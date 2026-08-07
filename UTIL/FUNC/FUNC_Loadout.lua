--function type DCS, ne pas changer la casse
function aircraft_task(taskName)

	return taskName
end

loadoutStructures = {
	{name = "minscore", check = false },
	{name = "support", check = false },
	{name = "country", check = false },

	{name = "self_escort", check = false },
	{name = "attributes", check = false },
	{name = "code_loadout", check = false },
	{name = "weaponType", check = false },
	{name = "expend", check = false },
	{name = "attackType", check = false },

	{name = "day", check = false },
	{name = "night", check = false },
	{name = "adverseWeather", check = false },
	{name = "range", check = false },
	{name = "capability", check = false },
	{name = "firepower", check = false },
	{name = "vCruise", check = false },
	{name = "vAttack", check = false },
	{name = "hCruise", check = false },
	{name = "hAttack", check = false },
	{name = "standoff", check = false },
	{name = "ingress", check = false },
	{name = "egress", check = false },
	{name = "MaxAttackOffset", check = false },

	{name = "tStation", check = false },
	{name = "LDSD", check = false },
	{name = "sortie_rate", check = false },
	{name = "stores", check = false },


}

local item = 0
local lodaoutStructure = {}

function TableSerializationLoadout(t, i, iTotal)

	local text = ""

		local recal = false
		local tab1 = ""
		local tab = ""

		--ignore les chapitres 4 issue du rangement loadoutStructures
		if iTotal == 4 then
			recal = true
			text = ""
		else
			text = "{\n"
		end

		if iTotal >= 4 then i = iTotal-1 end

		for n = 1, i do																	--controls the indent for the current text line
			tab1 = tab1 .. "\t"
		end

		for n = 1, i + 1 do																	--controls the indent for the current text line
			tab = tab .. "\t"
		end



		for k, v in pairs(t) do

			if type(k) == "string" then
				if string.match(k, "%s") or  string.match(k, "%d") then
					text = text .. tab .. '["' .. k .. '"] = '
				else
					text = text .. tab  .. k .. ' = '
				end
			elseif iTotal ~= 3 then
				text = text .. tab .. "[" .. k .. "] = "
			end

			if type(v) == "string" then
				v = string.gsub(v, "\n", "\\n" )
				text = text .. '"' .. v .. '",\n'
			elseif type(v) == "number" then
				text = text .. v .. ",\n"
			elseif type(v) == "table" then
				local tableOneLigne = false

				if k == "attributes" or k == "code_loadout" then
					tableOneLigne = true
				end

				if tableOneLigne then
					text = text .." {"
					local passLoop = false
					for kTemp, vTemp in pairs(v) do
						text = text .." \""..vTemp.."\","
						passLoop = true
					end
					if passLoop then text = text:sub(1, -2) end
					text = text .." },\n"
				else
					text = text .. TableSerializationLoadout(v, i+1, iTotal + 1)
				end

			elseif type(v) == "boolean" then
				if v == true then
					text = text .. "true,\n"
				else
					text = text .. "false,\n"
				end
			elseif type(v) == "function" then
				text = text .. v .. ",\n"
			elseif v == nil then
				text = text .. "nil,\n"
			end
		end
		tab = ""
		for n = 1, i do																		--indent for closing bracket is one less then previous text line
			tab = tab .. "\t"
		end
		if not recal then
			if i == 0 then
				text = text .. tab .. "}\n"														--the last bracket should not be followed by an comma
			else
				text = text .. tab .. "},\n"													--all brackets with indent higher than 0 are followed by a comma
			end
		end

	return text
end



