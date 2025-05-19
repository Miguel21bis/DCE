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

local guideSAR = {}
local walkEjectedPilot = {}
local SoldierAliasManhunt = {}
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
-- 			smokeOK = false,
-- 			embarked = false,
-- 			embarkAndSafe = false,
-- 		},
-- 		[2] = {
-- 			name = "ejected2",
-- 			smokeOK = false,
-- 			embarked = false,
-- 			embarkAndSafe = false,
-- 		},
-- 	}
-- }

--ajoute la table (camp.SAR.pilotEjected) dans SAR  pour n'avoir qu'une seule table
for N_Pilot, ejectedPilot in ipairs(camp.SAR.pilotEjected) do
	if ejectedPilot and ejectedPilot.MGRS_Chute   then
		if zoneSAR[ejectedPilot.MGRS_Chute] == nil then
			zoneSAR[ejectedPilot.MGRS_Chute] = {}
		end
		table.insert( zoneSAR[ejectedPilot.MGRS_Chute], ejectedPilot)
	end
end

function DespawnSoldierAliasPilot(arg)
	local EjectedPilotName = arg[1]
	local embarkation = arg[2]
	local _SAR_Player = arg[3]
	local SAR_Name = arg[4]


	env.info("DCE_DespawnSoldierAliasPilot START "..tostring(EjectedPilotName))

	for MGRS_Chute, zone in pairs(zoneSAR) do
		for N_Pilot, ejectedPilot in ipairs(zone) do
			if ejectedPilot.name and ejectedPilot.name == EjectedPilotName    then	--and ejectedPilot.embarked ~= true

				env.info( "DCE_SAR: the pilot :"..EjectedPilotName.." is on board ".." ejectedPilot.Coalition: "..tostring(ejectedPilot.Coalition))
				-- trigger.action.outText("DCE_SAR: the pilot:"..EjectedPilotName.." is on board", 10)

				if ejectedPilot.Coalition then
					trigger.action.outTextForCoalition(ejectedPilot.Coalition, "SAR Coalition: the pilot:"..EjectedPilotName.." is on board", 10)
				end

				EjectedPilotOnBoard[SAR_Name] = EjectedPilotOnBoard[SAR_Name] or {}
				table.insert(EjectedPilotOnBoard[SAR_Name],EjectedPilotName)
				_affiche(EjectedPilotOnBoard)

				ejectedPilot.embarked = embarkation
				ejectedPilot.status = "rescued"

				local log_entry = {}
				log_entry.type = "embarkedEjectedPilot"
				log_entry.t = timer.getTime()
				log_entry.targetPilotName = ejectedPilot.initiatorPilotName
				log_entry.target = ejectedPilot.name
				log_entry.initiatorPilotName = _SAR_Player
				log_entry.initiator = SAR_Name

				table.insert(CustomLog, log_entry)

				StopRadioTransmission(EjectedPilotName)

				local soldier = Unit.getByName(EjectedPilotName)

				if soldier and soldier:isExist()  then
					-- if not embarkation or embarkation == nil then
						soldier:destroy()
						env.info("DCE_DespawnSoldierAliasPilot despawn/destroy ")
					-- end
					-- trigger.action.outText("DespawnSoldierAliasPilot "..tostring(EjectedPilot.name), 30)

					StopRadioTransmission(EjectedPilotName)

					env.info("DCE_DespawnSoldierAliasPilot FIN "..tostring(EjectedPilotName))
				end
			end
		end
	end
end

function AddSoldierAliasPilot(element)

	env.info( "DCE_SAR_AddSoldierAliasPilot name:  "..tostring(element.name).." countryId: "..tostring(element.countryId))

	local hidden = true
	-- if camp.debug then
	-- 	hidden = false
	-- end

	if element.getOutHelicopter then
		hidden = false
	end

	local AddGroup = {
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
					["y"] = tonumber(element.y2d),
					["x"] = tonumber(element.x2d),
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
										["y"] = tonumber(element.y2d + 5),
										["x"] = tonumber(element.x2d + 5),
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
					["y"] = tonumber(element.y2d + 5),
					["x"] = tonumber(element.x2d + 5),
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
										["y"] = tonumber(element.y2d + 5),
										["x"] = tonumber(element.x2d + 5),
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
				["y"] = tonumber(element.y2d) + 2,
				["x"] = tonumber(element.x2d) + 2,
				["name"] = element.name,
				["heading"] = 0,
				["playerCanDrive"] = false,
			}, -- end of [1]
		}, -- end of ["units"]
		["y"] = tonumber(element.y2d) + 2,
		["x"] = tonumber(element.x2d) + 2,
		["name"] = "Group_"..tostring(element.name),
		["start_time"] = 0,
	}

	coalition.addGroup(element.countryId, Group.Category.GROUND, AddGroup)

	if camp.debug then
		local TimeSearchEngage = timer.getTime() + 5
		local logStr = "AddGroup = " .. TableSerialization(AddGroup, 0)
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

