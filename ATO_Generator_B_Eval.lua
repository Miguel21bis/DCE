--ATO_Generator_B_Eval.lua
--Sous-module de ATO_Generator : mini moteur d'evaluation de conditions (eval.test / eval.group / eval.attributesCond)
--A charger APRES ATO_Generator_A_Debug.lua (utilise debugLog si disponible) et AVANT ATO_Generator_C_Core.lua
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Generator_B_Eval.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Generator_B_Eval.lua "..versionDCE["ATO_Generator_B_Eval.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

-- Déclaration du module
eval = {}

-- Une fonction de log locale par défaut si debugLog n'est pas globale
local function log(msg)
    if debugLog then debugLog(msg) else print(msg) end
end

-- 1️ eval.test (Anciennement evalTest)
function eval.test(key, value, unit, DEBUG)
    -- Cas 1 : plusieurs valeurs → OU implicite
    if type(value) == "table" then
        for _, oneValue in ipairs(value) do
            -- Appel récursif via le module
            if eval.test(key, oneValue, unit, DEBUG) then
                if DEBUG then log("[TEST A return true Cas 1 : plusieurs valeurs → OU implicite "..key.."] OK (OR)") end
                return true
            end
        end
        if DEBUG then log("[TEST B "..key.."] FAIL (OR)") end
        return false
    end

    -- Cas 2 : valeur simple
    if DEBUG then
        log("[TEST C Cas 2 : valeur simple "..key.." = "..tostring(value).."]")
    end

    -- string.lower crée une nouvelle chaîne, on le fait après le check de la table
    local lowerKey = string.lower(key)

    -- Note : string.find utilise des expressions régulières. 
    -- Si tu cherches juste le mot exact, ajoute `true` en 4e argument pour désactiver le regex (plus rapide).
    if string.find(lowerKey, "playersquad", 1, true) then
        if DEBUG then log("[TEST D playersquad "..key.."] ") end
        return value == true and (unit.player or unit.client)

    elseif string.find(lowerKey, "category", 1, true) then
        value = string.lower(tostring(value))
        if DEBUG then log("[TEST D "..key.."] ") end

        if string.find(value, "helico", 1, true) then
            -- Sécurité au cas où IsHelicopter n'est pas défini globalement
            local isHeli = _G.IsHelicopter or {}
            if DEBUG then log("[TEST E "..key.."] ??? "..tostring(isHeli[unit.type])) end
            return isHeli[unit.type] ~= nil

        elseif string.find(value, "plane", 1, true) then
            local isHeli = _G.IsHelicopter or {}
            if DEBUG then log("[TEST F "..key.."] ") end
            return isHeli[unit.type] == nil
        end

    elseif string.find(lowerKey, "planetype", 1, true) then
        if DEBUG then log("[TEST G "..tostring(value).." ==? ] "..tostring(unit.type)) end
        return unit.type == value

    elseif string.find(lowerKey, "squadname", 1, true) then
        if DEBUG then log("[TEST H "..tostring(value).." ==? ] "..tostring(unit.name)) end
        return unit.name == value
    end

    if DEBUG then log("[TEST Z "..key.."] UNKNOWN → FALSE") end
    return false
end

-- 2️ eval.group (Anciennement evalGroup)
function eval.group(group, unit, DEBUG)
    local op = group.op or "AND"
    if DEBUG then log("== EVAL GROUP ("..op..") ==") end

    local result = (op == "AND")

    -- Tests simples (clés dictionnaires)
    for key, value in pairs(group) do
        if key ~= "op" and type(key) ~= "number" then
            local testResult = eval.test(key, value, unit, DEBUG)

            if DEBUG then
                log("   -> "..key.." = "..tostring(testResult))
            end

            if op == "AND" and not testResult then
                return false
            elseif op == "OR" and testResult then
                return true
            end
        end
    end

    -- Sous-groupes (index numériques)
    for _, subGroup in ipairs(group) do
        local subResult = eval.group(subGroup, unit, DEBUG)

        if DEBUG then
            log("   -> SUBGROUP = "..tostring(subResult))
        end

        if op == "AND" and not subResult then
            return false
        elseif op == "OR" and subResult then
            return true
        end
    end

    return result
end

-- 3️ eval.attributesCond (Anciennement evalAttributesCond)
function eval.attributesCond(cond, unit, DEBUG)
    if not cond then return true end
    return eval.group(cond, unit, DEBUG)
end

-- return eval
