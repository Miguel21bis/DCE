


local function latLon_decimal_to_dms(decimal_degrees)
    local degrees = math.floor(decimal_degrees)
    local minutes = math.floor((decimal_degrees - degrees) * 60)
    local seconds = (decimal_degrees - degrees - minutes / 60) * 3600
    return degrees, minutes, seconds
end


local showLL_position = true

function Format_dms(lat_decimal, lon_decimal, precision)

	if not showLL_position then return "" end

	local lat_deg, lat_min, lat_sec = latLon_decimal_to_dms(lat_decimal)
    local lon_deg, lon_min, lon_sec = latLon_decimal_to_dms(lon_decimal)

    local lat_direction = lat_decimal >= 0 and 'N' or 'S'
    local lon_direction = lon_decimal >= 0 and 'E' or 'W'

    if precision == 4 then
        return string.format("%s%d°%02d' - %s%d°%02d'",
                             lat_direction, math.abs(lat_deg), math.abs(lat_min),
                             lon_direction, math.abs(lon_deg), math.abs(lon_min))
    elseif precision == 6 then
        return string.format("%s%d°%02d'%02d\" - %s%d°%02d'%02d\"",
                             lat_direction, math.abs(lat_deg), math.abs(lat_min), math.floor(math.abs(lat_sec)),
                             lon_direction, math.abs(lon_deg), math.abs(lon_min), math.floor(math.abs(lon_sec)))
    elseif precision == 8 then
        return string.format("%s%d°%02d'%05.2f\" - %s%d°%02d'%05.2f\"",
                             lat_direction, math.abs(lat_deg), math.abs(lat_min), math.abs(lat_sec),
                             lon_direction, math.abs(lon_deg), math.abs(lon_min), math.abs(lon_sec))
    else
        error("Precision must be 4, 6, or 8")
    end
end



-- Rayon de la Terre en mètres
local R = 6371000  -- 6371 km en mètres

-- Fonction pour calculer la position du point B
function NewPosLatLon(latA, lonA, distance, azimut)
    -- Conversion des entrées en radians
    local latA_rad = toRadians(latA)
    local lonA_rad = toRadians(lonA)
    local azimut_rad = toRadians(azimut)

    -- Distance en fraction de rayon terrestre (distance en mètres ici)
    local d = distance / R

    -- Calcul de la latitude de B
    local latB_rad = math.asin(math.sin(latA_rad) * math.cos(d) + math.cos(latA_rad) * math.sin(d) * math.cos(azimut_rad))

    -- Calcul de la différence de longitude
    local deltaLon_rad = atan2(
        math.sin(azimut_rad) * math.sin(d) * math.cos(latA_rad),
        math.cos(d) - math.sin(latA_rad) * math.sin(latB_rad)
    )

    -- Calcul de la longitude de B
    local lonB_rad = lonA_rad + deltaLon_rad

    -- Conversion des résultats en degrés
    local latB = toDegrees(latB_rad)
    local lonB = toDegrees(lonB_rad)

    return latB, lonB
end

