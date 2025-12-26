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

if Debug.debug then
	print("START DC_Time.lua "..versionDCE["DC_Time.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end


--Global variable:
Daytime	= ""																					--variable what Daytime the is covered in the duration of the mission

--local variable:
local idle_time = 0
local overnightTime = 0

-- print("DcIme 0a Current date : " ..FormatTime(camp.time, "hh:mm") .. ", " .. camp.date.day .. "." .. camp.date.month .. "." .. camp.date.year )

--campaign day counter
if camp.day == nil then
	camp.day = 1
end

-- print("DcIme 0b TimeJump:? ".. tostring(TimeJump).." Mission.MissionInstance: "..camp.mission..".".. tostring(MissionInstance))

if TimeJump and (MissionInstance and MissionInstance <= 1) then
	camp.time = 0
	if mission_ini.onlyDayMission then
		-- Définir les heures de tolérance pour les missions de jour
		local ht_dawn = math.max(0, mission_ini.dawn - (mission_ini.hourlyTolerance * 3600))
		local ht_dusk = math.min(86400, mission_ini.dusk + (mission_ini.hourlyTolerance * 3600))
		idle_time = math.random(ht_dawn, ht_dusk)
		-- Arrondir idle_time à 5 minutes près (300 secondes)
		idle_time = math.floor(idle_time / 300 + 0.5) * 300
	else
		idle_time = math.random(0,23) * 3600
	end

	-- print("DcIme A1 timeJump: idle_time: ".. tostring(idle_time))

elseif Firstmission_flag and (MissionInstance and MissionInstance >= 2) then

	idle_time = mission_ini.mission_duration + math.random(mission_ini.idle_time_min, mission_ini.idle_time_max)
	-- print("DcIme A2 idle_time: ".. tostring(idle_time))

elseif not Firstmission_flag then
	if  not TimeJump or (MissionInstance and MissionInstance >= 1) then

		idle_time = mission_ini.mission_duration + math.random(mission_ini.idle_time_min, mission_ini.idle_time_max)
		-- print("DcIme A3 idle_time: ".. tostring(idle_time))
	end


end

camp.time = camp.time + idle_time

-- print("DcIme B1 camp.time: ".. tostring(camp.time))

-- Modification M25.b OnlyDayMission
local tempTime = DeepCopy(camp.time)

-- print("DcIme B2 tempTime: ".. tostring(tempTime) .." "..FormatTime(tempTime, "hh:mm").."\n")

if mission_ini.onlyDayMission then
	-- Définir les heures de tolérance pour les missions de jour
	local ht_dawn = math.max(0, mission_ini.dawn - (mission_ini.hourlyTolerance * 3600))
	local ht_dusk = math.min(86400, mission_ini.dusk + (mission_ini.hourlyTolerance * 3600))

	-- print("DcIme C1 onlyDayMission ht_dawn: ".. tostring(ht_dawn) .." ht_dusk: ".. tostring(ht_dusk) .. "\n")
	-- print("DcIme C1 onlyDayMission ht_dawn: ".. FormatTime(ht_dawn, "hh:mm") .." ht_dusk: ".. FormatTime(ht_dusk, "hh:mm") .. "\n")

	-- Ajuster le temps jusqu'à la prochaine plage de jour
	while (tempTime % 86400 < ht_dawn or tempTime % 86400 > ht_dusk) or (tempTime % 86400 + (mission_ini.mission_duration) < ht_dawn or ((tempTime % 86400) + mission_ini.mission_duration > ht_dusk)) do
		overnightTime = overnightTime + 300
		tempTime = tempTime + 300
		-- print("DcIme C2 tempTime: ".. tostring(tempTime) .." "..FormatTime(tempTime, "hh:mm").."\n")
	end

	-- print("DcIme C3 onlyDayMission FIN tempTime: ".. tostring(tempTime) .." "..FormatTime(tempTime, "hh:mm").."\n")
	-- print("DcIme C4 onlyDayMission FIN overnightTime: ".. tostring(overnightTime) .." "..FormatTime(overnightTime, "hh:mm").."\n")

	--ajoute un random de temps pour eviter de toujours commencer au petit matin:
	if overnightTime > 0 and mission_ini.idle_time_max > 7200 then
		if mission_ini.idle_time_max > 7200 then
			local nbHour = math.floor(mission_ini.idle_time_max/3600)
			overnightTime = overnightTime + (math.random(0, nbHour)*3600)
			-- print("DcIme C5a onlyDayMission overnightTime: ".. tostring(overnightTime) .. "\n")
		else
			overnightTime = overnightTime + math.random(0, mission_ini.idle_time_max)
			-- print("DcIme C5b onlyDayMission overnightTime: ".. tostring(overnightTime) .. "\n")
		end

		overnightTime = math.floor(overnightTime / 300 + 0.5) * 300
		-- print("DcIme C5c onlyDayMission overnightTime: ".. tostring(overnightTime) .. "\n")

	end

end

-- Ajouter addTime à camp.time après tous les ajustements
idle_time = idle_time + overnightTime
camp.time = camp.time + overnightTime

-- print("DcIme D1 idle_time "..idle_time)
-- print("DcIme D2 idle_time "..FormatTime(idle_time, "dd:hh:mm"))

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

-- print("DcIme E "..FormatTime(idle_time, "dd:hh:mm") .. " passed. Next mission scheduled at: " .. FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")


if not camp.dateInit then
	local tempCamp = camp
	dofile("Init/camp_init.lua")
	local campInit =  DeepCopy(camp)
	camp = tempCamp
	camp.dateInit = {
		day = campInit.date.day,
		year = campInit.date.year,
		month = campInit.date.month,
	}
end

CampTotalTimeS = SecondsBetween(camp.dateInit, camp.date)

if Debug.debug then
	print("DcTime The campaign will start on this date: " .. tostring(camp.dateInit.day) .. "." .. tostring(camp.dateInit.month) .. "." .. tostring(camp.dateInit.year) .. ".\n")
	print("DcTime The current date of the campaign is: " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")

end


camp.date.CampTotalTimeS = CampTotalTimeS

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

print(FormatTime(idle_time, "dd:hh:mm") .. " passed. Next mission scheduled at: " .. FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")

-- print("Test Time DC_Time  X : " .. FormatTime(mission["start_time"], "hh:mm"))
-- _affiche(mission["date"], "Test Time DC_Time Xb: mission[date] ")


TimeAlreadyAdded = true

--mise à jour de date dans confMod
UpdateConfMod(nil, camp.date, "DC_Time " .. debug.getinfo(1).currentline)

-- print("Test Time DC_Time  Y : " .. FormatTime(mission["start_time"], "hh:mm"))
-- _affiche(mission["date"], "Test Time DC_Time Yb: mission[date] ")
