-- initie par MAIN_NextMission
-- auteur : Miguel21
-- Garde le Pedro (Helicoptere de sauvetage), proche du CV, malgr� les changements de cap
-- Keeps the Pedro (Rescue Helicopter), close to the CV, in spite of course changes.
------------------------------------------------------------------------------------------------------- 
-- last modification cleanCode_b
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/Pedro.lua"] = "1.5.16"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_b				(b springCleaning)
-- adjustment_a				(CVN to CV)
-- debug_b					(b Pedro cycle)
-- modification M61_a		 SAR
-- modification M40_h		 Pedro Helicopter (i use new follow task)(h debug)(b: TakeOff)
-------------------------------------------------------------------------------------------------------


ListPedro = {}

local function injecteRoutePedro(arg)
	local pt_start = arg[1]
	local pt_dest = arg[2]

	local satarty = pt_start.y
	local satartx = pt_start.x
	local current_time = timer.getTime() +1
	local speed = 13.9		-- v = m/s	

	local distance01 = math.sqrt(math.pow(pt_start.x - pt_dest.x, 2) + math.pow(pt_start.y - pt_dest.y, 2))

	local nbWaypointCV
	local uCVUnit = Unit.getByName(pt_start.CV_Name)
	local gCVGroup = uCVUnit:getGroup()
	local gCVId = gCVGroup:getID()

	for coalition_name,coal in pairs(env.mission.coalition) do
		for country_n,country in ipairs(coal.country) do
			if country.ship then
				for group_n, group in ipairs(country.ship.group) do
					if pt_start.CV_Name == group.units[1].name then
						nbWaypointCV = #group.route.points
					end
				end
			end
		end
	end

	env.info( "Pedro.lua, nbWaypointCV "..tostring(nbWaypointCV))
	-- trigger.action.outText("Pedro.lua, nbWaypointCV "..tostring(nbWaypointCV), 30)

	local route = {}
	route = {
			[1] =
			{
				["alt"] = 25,
				["action"] = "From Parking Area Hot",
				["type"] = "TakeOffParkingHot",
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
								["enabled"] = true,
								["auto"] = false,
								["id"] = "Follow",
								["number"] = 1,
								["params"] =
								{
									["lastWptIndexFlagChangedManually"] = true,
									["groupId"] = tonumber(gCVId),
									["lastWptIndex"] = tonumber(nbWaypointCV),
									["lastWptIndexFlag"] = true,
									["pos"] =
									{
										["y"] = 0,
										["x"] = -50,
										["z"] = -100,
									}, -- end of ["pos"]
								}, -- end of ["params"]
							}, -- end of [1]
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
				["ETA"] = current_time ,
				["ETA_locked"] = true,
				["y"] = satarty,
				["x"] = satartx,
				["name"] = "",
				["formation_template"] = "",
				["speed_locked"] = true,
				['linkUnit'] = pt_start.Id,
				['helipadId'] = pt_start.Id,
			}, -- end of [1] 
		[2] =
		{
			["alt"] = 25,
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
							[1] =
							{
								["enabled"] = true,
								["auto"] = false,
								["id"] = "Follow",
								["number"] = 1,
								["params"] =
								{
									["lastWptIndexFlagChangedManually"] = true,
									["groupId"] = tonumber(gCVId),
									["lastWptIndex"] = tonumber(nbWaypointCV),
									["lastWptIndexFlag"] = true,
									["pos"] =
									{
										["y"] = 0,
										["x"] = -50,
										["z"] = -100,
									}, -- end of ["pos"]
								}, -- end of ["params"]
							}, -- end of [1]
						}, -- end of ["tasks"]
					}, -- end of ["params"]
				}, -- end of ["task"]
			["type"] = "Turning Point",
			["ETA"] = (distance01 / speed) + current_time ,
			["ETA_locked"] = false,
			["y"] = pt_dest.y,
			["x"] = pt_dest.x,
			["name"] = "",
			["formation_template"] = "",
			["speed_locked"] = true,
		},
	} -- end of ["route"]


	local Mission = {
		id = 'Mission',
		params = {
			route = {
				points = route
			}
		}
	}

	if campL.debug then
		local logStr = "injectPedro = " .. TableSerialization(Mission, 0)
		local FlightNameClean = pt_start.PedroName:gsub('[%p%c%s]', '_')
		local logFile = io.open(PathDCE.."Debug\\"..FlightNameClean.."_".. "injecteRoutePedro.lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_injecteRoutePedro: Failed to open log file for writing.")
		end
	end

	local ctr = Group.getByName("Group_"..pt_start.PedroName):getController()

	-- local ctr = value.Pedro_group:getController()
	Controller.setTask(ctr, Mission)