function MergeTablesDeep(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" then
          target[k] = target[k] or {}
            MergeTablesDeep(target[k], v)
        else
          target[k] = v
        end
    end
end


function makeStrutureLoadout(loadoutTotal)

	for plane, loadoutsByTask in PairsByKeys(loadoutTotal) do
		for task, loadouts in PairsByKeys(loadoutsByTask) do

			for loadoutName, loadout in PairsByKeys(loadouts) do

				local loadoutTemp = {}

				--ajoutes les entrées selon le canevas
				for structN, struct in ipairs(loadoutStructures) do

					if loadout[struct.name] then
						local entrie = {
							[struct.name] = loadout[struct.name]
						}
						table.insert(loadoutTemp, entrie)
					end
				end

				--fait un repassage pour ajouter ce qui n etait pas dans le canevas
				for key, values in pairs(loadout) do
					local inStructure = false

					for structN, struct in ipairs(loadoutStructures) do
						if struct.name == key then
							inStructure = true
							break
						end
					end

					if not inStructure then

						local entrie = {
							[key] = values
						}

						-- print("EEE             entrie "..key.." "..tostring(entrie))

						table.insert(loadoutTemp, entrie)
					end
				end

				loadouts[loadoutName] = loadoutTemp
			end
		end
	end

	return loadoutTotal

end


--renommer les clefs, c'est obligatoire
-- les tables loadouts sauvegardé par le campaignMaker dans aved Games\DCS\MissionEditor\UnitPayloads
-- sont inutilisable dans le fichier mission, tel quel
function loadoutPylon(loadoutTable)
	for plane, loadoutByTask in pairs(loadoutTable) do
		for task, ltable in pairs(loadoutByTask) do
			for loadoutName, loadout in pairs(ltable) do

				-- if debug.debug then
				-- 	print("UtilF loadoutPylon loadoutName: "..tostring(loadoutName))
				-- end

				local newSortPylons = {}
				local newSort = false
				if loadout.stores and loadout.stores.pylons then

					for chapterN, emport in pairs(loadout.stores.pylons) do
						-- if debug.debug then
						-- 	print("UtilF loadoutPylon chapterN: "..tostring(chapterN).." emport: "..tostring(emport))
						-- end
						if emport.num and emport.num ~= chapterN then
							-- if debug.debug then
							-- 	print("UtilF incoherence pylon N and Num: |"..tostring(plane).."| |"..tostring(task).."| chapterN |"..tostring(chapterN))
							-- end
							newSort = true
						end
					end

					if newSort then
						for chapterN, emport in pairs(loadout.stores.pylons) do

							if not emport.num then
								-- AddLog("UtilF bug with plane "..plane.." loadoutName: "..loadoutName)
							else
								newSortPylons[emport.num] =
								{
									["CLSID"] =	emport.CLSID,
								}
								if emport.settings then
									newSortPylons[emport.num]["settings"] = emport.settings
								end
								newSort = true
							end


						end
					else
						for chapterN, emport in pairs(loadout.stores.pylons) do
							emport.num = nil

						end
					end
				end

				if newSort then
					loadout.stores.pylons = newSortPylons
				end

				--deletes deprecated variables
				if loadout.capability then
					loadout.capability = nil
				end
			end
		end
	end
	return loadoutTable
end




function LoadAllLoadouts(subFolder)

	-- 1) ON PART DE LA TABLE ORIGINALE (celle de DCE)
	local final = {}
	if type(db_loadouts) == "table" then
		final = DeepCopy(db_loadouts)
	end

	-- 2) Le dossier est repéré depuis la RACINE de ScriptsMod,
	--    plus depuis la position de ce fichier.
	local files, folder = ListLuaFiles(subFolder)

	if #files == 0 then
		AddLog("DCE ERROR : aucun fichier .lua trouvé dans " .. folder)
		return final
	end

	-- 3) Chargement + fusion
	for _, fullpath in ipairs(files) do

		db_loadouts = nil							-- on purifie avant le dofile

		local ok, err = pcall(dofile, fullpath)

		if not ok then
			AddLog("DCE ERROR : erreur dans " .. fullpath .. " : " .. tostring(err))
		elseif db_loadouts then
			MergeTablesDeep(final, db_loadouts)
			db_loadouts = nil
		end
	end

	return final
end


