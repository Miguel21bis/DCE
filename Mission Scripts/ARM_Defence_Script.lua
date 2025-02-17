--ARM Defence Script
--by Marc "MBot" Marbot
--Version 21.12.2014
--This script gives radars a chance to detect anti-radar missiles launched against them and to shut down for self-preservation
------------------------------------------------------------------------------------------------------- 
-- last modification:  M83_a
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/ARM_Defence_Script.lua"] = "2.4.8"
------------------------------------------------------------------------------------------------------- 
 
-- cleanCode_a	
-- modification M83_a	Jammer checkMissileProximity		 
-- Reglage_b			(b more difficult with Patriot&Sa10)(a: RadarOn 6 a 9mn)			
-- Debug_b 				(b getCategory)(a:AGM-154 :31:  'getDesc' Static doesn't exist)
------------------------------------------------------------------------------------------------------- 	




-- 🔹 Table globale des missiles en cours de suivi
local activeMissiles = {}

-- 🔹 Table des Jammers (actualisée à chaque tir de missile)
local jammers = {}

-- 🔹 Fonction de surveillance active
local function checkMissileProximity()
    if #activeMissiles == 0 then
        env.info("ARM_Jammer Fin de la surveillance des missiles (plus de missiles actifs)")
		trigger.action.outText(" Fin de la surveillance des missiles (plus de missiles actifs)",20)
        return
    end

    -- Vérification des distances missile ↔ jammer
    for i = #activeMissiles, 1, -1 do
        local missile = activeMissiles[i]

        -- ⚠️ Vérification stricte : si le missile n'existe plus, on le supprime
        if not missile or not missile:isExist() or not missile.getPoint then
            table.remove(activeMissiles, i)
        else
            local posMissile = missile:getPoint()
            
            for _, posJammer in ipairs(jammers) do
                local dx = posMissile.x - posJammer.x
                local dy = posMissile.y - posJammer.y
                local dz = posMissile.z - posJammer.z
                local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

                if distance < 40000 then
                    --  Explosion du missile avec protection contre le crash
                    if missile and missile:isExist() then
                        trigger.action.explosion(posMissile, 200)
                        missile:destroy()
                        env.info("ARM_Jammer Missile détruit proche du Jammer !")
						trigger.action.outText("Missile détruit proche du Jammer",20)
                    end
                    
                    -- Suppression du missile suivi
                    table.remove(activeMissiles, i)
                    break
                end
            end
        end
    end

    --  Relancer la vérification seulement s'il reste des missiles actifs
    if #activeMissiles > 0 then
        timer.scheduleFunction(checkMissileProximity, {}, timer.getTime() + 0.2)
    else
        env.info("ARM_Jammer Surveillance arrêtée (plus de missiles actifs)")
		trigger.action.outText(" Surveillance arrêtée (plus de missiles actifs)",20)
    end
end

local function checkMissileProximityOLD()
	if #activeMissiles == 0 then
		env.info("ARM_Jammer Fin de la surveillance des missiles (plus de missiles actifs)")
		trigger.action.outText("Fin de la surveillance des missiles (plus de missiles actifs)",20)
		return -- On arrête la boucle si plus de missiles
	end

	-- Vérification des distances missile ↔ jammer
	for i = #activeMissiles, 1, -1 do  -- On parcourt à l'envers pour pouvoir retirer des éléments
		local missile = activeMissiles[i]

		if not missile or not missile:isExist() then
			table.remove(activeMissiles, i) -- Suppression du missile disparu
		else
			local posMissile = missile:getPoint()

			for _, posJammer in ipairs(jammers) do
				local dx = posMissile.x - posJammer.x
				local dy = posMissile.y - posJammer.y
				local dz = posMissile.z - posJammer.z
				local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

				if distance < 40000 then
					--  Explosion du missile
					trigger.action.explosion(posMissile, 200)
					missile:destroy()
					env.info("ARM_Jammer Missile détruit proche du Jammer !")
					trigger.action.outText("Missile détruit proche du Jammer !",20)

					table.remove(activeMissiles, i) -- Suppression du missile explosé
					break -- On passe au missile suivant
				end
			end
		end
	end

	-- 🔄 Relancer la vérification seulement s'il reste des missiles actifs
	if #activeMissiles > 0 then
		timer.scheduleFunction(checkMissileProximity, {}, timer.getTime() + 0.2)
	else
		env.info("ARM_Jammer Surveillance arrêtée (plus de missiles actifs)")
		trigger.action.outText("Surveillance arrêtée (plus de missiles actifs)",20)
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

ARM_Shot_EventHandler = {}																					--Event handler to look for launched ARM
function ARM_Shot_EventHandler:onEvent(event)
	if event.id == world.event.S_EVENT_SHOT then
		local wep = event.weapon																			--Get the weapon of the launch event
		local tgt = wep:getTarget()																			--Get the target of the weapon
		
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

						-- _affiche(descRadarSam, "descRadarSam ArmDefence")

						SAM_AMM = {
							["Patriot str"] = true,
							["S-300PS 40B6M tr"] = true,
						}

						if math.random(1,10) > 1 then																--90% chance that ARM launch is detected by target
							local probaTurnOff = 75

							if descRadarSam and descRadarSam.typeName and SAM_AMM[descRadarSam.typeName] then
								probaTurnOff = 25
							end
							
							if math.random(1,100) <= probaTurnOff then
								-- trigger.action.outText("RadarOff", 3)	--DEBUG
								env.info("DCE_ARM_RadarOff")
								timer.scheduleFunction(RadarOff, {tgt, wep}, timer.getTime() + math.random(5, 15))		--Target reacts within 5 to 15 seconds after ARM launch with shutting down its radar
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
            env.info("ARM_Jammer Missile SAM détecté ! Suivi activé.")
			trigger.action.outText("Missile SAM détecté ! Suivi activé.",20)

            -- Ajout du missile dans la table des missiles actifs
            table.insert(activeMissiles, wep)

            -- Actualisation de la liste des jammers
            jammers = {}
            for _, sideNum in ipairs({coalition.side.BLUE, coalition.side.RED}) do
                local groups = coalition.getGroups(sideNum, Group.Category.AIRPLANE)
                for _, gp in pairs(groups) do
                    if string.find(Group.getName(gp), "Jammer") then
                        for _, unit in ipairs(gp:getUnits()) do
                            if unit and unit:isActive() and unit:inAir() then
                                table.insert(jammers, unit:getPoint())
                            end
                        end
                    end
                end
            end

            --  Démarrage de la surveillance si ce n'est pas déjà fait
            if #activeMissiles == 1 then
                env.info("ARM_Jammer Démarrage de la surveillance des missiles...")
				trigger.action.outText("Démarrage de la surveillance des missiles...",20)
                checkMissileProximity()
            end
        end

		-- if desc.missileCategory == 2 and (desc.guidance == 3 or desc.guidance == 4) then
		-- 	env.info("ARM_Jammer Missile SAM détecté ! Suivi activé.")
		-- 	trigger.action.outText("Missile SAM détecté ! Suivi activé.",20)

		-- 	-- Ajout du missile dans la table des missiles actifs
		-- 	table.insert(activeMissiles, wep)

		-- 	-- Actualisation de la liste des jammers
		-- 	jammers = {}
		-- 	for _, sideNum in ipairs({coalition.side.BLUE, coalition.side.RED}) do
		-- 		local groups = coalition.getGroups(sideNum, Group.Category.AIRPLANE)
		-- 		for _, gp in pairs(groups) do
		-- 			if string.find(Group.getName(gp), "Jammer") then
		-- 				for _, unit in ipairs(gp:getUnits()) do
		-- 					if unit and unit:isActive() and unit:inAir() then
		-- 						table.insert(jammers, unit:getPoint())
		-- 					end
		-- 				end
		-- 			end
		-- 		end
		-- 	end

		-- 	--  Démarrage de la surveillance si ce n'est pas déjà fait
		-- 	if #activeMissiles == 1 then
		-- 		env.info("ARM_Jammer Démarrage de la surveillance des missiles...")
		-- 		trigger.action.outText("Démarrage de la surveillance des missiles...",20)
		-- 		checkMissileProximity()
		-- 	end
		-- end



	end
end
world.addEventHandler(ARM_Shot_EventHandler)
