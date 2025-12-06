-- compare_raw_literals.lua
-- Usage : adapte fileA/fileB puis lance le script

local function readFile(path)
    local f, err = io.open(path, "rb")
    if not f then return nil, err end
    local content = f:read("*a")
    f:close()
    return content
end

-- Trouve toutes les positions d'une sous-chaîne (non-overlap)
local function findAllPositions(s, pattern)
    local positions = {}
    local start = 1
    while true do
        local i, j = s:find(pattern, start, true) -- plain find
        if not i then break end
        table.insert(positions, i)
        start = j + 1
    end
    return positions
end

-- À partir d'une position après ["key"] ou ['key'], chercher le littéral qui suit, en gérant échappements
local function extractLiteralFrom(s, pos_after_key)
    local n = #s
    local i = pos_after_key
    -- skip spaces and = and spaces
    while i <= n do
        local c = s:sub(i, i)
        if c == '=' then
            i = i + 1
            break
        elseif c:match("%s") then
            i = i + 1
        else
            -- s'il n'y a pas de "=" là, on continue à chercher
            i = i + 1
        end
    end
    -- skip spaces
    while i <= n and s:sub(i, i):match("%s") do i = i + 1 end
    if i > n then return nil end

    local quote = s:sub(i, i)
    if quote ~= "'" and quote ~= '"' then
        -- pas de littéral simple/double trouvé
        return nil
    end

    local start_quote = i
    i = i + 1
    local j = i
    while j <= n do
        local ch = s:sub(j, j)
        if ch == quote then
            -- compter les backslashes consécutifs juste avant j
            local k = j - 1
            local bs = 0
            while k >= start_quote and s:sub(k, k) == "\\" do
                bs = bs + 1
                k = k - 1
            end
            if bs % 2 == 0 then
                -- quote non-échappé => fin du littéral
                local rawLiteral = s:sub(start_quote, j) -- inclut quotes et les backslashes bruts
                return {
                    raw = rawLiteral,
                    content = s:sub(start_quote + 1, j - 1),
                    start_pos = start_quote,
                    end_pos = j
                }
            end
            -- else quote échappé -> continuer
        end
        j = j + 1
    end
    return nil -- littéral non fermé
end

-- Cherche occurrences de ["key"] et ['key'] et extrait littéraux après = (si présents)
local function findKeyLiteralsInFile(content, key)
    local results = {}
    local pattern1 = '["' .. key .. '"]' -- exact
    local pattern2 = "['" .. key .. "']"
    -- rechercher toutes les positions
    local positions = {}
    for _, p in ipairs(findAllPositions(content, pattern1)) do table.insert(positions, p) end
    for _, p in ipairs(findAllPositions(content, pattern2)) do table.insert(positions, p) end
    table.sort(positions)
    for _, p in ipairs(positions) do
        local pos_after = p +
        #pattern1                       -- approximation; ok même si pattern2 utilisé, on avance trop mais extractLiteralFrom skipera espaces/=
        local lit = extractLiteralFrom(content, pos_after)
        if not lit then
            -- essayer avec la vraie longueur si pattern2 a été trouvé (cas où pattern2 long diff)
            local pos_after2 = p + #pattern2
            lit = extractLiteralFrom(content, pos_after2)
        end
        if lit then
            table.insert(results, lit)
        else
            -- si on n'a pas trouvé de littéral, on peut tenter d'extraire sur les 200 suivantes pour debug
            table.insert(results, { raw = nil, content = nil, start_pos = p })
        end
    end
    return results
end

-- Comparer deux listes de littéraux (par index) et afficher diff
local function compareLiteralLists(listA, listB, fileAname, fileBname)
    local maxn = math.max(#listA, #listB)
    local diffs = {}
    for i = 1, maxn do
        local a = listA[i]
        local b = listB[i]
        if not a then
            table.insert(diffs, { type = "added_in_B", index = i, valueB = (b and b.raw) })
        elseif not b then
            table.insert(diffs, { type = "removed_in_B", index = i, valueA = (a and a.raw) })
        else
            local ra = a.raw or "<no-literal>"
            local rb = b.raw or "<no-literal>"
            if ra ~= rb then
                table.insert(diffs, { type = "changed", index = i, rawA = ra, rawB = rb, contentA = a.content, contentB =
                b.content })
            end
        end
    end

    -- print results
    if #diffs == 0 then
        print("Aucune différence brute des littéraux '" .. "command" .. "' trouvée entre les fichiers.")
        return diffs
    end

    print("\nDIFFERENCES TROUVEES :")
    for _, d in ipairs(diffs) do
        print("---- Occurrence #" .. d.index .. " ----")
        if d.type == "changed" then
            print("Fichier A: " .. tostring(d.rawA))
            print("Fichier B: " .. tostring(d.rawB))
            print("Contenu A (sans quotes): " .. tostring(d.contentA))
            print("Contenu B (sans quotes): " .. tostring(d.contentB))
        elseif d.type == "added_in_B" then
            print("Présent seulement dans B: " .. tostring(d.valueB))
        elseif d.type == "removed_in_B" then
            print("Présent seulement dans A: " .. tostring(d.valueA))
        end
    end
    return diffs
end

-- === MAIN ===
local fileA = "mission_A" -- adapte
local fileB = "mission_B" -- adapte

local contentA, errA = readFile(fileA)
local contentB, errB = readFile(fileB)
if not contentA then error("Impossible de lire " .. fileA .. " : " .. tostring(errA)) end
if not contentB then error("Impossible de lire " .. fileB .. " : " .. tostring(errB)) end

local key = "command" -- tu peux changer pour d'autres clés

local listA = findKeyLiteralsInFile(contentA, key)
local listB = findKeyLiteralsInFile(contentB, key)

compareLiteralLists(listA, listB, fileA, fileB)
