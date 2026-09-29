-- Adds functions in radio menu F10
--Script attached to mission and executed via trigger
--Functions accessed via LUA Run Script
-- Renomme depuis AddCommandRadioF10.lua (reorganisation DCE InGame)
-------------------------------------------------------------------------------------------------------

if not campL.debugInGamePopup then
	env.setErrorMessageBoxEnabled(false)
end

env.info("DCE_ACRF10 version of Lua _VERSION " .. tostring(_VERSION))
env.info("DCE_ACRF10 START LOADING DCE_RadioF10.lua")


local fuelCacheCooldown = 5 -- secondes entre deux lectures DCS par avion

TypePedroByCV = campL.TypePedroByCV or {} --table used to store the type of Pedro by CV

local radioCommands = {}
local tabJockerPlane = {}
local var_TPN_alreadyAdded = false
-- Liste des unités à exclure
local excludedUnitTypes = {
	["FPS-117"] = true,
	["55G6 EWR"] = true,
	["1L13 EWR"] = true,
	["FPS-117 Dome"] = true,
	["TACAN_beacon"] = true,
}


-----*********check path**************---------
env.info("DCE_Bat_Path  " .. tostring(campL.path))

PathDD = "c:"
--prepare campaign path
PathDCE = string.gsub(campL.path, "/", "\\")           --replace slashes in campaign path with double-backslashes
if string.sub(campL.path, 2, 2) ~= ":" then            --si le chemin est differen de C:\Users ou D:\Users
	PathDCE = os.getenv('USERPROFILE') ..
	"\\" .. PathDCE                                    --get path of windows userprofile and add to campaign path
else
	PathDD = string.sub(campL.path, 1, 2)
end

PathDCE = PathDCE .. "Mods\\tech\\DCE\\Missions\\Campaigns\\" .. campL.title .. "\\"
env.info("DCE_PathDCE " .. tostring(PathDCE))
env.info("DCE_PathDD " .. tostring(PathDD))
-----*********check PathDCE**************---------



--response time of the interlocutor, so that the answer is not immediate like a computer
function ResponseTimeForU(arg)
	local Uid = arg[1]
	local txt = arg[2]

	trigger.action.outTextForUnit(Uid, txt, 10)
end

function ResponseTimeForGp(arg)
	local gpGid = arg[1]
	local txt = arg[2]

	trigger.action.outTextForGroup(gpGid, txt, 10)
end

--proxyBase
function ProxyBase(selectedEjection)
	if not RunwayLife then
		env.info("DCE_Bug ProxyBase: RunwayLife est nil, abandon")
		return nil, nil
	end
	local distanceBase = nil
	local baseName = nil
	for Id, base in pairs(RunwayLife) do
		if base.pointVec3 and base.pointVec3.x and base.pointVec3.z and selectedEjection.pos then
			local dx = base.pointVec3.x - selectedEjection.pos.vec3x
			local dz = base.pointVec3.z - selectedEjection.pos.vec3z
			local tempDistance = math.sqrt(dx * dx + dz * dz)
			if not distanceBase or tempDistance < distanceBase then
				distanceBase = tempDistance
				baseName = base.name
			end
		else
			env.info("DCE_EvenT: pilotLand_C G baseName " .. tostring(baseName) ..
			" distanceBase " .. tostring(distanceBase))
		end
	end
	return distanceBase, baseName
end

--function to return a new point offset from an initial point
-- heading en degré compas (0° = nord géographique, sens horaire) ; x = nord, y = est
function GetOffsetPoint(point, heading, distance)
	return {
		x = point.x + math.cos(math.rad(heading)) * distance,
		y = point.y + math.sin(math.rad(heading)) * distance
	}
end


--*************** BLUILD TAB INIT *********************
--*************** BLUILD TAB INIT *********************