function AddSoldierAliasManhunt(EjectedPilot)

	local function AddMultipleSoldier(ejectedPilotName, randomIdCountry, point, n)

		env.info( "DCE_SAR_AddSoldierAliasManhunt A randomIdCountry:  "..tostring(randomIdCountry))

		if not SoldierAliasManhunt[randomIdCountry] then SoldierAliasManhunt[randomIdCountry] = 0 end

		_affiche(SoldierAliasManhunt[randomIdCountry], "SoldierAliasManhunt[randomIdCountry]")

		if SoldierAliasManhunt[randomIdCountry] > 15 then
			env.info( "DCE_SAR_AddSoldierAliasManhunt Z return:  ")
			return
		end

		env.info( "DCE_SAR_AddSoldierAliasManhunt B ejectedPilotName:  "..tostring(ejectedPilotName).." randomIdCountry: "..tostring(randomIdCountry).." n: "..tostring(n))

		local hidden = true
		if camp.debug then
			hidden = false
		end
		local randomPos = math.random(-15, 15)

		local AddGroup = {
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

		coalition.addGroup(randomIdCountry, Group.Category.GROUND, AddGroup)
		SoldierAliasManhunt[randomIdCountry] = SoldierAliasManhunt[randomIdCountry] + 1
	end


	local ejectedPilotName = EjectedPilot:getName()
	local ejectedPilotCoalition = EjectedPilot:getCoalition()
	local enemyCoalition = 0

	if ejectedPilotCoalition == 1 then
		enemyCoalition = 2
	else
		enemyCoalition = 1
	end

	-- coalitionIdNumeric = {
	-- 	[0] = "neutral",
	-- 	[1] = "red",
	-- 	[2] = "blue",
	-- }

	_affiche(coalitionIdNumeric, "coalitionIdNumeric")
	local manhuntSide = coalitionIdNumeric[enemyCoalition]

	env.info( "DCE_SAR_AddSoldierAliasManhunt 01 enemyCoalition:  "..tostring(enemyCoalition).." manhuntSide "..tostring(manhuntSide))

	env.info( "DCE_SAR_AddSoldierAliasManhunt C ejectedPilotName:  "..tostring(ejectedPilotName).." ejectedPilotCoalition: "..tostring(ejectedPilotCoalition).." enemyCoalition: "..tostring(enemyCoalition))
	env.info( "DCE_SAR_AddSoldierAliasManhunt D coalitionIdNumeric[enemyCoalition]:  "..tostring(coalitionIdNumeric[enemyCoalition]))

	local nMaxCountry = #env.mission.coalition[coalitionIdNumeric[enemyCoalition]].country
	local randomNCountry  = math.random(1,nMaxCountry )
	local randomIdCountry = env.mission.coalition[coalitionIdNumeric[enemyCoalition]].country[randomNCountry].id
	local PosEjectedPilot = EjectedPilot:getPoint()

	env.info( "DCE_SAR_AddSoldierAliasManhunt E randomNCountry:  "..tostring(randomNCountry).." randomIdCountry: "..tostring(randomIdCountry))

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

		local pointSelected = PosEjectedPilot
		repeat

			portionCercle = portionCercle + 1
			-- local distance = math.random(35, 65)
			-- distance = distance * 100
			i = i + 1
			local testPoint = GetOffsetPoint( {x=PosEjectedPilot.x, y=PosEjectedPilot.z}, portionCercle, distance)
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
			env.info( "DCE_SAR_AddSoldierAliasManhunt F1")

			local rightSideOfBorder
			if camp.boundary and camp.boundary[manhuntSide] and camp.boundary[manhuntSide] ~= nil then
				rightSideOfBorder =  CheckPointInPoly2(pointSelected, camp.boundary[manhuntSide])
				env.info( "DCE_SAR_AddSoldierAliasManhunt?  F2 boundary rightSideOfBorder __"..tostring(rightSideOfBorder).."__ ejectedPilot.side: "..tostring(manhuntSide))
				if rightSideOfBorder  then
					env.info( "DCE_SAR_AddSoldierAliasManhunt? G rightSideOfBorder  ")
					rightSide = true
				end
			else
				rightSide = true
			end


		end
		if altiSelected < 999999 and randomSpawn and rightSide then
			env.info( "DCE_SAR_AddSoldierAliasManhunt G ejectedPilotName:  "..tostring(ejectedPilotName).." randomIdCountry: "..tostring(randomIdCountry).." n: "..tostring(n))
			AddMultipleSoldier(ejectedPilotName, randomIdCountry, pointSelected, n)
			nbManhunt[ejectedPilotCoalition] = nbManhunt[ejectedPilotCoalition] + 1
		end
	end

end	--function AddSoldierAliasManhunt(EjectedPilot)



local function startSAR(arg)

	local FlightSAR = arg[1]
	local pt_dest = arg[2]
	-- local pt_AfterTakeOff  = arg[3]

	local point_1y = FlightSAR.y
	local point_1x = FlightSAR.x
	local current_time = timer.getTime() +1
	local speed = FlightSAR.vAttack
	local distance01 = math.sqrt(math.pow(FlightSAR.x - pt_dest.x2d, 2) + math.pow(FlightSAR.y - pt_dest.y2d, 2))

	local alt_cruise = FlightSAR.hCruise
	local CV_Name = ""

	--400			10000 https://calculis.net/droite
	--60			1

	-- y = aX + b
	-- y = (0.034 + X ) + 60
	local a = 0.034
	alt_cruise = (0.034 * distance01) + 60
	if alt_cruise > FlightSAR.hCruise then
		alt_cruise = FlightSAR.hCruise
	end


	local heading1 = GetHeading(FlightSAR, {x=pt_dest.x2d, y=pt_dest.y2d})
	local distanceAfterPt2 = distance01/2

	local point_2 = GetOffsetPoint(FlightSAR, heading1, distanceAfterPt2)
	local point_2z = land.getHeight({x =point_2.x, y = point_2.y})

	env.info( "DCE_SAR startSAR point_2z "..tostring(point_2z).." heading1: "..tostring(heading1))
	-- trigger.action.outText("SAR startSAR point_2z "..tostring(point_2z).." heading1: "..tostring(heading1), 30)

	local altiTarget = pt_dest.z2d + 100
	if altiTarget < alt_cruise then
		altiTarget = alt_cruise
	end

	local pointData = {}
	pointData = {
		{
			["alt"] = FlightSAR.airdromeElevation + 30,
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
										-- ["command"] = 'Custom_Altitude("' .. FlightSAR.name .. '")',
									-- },
								-- },
							-- },
						-- },
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["ETA"] = tonumber(current_time) ,
			["ETA_locked"] = true,
			["y"] = point_1y,
			["x"] = point_1x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		}, -- end of [1] 
		{
			["alt"] = tonumber(point_2z + 100 ),
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
										["command"] = "Custom_Altitude('" .. FlightSAR.name .. "',  '  nil  ', '" .."2".. "')",
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
			["y"] = point_2.y,
			["x"] = point_2.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		{
			["alt"] = tonumber(altiTarget),
			["action"] = "Turning Point",
			["alt_type"] = "BARO",
			["speed"] = tonumber(FlightSAR.vCruise),
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
			["ETA"] = tonumber((distance01 / FlightSAR.vCruise) + current_time + 500) ,
			["ETA_locked"] = false,
			["y"] = pt_dest.y2d,
			["x"] = pt_dest.x2d,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		{
			-- ["alt"] = tonumber(alt_cruise + pt_dest.z2d),
			["alt"] = tonumber(altiTarget),
			["action"] = "Turning Point",
			["alt_type"] = "RADIO",
			["speed"] = tonumber(FlightSAR.vCruise),
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
										["command"] = 'Custom_SAR("' .. FlightSAR.name .. '",  "' .. FlightSAR.airdromeName .. '",  "' .. FlightSAR.x .. '",  "' .. FlightSAR.y .. '",  "' .. pt_dest.MGRS_Chute .. '",   "' .. FlightSAR.vCruise .. '",  "' .. alt_cruise ..  '")',
									}, -- end of ["params"]
								}, -- end of ["action"]
							}, -- end of ["params"]
						}, -- end of [1]			
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = tonumber((distance01 / FlightSAR.vCruise) + current_time + 500) ,
			["ETA_locked"] = false,
			["y"] = pt_dest.y2d,
			["x"] = pt_dest.x2d,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		{
			["alt"] = tonumber(point_2z + 100 ),
			["action"] = "Turning Point",
			["alt_type"] = "BARO",
			["speed"] = tonumber(FlightSAR.vCruise),
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
			["ETA"] = tonumber(((distance01 + distanceAfterPt2) / FlightSAR.vCruise) + current_time + 1000) ,
			["ETA_locked"] = false,
			["y"] = pt_dest.y2d,
			["x"] = pt_dest.x2d,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
		{
			["alt"] = tonumber(alt_cruise + FlightSAR.airdromeElevation),
			["action"] = "Landing",
			["alt_type"] = "BARO",
			["speed"] =  tonumber(FlightSAR.vCruise),
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
			["ETA"] = tonumber( ( ( (distance01 / FlightSAR.vCruise) + current_time)*2 )+ 1000 ),
			["ETA_locked"] = false,
			["y"] = point_1y,
			["x"] = point_1x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
			['linkUnit'] = tonumber(FlightSAR.airdromeId),
			['helipadId'] = tonumber(FlightSAR.airdromeId),
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

	local ctr = Group.getByName(FlightSAR.name):getController()
	Controller.setTask(ctr, Mission)

	local current_time = timer.getTime()

	if camp.debug then
		local logStr = "Start_SAR = " .. TableSerialization(Mission, 0)
		local flightNameClean = FlightSAR.name:gsub('[%p%c%s]', '_')
		local logFile = io.open(PathDCE.."Debug\\"..flightNameClean.."_".. "Start_SAR"..current_time..".lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_SAR_Start_SAR: Failed to open log file for writing.")
		end
	end

	local flight = Group.getByName(FlightSAR.name)
	local leader = flight:getUnit(1)
	local  gpGid = Group.getID(flight)

	LastInjectFlightPlan[gpGid] = Mission
end


function CheckImmediatSAR(ejectedPilot)

	env.info( "DCE_CheckImmediatSAR A "..tostring(ejectedPilot.name))

	local pt_chute = {}
	-- local initDesc = Event.initiator:getDesc()	

	if ejectedPilot.initiatorSIDE then
		if ejectedPilot.initiatorSIDE == 0 then
			ejectedPilot.initiatorSIDE = "neutrals"
		elseif ejectedPilot.initiatorSIDE == 1 then
			ejectedPilot.initiatorSIDE = "red"
		elseif ejectedPilot.initiatorSIDE == 2 then
			ejectedPilot.initiatorSIDE = "blue"
		end
	end

	local isExist = false

	-- if ejectedPilot.unit then
	-- 	isExist = Unit.isExist(ejectedPilot.unit)
	-- end 

	-- if damaged.unit and damaged.unit:isExist() then
	-- 	env.info( "DCE_getOut C1 occurenceN "..tostring(occurenceN))
	-- 	env.info( "DCE_getOut C2 isActive "..tostring(damaged.unit:isActive()))
	-- 	env.info( "DCE_getOut C3 inAir "..tostring(damaged.unit:inAir()))

	-- 	if damaged.unit:isActive() then
	-- 		env.info( "DCE_getOut C4 isActive "..tostring(damaged.unit:isActive()))
	-- 	end
	-- end

	-- if ejectedPilot and ejectedPilot.x then
	-- 	env.info( "DCE_CheckImmediatSAR B :isExist(): "..tostring(ejectedPilot.unit:isExist()))
	-- end

	if ejectedPilot and ejectedPilot.x  then -- and ejectedPilot.unit:isExist()  --and isExist

		env.info( "DCE_CheckImmediatSAR C "..tostring(ejectedPilot.name))

		local grid = coord.LLtoMGRS(coord.LOtoLL(ejectedPilot))

		if grid  then
			env.info( "DCE_CheckImmediatSAR  A1 grid found ")
		else
			grid = ejectedPilot.grid
			env.info( "DCE_CheckImmediatSAR  A2 grid else ")
		end


		local chuteZone = grid.UTMZone .. ' ' .. grid.MGRSDigraph .. ' ' .. grid.Easting .. ' ' .. grid.Northing

		env.info( "DCE_CheckImmediatSAR? A3 chuteZone "..chuteZone)

		--Avec 2 lettres (A et B) on passe de zone de 10km à des zone de 50km (la limite supérieur serait de 100km)
		local subdiv_E_Num = tonumber(string.sub(grid.Easting, 1, 1))
		local subdiv_E_Alpha
		if subdiv_E_Num < 5 then
			subdiv_E_Alpha = "A"
		else
			subdiv_E_Alpha = "B"
		end

		local subdiv_N_Num = tonumber(string.sub(grid.Northing, 1, 1))
		local subdiv_N_Alpha
		if subdiv_N_Num < 5 then
			subdiv_N_Alpha = "A"
		else
			subdiv_N_Alpha = "B"
		end

		-- local MGRS_Chute = grid.UTMZone.."_"..grid.MGRSDigraph.."_"..string.sub(grid.Easting, 1, 1).."_"..string.sub(grid.Northing, 1, 1)
		local MGRS_Chute = grid.UTMZone.."_"..grid.MGRSDigraph.."_"..subdiv_E_Alpha.."_"..subdiv_N_Alpha
		local MGRS_Chute_10KM = grid.UTMZone.."_"..grid.MGRSDigraph.."_"..subdiv_E_Num.."_"..subdiv_N_Num

		env.info( "DCE_CheckImmediatSAR? A4 Start if ejectedPilot MGRS_Chute "..MGRS_Chute)
		env.info( "DCE_CheckImmediatSAR? A5 Start if ejectedPilot MGRS_Chute_10KM "..MGRS_Chute_10KM)

		local t = timer.getTime()

		ejectedPilot.x2d = ejectedPilot.x
		ejectedPilot.y2d = ejectedPilot.z
		ejectedPilot.z2d = land.getHeight({x = ejectedPilot.x, y = ejectedPilot.z})
		-- ejectedPilot.name = "Mis"..camp.mission.."_M"..camp.date.month.."_D"..camp.date.day.."_H"..camp.date.hour.."_Mn"..camp.date.minute.."_Pilot_"..ejectedPilot.initiator.."_Nb"..tostring(ejectedPilot.SumejectedPilotDay)

		-- if ejectedPilot.initiatorPilotName then
		-- 	ejectedPilot.name = "Mis"..camp.mission.."_Pilot_"..ejectedPilot.initiatorPilotName.."_Nb"..tostring(ejectedPilot.SumejectedPilotDay)
		-- else
		-- 	ejectedPilot.name = "Mis"..camp.mission.."_Pilot_"..ejectedPilot.initiator.."_Nb"..tostring(ejectedPilot.SumejectedPilotDay)
		-- end

		-- ejectedPilot.name = ejectedPilot.name:gsub('[%p%c%s]', '_')

		ejectedPilot.year = camp.date.year
		ejectedPilot.month = camp.date.month
		ejectedPilot.day = camp.date.day
		ejectedPilot.hour = camp.date.hour


		ejectedPilot.nameId = ejectedPilot.initiatorMissionID
		ejectedPilot.MGRS_Chute = MGRS_Chute
		ejectedPilot.MGRS_Chute_10KM = MGRS_Chute_10KM
		ejectedPilot.groupSAR = ""
		ejectedPilot.status = "MIA"
		ejectedPilot.side = ejectedPilot.initiatorSIDE
		ejectedPilot.country = ejectedPilot.initiatorCountry

		ejectedPilot.embarkAndSafe = false
		ejectedPilot.smokeOK = false
		ejectedPilot.embarked = false
		ejectedPilot.landingPossible = false

		ejectedPilot.initChoicePOW = false

		ejectedPilot.radio_start = 0

		env.info( "DCE_CheckImmediatSAR? BB ejectedPilot.name "..ejectedPilot.name)

		--ajoute à la queue le crash suivant dans la table zoneSAR
		if not zoneSAR[MGRS_Chute] then zoneSAR[MGRS_Chute] = {} end
		table.insert( zoneSAR[MGRS_Chute], ejectedPilot)

		--si ejectedPilot est chez l'ENI, on ne lance pas de SAR
		-- on lancera une CSAR dans les missions suivantes

		local wrongSide = false
		local ENI_Side = DCS_ENI_Side[ejectedPilot.side]
		if camp.boundary and camp.boundary[ENI_Side] and camp.boundary[ENI_Side] ~= nil then
			wrongSide =  CheckPointInPoly2({x=ejectedPilot.x2d,y=ejectedPilot.y2d} , camp.boundary[ENI_Side])
			env.info( "DCE_CheckImmediatSAR C ?  boundary wrongSide ? __"..tostring(wrongSide))
			if wrongSide  then
				env.info( "DCE_CheckImmediatSAR? D boundary rightSideOfBorder __FALSE__ Return ")
				return
			end
		end

		-- local rightSideOfBorder
		-- if camp.boundary and camp.boundary[ejectedPilot.side] and camp.boundary[ejectedPilot.side] ~= nil then
		-- 	rightSideOfBorder =  CheckPointInPoly2({x=ejectedPilot.x2d,y=ejectedPilot.y2d}, camp.boundary[ejectedPilot.side])
		-- 	env.info( "DCE_CheckImmediatSAR? CC boundary rightSideOfBorder __"..tostring(rightSideOfBorder).."__ ejectedPilot.side: "..tostring(ejectedPilot.side))
		-- 	if rightSideOfBorder == nil or rightSideOfBorder == false then
		-- 		env.info( "DCE_CheckImmediatSAR? DD boundary rightSideOfBorder __FALSE__ Return ")
		-- 		return
		-- 	end
		-- end


		--si ejectedPilot sur une VILLE on ne lance pas de SAR ni de CSAR
		local NameTheatre =  string.lower(env.mission.theatre)
		env.info( "DCE_CheckImmediatSAR? NameTheatre "..tostring(NameTheatre))
		if circleCity[NameTheatre] then
			env.info( "DCE_CheckImmediatSAR? Passe 1 NameTheatre  ")

			for nCircle, circle in ipairs(circleCity[NameTheatre]) do
				--voir le code identique sur DC_UpdateSAR.lua

				local mission2d_x = 58538.7 - (47.2304 * circle.pixel_y )
				local mission2d_y = (47.2287 * circle.pixel_x) + 70914

				-- env.info( "CheckImmediatSAR? Passe 2  mission2d_x: "..tostring(mission2d_x).." |mission2d_y: "..tostring(mission2d_y))

				if math.abs(ejectedPilot.x2d - mission2d_x) <= 50000 and math.abs(ejectedPilot.y2d - mission2d_y) <= 50000 then
					env.info( "DCE_CheckImmediatSAR? Passe 3 <= 50000  ")

					local result = math.pow ((ejectedPilot.x2d - mission2d_x), 2) + math.pow((ejectedPilot.y2d - mission2d_y), 2) <= math.pow((circle.radius * 47.229042083728), 2)
					env.info( "DCE_CheckImmediatSAR? Passe 4 result?  "..tostring(result))

					local debugA = type(result)
					env.info( "DCE_CheckImmediatSAR? Passe 5 debugA?  "..tostring(debugA))

					if result then

						--le soldierejectedPilot est déjà dans une zone CITY 
						-- pas de SAR ni CSAR

						-- rightSideOfBorder =  CheckPointInPoly2(pointSelected, camp.boundary[manhuntSide])

						local rightSideOfBorder
						if camp.boundary and camp.boundary[ejectedPilot.side] and camp.boundary[ejectedPilot.side] ~= nil then
							rightSideOfBorder =  CheckPointInPoly2({x=ejectedPilot.x2d,y=ejectedPilot.y2d}, camp.boundary[ejectedPilot.side])

						end

						env.info("DCE_SAR zone CITY rightSideOfBorde B? "..tostring(rightSideOfBorder))
						if rightSideOfBorder then
							ejectedPilot.status = "Rescued"
							env.info("DCE_SAR zone CITY Rescued B ")
						else
							ejectedPilot.status = "MIA"
							env.info("DCE_SAR zone CITY POW B ")
						end

						ejectedPilot.landingPossible = false
						return

					end
				end

			end
		end

		--regarde la partie aéronaval, pour voir si c'est le pedro qui y va

		local groups = coalition.getGroups(ejectedPilot.Coalition, Group.Category.SHIP)
		local selected_distance = 60000
		local selectedPoint = {}

		for i, gp in pairs(groups) do

			local units = gp:getUnits()
			local _unit = units[1]
			local gpName = Group.getName(gp)
			local uName = Unit.getName(_unit)

			if string.find(uName,"CV") or string.find(uName,"LHA")  then

				local callsign = _unit:getCallsign()
				local ShipTypeName = _unit:getTypeName()
				local BaseHelico = {
					x=0,
					y=0,
					z=0,
					name = "",
					Id = 0,
				}

				local uId = _unit:getID()

				local tempPoint = _unit:getPoint()
				BaseHelico.x = tempPoint.x
				BaseHelico.y = tempPoint.z
				BaseHelico.z = tempPoint.y
				BaseHelico.name = uName
				BaseHelico.Id = tonumber(uId)

				local description = _unit:getDesc()

				if _unit:isActive() then
					local distance = math.sqrt(math.pow(BaseHelico.x - ejectedPilot.x2d, 2) + math.pow(BaseHelico.y - ejectedPilot.y2d, 2))
					if distance < selected_distance then
						selected_distance = distance
						selectedPoint = BaseHelico
					end
				end
			end
		end

		--si le crash est proche du CV, c'est le pedro qui y va
		if selected_distance < 6000 then
			env.info( "DCE_CheckImmediatSAR? EE <6000 donc AERONAVAL?   ")
			--temp de reaction en fonction de la distance
			--6000 -> 30 s
			--m 	-> x s
			local tempReact = (selected_distance * 30) / 6000
			timer.scheduleFunction(PedroSAR, {selectedPoint, ejectedPilot}, timer.getTime() + tempReact)

		-- elseif zoneSAR[ejectedPilot.MGRS_Chute] == nil or ( zoneSAR[ejectedPilot.MGRS_Chute] and zoneSAR[ejectedPilot.MGRS_Chute].groupSAR and  zoneSAR[ejectedPilot.MGRS_Chute].groupSAR == "" ) then
		elseif  zoneSAR[ejectedPilot.MGRS_Chute].groupSAR == "" or zoneSAR[ejectedPilot.MGRS_Chute].groupSAR == nil or zoneSAR[ejectedPilot.MGRS_Chute].groupSAR == false then
			env.info( "DCE_CheckImmediatSAR? FFa >6000 donc TERRESTRE?   ")

			--find all flights in range to Ejected Pilot and hover ceiling
			local eligible_flights = {}
			for base_name, base in pairs(camp.SAR.alertSAR[ejectedPilot.side].base) do
				env.info( "DCE_CheckImmediatSAR? FFb  base_name "..tostring(base_name))
				for flight_n, flight in ipairs(base.ready) do

					local distance = math.sqrt(math.pow(flight.x - ejectedPilot.x2d, 2) + math.pow(flight.y - ejectedPilot.y2d, 2))

					if distance >= flight.range  then
						env.info( "DCE_CheckImmediatSAR? trop loin : "..tostring(distance).." > flight.range: "..tostring(flight.range))
					end

					if ejectedPilot.z2d >= flight.hHover then
						env.info( "DCE_CheckImmediatSAR? trop haut : "..tostring(ejectedPilot.z2d).." > flight.hHover: "..tostring(flight.hHover))
					end

					if distance < flight.range and ejectedPilot.z2d < flight.hHover then
						eligible_flights[flight.name] = distance
						env.info( "DCE_CheckImmediatSAR? FFc eligible_flights?   "..tostring(flight.name).."|distance: "..tostring(distance))
					end
				end
			end

			env.info( "DCE_CheckImmediatSAR? interB   ")
			-- _affiche(eligible_flights, "eligible_flights interB")

			--select the flight closest to rescue Ejected Pilot
			local selected_flight
			local selected_distance = 9999999
			for flight_name, distance in pairs(eligible_flights) do
				if distance < selected_distance then
					selected_flight = flight_name
					selected_distance = distance
					env.info( "DCE_CheckImmediatSAR? HH selected_flight?   "..tostring(selected_flight))
				end
			end

			env.info( "DCE_CheckImmediatSAR? interC  selected_flight  "..tostring(selected_flight))

			--assign selected flight to rescue
			if selected_flight then
				env.info( "DCE_CheckImmediatSAR? II   ")
				for base_name, base in pairs(camp.SAR.alertSAR[ejectedPilot.side].base) do
					for flight_n, flight in pairs(base.ready) do
						if flight.name == selected_flight then
							env.info( "CheckImmediatSAR? JJ    selected_flight: "..tostring(selected_flight))
							trigger.action.setUserFlag(flight.flag, true)		--set flag true to launch SAR Alert					

							-- local idInfo = Group.getByName(selected_flight):getID()
							-- local _side = Group.getByName(selected_flight):getCoalition()

							env.info( "DCE_CheckImmediatSAR? YY launch SAR Alert   ")

							timer.scheduleFunction(startSAR, {flight, ejectedPilot}, timer.getTime() + 30)

							if not zoneSAR[ejectedPilot.MGRS_Chute].groupSAR or zoneSAR[ejectedPilot.MGRS_Chute].groupSAR == nil then
								zoneSAR[ejectedPilot.MGRS_Chute].groupSAR = "Group_"..flight.name
							end

							table.insert(camp.SAR.alertSAR[ejectedPilot.side].assigned, flight )
							table.remove( camp.SAR.alertSAR[ejectedPilot.side].base[base_name].ready, flight_n)											--move flight from ready to assigned status
						end
					end
				end
			end
		end
	end
end

--{selectedPoint, ejectedPilot}
function PedroSAR(arg)
	local pt_start = arg[1]
	local pt_dest = arg[2]

	local nb
	if not ListPedro[pt_start.name] then
		nb = 1
	else
		nb = #ListPedro[pt_start.name]
	end

	_affiche(ListPedro, "DCE_PedroSAR A0 ListPedro")

	-- ["name"] = "Unit_Pedro_CV-59 Forrestal_1",
	-- Pedro_CV-59 Forrestal_1
	-- Unit_Pedro_CV-59 Forrestal_1

	local name = tostring(pt_start.name).."_"..tostring(nb)
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

	local tempPoint = uPedro:getPoint()
	pt_start.x = tempPoint.x
	pt_start.y = tempPoint.z
	pt_start.z = tempPoint.y

	local alt = 60

	local distance01 = math.sqrt(math.pow(pt_start.x - pt_dest.x2d, 2) + math.pow(pt_start.y - pt_dest.y2d, 2))		--distance between tanker and player
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
				["alt"] = pt_start.z,
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
											["command"] = "Custom_Altitude('" .. groupName .. "',  '  nil  ', '" .."1".. "')",
										},
									},
								},
							},
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
				["ETA"] = current_time ,
				["ETA_locked"] = true,
				["y"] = pt_start.y,
				["x"] = pt_start.x,
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
			["y"] = pt_dest.y2d,
			["x"] = pt_dest.x2d,
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
			["y"] = pt_dest.y2d,
			["x"] = pt_dest.x2d,
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
									["command"] = 'Custom_RTB_2_Base("' .. groupName .. '",  "' .. pt_start.name .. '",  "' .. speed .. '",  "' .. alt ..  '")',
								},
							},
						},
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = (distance01 / speed) + current_time ,
			["ETA_locked"] = false,
			["y"] = pt_dest.y2d,
			["x"] = pt_dest.x2d,
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
									["command"] = 'Custom_RTB_2_Base("' .. groupName .. '",  "' .. pt_start.name .. '",  "' .. speed .. '",  "' .. alt ..  '")',
								},
							},
						},
					}, -- end of ["tasks"]
				}, -- end of ["params"]
			}, -- end of ["task"]
			["type"] = "Land",
			["ETA"] = ((distance01 / speed) + current_time)*2,
			["ETA_locked"] = false,
			["y"] = pt_start.y,
			["x"] = pt_start.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
			['linkUnit'] = pt_start.Id,
			['helipadId'] = pt_start.Id,
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
	for MGRS_Chute, zone in pairs(zoneSAR) do
		if not nbOfTargetMan[MGRS_Chute] then nbOfTargetMan[MGRS_Chute] = 0 end
		for N_Pilot, ejectedPilot in ipairs(zone) do
			if ejectedPilot.name and ejectedPilot.embarked ~= true and ( not nbOfTargetMan[MGRS_Chute] or nbOfTargetMan[MGRS_Chute] < 2 )   then
				local unitEjectPilot = Unit.getByName(ejectedPilot.name)

				if unitEjectPilot and ejectedPilot.Coalition and  nbManhunt[ejectedPilot.Coalition] and  nbManhunt[ejectedPilot.Coalition] < 19 then
					env.info( "")
					env.info( "DCE_SAR:checkAddingManhunt   ejectedPilot.name | "..tostring(ejectedPilot.name).." ejectedPilot.inTheEnemyCamp "..tostring( ejectedPilot.inTheEnemyCamp))

					env.info( "DCE_SAR:checkAddingManhunt PASSE BBB ")

					local rightSideOfBorder
					if camp.boundary and camp.boundary[ejectedPilot.side] and camp.boundary[ejectedPilot.side] ~= nil then
						rightSideOfBorder =  CheckPointInPoly2({x=ejectedPilot.x2d,y=ejectedPilot.y2d}, camp.boundary[ejectedPilot.side])
						env.info( "DCE_checkAddingManhunt?  CCC boundary rightSideOfBorder __"..tostring(rightSideOfBorder).."__ ejectedPilot.side: "..tostring(ejectedPilot.side))
						if rightSideOfBorder == nil or rightSideOfBorder == false then
							ejectedPilot.inTheEnemyCamp = true
							env.info( "DCE_checkAddingManhunt? DDD boundary  ejectedPilot.inTheEnemyCamp = true  ")

						end
					end

					if  ejectedPilot.inTheEnemyCamp then

						env.info( "DCE_SAR:checkAddingManhunt EEE "..tostring(MGRS_Chute).." | "..tostring(ejectedPilot.name))
						env.info( "DCE_SAR:checkAddingManhunt timer.scheduleFunction(DespawnSoldierAliasPilot "..tostring(ejectedPilot.name))

						timer.scheduleFunction(AddSoldierAliasManhunt, unitEjectPilot, timer.getTime() + 2)
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
	for MGRS_Chute, zone in pairs(zoneSAR) do
		for N_Pilot, ejectedPilot in ipairs(zone) do
			if ejectedPilot.name and (not ejectedPilot.radio_on or ejectedPilot.radio_on == nil) and ejectedPilot.embarked ~= true   then

				local unitEjectPilot = Unit.getByName(ejectedPilot.name)
				local actualTime = timer.getTime()

				-- env.info( "LoopManagedRadioTransmission D "..tostring(unitEjectPilot).."|"..tostring(ejectedPilot.radio_start).."|"..tostring("<?").."|"..tostring(actualTime).."|")

				if unitEjectPilot and ejectedPilot.radio_start and ejectedPilot.radio_start <= actualTime then



					local PosEjectedPilot = unitEjectPilot:getPoint()

					local pilotVec3 = {
						x = PosEjectedPilot.x,
						y = land.getHeight({x = PosEjectedPilot.x, y = PosEjectedPilot.z}),
						z = PosEjectedPilot.z,
					}

					trigger.action.radioTransmission('l10n/DEFAULT/beacon.ogg', pilotVec3, 0, true, camp.EjectedPilotFrequency[ejectedPilot.side].radioBeacon, 1, 'radioBeacon_'..ejectedPilot.name)
					ejectedPilot.radio_on = true

					env.info( "DCE_SAR:LoopManagedRadioTransmission E frequency  "..tostring(camp.EjectedPilotFrequency[ejectedPilot.side].radioBeacon).." MGRS_Chute: "..tostring(ejectedPilot.MGRS_Chute).." |MGRS_Chute_10KM: "..tostring(ejectedPilot.MGRS_Chute_10KM).." "..tostring('radio_'..ejectedPilot.name))

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

	-- env.info( "DCE_RADIO StopRadioTransmissionSeat A  "..tostring(time))

	if EjectionSeatFrequency and #EjectionSeatFrequency >= 1 then
		-- env.info( "DCE_RADIO StopRadioTransmissionSeat B  "..tostring(time))

		for n, ejected in pairs(EjectionSeatFrequency) do
			-- env.info( "DCE_RADIO StopRadioTransmissionSeat C  "..tostring(time))

			if ejected.radio_on then
				-- env.info( "DCE_RADIO StopRadioTransmissionSeat D  "..tostring(time))

				if time > (ejected.time_on + 60) then
					-- env.info( "DCE_RADIO StopRadioTransmissionSeat E  "..tostring(time))

					trigger.action.stopRadioTransmission('GuardEjection'..ejected.name)
					ejected.radio_on = false
					-- env.info( "DCE_RADIO StopRadioTransmissionSeat F "..tostring('GuardEjection'..ejected.name))	
				end
			end
		end
	end
	return timer.getTime() + 5