end



local function createPedro(arg)

    local uCV_Name = arg[1]
	local parameters = arg[2]

	-- TypePedroByCV[cvName] = {
	-- 	type = _group.units[1].type,
	-- 	payload = _group.units[1].payload,
	-- 	livery_id = _group.units[1].livery_id,
	-- 	AddPropAircraft = _group.units[1].AddPropAircraft,
	-- 	callsign = _group.units[1].callsign,
	-- }

	--TODO ajouter ici une condition de distance pour ne pas annoncer le spawn à tout le monde, mais seulement aux joueurs proches du CV
	env.info( "Attention, Pedro's helicopter will spawning on the CV "..tostring(uCV_Name))
	trigger.action.outText("Attention, Pedro's helicopter will spawning on the CV "..tostring(uCV_Name), 30)

	if not ListPedro[uCV_Name] then ListPedro[uCV_Name] = {uCV_Name} end
	table.insert(ListPedro[uCV_Name], #ListPedro[uCV_Name])

	-- local BaseUnit = Unit.getByName(pt_start.name)
	local unitCV = Unit.getByName(uCV_Name)
	local uCV_tempPointVec3 = unitCV:getPoint()
	local satartx = uCV_tempPointVec3.x
	local satarty = uCV_tempPointVec3.z
	local pt_start = {
		x = satartx,
		y = satarty,
		PedroName = "Pedro_"..uCV_Name.."_"..tostring(#ListPedro[uCV_Name]),
		CV_Name = uCV_Name,
	}

	local current_time = timer.getTime() +1
	-- local speed = 46.25		-- v = m/s
	-- local nbFlight = math.random(2,10)

	--from  mist.getHeading
	local u = Unit.getByName(uCV_Name)
	local unitpos = u:getPosition()
	local headingCV
	if unitpos then
		local heading = math.atan2(unitpos.x.z, unitpos.x.x)

		-- Heading = Heading + mist.getNorthCorrection(unitpos.p)

		if heading < 0 then
			heading = heading + 2*math.pi
		end
		headingCV = heading
	end

	local pt_dest = GetOffsetPoint(pt_start, headingCV, 300)

	local groupData = {
		["visible"] = false,
		["taskSelected"] = true,
		["route"] =
		{
			[1] =
			{
			}, -- end of [1] 			
		}, -- end of ["route"]
		["tasks"] =
		{
		}, -- end of ["tasks"]
		["hidden"] = false,
		["units"] =
		{
			[1] =
			{
				["type"] = tostring(parameters.type),
				["skill"] = "High",
				["y"] = satarty,
				["x"] = satartx,
				["name"] = "Unit_"..pt_start.PedroName,
				["heading"] = 0,
				["alt"] = 60,
				["alt_type"] = "BARO",
				["livery_id"] = tostring(parameters.livery_id),
				-- ["ropeLength"] = 15,
				["speed"] = 20,
				["psi"] = -0,
				["payload"] = parameters.payload,
				-- {
				-- 	["pylons"] =
				-- 	{
				-- 	}, -- end of ["pylons"]
				-- 	["fuel"] = "1100",
				-- 	["flare"] = 30,
				-- 	["chaff"] = 30,
				-- 	["gun"] = 100,
				-- }, -- end of ["payload"]
				["onboard_num"] =  tostring(math.random(700, 710)),

			}, -- end of [1]
		}, -- end of ["units"]
		["y"] = satarty + 150,
		["x"] = satartx + 150,
		["name"] = "Group_"..pt_start.PedroName,
		["start_time"] = current_time,
		["task"] = "Transport",
		["communication"] = true,
		["frequency"] = 243,
	} -- end of [1]

	if campL.debug then
		local logStr = "Mission = " .. TableSerialization(groupData, 0)
		local grpnameClean = pt_start.PedroName:gsub('[%p%c%s]', '_')
		local logFile = io.open(PathDCE .. "Debug\\" .. grpnameClean .. "_create_Pedro_" .. current_time .. ".lua", "w")
		if logFile then
			logFile:write(logStr)
			logFile:close()
		else
			env.info("DCE_create_Pedro_: Failed to open log file for writing.")
		end
	end

	coalition.addGroup(country.id.USA, Group.Category.HELICOPTER, groupData)

	env.info( "createPedroR passe B2 ")

	timer.scheduleFunction(injecteRoutePedro, {pt_start, pt_dest}, timer.getTime() + 1)

end

function NeedPedro(uCV_Name, parameters)
	if uCV_Name  then
		timer.scheduleFunction(createPedro, { uCV_Name, parameters }, timer.getTime() + 30)
	end
end