function GetWeightedRandom(min, max, bias)
    -- Génère un nombre aléatoire entre 0 et 1
    local randomValue = math.random()
    -- Applique une pondération exponentielle (plus le biais est grand, plus c'est proche de min)
    local weightedValue = randomValue ^ bias
    -- Remap pour correspondre à l'échelle entre min et max
    return min + (max - min) * weightedValue
end


---------------------------------------------------------------------
-- Convertit une latitude / longitude WGS84 en MGRS simplifié
-- Précision : 1 km ou 100 m selon le paramètre
---------------------------------------------------------------------
function LatLonToMGRS(lat, lon, precision)
    -- Pourquoi : constantes WGS84 nécessaires à la projection UTM
    local a = 6378137.0
    local f = 1 / 298.257223563
    local k0 = 0.9996
    local e2 = f * (2 - f)

    -- Pourquoi : calcul de la zone UTM
    local zone = math.floor((lon + 180) / 6) + 1

    -- Pourquoi : méridien central de la zone
    local lon0 = math.rad((zone - 1) * 6 - 180 + 3)

    -- Conversion degrés → radians
    local lat_rad = math.rad(lat)
    local lon_rad = math.rad(lon)

    -- Pourquoi : termes intermédiaires pour la projection
    local n = a / math.sqrt(1 - e2 * math.sin(lat_rad)^2)
    local t = math.tan(lat_rad)^2
    local c = (e2 / (1 - e2)) * math.cos(lat_rad)^2
    local a_term = math.cos(lat_rad) * (lon_rad - lon0)

    -- Pourquoi : calcul du méridien (formule UTM standard)
    local m = a * (
        (1 - e2 / 4 - 3 * e2^2 / 64 - 5 * e2^3 / 256) * lat_rad
        - (3 * e2 / 8 + 3 * e2^2 / 32 + 45 * e2^3 / 1024) * math.sin(2 * lat_rad)
        + (15 * e2^2 / 256 + 45 * e2^3 / 1024) * math.sin(4 * lat_rad)
        - (35 * e2^3 / 3072) * math.sin(6 * lat_rad)
    )

    -- Calcul Easting / Northing UTM
    local easting = k0 * n * (
        a_term
        + (1 - t + c) * a_term^3 / 6
        + (5 - 18 * t + t^2 + 72 * c) * a_term^5 / 120
    ) + 500000

    local northing = k0 * (
        m
        + n * math.tan(lat_rad) * (
            a_term^2 / 2
            + (5 - t + 9 * c + 4 * c^2) * a_term^4 / 24
        )
    )

    -- Pourquoi : correction hémisphère sud
    if lat < 0 then
        northing = northing + 10000000
    end

    -- Pourquoi : bande latitudinale MGRS
    local bands = "CDEFGHJKLMNPQRSTUVWX"
    local band = bands:sub(math.floor((lat + 80) / 8) + 1,
                            math.floor((lat + 80) / 8) + 1)

    -- Pourquoi : carrés 100 km MGRS
    local e100k = math.floor(easting / 100000)
    local n100k = math.floor(northing / 100000)

    local e_letters = {"ABCDEFGH", "JKLMNPQR", "STUVWXYZ"}
    local e_letter = e_letters[(zone - 1) % 3 + 1]:sub(e100k + 1, e100k + 1)

    local n_letters = "ABCDEFGHJKLMNPQRSTUV"
    local n_letter = n_letters:sub((n100k % 20) + 1, (n100k % 20) + 1)

    -- Pourquoi : réduction selon la précision demandée
    local scale = (precision == 100) and 100 or 1000

    local e_reduced = math.floor((easting % 100000) / scale)
    local n_reduced = math.floor((northing % 100000) / scale)

    local digits = (precision == 100) and 3 or 2

	local zone_str = padnumber(zone, 2)
	local e_str = padnumber(e_reduced, digits)
	local n_str = padnumber(n_reduced, digits)

	return zone_str .. band .. " " ..
		e_letter .. n_letter .. " " ..
		e_str .. " " .. n_str

end


---------------------------------------------------------------------
-- Génère une zone MGRS floue (1km / 2km / 10km) à partir d'une table grid
-- Pourquoi : représenter une zone d'incertitude (chute, impact, radar…)
---------------------------------------------------------------------
function GetFuzzyMGRS(grid, precision)

    -- precision en mètres : 1000 / 2000 / 10000

    local e = tostring(grid.Easting)
    local n = tostring(grid.Northing)

    -- Sécurité : toujours 5 chiffres
    while #e < 5 do e = "0" .. e end
    while #n < 5 do n = "0" .. n end

    local mask

    -- Pourquoi : nombre de chiffres à masquer selon la précision
    if precision == 1000 then
        mask = 2       -- 1 km → xx
    elseif precision == 2000 then
        mask = 2       -- 2 km ≈ même affichage, mais interprétation plus large
    elseif precision == 10000 then
        mask = 3       -- 10 km → xxx
    else
        mask = 2       -- défaut = 1 km
    end

    local function maskdigits(s, count)

        return s:sub(1, 5 - count) .. string.rep("x", count)
    end

    local e_fuzzy = maskdigits(e, mask)
    local n_fuzzy = maskdigits(n, mask)

    return grid.UTMZone .. "_" ..
           grid.MGRSDigraph .. "_" ..
           e_fuzzy .. "_" ..
           n_fuzzy
end