-- Parse env.mission UNE seule fois et construit tous les index nécessaires
-- Pourquoi : éviter 3 parcours complets très coûteux de env.mission
local function buildMissionIndex()
	local t0 = timer.getTime()

	if not env or not env.mission or not env.mission.coalition then
		return
	end

	for _, coalition in pairs(env.mission.coalition) do
		if coalition.country then
			for _, country in pairs(coalition.country) do
				-- ========= AVIONS =========
				if country.plane and country.plane.group then
					for _, group in pairs(country.plane.group) do
						-- index par nom
						if group.name then
							MissGroupByName[group.name] = group
						end

						-- routes
						if group.route and group.route.points then
							local data = {
								orbitCAP = {
									altitude = 0,
									speed = 0
								}
							}
							data.base = group.route.points[#group.route.points]
							data.to = 0
							data.from = 0

							for i, p in ipairs(group.route.points) do
								if p.name == "Station" then
									data.to = i
									data.from = i - 1
								end

								if p.task and p.task.params and p.task.params.tasks then
									for _, t in ipairs(p.task.params.tasks) do
										local task = nil
										if t.params then
											if t.params.task then
												task = t.params.task
											elseif t.params.action then
												task = t.params.action
											end
										end

										if task and task.id == "EngageTargetsInZone" then
											data.station1 = group.route.points[i]
											data.station2 = group.route.points[i + 1]
										end
										if task and task.id == "Orbit" and task.params then
											data.orbitCAP.altitude = task.params.altitude
											data.orbitCAP.speed = task.params.speed
										end
									end
								end
							end

							DCE_groupRouteCache[group.groupId] = data
						end
					end
				end
				-- ========= HELICOPTERES =========
				if country.helicopter and country.helicopter.group then
					for _, group in pairs(country.helicopter.group) do
						-- index par nom
						if group.name then
							MissGroupByName[group.name] = group
						end

						-- routes
						if group.route and group.route.points then
							local data = {}
							data.base = group.route.points[#group.route.points]

							for i, p in ipairs(group.route.points) do
								if p.name == "Station" then
									data.station1 = group.route.points[i]
									data.station2 = group.route.points[i + 1]
								end

								if p.task and p.task.params and p.task.params.tasks then
									for _, t in ipairs(p.task.params.tasks) do
										local task = nil
										if t.params then
											if t.params.task then
												task = t.params.task
											elseif t.params.action then
												task = t.params.action
											end
										end

										if task and task.id == "Orbit" and task.params then
											data.orbitAlt = task.params.altitude
											data.orbitSpeed = task.params.speed
										end
									end
								end
							end

							DCE_groupRouteCache[group.groupId] = data
						end
					end
				end

				-- ========= SHIPS / CARRIERS =========
				if country.ship and country.ship.group then
					for _, group in pairs(country.ship.group) do
						if group.units then
							for _, unit in pairs(group.units) do
								if unit.type then
									local desc = Unit.getDescByName(unit.type)

									if desc and desc.attributes and desc.attributes["Aircraft Carriers"] then
										DCE_carriers[#DCE_carriers + 1] = {
											name = unit.name,
											groupName = group.name
										}
									end
								end
							end
						end
					end
				end
			end
		end
	end

	local planeCount = 0
	for _ in pairs(MissGroupByName) do
		planeCount = planeCount + 1
	end

	env.info("DCE buildMissionIndex: planes=" ..
		tostring(planeCount) ..
		" carriers=" .. tostring(#DCE_carriers) ..
		" in " .. string.format("%.3f", timer.getTime() - t0) .. "s")
end





--*************** BLUILD TAB INIT *********************
--*************** BLUILD TAB INIT *********************


-- MGRS Rescue Zones (simplified)
--
-- Each MGRS square is divided into four rescue zones:
--
--        North
--      [3] | [4]
--      -----------
--      [1] | [2]
--        South
--
-- Zone 1 = South-West
-- Zone 2 = South-East
-- Zone 3 = North-West
-- Zone 4 = North-East
--
-- When a downed pilot reports "Zone 3", go to the north-west quarter
-- of the specified MGRS grid (e.g. 35W NR).
function Add_MGRS_Chute(pilot)
	local grid    = coord.LLtoMGRS(coord.LOtoLL(pilot))

	-- Extract first digit of Easting & Northing (10 km subdivision)
	local E       = tonumber(string.sub(grid.Easting, 1, 1))
	local N       = tonumber(string.sub(grid.Northing, 1, 1))

	-- Determine direction
	local isEast  = (E >= 5)
	local isNorth = (N >= 5)

	-- New zone numbering (requested layout):
	--        North
	--      3 | 4
	--      ------
	--      1 | 2
	--        South
	local zoneNumber

	if not isEast and not isNorth then
		zoneNumber = 1 -- South-West
	elseif isEast and not isNorth then
		zoneNumber = 2 -- South-East
	elseif not isEast and isNorth then
		zoneNumber = 3 -- North-West
	else
		zoneNumber = 4 -- North-East
	end

	-- Construct final strings
	pilot.MGRS_Chute = grid.UTMZone .. "_" .. grid.MGRSDigraph .. "_Zone_" .. zoneNumber

	pilot.MGRS_Chute_10KM = grid.UTMZone .. "_" .. grid.MGRSDigraph .. "_" .. E .. "_" .. N

	return pilot
end

local function localGetPlayerObj()
	local playerObj = nil
	for coalitionID = 1, 2 do
		local pUnits = coalition.getPlayers(coalitionID)

		for unitN, unit in ipairs(pUnits) do
			if unit and unit:getPlayerName() then
				playerObj = unit
				break
			end
		end
		if playerObj then
			break
		end
	end
	return playerObj
end

local function setErrorMessageBoxShedul()
	if not campL.debugInGamePopup then
		env.setErrorMessageBoxEnabled(false)
	end
end

local function getGroupById(groupId)
	for coalitionId = 1, 2 do -- 1 = Red, 2 = Blue
		local groups = coalition.getGroups(coalitionId)
		for _, group in ipairs(groups) do
			if group:getID() == groupId then
				return group
			end
		end
	end
	return nil -- Groupe introuvable
end


-- construit l’index
function BuildCarrierIndex()
	CarrierIndex = {}

	for _, coal in ipairs({ coalition.side.BLUE, coalition.side.RED }) do
		local groups = coalition.getGroups(coal, Group.Category.SHIP)
		if groups then
			for _, group in ipairs(groups) do
				local units = group:getUnits()
				if units then
					for _, unit in ipairs(units) do
						if unit and unit.isExist and unit:isExist() then
							local desc = unit:getDesc()
							if desc and desc.category == Object.Category.SHIP then
								local id = unit:getID()
								if id then
									CarrierIndex[id] = unit
								end
							end
						end
					end
				end
			end
		end
	end
end

-- retourne la position d’un CV/CVN depuis son unitId ou son nom
-- mesure le temps CPU cumulé consommé par cette fonction
local function getCarrierPosition(linkUnit)
	if not linkUnit then
		return nil
	end

	-- 1) cas normal : ID
	if type(linkUnit) == "number" then
		local u = CarrierIndex[linkUnit]
		if u and u.isExist and u:isExist() and u.getLife and u:getLife() > 0 then
			local p = u:getPoint()
			return p
		end

		return nil
	end

	-- 2) fallback : recherche par nom (rare)
	for _, u in pairs(CarrierIndex) do
		if u and u.isExist and u:isExist() and u.getName and u:getName() == linkUnit then
			local p = u:getPoint()
			return p
		end
	end

	return nil
end



function DCE_GetRoute(name)
	local select = MissGroupByName[name]
	if not select then
		env.info("DCE_Bug DCE_GetRoute this group Id not found in MissionGroupIndex[] " .. tostring(name))
	end

	return select
end

--envoi des messages au Player
-- notemment les heures de départ/roulage etc...
local totalMessages = 0

if campL.MsgForPlayerInMsn then
	for t, timeTable in pairs(campL.MsgForPlayerInMsn) do
		for groupId, msgs in pairs(timeTable) do
			totalMessages = totalMessages + #msgs
		end
	end
end

local lastCheck = 0

local function checkMessages()
	if totalMessages == 0 then
		return nil
	end

	local now = math.floor(timer.getTime())

	for t = lastCheck + 1, now do
		local timeTable = campL.MsgForPlayerInMsn[t]

		if timeTable then
			for groupName, msgs in pairs(timeTable) do
				local group = Group.getByName(groupName)

				if group then
					for i = 1, #msgs do
						trigger.action.outTextForGroup(group:getID(), msgs[i], 10)
						totalMessages = totalMessages - 1
					end
				end
			end
		end
	end

	lastCheck = now

	return now + 10
end


-- met à jour ou retourne les infos fuel d’un avion avec cooldown
-- retourne fuel et données avion avec cache temporel basé sur le temps DCS
local function updateFuelCache(unit)
	if not unit or not unit.isExist or not unit:isExist() then
		return nil
	end

	local unitId = unit:getID()
	local now = timer.getTime()

	local c = FuelCache[unitId]

	if not c then
		local desc = unit:getDesc()
		if not desc or not desc.fuelMassMax or not desc.range then
			return nil
		end

		c = {
			fuel = Unit.getFuel(unit),
			fuelMassMax = desc.fuelMassMax,
			range = desc.range,
			nextUpdate = now + fuelCacheCooldown
		}

		FuelCache[unitId] = c
		return c
	end

	-- cooldown pas expiré → aucune API DCS appelée
	if now < c.nextUpdate then
		return c
	end

	-- rafraîchissement réel
	c.fuel = Unit.getFuel(unit)
	c.nextUpdate = now + fuelCacheCooldown

	return c
end

local function updateBaseDistance(unit, baseX, baseY)
	-- garde-fous : on ne calcule rien si un argument essentiel manque
	if not unit or not baseX or not baseY then
		env.info("DCE_Bug updateBaseDistance: argument manquant (unit/baseX/baseY nil)")
		return nil
	end

	if not unit.isExist or not unit:isExist() then
		return nil
	end

	local id = unit:getID()
	local now = timer.getTime()

	local c = BaseDistCache[id]
	local pos = unit:getPoint()

	local dx = pos.x - baseX
	local dy = pos.z - baseY
	local dist = math.sqrt(dx * dx + dy * dy) / 1000

	if not c then
		BaseDistCache[id] = {
			baseX = baseX,
			baseY = baseY,
			lastDistKm = dist,
			lastTime = now,
			closingSpeed = 0
		}
		return dist
	end

	local dt = now - c.lastTime
	if dt > 0 then
		c.closingSpeed = (c.lastDistKm - dist) / dt
	end

	c.lastDistKm = dist
	c.lastTime = now
	c.baseX = baseX
	c.baseY = baseY

	return dist
end

local function bingo(gpId, gpObj)

	for n, unit in pairs(gpObj:getUnits()) do
		-- Bingo_prof.units = Bingo_prof.units + 1

		local callSign = Unit.getCallsign(unit)

		-- if BingoPlaneTab[gpId] and BingoPlaneTab[gpId][callSign] then
		--     Bingo_prof.dejaBingo_skip = Bingo_prof.dejaBingo_skip + 1
		--     return
		-- end

		if BingoPlaneTab[gpId] and BingoPlaneTab[gpId][callSign] then
			-- Bingo_prof.dejaBingo_skip = Bingo_prof.dejaBingo_skip + 1
		else
			local groupName = gpObj:getName()
			local toRTB
			local distanceToBase_Km = 0
			local cruiseSpeed = 300
			local speedMini = 999999
			local speedMax = 0

			local cache = updateFuelCache(unit)
			if not cache then
				env.info("DCE_Bingo D6 not cache, is dead? " .. tostring(callSign))
			else
				local fuelRemainingPercent = cache.fuel
				local fuelMass = cache.fuel * cache.fuelMassMax
				local unitRange = cache.range
				local unitId = unit:getID() -- celui-là est cheap

				-- 🟢 pré-filtre
				if fuelRemainingPercent > 0.60 then
					-- if fuelRemainingPercent > 2 then --testing
					-- Bingo_prof.prefilter_skip = Bingo_prof.prefilter_skip + 1
				else
					-- Bingo_prof.heavy_calc = Bingo_prof.heavy_calc + 1

					--calcul de la distance restante vers la base
					local mGroup = MissGroupByName[groupName]
					if mGroup then
						local route = mGroup.route.points
						-- local unitVec3 = unit:getPoint()

						local baseX, baseY

						--a mettre en cache
						if route[1].type == "TakeOff" then
							baseX = route[1].x
							baseY = route[1].y
						else
							local last = route[#route]
							baseX = last.x
							baseY = last.y
						end

						-- CV ?
						if route[1].linkUnit then
							local cv = getCarrierPosition(route[1].linkUnit)
							if cv then
								baseX = cv.x
								baseY = cv.z
							end
						end
						-- distanceToBase_Km = GetDistance({ x = baseX, y = baseY }, { x = unitVec3.x, y = unitVec3.z }) / 1000

						-- local c = BaseDistCache[unitId]
						-- if c then
						--     local dt = timer.getTime() - c.lastTime
						--     distanceToBase_Km = c.lastDistKm - c.closingSpeed * dt
						-- else
						--     distanceToBase_Km = updateBaseDistance(unit, baseX, baseY)
						-- end
						distanceToBase_Km = updateBaseDistance(unit, baseX, baseY) or 0
					else
						env.info("DCE_Bug DCE_Bingo this group not found in MissionGroupIndex[] " .. tostring(groupName))
					end

					if fuelMass and fuelMass > 0 then
						if distanceToBase_Km > 0 then
							if not AvgConsumptionKgPerKm[unitId] then
								if unitRange > 0 then
									AvgConsumptionKgPerKm[unitId] = cache.fuelMassMax / unitRange
								else
									AvgConsumptionKgPerKm[unitId] = 3
								end
							end

							local availableDistanceKm = fuelMass / AvgConsumptionKgPerKm[unitId]

							-- env.info("DCE_Bingo D3b availableDistanceKm: " .. tostring(availableDistanceKm) .. " <? distanceToBase_Km+200000: " .. tostring(distanceToBase_Km+200000))

							if availableDistanceKm < (distanceToBase_Km + 200) then
								-- if availableDistanceKm < (distanceToBase_Km + 200000) then
								toRTB = true
							end
						end
					else
						env.info("DCE_Bug Bingo D5 unitDesc invalid or missing fuelMassMax/range")
					end
				end

				if toRTB then
					-- Bingo_prof.ckeckRTB = Bingo_prof.ckeckRTB + 1

					trigger.action.outTextForGroup(gpId, callSign .. " low fuel: RTB", 15, true)

					if not BingoPlaneTab[gpId] then BingoPlaneTab[gpId] = {} end

					BingoPlaneTab[gpId][callSign] = true -- la callSign à déja indiqué qu'il était Bingo

					local humainUnit
					if unit and unit.getPlayerName then
						humainUnit = unit:getPlayerName()
					end
					-- local unitName = unit:getName()
					local unitVec3 = unit:getPoint()


					local report = "DCE_Bingo, pass toRTB, is humainUnit?:  " .. tostring(humainUnit)
					report = report .. " " .. tostring(callSign)
					local cntrl

					--for the leader, the task has to be set on the group level
					if n == 1 then
						cntrl = gpObj:getController()
					else
						cntrl = unit:getController()
					end

					report = report .. " RTB_ON_BINGO & PROHIBIT_AB "

					local breaktab = false
					local rtbGroup = {
						name = "",
						from = 0,
						to = 0
					}

					local mGroupB = MissGroupByName[groupName]
					if mGroupB then
						-- Bingo_prof.waypoint_scans = Bingo_prof.waypoint_scans + #mGroupB.route.points

						--le wpt le plus proche de l'unit
						local existIP = 0
						local wptN_closest = #mGroupB.route.points - 1
						local closestPoint = 99999999
						for wptN, wpt in ipairs(mGroupB.route.points) do
							if wpt.name == 'IP' then
								existIP = wptN
								closestPoint = 99999999
								-- env.info( "DCE_Bingo D1  passIP existIP: "..tostring(existIP))
							end
							--on essai de passer le point IP et le target
							if existIP > 0 and wptN < existIP + 2 then
								closestPoint = 99999999
								-- env.info( "DCE_Bingo D2 N1 existIP: "..tostring(existIP)..", wptN : "..tostring(wptN).." < "..tostring(existIP+2))
							end
							local distance = GetDistance({ x = unitVec3.x, y = unitVec3.z },
								{ x = wpt.x, y = wpt.y })
							if distance < closestPoint then
								closestPoint = distance
								wptN_closest = wptN
								-- env.info( "DCE_Bingo D1 N2 wptN_closest: "..tostring(wptN_closest).." closestPoint: "..tostring(closestPoint))
							end
						end

						rtbGroup.from = wptN_closest

						-- --Split
						-- for key, value in ipairs(_group.route.points) do
						-- 	if value.name == 'Split' then
						-- 		rtbGroup.from = key
						-- 	end
						-- end


						for key, value in ipairs(mGroupB.route.points) do
							--  env.info( "DCE_Bingo D1        waypoint "..tostring(key).." type "..tostring(value.type))
							if value.type == 'Land' then
								--  env.info( "DCE_Bingo D_2        found Land waypoint at "..tostring(key))
								rtbGroup.to = key
							end
						end


						if rtbGroup.to == 0 then
							rtbGroup.to = #mGroupB.route.points
						end
					end

					-- env.info( "DCE_Bingo D__DD        rtbGroup from "..tostring( rtbGroup.from).." to "..tostring( rtbGroup.to))

					if rtbGroup.to ~= 0 then
						local switchtask = {
							id = "SwitchWaypoint",
							params = {
								goToWaypointIndex = rtbGroup.to,
								fromWaypointIndex = rtbGroup.from
							}
						}


						cntrl:resetTask()

						cntrl:setCommand(switchtask)

						-- Bingo_prof.rtb_orders = Bingo_prof.rtb_orders + 1

						cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2)
						cntrl:setOption(AI.Option.Air.id.PROHIBIT_AA, true) -- Désactiver l'engagement A/A
						cntrl:setOption(AI.Option.Air.id.PROHIBIT_JETT, false)
						cntrl:setOption(AI.Option.Air.id.PROHIBIT_AB, true)
						cntrl:setOption(AI.Option.Air.id.JETT_TANKS_IF_EMPTY, true)

						-- RTB_NO							= false,
						-- RTB_AAR_REFUEL 					= true,
						-- RTB_IGNORE_AAR					= 2,

						cntrl:setOption(AI.Option.Air.id.RTB_ON_BINGO, 2) -- RTB on Bingo  RTB_IGNORE_AAR
						--OptionName.RTB_ON_BINGO

						env.info("DCE_Bingo D__DD        " .. callSign .. " RTB_ON_BINGO set" .. report)
					end
				end
			end
		end
	end
end


LLtool = {}

LLtool.LLstrings = function(posVec3) -- pos is a Vec3
	local LLposN, LLposE = coord.LOtoLL(posVec3)
	local LLposfixN, LLposdegN = math.modf(LLposN)
	LLposdegN = LLposdegN * 60
	local LLposdegN2, LLposdegN3 = math.modf(LLposdegN)
	LLposdegN3 = LLposdegN3 * 1000

	local LLposfixE, LLposdegE = math.modf(LLposE)
	LLposdegE = LLposdegE * 60
	local LLposdegE2, LLposdegE3 = math.modf(LLposdegE)
	LLposdegE3 = LLposdegE3 * 1000

	local LLposNstring = string.format('%+.2i %.2i %.3d', LLposfixN, LLposdegN2, LLposdegN3)
	local LLposEstring = string.format('%+.3i %.2i %.3d', LLposfixE, LLposdegE2, LLposdegE3)

	return LLposNstring, LLposEstring
end


--************* AFAC PART ****************************************
local function AFAC_com(arg)
	-- local AFAC_Name = arg[1]
	-- local gpGid = arg[2]
	-- local radioOn = arg[3]

	local afacData = {
		AFAC_Name = Deepcopy(arg[1]),
		gpGid = Deepcopy(arg[2]),
		radioOn = Deepcopy(arg[3]),
	}

	_affiche(afacData, "AFAC_afacData ")

	if afacData.radioOn and afacData.radioOn == "on" then
		AFAC_available[afacData.AFAC_Name]["gpGid"] = afacData.gpGid
		trigger.action.outTextForGroup(afacData.gpGid, "AFAC radio On, waiting ...", 15, false)
		_affiche(AFAC_available, "AFAC_available_radioOn ")
	elseif afacData.radioOn and afacData.radioOn == "off" then
		if AFAC_available[afacData.AFAC_Name]["gpGid"] and AFAC_available[afacData.AFAC_Name]["gpGid"] == afacData.gpGid then
			AFAC_available[afacData.AFAC_Name]["gpGid"] = nil
		end
		trigger.action.outTextForGroup(afacData.gpGid, "AFAC radio Off", 15, false)
		_affiche(AFAC_available, "AFAC_available_radioOff ")
	else
		trigger.action.outTextForGroup(afacData.gpGid, "AFAC radio ?else?", 15, false)
		_affiche(AFAC_available, "AFAC_available else ")
	end
end

local function AFAC_Com_ON(arg)
	-- local AFAC_Name = arg[1]
	-- local gpGid = arg[2]
	-- local radioOn = arg[3]

	local afacData = {
		AFAC_Name = Deepcopy(arg[1]),
		gpGid = Deepcopy(arg[2]),
		radioOn = Deepcopy(arg[3]),
	}

	_affiche(afacData, "AFAC_afacData ")

	if not AFAC_available[afacData.AFAC_Name] then
		env.info("DCE_Bug AFAC_Com_ON: AFAC_Name inconnu ou déjà retiré: " .. tostring(afacData.AFAC_Name))
		return
	end

	AFAC_available[afacData.AFAC_Name]["gpGid"] = afacData.gpGid
	trigger.action.outTextForGroup(afacData.gpGid, "AFAC radio On, waiting ...: " .. tostring(afacData.AFAC_Name), 15,
		false)
	_affiche(AFAC_available, "AFAC_available_radioOn ")
end

local function AFAC_Com_OFF(arg)
	-- local AFAC_Name = arg[1]
	-- local gpGid = arg[2]
	-- local radioOn = arg[3]

	local afacData = {
		AFAC_Name = Deepcopy(arg[1]),
		gpGid = Deepcopy(arg[2]),
		radioOn = Deepcopy(arg[3]),
	}

	_affiche(afacData, "AFAC_afacData ")

	if not AFAC_available[afacData.AFAC_Name] then
		env.info("DCE_Bug AFAC_Com_OFF: AFAC_Name inconnu ou déjà retiré: " .. tostring(afacData.AFAC_Name))
		return
	end

	if AFAC_available[afacData.AFAC_Name]["gpGid"] and AFAC_available[afacData.AFAC_Name]["gpGid"] == afacData.gpGid then
		AFAC_available[afacData.AFAC_Name]["gpGid"] = nil
	end
	trigger.action.outTextForGroup(afacData.gpGid, "AFAC radio Off : " .. tostring(afacData.AFAC_Name), 15, false)
	_affiche(AFAC_available, "AFAC_available_radioOff ")
end

function AFAC_F10(playerGroup)
	local gpGid
	if playerGroup and playerGroup:isExist() then
		gpGid = playerGroup:getID()
	else
		return -- Exit the function if group doesn't exist
	end

	missionCommands.removeItemForGroup(gpGid, { "AFAC" })

	local menuAFAC_A = missionCommands.addSubMenuForGroup(gpGid, "AFAC")

	if AFAC_available then
		--ne pas fair ça, cela rend le resultat aélatoire
		-- for AFAC_Name, _ in pairs(AFAC_available) do
		-- 	if AFAC_Name and type(AFAC_Name) == "string" then
		-- 		menuAFAC_A = missionCommands.addSubMenuForGroup(gpGid, "AFAC")
		-- 		break
		-- 	end
		-- end

		local i = 1
		for afacName, _ in pairs(AFAC_available) do
			if afacName and type(afacName) == "string" then
				-- menuAFAC_B = missionCommands.addSubMenuForGroup(gpGid, tostring(afacName), menuAFAC_A)

				-- Create a unique submenu for each AFAC name
				local uniqueMenuAFAC = missionCommands.addSubMenuForGroup(gpGid, tostring(afacName), menuAFAC_A)

				-- Commande pour activer la radio AFAC
				radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gpGid,
					"AFAC radio On (" .. afacName .. ")", uniqueMenuAFAC, AFAC_Com_ON, { afacName, gpGid, "on" })

				-- Commande pour désactiver la radio AFAC
				radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gpGid,
					"AFAC radio Off (" .. afacName .. ")", uniqueMenuAFAC, AFAC_Com_OFF, { afacName, gpGid, "off" })
			end
			i = i + 1
		end
	end
