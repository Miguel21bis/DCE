--To advance the campaign time for next mission
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- last modification:  springCleaning debug_f
if not versionDCE then versionDCE = {} end
versionDCE["DC_Time.lua"] = "1.5.16"
------------------------------------------------------------------------------------------------------- 
-- debug_f 					(f wrong time jump between missions)(e aliasYear)(d advances 2 times)(c hourlyTolerance work)(b: bug idle_time fin de mission)(a n'avance pas le temps entre accept mission et next)
-- adjustment_f				(f hoursFrom)(d: CampTotalTimeS)((c_Skipmission_flag)b diminue time entre tentative pour avoir le lev� de soleil)(a CampTotalTimeS)
-- cleancode_a				(a springCleaning)
-- modification M53_b		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M25_b 		onlyDayMission.
------------------------------------------------------------------------------------------------------- 
--Global variable:
--determine mission time of day
Daytime	= ""																					--variable what Daytime the is covered in the duration of the mission

--local variable:
local actualTime
local daysfrom
local hoursFrom
local referenceTime
local idle_time = 0
local overnightTime = 0

--campaign day counter
if camp.day == nil then																			--if counter does not exist yet
	camp.day = 1																				--start counting with first day in campaign
end


if AcceptedMission and MissionInstance < 2 then

	if not TimeAlreadyAdded then
		camp.time = camp.time + mission_ini.mission_duration
	end
	local aliasInitYear = camp.dateInit.year

	if aliasInitYear < 1970 then
		aliasInitYear = 1970
	end

	local aliasYear = camp.dateInit.year
	if aliasYear < 1970 then
		aliasYear = 1970
	end

	-- On n'avance pas le temps entre une mission acceptée et une suivante

	-- Modification M25.b OnlyDayMission
	if mission_ini.onlyDayMission then
		-- Définir les heures de tolérance pour les missions de jour
		local HTdawn = mission_ini.dawn - (86400 * (mission_ini.hourlyTolerance / 100))
		local HTdusk = mission_ini.dusk + (86400 * (mission_ini.hourlyTolerance / 100))
		local tempTime = Deepcopy(camp.time)

		-- Ajuster le temps jusqu'à la prochaine plage de jour
		while (tempTime % 86400 < HTdawn or tempTime % 86400 > HTdusk) or (tempTime % 86400 + (mission_ini.mission_duration) < HTdawn or ((tempTime % 86400) + mission_ini.mission_duration > HTdusk)) do
			overnightTime = overnightTime + 300
			tempTime = tempTime + 300
		end
	end

	-- Ajouter addTime à camp.time après tous les ajustements
	camp.time = camp.time + overnightTime

	while camp.time >= 86400 do																		--repeat as long as time 24 hours or more
		camp.time = camp.time - 86400																--remove 24 hours from time
		camp.date.day = camp.date.day + 1															--add a day to date
		if camp.date.day >= 32 and (camp.date.month == 1 or camp.date.month == 3 or camp.date.month == 5 or camp.date.month == 7 or camp.date.month == 8 or camp.date.month == 10 or camp.date.month == 12) then	--month change for large months
			camp.date.day = 1																		--first day of next month
			camp.date.month = camp.date.month + 1													--advance month
		elseif camp.date.day >= 31 and (camp.date.month == 4 or camp.date.month == 6 or camp.date.month == 9 or camp.date.month == 11) then	--month change for small months
			camp.date.day = 1																		--first day of next month
			camp.date.month = camp.date.month + 1													--advance month
		elseif camp.date.day >= 30 and camp.date.month == 2 then									--month change for February
			camp.date.day = 1																		--first day of next month
			camp.date.month = camp.date.month + 1													--advance month
		end
		if camp.date.month >= 13 then																--year change
			camp.date.month = 1																		--first month of next year
			camp.date.year = camp.date.year + 1														--advance year
		end
		camp.day = camp.day + 1																		--counter for campaign days
	end

	referenceTime = os.time{day=camp.dateInit.day, year=aliasInitYear, month=camp.dateInit.month}
	actualTime = os.time{day=camp.date.day, year=aliasYear, month=camp.date.month} + camp.time
	CampTotalTimeS = os.difftime(actualTime, referenceTime) --/ (24 * 60 * 60) -- seconds in a day


else	--si la mission est acceptée, on prend juste les infos sans ajouter de temps (idle)

	-- On n'avance pas le temps entre une mission acceptée et une suivante

	if not Firstmission_flag or (MissionInstance and MissionInstance > 1) then
		-- Calculer idle_time
		idle_time = math.random(mission_ini.idle_time_min, mission_ini.idle_time_max)
	end

	camp.time = camp.time + idle_time

	-- Modification M25.b OnlyDayMission
	if mission_ini.onlyDayMission then
		-- Définir les heures de tolérance pour les missions de jour
		local HTdawn = mission_ini.dawn - (86400 * (mission_ini.hourlyTolerance / 100))
		local HTdusk = mission_ini.dusk + (86400 * (mission_ini.hourlyTolerance / 100))
		local tempTime = Deepcopy(camp.time)

		-- Ajuster le temps jusqu'à la prochaine plage de jour
		while (tempTime % 86400 < HTdawn or tempTime % 86400 > HTdusk) or (tempTime % 86400 + (mission_ini.mission_duration) < HTdawn or ((tempTime % 86400) + mission_ini.mission_duration > HTdusk)) do
			overnightTime = overnightTime + 300
			tempTime = tempTime + 300
		end
	end

	-- Ajouter addTime à camp.time après tous les ajustements
	camp.time = camp.time + overnightTime


	while camp.time >= 86400 do																		--repeat as long as time 24 hours or more
		camp.time = camp.time - 86400																--remove 24 hours from time
		camp.date.day = camp.date.day + 1															--add a day to date
		if camp.date.day >= 32 and (camp.date.month == 1 or camp.date.month == 3 or camp.date.month == 5 or camp.date.month == 7 or camp.date.month == 8 or camp.date.month == 10 or camp.date.month == 12) then	--month change for large months
			camp.date.day = 1																		--first day of next month
			camp.date.month = camp.date.month + 1													--advance month
		elseif camp.date.day >= 31 and (camp.date.month == 4 or camp.date.month == 6 or camp.date.month == 9 or camp.date.month == 11) then	--month change for small months
			camp.date.day = 1																		--first day of next month
			camp.date.month = camp.date.month + 1													--advance month
		elseif camp.date.day >= 30 and camp.date.month == 2 then									--month change for February
			camp.date.day = 1																		--first day of next month
			camp.date.month = camp.date.month + 1													--advance month
		end
		if camp.date.month >= 13 then																--year change
			camp.date.month = 1																		--first month of next year
			camp.date.year = camp.date.year + 1														--advance year
		end
		camp.day = camp.day + 1																		--counter for campaign days
	end

	if not camp.dateInit then
		local tempCamp = camp
		dofile("Init/camp_init.lua")
		local campInit =  Deepcopy(camp)
		camp = tempCamp
		camp.dateInit = {
			day = campInit.date.day,
			year = campInit.date.year,
			month = campInit.date.month,
		}
	end

	local aliasInitYear = camp.dateInit.year
	if aliasInitYear < 1970 then
		aliasInitYear = 1970
	end

	local aliasYear = camp.date.year
	if aliasYear < 1970 then
		aliasYear = 1970
	end

	referenceTime = os.time{day=camp.dateInit.day, year=aliasInitYear, month=camp.dateInit.month}
	actualTime = os.time{day=camp.date.day, year=aliasYear, month=camp.date.month} + camp.time
	CampTotalTimeS = os.difftime(actualTime, referenceTime) --/ (24 * 60 * 60) -- seconds in a day
	camp.date.CampTotalTimeS = CampTotalTimeS
	daysfrom = CampTotalTimeS/ (24 * 60 * 60) -- seconds in a day
	hoursFrom = CampTotalTimeS/ (3600) -- seconds to hours
end


mission["start_time"] = camp.time																--set mission start time
mission["date"]["Day"] = camp.date.day															--set mission day
mission["date"]["Year"] = camp.date.year														--set mission year
mission["date"]["Month"] = camp.date.month														--set mission month

-- local targetTime =  camp.time + mission_ini.startup_time_player
local targetTime =  camp.time + mission_ini.mission_duration

--dawn == aube
--dusk == crépuscule
if targetTime >= mission_ini.dawn and targetTime <= mission_ini.dusk then		--current time is between dawn and dusk
	if targetTime  <= mission_ini.dusk then										--mission duration ends before dusk
		Daytime = "day"
	else																		--mission duration ends after dusk
		Daytime = "day-night"
	end
else																			--current time is between dusk and dawn
	if targetTime < mission_ini.dawn then										--mission starts before dawn
		if targetTime < mission_ini.dawn then									--mission duration ends before dawn
			Daytime = "night"
		else
			Daytime = "night-day"
		end
	else																		--mission starts after dusk
		if targetTime < mission_ini.dawn + 86400 then							--mission duration ends before dawn of next day
			Daytime = "night"
		else
			Daytime = "night-day"
		end
	end
end


if (Skipmission_flag or Firstmission_flag or (MissionInstance and MissionInstance > 1)) and not camp.waitingNextGen then
	if idle_time > 86400 then

		print(Disp_time(idle_time)
		.. " passed. Next mission scheduled at: "
		.. FormatTime(camp.time, "hh:mm") .. ", "
		.. tostring(camp.date.day) .. "."
		.. tostring(camp.date.month) .. "."
		.. tostring(camp.date.year) .. ".\n")
	else
		print(FormatTime(idle_time, "hh:mm") .. "h passed. Next mission scheduled at: " .. FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")
	end
else
	print("Next mission scheduled at: " .. FormatTime(camp.time, "hh:mm") .. ", " .. camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year .. ".\n")
end

TimeAlreadyAdded = true