end


local function detectsEjectedPilotEmbarkation(unitSAR, ejectedPilot)

	local outFonction = false
	local SAR_unitId = Unit.getID(unitSAR)
	local _SAR_Player = unitSAR:getPlayerName()
	local SAR_Name = unitSAR:getName()

	env.info( "DCE_SAR:_SAR_Player embarkation PASSE AA ")
	_affiche(unitSAR, "DCE_SAR unitSAR")
	_affiche(ejectedPilot, "DCE_SAR ejectedPilot")

	local function walk()

		if not unitSAR or not unitSAR:isActive()  then
			return
		end

		env.info( "DCE_SAR:_SAR_Player embarkation PASSE BB ")
		local unitEjectPilot = Unit.getByName(ejectedPilot.name)
		local PosEjectedPilot = unitEjectPilot:getPoint()
		local Pos_SAR = unitSAR:getPoint()
		local _SARinAir = unitSAR:inAir()

		local distance = math.ceil(math.sqrt(math.pow(Pos_SAR.x - PosEjectedPilot.x, 2) + math.pow(Pos_SAR.z - PosEjectedPilot.z, 2)))

		trigger.action.outTextForUnit( SAR_unitId , "PilotEmbarkation Embarkation Distance: "..tostring(distance).." (must be <200m)" , 2 , true)

		env.info( "DCE_SAR:_SAR_Player BB2 _SARinAir : "..tostring(_SARinAir))

		if distance <= 200 and not _SARinAir then
			env.info( "DCE_SAR:_SAR_Player SAR : "..tostring(_SAR_Player).." PilotEmbarkation PASSE CC _SARinAir "..tostring(_SARinAir))

			trigger.action.outTextForUnit( SAR_unitId , "PilotEmbarkation Use airborne troops for on-boarding" , 2 , false)

			if distance <= 20 then
				env.info( "DCE_SAR:_SAR_Player SAR : "..tostring(_SAR_Player).." PilotEmbarkation & StopRadioTransmission PASSE DD "..tostring(ejectedPilot.name))
				-- trigger.action.outTextForUnit( SAR_unitId , "DCE_SAR:_SAR_Player PilotEmbarkation & StopRadioTransmission PASSE DD "..tostring(ejectedPilot.name) , 15 , false)
				local embarkation = true
				DespawnSoldierAliasPilot({ejectedPilot.name, embarkation, _SAR_Player, SAR_Name  } )
				-- StopRadioTransmission(ejectedPilot.name)
				outFonction = true
				-- EjectedPilotOnBoard[SAR_Name] = EjectedPilotOnBoard[SAR_Name] or {}
				-- table.insert(EjectedPilotOnBoard[SAR_Name],ejectedPilot.name)
				-- _affiche(EjectedPilotOnBoard)

				walkEjectedPilot[SAR_unitId] = false
				return
			end

		elseif distance > 200 or _SARinAir then
			env.info( "DCE_SAR:_SAR_Player SAR : "..tostring(_SAR_Player).."PilotEmbarkation PASSE EE ")
			outFonction = true
			walkEjectedPilot[SAR_unitId] = false
			return
		end
		env.info( "DCE_SAR:_SAR_Player SAR : "..tostring(_SAR_Player).." PilotEmbarkation PASSE FF ")
		return timer.getTime() + 1
	end

	if outFonction then
		walkEjectedPilot[SAR_unitId] = false
		return
	end

	if unitSAR:isActive() then
		timer.scheduleFunction(walk, nil, timer.getTime() + 1)
	else
		return
	end

