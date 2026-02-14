




-- local function removeMenuId(gid, id)

--     if not id then return end

--     missionCommands.removeItem(id)

--     local t = GroupRadioMenus[gid]
--     if not t then return end

--     for i = #t, 1, -1 do
--         if t[i] == id then
--             table.remove(t, i)
--             break
--         end
--     end
-- end



-- =================================================
-- === EWR TOGGLE
-- =================================================
--[[ 
function EWR_TOGGLE(playerName)

    if not playerName then return end

    env.info("DCE_EWR_TOGGLE Player "..playerName)

    if not EWR_optionPlayer[playerName] then
        EWR_optionPlayer[playerName] = { EWR_on = false }
    end


    -- toggle state
    local newState = not EWR_optionPlayer[playerName].EWR_on
    EWR_optionPlayer[playerName].EWR_on = newState

	local gid = PlayerGroup[playerName]
	if gid and GroupEWRMenus[gid] and GroupEWRMenus[gid].players[playerName] then
		GroupEWRMenus[gid].players[playerName].EWR_on = newState
	end


    env.info("DCE_EWR_TOGGLE Set "..playerName.." = "..tostring(newState))


    -- retrouver groupe
    gid = nil

    for gId, data in pairs(GroupEWRMenus) do
        if data.buttons[playerName] then
            gid = gId
            break
        end
    end

    if not gid then
        env.info("DCE_EWR_TOGGLE No gid found for "..playerName)
        return
    end


    rebuildEWR(gid)
end
 ]]