end

--SAR_function
function SAR_fct.activateRadioBeacon(arguments)
	--attention, surement conflit avec function LoopManagedRadioTransmission()

	local arg_gpGid = arguments[1]
	local arg_ejPilTab = arguments[2]
	local pilEjectObj = Unit.getByName(arg_ejPilTab.name)

	if campL.EjectedPilotFrequency and campL.EjectedPilotFrequency[arg_ejPilTab.sideName] then
		if pilEjectObj then
			env.info("DCE_activateRadioBeacon  pilEjectObj:isExist " .. tostring(pilEjectObj:isExist()))

			if not arg_ejPilTab.embarked and pilEjectObj:isExist() then
				local modulation = 0 --AM/FM
				local modulationTxt = "AM" --AM
				if campL.EjectedPilotFrequency[arg_ejPilTab.sideName].radioBeacon < 90000000 then
					modulation = 1 --FM
					modulationTxt = "FM"
				end

				env.info("DCE_TransRadio modulation: " .. tostring(modulation))
				env.info("DCE_TransRadio Ejected pilot position: " ..
				tostring(arg_ejPilTab.posVec3.x) ..
				", " .. tostring(arg_ejPilTab.posVec3.y) .. ", " .. tostring(arg_ejPilTab.posVec3.z))
				env.info("DCE_TransRadio radioBeacon: " ..
				tostring(campL.EjectedPilotFrequency[arg_ejPilTab.sideName].radioBeacon))
				env.info("DCE_TransRadio RadioWatt: " .. tostring(RadioWatt))
				env.info("DCE_TransRadio 'radioBeacon_' .. arg_ejPilTab.name: " ..
				tostring('radioBeacon_' .. arg_ejPilTab.name))



				trigger.action.radioTransmission('l10n/DEFAULT/beacon.ogg', arg_ejPilTab.posVec3, modulation, true,
					campL.EjectedPilotFrequency[arg_ejPilTab.sideName].radioBeacon, RadioWatt,
					'radioBeacon_' .. arg_ejPilTab.name)

				local freqShow = campL.EjectedPilotFrequency[arg_ejPilTab.sideName].radioBeacon / 1000000
				trigger.action.outTextForGroup(arg_gpGid, "activate RadioBeacon on : " ..
				freqShow .. " MHz " .. modulationTxt, 45, true)

				--set a ON la radio du l'ejectedPilot
				for MGRS_Chute, zone in pairs(ZoneSAR) do
					for pilotN, ejPilot in ipairs(zone) do
						local ejPilotObj = Unit.getByName(ejPilot.name)
						if ejPilot.name == arg_ejPilTab.name then
							ejPilot.radioFreq = freqShow
							ejPilot.radio_on = true
							env.info("DCE_activateRadioBeacon set radioFreq true for ejPilot.name " ..
							tostring(ejPilot.name))
							timer.scheduleFunction(SAR_fct.menuF10_SAR, nil, timer.getTime() + 1)
						end
					end
				end
			end
		else
			trigger.action.outTextForGroup(arg_gpGid, "No response, the pilot may have been captured or killed. ", 15,
				true)

			env.info("DCE_activateRadioBeacon Error no response  ejectedPilot.name " .. tostring(arg_ejPilTab.name))

			_affiche(pilEjectObj, "pilEjectObj ")
		end
	else
		env.info("DCE_activateRadioBeacon frequency Error,  side  " ..
		tostring(arg_ejPilTab.sideName) ..
		" or Frequency: " .. tostring(campL.EjectedPilotFrequency[arg_ejPilTab.sideName]))
	end