end

--guide le pilote humain SAR vers l ejectedPilot
local function guideTreuilSAR(unitSAR, PosEjectedPilot, ejectedPilot)

	local outFonction = false
	local SAR_unitId = Unit.getID(unitSAR)
	local _SAR_Player = unitSAR:getPlayerName()
	local SAR_Name = unitSAR:getName()

	local function guidage()

		local Pos_SAR = unitSAR:getPoint()
		local distance = math.ceil(math.sqrt(math.pow(Pos_SAR.x - PosEjectedPilot.x, 2) + math.pow(Pos_SAR.z - PosEjectedPilot.z, 2)))

		local ejectedPilot_h = land.getHeight({x = PosEjectedPilot.x, y = PosEjectedPilot.z})

		local SAR_h = math.ceil(Pos_SAR.y)
		local _SARinAir = unitSAR:inAir()

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
			x = PosEjectedPilot.x - Pos_SAR.x,
			y = PosEjectedPilot.y - Pos_SAR.y,
			z = PosEjectedPilot.z - Pos_SAR.z
			}
		local bearing_rad = math.atan2(bearing_vector.z, bearing_vector.x)
		if bearing_rad < 0 then
				bearing_rad = bearing_rad + (2 * math.pi)
		end
		local bearing = math.ceil(math.deg(bearing_rad))

		local high = math.ceil(SAR_h - ejectedPilot_h)
		-- local high = SAR_h - ejectedPilot_h 
		trigger.action.outTextForUnit( SAR_unitId , "Helitacking Distance: "..tostring(distance).." (need <10m) High: "..tostring(high).." (need <45m) Bearing: "..tostring(bearing) , 2 , true)

		if distance <= 10 and high <=45 then

			local speed = Object.getVelocity(unitSAR)
			speed = math.sqrt(speed.x^2 + speed.y^2 + speed.z^2)
			speed = math.ceil(speed * 10)/10

			trigger.action.outTextForUnit( SAR_unitId , "Speed: "..tostring(speed) .." ( need < 0.2)" , 2 , false)

			if speed <= 0.2 then
				local embarkation = false	--il n'est pas embaqué au sol, mais helitreuillé
				DespawnSoldierAliasPilot({ejectedPilot.name, embarkation, _SAR_Player, SAR_Name})
				-- EjectedPilotOnBoard[SAR_Name] = EjectedPilotOnBoard[SAR_Name] or {}
				-- table.insert(EjectedPilotOnBoard[SAR_Name],ejectedPilot.name)
				-- _affiche(EjectedPilotOnBoard)
				outFonction = true
				guideSAR[SAR_unitId] = false
				return
			end

		elseif distance > 100 or not _SARinAir then	-- high <= 2
			outFonction = true
			guideSAR[SAR_unitId] = false
			return
		end
		return timer.getTime() + 1
	end

	if outFonction then
		guideSAR[SAR_unitId] = false
		return
	end

	--si l helico n est pas posé
	if not walkEjectedPilot[SAR_unitId] or walkEjectedPilot[SAR_unitId] == nil then
		timer.scheduleFunction(guidage, nil, timer.getTime() + 1)
	end
