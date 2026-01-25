-- auteur : Miguel21
-- 
-- .
------------------------------------------------------------------------------------------------------- 
-- last modification cleanCode_c debug_a
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/SAR.lua"] = "1.4.24"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_c				(c springCleaning)
-- debug_a	 				(a: getOut land.getSurfaceType() error GroundDamagedFlyingMachine)
-- adjustment_g				(if exist)(f don't spawn a manhunt in the ENI camp)(e CVN to CV)(c ajust nb of ManHunt)								
-- modification M61_j		SAR (j noSAR in wrongSide)(i correction 100 to 200m)(g guideTreuilSAR)(e: add MGRS_Chute_10KM)(b debug)
-------------------------------------------------------------------------------------------------------


env.info("DCE_SAR START LOADING SAR.lua "..tostring(versionDCE["Mission Scripts/SAR.lua"]))


local nbManhunt = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
}

local NB_MAX_MANHUNT = 8

local guideSAR = {}
local walkEjectedPilot = {}
local soldierAliasManhunt = {}
local createWreck = {}
local createWreckCrew = {}

-- pathDD = "c:"
-- --prepare campaign path
-- path = string.gsub(camp.path, "/", "\\")																		--replace slashes in campaign path with double-backslashes
-- if  string.sub (camp.path, 2, 2) ~= ":" then																		--si le chemin est differen de C:\Users ou D:\Users
-- 	path = os.getenv('USERPROFILE') .. "\\" .. path																	--get path of windows userprofile and add to campaign path	
-- else
-- 	pathDD = string.sub (camp.path, 1, 2)

-- end
-- path = path .."Mods\\tech\\DCE\\Missions\\Campaigns\\"..camp.title.."\\"											-- modification M35.b version ScriptsMod



-- SAR = {
-- 	helicopter = {
-- 		[1] = "machprout",
-- 		[2] = "machprout2",
-- 	},
-- 	pilotEjected = {
-- 		[1] = {
-- 			name = "ejected1",
-- 			smokeTiming = 0,
-- 			embarked = false,
-- 			embarkAndSafe = false,
-- 		},
-- 		[2] = {
-- 			name = "ejected2",
-- 			smokeTiming = 0,
-- 			embarked = false,
-- 			embarkAndSafe = false,
-- 		},
-- 	}
-- }

--ajoute la table (camp.SAR.pilotEjected) dans SAR  pour n'avoir qu'une seule table
for pilotN, ejectedPilot in ipairs(campL.SAR.pilotEjected) do
	if ejectedPilot and ejectedPilot.MGRS_Chute   then
		if ZoneSAR[ejectedPilot.MGRS_Chute] == nil then
			ZoneSAR[ejectedPilot.MGRS_Chute] = {}
		end
		table.insert( ZoneSAR[ejectedPilot.MGRS_Chute], ejectedPilot)
	end
end

function DespawnSoldierAliasPilot(arg)
	local pilotName = arg[1]
	local embarkation = arg[2]
	local uSAR_Player = arg[3]
	local uSAR_Name = arg[4]


	env.info("DCE_DespawnSoldierAliasPilot START "..tostring(pilotName))

	for MGRS_Chute, zone in pairs(ZoneSAR) do
		for pilotN, ejectedPilot in ipairs(zone) do
			if ejectedPilot.name and ejectedPilot.name == pilotName    then	--and ejectedPilot.embarked ~= true

				env.info( "DCE_SAR: the pilot :"..pilotName.." is on board ".." ejectedPilot.coalitionId: "..tostring(ejectedPilot.coalitionId))
				-- trigger.action.outText("DCE_SAR: the pilot:"..EjectedPilotName.." is on board", 10)

				if ejectedPilot.coalitionId then
					trigger.action.outTextForCoalition(ejectedPilot.coalitionId, "SAR Coalition: the pilot:"..pilotName.." is on board", 10)
				end

				EjectedPilotOnBoard[uSAR_Name] = EjectedPilotOnBoard[uSAR_Name] or {}
				table.insert(EjectedPilotOnBoard[uSAR_Name],pilotName)
				-- _affiche(EjectedPilotOnBoard)

				ejectedPilot.embarked = embarkation
				ejectedPilot.status = "rescued"

				local log_entry = {}
				log_entry.type = "embarkedEjectedPilot"
				log_entry.t = timer.getTime()
				log_entry.targetPilotName = ejectedPilot.pilotName
				log_entry.target = ejectedPilot.name
				log_entry.pilotName = uSAR_Player
				log_entry.initiator = uSAR_Name

				table.insert(CustomLog, log_entry)

				StopRadioTransmission(pilotName)

				local soldier = Unit.getByName(pilotName)

				if soldier and soldier:isExist()  then
					-- if not embarkation or embarkation == nil then
						soldier:destroy()
						env.info("DCE_DespawnSoldierAliasPilot despawn/destroy ")
					-- end
					-- trigger.action.outText("DespawnSoldierAliasPilot "..tostring(EjectedPilot.name), 30)

					StopRadioTransmission(pilotName)

					env.info("DCE_DespawnSoldierAliasPilot FIN "..tostring(pilotName))
				end
			end
		end
	end
end

function AddSoldierAliasPilot(element)

	env.info( "DCE_SAR_AddSoldierAliasPilot name:  "..tostring(element.name).." countryId: "..tostring(element.countryId))

	local hidden = true
	if campL.debug then
		hidden = false
	end

	if element.getOutHelicopter then
		hidden = false
	end

	local addGroup = {
		["visible"] = false,
		["tasks"] =
		{
		}, -- end of ["tasks"]
		["uncontrollable"] = false,
		["task"] = "Pas de sol",
		["taskSelected"] = true,
		["route"] =
		{
			["spans"] =
			{
			}, -- end of ["spans"]
			["points"] =
			{
				[1] =
				{
					-- ["alt"] = tonumber(element.z),
					["alt"] = 0,
					["type"] = "Turning Point",
					["ETA"] = 0,
					["alt_type"] = "BARO",
					["formation_template"] = "",
					["y"] = tonumber(element.pos.y),
					["x"] = tonumber(element.pos.x),
					["ETA_locked"] = true,
					["speed"] = 1,
					["action"] = "Off Road",
					["task"] =
					{
						["id"] = "ComboTask",
						["params"] =
						{
							["tasks"] =
							{
								[1] =
								{
									["number"] = 1,
									["auto"] = false,
									["id"] = "EmbarkToTransport",
									["enabled"] = true,
									["params"] =
									{
										["y"] = tonumber(element.pos.y + 5),
										["x"] = tonumber(element.pos.x + 5),
										["zoneRadius"] = 2000,
									}, -- end of ["params"]
								}, -- end of [1]
								[2] =
								{
									["enabled"] = true,
									["auto"] = false,
									["id"] = "WrappedAction",
									["number"] = 2,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Option",
											["params"] =
											{
												["name"] = 0,
												["value"] = 4,
											}, -- end of ["params"]
										}, -- end of ["action"]
									}, -- end of ["params"]
								}, -- end of [2]
							}, -- end of ["tasks"]
						}, -- end of ["params"]
					}, -- end of ["task"]
					["speed_locked"] = true,
				}, -- end of [1]
				[2] =
				{
					-- ["alt"] = tonumber(element.z),
					["alt"] = 0,
					["type"] = "Turning Point",
					["ETA"] = 5,
					["alt_type"] = "BARO",
					["formation_template"] = "",
					["y"] = tonumber(element.pos.y + 5),
					["x"] = tonumber(element.pos.x + 5),
					["ETA_locked"] = false,
					["speed"] = 1,
					["action"] = "Off Road",
					["task"] =
					{
						["id"] = "ComboTask",
						["params"] =
						{
							["tasks"] =
							{
								[1] =
								{
									["number"] = 1,
									["auto"] = false,
									["id"] = "EmbarkToTransport",
									["enabled"] = true,
									["params"] =
									{
										["y"] = tonumber(element.pos.y + 5),
										["x"] = tonumber(element.pos.x + 5),
										["zoneRadius"] = 2000,
									}, -- end of ["params"]
								}, -- end of [1]
								[2] =
								{
									["enabled"] = true,
									["auto"] = false,
									["id"] = "WrappedAction",
									["number"] = 2,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Option",
											["params"] =
											{
												["name"] = 0,
												["value"] = 4,
											}, -- end of ["params"]
										}, -- end of ["action"]
									}, -- end of ["params"]
								}, -- end of [2]
							}, -- end of ["tasks"]
						}, -- end of ["params"]
					}, -- end of ["task"]
					["speed_locked"] = true,
				}, -- end of [2]
			}, -- end of ["points"]
		}, -- end of ["route"]
		-- ["groupId"] = GenerateID(),
		["hidden"] = hidden,
		["units"] =
		{
			[1] =
			{
				["type"] = "Soldier M4",
				-- ["unitId"] = GenerateID(),
				["livery_id"] = "winter",
				["skill"] = "Average",
				["y"] = tonumber(element.pos.y) + 2,
				["x"] = tonumber(element.pos.x) + 2,
				["name"] = element.name,
				["heading"] = 0,
				["playerCanDrive"] = false,
			}, -- end of [1]
		}, -- end of ["units"]
		["y"] = tonumber(element.pos.y) + 2,
		["x"] = tonumber(element.pos.x) + 2,
		["name"] = "Group_"..tostring(element.name),
		["start_time"] = 0,
	}

	coalition.addGroup(element.countryId, Group.Category.GROUND, addGroup)

	if campL.debug then
		local TimeSearchEngage = timer.getTime() + 5
		local logStr = "AddGroup = " .. TableSerialization(addGroup, 0)
		local ElementNameClean = element.name:gsub('[%p%c%s]', '_')
		local logFile = io.open(PathDCE.."Debug\\"..ElementNameClean.."_"..TimeSearchEngage.."_".. "_AddSoldierAliasPilot.lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_SAR_AddSoldierAliasPilot: Failed to open log file for writing.")
		end

		env.info( "DCE_SAR_AddSoldierAliasPilot write debug file "..tostring(ElementNameClean))
	end

end

