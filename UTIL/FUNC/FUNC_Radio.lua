

MODULATION_AM = "AM"
MODULATION_AM_AND_FM = "AM/FM"
MODULATION_FM = "FM"
RadioPlayerWaveRanges = {}

AssignedTargetFrequency = {
	["blue"] = {},
	["red"] = {},
}

RADIO_WAVES = {
	HF =       { min =   3.0, max =  30.0 },
	LVHF =   { min =  30.0, max =  88.0 },
	VHF =   { min = 108.0, max = 174.0 },
	UHF =      { min = 225.0, max = 400.0 },
}


-- pour information, voici les plages utilisées en aéronautique (les valeurs fluctuent en fonction des organisations):
-- UHF 	: superieur à 225 Mhz	(Ultra Haute Frequence)
-- VHF 	: 100 à 225 Mhz			(Very Haute Frequence)
-- LVHF 	: 20 à 100 Mhz			(Low VHF, trompeusement dénommé FM, FM et AM sont des modulations de freq ou d'amplitude) (Occidental)
-- HF 		: 1 à 10 Mhz 			(Haute Fréquence)(Russe)
local waveRef = {
	["UHF"] = {
		min = 225,
		max = 400,
	},
	["VHF"] = {
		min = 100,
		max = 225,
	},
	["LVHF"] = {
		min = 20,
		max = 100,
	},
	["HF"] = {
		min = 1,
		max = 10,
	},
}

-- Retourne le nom de bande (UHF/VHF/LVHF/HF) contenant la frequence donnee,
-- ou nil si elle ne correspond a aucune des 4 bandes de reference (waveRef).
function BandOfFrequency(freq)
	freq = tonumber(freq)
	if not freq then return nil end
	for waveName, wave in pairs(waveRef) do
		if freq >= wave.min and freq <= wave.max then
			return waveName
		end
	end
	return nil
end

local EmergencyFreq = {
    [121.5] = true,
    [243.0] = true,
}
local waveDefinitions = {
    UHF  = { min = 225, max = 399.95 },
    VHF  = { min = 116, max = 149.975 },
    HF   = { min = 3,   max = 17.999 },
    LVHF = { min = 30,  max = 75.95 },
}

WavePriority = {
	blue = {
		plane = { "UHF", "VHF", "LVHF", "HF" },
		helicopter = {  "LVHF", "VHF", "UHF", "HF", }
	},
	red = {
		plane = {  "VHF", "UHF", "HF", "LVHF" },
		helicopter = {  "LVHF", "VHF", "UHF", "HF", }
	}
}

local specialTasks = {
    EWR = true,
    AWACS = true,
    Refueling = true,
    AFAC = true,
	player = true,
	playerInPackage = true,
}

--*******************************************************
----------------------------------------------------------------
-- Calcul Range Radio NG
----------------------------------------------------------------
----------------------------------------------------------------
-- DCE - Common Radio Frequency Finder
-- Lua 5.1 compatible
----------------------------------------------------------------


local function intersectRange(a, b)


	local function modulationCompatible(m1, m2)
		if m1 == m2 then return true end
		if m1 == MODULATION_AM_AND_FM then return true end
		if m2 == MODULATION_AM_AND_FM then return true end
		return false
	end

	if not modulationCompatible(a.modulation, b.modulation) then
		return nil
	end

	local minF = math.max(a.min, b.min)
	local maxF = math.min(a.max, b.max)

	if minF < maxF then
		return {
			min = minF,
			max = maxF,
			modulation = (a.modulation == b.modulation) and a.modulation or MODULATION_AM_AND_FM
		}
	end

	return nil
end


local function intersect(a,b)
	local min = math.max(a.min, b.min)
	local max = math.min(a.max, b.max)
	if max > min then
		return { min = min, max = max }
	end
	end

local function findBestCommonRange(ranges)

	if type(ranges) ~= "table" or #ranges == 0 then
		return nil
	end

	local best, bestScore = nil, 0

	for i,candidate in ipairs(ranges) do
		local score = 0
		local current = candidate

		for _,r in ipairs(ranges) do
			local inter = intersect(current, r)
			if inter then
				current = inter
				score = score + 1
			end
		end

		if score > bestScore then
			bestScore = score
			best = current
		end
	end

	return best
end

local function simplifyRadioRanges(moduleData, isPlayer)

	-- if isPlayer then print("simplifyRadioRanges called for moduleData isPlayer=? "..tostring(isPlayer)) end

	if type(moduleData) ~= "table" then
		print("return A no moduleData table")
		return {}
	end

	------------------------------------------------
	-- 1) Collecte brute de toutes les plages
	------------------------------------------------
	local rawRanges = {}

	local function addRange(min, max)

		-- if isPlayer then print("SRR addRange() A1 "..tostring(min).." - "..tostring(max)) end

		if type(min) == "number" and type(max) == "number" and max > min then
			-- if isPlayer then print("addRange() A2 valid range") end
			table.insert(rawRanges, { min = min, max = max })
		end
	end

	-- HumanRadio
	local hr = moduleData.HumanRadio
	if type(hr) == "table" then
		if type(hr.rangeFrequency) == "table" and hr.rangeFrequency[1] then
			-- forme limitative
			for _,r in ipairs(hr.rangeFrequency) do
				-- if isPlayer then print("SRR addRange() B1sub-range "..tostring(r.min).." - "..tostring(r.max)) end
				addRange(r.min, r.max)
			end
		elseif hr.minFrequency and hr.maxFrequency then
			-- if isPlayer then print("SRR addRange() B2 minFrequency "..tostring(hr.minFrequency).." - "..tostring(hr.maxFrequency)) end
			addRange(hr.minFrequency, hr.maxFrequency)
		end
	end

	-- PanelRadio
	local pr = moduleData.panelRadio
	if type(pr) == "table" then
		-- if isPlayer then _affiche(pr, "pr: ") end

		for _,radio in pairs(pr) do
			-- if isPlayer then print("SRR addRange() C _ ".._) _affiche(radio, "radio: ") end

			if type(radio.range) == "table" then
				for _, rangeData in ipairs(radio.range) do
					-- if isPlayer then print("SRR addRange() D panelRadio "..tostring(rangeData.min).." - "..tostring(rangeData.max)) end
					addRange(rangeData.min, rangeData.max)
				end
			end
		end
	end

	if #rawRanges == 0 then
		-- if isPlayer then print("SRR return E no rawRanges collected") end
		return {}
	end

	------------------------------------------------
	-- 2) CAS NON JOUEUR → UNION GLOBALE
	------------------------------------------------
	if not isPlayer then
		table.sort(rawRanges, function(a,b) return a.min < b.min end)

		local EPSILON = 0.01
		local simplified = {}
		local current = rawRanges[1]

		for i = 2, #rawRanges do
			local r = rawRanges[i]
			if r.min <= current.max + EPSILON then
				current.max = math.max(current.max, r.max)
			else
				table.insert(simplified, current)
				current = r
			end
		end

		table.insert(simplified, current)
		-- print("SRR return F simplified non-player ranges")
		return simplified
	end

	------------------------------------------------
	-- 3) CAS JOUEUR → UNE PLAGE PAR BANDE
	------------------------------------------------
	-- CORRECTIF : l'ancienne version ne gardait que LA plage la plus etroite
	-- toutes bandes confondues (souvent LVHF/HF, naturellement plus etroites
	-- qu'une plage UHF), ce qui rendait wavePriority/WavePriority inoperant :
	-- RadioPlayerWaveRanges ne contenait alors jamais d'entree UHF/VHF a
	-- proposer, la "bande gagnante" etait choisie par largeur de radio et non
	-- par priorite occidental/russe/helico.
	-- On garde desormais UNE plage par bande (RADIO_WAVES = UHF/VHF/LVHF/HF),
	-- la plus etroite au sein de chaque bande, pour que getRangesForContext()
	-- ait vraiment un choix a faire entre bandes.
	local bestByWave = {}

	for _, r in ipairs(rawRanges) do
		local width = r.max - r.min
		for waveName, waveDef in pairs(RADIO_WAVES) do
			if r.max >= waveDef.min and r.min <= waveDef.max then
				local inter = intersect(r, waveDef) or r
				if not bestByWave[waveName] or width < bestByWave[waveName].width then
					bestByWave[waveName] = { min = inter.min, max = inter.max, width = width }
				end
			end
		end
	end

	local perWave = {}
	for _, r in pairs(bestByWave) do
		perWave[#perWave + 1] = { min = r.min, max = r.max }
	end

	if #perWave > 0 then
		-- if isPlayer then print("SRR return H "..tostring(#perWave).." plage(s) par bande") end
		return perWave
	end

	-- if isPlayer then print("return Z no per-wave player range") end
	return {}

end



local function ComputeCommonRangesForModules(moduleList)

	local common = nil

	for moduleName,_ in pairs(moduleList) do
		local data = Db_Frequency[moduleName]
		if data then
			-- print("moduleName CCRFmodules() "..moduleName.." has data")
			local ranges = simplifyRadioRanges(data)
			-- ignorer modules vides (OH-6, data pas prête)
			if ranges[1] then
				if not common then
					common = DeepCopy(ranges)
				else
					local newCommon = {}
					for _,c in ipairs(common) do
						for _,r in ipairs(ranges) do
							local inter = intersectRange(c, r)
							if inter then
								table.insert(newCommon, inter)
							end
						end
					end
					common = newCommon
				end
			end
		end
	end

	return common or {}
end



----------------------------------------------------------------
-- main function
----------------------------------------------------------------
---	CurrentPlayerAircraftType = nil
function DCE_FindRadioCommonWaves()

	local result = {
		blue = {},
		red  = {},
	}

	for side,modules in pairs(AircraftCampaignBySide) do

		for waveName, wave in pairs(RADIO_WAVES) do

			-- local common = nil
			--**
			local common = nil
			local validModuleCount = 0

			-- 🔹 CONTRAINTE JOUEUR
			local playerData = Db_Frequency[CurrentPlayerAircraftType]
			local playerInWave = nil

			if playerData then
				local playerRanges = simplifyRadioRanges(playerData)
				playerInWave = {}

				for _, r in ipairs(playerRanges) do
					local inter = intersect(r, wave)
					if inter then
						playerInWave[#playerInWave+1] = inter
					end
				end

				-- si le joueur ne supporte pas la wave → on neutralise
				if not playerInWave[1] then
					playerInWave = false
				else
					common = DeepCopy(playerInWave)
				end
			end
			--**
			-- local validModuleCount = 0

			if playerInWave == false then
				-- le joueur ne supporte pas cette wave → on skip
			else

				for moduleName,_ in pairs(modules) do

					local moduleData = Db_Frequency[moduleName]
					if moduleData then
						-- print("moduleName DCE_FRC() "..moduleName)
						local ranges = simplifyRadioRanges(moduleData)
						local inWave = {}

						for _,r in ipairs(ranges) do
							local inter = intersect(r, wave)
							if inter then
								table.insert(inWave, inter)
							end
						end

						-- ce module participe à la wave
						if inWave[1] then
							validModuleCount = validModuleCount + 1
							if not common then
								common = DeepCopy(inWave)
							else
								local newCommon = {}

								for _,c in ipairs(common) do
									for _,m in ipairs(inWave) do
										local inter2 = intersect(c, m)
										if inter2 then
											table.insert(newCommon, inter2)
										end
									end
								end

								-- intersection impossible
								if not newCommon[1] then
									common = nil
									break
								end

								common = newCommon
							end
							-- _affiche(common, "common : ")
						end
					else
						-- if Data_divers[moduleName] and Data_divers[moduleName].playable then
						-- 	print("DCE_FindRadioCommonWaves D no Data_divers for module "..moduleName)
						-- 	os.execute("pause")
						-- end

					end
				end
			end

			-- décision finale
			-- if common and validModuleCount >= 1 then
			if common and playerInWave ~= false and validModuleCount >= 1 then
				result[side][waveName] = findBestCommonRange(common)
			end
		end

	end

	return result
end

function Make_Db_Frequency()

	--ajoute à la table Db_Frequency les data radio qui sont dans Data_divers
	--ne l'ajoute pas si les tables radio sont déjà ajouté dans Db_Frequency
	for moduleName, moduleData in pairs(Data_divers) do
		
		-- if string.find(moduleName, "F-14") then
		-- 	print("Make_Db_Frequency A processing module "..moduleName)
		-- 	_affiche(moduleData, "moduleData: ")
		-- end
		local addRadioData = false

		Db_Frequency[moduleName] = Db_Frequency[moduleName] or {}
		
		if moduleData.HumanRadio then
			Db_Frequency[moduleName].HumanRadio = moduleData.HumanRadio
			addRadioData = true
		end

		if moduleData.panelRadio then
			Db_Frequency[moduleName].panelRadio = moduleData.panelRadio
			addRadioData = true
		end

		if not addRadioData then
			
			HumanRadio = {
				frequency = 127.5, -- Radio Freq
				editable = true,
				minFrequency = 100.000,
				maxFrequency = 156.000,
				modulation = MODULATION_AM
			}

			Db_Frequency[moduleName].HumanRadio = HumanRadio

		end
	end

	-- local camp_str = "Db_Frequency = " .. TableSerialization(Db_Frequency, 0)						--make a string
	-- local campFile = io.open("Debug/Z1_Radio_Db_Frequency.lua", "w")	 or error("Failed to open debug file")
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()
end

function DCE_FindCommonRadioRanges()
	-- mutualisation panelRadio + HumanRadio
	for moduleName, dataRadio in pairs(Db_Frequency) do

		dataRadio.radio = {}

		------------------------------------------------------------------
		-- 1) panelRadio
		------------------------------------------------------------------
		if dataRadio.panelRadio then
			for radioN, radioData in pairs(dataRadio.panelRadio) do

				local ranges = {}

				--transforme cette partie range de la meme maniere pour tout le monde:
				if radioData.range then
					-- Check if range is already an array or a single range object
					if radioData.range.min and not radioData.range[1] then
						-- Single range object: convert to array format
						local copyRange = DeepCopy(radioData.range)
						radioData.range = {
							[1] = {
								min = copyRange.min,
								max = copyRange.max,
							}
						}
					end
					-- If already an array, leave it as-is
				end

				if radioData.range then
					for _, r in ipairs(radioData.range) do
						ranges[#ranges + 1] = {
							min = r.min,
							max = r.max,
						}
					end
				end

				dataRadio.radio[#dataRadio.radio + 1] = {
					name     = radioData.name or ("panelRadio_" .. tostring(radioN)),
					nbCanal  = radioData.channels and #radioData.channels or 0,
					range    = ranges,
					source   = "panelRadio",
				}
			end
		end
	end

		------------------------------------------------------------------
		-- 2) HumanRadio
		------------------------------------------------------------------
	for moduleName, dataRadio in pairs(Db_Frequency) do
		-- print("DCE_FindCommonRadioRanges A processing module "..moduleName)
		if dataRadio.HumanRadio then

			local hrMin = dataRadio.HumanRadio.minFrequency
			local hrMax = dataRadio.HumanRadio.maxFrequency
			-- print("DCE_FindCommonRadioRanges B HumanRadio for module "..moduleName.." range "..tostring(hrMin).." - "..tostring(hrMax))

			if hrMin and hrMax then
				-- print("DCE_FindCommonRadioRanges C adding HumanRadio for module "..moduleName.." range "..tostring(hrMin).." - "..tostring(hrMax))

				for waveName, wave in pairs(RADIO_WAVES) do
					-- print("DCE_FindCommonRadioRanges D checking wave "..waveName.." range "..tostring(wave.min).." - "..tostring(wave.max))

					-- test d'intersection HumanRadio ↔ wave
					if hrMax >= wave.min and hrMin <= wave.max then
						-- print("DCE_FindCommonRadioRanges E wave "..waveName.." is intersecting HumanRadio for module "..moduleName)

						-- vérifier si cette wave est déjà couverte par panelRadio
						local waveAlreadyCovered = false

						for _, radio in ipairs(dataRadio.radio) do
							-- print("DCE_FindCommonRadioRanges F checking existing radio "..tostring(radio.name).." for module "..moduleName)
							if radio.range then
								-- print("DCE_FindCommonRadioRanges G radio "..tostring(radio.name).." has range for module "..moduleName)

								-- if #radio.range and #radio.range >= 1 then
									for _, r in ipairs(radio.range) do
										-- print("DCE_FindCommonRadioRanges H checking range "..tostring(r.min).." - "..tostring(r.max).." of radio "..tostring(radio.name).." for module "..moduleName)
										if r.max >= wave.min and r.min <= wave.max then
											-- print("DCE_FindCommonRadioRanges I1 wave "..waveName.." is already covered by radio "..tostring(radio.name).." for module "..moduleName)
											waveAlreadyCovered = true
											break
										end
									end
								-- else
								-- 	local r = radio.range
								-- 	if r.max >= wave.min and r.min <= wave.max then
								-- 		print("DCE_FindCommonRadioRanges I2 wave "..waveName.." is already covered by radio "..tostring(radio.name).." for module "..moduleName)
								-- 		waveAlreadyCovered = true
								-- 		break
								-- 	end
								-- end
							end
							if waveAlreadyCovered then break end
						end

						-- si pas couverte → ajouter radio Human
						if not waveAlreadyCovered then
							-- print("DCE_FindCommonRadioRanges J adding HumanRadio wave "..waveName.." for module "..moduleName)

							-- intersection utile (le plus restrictif)
							local minFreq = math.max(hrMin, wave.min)
							local maxFreq = math.min(hrMax, wave.max)

							dataRadio.radio[#dataRadio.radio + 1] = {
								name    = "HumanRadio_" .. waveName,
								nbCanal = 0,
								range   = {
									{
										min = minFreq,
										max = maxFreq,
									},
								},
								source  = "HumanRadio",
							}
						end
					end
				end
			end
		else
			if not dataRadio.radio or #dataRadio.radio < 1 then
				dataRadio.radio[1] = {
					name    = "defautRadio_VHF",
					nbCanal = 0,
					range   = {
						{
							min = RADIO_WAVES["VHF"].min,
							max = RADIO_WAVES["VHF"].max,
						},
					},
					source  = "default",
				}
			end
		end
	end



	-- local camp_str = "Db_Frequency = " .. TableSerialization(Db_Frequency, 0)						--make a string
	-- local campFile = io.open("Debug/Radio_Db_Frequency.lua", "w")	 or error("Failed to open debug file")
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()


	local function intersectRangeFreqOnly(a, b)
		local minF = math.max(a.min, b.min)
		local maxF = math.min(a.max, b.max)

		if minF < maxF then
			return { min = minF, max = maxF }
		end

		return nil
	end

	--initie les waves de frequences
	RadioWaveCommon = DCE_FindRadioCommonWaves()

	-- camp_str = "RadioWaveCommon = " .. TableSerialization(RadioWaveCommon, 0)						--make a string
	-- campFile = io.open("Debug/Radio_RadioWaveCommon_.lua", "w")	 or error("Failed to open debug file")
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()


	------------------------------------------------
	-- 1. Find player aircraft type
	------------------------------------------------
	-- CurrentPlayerAircraftType = nil

	for moduleName, value in pairs(AircraftInCampaign) do
		if value == "player" then
			CurrentPlayerAircraftType = moduleName
			break
		end
	end

	if not CurrentPlayerAircraftType then
		-- print("DCE_FindRadioCommonRG ERROR: no player aircraft found")
		return { red = {}, blue = {} }
	end

	------------------------------------------------
	-- 2. Get player ranges (REFERENCE)
	------------------------------------------------
	local playerData = Db_Frequency[CurrentPlayerAircraftType]
	-- print("DCE_FindRadioCommonRG player module data: "..CurrentPlayerAircraftType)

	RadioPlayerWaveRanges = simplifyRadioRanges(playerData, true)

	if Debug.debug then
		local camp_str = "RadioPlayerWaveRanges = " .. TableSerialization(RadioPlayerWaveRanges, 0)						--make a string
		local campFile = io.open("Debug/RadioPlayerWaveRanges_"..CurrentPlayerAircraftType..".lua", "w")	 or error("Failed to open debug file")
		campFile:write(camp_str)																		--save new data
		campFile:close()
	end
	if not RadioPlayerWaveRanges or not RadioPlayerWaveRanges[1] then
		-- print("DCE_FindRadioCommonRG WARNING: player has no radio data")
		return { red = {}, blue = {} }
	end

	------------------------------------------------
	-- 3. Determine player side
	------------------------------------------------
	local playerSide = nil
	if AircraftCampaignBySide.red and AircraftCampaignBySide.red[CurrentPlayerAircraftType] then
		playerSide = "red"
	elseif AircraftCampaignBySide.blue and AircraftCampaignBySide.blue[CurrentPlayerAircraftType] then
		playerSide = "blue"
	end

	if not playerSide then
		return { red = {}, blue = {} }
	end

	------------------------------------------------
	-- 4. Start with player ranges
	------------------------------------------------
	local commonRanges = {
		red  = {},
		blue = {},
	}

	commonRanges[playerSide] = DeepCopy(RadioPlayerWaveRanges)

	------------------------------------------------
	-- 5. Intersect ONLY with other modules of same side
	------------------------------------------------
	for moduleName, moduleData in pairs(Db_Frequency) do

		if moduleName ~= CurrentPlayerAircraftType then

			-- same side only
			if AircraftCampaignBySide[playerSide] and AircraftCampaignBySide[playerSide][moduleName] then

				-- print("DCE_FindRadioCommonRG checking module "..moduleName.." for side "..playerSide)
				local moduleRanges = simplifyRadioRanges(moduleData)

					-- camp_str = "moduleRanges = " .. TableSerialization(moduleRanges, 0)						--make a string
					-- campFile = io.open("Debug/RadioRangeModule_"..moduleName..".lua", "w")	 or error("Failed to open debug file")
					-- campFile:write(camp_str)																		--save new data
					-- campFile:close()

				-- IGNORE modules without radio data
				if moduleRanges and moduleRanges[1] then

					local newCommon = {}

					for _,c in ipairs(commonRanges[playerSide]) do
						for _,m in ipairs(moduleRanges) do
							local inter = intersectRangeFreqOnly(c, m)
							if inter then
								-- _affiche(inter, "inter: ")
								table.insert(newCommon, inter)
							end
						end
					end

					-- only reduce if something matched
					if newCommon[1] then
						commonRanges[playerSide] = newCommon
					else
						-- print("DCE_FindRadioCommonRG: no compatible ranges with "..moduleName..", ignored")
					end
				else
					-- print("DCE_FindRadioCommonRG: module "..moduleName.." has no radio data, ignored")
				end
			end
		end
	end

	local function UnionRanges(a, b)
		local all = {}
		for _,r in ipairs(a) do table.insert(all, r) end
		for _,r in ipairs(b) do table.insert(all, r) end
		return simplifyRadioRanges(all)
	end

	local eniSide = DCS_ENI_Side[SidePlayer]

	local heliRanges  = ComputeCommonRangesForModules(HelicoBySide[eniSide])
	local planeRanges = ComputeCommonRangesForModules(PlaneBySide[eniSide])

	commonRanges[eniSide] = UnionRanges(heliRanges, planeRanges)

	-- _affiche(commonRanges, "commonRanges: ")

	return commonRanges
end

----------------------------------------------------------------
-- FIN FIN Calcul Range Radio NG FIN
----------------------------------------------------------------
---
---
--- --assigne les fréquences aux bases
function AssignedFrequencies()
	Assigned_freq = {}

	--liste toutes les Fréquences déjà existantes pour ne pas creer de doublon
	for basename, base in pairs(db_airbases) do
		if base.ATC_frequency and base.ATC_frequency ~= "" and type(base.ATC_frequency)~= "table" then
			Assigned_freq[tonumber(base.ATC_frequency)] = basename
		elseif base.ATC_frequency and type(base.ATC_frequency)== "table" then
			for n , freq in ipairs(base.ATC_frequency) do
				Assigned_freq[tonumber(freq)] = basename
			end
		else
			if Debug.debug then
				print("BUG whith AssignedFrequencies():")
				_affiche(base.ATC_frequency, "AA base.ATC_frequency: ") 
			end
		end
	end

	-- camp_str = "Assigned_freq = " .. TableSerialization(Assigned_freq, 0)						--make a string
	-- campFile = io.open("Debug/RADIO_Assigned_freq.lua", "w")  or error("Failed to open debug file")
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()

	-- print("AssignedFrequencies()")
	-- os.execute 'pause'
end






-------------------------------------------------------------------
-- START Get Frequency NG
----------------------------------------------------------------




local function rangeIntersectsWave(range, wave)
    local waveDef = RADIO_WAVES[wave]
    if not waveDef then
        return false
    end

    return range.max >= waveDef.min
       and range.min <= waveDef.max
end


local function getRangesForContext(side, task, type_withData, flightOrPackage)
	-- print()
    -- print("getRangesForContext A called for side "..tostring(side).." task "..tostring(task).." type_withData "..tostring(type_withData).." flightOrPackage "..tostring(flightOrPackage))
	-- cas spécial : réseaux commandement joueur

	if specialTasks[task] and side == PlayerSide and (not type_withData or not IsHelicopter[type_withData]) then
		if not IsHelicopter[type_withData] then
			for _, wave in ipairs(WavePriority[side].plane) do
				for n, dataFreq in ipairs(RadioPlayerWaveRanges or {}) do
					if rangeIntersectsWave(dataFreq, wave) then
						-- print("getRangesForContext B special task "..tostring(task).." wave "..tostring(wave).." freq range "..tostring(dataFreq.min).." - "..tostring(dataFreq.max))
						return wave, { dataFreq }
					end
				end
			end
		end
	end

    -- cas normal : coalition
	if not IsHelicopter[type_withData] then
		-- _affiche(WavePriority[side], "wavePriority[side]: ")
		for _, wave in ipairs(WavePriority[side].plane) do
			-- print("getRangesForContext C0 _ ".._.." type_withData: "..tostring(type_withData))
			if RadioWaveCommon[side] and RadioWaveCommon[side][wave] then
				-- print("getRangesForContext C1 "..wave)
				if type_withData == nil or WaveCapability(wave, type_withData) then
					-- print("getRangesForContext C2 normal plane wave "..tostring(wave).." type_withData: "..tostring(type_withData))
					return wave, { RadioWaveCommon[side][wave] }
				end
			end
		end
	else
		if flightOrPackage == "FreqFlight" and RadioWaveCommon[side] and RadioWaveCommon[side]["LVHF"] then
			-- print("getRangesForContext D1 normal helicopter wave "..tostring("LVHF"))
			return "LVHF", { RadioWaveCommon[side]["LVHF"] }
		elseif flightOrPackage == "FreqPackage" and RadioWaveCommon[side] and RadioWaveCommon[side]["UHF"] then
			-- print("getRangesForContext D2 normal helicopter wave "..tostring("UHF"))
			return "UHF", { RadioWaveCommon[side]["UHF"] }
		end

		for _, wave in ipairs(WavePriority[side].helicopter) do
			if RadioWaveCommon[side] and RadioWaveCommon[side][wave] then
				-- print("getRangesForContext D3 normal helicopter wave "..tostring(wave))
				return wave, { RadioWaveCommon[side][wave] }
			end
		end
	end

	-- print("getRangesForContext Z return nil ")
    return nil, {}
end



local function generateRandomFrequency(ranges)

	-- print("generateRandomFrequency 0 called for ranges: "..tostring(ranges) )
	-- _affiche(ranges, "ranges: ")
	-- print("generateRandomFrequency 0b ")

	local step = 0.05
	local range

	-- Normalisation du range
	if ranges.min and ranges.max then
		range = ranges
	elseif type(ranges) == "table" and #ranges > 0 then
		range = ranges[math.random(1, #ranges)]
	else
		-- print("generateRandomFrequency A RETURN NIL no valid range")
		return nil
	end

	if not range.min or not range.max then
		-- print("generateRandomFrequency B RETURN NIL no valid range.min or range.max")
		return nil
	end

	-- Ajustement du step pour HF (petites plages)
	-- Pourquoi : éviter saturation (trop peu de fréquences disponibles)
	if (range.max - range.min) <= 3 then
		step = 0.01
	end

	local min = math.ceil(range.min / step) * step
	local max = math.floor(range.max / step) * step
	local count = math.floor((max - min) / step)

	if count <= 0 then
		-- print("generateRandomFrequency C RETURN NIL no valid frequencies in range")
		return nil
	end

	local freq
	local safety = 0

	repeat
		local index = math.random(0, count)
		freq = min + index * step

		-- normalisation décimale
		freq = math.floor(freq * 100 + 0.5) / 100

		safety = safety + 1
		if safety > 200 then
			-- print("generateRandomFrequency D RETURN NIL safety limit reached")
			return nil
		end

	until not EmergencyFreq[freq]
	   and not Assigned_freq[freq]

	-- print("generateRandomFrequency E generated frequency "..tostring(freq).." in range "..tostring(range.min).." - "..tostring(range.max))
	return freq
end


function GetFrequencyNG(side, target_name, task, type, wave, flightOrPackage, groupName, from)
	
    -- print()
	-- print("GetFrequencyNG 0 called for side "..tostring(side).." target_name "..tostring(target_name).." task "..tostring(task).." type_withData "..tostring(type)
    -- .." wave " ..tostring(wave).." flightOrPackage "..tostring(flightOrPackage).." groupName "..tostring(groupName).." From: "..tostring(from))

	AssignedTargetFrequency[side] = AssignedTargetFrequency[side] or {}
	AssignedGroupFrequency = AssignedGroupFrequency or {}
	AssignedGroupFrequency[side] = AssignedGroupFrequency[side] or {}

	if target_name then
		AssignedTargetFrequency[side][target_name] = AssignedTargetFrequency[side][target_name] or {}
	end

	----------------------------------------------------------------
	-- 1. CACHE GROUPE (prioritaire mais différencié Flight/Package)
	----------------------------------------------------------------
	local groupKey = nil

	if groupName and type and flightOrPackage then
		local root = string.gsub(groupName, "%s%d+$", "")
		groupKey = type .. "|" .. root .. "|" .. flightOrPackage

		if AssignedGroupFrequency[side][groupKey] then
			local freqCache = AssignedGroupFrequency[side][groupKey]
			-- print("GetFrequencyNG A1 ")
			if FreqCapabilityNG1(freqCache, type) then
				-- print("GetFrequencyNG A2 returning cached frequency for groupKey "..tostring(groupKey).." freq "..tostring(AssignedGroupFrequency[side][groupKey]))
				return AssignedGroupFrequency[side][groupKey]
			end
		end
	end

	----------------------------------------------------------------
	-- 2. CACHE CLASSIQUE
	----------------------------------------------------------------
	if target_name and flightOrPackage and AssignedTargetFrequency[side][target_name][flightOrPackage] then
		local freqCache = AssignedTargetFrequency[side][target_name][flightOrPackage]
		
		-- print("GetFrequencyNG B2 ")
		if FreqCapabilityNG1(freqCache, type) then

			-- print("GetFrequencyNG B2 returning cached frequency for target "..tostring(target_name).." flightOrPackage: " .. tostring(flightOrPackage) .. " freq "..tostring(AssignedTargetFrequency[side][target_name][flightOrPackage]))
			return freqCache
		end
	end

	----------------------------------------------------------------
	-- 3. RANGES
	----------------------------------------------------------------
	local selectedWave
	local ranges = {}

	if wave then
		selectedWave = wave

        -- print("GetFrequencyNG C1 wave provided "..tostring(wave).." for side "..tostring(side).." task "..tostring(task).." type_withData "..tostring(type).." flightOrPackage "..tostring(flightOrPackage))

		if RadioWaveCommon[side] and RadioWaveCommon[side][wave] then
			ranges = { RadioWaveCommon[side][wave] }
            -- print("GetFrequencyNG C2 ranges found for wave "..tostring(wave).." for side "..tostring(side).." task "..tostring(task).." type_withData "..tostring(type).." flightOrPackage "..tostring(flightOrPackage))
		end
	else
		selectedWave, ranges = getRangesForContext(side, task, type, flightOrPackage)
        -- print("GetFrequencyNG C3 wave selected "..tostring(selectedWave).." for side "..tostring(side).." task "..tostring(task).." type_withData "..tostring(type).." flightOrPackage "..tostring(flightOrPackage))
	end

	----------------------------------------------------------------
	-- 4. GÉNÉRATION
	----------------------------------------------------------------
	local freq = generateRandomFrequency(ranges)
	if not freq then 
		-- _affiche(ranges, "ranges: ")
		-- print("GetFrequencyNG D no frequency generated for side "..tostring(side).." task "..tostring(task).." type_withData "..tostring(type).." wave "..tostring(selectedWave))
		return nil 

	end

	----------------------------------------------------------------
	-- 5. SAUVEGARDE
	----------------------------------------------------------------
	if groupKey then
		AssignedGroupFrequency[side][groupKey] = freq
	end

	if target_name and flightOrPackage then
		AssignedTargetFrequency[side][target_name][flightOrPackage] = freq
	end

	-- print("GetFrequencyNG E returning frequency "..tostring(freq).." for side "..tostring(side).." target_name "..tostring(target_name).." task "..tostring(task).." type_withData "..tostring(type).." wave "..tostring(selectedWave).." groupKey "..tostring(groupKey))
	return freq
end


----------------------------------------------------------------
-- START START FreqCapabilityNG START
----------------------------------------------------------------
---

function WaveCapability(wave, type)

	if not wave then 
		-- print("WaveCapability A no wave provided")
		return false 

	end

	local db = Db_Frequency[type]
	if not db then
		-- print("WaveCapability B no db entry for type "..tostring(type))
		return false
	else
		-- print("WaveCapability B0 type: "..tostring(type))
		-- _affiche(db, "Db_Frequency: ")
	end

	local waveDef = waveDefinitions[wave]
	if not waveDef then
		-- print("WaveCapability C no wave definition for wave "..tostring(wave))
		return false
	end

	------------------------------------------------------------------
	-- 1) HUMAN RADIO
	------------------------------------------------------------------
	if db.HumanRadio then
		local hr = db.HumanRadio

		-- cas rangeFrequency
		if hr.rangeFrequency then
			for _, r in ipairs(hr.rangeFrequency) do
				if r.max >= waveDef.min and r.min <= waveDef.max then
					-- print("WaveCapability D wave "..tostring(wave).." is compatible with HumanRadio range "..tostring(r.min).." - "..tostring(r.max).." for type "..tostring(type))
					return true
				end
			end
		end

		-- cas min/max classique
		if hr.minFrequency and hr.maxFrequency then
			if hr.maxFrequency >= waveDef.min and hr.minFrequency <= waveDef.max then
				-- print("WaveCapability E wave "..tostring(wave).." is compatible with HumanRadio range "..tostring(hr.minFrequency).." - "..tostring(hr.maxFrequency).." for type "..tostring(type))
				return true
			end
		end
	end

	------------------------------------------------------------------
	-- 2) PANEL RADIO
	------------------------------------------------------------------
	if db.panelRadio then
		for _, radio in ipairs(db.panelRadio) do

			if radio.range then
				for _, r in ipairs(radio.range) do
					if r.max >= waveDef.min and r.min <= waveDef.max then
						-- print("WaveCapability F wave "..tostring(wave).." is compatible with panelRadio "..tostring(r.min).." - "..tostring(r.max).." for type "..tostring(type))
						return true
					end
				end
			end

		end
	end

	------------------------------------------------------------------
	-- print("WaveCapability G wave "..tostring(wave).." is NOT compatible with type "..tostring(type))
	return false
end


local function freqInRange(freq, range)
    if not range or not range.min or not range.max then
        return false
    end
    return freq >= range.min and freq <= range.max
end

function FreqCapabilityNG1(arg_testFreq, arg_type)

    local freq = tonumber(arg_testFreq)
    if not freq then
        return false
    end

    local db = Db_Frequency[arg_type]
    if not db then
        return false
    end

    ------------------------------------------------------------------
    -- 1. HUMAN RADIO
    ------------------------------------------------------------------
    if db.HumanRadio then
        local hr = db.HumanRadio

        -- Cas 1 : rangeFrequency (le PLUS restrictif)
        if hr.rangeFrequency then
            for _, r in ipairs(hr.rangeFrequency) do
                if freqInRange(freq, r) then
                    return true
                end
            end
        else
            -- Cas 2 : minFrequency / maxFrequency
            if hr.minFrequency and hr.maxFrequency then
                if freq >= hr.minFrequency and freq <= hr.maxFrequency then
                    return true
                end
            end
        end
    end

    ------------------------------------------------------------------
    -- 2. PANEL RADIO
    ------------------------------------------------------------------
    if db.panelRadio then
        for _, radio in ipairs(db.panelRadio) do

            -- Cas 1 : range sous forme de liste
            if radio.range and type(radio.range) == "table" then
                -- range[1..n]
                if radio.range[1] then
                    for _, r in ipairs(radio.range) do
                        if freqInRange(freq, r) then
                            return true
                        end
                    end
                else
                    -- range simple
                    if freqInRange(freq, radio.range) then
                        return true
                    end
                end
            end
        end
    end

    ------------------------------------------------------------------
    -- 3. AUCUNE RADIO COMPATIBLE
    ------------------------------------------------------------------
    return false
end
----------------------------------------------------------------
-- FIN FIN FreqCapabilityNG FIN
----------------------------------------------------------------


----- function to assign frquencies to packages -----

function FoundWave(range)
	-- _affiche(range, "UtilF AA range testing")
	for waveName, wave in pairs(waveRef) do
		if range.min >= wave.min and range.max <= wave.max then
			-- print("UtilF CC return waveName "..tostring(waveName))

			return waveName
		end
	end
	return false
end