end

function LoopSAR()
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
	-- 			smokeOK = false,
	-- 			embarked = false,
	-- 			embarkAndSafe = false,
	-- 		},
	-- 		[2] = {
	-- 			name = "ejected2",
	-- 			smokeOK = false,
	-- 			embarked = false,
	-- 			embarkAndSafe = false,
	-- 		},
	-- 	}
	-- }


	for coalition_name,coal in pairs(env.mission.coalition) do
		for country_n,country in ipairs(coal.country) do
			if country.helicopter then
				for group_n, group in ipairs(country.helicopter.group) do
					local gpSAR = Group.getByName(group.name)

					if gpSAR then

						local units_SAR = gpSAR:getUnits()
						local unitSAR
						local SAR_Coalition

						if units_SAR then
							for n=1, #units_SAR do
								unitSAR = units_SAR[n]

								if unitSAR then
									SAR_Coalition = tostring(unitSAR:getCoalition())
									local _SAR_Player = unitSAR:getPlayerName()

									if  unitSAR:isActive() and  string.lower(coalition_name) ==  coalitionId[SAR_Coalition] then
										local Pos_SAR = unitSAR:getPoint()
										local SAR_unitId = Unit.getID(unitSAR)
										local SAR_Name = unitSAR:getName()
										local _SARinAir = unitSAR:inAir()

										for MGRS_Chute, zone in pairs(zoneSAR) do
											for N_Pilot, ejectedPilot in ipairs(zone) do
												if ejectedPilot.name and not ejectedPilot.embarked and ejectedPilot.side == coalition_name  then
													local unitEjectPilot = Unit.getByName(ejectedPilot.name)

													if unitEjectPilot then

														local PosEjectedPilot = unitEjectPilot:getPoint()
														local distance = math.sqrt(math.pow(Pos_SAR.x - PosEjectedPilot.x, 2) + math.pow(Pos_SAR.z - PosEjectedPilot.z, 2))

														if distance <= 3000 and distance > 1000 and not ejectedPilot.smokeOK and _SARinAir then
															--active fumigene
															local pilotVec3 = {
																x = PosEjectedPilot.x,
																y = land.getHeight({x = PosEjectedPilot.x, y = PosEjectedPilot.z}),
																z = PosEjectedPilot.z,
															}

															-- Obtenir le vecteur du vent à la position du pilote
															local windVec3 = atmosphere.getWind(pilotVec3)

															-- Calculer la norme du vent dans le plan horizontal
															local windMagnitude = math.sqrt(windVec3.x^2 + windVec3.z^2)

															-- Position de décalage pour le fumigène
															local smokeOffsetDistance = 30
															local smokePosition

															if windMagnitude > 0 then
																-- Normaliser la direction opposée au vent
																local windDirectionOpposite = {
																	x = -windVec3.x / windMagnitude,
																	z = -windVec3.z / windMagnitude,
																}

																-- Calculer la position du fumigène
																smokePosition = {
																	x = pilotVec3.x + windDirectionOpposite.x * smokeOffsetDistance,
																	z = pilotVec3.z + windDirectionOpposite.z * smokeOffsetDistance,
																}
																smokePosition.y = land.getHeight({x = smokePosition.x, y = smokePosition.z})
															else
																-- Si le vent est nul, placer le fumigène 10 mètres au nord du pilote
																smokePosition = {
																	x = pilotVec3.x,
																	z = pilotVec3.z + smokeOffsetDistance,
																}
																smokePosition.y = land.getHeight({x = smokePosition.x, y = smokePosition.z})
															end

															    -- Placer le fumigène
    														trigger.action.smoke(smokePosition, trigger.smokeColor.Orange)

															-- Indiquer que le fumigène a été placé
															ejectedPilot.smokeOK = true

														elseif distance <= 1000 and distance > 450 then

															if _SAR_Player then
																ejectedPilot.landingPossible = true
																-- trigger.action.outTextForUnit( SAR_unitId , "ForUnit _SAR_Player detected "..tostring(_SAR_Player) , 2 , false)
																env.info( "DCE_SAR_Player detected "..tostring(_SAR_Player).." SAR_unitId: "..tostring(SAR_unitId))

															end

														elseif distance <= 450 and not _SAR_Player and not ejectedPilot.scheduleEmbarkedOK then

															ejectedPilot.scheduleEmbarkedOK = true

															env.info( "DCE_SAR:LoopSTARt distance <= 450 "..tostring(ejectedPilot.name))

															timer.scheduleFunction(StopRadioTransmission, ejectedPilot.name, timer.getTime() + 149)

															if not ejectedPilot.landingPossible then
																env.info( "DCE_SAR:LoopSTARt timer.scheduleFunction(DespawnSoldierAliasPilot "..tostring(ejectedPilot.name))
																local embarkation = false	--il n'est pas embaqué au sol, mais helitreuillé
																timer.scheduleFunction(DespawnSoldierAliasPilot, {ejectedPilot.name, embarkation, nil , SAR_Name}, timer.getTime() + 150)

															else
																env.info( "DCE_SAR:Pilot.landingPossible, helico: |"..tostring(_SAR_Player).."| |"..tostring(SAR_Name).."| DEVRAIT se poser pour recuperer "..tostring(ejectedPilot.name))

																if not unitEjectPilot:isExist()  then
																	StopRadioTransmission(ejectedPilot.name)
																end
															end

														elseif distance <= 450 and _SAR_Player then

															local h = math.ceil(Pos_SAR.y - land.getHeight({x = Pos_SAR.x, y = Pos_SAR.z}))
															-- local _SARinAir = unitSAR:inAir()
															env.info( "DCE_SAR:_SAR_Player Pilot.landingPossible, helico: |"..tostring(_SAR_Player).."| |"..tostring(SAR_Name).."| HumainPilot se pose ou fait hoover pour recuperer "..tostring(ejectedPilot.name))

															env.info( "DCE_SAR:_SAR_Player Hauteur?: "..h.." _SARinAir?: "..tostring(_SARinAir).." "..distance.." guideSAR "..tostring(guideSAR[SAR_unitId]).." walkEjectedPilot "..tostring(walkEjectedPilot[SAR_unitId]))

															-- l helicopter tente un helitreuillage
															-- if h > 3 and distance <= 100 and (guideSAR[SAR_unitId] == nil or guideSAR[SAR_unitId] == false) then
															if _SARinAir then
																
																walkEjectedPilot[SAR_unitId] = false

																if distance <= 100 and not guideSAR[SAR_unitId] then
																	env.info( "DCE_SAR:_SAR_Player SAR tries helitacking")

																	guideSAR[SAR_unitId] = true
																	guideTreuilSAR(unitSAR, PosEjectedPilot, ejectedPilot)
																elseif distance > 100 then
																	guideSAR[SAR_unitId] = false
																end


															--l helicoptere est considéré posé
															-- elseif h <= 3 and distance <= 200 and (walkEjectedPilot[SAR_unitId] == nil or walkEjectedPilot[SAR_unitId] == false) then
															elseif not _SARinAir then

																guideSAR[SAR_unitId] = false	-- le player s'est posé

																if  distance <= 200 and not walkEjectedPilot[SAR_unitId] then
																	trigger.action.outTextForUnit( SAR_unitId ,  "you are less than 200m from the wrecked pilot, he should be walking towards you: ", 2 , true)
																	env.info( "DCE_SAR:_SAR_Player SAR attempts ground embarkation")

																	walkEjectedPilot[SAR_unitId] = true
																	detectsEjectedPilotEmbarkation(unitSAR, ejectedPilot)
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

	return timer.getTime() + 5

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
		["y"] = tonumber(element.y2d),
		["x"] = tonumber(element.x2d),
		["dead"] = dead,
	}

	staticObj.category = DCS_CategoryById[element.categoryId]

	coalition.addStaticObject(element.countryId, staticObj)

	createWreck[wreckName] = true

	if camp.debug then
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

	local pName
	local player
	local playerId

	if arg and arg[1] then
		pName = arg[1]
		player = arg[2]
		playerId = arg[3]
	end

	-- local eventData = {
	-- 	initiatorPilotName = initiatorPilotName,
	-- 	isPlayer = isPlayer,
	-- 	unitName = unitName,
	-- 	Uid = event.initiator:getID(),
	-- 	aircraftType = event.initiator:getTypeName(),
	-- 	lifePourcent = lifePourcent,
	-- 	crashPoint = event.initiator:getPoint(),
	-- 	unit = event.initiator,
	-- 	gpGid = gpGid,
	-- }

	if pName then

		local unitName = player:getName()
		local playerPoint = player:getPoint()				--get target point

		local countryId = player:getCountry()
		local initiatorSIDE = player:getCoalition()
		local side = coalitionIdNumeric[tonumber(initiatorSIDE)]


		local infoPlayer = {
			initiatorPilotName = pName,
			unit = player,
			unitName = unitName,
			aircraftType = player:getTypeName(),
			Coalition = player:getCoalition(),
			initiatorMissionID = player:getID(),
			initiatorSIDE = player:getCoalition(),
			countryId = countryId,
			initiatorCountry = string.lower(country.name[countryId]),
			side = side,
			x = playerPoint.x,
			y = playerPoint.y,
			z = playerPoint.z,
			unitId = playerId,
		}

		env.info( "DCE_getOut infoPlayer EventT :radioTransmission frequency A  "..tostring(camp.EjectedPilotFrequency[infoPlayer.side].GuardEjection).." | "..tostring('GuardEjection'..unitName))
		trigger.action.radioTransmission('l10n/DEFAULT/ejectionRadioBeacon.ogg', player, 0, true, camp.EjectedPilotFrequency[infoPlayer.side].GuardEjection, 1, 'GuardEjection'..unitName)
		env.info( "DCE_getOut infoPlayer EventT :radioTransmission frequency B  "..tostring(camp.EjectedPilotFrequency[infoPlayer.side].GuardEjection).." | "..tostring('GuardEjection'..unitName))

		--position precise pour le fumigene
		local pilotVec3 = {
			x = playerPoint.x,
			y = land.getHeight({x = playerPoint.x, y = playerPoint.z}),
			z = playerPoint.z,
		}

		--position futur de l ejectedPilot
		infoPlayer.x2d = pilotVec3.x + 150
		infoPlayer.y2d = pilotVec3.z + 150
		infoPlayer.z2d = pilotVec3.y


		local life = player:getLife()
		local init_life = player:getLife0()
		local lifePourcent = 100
		local isPlayer = true
		if init_life then
			lifePourcent = life/init_life*100
			infoPlayer.rate = lifePourcent
		end


		local current_time = timer.getTime()
		if camp.debug then
			local logStr = "GetOutPlayer = " .. TableSerialization(GroundDamagedFlyingMachine, 0)
			local grpnameClean = pName:gsub('[%p%c%s]', '_')
			local logFile = io.open(PathDCE.."Debug\\"..infoPlayer.unitId.."_"..grpnameClean.."_".. "DamagedFM_"..current_time..".lua", "w")
			if logFile then
				logFile:write(logStr)
				logFile:close()
			else
				env.info("DCE_GetOutPlayer: Failed to open log file for writing.")
			end
		end

		--si l'helico ne vole pas
		if pilotVec3.y <= 100 then

			SumSoldierAliasPilot = SumSoldierAliasPilot + 1
			infoPlayer.SumEjectedPilotDay  = SumSoldierAliasPilot

			infoPlayer.getOutHelicopter  = true

			if infoPlayer.initiatorPilotName then
				infoPlayer.name = "Mis"..camp.mission.."_Pilot_"..infoPlayer.initiatorPilotName.."_Nb"..tostring(infoPlayer.SumEjectedPilotDay).."_Damaged"
			end

			-- infoPlayer.name = infoPlayer.name:gsub('[%p%c%s]', '_')
			infoPlayer.name = CleanName(infoPlayer.name)

			local typeLand = land.getSurfaceType({x =infoPlayer.x2d, y = infoPlayer.y2d})

			env.info("DCE_getOut infoPlayer E test typeLand "..tostring(typeLand))

			if typeLand ~= 3 and typeLand ~= 5  then

				AddSoldierAliasPilot(infoPlayer)
				infoPlayer.createdSoldier = true

				-- Obtenir le vecteur du vent à la position du pilote
				local windVec3 = atmosphere.getWind(pilotVec3)

				-- Calculer la norme du vent dans le plan horizontal
				local windMagnitude = math.sqrt(windVec3.x^2 + windVec3.z^2)

				-- Position de décalage pour le fumigène
				local smokeOffsetDistance = 30
				local smokePosition

				if windMagnitude > 0 then
					-- Normaliser la direction opposée au vent
					local windDirectionOpposite = {
						x = -windVec3.x / windMagnitude,
						z = -windVec3.z / windMagnitude,
					}

					-- Calculer la position du fumigène
					smokePosition = {
						x = pilotVec3.x + windDirectionOpposite.x * smokeOffsetDistance,
						y = pilotVec3.y,
						z = pilotVec3.z + windDirectionOpposite.z * smokeOffsetDistance,
					}
				else
					-- Si le vent est nul, placer le fumigène 10 mètres au nord du pilote
					smokePosition = {
						x = pilotVec3.x,
						y = pilotVec3.y,
						z = pilotVec3.z + smokeOffsetDistance,
					}
				end

					-- Placer le fumigène
				trigger.action.smoke(smokePosition, trigger.smokeColor.Orange)

			end


			local log_entry = {
				type = "eject",
				initiator = unitName,
				initiatorPilotName = pName,
				t = timer.getTime(),
			}

			table.insert(CustomLog, log_entry)

			CheckImmediatSAR(infoPlayer)

			env.info("DCE_getOut F test despawn ")

			timer.scheduleFunction(despawn2, {infoPlayer.unit, "GetOutGDFM if pName" }, timer.getTime() + 30)

			timer.scheduleFunction(spawnWreck, infoPlayer, timer.getTime() + 35)

			createWreckCrew[infoPlayer.unitName] = true

		end

	else

		for id_, key in pairs(GroundDamagedFlyingMachine) do

			for occurenceN = #key, 1, -1 do
				local damaged = key[occurenceN]

				if not pName and not damaged.isPlayer then

					-- if damaged.unit and damaged.unit:isExist() and damaged.unit:isActive() and not damaged.unit:inAir() then
					if damaged and damaged.unit or not damaged.unit:inAir() then

						if not createWreckCrew[damaged.unitName] then

							-- if damaged.unit:getPlayerName()	then
							-- 	env.info( "DCE_getOut EventT :radioTransmission frequency A  "..tostring(camp.EjectedPilotFrequency[damaged.side].GuardEjection).." | "..tostring('GuardEjection'..damaged.unitName))
							-- 	trigger.action.radioTransmission('l10n/DEFAULT/ejectionRadioBeacon.ogg', damaged, 0, true, camp.EjectedPilotFrequency[damaged.side].GuardEjection, 1, 'GuardEjection'..damaged.unitName)
							-- 	env.info( "DCE_getOut EventT :radioTransmission frequency B  "..tostring(camp.EjectedPilotFrequency[damaged.side].GuardEjection).." | "..tostring('GuardEjection'..damaged.unitName))
							-- end

							damaged.x = damaged.crashPoint.x
							damaged.y = damaged.crashPoint.y
							damaged.z = damaged.crashPoint.z

							--position precise pour le fumigene
							local pilotVec3 = {
								x = damaged.crashPoint.x,
								y = land.getHeight({x = damaged.crashPoint.x, y = damaged.crashPoint.z}),
								z = damaged.crashPoint.z,
							}

							damaged.x2d = pilotVec3.x + 50
							damaged.y2d = pilotVec3.z + 50
							damaged.z2d = pilotVec3.y

							SumSoldierAliasPilot = SumSoldierAliasPilot + 1
							damaged.SumEjectedPilotDay  = SumSoldierAliasPilot

							damaged.getOutHelicopter  = true

							if damaged.initiatorPilotName then
								damaged.name = "Mis"..camp.mission.."_Pilot_"..damaged.initiatorPilotName.."_Nb"..tostring(damaged.SumEjectedPilotDay).."_Damaged"
							else
								damaged.name = "Mis"..camp.mission.."_Pilot_"..damaged.unitName.."_Nb"..tostring(damaged.SumEjectedPilotDay).."_Damaged"
							end

							-- damaged.name = damaged.name:gsub('[%p%c%s]', '_')
							damaged.name = CleanName(damaged.name)

							local typeLand = land.getSurfaceType({x =damaged.x2d, y = damaged.y2d})

							if typeLand ~= land.SurfaceType.WATER and typeLand ~= land.SurfaceType.RUNWAY  then

								AddSoldierAliasPilot(damaged)
								damaged.createdSoldier = true
								-- Obtenir le vecteur du vent à la position du pilote
								local windVec3 = atmosphere.getWind(pilotVec3)

								-- Calculer la norme du vent dans le plan horizontal
								local windMagnitude = math.sqrt(windVec3.x^2 + windVec3.z^2)

								-- Position de décalage pour le fumigène
								local smokeOffsetDistance = 30
								local smokePosition

								if windMagnitude > 0 then
									-- Normaliser la direction opposée au vent
									local windDirectionOpposite = {
										x = -windVec3.x / windMagnitude,
										z = -windVec3.z / windMagnitude,
									}

									-- Calculer la position du fumigène
									smokePosition = {
										x = pilotVec3.x + windDirectionOpposite.x * smokeOffsetDistance,
										y = pilotVec3.y,
										z = pilotVec3.z + windDirectionOpposite.z * smokeOffsetDistance,
									}
								else
									-- Si le vent est nul, placer le fumigène 10 mètres au nord du pilote
									smokePosition = {
										x = pilotVec3.x,
										y = pilotVec3.y,
										z = pilotVec3.z + smokeOffsetDistance,
									}
								end

									-- Placer le fumigène
								trigger.action.smoke(smokePosition, trigger.smokeColor.Orange)

							end

							CheckImmediatSAR(damaged)

							timer.scheduleFunction(despawn2, {damaged.unit, "GetOutGDFM, else IA" }, timer.getTime() + 30)

							timer.scheduleFunction(spawnWreck, damaged, timer.getTime() + 35)

							createWreckCrew[damaged.unitName] = true

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

		if not pName then
			return timer.getTime() + 5
		end
	end
end


if camp.SAR and camp.SAR.helicopter then
	timer.scheduleFunction(LoopSAR, nil, timer.getTime() + 5)
	timer.scheduleFunction(LoopManagedRadioTransmission, nil, timer.getTime() + 60)
end


timer.scheduleFunction(checkAddingManhunt, nil, timer.getTime() + 5)

timer.scheduleFunction(StopRadioTransmissionSeat, nil, timer.getTime() + 30)

timer.scheduleFunction(GetOutGDFM, nil, timer.getTime() + 6)

env.info("DCE_SAR END OF LOADING SAR.lua ")