---@diagnostic disable: undefined-global, lowercase-global
--[[
author/auteur = papoo
update/mise � jour = 17/08/2019
creation = 04/08/2019
source https://github.com/JamesSherburne/MoonPhasesLua/blob/master/main.lua
https://pon.fr/dzvents-phases-lunaires-sans-api
https://easydomoticz.com/forum/viewtopic.php?f=17&t=8789
--]]

------------------------------------------------------------------------------------------------------- 
-- last modification:  M51_d cleanCode_b
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_MoonPhase.lua"] = "1.3.7"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_b
-- adjustment_a			(a add english info)
-- modification M51_d  (d: actic circle)(c: NVG info)(b: Moonphase) (a: Moonphase)
------------------------------------------------------------------------------------------------------- 


local scriptName        = 'moon phase'
local scriptVersion     = '1.02'
local MoonPhaseSelector = 2479 --nil 

local Waning_Crescent = "Waning Crescent"     -- level 80 MoonPhase Selector switch
-- local Waning_Crescent = "Dernier croissant"     -- level 80 MoonPhase Selector switch
local Last_Quarter = "Last Quarter"           -- level 70 MoonPhase Selector switch
-- local Last_Quarter = "Dernier quartier"         -- level 70 MoonPhase Selector switch
local Waning Gibbous = "Waning gibbous"       -- level 60 MoonPhase Selector switch
-- local Waning_Gibbous = "Gibbeuse d�croissante"  -- level 60 MoonPhase Selector switch
local Full_Moon = "Full Moon"                 -- level 50 MoonPhase Selector switch
-- local Full_Moon = "Pleine une"                  -- level 50 MoonPhase Selector switch
local Waxing_Gibbous = "Waxing gibbous"       -- level 40 MoonPhase Selector switch
-- local Waxing_Gibbous = "Gibbeuse croissante"    -- level 40 MoonPhase Selector switch
local First_Moon = "First Moon"               -- level 30 MoonPhase Selector switch
-- local First_Moon = "Premier quartier"           -- level 30 MoonPhase Selector switch
local Waxing_Crescent = "Waxing crescent"     -- level 20 MoonPhase Selector switch
-- local Waxing_Crescent = "Premier croissant"     -- level 20 MoonPhase Selector switch
local New_Moon = "New Moon"                   -- level 10 MoonPhase Selector switch
-- local New_Moon = "Nouvelle lune"                -- level 10 MoonPhase Selector switch