end

--TODO code mort, non appelée
function SAR_fct.StopRadioBeaconTransmission(ejPilotName)
	if not ejPilotName or type(ejPilotName) ~= "string" then
		env.info("DCE_Bug StopRadioBeaconTransmission: ejPilotName manquant ou invalide")
		return
	end

	trigger.action.stopRadioTransmission('radioBeacon_' .. ejPilotName)

	env.info("DCE_RADIO StopRadioBeaconTransmission  " .. tostring('radioBeacon_' .. ejPilotName))

	--set a OFF la radio du l'ejectedPilot
	for MGRS_Chute, zone in pairs(ZoneSAR or {}) do
		for pilotN, ejPil in ipairs(zone) do
			if ejPil and ejPil.name == ejPilotName then
				ejPil.radio_on = nil
				env.info("DCE_activateRadioBeacon set radioBeacon OFF for ejPil.name " .. tostring(ejPil.name))
			end
		end
	end
end

--************* SAR ejectedPilot PART ****************************************
function SAR_fct.menuF10_SAR(arg)
	-- “Downed pilot, this is Sandy. If you hear me, key your radio twice.”
	env.info("DCE_menuF10_SAR A timer.getTime() " .. tostring(timer.getTime()))

	local gId = arg[1]
	local groupObj = arg[2]

	env.info("DCE_menuF10_SAR C1 arg_gpGid " .. tostring(gId) .. " arg_playerGroup: " .. tostring(groupObj))

	if groupObj and groupObj:isExist() then
	else
		env.info("DCE_menuF10_SAR D playerGroup not exist")
		return
	end

	local wingman = groupObj:getUnits()
	local unitSAR = wingman[1]
	local sar_CoalitionId = tostring(unitSAR:getCoalition())
	-- local uSAR_Player = unitSAR:getPlayerName()

	if unitSAR:isExist() and unitSAR:isActive() then
		local pos_SAR_vec3 = unitSAR:getPoint()

		env.info("DCE_menuF10_SAR E unitSAR:isExist() " ..
		tostring(unitSAR:isExist()) ..
		" unitSAR:isActive() " ..
		tostring(unitSAR:isActive()) ..
		" pos_SAR_vec3.x " ..
		tostring(pos_SAR_vec3.x) ..
		" pos_SAR_vec3.y " .. tostring(pos_SAR_vec3.y) .. " pos_SAR_vec3.z " .. tostring(pos_SAR_vec3.z))

		local txt = "Downed pilot, this is Sandy, key your radio and give me a beep."
		timer.scheduleFunction(ResponseTimeForGp, { gId, txt }, timer.getTime() + 2)

		for MGRS_Chute, zone in pairs(ZoneSAR) do
			env.info("DCE_menuF10_SAR _F1 MGRS_Chute " .. tostring(MGRS_Chute))
			for pilotN, ejPil in ipairs(zone) do
				env.info("DCE_menuF10_SAR _F2 pilotN " ..
				tostring(pilotN) ..
				" ejPil.name " ..
				tostring(ejPil.name) ..
				" ejPil.embarked " ..
				tostring(ejPil.embarked) ..
				" ejPil.sideName " ..
				tostring(ejPil.sideName) ..
				" CoalitionIdAlphaToName[sar_CoalitionId] " ..
				tostring(CoalitionIdAlphaToName[sar_CoalitionId]) .. " ejPil.radio_on " .. tostring(ejPil.radio_on))

				if ejPil.name and not ejPil.embarked and ejPil.sideName == CoalitionIdAlphaToName[sar_CoalitionId]
					and not ejPil.radio_on then
					env.info("DCE_menuF10_SAR _F3 pilotN " ..
					tostring(pilotN) ..
					" ejPil.name " ..
					tostring(ejPil.name) ..
					" ejPil.embarked " ..
					tostring(ejPil.embarked) ..
					" ejPil.sideName " ..
					tostring(ejPil.sideName) ..
					" CoalitionIdAlphaToName[sar_CoalitionId] " ..
					tostring(CoalitionIdAlphaToName[sar_CoalitionId]) .. " ejPil.radio_on " .. tostring(ejPil.radio_on))
					local unitEjectPilot = Unit.getByName(ejPil.name)

					if unitEjectPilot then
						local ejPilotVec3 = unitEjectPilot:getPoint()
						-- local distance = math.sqrt(math.pow( pos_SAR_vec3.x - ejPilotVec3.x, 2) + math.pow(pos_SAR_vec3.z - ejPilotVec3.z, 2))
						local dx = pos_SAR_vec3.x - ejPilotVec3.x
						local dz = pos_SAR_vec3.z - ejPilotVec3.z
						local distance = math.sqrt(dx * dx + dz * dz)

						env.info("DCE_menuF10_SAR _F4 pilotN " ..
						tostring(pilotN) ..
						" ejPil.name " .. tostring(ejPil.name) .. " distance to player " .. tostring(distance))

						-- Portée volontairement limitée (~30km) : simule la faible portée de la radio de détresse de l'éjecté
						if distance <= 30000 then --if distance <= 140000
							env.info("DCE_menuF10_SAR __G pilotN " ..
							tostring(pilotN) ..
							" ejPil.name " .. tostring(ejPil.name) .. " is in range for radio transmission")

							-- local ejPilData = arg[1]
							-- local ejPilObj = arg[2]
							-- StartRadioTransmission(arg)

							if unitEjectPilot:isExist() then
								timer.scheduleFunction(StartRadioTransmission, { gId, ejPil, ejPilotVec3 },
									timer.getTime() + 10)
							end
						end
					end
				end
			end
		end
	end
