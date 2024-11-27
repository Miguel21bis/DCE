--Weather
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- last modification: adjustment_h
if not versionDCE then versionDCE = {} end
versionDCE["DC_Weather.lua"] = "1.6.22"
------------------------------------------------------------------------------------------------------- 
-- cleanCode_d						
-- adjustment_h						(h baseChoice)(f \\\n to \n)(e debug info)(d preset = nil)(c adds METAR to dynamic cloud presets, where possible) (b CampTotalTimeS)(a: high 2 days max)
-- debug_d							(d very bad weather during a cold sector)%chance pHigh pLow 
-- miguel21 modification M53_b		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- miguel21 modification M51_c		Moonphase
-- miguel21 modification M45_e		compatible with 2.7.0s  (e: debug cleaning)(d: less clounds in the PG)(c: debugWeather)
------------------------------------------------------------------------------------------------------- 


	-- WindDirection = camp.weather.direction													--recupere la vrai direction du vent (aéronautique)


local debugWeather = false
local debugTxt = ""

local PresetChoice = 0
local showOne = false
local showOneNight = false

local foundSinglePlayer = {}
local FieldElevation = 0												--elevation of players airfield used for minimum cloud base
for side,unit in pairs(oob_air) do										--iterate through all sides
	for n = 1, #unit do													--iterate through all units
		if unit[n].player then											--find player unit			
			if not db_airbases[unit[n].base] then
				print("DcW: No "..unit[n].base.." (base) found for "..unit[n].name.." in db_airbase file")
				os.execute 'pause'
			end
			if db_airbases[unit[n].base].elevation then
				FieldElevation = db_airbases[unit[n].base].elevation		--get field elevation of player base
			end
			if FieldElevation == nil then
				FieldElevation = 0
			end
						
			foundSinglePlayer = {
				place = unit[n].base,
				type = unit[n].type,
				FieldElevation = FieldElevation
			}

			break

		end
	end
end


	
-- if debugWeather then 
-- 	print("old weather:")
-- 	_affiche(camp.weather, "camp.weather DcW")

-- 	-- ["zone"] = "low sector warm",
-- 	-- ["zoneEnd"] = 1023050,
-- 	-- ["zoneNext"] = "high",
-- 	-- ["zoneNextTemp"] = 24,
-- 	-- ["zoneStart"] = 965105,
-- 	-- ["zoneTemp"] = 31,

-- 	-- print("time              "..tostring((camp.date.day - 1) * 86400 + camp.time))
-- 	-- print("camp.weather.zoneEnd "..tostring(camp.weather.zoneEnd))
-- end
if camp and camp.weather and camp.weather.zoneEnd then
	debugTxt = debugTxt .."camp.weather.zoneEnd "..tostring(camp.weather.zoneEnd).."\n"
end
-- if debugWeather then print("time              "..tostring((camp.date.day - 1) * 86400 + camp.time)) end
debugTxt = debugTxt .."time              "..tostring((camp.date.day - 1) * 86400 + camp.time).."\n"

mission.weather["atmosphere_type"] = 0									--set simple weather model
local InitalW = false

local ProbaPhight = (mission_ini.weather.pHigh / (mission_ini.weather.pHigh + mission_ini.weather.pLow)) * 100					--chance of next weather zone being a high pressure system
local ProbaPlow = (mission_ini.weather.pLow / (mission_ini.weather.pHigh + mission_ini.weather.pLow)) * 100

-- if debugWeather then 
-- 	print("DcW camp.weather.zone: "..tostring( camp.weather.zone)) 
-- 	print("DcW ProbaPhight weather : "..tostring(ProbaPhight))
-- 	print("DcW ProbaPlow weather : "..tostring(ProbaPlow))
-- end	

debugTxt = debugTxt .."DcW ProbaPhight weather : "..tostring(ProbaPhight).."\n"
debugTxt = debugTxt .."DcW ProbaPlow weather : "..tostring(ProbaPlow).."\n"

--Initial weather
if camp.weather == nil then
	camp.weather = {}
end

--Initial weather 2
if camp.weather.zone == nil then										--no weather exists yet
	camp.weather.zoneTemp = math.random(mission_ini.weather.refTemp - 5, mission_ini.weather.refTemp + 5)				--Set temperature of weather zone (+/- 5°C of reference tempereature)
	camp.weather.zoneNextTemp = math.random(mission_ini.weather.refTemp - 5, mission_ini.weather.refTemp + 5)			--Set temperature of next weather zone (+/- 5°C of reference tempereature)

	local randChance = math.random(1, 100)

	-- if debugWeather then print("DcW A camp.weather.zoneTemp: "..tostring(camp.weather.zoneTemp)) end	
	-- if debugWeather then print("DcW A2 camp.weather.zoneNextTemp: "..tostring(camp.weather.zoneNextTemp)) end
	-- if debugWeather then print("DcW Initial weather: "..tostring(randChance).. "<=? "..tostring(ProbaPhight)) end	
	
	debugTxt = debugTxt .."DcW A camp.weather.zoneTemp: "..tostring(camp.weather.zoneTemp).."\n"
	debugTxt = debugTxt .."DcW A2 camp.weather.zoneNextTemp: "..tostring(camp.weather.zoneNextTemp).."\n"
	debugTxt = debugTxt .."DcW Initial weather: "..tostring(randChance).. "<=? "..tostring(ProbaPhight).."\n"

	if randChance <= ProbaPhight   then								--High pressure system
		-- if debugWeather then print("DcW YES camp.weather.zoneNext = high" ) end
		debugTxt = debugTxt .."DcW YES camp.weather.zoneNext = high".."\n"

		camp.weather.zoneNext = "high"									--set next weather zone

	else

		-- if debugWeather then print("DcW ProbaPlow weather : "..tostring(ProbaPlow)) end
		debugTxt = debugTxt .."DcW ProbaPlow weather : "..tostring(ProbaPlow).."\n"

		local limitA = 0
		local limitB = 0
		local limitC = 5

		--ceci à pour but de mettre un mauvais temps en fonction du random
		--plus le random est fort, plus le mauvais temps est probable
		if  ProbaPlow <= 25  then--faible proba TRES mauvais temps, donc fort proba SIMPLE mauvais temps
			-- rando = math.random(0,100)
			limitA = 95
			limitB = 100
			limitC = 100

		elseif  ProbaPlow <= 50  then
			-- rando = math.random(0,100)
			limitA = 25
			limitB = 50
			limitC = 75

		elseif  ProbaPlow <= 62  then
			-- rando = math.random(0,100)
			limitA = 17
			limitB = 34
			limitC = 52

		elseif  ProbaPlow <= 75  then
			-- rando = math.random(0,100)
			limitA = 9
			limitB = 18
			limitC = 29

		else
			-- rando = math.random(0,100)
			limitA = 0
			limitB = 0
			limitC = 5
		end

		local rando = math.random(0,100)
		
		-- if debugWeather then print("DcW random (rando) weather : "..tostring(rando)) end
		debugTxt = debugTxt .."DcW random (rando) weather : "..tostring(rando).."\n"

		-- if debugWeather then print("DcW  choice: "
		-- 	.. "<=A "..tostring(limitA)
		-- 	.. "<=B "..tostring(limitB)
		-- 	.. "<=C "..tostring(limitC)

		-- ) end
		debugTxt = debugTxt .."DcW  choice: ".."\n"
		debugTxt = debugTxt .."<=A "..tostring(limitA).."\n"
		debugTxt = debugTxt .."<=B "..tostring(limitB).."\n"
		debugTxt = debugTxt .."<=C "..tostring(limitC).."\n"

		
		if  rando < limitA  then--rando <= ((ProbaPlow / 4)*1)

			camp.weather.zoneNext = "low sector warm"					--next zone is a warm sector
			-- if debugWeather then print("DcW ProbaPlow weather rando: "..tostring(rando).. "<=? limitA "..tostring(limitA)) end
			debugTxt = debugTxt .."DcW ProbaPlow weather rando: "..tostring(rando).. "<=? limitA "..tostring(limitA).."\n"
		
		elseif rando < limitB then

			camp.weather.zoneNext = "low front warm"					--Next zone is a warm front
			-- if debugWeather then print("DcW ProbaPlow weather rando: "..tostring(rando).. "<=?limitB "..tostring(limitB)) end
			debugTxt = debugTxt .."DcW ProbaPlow weather rando: "..tostring(rando).. "<=?limitB "..tostring(limitB).."\n"
		elseif rando < limitC then

			camp.weather.zoneNext = "low sector cold"					--next zone is a cold sector
			-- if debugWeather then print("DcW ProbaPlow weather rando: "..tostring(rando).. "<=? limitC "..tostring(limitC)) end
			debugTxt = debugTxt .."DcW ProbaPlow weather rando: "..tostring(rando).. "<=? limitC "..tostring(limitC).."\n"
			
		else  --rando <= ProbaPlow  then
			
			--TODo pb ici, à 60 % de chance d avoir du mauvais temps, on ne devrait pas avoir l'ultra mauvais temps
			camp.weather.zoneNext = "low front cold"					--Next zone is a cold front
			-- if debugWeather then print("DcW ProbaPlow weather rando: "..tostring(rando).. "<=?Else D ") end
			debugTxt = debugTxt .."DcW ProbaPlow weather rando: "..tostring(rando).. "<=?Else D ".."\n"
		end
	end	
		
		-- local rando = math.random(1,4)
		-- if debugWeather then print("DcW NO rando: " ..rando) end
		
		-- if rando == 1 then
		-- 	camp.weather.zoneNext = "low sector cold"					--next zone is a cold sector
		-- elseif rando == 2 then
		-- 	camp.weather.zoneNext = "low sector warm"					--next zone is a warm sector
		-- elseif rando == 3 then
		-- 	camp.weather.zoneNext = "low front cold"					--Next zone is a cold front
		-- elseif rando == 4 then
		-- 	camp.weather.zoneNext = "low front warm"					--Next zone is a warm front
		-- end
	-- end
	
	camp.weather.zoneEnd = -1											--Current (non-existing) zone end negative to trigger weather change
	InitalW = true