function AddSoldierAliasManhunt(ejectedPilot)

	local function AddMultipleSoldier(ejectedPilotName, randomIdCountry, point, n)

		env.info( "DCE_SAR_AddSoldierAliasManhunt A randomIdCountry:  "..tostring(randomIdCountry))

		if not soldierAliasManhunt[randomIdCountry] then soldierAliasManhunt[randomIdCountry] = 0 end

		-- _affiche(soldierAliasManhunt[randomIdCountry], "SoldierAliasManhunt[randomIdCountry]")

		if soldierAliasManhunt[randomIdCountry] > 15 then
			env.info( "DCE_SAR_AddSoldierAliasManhunt Z return:  ")
			return
		end

		env.info( "DCE_SAR_AddSoldierAliasManhunt B ejectedPilotName:  "..tostring(ejectedPilotName).." randomIdCountry: "..tostring(randomIdCountry).." n: "..tostring(n))

		local hidden = true
		if campL.debug then
			hidden = false
		end
		local randomPos = math.random(-15, 15)

		local addGroup = {
			["visible"] = false,
			["tasks"] =
			{
			}, -- end of ["tasks"]
			["uncontrollable"] = false,
			["task"] = "Pas de sol",
			["taskSelected"] = true,
			["route"] =
			{
				["spans"] =
				{
				}, -- end of ["spans"]
				["points"] =
				{
					[1] =
					{
						["alt"] = 0,
						["type"] = "Turning Point",
						["ETA"] = 0,
						["alt_type"] = "BARO",
						["formation_template"] = "",
						["y"] = tonumber(point.y),
						["x"] = tonumber(point.x),
						["ETA_locked"] = true,
						["speed"] = 0,
						["action"] = "Off Road",
						["task"] =
						{
							["id"] = "ComboTask",
							["params"] =
							{
								["tasks"] =
								{
								}, -- end of ["tasks"]
							}, -- end of ["params"]
						}, -- end of ["task"]
						["speed_locked"] = true,
					}, -- end of [1]
				}, -- end of ["points"]
			}, -- end of ["route"]
			-- ["groupId"] = GenerateID(),
			["hidden"] = hidden,
			["units"] =
			{
				-- [1] = 
				-- {
				-- 	["type"] = "Infantry AK ver2",
				-- 	-- ["livery_id"] = "winter",
				-- 	["skill"] = "Average",
				-- 	["y"] = tonumber(point.y) + randomPos,
				-- 	["x"] = tonumber(point.x) + randomPos,
				-- 	["name"] = "Manhunt_"..tostring(ejectedPilotName)..n,
				-- 	["heading"] = 0,
				-- 	["playerCanDrive"] = false,
				-- }, -- end of [1]
				[1] =
				{
					["skill"] = "Average",
					["coldAtStart"] = false,
					["type"] = "tt_DSHK",
					["y"] = tonumber(point.y) + 50 + randomPos,
					["x"] = tonumber(point.x) + 50 + randomPos,
					["name"] = "Manhunt_"..tostring(ejectedPilotName)..n.."_2",
					["heading"] = 0,
					["playerCanDrive"] = false,
				}, -- end of [2]
			}, -- end of ["units"]
			["y"] = tonumber(point.y) + randomPos,
			["x"] = tonumber(point.x) + randomPos,
			["name"] = "Group_Manhunt_"..tostring(ejectedPilotName)..n,
			["start_time"] = 0,
		}

		coalition.addGroup(randomIdCountry, Group.Category.GROUND, addGroup)
		soldierAliasManhunt[randomIdCountry] = soldierAliasManhunt[randomIdCountry] + 1
	end


	local ejectedPilotName = ejectedPilot:getName()
	local ejPilCoalitionId = ejectedPilot:getCoalition()
	local enemyCoalition = 0

	if ejPilCoalitionId == 1 then
		enemyCoalition = 2
	else
		enemyCoalition = 1
	end

	-- coalitionIdNumeric = {
	-- 	[0] = "neutral",
	-- 	[1] = "red",
	-- 	[2] = "blue",
	-- }

	-- _affiche(coalitionIdNumeric, "coalitionIdNumeric")
	local manhuntSide = CoalitionIdToName[enemyCoalition]

	-- env.info( "DCE_SAR_AddSoldierAliasManhunt 01 enemyCoalition:  "..tostring(enemyCoalition).." manhuntSide "..tostring(manhuntSide))

	-- env.info( "DCE_SAR_AddSoldierAliasManhunt C ejectedPilotName:  "..tostring(ejectedPilotName).." ejPilCoalitionId: "..tostring(ejPilCoalitionId).." enemyCoalition: "..tostring(enemyCoalition))
	-- env.info( "DCE_SAR_AddSoldierAliasManhunt D coalitionIdNumeric[enemyCoalition]:  "..tostring(CoalitionIdToName[enemyCoalition]))

	local nMaxCountry = #env.mission.coalition[CoalitionIdToName[enemyCoalition]].country
	local randomNCountry  = math.random(1,nMaxCountry )
	local randomIdCountry = env.mission.coalition[CoalitionIdToName[enemyCoalition]].country[randomNCountry].id
	local posEjectedPilotVec3 = ejectedPilot:getPoint()

	-- env.info( "DCE_SAR_AddSoldierAliasManhunt E randomNCountry:  "..tostring(randomNCountry).." randomIdCountry: "..tostring(randomIdCountry))

	for n = 1, 6 do
		local portionCercle = 60*n
		local distance = math.random(35, 65) * 100
		-- local pointTest = GetOffsetPoint( {x=PosEjectedPilot.x, y=PosEjectedPilot.z}, portionCercle, 5000)
		-- local pointSelected = pointTest
		-- local testLand 

		-- local testAlti = land.getHeight({x = PosEjectedPilot.x, y = PosEjectedPilot.z})
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
		-- local testX = PosEjectedPilot.x
		-- local testY = PosEjectedPilot.z
		local i = 1
		-- local alti 
		local altiSelected = 999999

		local pointSelected = {
			x = posEjectedPilotVec3.x,
			y = posEjectedPilotVec3.z,
			z = posEjectedPilotVec3.y,
        }
		
		repeat

			portionCercle = portionCercle + 1
			-- local distance = math.random(35, 65)
			-- distance = distance * 100
			i = i + 1
			local testPoint = GetOffsetPoint( {x=posEjectedPilotVec3.x, y=posEjectedPilotVec3.z}, portionCercle, distance)
			local testAlti = land.getHeight({testPoint.x, testPoint.y})
			local testLand = land.getSurfaceType({x = testPoint.x, y = testPoint.y})

			if testAlti < altiSelected and (testLand ~= 2 and testLand ~= 3) then
				pointSelected = testPoint
				altiSelected = testAlti
			end

		until  i > 58

		local randomSpawn = false
		local rightSide = false
		if math.random(1, 100) > 50 then
			randomSpawn = true

			--ne spawn pas un manhunt dans le camp ENI, donc on regarde sa position/frontiere
			-- env.info( "DCE_SAR_AddSoldierAliasManhunt F1")

			local rightSideOfBorder
			if campL.boundary and campL.boundary[manhuntSide] and campL.boundary[manhuntSide] ~= nil then
				rightSideOfBorder =  CheckPointInPoly_XY_2(pointSelected, campL.boundary[manhuntSide])
				-- env.info( "DCE_SAR_AddSoldierAliasManhunt?  F2 boundary rightSideOfBorder __"..tostring(rightSideOfBorder).."__ ejectedPilot.side: "..tostring(manhuntSide))
				if rightSideOfBorder  then
					-- env.info( "DCE_SAR_AddSoldierAliasManhunt? G rightSideOfBorder  ")
					rightSide = true
				end
			else
				rightSide = true
			end


		end
		if altiSelected < 999999 and randomSpawn and rightSide then
			env.info( "DCE_SAR_AddSoldierAliasManhunt G ejectedPilotName:  "..tostring(ejectedPilotName).." randomIdCountry: "..tostring(randomIdCountry).." n: "..tostring(n))
			AddMultipleSoldier(ejectedPilotName, randomIdCountry, pointSelected, n)
			nbManhunt[ejPilCoalitionId] = nbManhunt[ejPilCoalitionId] + 1
		end
	end

end	--function AddSoldierAliasManhunt(EjectedPilot)