end

-- SAR_fct.menuF10_SAR_OLD() supprimée (code mort, jamais appelée ; remplacée depuis longtemps par SAR_fct.menuF10_SAR)





function BullsEye(playerGroup)
	-- ['coalition'] = {
	-- ['blue'] = {
	-- ['bullseye'] = {
	-- ['y'] = 635639.37385346,
	-- ['x'] = -317948.32727306,
	-- },
	local gpGid = playerGroup:getID()
	local playerUnits = playerGroup:getUnits()
	local playerUnit = playerUnits[1]

	local coalitionId = playerUnit:getCoalition()

	local sideT = {
		[0] = "neutral",
		[1] = "red",
		[2] = "blue"
	}

	local bullsEye_pos = {
		x = env.mission.coalition[sideT[coalitionId]].bullseye.x,
		y = 0,
		z = env.mission.coalition[sideT[coalitionId]].bullseye.y
	}

	LLposNstring, LLposEstring = LLtool.LLstrings(bullsEye_pos)

	trigger.action.outTextForGroup(gpGid, "BullsEye: " .. 'N ' .. LLposNstring .. '   E ' .. LLposEstring, 45, true)
end

function FctRtbGroup(rtbGroup)
	trigger.action.outText("RTB " .. tostring(rtbGroup.name), 5) --FOR DEBUG

	local gp = Group.getByName(rtbGroup.name)

	local rtbCtr = Group.getController(gp)


	local switchtask = {
		id = "SwitchWaypoint",
		params = {
			goToWaypointIndex = rtbGroup.to,
			fromWaypointIndex = rtbGroup.from
		}
	}

	rtbCtr:resetTask()
	rtbCtr:setCommand(switchtask)
end

function RtbPack(playerGroup)
	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == campL.playerSide then
			for Ncountry, _country in pairs(coalition.country) do
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name, "Pack " .. campL.playerPackN) then
							local rtbGroup = {
								name = "",
								from = 0,
								to = 0
							}


							rtbGroup.name = _group.name

							if string.find(_group.name, "Escort") then
								local function Execute()
									local wingman = _group:getUnits() --get list of units from attacking flights
									for n = 1, #wingman do --iterate through wingmen in flight
										local cntrl

										if n == 1 then
											cntrl = _group:getController()
										else
											cntrl = wingman[n]:getController()
										end

										cntrl:resetTask() --reset task (wingman will rejoin with leader)
									end
								end
								timer.scheduleFunction(Execute, nil, timer.getTime() + 1)
							end

							for key, value in ipairs(_group.route.points) do
								if value.type == 'Land' then
									rtbGroup.to = key
									rtbGroup.from = key - 1
								end
							end

							if rtbGroup.name and rtbGroup.to ~= 0 then
								FctRtbGroup(rtbGroup)
							end
						end
					end
				end
			end
		end
	end
end

function RtbStrikePack(playerGroup)
	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == campL.playerSide then
			for Ncountry, _country in pairs(coalition.country) do
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name, "Pack " .. campL.playerPackN) then
							local rtbGroup = {
								name = "",
								from = 0,
								to = 0
							}


							rtbGroup.name = _group.name

							if string.find(_group.name, "Strike") then
								for key, value in ipairs(_group.route.points) do
									if value.type == 'Land' then
										rtbGroup.to = key
										rtbGroup.from = key - 1
									end
								end

								if rtbGroup.name and rtbGroup.to ~= 0 then
									FctRtbGroup(rtbGroup)
								end
							end
						end
					end
				end
			end
		end
	end
end

function RtbSEADPack(playerGroup)
	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == campL.playerSide then
			for Ncountry, _country in pairs(coalition.country) do
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name, "Pack " .. campL.playerPackN) then
							local rtbGroup = {
								name = "",
								from = 0,
								to = 0
							}


							rtbGroup.name = _group.name

							if string.find(_group.name, "SEAD") then
								for key, value in ipairs(_group.route.points) do
									if value.type == 'Land' then
										rtbGroup.to = key
										rtbGroup.from = key - 1
									end
								end

								if rtbGroup.name and rtbGroup.to ~= 0 then
									FctRtbGroup(rtbGroup)
								end
							end
						end
					end
				end
			end
		end
	end
end

function EWR_ON(data)
	if not data or not data.playerName or not data.gid or not data.groupObject then
		env.info("EWR_ON: Missing data, cannot process EWR_ON command.")
		return
	end

	if not EWR_optionPlayer then
		EWR_optionPlayer = {}
	end

	if not EWR_optionPlayer[data.playerName] then
		EWR_optionPlayer[data.playerName] = {}
	end

	EWR_optionPlayer[data.playerName].EWR_on = true

	local txt = tostring(data.playerName) .. " switch EWR to ON"
	trigger.action.outTextForGroup(data.gid, txt, 20)
end

function EWR_OFF(data)
	if not data or not data.playerName or not data.gid or not data.groupObject then
		env.info("EWR_ON: Missing data, cannot process EWR_ON command.")
		return
	end

	if not EWR_optionPlayer then
		EWR_optionPlayer = {}
	end

	if not EWR_optionPlayer[data.playerName] then
		EWR_optionPlayer[data.playerName] = {}
	end

	EWR_optionPlayer[data.playerName].EWR_on = false

	local txt = tostring(data.playerName) .. " switch EWR to OFF"
	trigger.action.outTextForGroup(data.gid, txt, 20)
end

function EWR_Status(data)
	if not data or not data.gid or not data.groupObject then
		env.info("EWR_Status: Missing data, cannot process EWR_Status command.")
		return
	end

	for playerName, options in pairs(EWR_optionPlayer) do
		local status = options.EWR_on and "ON" or "OFF"
		local txt = tostring(playerName) .. " EWR is currently: " .. status
		trigger.action.outTextForGroup(data.gid, txt, 20)
	end
end

-- EWR_ON_OLD() supprimée (code mort, jamais appelée ; voir EWR_ON())

-- EWR_OFF_OLD() supprimée (code mort, jamais appelée ; voir EWR_OFF())