function Moonphase(day,month,year)

	function julianDate(d, m, y)
		local mm, yy, k1, k2, k3, j
		yy = y - math.floor((12 - m) / 10)
		mm = m + 9
		if (mm >= 12) then
			mm = mm - 12
		end
		k1 = math.floor(365.25 * (yy + 4712))
		k2 = math.floor(30.6001 * mm + 0.5)
		k3 = math.floor(math.floor((yy / 100) + 49) * 0.75) - 38
		j = k1 + k2 + d + 59
		if (j > 2299160) then
			j = j - k3
		end
		return j
	end

	function  moonAge(d, m, y)
		local j, ip, ag
		j = julianDate(d, m, y)
		ip = (j + 4.867) / 29.53059
		ip = ip - math.floor(ip)
		if (ip < 0.5) then
			ag = ip * 29.53059 + 29.53059 / 2
		else
			ag = ip * 29.53059 - 29.53059 / 2
		end
		-- logWrite(ag)
		return ag
	end

	local theMoon = moonAge(day,month,year)

	local moonText  = nil
	local level     = nil

	-- if     theMoon > 29   then moonText, level = New_Moon,          10 --Nouvelle Lune, New_Moon                > 27.65625
	-- elseif theMoon > 23   then moonText, level = Waning_Crescent,   80 --Dernier croissant, Waning_Crescent     > 23.96875
	-- elseif theMoon > 22   then moonText, level = Third_Quarter,     70 --Dernier quartier, Third_Quarter        > 20.28125
	-- elseif theMoon > 15   then moonText, level = Waning_Gibbous,    60 --Gibbeuse d�croissante, Waning_Gibbous  > 16.59375
	-- elseif theMoon > 13   then moonText, level = Full_Moon,         50 --Pleine lune, Full_Moon                 > 12.90625
	-- elseif theMoon > 8    then moonText, level = Waxing_Gibbous,    40 --Gibbeuse croissante, Waxing_Gibbous    > 9.21875
	-- elseif theMoon > 6    then moonText, level = First_Quarter,     30 --Premier Quartier, First_Quarter        > 5.53125
	-- elseif theMoon > 1    then moonText, level = Waxing_Crescent,   20 --Premier croissant, Waxing_Crescent     > 1.84375
	-- else                       moonText, level = New_Moon,          10 --Nouvelle Lune, New_Moon
	-- end
	
	if     theMoon > 29   then moonText = "New Moon"				level = 0 --Nouvelle Lune, New_Moon
	elseif theMoon > 23   then moonText = "Waning Crescent"			level = 10 --Dernier croissant, Waning_Crescent
	elseif theMoon > 22   then moonText = "Third Quarter"			level = 30 --Dernier quartier, Third_Quarter
	elseif theMoon > 15   then moonText = "Waning Gibbous"			level = 50 --Gibbeuse d�croissante, Waning_Gibbous
	elseif theMoon > 13   then moonText = "Full Moon"				level = 100 --Pleine lune, Full_Moon
	elseif theMoon > 8    then moonText = "Waxing Gibbous"			level = 50 --Gibbeuse croissante, Waxing_Gibbous
	elseif theMoon > 6    then moonText = "First Quarter"			level = 30 --Premier Quartier, First_Quarter
	elseif theMoon > 1    then moonText = "Waxing Crescent"			level = 10 --Premier croissant, Waxing_Crescent
	else                       moonText = "New Moon"				level =  0 --Nouvelle Lune, New_Moon
	end
	
	--inverse le chiffre, car apres 13j, l'intesit� diminue
	if theMoon > 13 then
		theMoon = math.abs(theMoon - 26)
	end
		
	local lumi = math.floor(theMoon /13 * 100)
	
	-- string.format("%.3f", 5.0)
	
	dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_SunMoonRIse.lua")
	
	local Timestamp = os.time({year= camp.date.year, month= camp.date.month, day= camp.date.day, hour= camp.date.hour, minute= camp.date.minute})
	
	-- local NameTheatre =  string.lower(mission.theatre)

	local locationBis = {}

	for key, value in pairs(LocationForEphemeris) do

		locationBis[string.lower(key)] = value 
	
	end
	
	loc = locationBis[NameTheatre]
	
	if not loc then
	
		print()
		print("********************ATTENTION******************")
		print("***************Note for the Campaign Maker*****")
		print("***************Ajoute la MAP et des coordon�es LatLong dans UTIL_DataMap pour utiliser les infos Moon ****************")
		print("***************Add MAP and LatLong coordinates in UTIL_DataMap to use Moon info****************")
		print("********************ATTENTION******************")
		print()
		os.execute 'pause'
	
	end

	local sSunrise, sSunset, sMoonrise, sMoonset, sDayLength, sSunAngle
	local hour, minute

	Initialize()
	local MoonRiseFCT = GetSunMoonTimes(loc.nnLatitude,
                         loc.nnLongitude,
                         loc.nnTimeZone,
                         Timestamp,
                         loc.nnShiftTz,
                         loc.nnTimeLZero,
                         loc.nnTimeStyle,
                         sSunrise,
                         sSunset,
                         sMoonrise,
                         sMoonset,
                         sDayLength,
                         sSunAngle)
	
	if bSunrise ~= "----" then
		hour, minute = bSunrise:match("([^,]+):([^,]+)")
		sSunrise = tonumber(hour) * 3600 + tonumber(minute) *60
	end
	if bSunset ~= "----" then
		hour, minute = bSunset:match("([^,]+):([^,]+)")	
		sSunset = tonumber(hour) * 3600 + tonumber(minute) *60
	end
	if bMoonrise then
		hour, minute = bMoonrise:match("([^,]+):([^,]+)")	
		sMoonrise = tonumber(hour) * 3600 + tonumber(minute) *60
	end
	if bMoonset then
		hour, minute = bMoonset:match("([^,]+):([^,]+)")	
		sMoonset = tonumber(hour) * 3600 + tonumber(minute) *60
	end
	
	local timeToTarget = camp.time + 3600	
	local infoMoonSet = ""
	local NiveauDeNuit = 0

	if sSunrise and sSunset then
		
		if timeToTarget < sSunrise or timeToTarget > sSunset then				--il fait nuit		
			if timeToTarget < sMoonrise and timeToTarget > sMoonset then		--pas de lune
				NiveauDeNuit = 4
				infoMoonSet = " (but the moon is set) "
			elseif lumi >= 50 then
				NiveauDeNuit = 1
			elseif lumi >= 25 then
				NiveauDeNuit = 2
			elseif lumi >= 5 then
				NiveauDeNuit = 3
			end
		end
	end
	
	local NVG_info =  "Sunrise   "..tostring(bSunrise) .. "\\n"..
				"Sunset    "..tostring(bSunset).. "\\n"..
				"Moonrise  "..tostring(bMoonrise).. "\\n"..
				"Moonset   "..tostring(bMoonset).. "\\n"..	
				"NVG Info => Night Level: "..tostring(NiveauDeNuit).." (max 5)  "..moonText.." ( "..lumi.."% full moon)"..tostring(infoMoonSet)
	
	if bSunrise == "----" or bSunset == "----" then
		NVG_info = "The sun doesn't set, you're probably beyond the Arctic Circle."
		print(NVG_info)
	else
		
		print("Sunrise   "..tostring(bSunrise))
		print("Sunset    "..tostring(bSunset))
		print("Moonrise  "..tostring(bMoonrise))
		print("Moonset   "..tostring(bMoonset))
		print("NVG Info => Night Level: "..tostring(NiveauDeNuit).." (max 5)  "..moonText.." ( "..lumi.."% full moon)"..tostring(infoMoonSet))
		
	end

	return NVG_info

end
