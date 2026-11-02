--To advance the campaign time for next mission
--Initiated by MAIN_NextMission.lua
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- last modification:  M85_a
if not versionDCE then versionDCE = {} end
versionDCE["DC_Time.lua"] = "1.6.18"
-------------------------------------------------------------------------------------------------------
-- debug_h					(h onlyDayMission: dayMarginMin remplace hourlyTolerance, fenetre de jour reelle, Daytime recalcule debut+fin)
-- debug_g 					(fg wrong time jump between missions)(e aliasYear)(d advances 2 times)(c hourlyTolerance work)(b: bug idle_time fin de mission)(a n'avance pas le temps entre accept mission et next)
-- adjustment_f				(f hoursFrom)(d: CampTotalTimeS)((c_Skipmission_flag)b diminue time entre tentative pour avoir le leve de soleil)(a CampTotalTimeS)
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

--campaign day counter
if camp.day == nil then
	camp.day = 1
end

-------------------------------------------------------------------------------------------------------
-- Fenetre de jour (onlyDayMission)
-- Regle unique : TOUTE la mission (demarrage joueur + duree) doit tenir entre
--   aube - marge   et   crepuscule + marge
-- dayMarginMin = marge en MINUTES (0 = strictement entre aube et crepuscule)
-- Depart au plus tot  = aube - marge
-- Depart au plus tard = crepuscule + marge - (startup_time_player + mission_duration)
-------------------------------------------------------------------------------------------------------
local missionSpan = (mission_ini.startup_time_player or 0) + mission_ini.mission_duration	--duree totale de la mission, demarrage inclus
local dayMargin = (mission_ini.dayMarginMin or 30) * 60										--marge en secondes
local startEarliest = math.max(0, mission_ini.dawn - dayMargin)								--depart au plus tot
local startLatest = math.min(86100, mission_ini.dusk + dayMargin - missionSpan)				--depart au plus tard (86100 = 23h55, evite de passer minuit)

if mission_ini.onlyDayMission and startLatest < startEarliest then
	--jour trop court pour la duree de mission : on part au plus tot, et on le dit
	AddLog("DcTime WARNING: daylight window too short for mission duration (earliest "..FormatTime(startEarliest, "hh:mm").." latest "..FormatTime(startLatest, "hh:mm")..")")
	startLatest = startEarliest
end

-- print("DcIme 0b TimeJump:? ".. tostring(TimeJump).." Mission.MissionInstance: "..camp.mission..".".. tostring(MissionInstance))

if TimeJump and (MissionInstance and MissionInstance <= 1) then
	camp.time = 0
	if mission_ini.onlyDayMission then
		--heure de depart tiree au hasard dans la fenetre de jour reelle, arrondie a 5 minutes
		idle_time = math.random(math.floor(startEarliest / 300), math.floor(startLatest / 300)) * 300
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
if mission_ini.onlyDayMission then

	local t = camp.time % 86400																--heure de depart actuelle dans la journee

	if t < startEarliest or t > startLatest then											--hors de la fenetre : on attend la prochaine ouverture
		local target = startEarliest
		if t > startEarliest then																--on a depasse la fenetre aujourd'hui, ce sera demain
			target = startEarliest + 86400
		end
		overnightTime = target - t

		--aleatoire ajoute DANS la fenetre (jamais au-dela de startLatest), pour ne pas toujours partir a l'aube
		local spread = math.min(mission_ini.idle_time_max, startLatest - startEarliest)
		if spread > 0 then
			overnightTime = overnightTime + math.random(0, math.floor(spread / 300)) * 300
		end

		-- print("DcIme C1 onlyDayMission overnightTime: ".. tostring(overnightTime) .. " (" .. FormatTime(overnightTime, "hh:mm") .. ")")
	end

end

-- Ajouter overnightTime a camp.time apres tous les ajustements
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
	local campInit = DeepCopy(camp)
	camp = tempCamp
	camp.dateInit = {
		day = campInit.date.day,
		year = campInit.date.year,
		month = campInit.date.month,
	}
end


CampTotalTimeS = SecondsBetween(camp.dateInit, camp.date)
CampTotalTimeH = CampTotalTimeS / 3600
if Debug.debug then
	print("if Debug: DcTime The campaign will start on this date: " .. tostring(camp.dateInit.day) .. "." .. tostring(camp.dateInit.month) .. "." .. tostring(camp.dateInit.year) .. ".\n")
	print("if Debug: DcTime The current date of the campaign is: " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")
	print("if Debug: DcTime CampTotalTimeS: " .. tostring(CampTotalTimeS))
	print("if Debug: DcTime CampTotalTimeH: " .. tostring(CampTotalTimeH))
end


camp.date.CampTotalTimeS = CampTotalTimeS
camp.date.CampTotalTimeH = CampTotalTimeH

mission["start_time"] = camp.time																--set mission start time
mission["date"]["Day"] = camp.date.day															--set mission day
mission["date"]["Year"] = camp.date.year														--set mission year
mission["date"]["Month"] = camp.date.month														--set mission month

-------------------------------------------------------------------------------------------------------
-- Daytime : ce que couvre la mission, du depart a la fin (demarrage joueur inclus)
--   "day"        debut et fin de jour
--   "day-night"  debut de jour, fin de nuit (crepuscule pendant la mission)
--   "night-day"  debut de nuit, fin de jour (aube pendant la mission)
--   "night"      debut et fin de nuit
-- dawn == aube, dusk == crepuscule
-------------------------------------------------------------------------------------------------------
local function isDayTime(t)
	t = t % 86400
	return t >= mission_ini.dawn and t <= mission_ini.dusk
end

local startIsDay = isDayTime(camp.time)
local endIsDay = isDayTime(camp.time + missionSpan)

if startIsDay and endIsDay then
	Daytime = "day"
elseif startIsDay then
	Daytime = "day-night"
elseif endIsDay then
	Daytime = "night-day"
else
	Daytime = "night"
end

print(FormatTime(idle_time, "dd:hh:mm") .. " passed. Next mission scheduled at: " .. FormatTime(camp.time, "hh:mm") .. ", " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")

-- print("Test Time DC_Time  X : " .. FormatTime(mission["start_time"], "hh:mm"))
-- _affiche(mission["date"], "Test Time DC_Time Xb: mission[date] ")


TimeAlreadyAdded = true

--mise a jour de date dans confMod
--TODO UpdateConfMod
-- UpdateConfModSuite(nil, camp.date, "DC_Time " .. debug.getinfo(1).currentline)
UpdateConfMod(nil, camp.date, "DC_Time " .. debug.getinfo(1).currentline)

-- print("Test Time DC_Time  Y : " .. FormatTime(mission["start_time"], "hh:mm"))
-- _affiche(mission["date"], "Test Time DC_Time Yb: mission[date] ")