function ReFueling(playerGroup)
	local player = {
		["point"] = {}
	}

	local tanker = {
		["point"] = {},
		["name"] = "",
		["distance"] = 0,
		["gpName"] = ""
	}

	local REFUEL_MIN_FRACTION = 1 / 3 -- le tanker doit avoir au moins ce ratio de l'emport max du demandeur, en fuel dispo

	local playerUnits = playerGroup:getUnits()
	local playerUnit = playerUnits[1]
	local uid = playerUnit:getID()

	local playerDesc = getCachedDesc(playerUnit)
	if not playerDesc or not playerDesc.attributes or not playerDesc.attributes.Refuelable then
		trigger.action.outTextForGroup(playerGroup:getID(), "Your aircraft is not capable of aerial refueling.", 15, true)
		return
	end

	-- fichier miz:
	-- plan haut, droite, alti : x/y/z
	-- vue F10 et vector3d:
	-- plan haut, droite, alti : x/z/y

	local playerVec3 = playerUnit:getPoint()
	player.point.x = playerVec3.x
	player.point.y = playerVec3.z
	player.point.z = playerVec3.y
	local playerCoalitionId = playerUnit:getCoalition()
	local groups = coalition.getGroups(playerCoalitionId, Group.Category.AIRPLANE)
	local speed = playerUnit:getVelocity()
	player.speed = math.sqrt(speed.x ^ 2 + speed.y ^ 2 + speed.z ^ 2)
	-- local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	local selected_distance = 99999999

	for i, gp in pairs(groups) do
		local gpName = Group.getName(gp)
		if string.find(gpName, "Refueling") then
			local units = gp:getUnits()
			local _unit = units[1]
			local callsign = _unit:getCallsign()
			local tankerTypeName = _unit:getTypeName()
			local t = {
				["point"] = {}
			}

			local unitVec3 = _unit:getPoint()
			t.point.x = unitVec3.x
			t.point.y = unitVec3.z
			t.point.z = unitVec3.y

			local description = getCachedDesc(_unit)
			local tankerFuelCache = updateFuelCache(_unit)

			local gpId = Group.getID(gp)
			local isBingo = BingoPlaneTab[gpId] and BingoPlaneTab[gpId][callsign]

			if description and description.attributes and (description.attributes.Refuelable or description.attributes.Tankers)
				and _unit:isActive() and tankerFuelCache and not isBingo then
				-- if _unit:getTypeName() == "S-3B Tanker" and _unit:isActive() then
				-- if _unit:getTypeName() == "S-3B Tanker"  and t.point.z > 100 and _unit:isActive() then

				local tankerFuelMass = tankerFuelCache.fuel * tankerFuelCache.fuelMassMax

				if tankerFuelMass >= (playerDesc.fuelMassMax * REFUEL_MIN_FRACTION) then
					-- local tempDistance = math.sqrt(math.pow(t.point.x - player.point.x, 2) + math.pow(t.point.y - player.point.y, 2))		--distance between tanker and player
					local dx = t.point.x - player.point.x
					local dy = t.point.y - player.point.y
					local tempDistance = math.sqrt(dx * dx + dy * dy) --distance between tanker and player
					if tempDistance < selected_distance then
						tanker.point = t.point
						tanker.TypeName = tankerTypeName
						tanker.distance = tempDistance
						tanker.gpName = tostring(gpName)
						tanker.ctr = Group.getController(gp)
						tanker.callsign = callsign
						tanker._unit = _unit
						tanker.Desc = description
						selected_distance = tempDistance
					end
				end
			end
		end
	end

	if not tanker._unit then
		local playerGid = playerGroup:getID()
		trigger.action.outTextForGroup(playerGid, "No refueling tanker available (or all tankers are too low on fuel).", 15, true)
		env.info("DCE_Bug ReFueling: no suitable tanker found for coalition " .. tostring(playerCoalitionId))
		return
	end

	local heading       = GetHeading(tanker.point, player.point)  --return heading between two vector2 points
	local dist          = tanker.distance / 2
	local interceptPos  = GetOffsetPoint(tanker.point, heading, dist) --function to return a new point offset from an initial point
	local interceptAlt  = player.point.z
	local pattern_alt   = player.point.z
	local pattern_speed = player.speed

	if interceptAlt < 1000 and dist > 50000 then
		interceptAlt = 3000
	elseif interceptAlt > 6100 then -- alti max:6100
		interceptAlt = 6100
		pattern_alt = 6100
	end

	if pattern_speed < 130 then
		pattern_speed = 130
	elseif pattern_speed > 200 then -- vi max:6100
		pattern_speed = 200
	end

	local infoSpeed = math.floor(pattern_speed / 0.51444444444)        -- m/s to Kts
	local infoAlti = math.floor((pattern_alt * 3.2808398950131) / 100) * 100 -- m to ft
	local interceptPosVec3 = {
		x = interceptPos.x,
		y = pattern_alt,
		z = interceptPos.y
	}

	local intercept_LL = coord.LOtoLL(interceptPosVec3)

	LLposNstring, LLposEstring = LLtool.LLstrings(interceptPosVec3)
	local txt = tanker.callsign .. " " .. tanker.gpName .. " Rdv: " ..
		'N ' .. LLposNstring .. '   E ' .. LLposEstring .. " Alt: " .. infoAlti .. " Speed " .. infoSpeed

	local Mission = { --define mission for interceptor group
		id = 'Mission',
		params = {
			route = {
				["points"] = {
					[1] = {
						["alt"] = interceptAlt,
						["type"] = "Turning Point",
						["action"] = "Turning Point",
						["alt_type"] = "BARO",
						["formation_template"] = "",
						["y"] = interceptPos.y,
						["x"] = interceptPos.x,
						["speed"] = 200,
						["ETA_locked"] = false,
						["task"] = {
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] =
								{

									[1] =
									{
										["number"] = 1,
										["auto"] = false,
										["id"] = "Tanker",
										["enabled"] = true,
										["params"] =
										{
										}, -- end of ["params"]
									}, -- end of [1]
									[2] =
									{
										["number"] = 2,
										["auto"] = false,
										["id"] = "ControlledTask",
										["enabled"] = true,
										["params"] =
										{
											["task"] =
											{
												["id"] = "Orbit",
												["params"] =
												{
													["altitude"] = pattern_alt,
													["pattern"] = "Circle",
													["speed"] = pattern_speed,
													["speedEdited"] = true,
												}, -- end of ["params"]
											}, -- end of ["task"]
											["stopCondition"] =
											{
												["duration"] = 600,
											}, -- end of ["stopCondition"]
										}, -- end of ["params"]
									}, -- end of [2]
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						},
						["speed_locked"] = true,
					},
					[2] = {
						["alt"] = tanker.point.z,
						["type"] = "Turning Point",
						["action"] = "Turning Point",
						["alt_type"] = "BARO",
						["formation_template"] = "",
						-- ["ETA"] = 0,
						["y"] = tanker.point.y,
						["x"] = tanker.point.x,
						["speed"] = 180,
						["ETA_locked"] = false,
						["task"] = {
							["id"] = "ComboTask",
							["params"] = {
								["tasks"] = {
								},
							},
						},
						["speed_locked"] = true,
					},
				},
			}
		}
	}

	local function Execute()
		trigger.action.outText(txt, 20)
		Controller.setTask(tanker.ctr, Mission)
	end
	timer.scheduleFunction(Execute, nil, timer.getTime() + 3) --activate task with mission for interceptor group
end

