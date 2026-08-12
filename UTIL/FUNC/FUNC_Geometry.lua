


-- Fonction pour convertir les degrés en radians
function deg_to_rad(deg)
    return deg * (math.pi / 180)
end

-- Fonction pour convertir les radians en degrés
function rad_to_deg(rad)
    return rad * (180 / math.pi)
end



-- Fonction pour convertir les degrés en radians
function toRadians(degrees)
    return degrees * math.pi / 180
end

-- Fonction pour convertir les radians en degrés
function toDegrees(radians)
    return radians * 180 / math.pi
end

-- Implémentation de atan2 manuelle
function atan2(y, x)
    if x > 0 then
        return math.atan(y / x)
    elseif x < 0 and y >= 0 then
        return math.atan(y / x) + math.pi
    elseif x < 0 and y < 0 then
        return math.atan(y / x) - math.pi
    elseif x == 0 and y > 0 then
        return math.pi / 2
    elseif x == 0 and y < 0 then
        return -math.pi / 2
    else
        return 0
    end
end


--function to return heading between two vector2 points
-- return une valeur en degré par rapport au nord géographique (pas le cercle trigonometrique)
function GetHeadingDegre(p1, p2, debug)

	if debug then
		if not p1 or not p1.x or not p1.y then
			_affiche(debug, "debug p1 GetHeading")
		end
		if not p2 or not p2.x or not p2.y then
			_affiche(debug, "debug p2 GetHeading")
		end
	end


	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y
	local result
	if (deltax > 0) and (deltay == 0) then
		result =  0
	elseif (deltax > 0) and (deltay > 0) then
		result =  math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay > 0) then
		result =  90
	elseif (deltax < 0) and (deltay > 0) then
		result =  90 - math.deg(math.atan(deltax / deltay))
	elseif (deltax < 0) and (deltay == 0) then
		result =  180
	elseif (deltax < 0) and (deltay < 0) then
		result =  180 + math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay < 0) then
		result =  270
	elseif (deltax > 0) and (deltay < 0) then
		result =  270 - math.deg(math.atan(deltax / deltay))
	else
		result =  0
	end

	-- --https://www.mathepower.com/fr/fonctionslineaires.php
	-- if result >= 0 and result <= 90 then       
	-- 	result = (-1* result) + 90

    -- elseif result >= 0 and result <= 180 then
    --     result = (-1* result) + 450

    -- elseif result >= 270 and result <= 360 then
    --     result = (-1* result) + 450

    -- elseif result >= 180 and result <= 270 then
    --     result = (-1* result) + 450
    -- end

	return result

end

--https://github.com/mrSkortch/MissionScriptingTools/releases
--- Returns heading of given unit.
-- @tparam Unit unit unit whose heading is returned.
-- @param rawHeading
-- @treturn number heading of the unit, in range
-- of 0 to 2*pi.
function GetHeadingByPos(unit)
	local unitpos = unit:getPosition()
	if unitpos then
		local Heading = math.atan2(unitpos.x.z, unitpos.x.x)
		if Heading < 0 then
			Heading = Heading + 2*math.pi	-- put heading in range of 0 to 2*pi
		end
		return Heading
	end
end

function HeadingDegToRad(angle)
	angle = angle % 360 							-- garde le reste de 360
	return angle * 0.0174532925				-- 0,0174532925
end


--function to return the angle between two headings
function GetDeltaHeading(h1, h2)
	local delta = h2 - h1
	if delta > 180 then
		delta = delta - 360
	elseif delta <= -180 then
		delta = delta + 360
	end
	return delta
end




--function to return distance between two vector2 points
function GetDistance(p1, p2)

	local c_GetD = os.clock()

	if not p1.x or not p1.y then
		_affiche(p1, "p1")
	end

	if not p2.x or not p2.y then
		_affiche(p2, "p2")
	end

	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y

	local result =  math.sqrt(math.pow(deltax, 2) + math.pow(deltay, 2))

	T_GetD = T_GetD + (os.clock() - c_GetD)

	return result
end




--function to return a new point offset from an initial point
function GetOffsetPoint(point, heading, distance, show)
	-- if show then
	-- 	print("UtilF heading: "..tostring(heading).." distance "..tostring(distance))
	-- 	_affiche(point,"point")
	-- end
	return {
		x = point.x + math.cos(math.rad(heading)) * distance,
		y = point.y + math.sin(math.rad(heading)) * distance
	}
end



-- Retourne la distance minimale entre un point (p3) et un segment (p1-p2),
-- afin d’évaluer rapidement si un trajet intersecte une zone de menace.
--https://www.geeksforgeeks.org/dsa/minimum-distance-from-a-point-to-the-line-segment-using-vectors/
-- Cette version utilise la projection vectorielle pour calculer la
-- distance minimale d’un point à un segment. Cela remplace les calculs
-- d’angles et de trigonométrie (atan2/sin) par une formule directe, ce
-- qui réduit fortement le coût CPU tout en donnant un résultat équivalent.