end 



-- if debugWeather then print("DcW camp.weather.zoneTemp: " ..tostring(camp.weather.zoneTemp)) end
-- if debugWeather then print("DcW camp.weather.zone: " ..tostring(camp.weather.zone)) end
-- if debugWeather then print("DcW camp.weather.zoneNext: " ..camp.weather.zoneNext) end

debugTxt = debugTxt .."DcW camp.weather.zoneTemp: " ..tostring(camp.weather.zoneTemp).."\n"
debugTxt = debugTxt .."DcW camp.weather.zone: " ..tostring(camp.weather.zone).."\n"
debugTxt = debugTxt .."DcW camp.weather.zoneNext: " ..camp.weather.zoneNext.."\n"

local elapsed_time = (camp.date.day - 1) * 86400 + camp.time					--elapsed time since campaign start in seconds

--Weather change
if elapsed_time > camp.weather.zoneEnd then										--active weather zone has ended

	--Active zone
	camp.weather.zone = camp.weather.zoneNext									--make next weather zone the active weather zone
	camp.weather.zoneStart = camp.weather.zoneEnd								--time active weather zone has started
	if camp.weather.zone == "high" then
		camp.weather.zoneEnd = elapsed_time + math.random(86400, 172800 )		--432000(5j)	--set duration of current weather zone (between 1 and 2 days for High system)
		camp.weather.zoneTemp = camp.weather.zoneNextTemp						--make next weather zone temperature the current temperature
	elseif camp.weather.zone == "low front cold" then
		camp.weather.zoneEnd = elapsed_time + math.random(14400, 28800)			--set duration of current weather zone (between 4 and 8 hours for cold front)
	elseif camp.weather.zone == "low front warm" then
		camp.weather.zoneEnd = elapsed_time + math.random(43200, 86400)			--set duration of current weather zone (between 12 and 24 hours for warm front)
	elseif camp.weather.zone == "low sector cold" then
		camp.weather.zoneEnd = elapsed_time + math.random(21600, 172800)		--set duration of current weather zone (between 6 and 48 hours for cold sector)
		camp.weather.zoneTemp = camp.weather.zoneNextTemp						--make next weather zone temperature the current temperature
	elseif camp.weather.zone == "low sector warm" then
		camp.weather.zoneEnd = elapsed_time + math.random(21600, 172800)		--set duration of current weather zone (between 6 and 48 hours for warm sector)
		camp.weather.zoneTemp = camp.weather.zoneNextTemp						--make next weather zone temperature the current temperature
	end
	
	--Next zone
	camp.weather.zoneNextTemp = math.random(mission_ini.weather.refTemp - 5, mission_ini.weather.refTemp + 5)			--Set temperature of next weather zone (+/- 5°C of reference tempereature)
	
	if not InitalW then 																		-- evite de passer 2 fois le random lors de la premiere mission
		
		-- local chance = 100 / (mission_ini.weather.pHigh + mission_ini.weather.pLow) * mission_ini.weather.pHigh					--chance of next weather zone being a high pressure system
		local ProbaPhight = (mission_ini.weather.pHigh / (mission_ini.weather.pHigh + mission_ini.weather.pLow)) * 100					--chance of next weather zone being a high pressure system
		local randChance = math.random(1, 100)
			-- if debugWeather then print("Next zone: "..tostring(randChance).. "<=? "..tostring(ProbaPhight)) end	
			debugTxt = debugTxt .."Next zone: "..tostring(randChance).. "<=? "..tostring(ProbaPhight).."\n"
		if randChance <= ProbaPhight   then								--High pressure system
			camp.weather.zoneNext = "high"									--set next weather zone		
		else																--Low pressure system
			if camp.weather.zone == "low front cold" then					--active zone is a cold front
				camp.weather.zoneNext = "low sector cold"					--next zone is a cold sector
			elseif camp.weather.zone == "low front warm" then				--active zone is a warm front
				camp.weather.zoneNext = "low sector warm"					--next zone is a warm sector
			else															--active zone is a sector (warm or cold), next zone is a front (warm or cold)
				if camp.weather.zoneTemp > camp.weather.zoneNextTemp then	--Next zone is colder
					camp.weather.zoneNext = "low front cold"				--Next zone is a cold front
				elseif camp.weather.zoneTemp < camp.weather.zoneNextTemp then	--Next zone is warmer
					camp.weather.zoneNext = "low front warm"				--Next zone is a warm front
				else														--Next zone has same tempreature
					camp.weather.zoneNext = camp.weather.zone				--Next zone remains the same (warm or cold sectior)
				end
			end
		end
	end
end

if debugWeather then 
	print("calcul new weather:")
	_affiche(camp.weather, "camp.weather DcW")
end
debugTxt = debugTxt .."".."\n"
-- if debugWeather then print("camp.weather.zone "..tostring(camp.weather.zone)) end	


-- 1	Light Scattered 1	FEW/SCT 7/8	25%
-- 2	Light Scattered 2	FEW/SCT 8/10 SCT 23/24	33%
-- 3	High Scattered 1	SCT 8/9 FEW 21	50%
-- 4	High Scattered 2	SCT 8/10 FEW 24/26	50%
-- 5	High Scattered 3	SCT/BKN  18/20 FEW 36/38 FEW 40	67%
-- 6	Scattered 1	SCT 14/17 FEW 27/29 BKN 40	50%
-- 7	Scattered 2	SCT/BKN 8/10 FEW 40	67%
-- 8	Scattered 3	BKN 7.5/12 SCT/BKN 21/23 SCT 40	75%
-- 9	Scattered 4	BKN 7.5/10 SCT 20/22	75%
-- 10	Scattered 5	SCT/BKN 18/20 FEW 36/38 FEW 40	67%
-- 11	Scattered 6	BKN 18/20 BKN 32/33 FEW 41	75%
-- 12	Scattered 7	BKN 12/14 SCT 22/23 FEW 41	75%
-- 13	Broken 1	BKN 12/14 BKN 26/28 FEW 41	75%
-- 14	Broken 2	BKN/LYR 7/16 FEW 41	87%
-- 15	Broken 3	SCT/BKN 14/18 BKN 24/27 FEW 41	67%
-- 16	Broken 4	BKN 14/18 BKN 28/30 FEW 40	75%
-- 17	Broken 5	BKN/OVC 7/13 20/22 32/34	87%
-- 18	Broken 6	BKN/OVC 13/15 25/29 38/41	87%
-- 19	Broken 7	OVC 9/16 BKN/OVC 23/24 31/33	100%
-- 20	Broken 8	BKN/OVC 13/18 BKN 28/30 SCT/FEW 38	87%
-- 21	Overcast 1	BKN/OVC 7/8 17/19	87%
-- 22	Overcast 2	BKN/OVC 7/10 17/20	87%
-- 23	Overcast 3	BKN/OVC 11/14 18/25 SCT 32/35	87%
-- 24	Overcast 4	BKN/OVC 3/7 17/22 BKN 34	87%
-- 25	Overcast 5	OVC 12/14 22/25 40/42	87%
-- 26	Overcast 6	OVC 9/15 BKN 23/25 SCT 32	100%
-- 27	Overcast 7	OVC 8/15 SCT/BKN 25/26 34/36	100%
-- 28	Overcast and Rain 1	VIS3-5KM RA OVC 3/15 28/30 FEW 40	100%
-- 29	Overcast and Rain 2	VIS 1-5KM RA OVC 3/11 SCT 18/29 FEW 40	100%
-- 30	Overcast and Rain 3	VIS 3.5KM RA OVC 6/18 19/21 SCT 34	100%