function RequestCAP(playerGroup)
	-- modification M36	Help CAP
	local player = {
		["point"] = {}
	}

	local CAP = {
		["point"] = {},
		["name"] = "",
		["distance"] = 0,
		["gpName"] = ""
	}

	local playerUnits = playerGroup:getUnits()
	local playerUnit = playerUnits[1]
	local uid = playerUnit:getID()

	-- fichier miz:
	-- plan haut, droite, alti : x/y/z
	-- vue F10 et vector3d:
	-- plan haut, droite, alti : x/z/y

	local playerVec3 = playerUnit:getPoint()
	player.point.x = playerVec3.x
	player.point.y = playerVec3.z
	player.point.z = playerVec3.y

	local playerCoalitionId = playerUnit:getCoalition()
	local groups = coalition.getGroups(playerCoalitionId, Group.Category.AIRPLANE)
	local speed = playerUnit:getVelocity()
	player.speed = math.sqrt(speed.x ^ 2 + speed.y ^ 2 + speed.z ^ 2)

	-- local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	local selected_distance = 99999999

	for i, gp in pairs(groups) do
		local gpName = Group.getName(gp)

		if string.find(gpName, "CAP") then
			local units = gp:getUnits()
			local _unit = units[1]
			local fuel = _unit:getFuel()
			local callsign = _unit:getCallsign()
			local TankerTypeName = _unit:getTypeName()
			local t = {
				["point"] = {}
			}

			local unitVec3 = _unit:getPoint()
			t.point.x = unitVec3.x
			t.point.y = unitVec3.z
			t.point.z = unitVec3.y

			if _unit:isActive() then
				-- if _unit:getTypeName() == "S-3B Tanker"  and t.point.z > 100 and _unit:isActive() then

				-- local tempDistance = math.sqrt(math.pow(t.point.x - player.point.x, 2) + math.pow(t.point.y - player.point.y, 2))		--distance between tanker and player
				local dx = t.point.x - player.point.x
				local dy = t.point.y - player.point.y
				local tempDistance = math.sqrt(dx * dx + dy * dy) --distance between tanker and player

				if tempDistance < selected_distance then
					CAP.point = t.point
					CAP.TypeName = TankerTypeName
					CAP.distance = tempDistance
					CAP.gpName = tostring(gpName)
					CAP.ctr = Group.getController(gp)
					CAP.callsign = callsign
					CAP._unit = _unit
					CAP.Desc = _unit:getDesc()
					selected_distance = tempDistance
				end
			end
		end
	end

	if not CAP._unit then
		local playerGid = playerGroup:getID()
		trigger.action.outTextForGroup(playerGid, "No CAP flight available.", 15, true)
		env.info("DCE_Bug RequestCAP: no CAP found for coalition " .. tostring(playerCoalitionId))
		return
	end


	local heading          = GetHeading(CAP.point, player.point) --return heading between two vector2 points
	local dist             = CAP.distance / 1.5       -- approche le CAP

	CAP.velocity           = CAP._unit:getVelocity()
	CAP.speed              = math.sqrt(CAP.velocity.x ^ 2 + CAP.velocity.y ^ 2 + CAP.velocity.z ^ 2)

	local interception_pos = GetOffsetPoint(CAP.point, heading, dist) --function to return a new point offset from an initial point

	local interception_alt = player.point.z
	local pattern_speed -- ex = player.speed

	if interception_alt < 3000 and dist > 50000 then
		interception_alt = 7600
	elseif interception_alt > 6100 then -- alti max:6100
		interception_alt = 7600
	end

	-- trigger.action.outText(CAP.callsign.." "..CAP.gpName, 20)


	local Mission = { --define mission for interceptor group
		id = 'Mission',
		params = {
			route = {
				["points"] = {

					[1] = {
						['alt'] = interception_alt,
						['briefing_name'] = 'Station',
						['action'] = 'Turning Point',
						['alt_type'] = 'BARO',
						-- ['properties'] = {
						-- 	['vnav'] = 1,
						-- 	['scale'] = 0,
						-- 	['angle'] = 0,
						-- 	['vangle'] = 0,
						-- 	['steer'] = 2,
						-- },
						['speed_locked'] = true,
						['speed'] = 290, -- vitesse du son  295 a 20000m
						['ETA'] = 1,
						["y"] = interception_pos.y,
						["x"] = interception_pos.x,
						['formation_template'] = '',
						['name'] = 'Station',
						['ETA_locked'] = false,
						['task'] = {
							['id'] = 'ComboTask',
							['params'] = {
								['tasks'] = {
									[1] = {
										['enabled'] = true,
										['auto'] = false,
										['id'] = 'ControlledTask',
										['number'] = 1,
										['params'] = {
											['task'] = {
												['id'] = 'EngageTargetsInZone',
												['params'] = {
													['targetTypes'] = {
														[1] = 'Air',
														[2] = 'Cruise missiles',
													},
													['x'] = player.point.x,
													['value'] = 'Air;Cruise missiles;',
													['priority'] = 0,
													['y'] = player.point.y,
													['zoneRadius'] = 111000,
												},
											},
											['stopCondition'] = {
												['lastWaypoint'] = 3,
											},
										},
									},
									[2] = {
										['enabled'] = true,
										['auto'] = false,
										['id'] = 'ControlledTask',
										['number'] = 2,
										['params'] = {
											['task'] = {
												['id'] = 'Orbit',
												['params'] = {
													['altitude'] = CAP.point.z,
													['pattern'] = 'Race-Track',
													['speed'] = CAP.speed,
												},
											},
											['stopCondition'] = {
												['time'] = 1000,
											},
										},
									},
								},
							},
						},
						['type'] = 'Turning Point',
					},
				},
			}
		}
	} --local Mission = {


	Controller.setTask(CAP.ctr, Mission) --activate task with mission for interceptor group

	local function Execute()
		trigger.action.outText(CAP.callsign .. " " .. CAP.gpName, 20)
		Controller.setTask(CAP.ctr, Mission)
		trigger.action.outText("ADD_CR " .. CAP.callsign .. " " .. CAP.gpName, 60)
	end
	timer.scheduleFunction(Execute, nil, timer.getTime() + 3)
end

function getOut(arg)
	env.info("DCE_getOut A function getOut(gid) ")

	if not arg or not arg[1] or not arg[2] then
		env.info("DCE_Bug getOut: argument manquant (arg/arg_groupObj/arg_playerName)")
		return
	end

	local arg_groupObj = arg[1]
	local arg_playerName = arg[2]

	if not arg_groupObj.isExist or not arg_groupObj:isExist() then
		env.info("DCE_getOut: groupObj n'existe plus, abandon")
		return
	end

	local wingman = arg_groupObj:getUnits()
	local playerName
	local playerObj
	local playerId

	if wingman then
		for w = 1, #wingman do
			if wingman[w] and wingman[w].isExist and wingman[w]:isExist() and wingman[w].getPlayerName then
				playerName = wingman[w]:getPlayerName()

				if playerName == arg_playerName then
					playerObj = wingman[w]
					playerId = Unit.getID(playerObj)

					env.info("DCE_getOut B Attempted emergency evacuation of the aircraft ")
					trigger.action.outTextForUnit(playerId, "Attempted emergency evacuation of the aircraft ", 15)

					GetOutGDFM({ playerName, playerObj, playerId })
				end
			end
		end
	end
end

local function getLL_TargetPosition()
	-- trigger.action.outText("DCE_getLL_TargetPosition Init ", 15)
	-- [357797] =
	-- {
	-- 	[1] =
	-- 	{
	-- 		["x"] = -357797,
	-- 		["y"] = 615132,
	-- 	},
	-- 	[2] =
	-- 	{
	-- 		["x"] = 357797,
	-- 		["y"] = 665544,
	-- 	},

	if campL.targetPos then
		-- trigger.action.outText("DCE_getLL_TargetPosition START ", 15)
		for key_x, searchPos_s in pairs(campL.targetPos) do
			for posN, searchPos in pairs(searchPos_s) do
				if searchPos.x and searchPos.y then
					local posXZ = {
						x = searchPos.x,
						y = math.ceil(land.getHeight(searchPos)),
						z = searchPos.y,
					}

					local LLposN, LLposE = coord.LOtoLL(posXZ)
					searchPos.lat = LLposN
					searchPos.lon = LLposE
					searchPos.elevation = posXZ.y
				end
			end
		end
	end

	--export custom mission log
	if campL.targetPos then
		local logStr = "Mission_LL_Positions = " .. TableSerialization(campL.targetPos, 0)
		local logFile = io.open(PathDCE .. "Mission_LL_Positions.lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_Mission_LL_Positions: Failed to open log file for writing.")
		end
	end

	campL.targetPos = nil
	collectgarbage("step", 200) -- on force la libération
end



AddFuncs = function(gId, gObj, playerName)
	env.info("DCE_addFuncs _A gid " .. tostring(gId) ..
	" Group " .. tostring(gObj) .. " argPlayerName: " .. tostring(playerName))

	--si aucun argument, on s'appui sur la liste des joueurs fait maison
	if not gId or not gObj then
		for pName, playerData in pairs(PlayerInOutAircraft or {}) do
			if playerData
				and playerData.gid
				and playerData.groupObject then
				AddFuncs(playerData.gid, playerData.groupObject, pName)
			end
		end
		return -- IMPORTANT
	end

	if gId and gObj then
		if not EWR_optionPlayer[playerName] then
			EWR_optionPlayer[playerName] = {
				EWR_on = false,
			}
		end


		missionCommands.removeItemForGroup(gId, { "Fuel Check" })
		missionCommands.removeItemForGroup(gId, { "Urgent request" })
		missionCommands.removeItemForGroup(gId, { "BullsEye_LongLat" })
		-- missionCommands.removeItemForGroup(arg_Gid, {"EWR"})
		missionCommands.removeItemForGroup(gId, { "Get out of the cockpit" })
		missionCommands.removeItemForGroup(gId, { "CarrierIntoWind" })

		-- Suppression propre via handle
		--"EWR"
		if EWR_menuRootByGroup[gId] then
			missionCommands.removeItemForGroup(gId, EWR_menuRootByGroup[gId])
			EWR_menuRootByGroup[gId] = nil
		end

		-- "SAR"
		if MenuF10ByGroupByCmd[gId] then
			if MenuF10ByGroupByCmd[gId]["SAR"] then
				missionCommands.removeItemForGroup(gId, MenuF10ByGroupByCmd[gId]["SAR"])
			end
		end



		-- ajoute les nouvelles commandes F10 **************************************
		missionCommands.addCommandForGroup(gId, "Fuel Check", nil, FuelCheck, { gid = gId, groupObject = gObj })

		local subR_A = missionCommands.addSubMenuForGroup(gId, "Urgent request", nil)

		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Urgent_Refueling", subR_A, ReFueling,
			gObj)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Urgent_RequestCAP", subR_A,
			RequestCAP, gObj)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Package_All_RTB", subR_A, RtbPack,
			gObj)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Package_Strike_RTB", subR_A,
			RtbStrikePack, gObj)
		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "Package_SEAD_RTB", subR_A,
			RtbSEADPack, gObj)


		radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId, "BullsEye_LongLat", nil, BullsEye,
			gObj)

		local subR_B1 = missionCommands.addSubMenuForGroup(gId, "EWR", nil)
		EWR_menuRootByGroup[gId] = subR_B1
		local subR_B2 = missionCommands.addSubMenuForGroup(gId, "EWR ON", subR_B1)
		local subR_B3 = missionCommands.addSubMenuForGroup(gId, "EWR OFF", subR_B1)
		missionCommands.addCommandForGroup(gId, "Group EWR Status", subR_B1, EWR_Status,
			{ gid = gId, groupObject = gObj })


		local wingmans = gObj:getUnits()
		for unitN, unitObj in ipairs(wingmans) do
			local pName = unitObj:getPlayerName()

			if pName then
				missionCommands.addCommandForGroup(gId, tostring(pName) .. " EWR ON", subR_B2, EWR_ON,
					{ playerName = pName, gid = gId, groupObject = gObj })
				missionCommands.addCommandForGroup(gId, tostring(pName) .. " EWR OFF", subR_B3, EWR_OFF,
					{ playerName = pName, gid = gId, groupObject = gObj })
			else
				env.info("DCE_addFuncs: BUG Unit " ..
				tostring(unitN) ..
				" in group " .. tostring(gId) .. " has no playerName, skipping EWR command creation for this unit.")
			end
		end


		MenuF10ByGroupByCmd[gId] = MenuF10ByGroupByCmd[gId] or {}
		--trouve ici le camp, la coalition du joueur, a partir de son gId ou gObj ou playerName

		local unitsObj = gObj:getUnits()
		local sideName = CoalitionIdToName[unitsObj[1]:getCoalition()] or "blue"
		local freqence = 0
		if campL.EjectedPilotFrequency and campL.EjectedPilotFrequency[sideName] then
			freqence = campL.EjectedPilotFrequency[sideName].radioBeacon or 0
		else
			env.info("DCE_Bug AddFuncs: EjectedPilotFrequency manquant pour side " .. tostring(sideName))
		end
		freqence = freqence / 100000
		MenuF10ByGroupByCmd[gId]["SAR"] = missionCommands.addCommandForGroup(gId,
			"CSAR: Request Survivor Beep " .. tostring(freqence), nil, SAR_fct.menuF10_SAR, { gId, gObj })


		local subR_C1 = missionCommands.addSubMenuForGroup(gId, "Get out of the cockpit", subR_A)
		for unitN, unitObj in ipairs(wingmans) do
			if unitObj and unitObj.isExist and unitObj:isExist() and unitObj.getPlayerName then
				local pName = unitObj:getPlayerName()
				if pName then
					missionCommands.addCommandForGroup(gId, tostring(pName) .. " Get out", subR_C1, getOut,
						{ gObj, pName })
				end
			end
		end

		if campL.SC_CarrierIntoWind == "man" then
			missionCommands.removeItemForGroup(gId, { "CarrierIntoWind" })
			local subR = missionCommands.addSubMenuForGroup(gId, "CarrierIntoWind", nil)

			if campL.Aircraft_Carriers then
				--TODO ajouter une condition side
				for sideCarrier, carriers in ipairs(campL.Aircraft_Carriers) do
					for group_n, carrier in ipairs(carriers) do
						local carrierGroup = Group.getByName(carrier.name)
						if carrierGroup then
							radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId,
								carrier.name .. " Into Wind 30mn", subR, TurnIntoWind, { carrier.name, nil, nil, 30 })
							radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId,
								carrier.name .. " Into Wind 60mn", subR, TurnIntoWind, { carrier.name, nil, nil, 60 })
							radioCommands[#radioCommands + 1] = missionCommands.addCommandForGroup(gId,
								carrier.name .. " Resume Route", subR, ResumeRoute, { carrier.name, nil })
						end
					end
				end
			end
		end

		-- Rappel : on utilise env.mission.coalition car c'est la seule source qui expose toutes les infos, y compris groupId
		-- https://forums.eagle.ru/showthread.php?t=147792&page=15

		if campL.debug then
			local timeSearchEngage = timer.getTime()
			local logStr = "radioCommands = " .. TableSerialization(radioCommands, 0)
			local flightNameClean = "radioCommands"
			local logFile = io.open(
			PathDCE .. "Debug\\" .. flightNameClean .. "_" .. timeSearchEngage .. "_" .. "_radioCommands.lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_addFuncs: Failed to open log file for writing.")
			end
		end
	end
