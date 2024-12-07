


-- -- Rayon de la Terre (en mètres)
-- local R = 6378137

-- -- Point de référence 1 (P1) N48_23_15_58__E26_46_43_50 ok
-- local P1_x = -560000
-- local P1_y = 380000
-- local P1_lat = 48.3876
-- local P1_lon = 26.7788

-- -- Point de référence 2 (P3) N47_22_55_88__E49_18_32_22 ok
-- local P2_y = 379982.92359638
-- local P2_x = 1129937.7183437
-- local P2_lat = 47.382194
-- local P2_lon = 49.30895

-- -- Point de référence 3 (P3)   N38_54_53_16__E47_05_52_77
-- local P3_y = -595066.58663007
-- local P3_x = 1125256.6436843
-- local P3_lat = 38.914767
-- local P3_lon = 47.097992

-- -- Point de référence 4 (P4) N39_36_32_16__E27_38_14_40 ok
-- local P4_y = -599999.55143785
-- local P4_x = -559999.77571892
-- local P4_lat = 39.608933
-- local P4_lon = 27.637333


-- -- Point cible (P5)
-- local P5_x = 496854.66554192
-- local P5_y = -188833.094827


-- Converts degrees to radians
local function deg_to_rad(deg)
    return deg * math.pi / 180
end

-- Converts radians to degrees
local function rad_to_deg(rad)
    return rad * 180 / math.pi
end

-- Mercator projection functions
local function mercator_y(lat)
    return math.log(math.tan(math.pi / 4 + deg_to_rad(lat) / 2))
end

local function inverse_mercator_y(y)
    return rad_to_deg(2 * math.atan(math.exp(y)) - math.pi / 4)
end


-- -- Given points
-- local points = {
--     {x = 0, y = 0, lat = 45.129497, lon = 34.265514},
--     {x = -560000, y = 380000, lat = 47.382194, lon = 49.30895},                      --N48_23_15_58__E26_46_43_50 ok
--     {x = 1129937.71, y = 379982.92, lat = 48.095942, lon = 42.065122},              --N47_22_55_88__E49_18_32_22 ok
--     {x = 1125256.64, y = -595066.58, lat = 38.914767, lon = 47.097992},             --N38_54_53_16__E47_05_52_77 ok
--     {x = -559999.77, y = -599999.55, lat = 39.608933, lon = 27.637333}    --N39_36_32_16__E27_38_14_40 
-- }

-- Given points
local points = {
    {x = 0, y = 0, lat = 45.129497, lon = 34.265514},
    {x = -560000, y = 380000, lat = 47.382194, lon = 49.30895},                      --N48_23_15_58__E26_46_43_50 ok
    {x = 1129937.71, y = 379982.92, lat = 48.095942, lon = 42.065122},              --N47_22_55_88__E49_18_32_22 ok
    {x = 1125256.64, y = -595066.58, lat = 38.914767, lon = 47.097992},             --N38_54_53_16__E47_05_52_77 ok
    {x = -560000, y = -600000, lat = 39.608933, lon = 27.637333}    --N39_36_32_16__E27_38_14_40 
}

-- Target point
local target_x = 496854.66554192
local target_y = -188833.094827

-- Calculate the scale based on known points (assuming they form a bounding box)
local min_lat = math.min(points[1].lat, points[2].lat, points[3].lat, points[4].lat, points[5].lat)
local max_lat = math.max(points[1].lat, points[2].lat, points[3].lat, points[4].lat, points[5].lat)
local min_lon = math.min(points[1].lon, points[2].lon, points[3].lon, points[4].lon, points[5].lon)
local max_lon = math.max(points[1].lon, points[2].lon, points[3].lon, points[4].lon, points[5].lon)

local min_x = math.min(points[1].x, points[2].x, points[3].x, points[4].x, points[5].x)
local max_x = math.max(points[1].x, points[2].x, points[3].x, points[4].x, points[5].x)
local min_y = math.min(points[1].y, points[2].y, points[3].y, points[4].y, points[5].y)
local max_y = math.max(points[1].y, points[2].y, points[3].y, points[4].y, points[5].y)

local scale_lat = (max_lat - min_lat) / (max_y - min_y)
local scale_lon = (max_lon - min_lon) / (max_x - min_x)

-- Convert target point
local target_lat = min_lat + (target_y - min_y) * scale_lat
local target_lon = min_lon + (target_x - min_x) * scale_lon

-- Print results in decimal degrees
print(string.format("Latitude (decimal): %.6f", target_lat))
print(string.format("Longitude (decimal): %.6f", target_lon))

-- Function to convert decimal degrees to DMS
local function decimal_to_dms(deg)
    local d = math.floor(deg)
    local m = math.floor((deg - d) * 60)
    local s = ((deg - d) * 60 - m) * 60
    return d, m, s
end

-- Convert to DMS
local lat_d, lat_m, lat_s = decimal_to_dms(target_lat)
local lon_d, lon_m, lon_s = decimal_to_dms(target_lon)

-- Print results in DMS
print(string.format("Latitude (DMS): %d° %d' %.2f\"", lat_d, lat_m, lat_s))
print(string.format("Longitude (DMS): %d° %d' %.2f\"", lon_d, lon_m, lon_s))

print("Attendu cible2: N43_12_01.14 E40_20_21.56 ")


-- -- Convertir les degrés en radians
-- local function deg_to_rad(deg)
--     return deg * math.pi / 180
-- end

-- -- Convertir les radians en degrés
-- local function rad_to_deg(rad)
--     return rad * 180 / math.pi
-- end

-- -- Fonction atan2 alternative
-- local function atan2(y, x)
--     if x > 0 then
--         return math.atan(y / x)
--     elseif x < 0 and y >= 0 then
--         return math.atan(y / x) + math.pi
--     elseif x < 0 and y < 0 then
--         return math.atan(y / x) - math.pi
--     elseif x == 0 and y > 0 then
--         return math.pi / 2
--     elseif x == 0 and y < 0 then
--         return -math.pi / 2
--     else
--         return 0  -- x == 0 and y == 0
--     end
-- end

-- -- Calculer les coordonnées géographiques de P3 en utilisant la projection gnomonique
-- local function gnomonic_to_latlon(P1_lat, P1_lon, P1_x, P1_y, P3_x, P3_y)
--     -- Convertir l'origine en radians
--     local lat0 = deg_to_rad(P1_lat)
--     local lon0 = deg_to_rad(P1_lon)
    
--     -- Calculer les coordonnées gnomoniques inverses
--     local rho = math.sqrt(P3_x^2 + P3_y^2)
--     local c = math.atan(rho / R)
    
--     local lat = math.asin(math.cos(c) * math.sin(lat0) + (P3_y * math.sin(c) * math.cos(lat0) / rho))
--     local lon = lon0 + atan2(P3_x * math.sin(c), rho * math.cos(c) * math.cos(lat0) - P3_y * math.sin(c) * math.sin(lat0))

--     return rad_to_deg(lat), rad_to_deg(lon)
-- end

-- -- Obtenir les coordonnées géographiques de P3
-- local lat, lon = gnomonic_to_latlon(P1_lat, P1_lon, P1_x, P1_y, P3_x, P3_y)

-- -- Afficher les résultats
-- print(string.format("Latitude: %.6f", lat))
-- print(string.format("Longitude: %.6f", lon))
