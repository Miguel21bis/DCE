--=======================================================================================
-- ATO_FP_30_Identity.lua  (appelé par ATO_FlightPlan.lua, via Include)
-- Identité des vols : callsigns, sidenumbers, identifiants datalink (L16 / SADL / IDM),
-- TACAN des ravitailleurs, bullseye déplacé.
-- Le code ci-dessous est celui d'origine, inchangé. Les résultats sont donnés à la fin du fichier.
--=======================================================================================

-- Pont avec ATO_FlightPlan.lua (tables partagées, même objet que dans le fichier principal)
local callSignFlight = AtoFP.callSignFlight
local callSignFlightUnite = AtoFP.callSignFlightUnite
local tacan_byTarget = AtoFP.tacan_byTarget
local callSign_west_counter = AtoFP.callSign_west_counter
local callsign_east_counter = 0
--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = =


local function getCallsignWest(category, task, flight_f, flight_n, aircraft_n)
    -- Toute la logique actuelle pour l'ouest ici
    -- Retourne la table callsign attendue par DCS pour l'ouest

	local callsign_flight = 0
	local testCall = ""
	local testCallFlightUnite = ""
	local callsign_nb = 0
	local _name = ""
	local foundCsf = false
	local callsign

	if task == "AWACS" then
		category = "AWACS"
	elseif task == "Refueling" then
		category = "tanker"
	else
		category = "generic"
	end

	if flight_f.target.predeterminedCallsign then

		callsign_flight = flight_f.target.predeterminedCallsign.groupNumber

		if callsign_flight <= 9 then
			callsign_flight = callsign_flight * 10
		end

		local nb_unite

		-- les tanker ne fonctionne pas avec Texaco 4.5
		-- mais Texaco 45.1
		--dans un group de 1, l'unité doit toujours etre à 1
		local ii = 1
		repeat
			nb_unite = math.random(2, 9)
			callsign_flight = callsign_flight + nb_unite
			testCall = Callsign_west[category][callSign_west_counter[category]]..callsign_flight
			testCallFlightUnite = testCall..1
			ii = ii + 1
		until ii > 50 or not callSignFlightUnite[testCallFlightUnite]

		callSignFlight[testCall] = true
		callSignFlightUnite[testCallFlightUnite] = true

		callsign_nb = callSign_west_counter[category]
		_name = Callsign_west[category][callSign_west_counter[category]] .. callsign_flight .. 1

		callsign = {
			[1] = callsign_nb,
			[2] =  callsign_flight,
			[3] =  1,
			name = _name
		}

		-- return callsign


	else

		--M56_b
		--si le callsign à déjà été défini par AssignCallnameSquad() ou oob_air_init
		if flight_f and flight_f["callsign"] and flight_f["callsignId"] then

			if aircraft_n == 1 then

				local ii = 1
				repeat
					callsign_flight = math.random(1, 9)
					testCall = flight_f["callsign"]..callsign_flight
					if not callSignFlight[testCall] then
						callSignFlight[testCall] = true
						flight_f["callsign_flight"] = callsign_flight
						foundCsf = true
						break
					end
					ii = ii + 1
				until ii > 30 or foundCsf

				--si le random non tuilé ne fonctionne pas, tant pis, on prend au pif
				if not foundCsf then
					callsign_flight = math.random(1, 9)
					testCall = flight_f["callsign"]..callsign_flight
					flight_f["callsign_flight"] = callsign_flight
					callSignFlight[testCall] = true
				end
			end

			callsign_flight = flight_f["callsign_flight"]
			callsign_nb = flight_f["callsignId"]
			_name = flight_f["callsign"] .. callsign_flight .. aircraft_n

		else
			if flight_n == 1 and aircraft_n == 1 then
				callSign_west_counter[category] = callSign_west_counter[category] + 1
				if callSign_west_counter[category] > #Callsign_west[category] then
					callSign_west_counter[category] = 1
				end
				callsign_flight = math.random(0, 8)
			end

			if aircraft_n == 1 then
				if not callsign_flight then
					DebugFLIGHT = DebugFLIGHT .. "\nNote for the Campaign Maker: The nation of a previous aircraft misfiled in the table  conf_mod/campMod.WestCallsign or ATO_FlightPlan/country\n"
					DebugFLIGHT = DebugFLIGHT .. "\n"..flight_f.name.. "\n"
				end

				local ii = 1
				repeat
					callsign_flight = math.random(1, 9)

					if not Callsign_west[category] or not callSign_west_counter[category] or not Callsign_west[category][callSign_west_counter[category]] then
						DebugFLIGHT = DebugFLIGHT .. "\nAtoFp Error GetCal..callsign: "..tostring(category).." "..tostring(callSign_west_counter[category])"\n"
					end


					testCall = Callsign_west[category][callSign_west_counter[category]]..callsign_flight
					if not callSignFlight[testCall] then
						callSignFlight[testCall] = true
						foundCsf = true
						break
					end
					ii = ii + 1
				until ii > 100 or foundCsf

				--si le random non tuilé ne fonctionne pas, tant pis, on prend au pif
				if not foundCsf then
					callsign_flight = math.random(1, 9)
					testCall = Callsign_west[category][callSign_west_counter[category]]..callsign_flight
					callSignFlight[testCall] = true
				end

			end

			callsign_nb = callSign_west_counter[category]
			_name = Callsign_west[category][callSign_west_counter[category]] .. callsign_flight .. aircraft_n

		end

		callsign = {
			[1] = callsign_nb,
			[2] =  callsign_flight,
			[3] =  aircraft_n,
			name = _name
		}
	end

	-- print("AtoFP flight_f.name "..tostring(flight_f.name))
	-- _affiche(callsign, "callsign")
    return callsign