local function startSAR(arg)

	local arg_flightSAR = arg[1]
	local arg_ejPil = arg[2]

	-- _affiche(arg_flightSAR, "arg_flightSAR")

	local point1 = {
		y = arg_flightSAR.y,
		x = arg_flightSAR.x,
	}
	local current_time = timer.getTime()
	local speed = arg_flightSAR.vAttack
	local distance01 = math.sqrt(math.pow(arg_flightSAR.x - arg_ejPil.pos.x, 2) + math.pow(arg_flightSAR.y - arg_ejPil.pos.y, 2))

	local alt_cruise = arg_flightSAR.hCruise

	--400			10000 https://calculis.net/droite
	--60			1

	-- y = aX + b
	-- y = (0.034 + X ) + 60
	local a = 0.034
	alt_cruise = (0.034 * distance01) + 60
	if alt_cruise > arg_flightSAR.hCruise then
		alt_cruise = arg_flightSAR.hCruise
	end


	local heading1 = GetHeading(arg_flightSAR, { x = arg_ejPil.pos.x, y = arg_ejPil.pos.y })
	local distanceAfterPt2 = distance01/2

	local point2 = GetOffsetPoint(arg_flightSAR, heading1, distanceAfterPt2)
	local point2_z = land.getHeight({x =point2.x, y = point2.y})

	env.info( "DCE_SAR startSAR point_2z "..tostring(point2_z).." heading1: "..tostring(heading1))
	-- trigger.action.outText("SAR startSAR point_2z "..tostring(point_2z).." heading1: "..tostring(heading1), 30)

	local altiTarget = arg_ejPil.pos.z + 100
	if altiTarget < alt_cruise then
		altiTarget = alt_cruise
	end

	local pointData = {}
	pointData = {
		{
			["alt"] = arg_flightSAR.airdromeElevation + 30,
			["name"] = "startSAR()",
			["action"] = "Turning Point",
			["type"] = "Turning Point",
			["alt_type"] = "BARO",
			["speed"] = tonumber(speed),
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
						-- [1] = {
							-- ['enabled'] = true,
							-- ['auto'] = false,
							-- ['id'] = 'WrappedAction',
							-- ['number'] = 1,
							-- ['params'] = {
								-- ['action'] = {
									-- ['id'] = 'Script',
									-- ['params'] = {
										-- ["command"] = "Custom_Altitude(" .. FlightSAR.name .. ")",
									-- },
								-- },
							-- },
						-- },
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["ETA"] = tonumber(current_time) ,
			["ETA_locked"] = true,
			["y"] = point1.y,
			["x"] = point1.x,
			["formation_template"] = "",
			["speed_locked"] = true,
		}, -- end of [1] 
		{
			["alt"] = tonumber(point2_z + 100 ),
			["action"] = "Turning Point",
			["alt_type"] = "BARO",
			["speed"] = tonumber(speed),
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
						[1] = {
							['enabled'] = true,
							['auto'] = false,
							['id'] = 'WrappedAction',
							['number'] = 1,
							['params'] = {
								['action'] = {
									['id'] = 'Script',
									['params'] = {
										["command"] = string.format ("Custom_Altitude('%s',   nil ,  %d)", arg_flightSAR.name, 2),
									},
								},
							},
						},
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = tonumber((distanceAfterPt2 / speed) + current_time) ,
			["ETA_locked"] = false,
			["y"] = point2.y,
			["x"] = point2.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		{
			["alt"] = tonumber(altiTarget),
			["action"] = "Turning Point",
			["alt_type"] = "BARO",
			["speed"] = tonumber(arg_flightSAR.vCruise),
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = tonumber((distance01 / arg_flightSAR.vCruise) + current_time + 500) ,
			["ETA_locked"] = false,
			["y"] = arg_ejPil.pos.y,
			["x"] = arg_ejPil.pos.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		{
			-- ["alt"] = tonumber(alt_cruise + pt_dest.z),
			["alt"] = tonumber(altiTarget),
			["action"] = "Turning Point",
			["alt_type"] = "RADIO",
			["speed"] = tonumber(arg_flightSAR.vCruise),
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
						[1] =
						{

							["enabled"] = true,
							["auto"] = false,
							["id"] = "WrappedAction",
							["number"] = 2,
							["params"] =
							{
								["action"] =
								{
									["id"] = "Script",
									["params"] =
									{
													-- Custom_SAR(grpname, airdrome, airdromeX2d, airdromeY2d, mgrsChute, speed, alt)
										["command"] = string.format("Custom_SAR('%s', '%s', %d, %d, '%s', %d, %d)",
											arg_flightSAR.name,
											arg_flightSAR.airdromeName,
											arg_flightSAR.x,
											arg_flightSAR.y,
											arg_ejPil.MGRS_Chute,
											arg_flightSAR.vCruise,
											alt_cruise
										),
									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [1]			
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = tonumber((distance01 / arg_flightSAR.vCruise) + current_time + 500) ,
			["ETA_locked"] = false,
			["y"] = arg_ejPil.pos.y,
			["x"] = arg_ejPil.pos.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		{
			["alt"] = tonumber(point2_z + 100 ),
			["action"] = "Turning Point",
			["alt_type"] = "BARO",
			["speed"] = tonumber(arg_flightSAR.vCruise),
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = tonumber(((distance01 + distanceAfterPt2) / arg_flightSAR.vCruise) + current_time + 1000) ,
			["ETA_locked"] = false,
			["y"] = arg_ejPil.pos.y,
			["x"] = arg_ejPil.pos.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		{
			["alt"] = tonumber(alt_cruise + arg_flightSAR.airdromeElevation),
			["action"] = "Landing",
			["alt_type"] = "BARO",
			["speed"] =  tonumber(arg_flightSAR.vCruise),
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Land",
			["ETA"] = tonumber( ( ( (distance01 / arg_flightSAR.vCruise) + current_time)*2 )+ 1000 ),
			["ETA_locked"] = false,
			["y"] = point1.y,
			["x"] = point1.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
			['linkUnit'] = tonumber(arg_flightSAR.airdromeId),
			['helipadId'] = tonumber(arg_flightSAR.airdromeId),
		},
	} -- end of ["route"]


	local Mission = {
		id = 'Mission',
		params = {
			route = {
				points = pointData
			}
		}
	}

	-- env.info("DCE_SAR_Start_SAR: arg_flightSAR.name: "..tostring(arg_flightSAR.name))

	local groupSAR_Obj = Group.getByName(arg_flightSAR.name)

	-- env.info("DCE_SAR_Start_SAR: groupSAR_Obj: "..tostring(groupSAR_Obj))

	if groupSAR_Obj then
		-- local ctr = Group.getByName(arg_flightSAR.name):getController()

		local ctr = groupSAR_Obj:getController()
		Controller.setTask(ctr, Mission)

		if campL.debug then
			local logStr = "Start_SAR = " .. TableSerialization(Mission, 0)
			local flightNameClean = arg_flightSAR.name:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_".. "Start_SAR"..current_time..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_SAR_Start_SAR: Failed to open log file for writing.")
			end
		end

		local flight = Group.getByName(arg_flightSAR.name)
		-- local leader = flight:getUnit(1)
		local  gpGid = Group.getID(flight)

		LastInjectFlightPlan[gpGid] = Mission
	end
end


function CheckImmediatSAR(ejPilot)

	local t0 = os.clock()
	Perf_S_N = Perf_S_N + 1

	env.info( "DCE_CheckImmediatSAR START A "..tostring(ejPilot.name))

	if ejPilot and ejPilot.pos.x then
		
		local t = timer.getTime()

		ejPilot.type = "ejectedPilot"
		-- pilot.x = pilot.x
		-- pilot.y = pilot.z
		-- pilot.z = land.getHeight({x = pilot.x, y = pilot.z})

        ejPilot.date = {
			hour = campL.date.hour,
			month = campL.date.month,
            day = campL.date.day,
			year = campL.date.year
		}


		ejPilot.nameId = ejPilot.initiatorMissionID
		ejPilot.groupSAR = ""
		ejPilot.status = "MIA"
		-- ejPilot.sideName = ejPilot.initiatorSideName
		-- ejPilot.country = ejPilot.initiatorCountry

		ejPilot.embarkAndSafe = false
		ejPilot.smokeTiming = 0
		ejPilot.embarked = false
		ejPilot.landingPossible = false

        ejPilot.dataPOW = {
            initChoicePOW = false,
			ejectNbDay = 0,
			POW_nextDayCheck = 2,
			PowDayMax = math.random(3, 15),
		}

		ejPilot.radio_start = 0

		--si ejectedPilot est chez l'ENI, on ne lance pas de SAR
		-- on lancera une CSAR dans les missions suivantes

		local wrongSide = false
		local ENI_Side = DCS_ENI_Side[ejPilot.sideName]
		if campL.boundary and campL.boundary[ENI_Side] and campL.boundary[ENI_Side] ~= nil then
			wrongSide = CheckPointInPoly_XY_2({x=ejPilot.pos.x,y=ejPilot.pos.y} , campL.boundary[ENI_Side])
			env.info( "DCE_CheckImmediatSAR C ?  boundary wrongSide ? __"..tostring(wrongSide))
			if wrongSide  then
                env.info("DCE_CheckImmediatSAR? D boundary rightSideOfBorder __FALSE__ Return ")
				local dt = os.clock() - t0
				Perf_S = Perf_S + dt
				return
			end
		end

		--si ejectedPilot sur une VILLE on ne lance pas de SAR ni de CSAR
		local nameTheatre =  string.lower(env.mission.theatre)
		env.info( "DCE_CheckImmediatSAR? NameTheatre "..tostring(nameTheatre))
		if circleCity and circleCity[nameTheatre] then
			env.info( "DCE_CheckImmediatSAR? Passe 1 NameTheatre  ")

			for nCircle, circle in ipairs(circleCity[nameTheatre]) do
				--voir le code identique sur DC_UpdateSAR.lua

				local mission2d_x = 58538.7 - (47.2304 * circle.pixel_y )
				local mission2d_y = (47.2287 * circle.pixel_x) + 70914

				-- env.info( "CheckImmediatSAR? Passe 2  mission2d_x: "..tostring(mission2d_x).." |mission2d_y: "..tostring(mission2d_y))

				if math.abs(ejPilot.pos.x - mission2d_x) <= 50000 and math.abs(ejPilot.pos.y - mission2d_y) <= 50000 then
					env.info( "DCE_CheckImmediatSAR? Passe 3 <= 50000  ")

					local result = math.pow ((ejPilot.pos.x - mission2d_x), 2) + math.pow((ejPilot.pos.y - mission2d_y), 2) <= math.pow((circle.radius * 47.229042083728), 2)
					env.info( "DCE_CheckImmediatSAR? Passe 4 result?  "..tostring(result))

					local debugA = type(result)
					env.info( "DCE_CheckImmediatSAR? Passe 5 debugA?  "..tostring(debugA))

					if result then

						--le soldierejectedPilot est déjà dans une zone CITY 
						-- pas de SAR ni CSAR

						-- rightSideOfBorder =  CheckPointInPoly_XY_2(pointSelected, camp.boundary[manhuntSide])

						local rightSideOfBorder
						if campL.boundary and campL.boundary[ejPilot.sideName] and campL.boundary[ejPilot.sideName] ~= nil then
							rightSideOfBorder =  CheckPointInPoly_XY_2({x=ejPilot.pos.x,y=ejPilot.pos.y}, campL.boundary[ejPilot.sideName])

						end

						env.info("DCE_SAR zone CITY rightSideOfBorde B? "..tostring(rightSideOfBorder))
						if rightSideOfBorder then
							ejPilot.status = "Rescued"
							env.info("DCE_SAR zone CITY Rescued B ")
						else
							ejPilot.status = "MIA"
							env.info("DCE_SAR zone CITY POW B ")
						end

                        ejPilot.landingPossible = false
						local dt = os.clock() - t0
						Perf_S = Perf_S + dt
						return

					end
				end

			end
		end

		--regarde la partie aéronaval, pour voir si c'est le pedro qui y va

		local groups = coalition.getGroups(ejPilot.coalitionId, Group.Category.SHIP)
		local selected_distance = 60000
		local selectedPoint = {}

		for i, gp in pairs(groups) do

			local units = gp:getUnits()
			local _unit = units[1]
			-- local gpName = Group.getName(gp)
			local uName = Unit.getName(_unit)

			if string.find(uName,"CV") or string.find(uName,"LHA")  then

				-- local callsign = _unit:getCallsign()
				-- local ShipTypeName = _unit:getTypeName()
				local baseHelico = {
					x=0,
					y=0,
					z=0,
					name = "",
					Id = 0,
				}

				local uId = _unit:getID()

				local tempPointVec3 = _unit:getPoint()
				baseHelico.x = tempPointVec3.x
				baseHelico.y = tempPointVec3.z
				baseHelico.z = tempPointVec3.y
				baseHelico.name = uName
				baseHelico.Id = tonumber(uId)

				-- local description = _unit:getDesc()

				if _unit:isActive() then
					local distance = math.sqrt(math.pow(baseHelico.x - ejPilot.pos.x, 2) + math.pow(baseHelico.y - ejPilot.pos.y, 2))
					if distance < selected_distance then
						selected_distance = distance
						selectedPoint = baseHelico
					end
				end
			end
		end

		local chute = ZoneSAR[ejPilot.MGRS_Chute]
		
		--si le crash est proche du CV, c'est le pedro qui y va
		if selected_distance < 6000 then
			env.info( "DCE_CheckImmediatSAR? EE <6000 donc AERONAVAL?   ")
			--temp de reaction en fonction de la distance
			--6000 -> 30 s
			--m 	-> x s
			local tempReact = (selected_distance * 30) / 6000
			timer.scheduleFunction(PedroSAR, {selectedPoint, ejPilot.pos}, timer.getTime() + tempReact)

		elseif chute and (not chute.groupSAR or chute.groupSAR == "") then

			env.info( "DCE_CheckImmediatSAR? FFa >6000 donc TERRESTRE?   ")

			-- _affiche(ejPilot, "ejPilot ")
			
			--find all flights in range to Ejected Pilot and hover ceiling
			local eligible_flights = {}
			if ejPilot.sideName then
				for baseName, base in pairs(campL.SAR.alertSAR[ejPilot.sideName].base) do
					env.info( "DCE_CheckImmediatSAR? FFb  base_name "..tostring(baseName))
					for flightN, flightSAR in ipairs(base.ready) do

						local distance = math.sqrt(math.pow(flightSAR.x - ejPilot.pos.x, 2) + math.pow(flightSAR.y - ejPilot.pos.y, 2))

						if distance >= flightSAR.range  then
							env.info( "DCE_CheckImmediatSAR? trop loin : "..tostring(distance).." > flight.range: "..tostring(flightSAR.range))
						end

						if ejPilot.pos.z >= flightSAR.hHover then
							env.info( "DCE_CheckImmediatSAR? trop haut : "..tostring(ejPilot.pos.z).." > flight.hHover: "..tostring(flightSAR.hHover))
						end

						if distance < flightSAR.range and ejPilot.pos.z < flightSAR.hHover then
							eligible_flights[flightSAR.name] = distance
							env.info( "DCE_CheckImmediatSAR? FFc eligible_flights?   "..tostring(flightSAR.name).."|distance: "..tostring(distance))
						end
					end
				end
			else
				env.info( "DCE_CheckImmediatSAR? DCE_ERROR  no ejPilot.sideName "..tostring(ejPilot.sideName))
			end

			env.info( "DCE_CheckImmediatSAR? interB   ")
			-- _affiche(eligible_flights, "eligible_flights interB")

			--select the flight closest to rescue Ejected Pilot
			local selected_flight
			local test_distance = 9999999
			for flight_name, distance in pairs(eligible_flights) do
				if distance < test_distance then
					selected_flight = flight_name
					test_distance = distance
					--TODO ajouter ici une table de plusieurs choix de SAR
					env.info( "DCE_CheckImmediatSAR? HH selected_flight?   "..tostring(selected_flight))
				end
			end

			env.info( "DCE_CheckImmediatSAR? interC  selected_flight  "..tostring(selected_flight))

			--assign selected flight to rescue
			if selected_flight then
				env.info( "DCE_CheckImmediatSAR? II   ")
				for base_name, base in pairs(campL.SAR.alertSAR[ejPilot.sideName].base) do
					for flight_n, flightSAR in pairs(base.ready) do
						if flightSAR.name == selected_flight then
							env.info( "CheckImmediatSAR? JJ    selected_flight: "..tostring(selected_flight))
							trigger.action.setUserFlag(flightSAR.flag, true)		--set flag true to launch SAR Alert					

							env.info( "DCE_CheckImmediatSAR? YY launch SAR Alert ejPilot.side:  "..tostring(ejPilot.sideName).." flightSAR.name: "..tostring(flightSAR.name).." chute.MGRS_Chute_10KM: "..tostring(chute.MGRS_Chute_10KM).." flight_n: "..tostring(flight_n).." base_name: "..tostring(base_name))
							trigger.action.outTextForCoalition(CoalitionNameToId[ejPilot.sideName], "SAR pilot:  " ..tostring(flightSAR.name), 60 , true)
							trigger.action.outTextForCoalition(CoalitionNameToId[ejPilot.sideName], "move your ass to recover the ejected pilot at the location, ASAP: " ..tostring(chute.MGRS_Chute_10KM), 60 , false)

							timer.scheduleFunction(startSAR, {flightSAR, ejPilot}, timer.getTime() + 30)

							if not ZoneSAR[ejPilot.MGRS_Chute].groupSAR or ZoneSAR[ejPilot.MGRS_Chute].groupSAR == nil then
								ZoneSAR[ejPilot.MGRS_Chute].groupSAR = "Group_"..flightSAR.name
							end

							table.insert(campL.SAR.alertSAR[ejPilot.sideName].assigned, flightSAR )
							table.remove( campL.SAR.alertSAR[ejPilot.sideName].base[base_name].ready, flight_n)											--move flight from ready to assigned status
						end
					end
				end
			end
		end
	end

	local dt = os.clock() - t0
    Perf_S = Perf_S + dt
	env.info("DCE_CheckImmediatSAR FIN Z " .. tostring(ejPilot.name) .. " dt " .. tostring(dt))
end

--{selectedPoint, ejectedPilot}
function PedroSAR(arg)
	local arg_pt_start = arg[1]
	local arg_pt_dest = arg[2]

	local nb
	if not ListPedro[arg_pt_start.name] then
		nb = 1
	else
		nb = #ListPedro[arg_pt_start.name]
	end

	_affiche(ListPedro, "DCE_PedroSAR A0 ListPedro")

	-- ["name"] = "Unit_Pedro_CV-59 Forrestal_1",
	-- Pedro_CV-59 Forrestal_1
	-- Unit_Pedro_CV-59 Forrestal_1

	local name = tostring(arg_pt_start.name).."_"..tostring(nb)
	local unitName = "Unit_Pedro_"..name
	local groupName = "Group_Pedro_"..name

	env.info("DCE_PedroSAR A name: "..tostring(name).." unitName: "..tostring(unitName).." groupName: "..tostring(groupName))

	local current_time = timer.getTime() +1
	local speed = 75		-- v = m/s 46

	local uPedro = Unit.getByName(unitName)

	if not uPedro then 
		env.info("DCE_PedroSAR B return name: "..tostring(name))
		return
	end

	local tempPointVec3 = uPedro:getPoint()
	arg_pt_start.x = tempPointVec3.x
	arg_pt_start.y = tempPointVec3.z
	arg_pt_start.z = tempPointVec3.y

	local alt = 60

	local distance01 = math.sqrt(math.pow(arg_pt_start.x - arg_pt_dest.x, 2) + math.pow(arg_pt_start.y - arg_pt_dest.y, 2))		--distance between tanker and player
	-- local destName
	-- if not pt_dest.name or pt_dest.name == "" then
	-- 	destName = math.floor(pt_dest.x)
	-- else
	-- 	destName = pt_dest.name
	-- end

	local route = {}
	route = {
			[1] =
			{
				["alt"] = arg_pt_start.z,
				["action"] = "Turning Point",
				["type"] = "Turning Point",
				["alt_type"] = "BARO",
				["speed"] = speed,
				["task"] =
				{
					["id"] = "ComboTask",
					["params"] =
					{
						["tasks"] =
						{
							[1] = {
								['enabled'] = true,
								['auto'] = false,
								['id'] = 'WrappedAction',
								['number'] = 1,
								['params'] = {
									['action'] = {
										['id'] = 'Script',
										['params'] = {
                                        -- ["command"] = "Custom_Altitude(" .. groupName .. ",    nil  , " .. "1" .. ")",
										["command"] = string.format("Custom_Altitude('%s',   nil ,  %d)",
											groupName, 1),
										},
									},
								},
							},
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
				["ETA"] = current_time ,
				["ETA_locked"] = true,
				["y"] = arg_pt_start.y,
				["x"] = arg_pt_start.x,
				["name"] = "",
				["formation_template"] = "",
				["speed_locked"] = true,
			}, -- end of [1]  
		[2] =
		{
			["alt"] = alt,
			["action"] = "Turning Point",
			["alt_type"] = "BARO",
			["name"] = "IP",
			["speed"] = speed,
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = (distance01 / speed) + current_time ,
			["ETA_locked"] = false,
			["y"] = arg_pt_dest.y,
			["x"] = arg_pt_dest.x,
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		[3] =
		{
			["alt"] = alt,
			["action"] = "Turning Point",
			['name'] = 'Attack',
			["alt_type"] = "BARO",
			["speed"] = speed,
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
						[1] =
						{
							["number"] = 1,
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
										["speedEdited"] = true,
										["pattern"] = "Circle",
										["speed"] = 0,		--["speed"] = 0.27777777777778,
										["altitude"] = 10,
										["altitudeEdited"] = true,
									}, -- end of ["params"]
								}, -- end of ["task"]
								["stopCondition"] =
								{
									["duration"] = 150,
								}, -- end of ["stopCondition"]
							}, -- end of ["params"]
						}, -- end of [1]
						-- [2] =
						-- {
						-- 	["enabled"] = true,
						-- 	["auto"] = false,
						-- 	["id"] = "WrappedAction",
						-- 	["number"] = 2,
						-- 	["params"] =
						-- 	{
						-- 		["action"] =
						-- 		{
						-- 			["id"] = "Script",
						-- 			["params"] =
						-- 			{
						-- 				-- ["command"] = "Custom_RTB_2_Base(\"Group_Pedro_CV-71 Theodore Roosevelt_1\",  \"CV-71 Theodore Roosevelt\",  \"46.25\",  \"60\")",
						-- 				["command"] = 'Custom_RTB_2_Base("' .. groupName .. '",  "' .. pt_start.name .. '",  "' .. speed .. '",  "' .. alt ..  '")',
						-- 			}, -- end of ["params"]
						-- 		}, -- end of ["action"]
						-- 	}, -- end of ["params"]
						-- }, -- end of [2]
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = (distance01 / speed) + current_time ,
			["ETA_locked"] = false,
			["y"] = arg_pt_dest.y,
			["x"] = arg_pt_dest.x,
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		[4] =
		{
			["alt"] = alt,
			["action"] = "Turning Point",
			["alt_type"] = "BARO",
			["speed"] = speed,
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
						["enabled"] = true,
						["auto"] = false,
						["id"] = "WrappedAction",
						["number"] = 1,
						["params"] =
						{
							["action"] =
							{
								["id"] = "Script",
								["params"] =
								{
									["command"] = "Custom_RTB_2_Base(" .. groupName .. ",  " .. arg_pt_start.name .. ",  " .. speed .. ",  " .. alt ..  ")",
								},
							},
						},
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = (distance01 / speed) + current_time ,
			["ETA_locked"] = false,
			["y"] = arg_pt_dest.y,
			["x"] = arg_pt_dest.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		[5] =
		{
			["alt"] = alt,
			["action"] = "Landing",
			["alt_type"] = "BARO",
			["speed"] = speed,
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
						["enabled"] = true,
						["auto"] = false,
						["id"] = "WrappedAction",
						["number"] = 1,
						["params"] =
						{
							["action"] =
							{
								["id"] = "Script",
								["params"] =
								{
									["command"] = 'Custom_RTB_2_Base("' .. groupName .. '",  "' .. arg_pt_start.name .. '",  "' .. speed .. '",  "' .. alt ..  '")',
								},
							},
						},
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Land",
			["ETA"] = ((distance01 / speed) + current_time)*2,
			["ETA_locked"] = false,
			["y"] = arg_pt_start.y,
			["x"] = arg_pt_start.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
			['linkUnit'] = arg_pt_start.Id,
			['helipadId'] = arg_pt_start.Id,
		}
	} -- end of ["route"]


	local mission = {
		id = 'Mission',
		params = {
			route = {
				points = route
			}
		}
	}

	local ctr = Group.getByName(groupName):getController()

	ctr:resetTask()
	ctr:setTask(mission)

end	--function PedroSAR(arg)



local function checkAddingManhunt()
	-- if 1==1 then
	-- 	return
	-- end
	local nbOfTargetMan = {}
	for MGRS_Chute, zone in pairs(ZoneSAR) do
		if not nbOfTargetMan[MGRS_Chute] then nbOfTargetMan[MGRS_Chute] = 0 end
		for N_Pilot, ejPil in ipairs(zone) do
			if ejPil.name and ejPil.embarked ~= true and ( not nbOfTargetMan[MGRS_Chute] or nbOfTargetMan[MGRS_Chute] < 2 )   then
				local unitEjPil = Unit.getByName(ejPil.name)

				if unitEjPil and ejPil.coalitionId and nbManhunt[ejPil.coalitionId] and nbManhunt[ejPil.coalitionId] < NB_MAX_MANHUNT then
					env.info( "")
					env.info( "DCE_SAR:checkAddingManhunt   ejectedPilot.name | "..tostring(ejPil.name).." ejectedPilot.inTheEnemyCamp "..tostring( ejPil.inTheEnemyCamp))

					local rightSideOfBorder
					if campL.boundary and campL.boundary[ejPil.sideName] and campL.boundary[ejPil.sideName] ~= nil then
						rightSideOfBorder = CheckPointInPoly_XY_2(ejPil.pos, campL.boundary[ejPil.sideName])
						env.info( "DCE_checkAddingManhunt?  CCC boundary rightSideOfBorder __"..tostring(rightSideOfBorder).."__ ejectedPilot.sideName: "..tostring(ejPil.sideName))
						
                        if rightSideOfBorder == nil or rightSideOfBorder == false then
                            ejPil.inTheEnemyCamp = true
                            env.info("DCE_checkAddingManhunt? DDD boundary  ejectedPilot.inTheEnemyCamp = true  ")
                        end
						
					end

					if ejPil.inTheEnemyCamp then

						env.info( "DCE_SAR:checkAddingManhunt EEE "..tostring(MGRS_Chute).." | "..tostring(ejPil.name))
						env.info( "DCE_SAR:checkAddingManhunt timer.scheduleFunction(DespawnSoldierAliasPilot "..tostring(ejPil.name))

						timer.scheduleFunction(AddSoldierAliasManhunt, unitEjPil, timer.getTime() + 2)
						nbOfTargetMan[MGRS_Chute] = nbOfTargetMan[MGRS_Chute] + 1
					end

				end
			end
		end
	end

	env.info( "DCE_FIN LOAD checkAddingManhunt   ")
	-- trigger.action.outText("FIN LOAD  checkAddingManhunt ", 30)

end

function LoopManagedRadioTransmission()
	for MGRS_Chute, zone in pairs(ZoneSAR) do
		for pilotN, ejPil in ipairs(zone) do
			if ejPil.name and (not ejPil.radio_on or ejPil.radio_on == nil) and ejPil.embarked ~= true   then

				local unitEjPil = Unit.getByName(ejPil.name)
				local actualTime = timer.getTime()

				-- env.info( "LoopManagedRadioTransmission D "..tostring(unitEjectPilot).."|"..tostring(ejectedPilot.radio_start).."|"..tostring("<?").."|"..tostring(actualTime).."|")

				
				if unitEjPil and ejPil.radio_start and ejPil.radio_start <= actualTime then

					local ejPilPosVec3 = unitEjPil:getPoint()

					local pilotVec3 = {
						x = ejPilPosVec3.x,
						y = land.getHeight({x = ejPilPosVec3.x, y = ejPilPosVec3.z}),
						z = ejPilPosVec3.z,
					}

					-- env.info( "LoopManagedRadioTransmission D "..tostring(ejPil.sideName))
					-- _affiche(ejPil, "LoopManagedRadioT ejPil")

					local modulation = 0	--AM
					if campL.EjectedPilotFrequency[ejPil.sideName].radioBeacon < 90000000 then
						modulation = 1	--FM
					end

					trigger.action.radioTransmission('l10n/DEFAULT/beacon.ogg', pilotVec3, modulation, true, campL.EjectedPilotFrequency[ejPil.sideName].radioBeacon, RadioWatt, 'radioBeacon_'..ejPil.name)
					ejPil.radio_on = true

					env.info( "DCE_SAR:LoopManagedRadioTransmission E frequency  "..tostring(campL.EjectedPilotFrequency[ejPil.sideName].radioBeacon).." MGRS_Chute: "..tostring(ejPil.MGRS_Chute).." |MGRS_Chute_10KM: "..tostring(ejPil.MGRS_Chute_10KM).." "..tostring('radio_'..ejPil.name))

				end
			end
		end
	end
	return timer.getTime() + 60
end

function StopRadioTransmission(PilotName)

	trigger.action.stopRadioTransmission('radioBeacon_'..PilotName)

	env.info( "DCE_RADIO StopRadioTransmission  "..tostring('radioBeacon_'..PilotName))



end

function StopRadioTransmissionSeat()

	-- ejectionSeatTemp = {
	-- 	radio_on = true,
	-- 	time_on = log_entry.t,
	-- 	name = PilotEjection.initiator,
	-- }

	local time = timer.getTime()

	if EjectionSeatFrequency and #EjectionSeatFrequency >= 1 then
		for n, ejected in pairs(EjectionSeatFrequency) do
			if ejected.radio_on then
				if time > (ejected.time_on + 60) then
					trigger.action.stopRadioTransmission('GuardEjection'..ejected.name)
					ejected.radio_on = false
				end
			end
		end
	end
	return timer.getTime() + 5
end


local function detectsEjectedPilotEmbarkation(arg_uSAR, arg_ejPil_tab)

	local outFonction = false
	local uSAR_unitId = Unit.getID(arg_uSAR)
	local uSAR_Player = arg_uSAR:getPlayerName()
	local uSAR_Name = arg_uSAR:getName()

	env.info( "DCE_SAR:_SAR_Player embarkation AA ")
	-- _affiche(arg_uSAR, "DCE_SAR unitSAR")
	-- _affiche(arg_ejPil_tab, "DCE_SAR ejectedPilot")

	local function walk()

		if not arg_uSAR or not arg_uSAR:isActive() or not arg_uSAR:isExist() then
			env.info( "DCE_SAR:_SAR_Player embarkation AA2 RETURN : "..tostring(uSAR_Player))
			return
		end

		env.info( "DCE_SAR:_SAR_Player embarkation BB ")

		local unitEjPil = Unit.getByName(arg_ejPil_tab.name)
		local ejPilPosVec3
        if unitEjPil then
            ejPilPosVec3 = unitEjPil:getPoint()
        else
            -- Gérer le cas où l'unité n'existe pas
			env.info("CE_SAR:_SAR_Player unitEjectPilot est nil")
			return
        end

		local pos_SAR_vec3 = arg_uSAR:getPoint()
		local uSAR_inAir = arg_uSAR:inAir()

		local distance = math.ceil(math.sqrt(math.pow(pos_SAR_vec3.x - ejPilPosVec3.x, 2) + math.pow(pos_SAR_vec3.z - ejPilPosVec3.z, 2)))

		trigger.action.outTextForUnit( uSAR_unitId , "PilotEmbarkation Embarkation Distance: "..tostring(distance).." (must be <200m)" , 2 , true)

		env.info( "DCE_SAR:_SAR_Player BB2 _SARinAir : "..tostring(uSAR_inAir))

		if distance <= 200 and not uSAR_inAir then
			env.info( "DCE_SAR:_SAR_Player SAR : "..tostring(uSAR_Player).." PilotEmbarkation PASSE CC _SARinAir "..tostring(uSAR_inAir))

			trigger.action.outTextForUnit( uSAR_unitId , "PilotEmbarkation Use airborne troops for on-boarding" , 2 , false)

			if distance <= 20 then
				env.info( "DCE_SAR:_SAR_Player SAR : "..tostring(uSAR_Player).." PilotEmbarkation & StopRadioTransmission PASSE DD "..tostring(arg_ejPil_tab.name))
				-- trigger.action.outTextForUnit( SAR_unitId , "DCE_SAR:_SAR_Player PilotEmbarkation & StopRadioTransmission PASSE DD "..tostring(ejectedPilot.name) , 15 , false)
				local embarkation = true
				DespawnSoldierAliasPilot({arg_ejPil_tab.name, embarkation, uSAR_Player, uSAR_Name  } )
				-- StopRadioTransmission(ejectedPilot.name)
				outFonction = true
				-- _affiche(EjectedPilotOnBoard)

				walkEjectedPilot[uSAR_unitId] = false
				return
			end

		elseif distance > 200 or uSAR_inAir then
			env.info( "DCE_SAR:_SAR_Player SAR : "..tostring(uSAR_Player).."PilotEmbarkation PASSE EE ")
			outFonction = true
			walkEjectedPilot[uSAR_unitId] = false
			return
		end

		env.info( "DCE_SAR:_SAR_Player SAR : "..tostring(uSAR_Player).." PilotEmbarkation PASSE FF ")
		return timer.getTime() + 1
	end

	if outFonction then
		walkEjectedPilot[uSAR_unitId] = false
		return
	end

	--si c'est un joueur, on s'assure qu'il occupe bien l'helico SAR
	if uSAR_Player and PlayerInOutAircraft[uSAR_Player] then
		timer.scheduleFunction(walk, nil, timer.getTime() + 1)
    else
		env.info( "DCE_SAR:_SAR_Player no embarkation GG RETURN no player in SAR : "..tostring(uSAR_Player))
		return
	end

	if arg_uSAR.isExist and arg_uSAR:isExist() and arg_uSAR.isActive and arg_uSAR:isActive() then
		timer.scheduleFunction(walk, nil, timer.getTime() + 1)
	else
		return
	end

end

--guide le pilote humain SAR vers l ejectedPilot
local function guideTreuilSAR(arg_uSAR, arg_EjPilPosVec3, arg_EjPil_tab)

	local outFonction = false
	local uSAR_unitId = Unit.getID(arg_uSAR)
	local uSAR_Player = arg_uSAR:getPlayerName()
	local uSAR_Name = arg_uSAR:getName()

	local function guidage()

		local pos_SAR_vec3 = arg_uSAR:getPoint()
		local distance = math.ceil(math.sqrt(math.pow(pos_SAR_vec3.x - arg_EjPilPosVec3.x, 2) + math.pow(pos_SAR_vec3.z - arg_EjPilPosVec3.z, 2)))

		local ejectedPilot_h = land.getHeight({x = arg_EjPilPosVec3.x, y = arg_EjPilPosVec3.z})

		local uSAR_h = math.ceil(pos_SAR_vec3.y)
		local uSAR_inAir = arg_uSAR:inAir()

		-- local unitSarPos = unitSAR:getPosition()
   		-- local bearing_rad = math.atan2(unitSarPos.x.z, unitSarPos.x.x))
		-- if bearing_rad < 0 then
		-- 	bearing_rad = bearing_rad + (2 * math.pi) 
		-- end
		-- local bearing = math.ceil(math.deg(bearing_rad))


		-- --    local group_1_pos = Group.getByName('group_1'):getUnits()[1]:getPoint()
		-- --    local group_2_pos = Group.getByName('group_2'):getUnits()[1]:getPoint()
		-- --    local distance = ((group_1_pos.x - group_2_pos.x)^2 + (group_1_pos.z - group_2_pos.z)^2)^0.5
		-- local bearing_vector = {
		-- 	x = PosEjectedPilot.x - Pos_SAR.x, 
		-- 	y = PosEjectedPilot.y - Pos_SAR.y, 
		-- 	z = PosEjectedPilot.z - Pos_SAR.z
		-- 	}
		-- local bearing_rad = math.atan2(bearing_vector.z, bearing_vector.x)
		-- if bearing_rad < 0 then
		-- 		bearing_rad = bearing_rad + (2 * math.pi) 
		-- end
		-- local bearing = math.ceil(math.deg(bearing_rad))

		local bearing_vector = {
			x = arg_EjPilPosVec3.x - pos_SAR_vec3.x,
			y = arg_EjPilPosVec3.y - pos_SAR_vec3.y,
			z = arg_EjPilPosVec3.z - pos_SAR_vec3.z
			}
		local bearing_rad = math.atan2(bearing_vector.z, bearing_vector.x)
		if bearing_rad < 0 then
				bearing_rad = bearing_rad + (2 * math.pi)
		end
		local bearing = math.ceil(math.deg(bearing_rad))
		local high = math.ceil(uSAR_h - ejectedPilot_h)
		trigger.action.outTextForUnit( uSAR_unitId , "Helitacking Distance: "..tostring(distance).." (need <10m) High: "..tostring(high).." (need <45m) Bearing: "..tostring(bearing) , 2 , true)

		if distance <= 10 and high <=45 then

			local speed = Object.getVelocity(arg_uSAR)
			speed = math.sqrt(speed.x^2 + speed.y^2 + speed.z^2)
			speed = math.ceil(speed * 10)/10

			trigger.action.outTextForUnit( uSAR_unitId , "Speed: "..tostring(speed) .." ( need < 0.2)" , 2 , false)

			if speed <= 0.2 then
				local embarkation = false	--il n'est pas embarqué au sol, mais helitreuillé
				DespawnSoldierAliasPilot({arg_EjPil_tab.name, embarkation, uSAR_Player, uSAR_Name})
				-- EjectedPilotOnBoard[SAR_Name] = EjectedPilotOnBoard[SAR_Name] or {}
				-- table.insert(EjectedPilotOnBoard[SAR_Name],ejectedPilot.name)
				-- _affiche(EjectedPilotOnBoard)
				outFonction = true
				guideSAR[uSAR_unitId] = false
				return
			end

		elseif distance > 100 or not uSAR_inAir then	-- high <= 2
			outFonction = true
			guideSAR[uSAR_unitId] = false
			return
		end
		return timer.getTime() + 1
	end

	if outFonction then
		guideSAR[uSAR_unitId] = false
		return
	end

	--si l helico n est pas posé
	if not walkEjectedPilot[uSAR_unitId] or walkEjectedPilot[uSAR_unitId] == nil then
		timer.scheduleFunction(guidage, nil, timer.getTime() + 1)
	end
end

function LoopSAR()

	local t0
    if campL.debug then
        t0 = os.clock()
		Perf_D_N = Perf_D_N + 1
    end
	
	--** allume le fumigene lorsque la SAR est proche
	--** déclare le pilote dans l'helico meme s'il ne peut pas se poser

	-- TODO  Pilot no KIA si MERe and EJECTION and PilotSEPARATION a faire dans DEBRIEF_StatEvaluation
	-- TODO ajouter le son scramble


	-- SAR = {
	-- 	helicopter = {
	-- 		[1] = "machprout",
	-- 		[2] = "machprout2",
	-- 	},
	-- 	pilotEjected = {
	-- 		[1] = {
	-- 			name = "ejected1",
	-- 			smokeTiming = 0,
	-- 			embarked = false,
	-- 			embarkAndSafe = false,
	-- 		},
	-- 		[2] = {
	-- 			name = "ejected2",
	-- 			smokeTiming = 0,
	-- 			embarked = false,
	-- 			embarkAndSafe = false,
	-- 		},
	-- 	}
	-- }


	for coalName, coal in pairs(env.mission.coalition) do
		for countryN, country in ipairs(coal.country) do
			if country.helicopter then
				for groupN, group in ipairs(country.helicopter.group) do
					local gpSAR = Group.getByName(group.name)

					if gpSAR then
						

						local units_SAR = gpSAR:getUnits()
						local unitSAR
						local sar_CoalitionId

						-- env.info("DCE_LoopSAR E units_SAR "..tostring(units_SAR))

						if units_SAR then
							-- env.info("DCE_LoopSAR F #units_SAR "..tostring(#units_SAR))
							for n=1, #units_SAR do
								unitSAR = units_SAR[n]

								-- env.info("DCE_LoopSAR G unitSAR "..tostring(unitSAR))
								if unitSAR then
									sar_CoalitionId = tostring(unitSAR:getCoalition())
									local uSAR_Player = unitSAR:getPlayerName()

									-- env.info("DCE_LoopSAR H coalName "..tostring(coalName).." sar_CoalitionId "..tostring(sar_CoalitionId))
									-- env.info("DCE_LoopSAR H  == ? CoalitionIdAlphaToName "..tostring(CoalitionIdAlphaToName[sar_CoalitionId] ))

									if unitSAR:isExist() and unitSAR:isActive() and string.lower(coalName) == CoalitionIdAlphaToName[sar_CoalitionId] then
										local pos_SAR_vec3 = unitSAR:getPoint()
										local uSAR_unitId = Unit.getID(unitSAR)
										local uSAR_Name = unitSAR:getName()
										local uSAR_inAir = unitSAR:inAir()

										-- env.info("DCE_LoopSAR I uSAR_inAir "..tostring(uSAR_inAir))
										for MGRS_Chute, zone in pairs(ZoneSAR) do
											for pilotN, ejPil in ipairs(zone) do
												if ejPil.name and not ejPil.embarked and ejPil.sideName == coalName  then
													local unitEjectPilot = Unit.getByName(ejPil.name)

													-- env.info("DCE_LoopSAR J unitEjectPilot "..tostring(unitEjectPilot))
													if unitEjectPilot then
														

														local ejPilotVec3 = unitEjectPilot:getPoint()
														local distance = math.sqrt(math.pow(pos_SAR_vec3.x - ejPilotVec3.x, 2) + math.pow(pos_SAR_vec3.z - ejPilotVec3.z, 2))

														if not ejPil.smokeTiming then 
															ejPil.smokeTiming = timer.getTime()
														end

														-- env.info("DCE_LoopSAR K distance "..tostring(distance))
														if distance <= 3000 and distance > 1000 and uSAR_inAir and (timer.getTime() > ejPil.smokeTiming + 300) then --and not ejectedPilot.smokeOK 
															--active fumigene
															local pilotVec3 = {
																x = ejPilotVec3.x,
																y = land.getHeight({x = ejPilotVec3.x, y = ejPilotVec3.z}),
																z = ejPilotVec3.z,
															}

															-- Obtenir le vecteur du vent à la position du pilote
															local windVec3 = atmosphere.getWind(pilotVec3)

															-- Calculer la norme du vent dans le plan horizontal
															local windMagnitude = math.sqrt(windVec3.x^2 + windVec3.z^2)

															-- Position de décalage pour le fumigène
															local smokeOffsetDistance = 30
															local smokePosVec3

															if windMagnitude > 0 then
																-- Normaliser la direction opposée au vent
																local windDirectionOpposite = {
																	x = -windVec3.x / windMagnitude,
																	z = -windVec3.z / windMagnitude,
																}

																-- Calculer la position du fumigène
																smokePosVec3 = {
																	x = pilotVec3.x + windDirectionOpposite.x * smokeOffsetDistance,
																	z = pilotVec3.z + windDirectionOpposite.z * smokeOffsetDistance,
																}
																smokePosVec3.y = land.getHeight({x = smokePosVec3.x, y = smokePosVec3.z})
															else
																-- Si le vent est nul, placer le fumigène 10 mètres au nord du pilote
																smokePosVec3 = {
																	x = pilotVec3.x,
																	z = pilotVec3.z + smokeOffsetDistance,
																}
																smokePosVec3.y = land.getHeight({x = smokePosVec3.x, y = smokePosVec3.z})
															end

															-- env.info("DCE_LoopSAR L smokePosVec3 "..tostring(smokePosVec3).." SmokeColor_EjectedPilot "..tostring(SmokeColor_EjectedPilot))

															-- Placer le fumigène
    														trigger.action.smoke(smokePosVec3, SmokeColor_EjectedPilot)


															ejPil.smokeTiming = timer.getTime()	-- mettre à jour le temps du fumigène

														elseif distance <= 1000 and distance > 450 then

															if uSAR_Player then
																ejPil.landingPossible = true
																-- trigger.action.outTextForUnit( SAR_unitId , "ForUnit _SAR_Player detected "..tostring(_SAR_Player) , 2 , false)
																-- env.info( "DCE_SAR_Player detected "..tostring(uSAR_Player).." SAR_unitId: "..tostring(uSAR_unitId))

															end

														elseif distance <= 450 and not uSAR_Player and not ejPil.scheduleEmbarkedOK then

															ejPil.scheduleEmbarkedOK = true

															-- env.info( "DCE_SAR:LoopSTARt distance <= 450 "..tostring(ejPil.name))

															timer.scheduleFunction(StopRadioTransmission, ejPil.name, timer.getTime() + 149)

															if not ejPil.landingPossible then
																-- env.info( "DCE_SAR:LoopSTARt timer.scheduleFunction(DespawnSoldierAliasPilot "..tostring(ejPil.name))
																local embarkation = false	--il n'est pas embaqué au sol, mais helitreuillé
																timer.scheduleFunction(DespawnSoldierAliasPilot, {ejPil.name, embarkation, nil , uSAR_Name}, timer.getTime() + 150)

															else
																-- env.info( "DCE_SAR:Pilot.landingPossible, helico: |"..tostring(uSAR_Player).."| |"..tostring(uSAR_Name).."| DEVRAIT se poser pour recuperer "..tostring(ejPil.name))

																if not unitEjectPilot:isExist()  then
																	StopRadioTransmission(ejPil.name)
																end
															end

														elseif distance <= 450 and uSAR_Player then

															-- local h = math.ceil(pos_SAR_vec3.y - land.getHeight({x = pos_SAR_vec3.x, y = pos_SAR_vec3.z}))
															
															-- l helicopter tente un helitreuillage
															-- if h > 3 and distance <= 100 and (guideSAR[SAR_unitId] == nil or guideSAR[SAR_unitId] == false) then
															if uSAR_inAir then
																
																walkEjectedPilot[uSAR_unitId] = false

																if distance <= 100 and not guideSAR[uSAR_unitId] then
																	-- env.info( "DCE_SAR:_SAR_Player SAR tries helitacking")

																	guideSAR[uSAR_unitId] = true
																	guideTreuilSAR(unitSAR, ejPilotVec3, ejPil)
																elseif distance > 100 then
																	guideSAR[uSAR_unitId] = false
																end


															--l helicoptere est considéré posé
															-- elseif h <= 3 and distance <= 200 and (walkEjectedPilot[SAR_unitId] == nil or walkEjectedPilot[SAR_unitId] == false) then
															elseif not uSAR_inAir then

																guideSAR[uSAR_unitId] = false	-- le player s'est posé

																if distance <= 200 and not walkEjectedPilot[uSAR_unitId] then
																	trigger.action.outTextForUnit( uSAR_unitId ,  "you are less than 200m from the wrecked pilot, he should be walking towards you: ", 2 , true)
																	-- env.info( "DCE_SAR:_SAR_Player SAR attempts ground embarkation")

																	walkEjectedPilot[uSAR_unitId] = true
																	detectsEjectedPilotEmbarkation(unitSAR, ejPil)
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

    if campL.debug then
		local dt = os.clock() - t0
		Perf_D = Perf_D + dt
    end

	return timer.getTime() + 10

end


local function despawn2(arg)
	local unitToDespawn = arg[1]
	local from = arg[2]
	env.info("DCE_despawn2 A tentative despawn2() from "..tostring(from))

	-- _affiche(unitToDespawn, "DCE_despawn2 B despawn unitToDespawn")
	if unitToDespawn and unitToDespawn:isExist() then
		unitToDespawn:destroy()
		env.info("DCE_despawn2 despawn/destroy ")
	end
end

local function spawnWreck(element)

	env.info( "DCE_spawnWreck name:  "..tostring(element.name).." countryId: "..tostring(element.countryId))

	local wreckName = "Unit_Static_"..tostring(element.name)

	if createWreck[wreckName] then
		env.info( "DCE_spawnWreck already exist, then return  ")
		return
	end


	local hidden = true
	-- if camp.debug then
	-- 	hidden = false
	-- end

	if element.getOutHelicopter then
		hidden = false
	end

	local dead = true
	local rate = 50

	if element.rate then
		rate = element.rate

		if element.rate >= 80 then
			dead = false
		end
	end

	local staticObj = {
		["heading"] = 0,
		-- ["shape_name"] = "stolovaya",
		["type"] = tostring(element.aircraftType),
		["rate"] = rate,
		["name"] = tostring(wreckName),
		-- ["category"] = "Helicopters",
		["y"] = tonumber(element.y),
		["x"] = tonumber(element.x),
		["dead"] = dead,
	}

	staticObj.category = DCS_CategoryById[element.categoryId]

	coalition.addStaticObject(element.countryId, staticObj)

	createWreck[wreckName] = true

	if campL.debug then
		local TimeNow = timer.getTime() + 5
		local logStr = "AddstaticObjWreck = " .. TableSerialization(staticObj, 0)
		local ElementNameClean = element.name:gsub('[%p%c%s]', '_')
		local logFile = io.open(PathDCE.."Debug\\".."spawnWreck"..ElementNameClean.."_"..TimeNow.."_".. ".lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_spawnWreck: Failed to open log file for writing.")
		end

		env.info( "DCE_spawnWreck write debug file "..tostring(ElementNameClean))
	end

end

function GetOutGDFM(arg)
	-- env.info( "DCE_getOut A scheduleFunction GetOutGDFM ")

	local arg_playerName
	local arg_playerObj
	local arg_playerId

	if arg and arg[1] then
		arg_playerName = arg[1]
		arg_playerObj = arg[2]
		arg_playerId = arg[3]
	end

	if arg_playerName then

		if arg_playerObj.getName and arg_playerObj.getPoint and arg_playerObj.getCountry and arg_playerObj.getCoalition and arg_playerObj.getTypeName and arg_playerObj.getID then

			local name = arg_playerObj:getName()
			local playerPointVec3 = arg_playerObj:getPoint()				--get target point
			local countryId = arg_playerObj:getCountry()
			local coalitionId = arg_playerObj:getCoalition()
			local sideName = CoalitionIdToName[tonumber(coalitionId)]


			local infoPlayer = {
				pilotName = arg_playerName,
				unit = arg_playerObj,
				name = name,
				aircraftType = arg_playerObj:getTypeName(),
				coalitionId = coalitionId,
				initiatorMissionID = arg_playerObj:getID(),
				countryId = countryId,
				countryName = string.lower(country.name[countryId]),
				sideName = sideName,
				pos = {
					Vec3x = playerPointVec3.x,
					Vec3y = playerPointVec3.z,
					Vec3z = playerPointVec3.y,
					x= playerPointVec3.x,
					y= playerPointVec3.z,
					z= playerPointVec3.y,
					altiLand = land.getHeight({ x = playerPointVec3.x, y = playerPointVec3.z }),
				},
				unitId = arg_playerId,
			}
		
			local modulation = 0	--AM

			env.info( "DCE_getOut infoPlayer EventT :radioTransmission frequency A  "..tostring(campL.EjectedPilotFrequency[infoPlayer.sideName].GuardEjection).." | "..tostring('GuardEjection'..name))
			trigger.action.radioTransmission('l10n/DEFAULT/ejectionRadioBeacon.ogg', arg_playerObj, modulation, true, campL.EjectedPilotFrequency[infoPlayer.sideName].GuardEjection, RadioWatt, 'GuardEjection'..name)
			env.info( "DCE_getOut infoPlayer EventT :radioTransmission frequency B  "..tostring(campL.EjectedPilotFrequency[infoPlayer.sideName].GuardEjection).." | "..tostring('GuardEjection'..name))

			-- --position precise pour le fumigene
			-- local pilotVec3 = {
			-- 	x = playerPointVec3.x,
			-- 	y = land.getHeight({x = playerPointVec3.x, y = playerPointVec3.z}),
			-- 	z = playerPointVec3.z,
			-- }

			--position futur de l ejectedPilot
			infoPlayer.pos.x = infoPlayer.pos.x + 150
			infoPlayer.pos.y = infoPlayer.pos.y + 150

			local life = arg_playerObj:getLife()
			local init_life = arg_playerObj:getLife0()
			local lifePourcent = 100
			-- local isPlayer = true
			if init_life then
				lifePourcent = life/init_life*100
				infoPlayer.rate = lifePourcent
			end

			local current_time = timer.getTime()
			if campL.debug then
				local logStr = "GetOutPlayer = " .. TableSerialization(GroundDamagedFlyingMachine, 0)
				local grpnameClean = arg_playerName:gsub('[%p%c%s]', '_')
				local logFile = io.open(PathDCE.."Debug\\"..infoPlayer.unitId.."_"..grpnameClean.."_".. "DamagedFM_"..current_time..".lua", "w")
				if logFile then
					logFile:write(logStr)
					logFile:close()
				else
					env.info("DCE_GetOutPlayer: Failed to open log file for writing.")
				end
			end

			-- env.info("DCE_GetOutPlayer: playerPointVec3.x."..tostring(playerPointVec3.x))
			-- env.info("DCE_GetOutPlayer: playerPointVec3.z."..tostring(playerPointVec3.z))

			-- env.info("DCE_GetOutPlayer: infoPlayer.pos.z."..tostring(infoPlayer.pos.z))
			-- env.info("DCE_GetOutPlayer: infoPlayer.pos.altiLand."..tostring(infoPlayer.pos.altiLand))

			-- _affiche(infoPlayer, "DCE_getOut infoPlayer ")

			--si l'helico ne vole pas
			local altiAicraft = infoPlayer.pos.altiLand - infoPlayer.pos.z
			if altiAicraft <= 100 then

				SumSoldierAliasPilot = SumSoldierAliasPilot + 1
				infoPlayer.getOutHelicopter  = true

				if infoPlayer.pilotName then
					infoPlayer.name = "Mis" ..
					campL.mission ..
					"_Pilot_" .. infoPlayer.pilotName .. "_Nb" .. tostring(SumSoldierAliasPilot) .. "_Damaged"
				end

				-- infoPlayer.name = infoPlayer.name:gsub('[%p%c%s]', '_')
				infoPlayer.name = CleanName(infoPlayer.name)

				local typeLand = land.getSurfaceType({x =infoPlayer.x, y = infoPlayer.y})

				env.info("DCE_getOut infoPlayer E test typeLand "..tostring(typeLand))

				if typeLand ~= 3 and typeLand ~= 5  then

					AddSoldierAliasPilot(infoPlayer)
					infoPlayer.createdSoldier = true

					--ajoute l'ejectedPilot dans la liste SAR, pour etre recupéré par le module SAR
					infoPlayer = Add_MGRS_Chute(infoPlayer)
					if infoPlayer.MGRS_Chute then
						if ZoneSAR[infoPlayer.MGRS_Chute] == nil then
							ZoneSAR[infoPlayer.MGRS_Chute] = {}
						end
						table.insert(ZoneSAR[infoPlayer.MGRS_Chute], infoPlayer)
					end

					-- Obtenir le vecteur du vent à la position du pilote
					local windVec3 = atmosphere.getWind({x=infoPlayer.pos.Vec3x,y=infoPlayer.pos.Vec3y,z=infoPlayer.pos.Vec3z})

					-- Calculer la norme du vent dans le plan horizontal
					local windMagnitude = math.sqrt(windVec3.x^2 + windVec3.z^2)

					-- Position de décalage pour le fumigène
					local smokeOffsetDistance = 30
					local smokePosVec3

					if windMagnitude > 0 then
						-- Normaliser la direction opposée au vent
						local windDirectionOpposite = {
							x = -windVec3.x / windMagnitude,
							z = -windVec3.z / windMagnitude,
						}

						-- Calculer la position du fumigène
						smokePosVec3 = {
							x = infoPlayer.pos.Vec3x + windDirectionOpposite.x * smokeOffsetDistance,
							y = infoPlayer.pos.Vec3y,
							z = infoPlayer.pos.Vec3z + windDirectionOpposite.z * smokeOffsetDistance,
						}
					else
						-- Si le vent est nul, placer le fumigène 10 mètres au nord du pilote
						smokePosVec3 = {
							x = infoPlayer.pos.Vec3x,
							y = infoPlayer.pos.Vec3y,
							z = infoPlayer.pos.Vec3z + smokeOffsetDistance,
						}
					end

						-- Placer le fumigène
					trigger.action.smoke(smokePosVec3, SmokeColor_EjectedPilot)
					-- ejectedPilot.smokeTiming = timer.getTime()	-- mettre à jour le temps du fumigène

				else
					env.info( "DCE_GetOutGDFM M emergency evacuation impossible, no-go area (water(3)  or runway(5)) "..tostring(typeLand))
					trigger.action.outTextForUnit(arg_playerId, "emergency evacuation impossible, no-go area (water(3)  or runway(5)) "..tostring(typeLand), 15)

				end


				local log_entry = {
					type = "eject",
					initiator = name,
					pilotName = arg_playerName,
					t = timer.getTime(),
				}

				table.insert(CustomLog, log_entry)

				CheckImmediatSAR(infoPlayer)

				env.info("DCE_getOut F test despawn ")
				timer.scheduleFunction(despawn2, {infoPlayer.unit, "GetOutGDFM if pName" }, timer.getTime() + 30)
				timer.scheduleFunction(spawnWreck, infoPlayer, timer.getTime() + 35)
				createWreckCrew[infoPlayer.name] = true
			else
				env.info( "DCE_GetOutGDFM M emergency evacuation impossible, altitude above 100m "..tostring(altiAicraft))
				trigger.action.outTextForUnit(arg_playerId, "emergency evacuation impossible, altitude above 100m "..tostring(altiAicraft), 15)
			end
		end
	else

		for id_, key in pairs(GroundDamagedFlyingMachine) do
			for occurenceN = #key, 1, -1 do
				local damaged = key[occurenceN]

				if not arg_playerName and not damaged.isPlayer then
					if damaged and damaged.unit or not damaged.unit:inAir() then
						if not createWreckCrew[damaged.name] then
							damaged.pos = {
								Vec3x = damaged.crashPointVec3.x,
								Vec3y = damaged.crashPointVec3.y,
								Vec3z = damaged.crashPointVec3.z,
								x = damaged.crashPointVec3.x,
								y = damaged.crashPointVec3.z,
								z = damaged.crashPointVec3.y,
							}

							damaged.pos.x = damaged.pos.x + 50
							damaged.pos.y = damaged.pos.y + 50
							SumSoldierAliasPilot = SumSoldierAliasPilot + 1
							damaged.getOutHelicopter  = true

							if damaged.pilotName then
								damaged.name = "Mis" ..
								campL.mission ..
								"_Pilot_" ..
								damaged.pilotName .. "_Nb" .. tostring(SumSoldierAliasPilot) .. "_Damaged"
							else
								damaged.name = "Mis" ..
								campL.mission ..
								"_Pilot_" .. damaged.name .. "_Nb" .. tostring(SumSoldierAliasPilot) .. "_Damaged"
							end

							-- damaged.name = damaged.name:gsub('[%p%c%s]', '_')
							damaged.name = CleanName(damaged.name)

							local typeLand = land.getSurfaceType({x =damaged.x, y = damaged.y})
							local distanceBase, baseName = ProxyBase(damaged)
							if distanceBase then
								distanceBase = math.floor(distanceBase)
							else
								distanceBase = 0
							end

							env.info("DCE_getOut G baseName "..tostring(baseName).." distanceBase "..tostring(distanceBase))

							if distanceBase > 15000 and typeLand ~= land.SurfaceType.WATER and typeLand ~= land.SurfaceType.RUNWAY  then

								AddSoldierAliasPilot(damaged)
								damaged.createdSoldier = true
								-- Obtenir le vecteur du vent à la position du pilote
								local windVec3 = atmosphere.getWind({x=damaged.pos.Vec3x,y=damaged.pos.Vec3y,z=damaged.pos.Vec3z})

								-- Calculer la norme du vent dans le plan horizontal
								local windMagnitude = math.sqrt(windVec3.x^2 + windVec3.z^2)

								-- Position de décalage pour le fumigène
								local smokeOffsetDistance = 30
								local smokePosVec3

								if windMagnitude > 0 then
									-- Normaliser la direction opposée au vent
									local windDirectionOpposite = {
										x = -windVec3.x / windMagnitude,
										z = -windVec3.z / windMagnitude,
									}

									-- Calculer la position du fumigène
									smokePosVec3 = {
										x = damaged.pos.Vec3x + windDirectionOpposite.x * smokeOffsetDistance,
										y = damaged.pos.Vec3y,
										z = damaged.pos.Vec3z + windDirectionOpposite.z * smokeOffsetDistance,
									}
								else
									-- Si le vent est nul, placer le fumigène 10 mètres au nord du pilote
									smokePosVec3 = {
										x = damaged.pos.Vec3x,
										y = damaged.pos.Vec3y,
										z = damaged.pos.Vec3z + smokeOffsetDistance,
									}
								end

									-- Placer le fumigène
								trigger.action.smoke(smokePosVec3, SmokeColor_EjectedPilot)

							end

							CheckImmediatSAR(damaged)

							timer.scheduleFunction(despawn2, {damaged.unit, "GetOutGDFM, else IA" }, timer.getTime() + 30)
							timer.scheduleFunction(spawnWreck, damaged, timer.getTime() + 35)
							createWreckCrew[damaged.name] = true

							if damaged.initiator and damaged.initiator.id_ then
								for n, damageds in pairs(GroundDamagedFlyingMachine) do
									local toRemove = {} -- Table pour stocker les clés à supprimer

									for initiatorId, damagedUnit in pairs(damageds) do
										if initiatorId == damaged.initiator_id_ then
											table.insert(toRemove, initiatorId)
										end
									end

									-- Supprimer les entrées après avoir parcouru la table
									for _, initiatorId in ipairs(toRemove) do
										damageds[initiatorId] = nil
									end
								end
							end
						end
					else
						key[occurenceN] = nil
					end
				end
			end
		end

		if not arg_playerName then
			return timer.getTime() + 5
		end
	end
end


if campL.SAR and campL.SAR.helicopter then
	timer.scheduleFunction(LoopSAR, nil, timer.getTime() + 5)
	timer.scheduleFunction(LoopManagedRadioTransmission, nil, timer.getTime() + 60)
end


timer.scheduleFunction(checkAddingManhunt, nil, timer.getTime() + 5)

timer.scheduleFunction(StopRadioTransmissionSeat, nil, timer.getTime() + 30)

timer.scheduleFunction(GetOutGDFM, nil, timer.getTime() + 6)

env.info("DCE_SAR END OF LOADING SAR.lua ")