--[[ local function addFuncs(gId, gObj, pName)
	env.info("DCE_addFuncs _A gid " .. tostring(gId) .. " Group " .. tostring(gObj) .. " argPlayerName: " .. tostring(pName))

	trigger.action.outText("DCE_addFuncs gid " .. tostring(gId) .. " Group " .. tostring(gObj) .. " argPlayerName: " .. tostring(pName), 10)


	--si aucun argument, on s'appui sur la liste des joueurs fait maison
	if not gId or not gObj then
		env.info("DCE_addFuncs _A2 with No arg ")

		for playerName, playerData in pairs(PlayerInOutAircraft) do
			env.info("DCE_addFuncs  _A4 gid " .. tostring(playerData.gid) .. " Group " ..
			tostring(playerData.groupObject))
			if playerData.gid and playerData.groupObject then
				env.info("DCE_addFuncs  _A5  MAKE addFuncs() gid " ..
				tostring(playerData.gid) .. " Group " .. tostring(playerData.groupObject))
				addFuncs(playerData.gid, playerData.groupObject, playerName)
			end
		end
	end

	if gId and gObj then

		env.info("DCE_addFuncs _B  MAKE addFuncs() gid " .. tostring(gId) .. " Group " .. tostring(gObj) .. " argPlayerName: " .. tostring(pName))

		local firstBuild = false

		if not GroupMenusBuilt[gId] then
			GroupMenusBuilt[gId] = true
			firstBuild = true
			env.info("DCE_addFuncs _B2  First build for group " .. tostring(gId) .. " Group " .. tostring(gObj) .. " argPlayerName: " .. tostring(pName))
		end

		
		if not GroupMenusBuilt[gId] then
			GroupMenusBuilt[gId] = true
			env.info("DCE_addFuncs _B2  First build for group " .. tostring(gId) .. " Group " .. tostring(gObj) .. " argPlayerName: " .. tostring(pName))
		end

		env.info("DCE_addFuncs _B3  First build " .. tostring(firstBuild) .. " for group " .. tostring(gId) .. " Group " .. tostring(gObj) .. " argPlayerName: " .. tostring(pName))

		if firstBuild then

			env.info("DCE_addFuncs _C  Build F10 menu for group " .. tostring(gId) .. " Group " .. tostring(gObj) .. " argPlayerName: " .. tostring(pName))

			if GroupRadioMenus[gId] then
				for _, cmdId in ipairs(GroupRadioMenus[gId]) do
					missionCommands.removeItemForGroup(gId, cmdId)
				end
			end


			GroupRadioMenus[gId] = {}

			-- -- if not EWR_optionPlayer[pName] then--C-
			-- if pName and not EWR_optionPlayer[pName] then--C+
			-- 	EWR_optionPlayer[pName] = {
			-- 		EWR_on = false,
			-- 	}
			-- 	PlayerGroup[pName] = gId
			-- 	env.info("DCE_addFuncs _C3  Init EWR_optionPlayer for player " .. tostring(pName) .. " for group " .. tostring(gId) .. " Group " .. tostring(gObj) )
			-- end


			-- ajoute les nouvelles commandes F10 **************************************
			local id = missionCommands.addCommandForGroup( gId, "Fuel Check", nil, FuelCheck, { gid = gId, groupObject = gObj }	)
			table.insert(GroupRadioMenus[gId], id)

			local subR_A = missionCommands.addSubMenuForGroup(gId, "Urgent request", nil)
			table.insert(GroupRadioMenus[gId], subR_A)

			id = missionCommands.addCommandForGroup(gId, "Urgent_Refueling", subR_A, ReFueling, gObj)
			table.insert(GroupRadioMenus[gId], id)
			
			id = missionCommands.addCommandForGroup(gId, "Urgent_RequestCAP", subR_A, RequestCAP, gObj)
			table.insert(GroupRadioMenus[gId], id)
			
			id = missionCommands.addCommandForGroup(gId, "Package_All_RTB", subR_A, RtbPack, gObj)
			table.insert(GroupRadioMenus[gId], id)

			id = missionCommands.addCommandForGroup(gId, "Package_Strike_RTB", subR_A, RtbStrikePack, gObj)
			table.insert(GroupRadioMenus[gId], id)

			id = missionCommands.addCommandForGroup(gId, "Package_SEAD_RTB", subR_A, RtbSEADPack, gObj)
			table.insert(GroupRadioMenus[gId], id)

			id = missionCommands.addCommandForGroup(gId, "BullsEye_LongLat", nil, BullsEye, gObj)
			table.insert(GroupRadioMenus[gId], id)
			

			-- =================================================
			-- === EWR ROOT MENU (1 seule fois par groupe)
			-- =================================================

			-- === EWR ROOT ===

			if not GroupEWRMenus[gId] then

				env.info("DCE_EWR Init root for group "..gId)

				local root = missionCommands.addSubMenuForGroup(gId, "EWR", nil)

				GroupEWRMenus[gId] = {
					root = root,
					buttons = {}
				}
			end



			-- === EWR PLAYER REGISTER ===

			local ewr = GroupEWRMenus[gId]

			-- init table joueurs du groupe si absente
			if not ewr.players then
				ewr.players = {}
			end

			if pName and not ewr.players[pName] then


				env.info("DCE_EWR Register player "..pName.." in group "..gId)

				ewr.players[pName] = {
					EWR_on = false
				}

				PlayerGroup[pName] = gId

				rebuildEWR(gId)
			end



			
			local subR_C1 = missionCommands.addSubMenuForGroup(gId, "Get out of the cockpit", subR_A)
			table.insert(GroupRadioMenus[gId], subR_C1)


			if campL.SC_CarrierIntoWind == "man" then
				missionCommands.removeItemForGroup(gId, { "CarrierIntoWind" })
				local subR = missionCommands.addSubMenuForGroup(gId, "CarrierIntoWind", nil)

				if campL.Aircraft_Carriers then
					--TODO ajouter une condition side
					for sideCarrier, carriers in ipairs(campL.Aircraft_Carriers) do
						for group_n, carrier in ipairs(carriers) do
							local carrierGroup = Group.getByName(carrier.name)
							if carrierGroup then
								id = missionCommands.addCommandForGroup(gId, carrier.name .. " Into Wind 30mn", subR, TurnIntoWind, { carrier.name, nil, nil, 30 })
								table.insert(GroupRadioMenus[gId], id)
								id = missionCommands.addCommandForGroup(gId, carrier.name .. " Into Wind 60mn", subR, TurnIntoWind, { carrier.name, nil, nil, 60 })
								table.insert(GroupRadioMenus[gId], id)
								id = missionCommands.addCommandForGroup(gId, carrier.name .. " Resume Route", subR, ResumeRoute, { carrier.name, nil })
								table.insert(GroupRadioMenus[gId], id)
							end
						end
					end
				end
			end

			-- sar_F10(Group)
			timer.scheduleFunction(SAR_fct.menuF10_SAR, { gId, gObj }, timer.getTime() + 5)

			if campL.debug then
				local timeSearchEngage = timer.getTime()
				local logStr = "GroupRadioMenus = " .. TableSerialization(GroupRadioMenus, 0)
				local flightNameClean = "GroupRadioMenus"
				local logFile = io.open( PathDCE .. "Debug\\GroupRadioMenus_" .. timeSearchEngage .. "_.lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_addFuncs: Failed to open log file for writing.")
				end
			end

			env.info("DCE_addFuncs PASSE   FIN  ")
		end
	end
end

local function cleanEWR_list(initiator)

	env.info("DCE_cleanEWR_list _A  initiator " .. tostring(initiator))

    if not initiator then 
		env.info("DCE_cleanEWR_list _B  RETURN no initiator ")
		return 

		end

	local p
    local g

	if initiator and initiator.getPlayerName then
		p = initiator:getPlayerName()
		g = initiator:getGroup()
		env.info("DCE_cleanEWR_list _C  initiator player " .. tostring(p) .. " group " .. tostring(g))
	end


    if not p or not g then env.info("DCE_cleanEWR_list _return end") return end

    local gid = g:getID()

	if GroupEWRMenus[gid] then

		env.info("DCE_EWR Clean group "..gid)

		-- on vide juste les boutons
		local ewr = GroupEWRMenus[gid]

		for p,id in pairs(ewr.buttons) do
			if id then
				missionCommands.removeItemForGroup(gid, id)
			end
		end


		ewr.buttons = {}
	end


    -- =========================
    -- Nettoyage menus groupe
    -- =========================
    if GroupRadioMenus[gid] then

		for _, id in ipairs(GroupRadioMenus[gid]) do
			missionCommands.removeItemForGroup(gid, id)
			env.info("DCE_cleanEWR_list _D  Remove F10 menu cmdId " .. tostring(id) .. " for group " .. tostring(gid) )
		end

		env.info("DCE_cleanEWR_list _E  Clear GroupRadioMenus for group " .. tostring(gid) )

        GroupRadioMenus[gid] = nil
    end


	-- =========================
	-- Nettoyage EWR joueur
	-- =========================

	if GroupEWRMenus[gid] and GroupEWRMenus[gid].players then

		local ewr = GroupEWRMenus[gid]

		env.info("DCE_cleanEWR_list _F  Clean EWR player button for group " .. tostring(gid) )

		if ewr.players[p] then

			local data = ewr.players[p]

			env.info("DCE_cleanEWR_list _G  Remove EWR player button for player " .. tostring(p) .. " for group " .. tostring(gid) )

			if data.id then
				missionCommands.removeItemForGroup(gid, data.id)

				env.info("DCE_cleanEWR_list _G2  Remove EWR player button cmdId " .. tostring(data.id) .. " for player " .. tostring(p) .. " for group " .. tostring(gid) )
			end

			ewr.players[p] = nil
		end
	end



	-- Nettoyage joueur EWR dans le groupe
	if GroupEWRMenus[gid] and GroupEWRMenus[gid].players then
		GroupEWRMenus[gid].players[p] = nil
	end


	-- =========================
    -- 
    -- =========================
	GroupMenusBuilt[gid] = nil

	PlayerGroup[p] = nil

end

function rebuildEWR(gid)

    local ewr = GroupEWRMenus[gid]
    if not ewr then return end

    env.info("DCE_EWR_REBUILD Start for group "..gid)

    -- supprimer anciens boutons
	for p, id in pairs(ewr.buttons) do
		if id then
			missionCommands.removeItemForGroup(gid, id)
			env.info("DCE_EWR_REBUILD Remove EWR player button cmdId " .. tostring(id) .. " for player " .. tostring(p) .. " for group " .. tostring(gid) )
		end
	end


    ewr.buttons = {}


    -- recréer tous les boutons
    local ewr = GroupEWRMenus[gid]
	if not ewr or not ewr.players then return end

	for playerName, data in pairs(ewr.players) do


		if PlayerGroup[playerName] == gid then

			if data then

				local state = data.EWR_on

				local txt

				if state then
					txt = "ON  → "..playerName.." (Disable)"
				else
					txt = "OFF → "..playerName.." (Enable)"
				end

				local id = missionCommands.addCommandForGroup(
					gid,
					txt,
					ewr.root,
					EWR_TOGGLE,
					playerName
				)

				ewr.buttons[playerName] = id

				env.info("DCE_EWR_REBUILD Add "..txt.." id "..tostring(id))
			end
		end
	end

    env.info("DCE_EWR_REBUILD End for group "..gid)
end
 ]]