local preset = {
	[1] = {
		altiMin = 840,
		altiMax = 4100,
		name = "Preset1",
		nameVignette = "Light Scattered 1",
		thickness = 200,
		--FEW/SCT 7/8
		layers = {
			{
				presetMetar = "FEW/SCT",
				base = 7,
				ceiling = 8,
			},
		},
		cover = 25,
	},
	[2] = {
		altiMin = 1260,
		altiMax = 2520,
		name = "Preset2",
		nameVignette = "Light Scattered 2",

		thickness = 200,
		nameMETAR = "FEW/SCT 8/10 SCT 23/24",
		layers = {
			{
				presetMetar = "FEW/SCT",
				base = 8,
				ceiling = 10,
			},
			{
				presetMetar = "SCT",
				base = 23,
				ceiling = 24,
			},
		},
		cover = 33,
	},
	[3] = {
		altiMin = 840,
		altiMax = 2520,
		name = "Preset3",
		nameVignette = "Hight Scattered 1",
		nameMETAR = "SCT 8/9 FEW 21",
		layers = {
			{
				presetMetar = "SCT",
				base = 8,
				ceiling = 9,
			},
			{
				presetMetar = "FEW",
				base = 21,
				ceiling = 0,
			},
		},
		cover = 50,
	},
	[4] = {
		altiMin = 1260,
		altiMax = 2520,
		name = "Preset4",
		nameVignette = "Hight Scattered 2",
		nameMETAR = "SCT 8/10 FEW 24/26",
		layers = {
			{
				presetMetar = "SCT",
				base = 8,
				ceiling = 10,
			},
			{
				presetMetar = "FEW",
				base = 24,
				ceiling = 26,
			},
		},
		cover = 50,
	},
	
	[5] = {
		altiMin = 1260,
		altiMax = 4620,
		name = "Preset5",
		nameVignette = "Scattered 1",
		nameMETAR = "SCT/BKN  18/20 FEW 36/38 FEW 40",
		layers = {
			{
				presetMetar = "SCT/BKN",
				base = 18,
				ceiling = 20,
			},
			{
				presetMetar = "FEW",
				base = 36,
				ceiling = 38,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 67,
	},
	[6] = {
		altiMin = 1260,
		altiMax = 4200,
		name = "Preset6",
		nameVignette = "Scattered 2",					--okok
		nameMETAR = "SCT 14/17 FEW 27/29 BKN 40",
		layers = {
			{
				presetMetar = "SCT",
				base = 14,
				ceiling = 17,
			},
			{
				presetMetar = "FEW",
				base = 27,
				ceiling = 29,
			},
			{
				presetMetar = "BKN",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 50,
	},
	[7] = {
		altiMin = 1680,
		altiMax = 5040,
		name = "Preset7",
		nameVignette = "Scattered 3",
		nameMETAR = "SCT/BKN 8/10 FEW 40",
		layers = {
			{
				presetMetar = "SCT/BKN",
				base = 8,
				ceiling = 10,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},	
		cover = 67,
	},
	[8] = {
		altiMin = 3780,
		altiMax = 5460,
		name = "Preset8",
		nameVignette = "Hight Scattered 3",
		nameMETAR = "BKN 7.5/12 SCT/BKN 21/23 SCT 40",
		layers = {
			{
				presetMetar = "BKN",
				base = 7.5,
				ceiling = 12,
			},
			{
				presetMetar = "SCT/BKN",
				base = 21,
				ceiling = 23,
			},
			{
				presetMetar = "SCT",
				base = 40,
				ceiling = 0,
			},
		},
		cover = 75,	
	},
	[9] = {
		altiMin = 1680,
		altiMax = 3780,
		name = "Preset9",
		nameVignette = "Scattered 4",				--ok	ok
		nameMETAR = "BKN 7.5/10 SCT 20/22",
		layers = {
			{
				presetMetar = "BKN",
				base = 7.5,
				ceiling = 10,
			},
			{
				presetMetar = "SCT",
				base = 20,
				ceiling = 22,
			},
		},	
		cover = 75,
	},
	[10] = {
		altiMin = 1260,
		altiMax = 4200,
		name = "Preset10",
		nameVignette = "Scattered 5",				-- OK	ok
		nameMETAR = "SCT/BKN 18/20 FEW 36/38 FEW 40",
		layers = {
			{
				presetMetar = "SCT/BKN",
				base = 18,
				ceiling = 20,
			},
			{
				presetMetar = "FEW",
				base = 36,
				ceiling = 38,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},	
		cover = 67,
	},
	[11] = {
		altiMin = 2520,
		altiMax = 5460,
		name = "Preset11",
		nameVignette = "Scattered 6",				--okok
		nameMETAR = "BKN 18/20 BKN 32/33 FEW 41",
		layers = {
			{
				presetMetar = "BKN",
				base = 18,
				ceiling = 20,
			},
			{
				presetMetar = "BKN",
				base = 32,
				ceiling = 33,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},	
		cover = 75,
	},
	[12] = {
		altiMin = 1680,
		altiMax = 3360,
		name = "Preset12",
		nameVignette = "Scattered 7",					--okok
		nameMETAR = "BKN 12/14 SCT 22/23 FEW 41",
		layers = {
			{
				presetMetar = "BKN",
				base = 12,
				ceiling = 14,
			},
			{
				presetMetar = "SCT",
				base = 22,
				ceiling = 23,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},	
		cover = 75,
	},
	[13] = {
		altiMin = 1680,
		altiMax = 3360,
		name = "Preset13",
		nameVignette = "Broken 1",					--okok
		nameMETAR = "BKN 12/14 BKN 26/28 FEW 41",
		layers = {
			{
				presetMetar = "BKN",
				base = 12,
				ceiling = 14,
			},
			{
				presetMetar = "BKN",
				base = 26,
				ceiling = 28,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},	
		cover = 75,
	},
	[14] = {
		altiMin = 1680,
		altiMax = 3360,
		name = "Preset14",
		nameVignette = "Broken 2",					--okok
		nameMETAR = "BKN/LYR 7/16 FEW 41",
		layers = {
			{
				presetMetar = "BKN/LYR",
				base = 7,
				ceiling = 16,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},	
		cover = 87,
	},
	[15] = {
		altiMin = 840,
		altiMax = 5040,
		name = "Preset15",
		nameVignette = "Broken 3",
		nameMETAR = "SCT/BKN 14/18 BKN 24/27 FEW 41",
		layers = {
			{
				presetMetar = "SCT/BKN",
				base = 14,
				ceiling = 18,
			},
			{
				presetMetar = "BKN",
				base = 24,
				ceiling = 27,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},	
		cover = 67,
	},
	[16] = {
		altiMin = 1260,
		altiMax = 4200,
		name = "Preset16",
		nameVignette = "Broken 4",
		nameMETAR = "BKN 14/18 BKN 28/30 FEW 40",
		layers = {
			{
				presetMetar = "BKN",
				base = 14,
				ceiling = 18,
			},
			{
				presetMetar = "BKN",
				base = 28,
				ceiling = 30,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},	
		cover = 75,
	},
	[17] = {
		altiMin = 0,
		altiMax = 2520,
		name = "Preset17",
		nameVignette = "Broken 5",
		nameMETAR = "BKN/OVC 7/13 20/22 32/34",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 7,
				ceiling = 13,
			},
			{
				presetMetar = "",
				base = 20,
				ceiling = 22,
			},
			{
				presetMetar = "",
				base = 32,
				ceiling = 34,
			},
		},	
		cover = 87,
	},
	[18] = {
		altiMin = 0,
		altiMax = 3780,
		name = "Preset18",
		nameVignette = "Broken 6",
		nameMETAR = "BKN/OVC 13/15 25/29 38/41",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 13,
				ceiling = 15,
			},
			{
				presetMetar = "",
				base = 25,
				ceiling = 29,
			},
			{
				presetMetar = "",
				base = 38,
				ceiling = 41,
			},
		},	
		cover = 87,
	},
	[19] = {
		altiMin = 0,
		altiMax = 2940,
		name = "Preset19",
		nameVignette = "Broken 7",
		nameMETAR = "OVC 9/16 BKN/OVC 23/24 31/33",
		layers = {
			{
				presetMetar = "OVC",
				base = 9,
				ceiling = 16,
			},
			{
				presetMetar = "BKN/OVC",
				base = 23,
				ceiling = 24,
			},
			{
				presetMetar = "FEW",
				base = 31,
				ceiling = 33,
			},
		},	
		cover = 100,
	},
	[20] = {
		altiMin = 0,
		altiMax = 3780,
		name = "Preset20",
		nameVignette = "Broken 8",					--okok
		nameMETAR = "BKN/OVC 13/18 BKN 28/30 SCT/FEW 38",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 13,
				ceiling = 18,
			},
			{
				presetMetar = "BKN",
				base = 28,
				ceiling = 30,
			},
			{
				presetMetar = "SCT/FEW",
				base = 38,
				ceiling = 0,
			},
		},
		cover = 87,	
	},
	[21] = {
		altiMin = 1260,
		altiMax = 4200,
		name = "Preset21",
		nameVignette = "Overcast 1",				--okok
		nameMETAR = "BKN/OVC 7/8 17/19",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 7,
				ceiling = 8,
			},
			{
				presetMetar = "BKN",
				base = 17,
				ceiling = 19,
			},
			{
				presetMetar = "FEW",
				base = 41,
				ceiling = 0,
			},
		},	
		cover = 87,
	},
	[22] = {
		altiMin = 420,
		altiMax = 4200,
		name = "Preset22",
		nameVignette = "Overcast 2",
		nameMETAR = "BKN/OVC 7/10 17/20",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 7,
				ceiling = 10,
			},
			{
				presetMetar = "BKN",
				base = 17,
				ceiling = 20,
			},
		},
		cover = 87,	
	},
	[23] = {
		altiMin = 840,
		altiMax = 3360,
		name = "Preset23",
		nameVignette = "Overcast 3",
		nameMETAR = "BKN/OVC 11/14 18/25 SCT 32/35",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 11,
				ceiling = 14,
			},
			{
				presetMetar = "",
				base = 18,
				ceiling = 25,
			},
			{
				presetMetar = "SCT",
				base = 32,
				ceiling = 35,
			},
		},	
		cover = 87,
	},
	[24] = {
		altiMin = 420,
		altiMax = 2520,
		name = "Preset24",
		nameVignette = "Overcast 4",
		nameMETAR = "BKN/OVC 3/7 17/22 BKN 34",
		layers = {
			{
				presetMetar = "BKN/OVC",
				base = 3,
				ceiling = 7,
			},
			{
				presetMetar = "",
				base = 17,
				ceiling = 22,
			},
			{
				presetMetar = "BKN",
				base = 34,
				ceiling = 0,
			},
		},	
		cover = 87,
	},
	[25] = {
		altiMin = 420,
		altiMax = 3360,
		name = "Preset25",
		nameVignette = "Overcast 5",
		nameMETAR = "OVC 12/14 22/25 40/42",
		layers = {
			{
				presetMetar = "OVC",
				base = 12,
				ceiling = 14,
			},
			{
				presetMetar = "BKN",
				base = 22,
				ceiling = 25,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 42,
			},
		},	
		cover = 87,
	},
	[26] = {
		altiMin = 420,
		altiMax = 2940,
		name = "Preset26",
		nameVignette = "Overcast 6",
		nameMETAR = "OVC 9/15 BKN 23/25 SCT 32",
		layers = {
			{
				presetMetar = "OVC",
				base = 9,
				ceiling = 15,
			},
			{
				presetMetar = "BKN",
				base = 23,
				ceiling = 25,
			},
			{
				presetMetar = "SCT",
				base = 32,
				ceiling = 0,
			},
		},
		cover = 100,	
	},
	[27] = {
		altiMin = 420,
		altiMax = 2520,
		name = "Preset27",
		nameVignette = "Overcast 7",
		nameMETAR = "OVC 8/15 SCT/BKN 25/26 34/36",
		layers = {
			{
				presetMetar = "OVC",
				base = 8,
				ceiling = 15,
			},
			{
				presetMetar = "SCT/BKN",
				base = 25,
				ceiling = 26,
			},
			{
				presetMetar = "",
				base = 34,
				ceiling = 36,
			},
		},	
		cover = 100,
	},
	[28] = {
		altiMin = 420,
		altiMax = 2500,
		name = "RainyPreset1",
		visibility = 3000,
		nameVignette = "Overcast And Rain 1",
		nameMETAR = "VIS3-5KM RA OVC 3/15 28/30 FEW 40",
		layers = {
			{
				presetMetar = "VIS3-5KM RA OVC",
				base = 3,
				ceiling = 15,
			},
			{
				presetMetar = "",
				base = 28,
				ceiling = 30,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},	
		cover = 100,
	},
	[29] = {
		altiMin = 840,
		altiMax = 2520,
		name = "RainyPreset2",
		visibility = 1000,
		nameVignette = "Overcast And Rain 2",
		nameMETAR = "VIS 1-5KM RA OVC 3/11 SCT 18/29 FEW 40",
		layers = {
			{
				presetMetar = "VIS 1-5KM RA OVC",
				base = 3,
				ceiling = 11,
			},
			{
				presetMetar = "SCT",
				base = 18,
				ceiling = 29,
			},
			{
				presetMetar = "FEW",
				base = 40,
				ceiling = 0,
			},
		},	
		cover = 100,
	},
	[30] = {
		altiMin = 840,
		altiMax = 2520,
		name = "RainyPreset3",
		visibility = 3500,
		nameVignette = "Overcast And Rain 2",
		nameMETAR = "VIS 3.5KM RA OVC 6/18 19/21 SCT 34",
		layers = {
			{
				presetMetar = "VIS 3.5KM RA OVC",
				base = 6,
				ceiling = 18,
			},
			{
				presetMetar = "",
				base = 19,
				ceiling = 21,
			},
			{
				presetMetar = "SCT",
				base = 34,
				ceiling = 0,
			},
		},
		cover = 100,	
	},
}


--Set current weather
----- HIGH -----
if camp.weather.zone == "high" then

	if camp.weather.zoneTemp >= 30 then				--si T° sup= à 30: aucun nuage, on se passe du nouveau systeme de nuage de DCS
		Rmini = 0
		Rmaxi = 0
	elseif camp.weather.zoneTemp >= 25 then				--si T° sup= à 25: proba entre ancien systeme (pas de nuage) et les 2 premiers nuages du nouveau systeme DCS
		Rmini = 0
		Rmaxi = 2
	else											--sinon, proba entre les 4 premiers nuages du nouveau systeme DCS
		Rmini = 1
		Rmaxi = 4
	end
	
	presetMiss = ""
	baseChoice = 5000							--TODO quelle base est appliquée par l editeur de mission en cas d extreme beau
	PresetChoice = math.random(Rmini, Rmaxi)
	
	if PresetChoice ~= 0 then
		baseChoice =  math.random(preset[PresetChoice].altiMin, preset[PresetChoice].altiMax)		
		presetMiss = preset[PresetChoice].name
	end
	
	--clouds
	mission.weather["clouds"] = {
		["thickness"] = 0,
		["density"] = 0,
		["base"] = baseChoice,
		["iprecptns"] = 0,
		["preset"] = presetMiss,
	}

	--wind
	-- local windDir = 180
	local windDir = math.random(0, 359)
	local windSpeed = math.random(0, 5)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 2.5,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed * 0.8,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence


	-- mission.weather["turbulence"] = {
	-- 	["at8000"] = math.random(0, windSpeed*2),--10
	-- 	["at2000"] = math.random(0, windSpeed*2),--10
	-- 	["atGround"] = math.random(0, windSpeed*2),--10
	-- }

	local coef = 1
	local ponderation = math.random(1, 100)
	if ponderation <= 50 then
		coef = 1
	elseif ponderation <= 100 then
		coef = 2
	end
			-- mission.weather["turbulence"] = {
			-- 	["atGround"] = math.random(0, mission.weather.wind.atGround.speed * coef),--10
			-- 	["at2000"] = math.random(0,  mission.weather.wind.at2000.speed * coef),--10
			-- 	["at8000"] = math.random(0,  mission.weather.wind.at8000.speed * coef),--10
			-- }
	-- if max_atGroung <= 0 then max_atGroung = 1 end
	mission.weather["groundTurbulence"] = math.random(0, mission.weather.wind.atGround.speed * coef) --10
	-- print("DcW ponderation High "..ponderation.." coef "..coef.." max_atGroung: "..max_atGroung.." groundTurbulence: "..mission.weather["groundTurbulence"])
	-- mission.weather["groundTurbulence"] = math.random(0, 10)--10
	
	--temperature
	mission.weather["season"]["temperature"] = camp.weather.zoneTemp
	-- if debugWeather then print("DcW B temperature: "..mission.weather["season"]["temperature"]) end
	debugTxt = debugTxt .."DcW B temperature: "..mission.weather["season"]["temperature"].."\n"
	--pressure
	-- 720- -790 mm Hg
	mission.weather["qnh"] = math.random(760, 780)

	
----- COLD FRONT -----
elseif camp.weather.zone == "low front cold" then

	local front_remaining = (camp.weather.zoneEnd - elapsed_time) / 3600					--hours until end of cold front
	local front_duration = (camp.weather.zoneEnd - camp.weather.zoneStart) / 3600			--duration of the front in hours
	local strength = 10 - front_remaining * 10 / front_duration								--strength of the front on a scale of 0-10
	
	--clouds
	PresetChoice = math.random(28, 30)
	if FieldElevation >= preset[PresetChoice].altiMin and FieldElevation <= preset[PresetChoice].altiMax then
		baseChoice =  math.random(FieldElevation, preset[PresetChoice].altiMax)
	else
		baseChoice =  math.random(preset[PresetChoice].altiMin, preset[PresetChoice].altiMax)
	end
	
	mission.weather["clouds"] = {
		["thickness"] = math.random(4000, 8000),
		["density"] = math.random(9, 10),
		-- ["base"] = FieldElevation + math.random(100, 500),
		["base"] = baseChoice,
		["iprecptns"] = math.random(1, 2),
		["preset"] = preset[PresetChoice].name,
	}

	--wind
	-- local windDir = 180
	local windDir = math.random(0, 359)
	local windSpeed = math.random(3, 5)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 2.5,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed * 0.8,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence
	local coef = 1
	local ponderation = math.random(1, 100)
	if ponderation <= 8 then
		coef = 1
	elseif ponderation < 16 then
		coef = 2
	elseif ponderation < 24 then
		coef = 3
	elseif ponderation < 32 then
		coef = 4
	elseif ponderation < 40 then
		coef = 5
	elseif ponderation < 48 then
		coef = 6
	elseif ponderation < 56 then
		coef = 7
	elseif ponderation < 64 then
		coef = 8
	elseif ponderation < 72 then
		coef = 9
	elseif ponderation < 80 then
		coef = 10
	elseif ponderation < 88 then
		coef = 11
	elseif ponderation <= 100 then
		coef = 12
	end
	local max_atGroung = (mission.weather.wind.atGround.speed * coef > 10 and mission.weather.wind.atGround.speed * coef or 11)
	if max_atGroung <= 10 then max_atGroung = 11 end
	if max_atGroung > 60 then max_atGroung = 60 end
	mission.weather["groundTurbulence"] = math.random(10, max_atGroung)--60
	-- if debugWeather then
	-- 	print("DcW ponderation LFC "..ponderation.." coef "..coef.." max_atGroung: "..max_atGroung.." groundTurbulence: "..mission.weather["groundTurbulence"])
	-- end
	debugTxt = debugTxt .."DcW ponderation LFC "..ponderation.." coef "..coef.." max_atGroung: "..max_atGroung.." groundTurbulence: "..mission.weather["groundTurbulence"].."\n"
			-- mission.weather["groundTurbulence"] = math.random(10, 60)--60
	--temperature
	mission.weather["season"]["temperature"] = math.ceil(camp.weather.zoneTemp + strength * (camp.weather.zoneNextTemp - camp.weather.zoneTemp) / 10)
	
	--pressure
	mission.weather["qnh"] = math.random(740, 760)


------ WARM FRONT -----
elseif camp.weather.zone == "low front warm" then

	local front_remaining = (camp.weather.zoneEnd - elapsed_time) / 3600					--hours until end of warm front
	local front_duration = (camp.weather.zoneEnd - camp.weather.zoneStart) / 3600			--duration of the front in hours
	local strength = 10 - front_remaining * 10 / front_duration								--strength of the front on a scale of 0-10
	
	--clouds
	-- pondere en fonction des zones desertique (%low weather)
	-- print("DcW LFW ProbaPhight "..ProbaPhight)
	-- print("DcW LFW AVANT strength "..strength)
	-- print("DcW LFW  math.random "..math.floor(strength - (strength * ProbaPhight/100)).." BTW  "..math.ceil(strength))

	strength = math.random(math.floor(strength - (strength * ProbaPhight/100)), math.ceil(strength)) 

	-- print("DcW LFW APRES strength "..strength)

	local dens = math.ceil(strength * 1.5)
	if dens > 10 then
		dens = 10
	end
	-- local conversionDens = math.ceil(dens * 0.8)
	local conversionDens = math.ceil((0.77777777777778 * dens) + 0.22222222222222)
	local presetCompatible = {}
	local maxloop = 1
	local tolerance = 0
	repeat
		for n=1, #preset do
			if math.ceil(preset[n].cover/10) <= conversionDens + tolerance and math.ceil(preset[n].cover/10) >= conversionDens - tolerance then
				table.insert(presetCompatible, n )
			end
			maxloop = maxloop +1
		end
		tolerance = tolerance + 1
	until #presetCompatible >= 1 or maxloop > 200

	if #presetCompatible == 0 then
		presetCompatible = {1, 2, 3}
		print("DcW PresetCompatible Error")
		os.execute 'pause'
	end

	PresetChoice = math.random(1, #presetCompatible)
	PresetChoice = presetCompatible[PresetChoice]

	-- PresetChoice = math.random(10, 20)
	-- baseChoice =  math.random(preset[PresetChoice].altiMin, preset[PresetChoice].altiMax)
	if FieldElevation >= preset[PresetChoice].altiMin and FieldElevation <= preset[PresetChoice].altiMax then
		baseChoice =  math.random(FieldElevation, preset[PresetChoice].altiMax)
	else
		baseChoice =  math.random(preset[PresetChoice].altiMin, preset[PresetChoice].altiMax)
	end

	mission.weather["clouds"] = {
		["thickness"] = math.ceil(strength * 200),
		["density"] = dens,
		-- ["base"] = FieldElevation + 100 + math.ceil(8000 - strength * 800),
		["base"] = baseChoice,
		["preset"] = preset[PresetChoice].name,
	}

	--il ne pleut que dans les preset 28/29/30
	if PresetChoice >= 28 and PresetChoice <= 30 then
		mission.weather["clouds"]["iprecptns"] = math.floor(strength * 0.2)
	else
		mission.weather["clouds"]["iprecptns"] = 0
	end
	

	--wind
	-- local windDir = 180
	local windDir = math.random(0, 359)
	local windSpeed = math.random(2, 5)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 2.5,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed * 0.8,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence
	local coef = 1
	local ponderation = math.random(1, 100)
	if ponderation <= 50 then
		coef = 1
	elseif ponderation <= 60 then
		coef = 2
	elseif ponderation <= 70 then
		coef = 3
	elseif ponderation <= 80 then
		coef = 4
	elseif ponderation <= 90 then
		coef = 5
	elseif ponderation <= 100 then
		coef = 6
	end
	local max_atGroung = (mission.weather.wind.atGround.speed * coef > 5 and mission.weather.wind.atGround.speed * coef or 5)
		-- local max_at2000 = (mission.weather.wind.at2000.speed * coef > 5 and mission.weather.wind.at2000.speed * coef or 5)
		-- local max_at8000 = (mission.weather.wind.at8000.speed * coef > 5 and mission.weather.wind.at8000.speed * coef or 5)

		-- mission.weather["turbulence"] = {
		-- 	["atGround"] = math.random(5, max_atGroung),--30
		-- 	["at2000"] = math.random(5,  max_at2000),--30
		-- 	["at8000"] = math.random(5,  max_at8000),--30
		-- }

	if max_atGroung <= 10 then max_atGroung = 11 end
	mission.weather["groundTurbulence"] = math.random(10, max_atGroung)--30
	-- print("DcW ponderation LFW "..ponderation.." coef "..coef.." max_atGroung: "..max_atGroung.." groundTurbulence: "..mission.weather["groundTurbulence"])
	-- mission.weather["groundTurbulence"] = math.random(10, 30)--30
	
	--temperature
	mission.weather["season"]["temperature"] = math.ceil(camp.weather.zoneTemp + strength * (camp.weather.zoneNextTemp - camp.weather.zoneTemp) / 10)
	
	--pressure
	mission.weather["qnh"] = math.random(740, 760)

	
----- COLD SECTOR ------
elseif camp.weather.zone == "low sector cold" then

	--clouds
	-- PresetChoice = math.random(20, 25)
	PresetChoice = 1
	baseChoice =  math.random(preset[PresetChoice].altiMin, preset[PresetChoice].altiMax)
	
	mission.weather["clouds"] = {
		["thickness"] = math.random(100, 1000),
		["density"] = math.random(0, 1),
		-- ["base"] = math.random(4000, 6000),
		["base"] = baseChoice,
		
		["iprecptns"] = 0,
		["preset"] = preset[PresetChoice].name,
	}

	--wind
	-- local windDir = 180
	local windDir = math.random(0, 359)
	local windSpeed = math.random(1, 5)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 2.5,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed * 0.8,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence
	local coef = 1
	local ponderation = math.random(1, 100)
	if ponderation <= 50 then
		coef = 1
	elseif ponderation <= 60 then
		coef = 2
	elseif ponderation <= 70 then
		coef = 3
	elseif ponderation <= 80 then
		coef = 4
	elseif ponderation <= 90 then
		coef = 5
	elseif ponderation <= 100 then
		coef = 6
	end
	local max_atGroung = (mission.weather.wind.atGround.speed * coef > 5 and mission.weather.wind.atGround.speed * coef or 5)
			-- local max_at2000 = (mission.weather.wind.at2000.speed * coef > 5 and mission.weather.wind.at2000.speed * coef or 5)
			-- local max_at8000 = (mission.weather.wind.at8000.speed * coef > 5 and mission.weather.wind.at8000.speed * coef or 5)

			-- mission.weather["turbulence"] = {
			-- 	["atGround"] = math.random(5, max_atGroung),--30
			-- 	["at2000"] = math.random(5,  max_at2000),--30
			-- 	["at8000"] = math.random(5,  max_at8000),--30
			-- }
	if max_atGroung <= 10 then max_atGroung = 11 end
	mission.weather["groundTurbulence"] = math.random(10, max_atGroung)--30
	-- print("DcW ponderation LSC "..ponderation.." coef "..coef.." max_atGroung: "..max_atGroung.." groundTurbulence: "..mission.weather["groundTurbulence"])
	-- mission.weather["groundTurbulence"] = math.random(10, 30)--30

	--temperature
	mission.weather["season"]["temperature"] = camp.weather.zoneTemp
	
	--pressure
	mission.weather["qnh"] = math.random(740, 760)


----- WARM SECTOR -----
elseif camp.weather.zone == "low sector warm" then

	--clouds
	PresetChoice = math.random(5, 20)
	baseChoice =  math.random(preset[PresetChoice].altiMin, preset[PresetChoice].altiMax)
	
	mission.weather["clouds"] = {
		["thickness"] = math.random(100, 1000),
		["density"] = math.random(1, 4),
		-- ["base"] = math.random(4000, 6000),
		["base"] = baseChoice,
		["iprecptns"] = 0,
		["preset"] = preset[PresetChoice].name,
	}

	--wind
	-- local windDir = 180
	local windDir = math.random(0, 359)
	local windSpeed = math.random(1, 5)
	mission.weather["wind"] = {
		["at8000"] = 
		{
			["speed"] = windSpeed * 2.5,
			["dir"] = windDir,
		},
		["at2000"] = 
		{
			["speed"] = windSpeed * 0.8,
			["dir"] = windDir,
		},
		["atGround"] = 
		{
			["speed"] = windSpeed,
			["dir"] = windDir,
		},
	}
	
	--turbulence
	local coef = 1
	local ponderation = math.random(1, 100)

	if ponderation <= 50 then
		coef = 1
	elseif ponderation <= 60 then
		coef = 2
	elseif ponderation <= 70 then
		coef = 3
	elseif ponderation <= 80 then
		coef = 4
	elseif ponderation <= 90 then
		coef = 5
	elseif ponderation <= 100 then
		coef = 6
	end
	
	local max_atGroung = (mission.weather.wind.atGround.speed * coef > 5 and mission.weather.wind.atGround.speed * coef or 6)
			-- local max_at2000 = (mission.weather.wind.at2000.speed * coef > 5 and mission.weather.wind.at2000.speed * coef or 6)
			-- local max_at8000 = (mission.weather.wind.at8000.speed * coef > 5 and mission.weather.wind.at8000.speed * coef or 6)

			-- mission.weather["turbulence"] = {
			-- 	["atGround"] = math.random(5, max_atGroung),--30
			-- 	["at2000"] = math.random(5,  max_at2000),--30
			-- 	["at8000"] = math.random(5,  max_at8000),--30
			-- }
	
	if max_atGroung <= 10 then max_atGroung = 11 end
	mission.weather["groundTurbulence"] = math.random(10, max_atGroung)--30
	-- mission.weather["groundTurbulence"] = math.random(10, 30)--30
	-- print("DcW ponderation LSW "..ponderation.." coef "..coef.." max_atGroung: "..max_atGroung.." groundTurbulence: "..mission.weather["groundTurbulence"])


	--temperature
	mission.weather["season"]["temperature"] = camp.weather.zoneTemp
	
	--pressure
	mission.weather["qnh"] = math.random(740, 760)
	
	
end


--Time of day temperature modification, min at 5 o'clock, max at 17 o'clock, deltaT 1 °C per hour
local hour = math.floor(camp.time / 3600)								--convert time to hours rounded down
if hour <= 5 then														--before 5 o'clock in the morning
	mission.weather["season"]["temperature"] = mission.weather["season"]["temperature"] - 7 - hour
elseif hour <= 17 then													--between 5 and 17 o'clock
	mission.weather["season"]["temperature"] = mission.weather["season"]["temperature"] - 17 + hour
else																	--after 17 o'clock
	mission.weather["season"]["temperature"] = mission.weather["season"]["temperature"] + 17 - hour
end


--Fog
if mission.weather["wind"]["atGround"]["speed"] < 2 then															--Fog is possible at speeds below 2 m/s
	if mission.weather["season"]["temperature"] < 12 and mission.weather["season"]["temperature"] > -2 then			--Fog is possoble at temperatures between -2 and 12 °C
		if math.random(1, 2) == 1 then																				--20% chance of fog
			mission.weather["enable_fog"] = true
			mission.weather["fog"] = {
				["thickness"] = math.random(0, 1000),
				["visibility"] = math.random(0,10000),
			}

			--pas de turbulence lors d'un brouillard ....
			-- mission.weather["turbulence"] = {
			-- 	["atGround"] = 0,
			-- 	["at2000"] = mission.weather.turbulence.at2000 / 4,
			-- 	["at8000"] = mission.weather.turbulence.at2000 / 2,
			-- }
			mission.weather["groundTurbulence"] = 0
		end
	end
end

--halo
mission.weather["halo"] = 
{
	["preset"] = "auto",
}

if mission.weather.clouds.preset == "" then
	mission.weather.clouds.preset = nil
end

--time and date
camp.date.hour = math.floor(camp.time / 3600)
camp.date.minute =  math.floor((camp.time / 3600 - camp.date.hour) * 60)


--###################################################################
----- Build METAR -----
--###################################################################


tab_unite = {
	[1] = "imperial",
	[2] = "metric",
	[3] = "russian",
}
tabMetar = {}

for placeName, place in pairs(db_airbases) do
	for i, units in ipairs(tab_unite) do
		
		local METAR = "METAR "

		-- code = {
		-- 	ICAO = "LTAG",
		-- 	other = "IAB",
		-- },

		local name = ""
		if place.code and place.code.other and place.code.other ~= "" then
			name = place.code.other
		elseif place.code and place.code.ICAO and place.code.ICAO ~= "" then
			name = place.code.ICAO
		else
			name = placeName
		end
		METAR = METAR .. name .. " "

		--time and date
		if camp.date.day < 10 then
			METAR = METAR .. "0" .. camp.date.day
		else
			METAR = METAR .. camp.date.day
		end

		--le metar est pris en compte avant le briefing, donc environ 1 à 2h avant
		local timePrepaMinute = math.random(3, 15) *100
		local timePrepa = math.floor((camp.time - 3600 - timePrepaMinute) / 600) * 600   --on arrondi à 10mn

		if timePrepa < 0 then
			timePrepa = 0
		else
			timePrepa = camp.time - 3600 - timePrepaMinute
		end
		--on arrondi (encore) à 10mn pres
		timePrepa = math.floor((timePrepa) / 600) * 600

		local hours = math.floor((timePrepa) / 3600)
		if hours < 10 then
			METAR = METAR .. "0" .. hours
		else
			METAR = METAR .. hours
		end

		local minute = (timePrepa / 3600 - hours) * 60

		if minute < 10 then
			minute = "0" .. minute
		end
		METAR = METAR .. minute .. " "

		--wind
		local direction = mission.weather["wind"]["atGround"]["dir"] - 180
		if direction < 0 then
			direction = direction + 360
		end

		WindDirection = direction													--recupere la vrai direction du vent (aéronautique)

		direction = math.floor(direction / 10) * 10
		if direction < 10 then
			direction = "00" .. direction
		elseif direction < 100 then
			direction = "0" .. direction
		end
		local speed = mission.weather["wind"]["atGround"]["speed"]
		if units == "imperial" then
			speed = math.ceil(speed * 1.94384)
		end
		if speed < 10 then
			speed = "0" .. speed
		end
		-- 33014G26KT
		
		--turbulence or Gust, si la rafale de vent est supérieur à 25% au vent normal
		local gust = ""
		-- if (mission.weather["groundTurbulence"] / 10) > mission.weather["wind"]["atGround"]["speed"] * 1.20 then
		-- 	if units == "imperial" then
		-- 		gust = "G"..math.ceil(mission.weather["groundTurbulence"] * 1.94384)
		-- 	else
		-- 		gust = "G"..mission.weather["groundTurbulence"]
		-- 	end
		-- end 

		if units == "imperial" then
			if mission.weather["wind"]["atGround"]["speed"] == 0 then
				METAR = METAR .. "00000KT "
			else
				METAR = METAR .. direction .. speed .. gust .. "KT "
			end
		else
			if mission.weather["wind"]["atGround"]["speed"] == 0 then
				METAR = METAR .. "00000MPS "
			else
				METAR = METAR .. direction .. speed .. gust .. "MPS "
			end
		end


		--visibility
		if mission.weather["enable_fog"] == true then
			local vis = math.floor(mission.weather["fog"]["visibility"] / 100) * 100
			if vis < 10 then
				vis = "000" .. vis
			elseif vis < 100 then
				vis = "00" .. vis
			elseif vis < 1000 then
				vis = "0" .. vis
			end
			METAR = METAR .. vis .. " " 
		else
			-- if mission.weather["clouds"]["iprecptns"] == 1 then
			-- 	METAR = METAR .. "9999 "
			-- elseif mission.weather["clouds"]["iprecptns"] == 2 then
			-- 	METAR = METAR .. "9999 "
			-- else
			-- 	-- METAR = METAR .. "CAVOK "
			-- end

		end

		--fog
		if mission.weather["enable_fog"] == true then
			METAR = METAR .. "FG "
		end

		--precipitation
		if mission.weather["clouds"]["iprecptns"] == 1 then
			if mission.weather["season"]["temperature"] <= 0 then
				METAR = METAR .. "SN "
			else
				METAR = METAR .. "RA "
			end
		elseif mission.weather["clouds"]["iprecptns"] == 2 then
			METAR = METAR .. "TS "
		elseif not mission.weather["enable_fog"] then
			METAR = METAR .. "NSW "
		end


		--clouds
		local baseIni = mission.weather["clouds"]["base"]

		if place.elevation then
			baseIni = baseIni - place.elevation
		end

		local ceilingMeter = baseIni

		if ceilingMeter < 100 then
			--
		elseif ceilingMeter < 1000 then
			ceilingMeter =  math.floor(ceilingMeter / 100)
		elseif ceilingMeter < 10000 then
			ceilingMeter =  math.floor(ceilingMeter / 100)
		else
			ceilingMeter =  math.floor(ceilingMeter / 100)
		end

		local	ceilingFt = baseIni * 3.28084
		if ceilingFt < 100 then
			--
		elseif ceilingFt < 1000 then
			ceilingFt =  math.floor(ceilingFt / 100)
		elseif ceilingFt < 10000 then
			ceilingFt =  math.floor(ceilingFt / 100)
		else
			ceilingFt =  math.floor(ceilingFt / 100)
		end

		if PresetChoice > 0 then
			local deltaBase = 0 
			for n, layer in ipairs(preset[PresetChoice].layers) do
				if n == 1 then
					deltaBase = (layer.base * 10) - ceilingFt  
				end

				local metarLayer = ""
				if layer.presetMetar  then   --and layer.presetMetar ~= ""
					if n == 1 then
						metarLayer =  ""..layer.presetMetar
					else
						metarLayer =  " "..layer.presetMetar
					end
				end

				local stringBase = math.floor((layer.base * 10) - deltaBase)
				if stringBase < 10 then
					stringBase = "00"..stringBase
				elseif stringBase < 100 then
					stringBase = "0" .. stringBase
				end


				METAR = METAR .. metarLayer..stringBase

			end
		end


		-- SKC : sky clear, aucun nuage (0 octa) ;
		-- FEW : few, quelques nuages, 1/8 à 2/8 du ciel couvert (1 à 2 octas) ;
		-- SCT : scattered, épars, 3/8 à 4/8 du ciel couvert (3 à 4 octas) ;
		-- BKN : broken, fragmenté, 5/8 à 7/8 du ciel couvert (5 à 7 octas) ;
		-- OVC : overcast, couvert, 8/8 du ciel couvert (8 octas) ;


		--*******************************************************************************
		-- Temperature  ********************************************************************
		--*******************************************************************************
		--formule de la temperature, changeant en fonction de l'altitude du TableTransportPilotNames
		--θ(z) = 15 − 6.5 10−3 z
		local airfieldAlti = 0
		if place.elevation then
			airfieldAlti = place.elevation
		end
		local tempCorrected = math.ceil(mission.weather.season.temperature - (0.0065 * airfieldAlti))
	
		-- local tempT = math.abs(mission.weather.season.temperature)
		local tempT = math.abs(tempCorrected)
		if tempT < 10 then
			tempT = "0"..tempT
		end
		if mission.weather.season.temperature < 0 then
			METAR = METAR .. " M" .. tempT 
		else
			METAR = METAR .. " " .. tempT
		end
		
		-- dewPoint = airTemp - ((cloudAltitude/1000) * 2.5) 
		local dewPoint = math.ceil(mission.weather.season.temperature - (((mission.weather.clouds.base * 3.281 )/1000) * 2.5) )
		local tempDewPoint = math.abs(dewPoint)
		if tempDewPoint < 10 then
			tempDewPoint = "0"..tempDewPoint
		end
		if dewPoint < 0 then
			METAR = METAR .. "/M" .. tempDewPoint 
		else
			METAR = METAR .. "/" .. tempDewPoint 
		end

		--*******************************************************************************
		-- Turbulence ********************************************************************
		--*******************************************************************************
		-- Turbulence Layer(s): 6 Digits (5WXXXY)
		-- 	5: first digit of the turbulence group is always a 5.

			-- 	Turbulence type: Second digit:
			-- intensity    ////  Weather Condition  ////Frequency
			--0
			--1 Light
			--2 Moderate     /// Clear     ///      Occasional
			--3 Moderate     /// Clear     ///      Frequent
			--4 Moderate     /// Cloud     ///      Occasional
			--5 Moderate     /// Cloud     ///      Frequent
			--6 Severe       /// Clear     ///      Occasional
			--7 Severe       /// Clear     ///      Frequent
			--8 Severe       /// Cloud     ///      Occasional
			--9 Severe       /// Cloud     ///      Frequent

			local turbulenceInfo = ""
			local turbulDigit = ""
			local turbulValue =  mission.weather["groundTurbulence"] / 10
	
			-- max 60/10 = 6
			--4 valeurs sont retenu, pour 
				-- 0 rien 
				-- 2 Light
				-- 4 Moderate
				-- 6 Severe
	
			if turbulValue <= 0 then   -- rien
				turbulenceInfo = " 5"..0
			elseif turbulValue <= 2 then   -- Light
				turbulenceInfo = " 5"..1
			elseif turbulValue <= 4 then   --Moderate
				if mission.weather.clouds.density == 0 then
					turbulenceInfo = " 5"..3
				else
					turbulenceInfo = " 5"..5
				end
			else 
				if mission.weather.clouds.density == 0 then
					turbulenceInfo = " 5"..7
				else
					turbulenceInfo = " 5"..9
				end
			end
	
			-- no turbulence layer in DCS
			turbulenceInfo = turbulenceInfo .. "000"
	
			-- Turbulence layer’s base: next 3 digits.  (direct reading in 100s of ft/30s meters)
	
			-- 	Thickness of turbulence layer: last digit:
		 
				-- Thickness of Layer
	
				-- 0-- Up to top of cloud			
				-- 1-- 300m/1000’			
				-- 2-- 600m/2000’			
				-- 3-- 900m/2000’			
				-- 4-- 1200m/4000’			
				-- 5-- 1500m/5000’			
				-- 6-- 1800m/6000’			
				-- 7-- 2100m/7000’			
				-- 8-- 2400m/8000’			
				-- 9-- 2700m/9000’
	
				-- no turbulence layer in DCS, but groundTurbulence, maybe 2000ft ^^
			turbulenceInfo = turbulenceInfo .. "2"
			 
			METAR = METAR ..turbulenceInfo

		--QNH
		--le QNH de DCS est en mm d Hg, il faut le transformer pour etre en HPa

		if units == "imperial" then
			local qnh =mission.weather["qnh"] / 25.399999704976

			qnh = tostring(qnh)

			qnh = qnh:sub(1, 2)..qnh:sub(4, 5)

			METAR = METAR .. " A" .. qnh
		elseif units == "metric" then

			local qnh = math.floor(mission.weather["qnh"] / 760 * 1013.25)
			METAR = METAR .. " Q" .. qnh

		else
			local qnh = math.floor(mission.weather["qnh"] )
			METAR = METAR .. " QNH" .. qnh
		end


		--a/Base of lowest cloud layer of 3/8 (or SCT) or more in heights above ground level
		--b/Base of lowest cloud layer of 5/8 (or BKN) or more in heights above ground level

		--						/a					/b
		-- Blue (BLU) 	8 KM 	2500 FT 	10 KM 	1500 FT
		-- White (WHT) 	5000 M 	1500 FT 	5000 M 	1200 FT
		-- Green (GRN) 	3700 M 	700 FT 	4000 M 	600 FT
		-- Yellow 1 (YLO1) 	2500 M 	500 FT 	  	 
		-- Yellow 2 (YLO2) 	1600 M 	300 FT 	  	 
		-- Amber (AMB) 	800 M 	200 FT 	500 M 	200 FT
		-- Red (RED) 	Less than 800 M Below 200 FT or Sky obscuredLess than 500 M Below 200 FT or Sky obscured

		local militaryColor = {
			[1] = {
				alti_ft = 2500,
				alti_m = 762,
				visu_m = 8000,
				color = "BLU",
			},
			[2] = {
				alti_ft = 1500,
				alti_m = 457,
				visu_m = 5000,
				color = "WHT",
			},
			[3] = {
				alti_ft = 700,
				alti_m = 213,
				visu_m = 3700,
				color = "GRN",
			},
			[4] = {
				alti_ft = 500,
				alti_m = 152,
				visu_m = 2500,
				color = "YLO",
			},
			[5] = {
				alti_ft = 200,
				alti_m = 60,
				visu_m = 800,
				color = "AMB",
			},
			[6] = {
				alti_ft = 0,
				alti_m = 0,
				visu_m = 0,
				color = "RED",
			},
			
		}

		local vis = 80000
		if mission.weather["enable_fog"] == true then
			vis = mission.weather["fog"]["visibility"] 
		end
		if preset[PresetChoice] and preset[PresetChoice].visibility and preset[PresetChoice].visibility < vis then
			-- print("DcW PresetChoice "..PresetChoice.." visibility "..preset[PresetChoice].visibility)
			vis =  preset[PresetChoice].visibility
		end

		for n, level in ipairs(militaryColor) do
			-- print("DcW base "..mission.weather.clouds.base.." (baseIni) "..baseIni.." > m? "..level.alti_m)
			-- print("DcW vis "..vis.." > level.visu_m? "..level.visu_m.." level.color? "..level.color)
			if baseIni >= level.alti_m and vis >= level.visu_m  then
				-- print("DcW passe color ")
				METAR = METAR .. " " .. level.color
				break
			end 
		end

		METAR = METAR .. "="
				
		if not tabMetar[placeName] then tabMetar[placeName] = {} end
		tabMetar[placeName][units] = METAR
		
		if debugWeather then
			print("DcW units "..tabMetar[placeName][units])
			if tabMetar[placeName][units] == nil then
				print("DcW placeName "..placeName.." units "..units )
			end
		end

		-- foundSinglePlayer = {
		-- 	place = unit[n].base,
		-- 	type = unit[n].type,
		-- 	FieldElevation = FieldElevation
		-- }

		if not showOne then
			if foundSinglePlayer and foundSinglePlayer.type and foundSinglePlayer.place then
				
				if tabMetar and tabMetar[foundSinglePlayer.place] 
				and data_divers and data_divers[foundSinglePlayer.type] 
				and data_divers[foundSinglePlayer.type].instrumentUnits 
				then
					if  tabMetar[foundSinglePlayer.place][data_divers[foundSinglePlayer.type].instrumentUnits] then
						print("Metar: ".. tostring(tabMetar[foundSinglePlayer.place][data_divers[foundSinglePlayer.type].instrumentUnits]))
						showOne = true
					else
					
					end

				end
			else
				-- print("DcW B not found foundSinglePlayer.type "..tostring(foundSinglePlayer.type).." place "..tostring(foundSinglePlayer.place))
			end		
		end


		moonTxt = ""
		if not showOneNight and string.find(daytime, "night") then
			moonTxt = moonphase(camp.date.day, camp.date.month, camp.date.year)
			showOneNight = true
			-- print(moonTxt)
		end

	end   -- end of unite
end   --end db_airbase

-- if debugWeather then
-- 	print()
-- 	print("---")
-- 	print("DcW camp.weather.zoneTemp "..camp.weather.zone)
-- 	print("DcW camp.weather.zoneNextTemp "..camp.weather.zoneNext)
	
-- 	print("---")
-- 	print()

-- 	_affiche(mission.weather, "DcW mission.weather")
-- 	os.execute 'pause'
-- end

debugTxt = debugTxt .."DcW camp.weather.zoneTemp "..camp.weather.zone.."\n"
debugTxt = debugTxt .."DcW camp.weather.zoneNextTemp "..camp.weather.zoneNext.."\n"

if not camp["debugTraceability"] then 
	camp["debugTraceability"] = {} 
end

if not camp["debugTraceability"]["weather"] then 
	camp["debugTraceability"]["weather"] = "" 
end

camp["debugTraceability"]["weather"] = debugTxt

if debugWeather then
	print(debugTxt)
	os.execute 'pause'
end

print("\nPlease Wait...\n")