end



--////////////////////////////////////////////////////////////////////////////////////////////
--test EWR (start)
--recupere les data de tous les aéronefs
--////////////////////////////////////////////////////////////////////////////////////////////
-- EWR_speaking(), EWR_magic(), MonitorPlayerAircraftActivity() et EventHandler2 déplacés vers DCE_Background.lua




--sur certaines map en solo (Syria) l'evenement Birth n'est pas detectée
local function timerPlayerMenu(arg)
	if (radioCommands == nil or #radioCommands == 0) and timer.getTime() < 10 then
		local Uid, groupObject, gpGid, playerName
		local playerObj = localGetPlayerObj()
		if playerObj then
			playerName = playerObj:getPlayerName()
			groupObject = playerObj:getGroup()
			gpGid = playerObj:getGroup():getID()
		end

		if gpGid and Group and playerName then
			env.info("DCE_timerPlayerMenu: MAKE addFuncs().")
			AddFuncs(gpGid, groupObject, playerName)
		end
	end
end


--TODO nouvelle fonction a tester
local function _NEW_loopAFAC_CAS()
	if next(AFAC_available) == nil then
		return timer.getTime() + 17
	end

	for _, sideNum in ipairs({ coalition.side.BLUE, coalition.side.RED }) do
		-- résout une seule fois par camp les AFAC de ce camp encore vivants
		-- (avant : Group.getByName / getUnits / isExist refaits pour CHAQUE striker)
		local sideAfacs = {}
		for afacFlightName, afacData in pairs(AFAC_available) do
			if afacData and sideNum == afacData.sideNum then
				local afacGroupObj = Group.getByName(afacFlightName)
				if afacGroupObj then
					local unitsAFAC = afacGroupObj:getUnits()
					local unitAFAC = unitsAFAC and unitsAFAC[1]
					if unitAFAC and unitAFAC:isExist() then
						sideAfacs[#sideAfacs + 1] = {
							name = afacFlightName,
							afacData = afacData, -- référence live (pas une copie), pour garder l'auto-throttling
							unit = unitAFAC,
						}
					end
				end
			end
		end

		if #sideAfacs > 0 then
			local groups = coalition.getGroups(sideNum, Group.Category.AIRPLANE)

			for _, gp in pairs(groups) do
				local gpName = Group.getName(gp)
				if gpName and string.find(gpName, "Strike", 1, true) then
					local strikers = gp:getUnits()
					for wingmanN, unitStriker in ipairs(strikers) do
						if unitStriker and unitStriker:isExist() then
							local unitStrikerVec3 = unitStriker:getPoint()

							for _, afac in ipairs(sideAfacs) do
								local smokeData = afac.afacData.smokeData
								if smokeData and timer.getTime() > (smokeData.time + 300) then
									local afacVec3 = afac.unit:getPoint()
									local dx = afacVec3.x - unitStrikerVec3.x
									local dz = afacVec3.z - unitStrikerVec3.z
									local distance = math.sqrt(dx * dx + dz * dz)

									if distance <= 10000 then
										trigger.action.smoke(smokeData.targetPosVec3, SmokeColor_TargetDesignation)
										AFAC_available[afac.name]["smokeData"] = {
											time = timer.getTime(),
											targetPosVec3 = smokeData.targetPosVec3,
											sideNum = sideNum,
										}
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return timer.getTime() + 17
end

local function loopAFAC_CAS()
	if next(AFAC_available) == nil then
		return timer.getTime() + 17
	end

	for _, sideNum in ipairs({ coalition.side.BLUE, coalition.side.RED }) do
		local groups = coalition.getGroups(sideNum, Group.Category.AIRPLANE)

		for _, gp in pairs(groups) do
			local gpName = Group.getName(gp)
			if string.find(gpName, "Strike") then
				local strikers = gp:getUnits()
				for wingmanN, unitStriker in ipairs(strikers) do
					for afacFlightName, afacData in pairs(AFAC_available) do
						if sideNum == afacData.sideNum then
							if afacData.smokeData and timer.getTime() > (afacData.smokeData.time + 300) then
								local afacGroupObj = Group.getByName(afacFlightName)
								if afacGroupObj then
									local unitsAFAC = afacGroupObj:getUnits()
									local unitAFAC = unitsAFAC[1]

									if unitAFAC and unitAFAC:isExist() then
										local afacVec3 = unitAFAC:getPoint()
										local unitStrikerVec3 = unitStriker:getPoint()
										local distance = math.sqrt((afacVec3.x - unitStrikerVec3.x) ^ 2 +
										(afacVec3.z - unitStrikerVec3.z) ^ 2)

										if distance <= 10000 then
											trigger.action.smoke(afacData.smokeData.targetPosVec3,
												SmokeColor_TargetDesignation)
											AFAC_available[afacFlightName]["smokeData"] = {
												time = timer.getTime(),
												targetPosVec3 = afacData.smokeData.targetPosVec3,
												sideNum = sideNum,
											}
										end
									end
								end
							else

							end
						end
					end
				end
			end
		end
	end
	return timer.getTime() + 17
end




local function loopAFAC()
	local groupObject, gpGid
	local playerObj = localGetPlayerObj()
	if playerObj then
		groupObject = playerObj:getGroup()
		-- gpGid = playerObj:getGroup():getID()
	end

	if gpGid and groupObject then
		-- AFAC_F10(Group)
		timer.scheduleFunction(AFAC_F10, groupObject, timer.getTime() + 2)
	end
	return timer.getTime() + 61
end


--uniquement pour le Bingo?
local function loopPilot()
	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)

	for _, gp in pairs(groups) do
		local gpGid = Group.getID(gp)
		if gpGid and gp then
			bingo(gpGid, gp)
		end
	end

	groups = coalition.getGroups(coalition.side.RED, Group.Category.AIRPLANE)

	for _, gp in pairs(groups) do
		local gpGid = Group.getID(gp)
		if gpGid and gp then
			bingo(gpGid, gp)
		end
	end

	if campL.TableTransportPilotNames and ctld and ctld.alreadyInitialized and not var_TPN_alreadyAdded then
		for n = 1, #campL.TableTransportPilotNames do
			ctld.transportPilotNames[#ctld.transportPilotNames + 1] = campL.TableTransportPilotNames[n]
		end
		env.info("AdCR10 add  ctld.transportPilotNames ")
		var_TPN_alreadyAdded = true
	end


	return timer.getTime() + 120
	-- return timer.getTime() + 10
end


timer.scheduleFunction(buildMissionIndex, nil, timer.getTime() + 0.02)
timer.scheduleFunction(BuildCarrierIndex, nil, timer.getTime() + 0.04)


timer.scheduleFunction(timerPlayerMenu, nil, timer.getTime() + 5)

timer.scheduleFunction(loopPilot, nil, timer.getTime() + 15) --+15

timer.scheduleFunction(loopAFAC, nil, timer.getTime() + 61)

timer.scheduleFunction(loopAFAC_CAS, nil, timer.getTime() + 63)

timer.scheduleFunction(getLL_TargetPosition, nil, timer.getTime() + 21)

timer.scheduleFunction(setErrorMessageBoxShedul, nil, timer.getTime() + 32)

if campL.MsgForPlayerInMsn then
	timer.scheduleFunction(checkMessages, nil, timer.getTime() + 10)
end

-- _affiche(AI.Option.Air.val, "AI.Option.Air.val ")

-- _affiche(DCS_CategoryById, "DCE_DCS_CategoryById ")

-- _affiche(Object.Category, "Object.Category ")

env.info("DCE_ACRF10 END OF LOADING AdCR10 script ")
