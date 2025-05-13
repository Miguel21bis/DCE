--To advance the campaign time for next mission
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- last modification:  M85_a
if not versionDCE then versionDCE = {} end
versionDCE["DC_Time.lua"] = "1.6.18"
------------------------------------------------------------------------------------------------------- 
-- debug_g 					(fg wrong time jump between missions)(e aliasYear)(d advances 2 times)(c hourlyTolerance work)(b: bug idle_time fin de mission)(a n'avance pas le temps entre accept mission et next)
-- adjustment_f				(f hoursFrom)(d: CampTotalTimeS)((c_Skipmission_flag)b diminue time entre tentative pour avoir le lev� de soleil)(a CampTotalTimeS)
-- cleancode_a				(a springCleaning)
-- modification M85_a		new variables added to conf_mod (RepairOption, current_date, weather, etc.)
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

print("DcIme 0a Current date set to: " .. camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year.." time: "..camp.time)

if camp.mission > 1 and mission_ini.current_date and mission_ini.current_date.year then
	camp.date.day = mission_ini.current_date.day
	camp.date.month = mission_ini.current_date.month
	camp.date.year = mission_ini.current_date.year
	print("DcIme 0b Current date set to: " .. camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year.." time: "..camp.time)
end

--campaign day counter
if camp.day == nil then																			--if counter does not exist yet
	camp.day = 1																				--start counting with first day in campaign
end


-- if AcceptedMission and MissionInstance < 2 then

-- 	print("DcIme A1 AcceptedMission: " .. tostring(AcceptedMission) .. " MissionInstance: " .. tostring(MissionInstance) .. "\n")

-- 	if not TimeAlreadyAdded then
-- 		camp.time = camp.time + mission_ini.mission_duration
-- 		print("DcIme A2 if not TimeAlreadyAdded: " .. camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year.." time: "..camp.time)
-- 	end
-- 	local aliasInitYear = camp.dateInit.year

-- 	if aliasInitYear < 1970 then
-- 		aliasInitYear = 1970
-- 	end

-- 	local aliasYear = camp.dateInit.year
-- 	if aliasYear < 1970 then
-- 		aliasYear = 1970
-- 	end

-- 	-- Modification M25.b OnlyDayMission
-- 	if mission_ini.onlyDayMission then

-- 		print("DcIme A3 mission_ini.onlyDayMission: ".. tostring(mission_ini.onlyDayMission) .. "\n")

-- 		-- Définir les heures de tolérance pour les missions de jour
-- 		local ht_dawn = mission_ini.dawn - (86400 * (mission_ini.hourlyTolerance / 100))
-- 		local ht_dusk = mission_ini.dusk + (86400 * (mission_ini.hourlyTolerance / 100))
-- 		-- local tempTime = Deepcopy(camp.time)
-- 		print("DcIme A4 camp.time: ".. tostring(camp.time) .. "\n")

-- 		-- Ajuster le temps jusqu'à la prochaine plage de jour
-- 		while (camp.time % 86400 < ht_dawn or camp.time % 86400 > ht_dusk) or (camp.time % 86400 + (mission_ini.mission_duration) < ht_dawn or ((camp.time % 86400) + mission_ini.mission_duration > ht_dusk)) do
-- 			-- overnightTime = overnightTime + 300
-- 			-- tempTime = tempTime + 300
-- 			print("DcIme A5 camp.time: ".. tostring(camp.time) .. "\n")
-- 		end

-- 		--ajoute un random de temps pour eviter de toujours commencer au petit matin:
-- 		camp.time = camp.time + math.random(0, 40000)
-- 		print("DcIme A6 overnightTime: ".. tostring(camp.time) .. "\n")
-- 	end

-- 	-- -- Ajouter addTime à camp.time après tous les ajustements
-- 	-- camp.time = camp.time + overnightTime

-- 	print("DcIme A10 ".. camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year.." time: "..camp.time .. "\n")

-- 	while camp.time >= 86400 do																		--repeat as long as time 24 hours or more
-- 		print("DcIme Ab1 camp.time  >= 86400 ".. tostring(camp.time) .." day ".. tostring(camp.date.day) .. "\n")	
-- 		camp.time = camp.time - 86400																--remove 24 hours from time
-- 		camp.date.day = camp.date.day + 1															--add a day to date
-- 		if camp.date.day >= 32 and (camp.date.month == 1 or camp.date.month == 3 or camp.date.month == 5 or camp.date.month == 7 or camp.date.month == 8 or camp.date.month == 10 or camp.date.month == 12) then	--month change for large months
-- 			camp.date.day = 1																		--first day of next month
-- 			camp.date.month = camp.date.month + 1													--advance month
-- 		elseif camp.date.day >= 31 and (camp.date.month == 4 or camp.date.month == 6 or camp.date.month == 9 or camp.date.month == 11) then	--month change for small months
-- 			camp.date.day = 1																		--first day of next month
-- 			camp.date.month = camp.date.month + 1													--advance month
-- 		elseif camp.date.day >= 30 and camp.date.month == 2 then									--month change for February
-- 			camp.date.day = 1																		--first day of next month
-- 			camp.date.month = camp.date.month + 1													--advance month
-- 		end
-- 		if camp.date.month >= 13 then																--year change
-- 			camp.date.month = 1																		--first month of next year
-- 			camp.date.year = camp.date.year + 1														--advance year
-- 		end
-- 		camp.day = camp.day + 1																		--counter for campaign days
		
-- 	end

-- 	print("DcIme Ab2 "..  camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year.." time: "..camp.time  .. "\n")

-- 	referenceTime = os.time{day=camp.dateInit.day, year=aliasInitYear, month=camp.dateInit.month}
-- 	actualTime = os.time{day=camp.date.day, year=aliasYear, month=camp.date.month} + camp.time
-- 	CampTotalTimeS = os.difftime(actualTime, referenceTime) --/ (24 * 60 * 60) -- seconds in a day


-- else	--si la mission est acceptée, on prend juste les infos sans ajouter de temps (idle)

	-- On n'avance pas le temps entre une mission acceptée et une suivante

	-- if not Firstmission_flag or (MissionInstance and MissionInstance > 1) then
		-- Calculer idle_time
		idle_time = math.random(mission_ini.idle_time_min, mission_ini.idle_time_max) + mission_ini.mission_duration
	-- end

	camp.time = camp.time + idle_time

	print("DcIme B3a camp.time: ".. tostring(camp.time))

	-- Modification M25.b OnlyDayMission
	local tempTime = Deepcopy(camp.time)
	print("DcIme B3b tempTime: ".. tostring(tempTime))
	print("DcIme B3c tempTime: ".. tostring(tempTime) .." "..FormatTime(tempTime, "hh:mm").."\n")
	print("DcIme B3d "..FormatTime(idle_time, "hh:mm") .. "h passed. Next mission scheduled at: " .. FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")

	if mission_ini.onlyDayMission then
		-- Définir les heures de tolérance pour les missions de jour
		local ht_dawn = math.max(0, mission_ini.dawn - (mission_ini.hourlyTolerance * 3600))
		local ht_dusk = math.min(86400, mission_ini.dusk + (mission_ini.hourlyTolerance * 3600))
		
		print("DcIme B4 ht_dawn: ".. tostring(ht_dawn) .." ht_dusk: ".. tostring(ht_dusk) .. "\n")
		print("DcIme B4 ht_dawn: ".. FormatTime(ht_dawn, "hh:mm") .." ht_dusk: ".. FormatTime(ht_dusk, "hh:mm") .. "\n")

		-- Ajuster le temps jusqu'à la prochaine plage de jour
		while (tempTime % 86400 < ht_dawn or tempTime % 86400 > ht_dusk) or (tempTime % 86400 + (mission_ini.mission_duration) < ht_dawn or ((tempTime % 86400) + mission_ini.mission_duration > ht_dusk)) do
			overnightTime = overnightTime + 300
			tempTime = tempTime + 300
			-- print("DcIme B5 tempTime: ".. tostring(tempTime) .." "..FormatTime(tempTime, "hh:mm").."\n")
		end
		print("DcIme B6 FIN tempTime: ".. tostring(tempTime) .." "..FormatTime(tempTime, "hh:mm").."\n")
		print("DcIme B6 FIN overnightTime: ".. tostring(overnightTime) .." "..FormatTime(overnightTime, "hh:mm").."\n")

		--ajoute un random de temps pour eviter de toujours commencer au petit matin:
		if mission_ini.idle_time_max > 7200 then
			local nbHour = math.floor(mission_ini.idle_time_max/3600)
			overnightTime = overnightTime + (math.random(0, nbHour)*3600)
			print("DcIme B3a overnightTime: ".. tostring(overnightTime) .. "\n")
		else
			overnightTime = overnightTime + math.random(0, mission_ini.idle_time_max)
			print("DcIme B3b overnightTime: ".. tostring(overnightTime) .. "\n")
		end


	end

	-- Ajouter addTime à camp.time après tous les ajustements
	idle_time = idle_time + overnightTime
	camp.time = camp.time + overnightTime

	print("DcIme B7 "..FormatTime(idle_time, "hh:mm") .. "h passed. Next mission scheduled at: " .. FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")


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
-- end


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

os.execute 'pause'

--mise à jour de date dans confMod
UpdateConfMod(nil, camp.date )