function GetTangentDistance(p1, p2, p3)

    local c_GetTD = os.clock()

    local x1, y1 = p1.x, p1.y
    local x2, y2 = p2.x, p2.y
    local x3, y3 = p3.x, p3.y

    local dx = x2 - x1
    local dy = y2 - y1

    local len2 = dx * dx + dy * dy
    if len2 == 0 then
        -- p1 et p2 confondus : distance point à point
        local dist = math.sqrt((x3 - x1)^2 + (y3 - y1)^2)
      t_GetTD = T_GetTD + (os.clock() - c_GetTD)
        return dist
    end

    -- Projection du point p3 sur la droite p1-p2 (paramètre t)
    local t = ((x3 - x1) * dx + (y3 - y1) * dy) / len2

    if t < 0 then
        -- Projection avant p1
        local dist = math.sqrt((x3 - x1)^2 + (y3 - y1)^2)
      t_GetTD = T_GetTD + (os.clock() - c_GetTD)
        return dist
    elseif t > 1 then
        -- Projection après p2
        local dist = math.sqrt((x3 - x2)^2 + (y3 - y2)^2)
      t_GetTD = T_GetTD + (os.clock() - c_GetTD)
        return dist
    else
        -- Distance perpendiculaire au segment
        local projx = x1 + t * dx
        local projy = y1 + t * dy
        local dist = math.sqrt((x3 - projx)^2 + (y3 - projy)^2)
      t_GetTD = T_GetTD + (os.clock() - c_GetTD)
        return dist
    end
end


--function to return lenght of a line from p1 to p2 that is within a circle c with radius r
function GetTangentLenght(p1, p2, pc, r)
	local p1_pc = GetDistance(p1, pc)
	local p2_pc = GetDistance(p2, pc)
	local p1_p2 = GetDistance(p1, p2)

	if (p1.x == pc.x and p1.y == pc.y) or (p2.x == pc.x and p2.y == pc.y) then			--p1 or p2 are the center of the circle
		if p1_p2 > r then																--the other point is outside of the circle
			return r																	--return the circle radius
		else																			--the other point is inside the cicle
			return p1_p2																--return distance from p1 to p2
		end
	elseif p1_pc < r and p2_pc < r then													--p1 and p2 are in circle
		return p1_p2																	--return distance from p1 to p2
	elseif p1_pc < r then																--only p1 is in circle
		local p1_p2_heading = GetHeadingDegre(p1, p2)										--heading from p1 to p2
		local p1_pc_heading = GetHeadingDegre(p1, pc)										--heading from p1 to pc
		local alpha = math.abs(p1_p2_heading - p1_pc_heading)							--angle in deg		
		local a = r
		local b = p1_pc
		local beta = math.deg(math.asin(b * math.sin(math.rad(alpha)) / a))
		local gamma = 180 - alpha - beta
		local c = a * math.sin(math.rad(gamma)) / math.sin(math.rad(alpha))
		return math.abs(c)
	elseif p2_pc < r then																--only p2 is in circle
		local p2_p1_heading = GetHeadingDegre(p2, p1)										--heading from p2 to p1
		local p2_pc_heading = GetHeadingDegre(p2, pc)										--heading from p2 to pc
		local alpha = math.abs(p2_p1_heading - p2_pc_heading)							--angle in deg		
		local a = r
		local b = p2_pc
		local beta = math.deg(math.asin(b * math.sin(math.rad(alpha)) / a))
		local gamma = 180 - alpha - beta
		local c = a * math.sin(math.rad(gamma)) / math.sin(math.rad(alpha))
		return math.abs(c)
	else																				--neither p1 or p2 is in circle
		local t = GetTangentDistance(p1, p2, pc)
		return 2 * math.sqrt(math.pow(r, 2) - math.pow(t, 2))
	end
end


--function to check if point is in polygon
--function repris de Mbot dans DC_NavalEnvironment
function CheckPointInPolygonINIT(point, poly)
	local crossings = 0
	for n = 1, #poly - 1 do
		if (poly[n].y < point.y and poly[n + 1].y > point.y) or (poly[n].y > point.y and poly[n + 1].y < point.y) then
			local dx = poly[n + 1].x - poly[n].x
			local dy = poly[n + 1].y - poly[n].y
			local delta_point_y = point.y - poly[n].y
			local delta_point_x = dx / dy * delta_point_y
			if poly[n].x + delta_point_x > point.x then
				crossings = crossings + 1
			end
		end
	end
	if crossings % 2 ~= 0 then
		return true
	else
		return false
	end
end

--https://stackoverflow.com/questions/31730923/check-if-point-lies-in-polygon-lua
function CheckPointInPolygon(point, polygon, show)
    local oddNodes = false
    local j = #polygon
    for i = 1, #polygon do

        if (polygon[i].y < point.y
		and polygon[j].y >= point.y
		or polygon[j].y < point.y
		and polygon[i].y >= point.y) then
            if (polygon[i].x + ( point.y - polygon[i].y ) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) then
                oddNodes = not oddNodes;
            end
        end
        j = i;
    end
    return oddNodes
end

