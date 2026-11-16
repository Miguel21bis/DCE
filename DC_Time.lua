--To advance the campaign time for next mission
--Initiated by MAIN_NextMission.lua
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- last modification:  M85_a
if not versionDCE then versionDCE = {} end
versionDCE["DC_Time.lua"] = "1.6.19"
-------------------------------------------------------------------------------------------------------
-- debug_i					(i dawn/dusk fiabilises : crepuscule apres minuit accepte (ex. Kola en ete), valeurs invalides remplacees, isDayTime gere minuit, plus de correction silencieuse de la fenetre de jour)
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
DayWindow = nil																					--fenetre de jour calculee : { earliest, latest, tooShort } (nil si onlyDayMission est inactif)

--local variable:
local idle_time = 0
local overnightTime = 0

--campaign day counter
if camp.day == nil then
	camp.day = 1
end

-------------------------------------------------------------------------------------------------------
-- Aube / crepuscule : controle et normalisation
-- mission_ini.dawn et mission_ini.dusk sont des secondes depuis minuit (DCE_Manager les ecrit si dawnDuskAuto).
-- Aux latitudes nordiques en ete, le crepuscule tombe APRES minuit (ex. aube 02:08, crepuscule 00:30) :
-- le jour chevauche alors minuit. On le represente en ajoutant 24 h au crepuscule (dusk > 86400),
-- ce qui permet partout ailleurs de calculer "dusk - camp.time" sans cas particulier.
-- Valeurs inutilisables (pas un nombre, hors 0-24h, aube == crepuscule) : valeurs par defaut + message.
-- Fonction idempotente : on peut l'appeler plusieurs fois, et apres chaque rechargement de conf_mod.lua
-- (UpdateConfMod recharge mission_ini avec les valeurs brutes du fichier).
-------------------------------------------------------------------------------------------------------
local function NormalizeDawnDusk()
	local dawn = tonumber(mission_ini.dawn)
	local dusk = tonumber(mission_ini.dusk)

	local valid = dawn ~= nil and dusk ~= nil
		and dawn >= 0 and dawn < 86400
		and dusk >= 0 and dusk < 172800
		and (dusk % 86400) ~= dawn

	if not valid then
		AddLog("DcTime WARNING: dawn/dusk unusable (dawn="..tostring(mission_ini.dawn).." dusk="..tostring(mission_ini.dusk).."), default 06:00 / 18:15 used")
		print(" !! DcTime : dawn/dusk unusable (dawn="..tostring(mission_ini.dawn).." dusk="..tostring(mission_ini.dusk).."), default values 06:00 / 18:15 used.")
		dawn = 21600
		dusk = 65700
	end

	if dusk <= dawn then
		dusk = dusk + 86400																	--le jour chevauche minuit
	end

	mission_ini.dawn = dawn
	mission_ini.dusk = dusk
end

NormalizeDawnDusk()

-------------------------------------------------------------------------------------------------------
-- Jour / nuit a une heure donnee (secondes, toute valeur : le modulo 24 h est fait ici)
-- Gere le jour qui chevauche minuit (dusk > 86400)
-- Fonction globale : utilisable par les autres fichiers du generateur
-------------------------------------------------------------------------------------------------------
function IsDayTime(t)
	t = t % 86400
	if t >= mission_ini.dawn and t <= mission_ini.dusk then
		return true
	end
	if mission_ini.dusk > 86400 and (t + 86400) <= mission_ini.dusk then					--apres minuit, avant le crepuscule
		return true
	end
	return false
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

if mission_ini.onlyDayMission then
	DayWindow = { earliest = startEarliest, latest = startLatest, tooShort = false }

	if startLatest < startEarliest then
		--jour trop court pour la duree de mission : on part au plus tot, et on le dit clairement
		DayWindow.tooShort = true
		local txt = "DcTime WARNING: daylight window too short for mission duration (dawn "..FormatTime(mission_ini.dawn, "hh:mm")
			.." dusk "..FormatTime(mission_ini.dusk % 86400, "hh:mm")
			.." margin "..FormatTime(dayMargin, "hh:mm")
			.." mission "..FormatTime(missionSpan, "hh:mm")
			.." -> earliest "..FormatTime(startEarliest, "hh:mm")
			.." latest "..FormatTime(startLatest, "hh:mm")..")"
		AddLog(txt)
		print(" !! "..txt)
		print(" !! Every mission will start at "..FormatTime(startEarliest, "hh:mm").." and cannot be fully in daylight. Reduce mission duration or startup time, or increase the dawn/dusk margin.")
		startLatest = startEarliest
		DayWindow.latest = startLatest
	end
end

-- print("DcIme 0b TimeJump:? ".. tostring(TimeJump)..." Mission.MissionInstance: "..camp.mission..".".. tostring(MissionInstance))

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

	local t = camp.time % 86400															--heure de depart actuelle dans la journee

	if t < startEarliest or t > startLatest then										--hors de la fenetre : on attend la prochaine ouverture
		local target = startEarliest
		if t > startEarliest then														--on a depasse la fenetre aujourd'hui, ce sera demain
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

while camp.time >= 86400 do																--repeat as long as time 24 hours or more
	camp.time = camp.time - 86400														--remove 24 hours from time
	camp.date.day = camp.date.day + 1													--add a day to date
	if camp.date.day >= 32 and (camp.date.month == 1 or camp.date.month == 3 or camp.date.month == 5 or camp.date.month == 7 or camp.date.month == 8 or camp.date.month == 10 or camp.date.month == 12) then	--month change for large months
		camp.date.day = 1																--first day of next month
		camp.date.month = camp.date.month + 1											--advance month
	elseif camp.date.day >= 31 and (camp.date.month == 4 or camp.date.month == 6 or camp.date.month == 9 or camp.date.month == 11) then	--month change for small months
		camp.date.day = 1																--first day of next month
		camp.date.month = camp.date.month + 1											--advance month
	elseif camp.date.day >= 30 and camp.date.month == 2 then							--month change for February
		camp.date.day = 1																--first day of next month
		camp.date.month = camp.date.month + 1											--advance month
	end
	if camp.date.month >= 13 then														--year change
		camp.date.month = 1																--first month of next year
		camp.date.year = camp.date.year + 1												--advance year
	end
	camp.day = camp.day + 1																--counter for campaign days
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

mission["start_time"] = camp.time														--set mission start time
mission["date"]["Day"] = camp.date.day													--set mission day
mission["date"]["Year"] = camp.date.year												--set mission year
mission["date"]["Month"] = camp.date.month												--set mission month

-------------------------------------------------------------------------------------------------------
-- Daytime : ce que couvre la mission, du depart a la fin (demarrage joueur inclus)
--   "day"        debut et fin de jour
--   "day-night"  debut de jour, fin de nuit (crepuscule pendant la mission)
--   "night-day"  debut de nuit, fin de jour (aube pendant la mission)
--   "night"      debut et fin de nuit
-- dawn == aube, dusk == crepuscule
-------------------------------------------------------------------------------------------------------
local startIsDay = IsDayTime(camp.time)
local endIsDay = IsDayTime(camp.time + missionSpan)

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

--UpdateConfMod recharge conf_mod.lua : mission_ini retrouve les valeurs brutes de dawn/dusk, on les normalise a nouveau
NormalizeDawnDusk()

-- print("Test Time DC_Time  Y : " .. FormatTime(mission["start_time"], "hh:mm"))
-- _affiche(mission["date"], "Test Time DC_Time Yb: mission[date] ")