function BuildLoadout()

	if not camp.AuthorizedLoadout then
		camp.AuthorizedLoadout = {}
	end
	local addLoadoutsTag = false
	-- campaigns_code_loadout = { 
		-- ["Cyprus"] =		"Cyprus Incident",
		-- ["Crisis"] = 		"Crisis in PG",
		-- ["PG"] = 			"Over PG",
		-- ["Caucasus"] = 		"Over Caucasus",
		-- ["TF"] = 			"TF-71",             
		-- ["TF80s"] = 		"TF-71-80s",           
		-- ["TF80sRED"] = 		"TF-71-Fishbed-80s",   
		-- ["IPW71"] = 		"India Pak War 71",    
		-- ["HWITC"] = 		"Hot War in the Cold",
		-- ["IIW"] = 			"Iran Iraq War",
	-- }   



	if campMod.selectLoadout == "init" then
		require("Init/db_loadouts")
	else
		-- charge le loadout central en premier pour avoir la table de code_loadout
		-- Charge toute la base
		db_loadouts = LoadAllLoadouts("db_loadouts")
	end

	-- Fonction pour compter les mots dans une chaîne
	local function word_count(input)
		local count = 0
		for word in string.gmatch(input, "%S+") do
			count = count + 1
		end
		return count
	end



	-- cherche le code a appliquer au loadout, pour charger le bon..loadout ^^
	-- if (not ( campConfMod and campConfMod.code_loadout) and campaigns_code_loadout )then
	if (campaigns_code_loadout )then
		local bestMatch = nil
		local bestMatchCount = 0


		-- Parcourir la table des codes
		for codeName, prefix_s in pairs(campaigns_code_loadout) do
			if type(prefix_s) == "table" then
				-- Plusieurs mots-clés à vérifier
				local matchCount = 0
				for _, prefix in ipairs(prefix_s) do
					if string.find(string.lower(camp.title), string.lower(prefix)) then
						matchCount = matchCount + 1
					end
				end
				-- Mise à jour du meilleur match
				if matchCount > bestMatchCount then
					bestMatch = codeName
					bestMatchCount = matchCount
				end
			else
				-- Un seul mot-clé à vérifier
				if string.find(string.lower(camp.title), string.lower(prefix_s)) then
					local number_of_words = word_count(prefix_s)
					if number_of_words > bestMatchCount then
						bestMatch = codeName
						bestMatchCount = 1
					elseif prefix_s == camp.title then
						bestMatch = codeName
						bestMatchCount = 100
					end

					if bestMatchCount < 1 then -- Priorité pour les correspondances plus spécifiques
						bestMatch = codeName
						bestMatchCount = 1
					end
				end
			end
		end

		-- campConfMod.code_loadout = bestMatch
		camp.code_loadout = bestMatch
	end


	if Debug.debug then
		print("UtilF camp.title |"..camp.title.."| campConfMod.code_loadout |"..tostring(camp.code_loadout) )
	end

	-- helper: vérifie si le loadout est autorisé par restrictedCondition
	local function allowed_by_restriction(loadData)
		if not loadData.restrictedCondition then
			return true
		end
		if type(loadData.restrictedCondition) == "string" then
			for _, campAuth in pairs(camp.AuthorizedLoadout) do
				if string.lower(tostring(loadData.restrictedCondition)) == string.lower(tostring(campAuth)) then
					return true
				end
			end
			return false
		end
		if not camp.AuthorizedLoadout then
			return true
		end
		for _, conditionName in pairs(loadData.restrictedCondition) do
			for _, campAuth in pairs(camp.AuthorizedLoadout) do
				if string.lower(tostring(conditionName)) == string.lower(tostring(campAuth)) then
					return true
				end
			end
		end
		return false
	end

	-- helper: vérifie si le code_loadout correspond à la configuration de la campagne
	local function codes_match(value, campaign_code)
		if not value.code_loadout or value.code_loadout == "" then
			return true
		end
		if not campaign_code or campaign_code == "" then
			return true
		end
		-- accepter une chaîne ou une table
		if type(value.code_loadout) == "string" then
			return string.lower(value.code_loadout) == string.lower(campaign_code) or string.lower(value.code_loadout) == "all"
		end
		if type(value.code_loadout) == "table" then
			for _, code in pairs(value.code_loadout) do
				if string.lower(tostring(code)) == string.lower(campaign_code) or string.lower(tostring(code)) == "all" then
					return true
				end
			end
		end
		return false
	end

	-- helper: vérifie si 
	local function plane_match(planeLoadout)

		for sideName, squads in pairs(oob_air) do
			for squadN, squad in pairs(squads) do
				if string.lower(squad.type) == string.lower(planeLoadout) then
					return true
				end
			end
		end
		return false
	end

	local function add_loadout(plane, taskName, loadoutName, value)
		LoadoutsList[plane] = LoadoutsList[plane] or {}
		LoadoutsList[plane][taskName] = LoadoutsList[plane][taskName] or {}
		LoadoutsList[plane][taskName][loadoutName] = value
	end

	for plane, planeTab in pairs(db_loadouts) do
		if plane_match(plane) then
			for taskName, loadout in pairs(planeTab) do
				for loadoutName, loadData in pairs(loadout) do
					if codes_match(loadData, camp.code_loadout) then
						if allowed_by_restriction(loadData) then
							add_loadout(plane, taskName, loadoutName, loadData)
						end
					end
				end
			end
		end
	end


	if campaigns_code_loadout and not addLoadoutsTag then
		for planeType, plane  in pairs(LoadoutsList) do
			for taskName, loadouts in pairs(plane) do
				for loadoutName, loadout  in pairs(loadouts) do
					-- print("UtilF "..plane.." "..taskName.." "..loadoutName)
					if loadout and loadout.code_loadout and loadout.code_loadout ~= "" then
						for code_loadout_number, code in ipairs(loadout.code_loadout) do
							if not campaigns_code_loadout[code]  then	--and not string.lower(code) == "all"

								if  string.lower(code) ~= "all"  then

									local bugTxt = ""..planeType.." ||| "..taskName.." ||| "..loadoutName.." ||| "..code.." not found in campaigns_code_loadout****************"
									AddLog("Note for the Campaign Maker"..bugTxt)
								end
							else
								-- print("UtilF camp.code_loadout "..camp.code_loadout.." found")						
							end
						end
					end
				end
			end
		end
	end


	LoadoutsList = loadoutPylon(LoadoutsList)

	if Debug.debug then
		local test_loadouts = DeepCopy(LoadoutsList)
		test_loadouts = makeStrutureLoadout(test_loadouts)

		local test_str = "db_loadouts = " .. TableSerializationLoadout(test_loadouts, 0, 0)						--make a string	
		local testFile = io.open("Debug/loadouts_clean.lua", "w") or error("Failed to open debug file")
		testFile:write(test_str)															--save new data
		testFile:close()


	end
end



