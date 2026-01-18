--ARM Defence Script
--by Marc "MBot" Marbot
--Version 21.12.2014
--This script gives radars a chance to detect anti-radar missiles launched against them and to shut down for self-preservation
------------------------------------------------------------------------------------------------------- 
-- last modification:  M83_c
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/ARM_Defence_Script.lua"] = "3.5.11"
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
	local grp = arg[1]:getGroup()																			--Get group of attached unit (radar can only be turned off for whole group)
	if grp ~= nil then
		local ctrl = grp:getController()																	--Get controller of group
		ctrl:setOption(AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.GREEN)				--Turn off radar
		--trigger.action.outText("Radar Off", 3)	--DEBUG
		-- timer.scheduleFunction(RadarOn, ctrl, timer.getTime() + math.random(120, 240))						--Schedule turning radar back on in 2 to 4 minutes
		timer.scheduleFunction(RadarOn, ctrl, timer.getTime() + math.random(360, 540))						--Schedule turning radar back on in 6 to 9 minutes
	end
end


SAM_AMM = {
	["Patriot str"] = true,
	["S-300PS 40B6M tr"] = true,
}

OLD_SAM_Radar = {
    ["SNR_75V"] = true,
	["snr s-125 tr"] = true,
}

local timingRadarOff = {5,15 }

ARM_Shot_EventHandler = {}																					--Event handler to look for launched ARM
function ARM_Shot_EventHandler:onEvent(event)
	if event.id == world.event.S_EVENT_SHOT then
		local wep = event.weapon																			--Get the weapon of the launch event
		local tgt = wep:getTarget()																			--Get the target of the weapon
		local addTime = 0
		if not wep or not wep.getDesc then return end

		-- if event.initiator and Object.getCategory(event.initiator) == Object.Category.UNIT  then										--initiator is a unit debug_ET01.h
		-- 	env.info("DCE_ARM_S_EVENT A SHOT getPlayerName "..tostring( event.initiator:getPlayerName()))
		-- end

		-- env.info("DCE_ARM_S_EVENT    B SHOT tgt "..tostring(tgt))
		if tgt and tgt:isExist() then

			local desc = wep:getDesc()
			env.info("DCE_ARM_S_EVENT       C ")
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

			if desc.missileCategory == 6 and desc.guidance == 5 then										--Check if the weapon is an ARM
				-- env.info("DCE_ARM_S_EVENT          D ")

				-- Object.Category
				-- UNIT    1
				-- WEAPON  2
				-- STATIC  3
				-- BASE    4
				-- SCENERY 5
				-- Cargo   6

				local objCat = Object.getCategory(tgt)

				if objCat ~= Object.Category.SCENERY then														--target is not a scenery object
					env.info("DCE_ARM_S_EVENT          E Object_Category: "..tostring(Object_Category[objCat]))

					local unitCat = tgt:getDesc().category
					env.info("DCE_ARM_S_EVENT          E unitCat: "..tostring(unitCat))
					if unitCat ~= 3 then															--target is not a ship	-- bug AGM-154 :31: in function 'getDesc' Static doesn't exist
						-- trigger.action.outText("ARM Launch", 3)	--DEBUG
						-- env.info("DCE_ARM_               F Launch")

						local descRadarSam = tgt:getDesc()

						_affiche(descRadarSam, "descRadarSam ArmDefence")



						if math.random(1,10) > 1 then																--90% chance that ARM launch is detected by target
							local probaTurnOff = 75

							if descRadarSam and descRadarSam.typeName and SAM_AMM[descRadarSam.typeName] then
								probaTurnOff = 25
							end

							if math.random(1,100) <= probaTurnOff then
								-- trigger.action.outText("RadarOff", 3)	--DEBUG
								env.info("DCE_ARM_RadarOff")
								
                                if OLD_SAM_Radar[descRadarSam.typeName] then
									addTime = 60
									env.info("DCE_ARM_Defence OLD_SAM_Radar detected addTime: " .. tostring(addTime))
								end
								
								timer.scheduleFunction(RadarOff, {tgt, wep}, timer.getTime() + math.random(timingRadarOff[1], timingRadarOff[2]) + addTime)		--Target reacts within 5 to 15 seconds after ARM launch with shutting down its radar
							end

						end
					end
				end

				-- if tgt:getDesc().category ~= 3 then															--target is not a ship	-- bug AGM-154 :31: in function 'getDesc' Static doesn't exist
				-- local desc = wep:getDesc()
					-- if desc.missileCategory == 6 and desc.guidance == 5 then										--Check if the weapon is an ARM
						-- --trigger.action.outText("ARM Launch", 3)	--DEBUG
						-- if math.random(1,10) > 1 then																--90% chance that ARM launch is detected by target
							-- timer.scheduleFunction(RadarOff, {tgt, wep}, timer.getTime() + math.random(5, 15))		--Target reacts within 5 to 15 seconds after ARM launch with shutting down its radar
						-- end
					-- end
				-- end


			end
		end



		local desc = wep:getDesc()
		if desc.missileCategory == 2 and (desc.guidance == 3 or desc.guidance == 4) then
            
			-- Ajout du missile dans la table des missiles actifs
            table.insert(activeMissiles, wep)

			-- Utilisation du cache de jammers (optimisé)
			jammers = cachedJammers

          --[[   -- Actualisation de la liste des jammers
            jammers = {}
			-- local jammerDist_RealJammer = 10000
			-- local jammerDist_B52 = 1000

			for _, sideNum in ipairs({coalition.side.BLUE, coalition.side.RED}) do
                local groups = coalition.getGroups(sideNum, Group.Category.AIRPLANE)
                for _, gp in pairs(groups) do
                    local gpName = Group.getName(gp)  -- Protection pour éviter un crash si `gpName` est nil
                    -- if gpName and string.find(gpName, "Jammer") then
                    --     for _, unit in ipairs(gp:getUnits()) do
                    --         if unit and unit:isActive() and unit:inAir() then
                    --             local entry = {
                    --                 unit = unit,
                    --                 dist = jammerDist_RealJammer,
                    --             }
                    --             table.insert(jammers, entry)
                    --         end
                    --     end
					-- elseif gpName then
                    if gpName then
                        for _, unit in ipairs(gp:getUnits()) do
                            if unit and unit:isActive() and unit:inAir() then
								local typeName = unit:getTypeName()

								-- env.info("ARM_Jammer B typeName: "..tostring(typeName))

								if campL.jammerOnBoard and campL.jammerOnBoard[typeName] then
									local entry = {
										unit = unit,
										range = campL.jammerOnBoard[typeName].range,
										efficiency = campL.jammerOnBoard[typeName].efficiency,
									}
									table.insert(jammers, entry)
									-- env.info("ARM_Jammer C table.insert(jammers ")
								end

								-- if typeName == "B-52H" or typeName == "VSN_F105G" or typeName == "vwv_ra-5" then
								-- 	local entry = {
								-- 		unit = unit,
								-- 		dist = jammerDist_B52,
								-- 	}
								-- 	table.insert(jammers, entry)
								-- end
                            end
                        end
                    end
                end
            end ]]

            -- Démarrage de la surveillance si ce n'est pas déjà fait
            if #activeMissiles == 1 then
                env.info("ARM_Jammer Démarrage de la surveillance des missiles...")
				-- trigger.action.outText("ARM_Jammer Démarrage de la surveillance des missiles.",20)
                checkMissileProximity()
            end
        end

	end
end
world.addEventHandler(ARM_Shot_EventHandler)

-- Initialisation du cache des jammers
updateJammers()

env.info("DCE_ARM END OF LOADING ARM_Defence_Script ")