end

local function getCallsignEast(aircraft_n)
    -- Toute la logique actuelle pour l'est ici
    -- Retourne le nombre attendu par DCS pour l'est

		if aircraft_n == 1 then
			callsign_east_counter = callsign_east_counter + 1
		end
		local callsign = 90 + callsign_east_counter * 10 + aircraft_n

		-- callsign = {
		-- 	[3] = hundreds,
		-- 	[2] = tens,
		-- 	[1] = ones,
		-- 	name = ""
		-- }

    return callsign
end

local function getCallsign(country, flight_f, task, flight_n, aircraft_n )
	--["callsign"] = getCallsign(flight[f].country, flight[f], flight[f].task, f, n),

    local style = IsWesternCountry(country) and "west" or "east"
    if style == "west" then
        local category = "generic"
        if task == "AWACS" then category = "AWACS"
        elseif task == "Refueling" then category = "tanker" end
        return getCallsignWest(category, task, flight_f, flight_n, aircraft_n)
    else
        return getCallsignEast(aircraft_n)
    end
end


---- function to get sidenumbers -----
local sidenumbers = {}

--découpe un modex en une liste ordonnée de segments : "alpha" (lettres), "digit" (chiffres), "other" (reste)
--ex: "EF180" -> { {type="alpha", value="EF"}, {type="digit", value="180"} }
--ex: "82FS"  -> { {type="digit", value="82"}, {type="alpha", value="FS"} }
---@param str string|number
---@return table[]
local function SplitSegments(str)
	str = tostring(str)
	local segs = {}
	local i, len = 1, #str
	while i <= len do
		local c = str:sub(i, i)
		local j = i
		if c:match("%d") then
			while j <= len and str:sub(j, j):match("%d") do j = j + 1 end
			segs[#segs + 1] = { type = "digit", value = str:sub(i, j - 1) }
		elseif c:match("%a") then
			while j <= len and str:sub(j, j):match("%a") do j = j + 1 end
			segs[#segs + 1] = { type = "alpha", value = str:sub(i, j - 1) }
		else
			while j <= len and not str:sub(j, j):match("%w") do j = j + 1 end
			segs[#segs + 1] = { type = "other", value = str:sub(i, j - 1) }
		end
		i = j
	end
	return segs
end

--vérifie que 2 listes de segments ont la même "forme" (même nombre de segments, mêmes types dans le même ordre)
---@param a table[]
---@param b table[]
---@return boolean
local function SegmentsMatch(a, b)
	if #a ~= #b then return false end
	for i = 1, #a do
		if a[i].type ~= b[i].type then return false end
	end
	return true
end

function GetSidenumber(flight, nUnit)				--not local, also used in DC_StaticAircraft

	local squadron = flight.name
	local lower = flight.sidenumber and flight.sidenumber[1] or nil
	local upper = flight.sidenumber and flight.sidenumber[2] or nil
	local player = flight.player
	local client = flight.client
	local type = flight.type

	local s																			--new sidenumber (chaine finale, ex: "EF182")
	local counter = 0

	if type == "F-4E-45MC" and mission_ini.persistentACFT_TailNb and mission_ini.persistentACFT_TailNb ~= "" then
		if player then
			if nUnit == 1 then
				return mission_ini.persistentACFT_TailNb, mission_ini.persistentACFT_FileNameCache, true
			end
		--utilise ici le fichier Init/persistenceMP.lua s'il existe, pour facilité l'attribution des num tail/avion
		elseif client and PersistenceMP_byTask and PersistenceMP_byTask[flight.task] then
			for clientName, clientData in pairs(PersistenceMP_byTask[flight.task]) do
				if not clientData.assigned and clientData.tailNum then
					clientData.assigned = true
					return tostring(clientData.tailNum), mission_ini.persistentACFT_FileNameCache, true
				end
			end
		end
	end

	if not lower or not upper then												--pas de plage définie, cas normal (aucun sidenumber configuré pour ce squadron)
		s = math.random(1, 99)										--us a random number
		s = string.format("%03d", s)
		return tostring(s)
	end

	local lowerSegs = SplitSegments(lower)
	local upperSegs = SplitSegments(upper)

	if not SegmentsMatch(lowerSegs, upperSegs) then			--lower et upper sont fournis mais de formats incompatibles : véritable erreur de configuration
		AddLog("GetSidenumber() incompatible sidenumber format for squadron "..tostring(squadron)..", lower: "..tostring(lower)..", upper: "..tostring(upper)..", falling back to random number")
		s = math.random(1, 99)
		s = string.format("%03d", s)
		return tostring(s)
	end

	if sidenumbers[squadron] == nil then										--sidenumber squadron entry does not exist
		sidenumbers[squadron] = {}												--create sidenumber squadron entry
	end

	--prépare, pour chaque segment, ses bornes/options ; repère le 1er segment numérique qui varie ("principal")
	local segCount = #lowerSegs
	local mainIndex										---@type integer|nil
	local mainLowerNum, mainUpperNum = 0, 0				--valeurs par defaut ; reecrites plus bas si un segment numerique variable existe, evite tout `nil` implicite
	local segInfo = {}
	for i = 1, segCount do
		local lo, hi = lowerSegs[i].value, upperSegs[i].value
		if lowerSegs[i].type == "digit" then
			local loNum, hiNum = tonumber(lo) or 0, tonumber(hi) or 0		--fallback 0 impossible en pratique (segment déjà validé comme "digit"), juste pour couper l'optionalité aux yeux du LSP
			---@cast loNum integer
			---@cast hiNum integer
			if hiNum < loNum then loNum, hiNum = hiNum, loNum end
			local padWidth = math.max(string.len(lo), string.len(hi))				--supporte plus de 3 chiffres
			segInfo[i] = { type = "digit", loNum = loNum, hiNum = hiNum, padWidth = padWidth }
			if not mainIndex and loNum ~= hiNum then
				mainIndex, mainLowerNum, mainUpperNum = i, loNum, hiNum
			end
		elseif lowerSegs[i].type == "alpha" and lo ~= hi then
			segInfo[i] = { type = "alphaChoice", options = { lo, hi } }			--ex: EF ou EG, tiré au hasard
		else																	--alpha identique entre lower/upper, ou segment "other" : reste fixe
			segInfo[i] = { type = "fixed", value = lo }
		end
	end

	--cherche si le joueur fait partie de cet escadron
	local reservedDigit = 0
	oob_air = oob_air or {}
	for side_name,side in pairs(oob_air) do
		for n,unit in pairs(side) do
			if unit.name == squadron and unit.player then
				reservedDigit = 1												--ajoute un chiffre pour les IA, exemple 200+1 pour l'ia, 200 etant reservé au joueur
			end
		end
	end

	--assemble une chaine à partir d'un tirage pour le segment numérique principal (les autres segments sont tirés/fixés en interne)
	local function BuildString(mainNum)
		local parts = {}
		for i = 1, segCount do
			local info = segInfo[i]
			if info.type == "digit" then
				local n = (i == mainIndex) and mainNum or info.loNum
				parts[i] = string.format("%0"..info.padWidth.."d", n)
			elseif info.type == "alphaChoice" then
				parts[i] = info.options[math.random(1, 2)]
			else
				parts[i] = info.value
			end
		end
		return table.concat(parts)
	end

	local leaderCheck															--on s assure que le num 200 (par exemple) est donné au leader et pas un ailier
	if player and nUnit == 1 then
		s = BuildString(mainIndex and mainLowerNum or nil)
	else
		if mainIndex then
			repeat
				leaderCheck = true
				counter = counter + 1
				local sNum = math.random(mainLowerNum + reservedDigit, mainUpperNum)		--find random sidenumber
				s = BuildString(sNum)

				if nUnit == 1 and sNum % 10 ~= 0 and not sidenumbers[squadron][s] then	--on s assure que le num 200 (par exemple) est donné au leader et pas un ailier
					leaderCheck = false
				end

			until (sidenumbers[squadron][s] == nil and leaderCheck) or counter == 100	--repeat until a sidenumber is found that is not yet in squadron use or stop after 100 tries
		else
			--pas de segment numérique variable (seules les lettres varient, ou modex totalement fixe)
			repeat
				counter = counter + 1
				s = BuildString(nil)
			until sidenumbers[squadron][s] == nil or counter == 100
		end

		--le script n'a pas trouvé de serial non libre : recherche linéaire du premier combo encore libre
		if counter >= 100 then
			local loN = mainIndex and mainLowerNum or 0
			local hiN = mainIndex and mainUpperNum or 0
			for n = loN, hiN do
				local candidate = BuildString(n)
				if sidenumbers[squadron][candidate] == nil then
					s = candidate
					break
				end
			end
		end
	end

	if s and s ~= nil then
		sidenumbers[squadron][s] = true													--mark sidenumber in use for squadron
	end

	-- particularité du Harrier : donner 810 pour afficher 18 (ne s'applique qu'à la partie numérique)
	if type == "AV8BNA" then
		local numOnly = s:match("%d+") or s
		local Digit_1 = string.sub(numOnly, -1, -1)
		local Digit_2 = string.sub(numOnly, -2, -2)
		local n2 = tonumber(Digit_1..Digit_2.."0")
		s = string.format("%03d", n2)
	end

	return tostring(s)															--return sidenumber as string
end


---- function to get datalink Id -----
local pack_L16_unitId = {}		--permet de retrouver tous les unitId participant à un package
local STN_L16_Id = {}
local pack_SADL_unitId = {}		--permet de retrouver tous les unitId participant à un package
local SADL_TN_Id = {}
local pack_IDM_unitId = {}
local IDM_Id = {}


local function Get_L16_Id()
	local i = 0
	local preTest = "002"
	local testId = "00001"

	repeat
		i=i+1
		local digit4 = math.random(0,7)
		local digit5 = math.random(0,7)

		testId = preTest..digit4..digit5

	until STN_L16_Id[testId] == nil or i >= 300

	if i >= 300 then
		preTest = "003"
		repeat
			i=i+1
			-- local digit1 = math.random(0,7)
			-- local digit2 = math.random(0,7)
			-- local digit3 = math.random(0,7)
			local digit4 = math.random(0,7)
			local digit5 = math.random(0,7)

			testId = preTest..digit4..digit5

		until STN_L16_Id[testId] == nil 	or i >= 600
	end

	if i >= 600 then
		preTest = "00"
		repeat
			i=i+1
			-- local digit1 = math.random(0,7)
			-- local digit2 = math.random(0,7)
			local digit3 = math.random(0,7)
			local digit4 = math.random(0,7)
			local digit5 = math.random(0,7)

			testId = preTest..digit3..digit4..digit5

		until STN_L16_Id[testId] == nil 	or i >= 900
	end

	STN_L16_Id[testId] = true

	if i >= 400 then
		DebugFLIGHT = DebugFLIGHT .. "\n".." AtoFP Get_L16_Id trop long "..i.." test "..testId
	end

	return testId
end

--spécial datalink A-10
local function Get_SADL_Id()
	local i = 0
	local preTest = "01"
	local testId = "0001"

	repeat
		i=i+1
		local digit3 = math.random(0,7)
		local digit4 = math.random(0,7)

		testId = preTest..digit3..digit4

	until SADL_TN_Id[testId] == nil or i >= 300


	if i >= 200 then
		DebugFLIGHT = DebugFLIGHT .. "\n".." AtoFP Get_SADL_Id trop long "..i.." test "..testId
	end

	return testId
end


--spécial datalink AH-64
local function get_IDM_Id()
	local i = 0

	local testId = "1"

	repeat
		i=i+1
		local digit1 = math.random(1,39)

		testId = tostring(digit1)

	until IDM_Id[testId] == nil or i >= 300

	if i >= 200 then
		DebugFLIGHT = DebugFLIGHT .. "\n".."AtoFP IDM_Id trop long "..i.." test "..testId
	end

	return testId
end

-- --liste toutes les Fréquences déjà existantes pour ne pas creer de doublon
-- for basename, base in pairs(db_airbases) do
-- 	if base.ATC_frequency and base.ATC_frequency ~= "" and type(base.ATC_frequency)~= "table" then
-- 		Assigned_freq[tonumber(base.ATC_frequency)] = basename
-- 	elseif base.ATC_frequency and type(base.ATC_frequency)== "table" then
-- 		for n , freq in ipairs(base.ATC_frequency) do
-- 			Assigned_freq[tonumber(freq)] = basename
-- 		end
-- 	else
-- 		-- _affiche(base.ATC_frequency, "AA base.ATC_frequency") 
-- 	end
-- end


---- function to assign A-A TACAN channels ----
local channel_tacan = {}																--table to store tanker TACAN channels
-- https://forums.eagle.ru/showpost.php?p=3821502&postcount=139
-- https://forums.eagle.ru/topic/199994-tacan-and-dl-last-update/
-- 37-67  ??.?

--liste tous les TACAN déjà existant pour ne pas creer de doublon
for basename, base in pairs(db_airbases) do															--iterate through airbases
	if base.TACAN then
		local tacanClean = base.TACAN
		local channel = 0
		local one, two
		if string.find(base.TACAN, "/") then
			one, two = tacanClean:match("([^,]+)/([^,]+)")
			tacanClean = one:gsub( " ", "")
		elseif string.find(base.TACAN, "-") then
			one, two = tacanClean:match("([^,]+)-([^,]+)")
			tacanClean = one:gsub( " ", "")
		end

		local test = string.sub(base.TACAN, 1, #tacanClean - 1)

		if test and test ~= nil then
			local channel_num = tonumber(test)
			if channel_num then
				channel = channel_num
			end
		end
		channel_tacan[channel] = true

	end
end


local function getTankerTACAN(tarnetName)

	local channel

	if tacan_byTarget[tarnetName] then
		return tacan_byTarget[tarnetName]
	end

	repeat
		-- channel = math.random(37, 67)											--find random TACAN channel
		channel = math.random(1, 63)
	until channel_tacan[channel] == nil											--repeat until channel is found that is not in use yet

	channel_tacan[channel] = tarnetName												--mark channel in use
	tacan_byTarget[tarnetName] = channel

	return channel																--return channel
end


local function fct_movedBullseye(arg_Side, arg_NameTheatre)

    local tempArrayBulls = {}
    local tempBullseye =
    {
        x = 0,
        y = 0,
        name = "",
    }

    if not mission_ini.movedBullseye then
        for name, base in pairs(db_airbases) do
            if base.x and not base.unitname and base.side == arg_Side then
                if base.selectedBullseye then
                    tempBullseye.x = base.x
                    tempBullseye.y = base.y
                    tempBullseye.name = name
                end
            end
        end
    else

        --resout la zone a utiliser : override campaignMaker si actif, sinon la valeur par defaut de la carte
        local zone
        if campMod.bullseyeZoneOverride and campMod.bullseyeZoneOverride.enabled then
            zone = {
                pos   = { x = campMod.bullseyeZoneOverride.x, y = campMod.bullseyeZoneOverride.y },
                rayon = campMod.bullseyeZoneOverride.rayon,
            }
        else
            zone = BullseyeZone[arg_NameTheatre]
        end

        for baseName, base in pairs(db_airbases) do
            if base.x and not base.unitname then
                if GetDistance(zone.pos, base) <= (zone.rayon * 1000) then
                    db_airbases[baseName]["name"] = baseName
                    table.insert(tempArrayBulls, db_airbases[baseName])
                end
            end
        end

        local i = #tempArrayBulls

        if i >= 1 then
            local j = math.random(1, i)
            tempBullseye.x = tempArrayBulls[j].x
            tempBullseye.y = tempArrayBulls[j].y
            tempBullseye.name = tempArrayBulls[j].name
        end
    end

    if tempBullseye.name ~= "" and tempBullseye.x ~= 0 then
        --ajoute bullseye dans mission
        mission.coalition[arg_Side].bullseye.x = tempBullseye.x
        mission.coalition[arg_Side].bullseye.y = tempBullseye.y

        --ajoute bullseye dans briefing
        if not Brief[arg_Side].bullseye then Brief[arg_Side].bullseye = {} end
        Brief[arg_Side].bullseye.name = tempBullseye.name
        Brief[arg_Side].bullseye.x = tempBullseye.x
        Brief[arg_Side].bullseye.y = tempBullseye.y

        if LL_PositionsFileExit then

            local xKey = math.abs(math.floor(tempBullseye.x))
            if LL_Positions[xKey] then
                local testX = math.floor(Brief[arg_Side].bullseye.x)
                local testY = math.floor(Brief[arg_Side].bullseye.y)
                for n, llPos in pairs(LL_Positions[xKey] ) do
                    if testX == llPos.x and testY == llPos.y then
                        Brief[arg_Side].bullseye.lat = llPos.lat
                        Brief[arg_Side].bullseye.lon = llPos.lon
                        break
                    end
                end
            end
        end
    end

    return mission.coalition[arg_Side].bullseye, Brief[arg_Side].bullseye

end

--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = =
-- Ce que ce fichier rend à ATO_FlightPlan.lua
AtoFP.getCallsign = getCallsign
AtoFP.pack_L16_unitId = pack_L16_unitId
AtoFP.pack_SADL_unitId = pack_SADL_unitId
AtoFP.pack_IDM_unitId = pack_IDM_unitId
AtoFP.Get_L16_Id = Get_L16_Id
AtoFP.Get_SADL_Id = Get_SADL_Id
AtoFP.get_IDM_Id = get_IDM_Id
AtoFP.getTankerTACAN = getTankerTACAN
AtoFP.fct_movedBullseye = fct_movedBullseye
