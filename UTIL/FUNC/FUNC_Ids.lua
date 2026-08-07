AllIdGroup = {}
AllIdUnit = {}
UnitByName = {}						-- table de tous les unitId généré, utile pour placer le TACAN sur l'unitId qui est demandé avant la génération du l'unité

local idGroupCounter = 3000
local idUnitCounter = 3000


-- Génère un nouvel ID de groupe unique
function GenerateIDGroup(groupName)
	local maxAttempts = 10000
	local attempts = 0
	repeat
		idGroupCounter = idGroupCounter + 1
		attempts = attempts + 1
		if attempts > maxAttempts then
			error("GenerateIDGroup: Too many attempts to find a unique group ID")
		end
	until not AllIdGroup[idGroupCounter]
	AllIdGroup[idGroupCounter] = groupName
	return idGroupCounter
end

-- Génère un nouvel ID d'unité unique
function GenerateIDUnit(unitName, type)
	local maxAttempts = 10000
	local attempts = 0

	repeat
		idUnitCounter = idUnitCounter + 1
		attempts = attempts + 1
		if attempts > maxAttempts then
			error("GenerateIDUnit: Too many attempts to find a unique unit ID")
		end
	until not AllIdUnit[idUnitCounter]

	AllIdUnit[idUnitCounter] = {
		name = unitName,
		type = type,
	}
	if unitName then
		UnitByName[unitName] = idUnitCounter
	end

	-- print("GenerateIDUnit "..unitName.." | "..type.." | "..idUnitCounter)

	return idUnitCounter
end

-- Fonction principale pour détecter et corriger les doublons
--premiere passe pour les warehouses, CV, et FARP
function FirstCheck_Id()

	for warhouse_Id, warehouseData in pairs(warehouses.warehouses or {}) do
		for side_name, side in pairs(mission.coalition) do
			for country_n, country_ in pairs(side.country) do
				for categorie, categorie_ in pairs(country_) do
					if type(categorie_) == "table" and categorie_.group then
						for groupN, groupData in pairs(categorie_.group) do

							-- Vérifie les doublons de unitId
							for unitN, unit in pairs(groupData.units or {}) do
								if unit.unitId == warhouse_Id then
									AllIdUnit[unit.unitId] = {name = unit.name, type = unit.type}
									break
								end
							end

						end
					end
				end
			end
		end
	end

	-- _affiche(AllIdUnit, "warehouses ")

end

-- Fonction principale pour détecter et corriger les doublons
function CheckAll_Id()

	-- _affiche(AllIdUnit, "AllIdUnit_START ")
	-- Cross-platform sleep for 6 seconds
	-- if package.config:sub(1,1) == '\\' then
	-- 	-- Windows
	-- 	os.execute("ping -n 7 127.0.0.1 > NUL")
	-- else
	-- 	-- Unix/Linux/Mac
	-- 	os.execute("sleep 6")
	-- end

	--pour le mission
	for side_name, side in pairs(mission.coalition) do
		for country_n, country_ in pairs(side.country) do
			for categorie, categorie_ in pairs(country_) do
				if type(categorie_) == "table" and categorie_.group then
					for groupN, groupData in pairs(categorie_.group) do
						-- Vérifie les doublons de groupId
                        if AllIdGroup[groupData.groupId] then
                        else
                            AllIdGroup[groupData.groupId] = groupData.name
                        end
                        -- Vérifie les doublons de unitId
                        for Nunit, unit in pairs(groupData.units or {}) do
                            if AllIdUnit[unit.unitId] then
                            else
                                AllIdUnit[unit.unitId] = {name = unit.name, type = unit.type}
                                UnitByName[unit.name] = unit.unitId
                            end
                        end
                    end
                end
            end
        end
    end

	--pour le oob_ground
    for coalName, coal in pairs(oob_ground or {}) do
        for countryN, country in pairs(coal or {}) do
            for category, groups in pairs(country or {}) do
                if type(groups) == "table" and groups["group"] then
                    for groupN, groupData in pairs(groups["group"] or {}) do
                        -- Vérifie les doublons de groupId
                        if AllIdGroup[groupData.groupId] then
                        else
                            AllIdGroup[groupData.groupId] = groupData.name
                        end
                        -- Vérifie les doublons de unitId
                        for Nunit, unit in pairs(groupData.units or {}) do
                            if AllIdUnit[unit.unitId] then
                            else
                                AllIdUnit[unit.unitId] = {name = unit.name, type = unit.type}
                                UnitByName[unit.name] = unit.unitId
                            end
                        end
                    end
                end
            end
        end
    end

-- _affiche(AllIdUnit, "AllIdUnit_FIN ")

end


-- Fonction principale pour détecter et corriger les doublons
function CheckAndFixAllIds()
    -- -- Réinitialise les tables d'ID
    -- AllIdGroup = {}
    -- AllIdUnit = {}
    -- UnitByName = {}

    -- 1. Premier passage : collecte tous les IDs et détecte les doublons
    local groupIdError = {}
    local unitIdError = {}

    for coalName, coal in pairs(oob_ground or {}) do
        for countryN, country in pairs(coal or {}) do
            for category, groups in pairs(country or {}) do
                if type(groups) == "table" and groups["group"] then
                    for groupN, group in pairs(groups["group"] or {}) do
                        -- Vérifie les doublons de groupId
                        if AllIdGroup[group.groupId] and AllIdGroup[group.groupId] ~= group.name then
                          table.insert(groupIdError, group)
                        else
                            AllIdGroup[group.groupId] = group.name
                        end
                        -- Vérifie les doublons de unitId
                        for Nunit, unit in pairs(group.units or {}) do
                            if AllIdUnit[unit.unitId] and AllIdUnit[unit.unitId].name ~= unit.name then
								--on evite de changer l'Id si c'est une FARP, a cause des multiple lien (warhouse, linkUnit, etc...)
								if string.find(AllIdUnit[unit.unitId].type, "FARP") then
                                	table.insert(unitIdError, unit)
								else
									table.insert(unitIdError, AllIdUnit[unit.unitId])
								end
                            else
                                AllIdUnit[unit.unitId] = {name = unit.name, type = unit.type}
                                UnitByName[unit.name] = unit.unitId
                            end
                        end
                    end
                end
            end
        end
    end

    -- 2. Correction des doublons de groupId
    for _, group in ipairs(groupIdError) do
        group.groupId = GenerateIDGroup(group.name)
        -- if Debug and Debug.debug then
        --     print("Nouveau groupId attribué : "..tostring(group.groupId).." pour "..tostring(group.name))
        -- end
    end

    -- 3. Correction des doublons de unitId
    for _, unit in ipairs(unitIdError) do
        unit.unitId = GenerateIDUnit(unit.name, unit.type)
        -- if Debug and Debug.debug then
        --     print("Nouveau unitId attribué : "..tostring(unit.unitId).." pour "..tostring(unit.name))
        -- end
    end
end