--[[




local useBubble_DisableEnable_Group = false
-- Distance seuil pour activation/désactivation (en mètres)
local ACTIVATION_DISTANCE = 45000
local SPAWN_DELAY = 0.06  -- Délai entre chaque création (en secondes)
-- CONFIG ------------------------------------------------
local FORCING_DISTANCE = 15000       -- distance en mètres pour déclencher (15 km)
local CHECK_INTERVAL = 15            -- intervalle de vérification en secondes
-- local FORCE_ON_COMBAT = false        -- si false : n'applique pas setTask() si le groupe est en combat
-- END CONFIG --------------------------------------------



--////////////////////////////////////////////////////////////////////////////////////////////
--test BULLE (debut) IV
--avec distance avion
--////////////////////////////////////////////////////////////////////////////////////////////


-- Fonction pour obtenir le heading correctement
local function getHeadingDCE(unit)
    local unitpos = unit:getPosition()
    local heading
    if unitpos then
        heading = math.atan2(unitpos.x.z, unitpos.x.x)
        if heading < 0 then
            heading = heading + 2 * math.pi
        end
    end
    return heading
end

local function tablelength(T)
	local count = 0
	for _ in pairs(T) do
	  count = count + 1
	end
	return count
  end

  -- Liste des groupes et objets statiques sauvegardés (désactivés temporairement)
local savedGroups = {}
local savedStatics = {}
local staticObjects = {}
-- Liste des groupes au sol et leurs états d'origine
local groundGroups = {} -- Stocke les groupes actifs



--/////////////////////////////////////// DCE_Bulle /////////////////////////////////////////////////////
local function DCE_BulleBy_DE()

	--  **Collecte des objets statiques au démarrage**
	local function collectStaticObjects()
		staticObjects = {}

		for _, coalTab in pairs({ coalition.side.RED, coalition.side.BLUE }) do
			local allStatics = coalition.getStaticObjects(coalTab)
			for _, static in ipairs(allStatics) do
				if static and static:isExist() then
					local staticName = static:getName()
					staticObjects[staticName] = {
						name = staticName,
						country = static:getCountry(),
						type = static:getTypeName(),
						x = static:getPoint().x,
						y = static:getPoint().z,
						heading = getHeadingDCE(static)
					}
				end
			end
		end

		local nombreElements = tablelength(staticObjects)

		-- if camp.debug then
		-- 	local current_time = timer.getTime()
		-- 	local logStr = "OrbitPosition = " .. TableSerialization(staticObjects, 0)
		-- 	local logFile = io.open(PathDCE.."Debug\\DCE_Bulle".."_".. "staticObjects"..current_time..".lua", "w")
		-- 	if logFile then
		-- 		logFile:write(logStr)
		-- 		logFile:close()
		-- 	else
		-- 		-- env.info("DCE_Bulle: Failed to open log file for writing.")
		-- 	end
		-- end
	end



	--  **Collecte des groupes dynamiques au sol avec exclusion**
	local function collectGroundGroups()
		groundGroups = {}
		local totalGroups = 0
		local validGroups = 0

		local function addGroupsFromCoalition(coalTab)
			-- Récupère uniquement les groupes dynamiques au sol
			local allGroups = coalition.getGroups(coalTab, Group.Category.GROUND)
			totalGroups = totalGroups + #allGroups

			for _, group in ipairs(allGroups) do
				if group and group:isExist() then
					local groupName = group:getName()
					local units = group:getUnits()
					local excludeGroup = false -- Flag pour exclure un groupe entier

					if #units > 0 then
						-- Vérifie si le groupe contient une unité interdite
						for _, unit in ipairs(units) do
							if excludedUnitTypes[unit:getTypeName()] then
								excludeGroup = true
								-- env.info("DCE_Bulle - Exclusion du groupe : " .. groupName .. " (contient " .. unit:getTypeName() .. ")")
								break
							end
						end

						if not excludeGroup then
							-- Récupère le pays depuis la première unité du groupe
							local firstUnit = units[1]
							local country = firstUnit and firstUnit:getCountry() or nil

							if country then
								-- Sauvegarde la structure du groupe pour le recréer plus tard
								local groupData = {
									name = groupName,
									country = country,
									units = {}
								}

								for _, unit in ipairs(units) do
									local posVec3 = unit:getPoint()
									table.insert(groupData.units, {
										name = unit:getName(),
										type = unit:getTypeName(),
										x = posVec3.x,
										y = posVec3.z,
										heading = math.deg(math.atan2(unit:getVelocity().z, unit:getVelocity().x))
									})
								end

								groundGroups[groupName] = groupData
								-- env.info("Added ground vehicle group: " .. groupName)
								validGroups = validGroups + 1
							else
								env.warning("Impossible de récupérer le pays pour " .. groupName)
							end
						end
					else
						-- env.info("Skipped group (no units): " .. groupName)
					end
				end
			end
		end

		-- Ajout des groupes des deux coalitions
		addGroupsFromCoalition(coalition.side.RED)
		addGroupsFromCoalition(coalition.side.BLUE)

		env.info("Total groups found: " .. tostring(totalGroups))
		env.info("Ground vehicle groups collected (après exclusion) : " .. tostring(validGroups))
	end


	--  **Récupérer tous les avions (joueurs et IA) en vol**
	local function getAllAircrafts()
		local aircrafts = {}

		for _, coalTab in pairs({ coalition.side.RED, coalition.side.BLUE }) do
			local airGroups = coalition.getGroups(coalTab, Group.Category.AIRPLANE) -- Récupère tous les groupes aériens
			for _, group in ipairs(airGroups) do
				if group and group:isExist() then
					for _, unit in ipairs(group:getUnits()) do
						if unit and unit:isExist() then
							table.insert(aircrafts, unit)
						end
					end
				end
			end
		end

		return aircrafts
	end


	--  **Désactiver un groupe ou un objet statique**
	local function disableGroup(groupData)
		if not groupData or not groupData.name then
			env.warning("DCE_Bulle Erreur : groupData invalide dans disableGroup")
			return
		end

		groupData["respawnTime"] = 0

		local group = Group.getByName(groupData.name)
		if group and group:isExist() then
			--  **Sauvegarde du groupe avant suppression**
			local unitsData = {}
			local foundCountry
			for _, unit in ipairs(group:getUnits()) do
				table.insert(unitsData, {
					name = unit:getName(),
					type = unit:getTypeName(),
					x = unit:getPoint().x,
					y = unit:getPoint().z,
					heading = getHeadingDCE(unit),
					skill = "Average",
					playerCanDrive = true,
				})
				foundCountry = unit:getCountry()
			end

			savedGroups[groupData.name] = {
				name = groupData.name,
				country = foundCountry,
				category = Group.Category.GROUND,
				units = unitsData,
				task = "Ground Nothing",
				visible = false,
				hidden = false,
				start_time = 0,
			}

			group:destroy()
			-- trigger.action.outText("Group " .. groupData.name .. " DISABLED", 2)
			-- env.info("DCE_Bulle Group " .. groupData.name .. " has been disabled (destroyed)")

		elseif staticObjects[groupData.name] then
			--  **Gestion des objets statiques**
			local staticData = staticObjects[groupData.name]
			savedStatics[groupData.name] = staticData
			local static = StaticObject.getByName(groupData.name)
			if static then
				static:destroy()
				-- trigger.action.outText("Static Object " .. groupData.name .. " DISABLED", 2)
				-- env.info("DCE_Bulle Static Object has been disabled (destroyed): " .. groupData.name )
			end
		else
			env.warning("DCE_Bulle Group/Static Object " .. groupData.name .. " does not exist or is already destroyed")
			-- trigger.action.outText("DCE_Bulle Group/Static Object ".. " does not exist or is already destroyed" .. groupData.name , 2)
		end
	end



	local spawnQueue = {}  -- File d’attente pour la création progressive (groupes + statiques)

	--  **Ajoute un élément (groupe ou statique) à la file d’attente**
	local function queueSpawn(elementData, isStatic)
		table.insert(spawnQueue, { data = elementData, isStatic = isStatic })
	end

	--  **Spawn progressif des groupes et objets statiques**
	local function processSpawnQueue()
		if #spawnQueue == 0 then
			-- env.info("DCE_Bulle -E1- Tous les groupes et statiques ont été créés.")
			return  -- Plus rien à créer
		end

		local spawnItem = table.remove(spawnQueue, 1)  -- Prend le premier élément de la file
		local elementData = spawnItem.data
		local isStatic = spawnItem.isStatic

		if isStatic then
			-- env.info("DCE_Bulle -E2- Création différée de l'objet statique : " .. elementData.name)
			local status, err = pcall(function()
				coalition.addStaticObject(elementData.country, {
					name = elementData.name,
					type = elementData.type,
					x = elementData.x,
					y = elementData.y,
					heading = elementData.heading
				})
			end)

			if not status then
				env.warning("DCE_Bulle -E3- Erreur lors de la création de l'objet statique " .. elementData.name .. " : " .. tostring(err))
			end
		else
			-- env.info("DCE_Bulle -E4- Création différée du groupe : " .. elementData.name)
			local status, err = pcall(function()
				coalition.addGroup(elementData.country, Group.Category.GROUND, elementData)
			end)

			if not status then
				env.warning("DCE_Bulle -E5- Erreur lors de la création du groupe " .. elementData.name .. " : " .. tostring(err))
			end
		end

		-- Planifie le spawn du prochain élément
		if #spawnQueue > 0 then
			timer.scheduleFunction(processSpawnQueue, nil, timer.getTime() + SPAWN_DELAY)
		else
			-- env.info("DCE_Bulle -E6- Tous les groupes et statiques ont été créés.")
		end

	end

	--  **Réactiver un groupe ou un objet statique (file d’attente au lieu de spawn direct)**
	local function enableGroup(groupData)

		if not groupData or not groupData.name then
			env.info("DCE_Bulle G1 - Erreur : groupData invalide dans enableGroup")
			return
		end

		groupData["respawnTime"] = timer.getTime()

		if savedGroups[groupData.name] then
			local groupInfo = savedGroups[groupData.name]

			local newGroup = {
				name = groupInfo.name,
				groupId = nil,
				country = groupInfo.country,
				category = Group.Category.GROUND,
				task = groupInfo.task or "Ground Nothing",
				start_time = 0,
				visible = false,
				hidden = false,
				units = {},
			}

			for _, unit in ipairs(groupInfo.units) do
				table.insert(newGroup.units, {
					name = unit.name,
					type = unit.type,
					x = unit.x,
					y = unit.y,
					heading = unit.heading,
					skill = unit.skill or "Average",
					playerCanDrive = unit.playerCanDrive or true,
					transportable = { randomTransportable = false },
				})
			end

			-- Ajoute le groupe dans la file d’attente pour un spawn différé
			queueSpawn(newGroup, false)
			savedGroups[groupData.name] = nil

			-- env.info("DCE_Bulle -G2- #spawnQueue " .. tostring(#spawnQueue))

			-- Démarre le traitement si ce n'est pas déjà fait
			if #spawnQueue == 1 then
				-- env.info("DCE_Bulle -G3- Début du spawn progressif")
				if #spawnQueue == 1 then
					-- env.info("DCE_Bulle -G3- Début du spawn progressif")
					timer.scheduleFunction(processSpawnQueue, nil, timer.getTime() + SPAWN_DELAY)
				end

			end

		elseif savedStatics[groupData.name] then
			-- env.info("DCE_Bulle -G4- Ajout à la file d'attente de l'objet statique : " .. groupData.name)
			local staticInfo = savedStatics[groupData.name]

			-- Ajoute le statique dans la file d’attente
			queueSpawn(staticInfo, true)
			savedStatics[groupData.name] = nil

			-- Démarre le traitement si ce n'est pas déjà fait
			if #spawnQueue == 1 then
				-- env.info("DCE_Bulle -G5- Début du spawn progressif des statiques")
				if #spawnQueue == 1 then
					-- env.info("DCE_Bulle -G6- Début du spawn progressif")
					timer.scheduleFunction(processSpawnQueue, nil, timer.getTime() + SPAWN_DELAY)
				end

			end
		else
			env.info("DCE_Bulle -G7- Le groupe/statique " .. groupData.name .. " n'était pas sauvegardé !")
		end
	end



	--  **Calculer la distance entre un point et l'avion le plus proche**
	local function getNearestAircraftDistance(targetX, targetY)
		local aircrafts = getAllAircrafts()
		local minDistance = math.huge -- Distance infinie par défaut

		for _, aircraft in ipairs(aircrafts) do
			local posVec3 = aircraft:getPoint()
			local dx = posVec3.x - targetX
			local dy = posVec3.z - targetY
			local distance = math.sqrt(dx * dx + dy * dy)

			if distance < minDistance then
				minDistance = distance
			end
		end

		return minDistance
	end

	--  **Vérifier et basculer les unités selon leur distance aux avions**
	local function updateUnitVisibility()
		-- env.info("DCE_Bulle -H1- Vérification des distances et basculement des unités...")

		local activationN = 0
		local deActivate = 0

		--  **Véhicules dynamiques**
		for groupName, groupData in pairs(groundGroups) do
			if groupData and groupData.units then
				local firstUnit = groupData.units[1] -- Prendre la première unité comme référence
				local distance = getNearestAircraftDistance(firstUnit.x, firstUnit.y)

				if distance < ACTIVATION_DISTANCE then
					if savedGroups[groupName] then
						-- env.info("DCE_Bulle -H2- Activation du groupe terrestre : " .. groupName)
						activationN = activationN+1
						enableGroup(groupData)
					end
				else
					if not groupData.respawnTime or (groupData.respawnTime < timer.getTime() + 900) then
						if not savedGroups[groupName] then
							-- env.info("DCE_Bulle -H3- Désactivation du groupe terrestre : " .. groupName)
							deActivate = deActivate + 1
							disableGroup(groupData)
						end
					end
				end
			end
		end

		--  **Objets statiques**
		for staticName, staticData in pairs(staticObjects) do
			local distance = getNearestAircraftDistance(staticData.x, staticData.y)

			if distance < ACTIVATION_DISTANCE then
				if savedStatics[staticName] then
					-- env.info("DCE_Bulle -H4- Activation de l'objet statique : " .. staticName)
					activationN = activationN+1
					enableGroup({ name = staticName }) -- Réactivation
				end
			else
				if not savedStatics[staticName] then
					-- env.info("DCE_Bulle -H5- Désactivation de l'objet statique : " .. staticName)
					deActivate = deActivate+1
					disableGroup({ name = staticName }) -- Désactivation
				end
			end
		end

		if activationN > 0 then
			env.info("DCE_Bulle -H6- Activation de N objet : " .. activationN)
			-- trigger.action.outText("DCE_Bulle - Activation de N objet : " .. activationN, 6)
		end
		if deActivate > 0 then
			env.info("DCE_Bulle -H7- Suppresion de N objet : " .. deActivate)
			-- trigger.action.outText("DCE_Bulle - Suppresion de N objet : " .. deActivate, 6)
		end


	end

	--  **Planification du check toutes les 30 secondes**
	local function scheduleUnitCheck()
		-- env.info("DCE_Bulle - Planification de la vérification des unités dans 30 secondes...")
		updateUnitVisibility()
		return timer.getTime() + 30
	end

	--  **Planification initiale après collecte des unités et statiques**
	timer.scheduleFunction(function()
		-- env.info("DCE_Bulle - Démarrage de la collecte des groupes au sol et statiques...")
		collectStaticObjects()
		collectGroundGroups()
		-- env.info("DCE_Bulle - Vérification et activation de la surveillance des unités...")
		timer.scheduleFunction(scheduleUnitCheck, nil, timer.getTime() + 5) -- Premier check après 5 sec
	end, nil, timer.getTime() + 10)

end


--////////////////////////////////////////////////////////////////////////////////////////////
--test BULLE (fin) IV
--avec distance avion
--////////////////////////////////////////////////////////////////////////////////////////////
 ]]
 
 --[[ 
-- Force la mission d'atterrissage (remplace la mission du groupe)
-- landingWp : table du waypoint d'atterrissage sauvegardée dans SatusGroupAircraft[flightName]["waypoints"]
local function forceLandingTowardsWaypoint(group, landingWp)
    if not group or not group:isExist() or not landingWp then return false end

    local leader = group:getUnit(1)
    if not leader or not leader:isExist() then return false end

    local curPos = leader:getPoint()

    -- Construire une mission simple : WP courant (Turning Point) -> WP atterrissage (Land)
    local mission = {
        id = 'Mission',
        params = {
            route = {
                points = {
                    [1] = {
                        action = "Turning Point",
                        type = "Turning Point",
                        x = curPos.x,
                        y = curPos.z,
                        alt = leader:getAltitude() or 500,
                        alt_type = "BARO",
						speed = landingWp.speed or 230,
                        ETA_locked = false,
                        task = { id = "ComboTask", params = { tasks = {} } },
                    },
                    [2] = nil -- on remplira ci-dessous selon landingWp
                }
            }
        }
    }

    -- Si landingWp contient un linkUnit (base/ship), on le réutilise pour avoir un "vrai" landing
    local landPoint = {
        action = "Landing",
        type = "Land",
        alt = landingWp.alt or 0,
        alt_type = landingWp.alt_type or "RADIO",
        speed = landingWp.speed or 230,
        x = landingWp.x,
        y = landingWp.y,
        ETA_locked = false,
        task = { id = "ComboTask", params = { tasks = {} } },
    }

    if landingWp.linkUnit then
        landPoint.linkUnit = landingWp.linkUnit
    end
    if landingWp.helipadId then
        landPoint.helipadId = landingWp.helipadId
    end

    mission.params.route.points[2] = landPoint

    -- Appliquer en remplaçant la mission : Controller.setTask
    local ctrl = group:getController()
    if ctrl then
        -- On utilise pcall pour éviter crash si API différente
        local ok, err = pcall(function()
            Controller.setTask(ctrl, mission)
        end)
        if not ok then
            env.info("DCE_forceLandingTowardsWaypoint: Controller.setTask failed: " .. tostring(err))
            return false
        end
        env.info("DCE_forceLandingTowardsWaypoint: mission d'atterrissage appliquée pour " .. tostring(group:getName()))
        return true
    end

    return false
end



-- Fonction principale : vérifier un groupe et forcer l'atterrissage si conditions remplies
local function checkAndForceLandingForGroup(flightName)
    if not flightName then return end
    local stat = SatusGroupAircraft[flightName]
    if not stat then return end

    -- si déjà forcé auparavant, rien à faire
    if stat["forcedLanding"] then
        return
    end

    local group = Group.getByName(flightName)
    if not group or not group:isExist() then return end

    -- si aucune route stockée -> rien
    local wps = stat["waypoints"]
    local landingIdx = stat["landingWpt"] or (#wps)
    if not wps or #wps == 0 or landingIdx < 1 or landingIdx > #wps then
        return
    end

    -- Vérifier si le vol a déjà passé le waypoint just before landing (landingWpt - 1)
    local thresholdWp = landingIdx - 1
    if thresholdWp < 1 then
        -- il n'y a pas de WP précédent : on peut traiter différemment ou ignorer
        thresholdWp = 1
    end

    -- On considère "passé" si currentWP > thresholdWp OR si le WP threshold a le flag passed
    local curIdx = stat["currentWP"] or 1
    local passedThreshold = false
    if stat["waypoints"][thresholdWp] and stat["waypoints"][thresholdWp]["passed"] then
        passedThreshold = true
    elseif curIdx and curIdx > thresholdWp then
        passedThreshold = true
    end

    if not passedThreshold then
        return
    end

    -- calcul distance au waypoint d'atterrissage
    local leader = group:getUnit(1)
    if not leader or not leader:isExist() then return end
    local pos = leader:getPoint()
    local landingWp = stat["waypoints"][landingIdx]
    if not landingWp or not landingWp.x or not landingWp.y then return end

    local landingPos = { x = landingWp.x, y = landingWp.y }
    local curPos = { x = pos.x, y = pos.z }  -- attention à l'axe y/z

    local dist = distance2D(curPos, landingPos)

    if dist <= FORCING_DISTANCE then
        -- détection combat (optionnel)
        -- local inCombat = groupIsInCombat(group)
        -- if inCombat and FORCE_ON_COMBAT == false then
        --     env.info(string.format("checkAndForceLandingForGroup: %s is in combat — skip forcing (dist=%.0f)", flightName, dist))
        --     return
        -- end

        -- forcer l'atterrissage et marquer
        local ok = forceLandingTowardsWaypoint(group, landingWp)
        if ok then
            SatusGroupAircraft[flightName]["forcedLanding"] = true
            env.info(string.format("checkAndForceLandingForGroup: forced landing for %s (dist=%.0f)", flightName, dist))
        end
    end
end

-- Wrapper scheduler pour surveiller tous les groupes enregistrés
local function monitorAllGroups(_, t)
    -- parcours des groupes connus
    for flightName, _ in pairs(SatusGroupAircraft) do
        -- ne pas bloquer si table malformée
        if flightName and SatusGroupAircraft[flightName] then
            pcall(checkAndForceLandingForGroup, flightName)
        end
    end
    return t + CHECK_INTERVAL
end

-- Démarrer le scheduler (une fois dans ton init ou event birth)
timer.scheduleFunction(monitorAllGroups, nil, timer.getTime() + 1) ]]




-- EventHandler2 = {} 
-- function EventHandler2:onEvent(event)

	-- if eventsSurvey2[event.id] then

		-- local idLabel = "inc"
		-- local current_time = timer.getTime()

		-- if event and event.id and Info_event and Info_event[tonumber(event.id)] then
			-- idLabel = tostring(Info_event[tonumber(event.id)])
		-- end

        -- if event.id == world.event.S_EVENT_BIRTH and event.initiator then
            -- local obj_Category = Object.getCategory(event.initiator)

            -- -- on ignore les statics
            -- if obj_Category ~= Object.Category.STATIC then
                -- if event.initiator.getID then
                    -- local unitId = event.initiator:getID()

                    -- if unitId then
                        -- -- init cache
                        -- if not Cache_UnitCategoryByGetID[unitId] then
                            -- Cache_UnitCategoryByGetID[unitId] = {}
                        -- end

                        -- local desc = event.initiator:getDesc()
                        -- if desc and desc.category ~= nil then
                            -- Cache_UnitCategoryByGetID[unitId].category = desc.category
                        -- end
                    -- end
                -- end

                -- if event.initiator.getPlayerName and event.initiator.getGroup then
                    -- local playerName = event.initiator:getPlayerName()
                    -- local groupObject = event.initiator:getGroup()

                    -- -- env.info("DCE_EventHandler2 B playerName." .. tostring(playerName))

                    -- if groupObject and groupObject.getID then
                        -- local gpGid = groupObject:getID()
                        -- local flightName = event.initiator:getName()
                        -- local groupName = groupObject:getName()

                        -- if playerName then
                            -- env.info("DCE_EventHandler2 C0. playerName " ..
                                -- tostring(playerName) ..
                                -- " gpGid." .. tostring(gpGid) .. " groupObject." .. tostring(groupObject))

                            -- if gpGid and groupObject then
                                -- env.info("DCE_EventHandler2 C1 playerName S_EVENT_BIRTH. MAKE addFuncs() ")
                                -- addFuncs(gpGid, groupObject, playerName)

                                -- local desc = event.initiator:getDesc()
                                -- env.info("DCE_EventHandler2 C2. desc" .. tostring(desc))
                                -- if desc.category == Unit.Category.HELICOPTER then
                                    -- timer.scheduleFunction(MonitorPlayerAircraftActivity,
                                        -- { "in", playerName, flightName, desc.category, groupObject }, current_time + 1)
                                -- end
                            -- end
                        -- else
                            -- if gpGid and groupObject then
                                -- if not SatusGroupAircraft[groupName] then
                                    -- SatusGroupAircraft[groupName] = {
                                        -- ["spawn"] = false,
                                        -- ["takeoff"] = false,
                                        -- ["landing"] = false,
                                        -- ["task"] = "",
                                        -- ["waypoints"] = {}, -- suivi des waypoints
                                    -- }
                                -- end

                                -- local passEscort = false

                                -- if string.find(string.lower(groupName), "escort") then
                                    -- passEscort = true


                                    -- -- --TODO a supprimer une fois les tests finitos
                                    -- -- if campL.debug then
                                    -- --     EWR_ON(flightName)
                                    -- -- end
                                -- end

                                -- if groupObject and passEscort then
                                    -- -- local route = DCE_GetRoute(flightName, sideName)
                                    -- -- local route = DCE_GetRoute(groupName)
                                    -- local route = DCE_GetRoute(groupName)

                                    -- -- env.info("DCE_Perf Perf_Tot " .. tostring(Perf_Tot))

                                    -- if route and #route > 0 then
                                        -- SatusGroupAircraft[groupName]["waypoints"] = route
                                        -- SatusGroupAircraft[groupName]["task"] = "escort"
                                    -- end
                                -- end
                            -- end
                        -- end
                    -- end
                -- end



                -- if event.initiator then
                    -- local unit = event.initiator
                    -- if unit and unit.getPlayerName and unit:getPlayerName() then
                        -- local name = unit:getPlayerName()
                        -- local uName = unit:getName()
                        -- env.info("DCE_EventHandler2 D Joueur détecté: " .. name .. " (unité: " .. uName .. ")")
                        -- Players[uName] = name
                    -- end
                -- end
            -- end
        -- elseif not event.place then
            -- if event.subPlace then
                -- if event.initiator and event.initiator.getPlayerName then
                    -- local playerName = event.initiator:getPlayerName()
                    -- local groupObject = event.initiator:getGroup()

                    -- if groupObject and groupObject.getID then
                        -- local gpGid = groupObject:getID() --1300: attempt to index a nil value
                        -- if gpGid and groupObject and playerName then
                            -- env.info("DCE_EventHandler2 E playerName event.subPlace MAKE addFuncs()")
                            -- addFuncs(gpGid, groupObject, playerName)
                        -- end
                    -- end
                -- end
            -- elseif event.id == world.event.S_EVENT_LAND or event.id == world.event.S_EVENT_CRASH or event.id == world.event.S_EVENT_DETAILED_FAILURE or event.id == world.event.S_EVENT_AI_ABORT_MISSION
                -- or event.id == world.event.S_EVENT_EMERGENCY_LANDING then
                -- if event.initiator and not event.initiator.getPlayerName then
                    -- local eventVec3 = event.initiator:getPoint()
                    -- local wreckVec3
                    -- if eventVec3 and eventVec3.x then
                        -- wreckVec3 = {
                            -- x = eventVec3.x,
                            -- y = land.getHeight({ x = eventVec3.x, y = eventVec3.z }),
                            -- z = eventVec3.z,
                        -- }
                        -- env.info("DCE_GroundDamagedFlyingMachine F1 wreckVec3 alti " .. tostring(wreckVec3.y))
                    -- end

                    -- if wreckVec3.y <= 100 then
                        -- env.info("DCE_GroundDamagedFlyingMachine G getPlayerName detected ? ")

                        -- local name = event.initiator:getName()
                        -- local life = event.initiator:getLife()
                        -- local init_life = event.initiator:getLife0()
                        -- local lifePourcent = 100
                        -- -- local isPlayer = false
                        -- if init_life then
                            -- lifePourcent = life / init_life * 100
                        -- end

                        -- env.info("DCE_GroundDamagedFlyingMachine H2 init_life " ..
                            -- tostring(init_life) .. " life: " .. tostring(life))
                        -- env.info("DCE_GroundDamagedFlyingMachine H3 event.initiator.id_ " ..
                            -- tostring(event.initiator.id_))



                        -- if lifePourcent < 100 and lifePourcent >= 1 then
                            -- env.info("DCE_GroundDamagedFlyingMachine I detected ? event.initiator.id_ " ..
                                -- tostring(event.initiator.id_))

                            -- local crashVec3 = event.initiator:getPoint()
                            -- local typeLand = land.getSurfaceType({ x = crashVec3.x, y = crashVec3.z })

                            -- --TODO ajouter une proximité Base & Farp pour ne pas le faire dessus
                            -- if typeLand == land.SurfaceType.WATER and typeLand == land.SurfaceType.RUNWAY then
                                -- local Group = event.initiator:getGroup()
                                -- local gpGid = Group:getID()
                                -- local categoryId = event.initiator:getDesc().category

                                -- local countryId = event.initiator:getCountry()
                                -- local countryName = string.lower(country.name[countryId])
                                -- local coalitionId = event.initiator:getCoalition()
                                -- local sideName = CoalitionIdToName[tonumber(coalitionId)]

                                -- local eventData = {
                                    -- name = name,
                                    -- SurfaceType = typeLand,
                                    -- aircraftType = event.initiator:getTypeName(),
                                    -- lifePourcent = lifePourcent,
                                    -- crashPointVec3 = crashVec3,
                                    -- unit = event.initiator,
                                    -- gpGid = gpGid,
                                    -- idLabel = idLabel,
                                    -- categoryId = categoryId,
                                    -- coalitionId = coalitionId,
                                    -- initiatorMissionID = event.initiator:getID(),
                                    -- countryId = countryId,
                                    -- countryName = countryName,
                                    -- sideName = sideName,
                                    -- initiator_id_ = event.initiator.id_,
                                -- }

                                -- if not GroundDamagedFlyingMachine[event.initiator.id_] then GroundDamagedFlyingMachine[event.initiator.id_] = {} end
                                -- table.insert(GroundDamagedFlyingMachine[event.initiator.id_], eventData)

                                -- if campL.debug then
                                    -- local logStr = "DamagedFM = " .. TableSerialization(GroundDamagedFlyingMachine, 0)
                                    -- local grpnameClean = name:gsub('[%p%c%s]', '_')
                                    -- local logFile = io.open(
                                        -- PathDCE ..
                                        -- "Debug\\" ..
                                        -- event.initiator.id_ .. "_" .. grpnameClean ..
                                        -- "_" .. "DamagedFM_" .. current_time .. ".lua", "w")
                                    -- if logFile then
                                        -- logFile:write(logStr)
                                        -- logFile:close()
                                    -- else
                                        -- env.info("DCE_GroundDamagedFlyingMachine: Failed to open log file for writing.")
                                    -- end
                                -- end
                            -- end
                        -- end
                    -- end
                -- end
            -- end
        -- elseif event.id == world.event.S_EVENT_DEAD or event.id == world.event.S_EVENT_PILOT_DEAD or event.id == world.event.S_EVENT_KILL then
            
			-- if event.initiator then
				-- cleanEWR_list(event.initiator)
			-- end
			
			-- local playerName = event.initiator:getPlayerName()
            -- if playerName then
                -- local desc = event.initiator:getDesc()
                -- if desc.category == Unit.Category.HELICOPTER then
                    -- local aircraftName = event.initiator:getName()
                    -- timer.scheduleFunction(MonitorPlayerAircraftActivity,
                        -- { "out", playerName, aircraftName, desc.category }, current_time + 1)
                -- end
            -- end

            -- --TODO controler si c'est utile
            -- if event.initiator and event.initiator.id_ then
                -- for n, damageds in pairs(GroundDamagedFlyingMachine) do
                    -- local toRemove = {} -- Table pour stocker les clés à supprimer

                    -- for initiatorId, damaged in pairs(damageds) do
                        -- env.info("DCE_GroundDamagedFlyingMachine S_EVENT_KILL n: " ..
                            -- n .. " initiatorId: " .. tostring(initiatorId))

                        -- if initiatorId == event.initiator.id_ then
                            -- env.info("DCE_GroundDamagedFlyingMachine S_EVENT_KILL delete initiatorId: " ..
                                -- tostring(initiatorId))
                            -- table.insert(toRemove, initiatorId)
                        -- end
                    -- end

                    -- -- Supprimer les entrées après avoir parcouru la table
                    -- for _, initiatorId in ipairs(toRemove) do
                        -- damageds[initiatorId] = nil
                    -- end
                -- end
            -- end
        -- end
		
		-- if event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT and event.initiator then
			-- cleanEWR_list(event.initiator)
		-- end
		
	-- end
-- end





