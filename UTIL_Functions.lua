--Various functions
------------------------------------------------------------------------------------------------------- 
-- last modification: debug_k
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Functions.lua"] = "1.17.131"
------------------------------------------------------------------------------------------------------- 
-- cleancode_g				(g springCleaning)					
-- adjustment_o				(n loadout code)(m Disp_time)(l add AFAC task)(k FormatTime)(i add InsertBugList(txt))(h use IsWesternCountry)(fg: add Loadout tiers)(e todo)(d:CheckConfModMaster )(c: fire Playable_m from conf_mod)
-- debug_k					(k Package_freq-targetname)(j code_loadout bestMatch)(i planeType)(h Tha\'lah)(g string.gsub(v, "\"", "\\\"" ))(f new generateId)(d UH to HF) Angle et Bearing des statics sur PA
-- modification M80_a		use various tables, such as base name or aircraft type aliases
-- modification M78_a		LatLon positions added and unit display removed on MAP F10 (a LL_KnownPositionsTable)
-- modification M77_l		CG_ArtySpotter (kl ListSpotterAircraft)
-- modification M63_a		compatible Datacard Generator or CombatFlite
-- modification M61_a		SAR
-- modification M56_a		AssignCallnameSquad
-- modification M53_d		automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M49_h		big central db_loadout (h buildsLoadout)(g emport.num)(b: routine Check)
-- modification M47_c		keeps the history of the campaign files (c: save debugging information during mission generation)
-- modification M43_d		assignation des numeros de parking du type C08 (d: bug static, solution : NbPlaneTot)
-- modification M41			Scratchpad written in the Sratchpad file, if this modul is installed
-- modification M38_z		Check and Help CampaignMaker (z new file name: UTIL_ConfModCheck) (s jammer)(pq infos)(e: helps to balance the game (type "Z" in firstmission.bat))(d: checks only the right  theatre) (c: Check conf_mod)
-- modification M34_Bk		custom FrequenceRadio (k FreqCapability)(FreqCapability2)(Bd_z guard)(debug Tanker NoRadio)(q: LVHF & CommunFrequency)(p: mil impossible M2000)(mno: freq group bug)(i  3 frequency bands)(g: VHF helicopter)(h: bug Gazelle)
-- modification M17_f		Option F-14B & All AddPropAircraft
------------------------------------------------------------------------------------------------------- 

--variable global
DCS_Side = {"blue", "red", "neutrals"}

DCS_ENI_Side = {
	["blue"] = "red",
	["red"] = "blue"
	}

	-- airbase = { 25, 12, 20, 15, 0 },
	-- runWay = { 25, 12, 20, 15, 0 },
	-- SAM = { 25, 12, 20, 15, 0 },
	-- EWR = { 25, 12, 20, 15, 0 },
	-- bridge = { 25, 12, 20, 15, 0 },
	-- generic = { 25, 12, 20, 15, 0 },

Attribut2Target = {
	["airbase"] = "airbase",
	["base"] = "airbase",	
	["Runway"] = "runway",
	["sam"] = "sam",
	["ewr"] = "ewr",
	["bridge"] = "bridge",
}


AllIdGroup = {}
AllIdUnit = {}
UnitByName = {}						-- table de tous les unitId généré, utile pour placer le TACAN sur l'unitId qui est demandé avant la génération du l'unité

-- UnitByName = UnitByName or {}						-- table de tous les unitId généré, utile pour placer le TACAN sur l'unitId qui est demandé avant la génération du l'unité



Assigned_freq = {}

Package_freq = {															--table to store frequencies assigned to packages
	["blue"] = {
		["UHF"] = {},
		["VHF"] = {},
		-- ["FM"] = {},
		["LVHF"] = {},
		["HF"] = {},
	},
	["red"] = {
		["UHF"] = {},
		["VHF"] = {},
		-- ["FM"] = {},
		["LVHF"] = {},
		["HF"] = {},
	},
}

--function to return txt whith carriage return
function StringToTxt(text)
	text = string.gsub(text, "\\n", "\n")
	return text
end

--function to return txt whith carriage return for Sratchpad
-- modification M41
function StringToTxtBrief(text)
	if type(text) == "string" then
		text = string.gsub(text, "\\n", " \\\n")
		return text
	else
		return  text
	end
end

--//####################### file function:
function FileExists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	else
		return false
	end
end

-- sorts tables alphabetically, to be used in a "for" loop instead of pairs or ipairs
-- http://www.lua.org/pil/19.3.html
function PairsByKeys (t, f)
    local a = {}
	local initType
	local dontSort = false
    for n in pairs(t) do initType = type(n) break end
	for n in pairs(t) do
		table.insert(a, n)
		if type(n) ~= initType then dontSort = true end
	end
	if not dontSort then
		table.sort(a, f)
	end
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

--function to turn a table into a string
function TableSerializationAG(t, i)

	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do																	--controls the indent for the current text line
		tab = tab .. "\t"
	end
	for k,v in pairs(t) do
		if type(k) == "string" then
			text = text .. tab .. "['" .. k .. "'] = "
		else
			text = text .. tab .. "[" .. k .. "] = "
		end
		if type(v) == "string" then
			text = text .. "'" .. v .. "',\n"
		elseif type(v) == "number" then
			text = text .. v .. ",\n"
		elseif type(v) == "table" then
			text = text .. TableSerializationAG(v, i + 1)
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
	if i == 0 then
		text = text .. tab .. "}\n"														--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"													--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end

--function to turn a table into a string
function TableSerialization(t, i, params)

	local crlf = ""
	local tab1 = ""
	for n = 1, i do																	--controls the indent for the current text line
		tab1 = tab1 .. "\t"
	end

	local text = "\n"..crlf..tab1.."{\n"..crlf

	local tab = ""
	for n = 1, i + 1 do																	--controls the indent for the current text line
		tab = tab .. "\t"
	end

	-- if params then
	-- 	table.sort(t, function(a,b) return a[params] > b[params]  end)
	-- end
	local stop = false
	for k,v in PairsByKeys(t) do
		if type(k) == "string" then
			k = string.gsub(k, "\n", "\\\n" )
			k = string.gsub(k, "\"", "\\\"" )
			k = string.gsub(k, "'", "\\\'" )
			text = text .. tab .. '["' .. k .. '"] = '
		else
			text = text .. tab .. "[" .. k .. "] = "
		end
		if type(v) == "string" then
			v = string.gsub(v, "\n", "\\\n" )
			v = string.gsub(v, "\"", "\\\"" )
			v = string.gsub(v, "'", "\\\'" )
			text = text .. '"' .. v .. '",\n'..crlf
		elseif type(v) == "number" then
			text = text .. v .. ",\n"..crlf
		elseif type(v) == "table" then
			text = text .. TableSerialization(v, i + 1)
		elseif type(v) == "boolean" then
			if v == true then
				text = text .. "true,\n"..crlf
			else
				text = text .. "false,\n"..crlf
			end
		elseif type(v) == "function" then
			text = text .. v .. ",\n"..crlf
		elseif v == nil then
			text = text .. "nil,\n"..crlf
		end
	end
	tab = ""
	for n = 1, i do																		--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"		..crlf												--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"	..crlf												--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end

local loadoutStructures = {
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

local function makeStrutureLoadout(loadoutTotal)

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

function Deepcopy(orig, copies)
    copies = copies or {}  -- Table pour suivre les références déjà copiées

    if type(orig) ~= 'table' then return orig end  -- Copie simple des types de base

    if copies[orig] then return copies[orig] end  -- Si déjà copié, éviter boucle infinie

    local copy = {}
    copies[orig] = copy  -- Stocker la copie pour éviter de repasser sur la même table

    for orig_key, orig_value in pairs(orig) do
        copy[Deepcopy(orig_key, copies)] = Deepcopy(orig_value, copies)
    end

    setmetatable(copy, Deepcopy(getmetatable(orig), copies))
    return copy
end


-- --function to make a deep copy of a table
-- function Deepcopy(orig)
--     -- local orig_type = type(orig)
--     -- local copy
--     -- if orig_type == 'table' then
--     --     copy = {}
--     --     for orig_key, orig_value in next, orig, nil do
--     --         copy[Deepcopy(orig_key)] = Deepcopy(orig_value)
--     --     end
--     --     setmetatable(copy, Deepcopy(getmetatable(orig)))
--     -- else -- number, string, boolean, etc
--     --     copy = orig
--     -- end
--     -- return copy



-- 		local copy
-- 		if type(orig) == 'table' then
-- 			copy = {}
-- 			for orig_key, orig_value in pairs(orig) do
-- 				copy[orig_key] = Deepcopy(orig_value)
-- 			end
-- 			setmetatable(copy, Deepcopy(getmetatable(orig)))
-- 		else
-- 			copy = orig
-- 		end
-- 		return copy
	

-- end


--function to return heading between two vector2 points
-- return une valeur en degré par rapport au nord géographique (pas le cercle trigonometrique)
function GetHeading(p1, p2)
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

	if not p1.x then
		_affiche(p1, "p1")
	end

	if not p2.x then
		_affiche(p2, "p2")
	end

	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y
	return math.sqrt(math.pow(deltax, 2) + math.pow(deltay, 2))
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


--function to return closest distance of point p3 to the line p1 to p2
function GetTangentDistance(p1, p2, p3)
	local p1_p2_heading = GetHeading(p1, p2)
	local p1_p3_heading = GetHeading(p1, p3)
	local alpha = math.abs(p1_p2_heading - p1_p3_heading)
	if alpha > 180 then
		alpha = math.abs(alpha - 360)
	end
	local p1_p3_distance = GetDistance(p1, p3)

	local p2_p1_heading = GetHeading(p2, p1)
	local p2_p3_heading = GetHeading(p2, p3)

	local beta = math.abs(p2_p1_heading - p2_p3_heading)
	if beta > 180 then
		beta = math.abs(beta - 360)
	end
	local p2_p3_distance = GetDistance(p2, p3)

	if alpha > 90 or alpha < -90 then
		return p1_p3_distance
	elseif beta > 90 or beta < -90 then
		return p2_p3_distance
	elseif GetDistance(p1, p2) == 0 then
		return p1_p3_distance
	else
		return math.abs(math.sin(math.rad(alpha)) * p1_p3_distance)
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
		local p1_p2_heading = GetHeading(p1, p2)										--heading from p1 to p2
		local p1_pc_heading = GetHeading(p1, pc)										--heading from p1 to pc
		local alpha = math.abs(p1_p2_heading - p1_pc_heading)							--angle in deg		
		local a = r
		local b = p1_pc
		local beta = math.deg(math.asin(b * math.sin(math.rad(alpha)) / a))
		local gamma = 180 - alpha - beta
		local c = a * math.sin(math.rad(gamma)) / math.sin(math.rad(alpha))
		return math.abs(c)
	elseif p2_pc < r then																--only p2 is in circle
		local p2_p1_heading = GetHeading(p2, p1)										--heading from p2 to p1
		local p2_pc_heading = GetHeading(p2, pc)										--heading from p2 to pc
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


--function to return subsequent IDs


--recupere les Id deja utilise pour ne pas creer de doublon
function GetAllId()

	AllIdGroupImport = false		--deprecate?
	AllIdUnitImport = false		--deprecate?

	local groupIdError = {}
	local unitIdError = {}

	--recupere les Id deja utilise pour ne pas creer de doublon
	for coal_name,coal in pairs(oob_ground) do
		for countryN, country in pairs(coal) do
			for category, groups in pairs(country) do
				if type(groups) == "table" and groups["group"]  then
					for Ngroup, group in pairs(groups["group"]) do

						if not AllIdGroup[group.groupId] then
							AllIdGroup[group.groupId] = true
							AllIdGroupImport = true
						else
							table.insert(groupIdError,group.groupId )
							-- print("UtilF F1 found groupIdError ID "..tostring(group.groupId).." name: "..tostring(group.name))
						end

						for Nunit, unit in pairs(group.units) do

							if not AllIdUnit[unit.unitId] then
								AllIdUnit[unit.unitId] = true
								AllIdUnitImport = true
							else
								table.insert(unitIdError, unit.unitId )
								-- print("UtilF F2 found unitIdError ID "..tostring(unit.unitId).." name: "..tostring(unit.name))
							end
						end
					end
				end
			end
		end
	end

	if unitIdError and #unitIdError > 0 then
		for errorN, IdError in pairs(unitIdError) do
			for coal_name,coal in pairs(oob_ground) do
				for countryN, country in pairs(coal) do
					for category, groups in pairs(country) do
						if type(groups) == "table" and groups["group"]  then
							for Ngroup, group in pairs(groups["group"]) do
								for Nunit, unit in pairs(group.units) do
									if IdError == unit.unitId then
										unit.unitId = GenerateIDUnit(unit.name)
										if Debug.debug then
											print("UtilF PP found NEW ID| "..tostring(unit.unitId).." |unit.NAME:| "..tostring(unit.name))
										end
									end
								end
							end
						end
					end
				end
			end
			-- os.execute 'pause'
		end
	end

	if groupIdError and #groupIdError > 0 then
		for errorN, IdError in pairs(groupIdError) do
			for coal_name,coal in pairs(oob_ground) do
				for countryN, country in pairs(coal) do
					for category, groups in pairs(country) do
						if type(groups) == "table" and groups["group"]  then
							for Ngroup, group in pairs(groups["group"]) do

								if IdError == group.groupId then
									group.groupId = GenerateIDGroup(group.name)
									if Debug.debug then
										print("UtilF PP found NEW ID| "..tostring(group.groupId).." |group.NAME:| "..tostring(group.name))
									end
								end

							end
						end
					end
				end
			end
		end
	end

end



local idGroupCounter = 100000
function GenerateIDGroup(name)
	if not AllIdUnitImport or not AllIdGroupImport then
		GetAllId()
	end

	local loop = 1
	repeat
		idGroupCounter = idGroupCounter + 1
		loop = loop+1
		-- if AllIdGroup[idGroupCounter] then
		-- 	-- print("UtilF  GenerateIDGroup IDGroup déjà utilisé: "..tostring(idGroupCounter))
		-- 	-- os.execute 'pause'
		-- end
	until not AllIdGroup[idGroupCounter] or loop > 5000
	if loop > 5000 then
		print("UtilF Bug GenerateIDGroup idGroupCounter "..tostring(idGroupCounter))
		os.execute 'pause'
	end
	AllIdGroup[idGroupCounter] = true

	-- print("UtilsF passe AA2 idGroupCounter "..idGroupCounter.." NAME: "..tostring(name))
	return idGroupCounter
end

local idUnitCounter = 100000
function GenerateIDUnit(name)

	if not AllIdUnitImport or not AllIdGroupImport then
		GetAllId()
	end

	local loop = 1
	repeat
		idUnitCounter = idUnitCounter + 1
		loop = loop+1
	until not AllIdUnit[idUnitCounter] or loop > 5000

	if loop > 5000 then
		print("UtilF Bug GenerateIDUnit loop > 5000 "..tostring(idUnitCounter))
		os.execute 'pause'
	end
	AllIdUnit[idUnitCounter] = true
	UnitByName[name] = idUnitCounter

	return idUnitCounter
end

-- id_counter = 100000
-- function GenerateID()
-- 	local id = id_counter
-- 	id_counter = id_counter + 1
-- 	return id
-- end

function Disp_time(time)
	local days = math.floor(time/86400)
	local hours = math.floor((time% 86400)/3600)
	local minutes = math.floor((time%3600)/60)
	local seconds = math.floor((time%60))
	return string.format("%d days %02d hours",days,hours)
  end


--function to return various date and time formats of a number in seconds
function FormatTime(t, form)
	local hour
	local minute
	local second

	if t >= 86400 then
		t= t - 86400
	end

	hour = math.floor(t / 3600)
	t = t - hour * 3600
	if hour < 10 then
		hour = "0" .. hour
	end

	minute = math.floor(t / 60)
	t = t - minute * 60
	if minute < 10 then
		minute = "0" .. minute
	end

	second = math.floor(t)
	if second < 10 then
		second = "0" .. second
	end

	if form == "hh:mm" then
		minute =  math.floor(minute + 0.5)
		if minute < 10 then
			minute = "0" .. minute
		end
		return hour .. ":" .. minute
	elseif form == "hh:mm:ss" then
		return hour .. ":" .. minute .. ":" .. second
	end
end


--function to format date
function FormatDate(day, month, year)
	if month == 1 then
		month = "January"
	elseif month == 2 then
		month = "February"
	elseif month == 3 then
		month = "March"
	elseif month == 4 then
		month = "April"
	elseif month == 5 then
		month = "May"
	elseif month == 6 then
		month = "June"
	elseif month == 7 then
		month = "July"
	elseif month == 8 then
		month = "August"
	elseif month == 9 then
		month = "September"
	elseif month == 10 then
		month = "October"
	elseif month == 11 then
		month = "November"
	elseif month == 12 then
		month = "December"
	end

	return month .. " " .. day .. ", " .. year
end


--function to format altitude in metric or imperial measurement
function FormatDistance(a, unitsUse)
	a = a / 1000																			--round to km
	if unitsUse == "metric" or unitsUse =="russian" then															--metric units
		a = math.floor(a) .. " km"															--kilometers
	else 													--imperial units
		a = a * 0.539957																	--covert to nm
		a = math.floor(a) .. " nm"															--nautical miles
	end
	return a
end


--function to format altitude in metric or imperial measurement
function FormatAlt(a, unitsUse)
	if unitsUse == "metric" or unitsUse =="russian" then															--metric units
		a = math.ceil(a / 10) * 10															--round to tens
		if a <= 1000 then																	--for altitudes until 1000m
			a = a .. " m AGL"																--meters AGL
		else
			a = a .. " m MSL"																--meters MSL
		end
	else													--imperial units
		a = a * 3.28																		--covert to feet
		a = math.ceil(a / 100) * 100														--round to hunderts
		if a <= 3300 then																	--for altitudes until 3300ft
			a = a .. " ft AGL"																--feet AGL
		else
			a = a .. " ft MSL"																--feet MSL
		end
	end
	return a
end


--function to format speed in metric or imperial measurement
function FormatSpeed(a, unitsUse)
	if  unitsUse == "metric" or unitsUse =="russian" then															--metric units
		a = a * 3.6
		a = math.floor(a / 10) * 10															--round to tens
		a = a .. " kph"																		--km per hour
	else												--imperial units
		a = a * 1.94																		--covert to knots
		a = math.floor(a / 5) * 5															--round to fives
		a = a .. " kts"																		--knots
	end
	return a
end


--function to replace certain type names
function ReplaceTypeName(s)
	if TypeAlias and TypeAlias[s] then
		return TypeAlias[s]
	else
		return s
	end
end

--function to replace certain type names Init\various_table.lua
function ReplaceBaseName(s)
	if BaseNameAlias and BaseNameAlias[s] then
		return BaseNameAlias[s]
	else
		return s
	end
end

-- -- Fonction récursive pour itérer sur la table
-- function Display(t, indent)
--     indent = indent or ""
--     for key, value in pairs(t) do
--         if type(value) == "table" then
--             print(indent .. tostring(key) .. ":")
--             Display(value, indent .. "  ")
--         else
--             print(indent .. tostring(key) .. ": " .. tostring(value))
--         end
--     end
-- end

-- Fonction récursive pour afficher une table en évitant les erreurs
function Display(t, indent)
    indent = indent or ""

    if type(t) ~= "table" then
        print(indent .. tostring(t)) -- Affiche directement la valeur si ce n'est pas une table
        return
    end

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(indent .. tostring(key) .. ":")
            Display(value, indent .. "  ")
        else
            print(indent .. tostring(key) .. ": " .. tostring(value))
        end
    end
end

function _affiche(_table, titre, prof)

 if not prof or prof == nil then prof = 999 end 						-- prof = profondeur de niveau dans la hierarchie
  print()
   print()
    print()
    if titre == nil then print( string.format(" _affiche() titre = nil "))
    elseif type( titre) == "string" then
		print( string.format(" _affiche(titre) "..tostring(titre)))
	end

	if type( _table) == "table"  then

		for a, b in pairs(_table) do

			if  type(b) ~= "table" then
				print(" _affiche(a b)    |"..tostring(a).."|"..tostring(b).."|")
			elseif type(b) == "table"   and prof >= 2 then
				for c, d in pairs(b) do
					print( " _affiche(a c)     "..tostring(a).."   "..tostring(c))


					if type(d)~= "table"  then
						print( " _affiche(d)                "..tostring(d))
					elseif type(d) == "table"  and prof >= 3 then
						for e, f in pairs(d) do

							if type( f ) ~= "table"  then
								print( " _affiche(e f)                          "..tostring(e).." "..tostring(f))
							elseif type( f ) == "table"  and prof >= 4 then
								for g, h in pairs(f) do
									print( " _affiche(  e)                     "..tostring(e))

									if type( h ) ~= "table"  then
										print( " _affiche(g h)                                    "..tostring(g).." "..tostring(h))
									elseif type( h ) == "table"  and prof >= 5 then
										for i, j in pairs(h) do

											if type( j ) ~= "table"  then
												print( " _affiche(i j)                                              "..tostring(i).." "..tostring(j))
											elseif type( j ) == "table" and prof >= 6 then
												for k, l in pairs(j) do
													print( " _affiche(k)                                                   "..tostring(k))

													if type( l ) ~= "table"  then
														print( " _affiche(l)                                                   "..tostring(l))
													elseif type( l ) == "table" and prof >= 7 then
														for m, n in pairs(l) do
															print( " _affiche(m)                                                        "..tostring(m))

															if type( n ) ~= "table"  then
																print( " _affiche(n)                                                             "..tostring(n))
															elseif type( n ) == "table"  and prof >= 8 then
																print( " n est une table                                                              "..tostring(n).."---------------------------")

															end --if
														end --for l
													end --if
												end -- for j
											end --if
										end -- for h
									end --if
								end --for f
							end --elseif
						end -- for d
					end -- if d
				end -- for v
			end -- if v
		end  -- for _table

	else print( "_affiche NoTable==> " ..tostring(_table))

	end -- if if type( _table) == "table"

end -- function affiche


function _afficheTXT(_table, titre, prof)

	--export custom mission log
	local logExp = "logExp  "

	if not prof or prof == nil then prof = 999 end 						-- prof = profondeur de niveau dans la hierarchie
	logExp = logExp.."\n"

    if titre == nil then logExp = logExp.. string.format(" _affiche() titre = nil ")
    elseif type( titre) == "string" then
		logExp = logExp.. string.format(" _affiche(titre) "..tostring(titre)).."\n"
	end

	if type( _table) == "table"  then --and  (table.getn(_table) ~= 0 or table.getn(_table) ~= nil

		for a, b in pairs(_table) do --for a, b in pairs(event.initiator) do --for a, b in pairs(_ammo) do

			if  type(b) ~= "table" then
				logExp = logExp.." _affiche (a b)     "..tostring(a).." "..tostring(b).."\n"
			elseif type(b) == "table"   and prof >= 2 then
				for c, d in pairs(b) do
					logExp = logExp.. " _affiche(a c)           "..tostring(a).." "..tostring(c).."\n"


					if type(d)~= "table"  then
						logExp = logExp.. " _affiche(d)                "..tostring(d).."\n"
					elseif type(d) == "table"  and prof >= 3 then
						for e, f in pairs(d) do

							if type( f ) ~= "table"  then
								logExp = logExp.. " _affiche(e f)                          "..tostring(e).." "..tostring(f).."\n"
							elseif type( f ) == "table"  and prof >= 4 then
								logExp = logExp.. " _affiche( e)                                "..tostring(e).."\n"
								for g, h in pairs(f) do
									logExp = logExp.. " _affiche(Ig)                                 "..tostring(g).."\n"


									if type( h ) ~= "table"  then
										logExp = logExp.. " _affiche(g h)                                    "..tostring(g).." "..tostring(h).."\n"
									elseif type( h ) == "table"  and prof >= 5 then
										logExp = logExp.. " _affiche( g)                                         "..tostring(g).."\n"
										for i, j in pairs(h) do

											if type( j ) ~= "table"  then
												logExp = logExp.. " _affiche(i j)                                              "..tostring(i).." "..tostring(j).."\n"
											elseif type( j ) == "table" and prof >= 6 then
												logExp = logExp.. " _affiche(i)                                                  "..tostring(i).."\n"
												for k, l in pairs(j) do

													if type( l ) ~= "table"  then
														logExp = logExp.. " _affiche(k l)                                                   "..tostring(k).." "..tostring(l).."\n"
													elseif type( l ) == "table" and prof >= 7 then
														logExp = logExp.. " _affiche(k)                                                       "..tostring(k).."\n"
														for m, n in pairs(l) do
															logExp = logExp.. " _affiche(m)                                                        "..tostring(m).."\n"


															if type( n ) ~= "table"  then
																logExp = logExp.. " _affiche(m n)                                                   "..tostring(m).." "..tostring(n).."\n"
															elseif type( n ) == "table" and prof >= 7 then
																logExp = logExp.. " _affiche(m)                                                       "..tostring(m).."\n"
																for o, p in pairs(n) do
																	logExp = logExp.. " _affiche(o)                                                        "..tostring(o).."\n"


																	if type( p ) ~= "table"  then
																		logExp = logExp.. " _affiche(p)                                                             "..tostring(p).."\n"
																	elseif type( p ) == "table"  and prof >= 8 then
																		logExp = logExp.. " p est une table                                                              "..tostring(p).."---------------------------".."\n"

																	end
																end
															end --if
														end --for l
													end --if
												end -- for j
											end --if
										end -- for h
									end --if
								end --for f
							end --elseif
						end -- for d
					end -- if d
				end -- for v
			end -- if v
		end  -- for _table

	else logExp = logExp.. "_affiche NoTable==> " ..tostring(_table).."\n"

	end -- if if type( _table) == "table"

	return logExp

end -- function affiche


function FreqCapability2(TestFreq, flightType, Nradio, info)
	local waves  = ""

	if not frequency[flightType] then
		--si le type de plane n'est pas dans la liste, c'est qu'il n'est pas jouable et donc que tout passe, au niveau radio
		return true
	end
	local RadioPlane = frequency[flightType].radio

	if type(TestFreq) == "table" then
		return false
	elseif type(TestFreq) == "string" then
		TestFreq = tonumber(TestFreq)
		if type(TestFreq) ~= "number" then
			return false
		end
	end
	if not RadioPlane[Nradio] or RadioPlane[Nradio] == nil then
		return false
	end
	-- modification M34.n (n: bestCapability)
	for wave, freqRange in pairs(RadioPlane[Nradio]) do
		-- if string.lower(wave)  ~= "nbcanal"  then
		if type(freqRange)  == "table"  then
			if tonumber(TestFreq) < freqRange.max and  tonumber(TestFreq) > freqRange.min then
				if RadioPlane[Nradio] and RadioPlane[Nradio][wave] and (TestFreq > RadioPlane[Nradio][wave].min and TestFreq < RadioPlane[Nradio][wave].max)	 then
					return true
				end
			end
		end
	end

	if TestFreq >= 225 then
		waves = "UHF"
	elseif TestFreq >= 100 and TestFreq < 225 then
		waves = "VHF"
	elseif TestFreq >= 20 and TestFreq < 100 then
		waves = "LVHF"
		if RadioPlane[Nradio] and not RadioPlane[Nradio][waves] then waves = "LVHF" end
	elseif TestFreq >= 1 and TestFreq < 20 then
		waves = "HF"
	else
		print()
		print("********************ATTENTION******************")
		print("***************Note for the Campaign Maker*****")
		print("Problem with frequency UFF? VHF? LVHF? HF? frequence: "..tostring(TestFreq).." Info: "..tostring(info))
		_affiche(RadioPlane, "RadioPlane")
		print("********************ATTENTION******************")
		print()
		os.execute 'pause'
	end

	if RadioPlane[Nradio] and RadioPlane[Nradio][waves] and (TestFreq > RadioPlane[Nradio][waves].min and TestFreq < RadioPlane[Nradio][waves].max)	 then
		return true
	else
		return false
	end
end

--function pour assigner les fr�quences pour tout le monde, Plane and vehicle (EWR)
-- modification M34.i  custom FrequenceRadio (i  3 frequency bands)(g: VHF helicopter)(h: bug Gazelle)

function CreatePlageFrequency()																				--trouve une plage de frequence commune si c'est possible
	local activeVHF = false
	camp.radio = {}

	local TempRadio = {
		["blue"] = {
			-- [1] = {
			-- },
		},
		["red"] = {
			-- [1] = {
			-- },
		},
	}

	-- modification M38.g (g: prise en compte des 3 bandes de fr�quence)(e: priority to the player's frequencies)
	for side, oob_side in pairs(oob_air) do
		for n, sqd in pairs(oob_side) do
			if not sqd.inactive and sqd.player then
				if frequency[sqd.type] then
					for n = 1,  #frequency[sqd.type].radio do
						for bandFreq, value in pairs(frequency[sqd.type].radio[n]) do
							if bandFreq == "HF" or bandFreq == "VHF" or bandFreq == "UHF" or bandFreq == "LVHF"  then			--or bandFreq == "FM"					

								if not TempRadio[side][n] then TempRadio[side][n] = {} end
								if not TempRadio[side][n][bandFreq] then TempRadio[side][n][bandFreq] = {} end

								TempRadio[side][n][bandFreq].min = value.min
								TempRadio[side][n][bandFreq].max = value.max
							end
						end
					end
				end
			end
		end
	end
	-- _affiche(TempRadio, "UTIL_F 1er TempRadio")

	for side, oob_side in pairs(oob_air) do
		for n, sqd in pairs(oob_side) do
			if not sqd.inactive then
				if frequency[sqd.type] then
					for typeRadio , PlaneFreqRadio in pairs(frequency[sqd.type]) do
						if typeRadio == "radio" and type(PlaneFreqRadio) == "table" then
							for nr , _bandFreq in pairs(PlaneFreqRadio) do	--for nr , value in pairs(frequency[sqd.type].radio) do
								for bandFreq , value in pairs(_bandFreq) do
									if bandFreq == "HF" or bandFreq == "LVHF" or bandFreq == "VHF" or bandFreq == "UHF" then

										if not TempRadio[side][nr] then TempRadio[side][nr] = {} end
										if not TempRadio[side][nr][bandFreq] then TempRadio[side][nr][bandFreq] = {} end
										if not TempRadio[side][nr][bandFreq].min then TempRadio[side][nr][bandFreq].min = value.min  end
										if not TempRadio[side][nr][bandFreq].max then TempRadio[side][nr][bandFreq].max = value.max  end

										if (value.min < TempRadio[side][nr][bandFreq].max)  then								--si une plage radio est en dehors des autres, on privil�gie le joueur
											if value.min > TempRadio[side][nr][bandFreq].min then
												TempRadio[side][nr][bandFreq].min =  value.min
											end

											if (value.max < TempRadio[side][nr][bandFreq].max) and (value.max > TempRadio[side][nr][bandFreq].min )  then
												TempRadio[side][nr][bandFreq].max =  value.max
											end
										end

										if sqd.player and TempRadio[side][1][bandFreq] then
											-- print("sqd.type "..tostring(sqd.type))
											TempRadio[side][1][bandFreq]["player"] = true
										end

									end
								end
							end
						elseif typeRadio == "frequency"  then											-- frequence de base utilis� par FC3 ou gazelle
								print("UTIL_F Type No Frequency FC3? "..sqd.type)
						end
					end
				else
					-- print("UTIL_F Type No Frequency "..sqd.type)
				end
			end
		end
	end

	camp.radio = TempRadio
	-- _affiche(camp.radio, "UTIL_F camp.radio")


	--*****************************************************************************   radioC   ********

	camp.radioC = {}

	local TempRadio = {
		["blue"] = {},
		["red"] = {},
	}

	for side, oob_side in pairs(oob_air) do
		for n, sqd in pairs(oob_side) do
			if not sqd.inactive and sqd.player then
				if frequency[sqd.type] then
					for n = 1,  #frequency[sqd.type].radio do
						for bandFreq, value in pairs(frequency[sqd.type].radio[n]) do
							if bandFreq == "HF" or bandFreq == "VHF" or bandFreq == "UHF" or bandFreq == "LVHF"  then			--or bandFreq == "FM"					

								if not TempRadio[side][bandFreq] then
									TempRadio[side][bandFreq] = {
										min = value.min,
										max = value.max,
									}
								end

							end
						end
					end
				end
			end
		end
	end

	for side, oob_side in pairs(oob_air) do
		for n, sqd in pairs(oob_side) do
			if not sqd.inactive then
				if frequency[sqd.type] then
					for typeRadio , PlaneFreqRadio in pairs(frequency[sqd.type]) do
						if typeRadio == "radio" and type(PlaneFreqRadio) == "table" then
							for nr , _bandFreq in pairs(PlaneFreqRadio) do	--for nr , value in pairs(frequency[sqd.type].radio) do
								for bandFreq , value in pairs(_bandFreq) do
									if bandFreq == "HF" or bandFreq == "LVHF" or bandFreq == "VHF" or bandFreq == "UHF" then

										if not TempRadio[side][bandFreq] then
											TempRadio[side][bandFreq] = {
												min = value.min,
												max = value.max,
											}
										end

										if (value.min < TempRadio[side][bandFreq].max)  then								--si une plage radio est en dehors des autres, on privil�gie le joueur
											if value.min > TempRadio[side][bandFreq].min then
												TempRadio[side][bandFreq].min =  value.min
											end

											if (value.max < TempRadio[side][bandFreq].max) and (value.max > TempRadio[side][bandFreq].min )  then
												TempRadio[side][bandFreq].max =  value.max
											end
										end

										if sqd.player and TempRadio[side][bandFreq] then
											TempRadio[side][bandFreq]["player"] = true
										end

									end
								end
							end
						elseif typeRadio == "frequency"  then											-- frequence de base utilis� par FC3 ou gazelle
								print("UTIL_F Type No Frequency FC3? "..sqd.type)
						end
					end
				else
					-- print("UTIL_F Type No Frequency "..sqd.type)
				end
			end
		end
	end

	camp.radioC = TempRadio
	-- _affiche(camp.radio, "UTIL_F camp.radio")
end


function CreatePlageFrequencyB()																				--trouve une plage de frequence commune si c'est possible
	local activeVHF = false
	camp.radioB = {}

	local TempRadioB = {
		["blue"] = {
			-- [1] = {
			-- },
		},
		["red"] = {
			-- [1] = {
			-- },
		},
	}

	-- modification M38.g (g: prise en compte des 3 bandes de fr�quence)(e: priority to the player's frequencies)
	-- for side, oob_side in pairs(oob_air) do
		-- for n, sqd in pairs(oob_side) do
			-- if not sqd.inactive and sqd.player then
				-- if frequency[sqd.type] then					
					-- for n = 1,  #frequency[sqd.type].radio do	
						-- for bandFreq, value in pairs(frequency[sqd.type].radio[n]) do
							-- if bandFreq == "FM" or bandFreq == "VHF" or bandFreq == "UHF" or bandFreq == "LVHF" or bandFreq == "HF" then								

								-- if not TempRadio[side][n] then TempRadio[side][n] = {} end	
								-- if not TempRadio[side][n][bandFreq] then TempRadio[side][n][bandFreq] = {} end

								-- TempRadio[side][n][bandFreq].min = value.min
								-- TempRadio[side][n][bandFreq].max = value.max
							-- end
						-- end					
					-- end				
				-- end
			-- end
		-- end
	-- end	
	-- _affiche(TempRadio, "UTIL_F 1er TempRadio")

	for side, oob_side in pairs(oob_air) do
		for n, sqd in pairs(oob_side) do
			if not sqd.inactive then
				if frequency[sqd.type] then
					for typeRadio , PlaneFreqRadio in pairs(frequency[sqd.type]) do
						if typeRadio == "radio" and type(PlaneFreqRadio) == "table" then
							for nr , _bandFreq in pairs(PlaneFreqRadio) do	--for nr , value in pairs(frequency[sqd.type].radio) do
								for bandFreq , value in pairs(_bandFreq) do
									if bandFreq == "HF" or bandFreq == "LVHF" or bandFreq == "VHF" or bandFreq == "UHF" then


										if not TempRadioB[side][bandFreq] then TempRadioB[side][bandFreq] = {} end
										if not TempRadioB[side][bandFreq].min then TempRadioB[side][bandFreq].min = value.min  end
										if not TempRadioB[side][bandFreq].max then TempRadioB[side][bandFreq].max = value.max  end

										if (value.min < TempRadioB[side][bandFreq].max)  then								--si une plage radio est en dehors des autres, on privil�gie le joueur
											if value.min > TempRadioB[side][bandFreq].min then
												TempRadioB[side][bandFreq].min =  value.min
											end

											if (value.max < TempRadioB[side][bandFreq].max) and (value.max > TempRadioB[side][bandFreq].min )  then
												TempRadioB[side][bandFreq].max =  value.max
											end
										end

										if sqd.player and TempRadioB[side][bandFreq] then
											-- print("sqd.type "..tostring(sqd.type))
											TempRadioB[side][bandFreq]["player"] = true
											camp.radioWavePlayer = bandFreq
										end

									end
								end
							end
						elseif typeRadio == "frequency"  then											-- frequence de base utilis� par FC3 ou gazelle
								print("UTIL_F Type No Frequency FC3? "..sqd.type)
						end
					end
				else
					-- print("UTIL_F Type No Frequency "..sqd.type)
				end
			end
		end
	end

	camp.radioB = TempRadioB
	-- _affiche(camp.radioB, "UTIL_F camp.radioB")

end

----- function to assign frquencies to packages -----

-- assigned_AdfFreq = {}														--table to store frequencies in use


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


function FreqCapability(TestFreq, type, Nradio, info)
	local waves  = ""

	if  not frequency[type] or not frequency[type].radio or not frequency[type].radio[Nradio] or frequency[type].radio[Nradio] == nil then
		return false
	end

	local RadioPlane = frequency[type].radio[Nradio]

	for wave, freqRange in pairs(RadioPlane) do
		if wave  == "HF" or wave  == "LVHF" or  wave  == "VHF" or  wave  == "UHF" then
			if freqRange and tonumber(TestFreq) < freqRange.max and  tonumber(TestFreq) > freqRange.min then
				if RadioPlane[wave] and (TestFreq > RadioPlane[wave].min and TestFreq < RadioPlane[wave].max)	 then
					return true
				end
			end
		end
	end

	return false

end

-- from ATO_ThreatEvaluation pour asssigner une frequence EWR al�atoire
-- from ATO_FlightPlan pour assigner une freqence de groupe
function GetFrequency(side, targetname, task, type, waves, overide)
	if Debug.debug then print() end
	if Debug.debug then print("UtilF_Debug GetFrequency 000 side "..tostring(side).." targetname "..tostring(targetname)
		.." task "..tostring(task).." type "..tostring(type).." waves "..tostring(waves).." overide "..tostring(overide)) end
	
	local freq
	local nRadio = 1																					--chose frequency range from radio 1
	if camp.radio[side] and camp.radio[side][2] and (task == "EWR" or task == "AWACS" or task == "Refueling" or task == "AFAC") then			--if player has two radions, chose frequency range from AWACS and tanker from radio 2
		nRadio = 2
	end

	--check si la freq existe dans la radio 1, debug freq groupe
	local tabWave = {"UHF", "VHF", "LVHF", "HF"}
	local function freqValide(checkFreq)
		for nb, Wave in pairs(tabWave) do
			local nRadio = 1
			if frequency[type] and frequency[type].prefFreqPackage then
				nRadio = frequency[type].prefFreqPackage.nRadio
			end
			if checkFreq and frequency[type] then
				if frequency[type]["radio"] then
					for radioN = 1 , #frequency[type]["radio"] do

						if frequency[type]["radio"][radioN][Wave] then

							return true

						end

					end
				end

				return false

				-- if checkFreq and frequency[type] and frequency[type]["radio"] and frequency[type]["radio"][nRadio] and frequency[type]["radio"][nRadio][Wave] then
				-- 	return true
				-- else
				-- 	return false
				-- end
			else
				--pour les avions IA
				return true
			end
		end
	end

	--si la freq package a déjà été désignée, on la reprend
	if task ~= "coalition" and overide == nil then

		if Debug.debug then print("UtilF_Debug GetFrequency 001 targetname? "..tostring(targetname)) end

		if Package_freq[side]["UHF"][targetname] and freqValide(Package_freq[side]["UHF"][targetname]) then
			
			if Debug.debug then print("UtilF_Debug GetFrequency return B1 Package_freq "..tostring(Package_freq[side]["UHF"][targetname])) end
			return Package_freq[side]["UHF"][targetname]															--return frequency
		
		elseif Package_freq[side]["VHF"][targetname] and freqValide(Package_freq[side]["VHF"][targetname]) then
			
			if Debug.debug then print("UtilF_Debug GetFrequency return B2 Package_freq "..tostring(Package_freq[side]["VHF"][targetname])) end
			return Package_freq[side]["VHF"][targetname]															--return frequency
		
		elseif Package_freq[side]["LVHF"][targetname] and freqValide(Package_freq[side]["LVHF"][targetname]) then
			
			if Debug.debug then print("UtilF_Debug GetFrequency return B3 Package_freq "..tostring(Package_freq[side]["LVHF"][targetname])) end
			return Package_freq[side]["LVHF"][targetname]
		
		elseif Package_freq[side]["HF"][targetname] and freqValide(Package_freq[side]["HF"][targetname]) then
			
			if Debug.debug then print("UtilF_Debug GetFrequency return B4 Package_freq "..tostring(Package_freq[side]["HF"][targetname])) end
			return Package_freq[side]["HF"][targetname]
		
		end
	end

	function GetLocFrequency(side, targetname, nRadio, type,  range)

		if task == "EWR" then		-- (range == "UHF" or range == "VHF")  and
			range = camp.radioWavePlayer
			if camp.radio[side][nRadio] and camp.radio[side][nRadio][range]  then		--Cherche d'abord une frequence UHF commune
				repeat
					freq = math.random(camp.radio[side][nRadio][range].min, camp.radio[side][nRadio][range].max - 1)		--find random frequency in mHz
					local deci = math.random(0, 9) / 10									--random first decimal place
					-- local mil = math.random(0, 3) * 25 / 1000							--random second and third decimal place (00/25/50/75)
					local mil = 00														--impossible pour certain avions, comme le M2000
					freq = freq + deci + mil											--combine to complete frequency
				until Assigned_freq[freq] == nil and (freq<242.9 or freq>243.1)			--repeat until a frequency is found that is not yet in use

				Assigned_freq[freq] = true												--mark frequency in use
				Package_freq[side][range][targetname] = freq							--store frequency for package
				
				if Debug.debug then print("UtilF_Debug GetFrequency return C1 Package_freq "..tostring(freq)) end
				return freq																--return frequency
			end

		elseif task == "coalition"   then						--(range == "HF" or range == "FM")
			if range == "HF"  then
				if camp.radioB[side] and camp.radioB[side][range]  then
					freq = 0
					repeat
						freq = math.random(camp.radioB[side][range].min, camp.radioB[side][range].max)		--find random frequency in mHz
						local deci = math.random(0, 9) / 10									--random first decimal place
						local mil = math.random(0, 3) * 25 / 1000							--random second and third decimal place (00/25/50/75)
						-- local mil = 00														--impossible pour certain avions, comme le M2000

						freq = freq + deci + mil											--combine to complete frequency
					until Assigned_freq[freq] == nil										--repeat until a frequency is found that is not yet in use

					Assigned_freq[freq] = true												--mark frequency in use

					if Debug.debug then print("UtilF_Debug GetFrequency return C2 HF Package_freq "..tostring(freq)) end
					return freq																--return frequency
				else

					if Debug.debug then print("UtilF_Debug GetFrequency return C2 HF 0") end
					return 0
				end
			elseif range == "UHF"  then
				if camp.radioB[side] and camp.radioB[side][range]   then		--Cherche d'abord une frequence UHF commune	--and CommonFreq[side]  == 0
					freq = 0
					repeat
						freq = math.random(camp.radioB[side][range].min, camp.radioB[side][range].max - 1)		--find random frequency in mHz
						local deci = math.random(0, 9) / 10									--random first decimal place
						-- local mil = math.random(0, 3) * 25 / 1000							--random second and third decimal place (00/25/50/75)
						local mil = 00														--impossible pour certain avions, comme le M2000

						freq = freq + deci + mil											--combine to complete frequency
					until Assigned_freq[freq] == nil and (freq<242.9 or freq>243.1)			--repeat until a frequency is found that is not yet in use

					Assigned_freq[freq] = true												--mark frequency in use

					if Debug.debug then print("UtilF_Debug GetFrequency return D1 UHF Package_freq "..tostring(freq)) end
					return freq																--return frequency
				else

					if Debug.debug then print("UtilF_Debug GetFrequency return D2 UHF 0") end
					return 0
				end
			elseif range == "VHF"  then
				if camp.radioB[side] and camp.radioB[side][range]   then		--Cherche d'abord une frequence UHF commune	--and CommonFreq[side]  == 0
					freq = 0
					repeat
						freq = math.random(camp.radioB[side][range].min, camp.radioB[side][range].max - 1)		--find random frequency in mHz
						local deci = math.random(0, 9) / 10									--random first decimal place
						-- local mil = math.random(0, 3) * 25 / 1000							--random second and third decimal place (00/25/50/75)
						local mil = 00														--impossible pour certain avions, comme le M2000

						freq = freq + deci + mil											--combine to complete frequency
					until Assigned_freq[freq] == nil and (freq<121.45 or freq>121.55)	and freq ~= 123.1			--repeat until a frequency is found that is not yet in use

					Assigned_freq[freq] = true												--mark frequency in use

					if Debug.debug then print("UtilF_Debug GetFrequency return E1 VHF Package_freq "..tostring(freq)) end
					return freq																--return frequency
				else

					if Debug.debug then print("UtilF_Debug GetFrequency return E2 VHF 0") end
					return 0
				end
			elseif range == "LVHF" then
				if camp.radioB[side] and camp.radioB[side][range]   then
					freq = 0
					repeat
						freq = math.random(camp.radioB[side][range].min, camp.radioB[side][range].max - 1)		--find random frequency in mHz
						local deci = math.random(0, 9) / 10									--random first decimal place
						-- local mil = math.random(0, 3) * 25 / 1000							--random second and third decimal place (00/25/50/75)
						local mil = 00														--impossible pour certain avions, comme le M2000
						freq = freq + deci + mil											--combine to complete frequency
					until Assigned_freq[freq] == nil										--repeat until a frequency is found that is not yet in use
					Assigned_freq[freq] = true												--mark frequency in use

					if Debug.debug then print("UtilF_Debug GetFrequency return F1 LVHF Package_freq "..tostring(freq)) end
					return freq																--return frequency
				else

					if Debug.debug then print("UtilF_Debug GetFrequency return F2 LVHF 0") end
					return 0
				end
			end
		elseif range == "UHF" and task ~= "EWR" then
			-- if camp.radio[side][nRadio] and camp.radio[side][nRadio][range]	and frequency[type] and frequency[type]["radio"] and frequency[type]["radio"][nRadio] and frequency[type]["radio"][nRadio][range]  then		--Cherche d'abord une frequence UHF commune
			if Debug.debug then print("UtilF_Debug GetFrequency return G0 UHF non  EWR frequency[type] "..tostring(frequency[type])) end

			if frequency[type] and frequency[type]["radio"]   then
				for radioN = 1, #frequency[type]["radio"] do
					local passe = true
					if nRadio ~= nil and nRadio ~= radioN then
						passe = false
					end
					for wave, freqRange in pairs(frequency[type]["radio"][radioN]) do
						if wave == range  then
							local i = 1
							repeat
								local rangeMin = camp.radioC[side][range].min
								local rangeMax = camp.radioC[side][range].max
								if freqRange and camp.radioC[side][range].min < freqRange.min then rangeMin = freqRange.min end
								if freqRange and camp.radioC[side][range].max > freqRange.max then rangeMax = freqRange.max end

								freq = math.random(camp.radioC[side][range].min, camp.radioC[side][range].max - 1)
								local deci = math.random(0, 9) / 10									--random first decimal place
								-- local mil = math.random(0, 3) * 25 / 1000							--random second and third decimal place (00/25/50/75)
								local mil = 00														--impossible pour certain avions, comme le M2000
								freq = freq + deci + mil											--combine to complete frequency
							until Assigned_freq[freq] == nil and FreqCapability(freq, type, radioN) and (freq<242.9 or freq>243.1) or i > 1000		--repeat until a frequency is found that is not yet in use

							if i>=1000 then
								print("UtilF          BUG A range "..range .. " with "..tostring(type))
							end

							Assigned_freq[freq] = true												--mark frequency in use
							Package_freq[side][range][targetname] = freq							--store frequency for package

							if Debug.debug then print("UtilF_Debug GetFrequency return G1 UHF non  EWR Package_freq "..tostring(freq)) end
							return freq
						end
					end
				end
			end
		elseif range == "VHF" then

			if Debug.debug then 
				print("UtilF_Debug GetFrequency return H0 VHF non  EWR frequency[type] "..tostring(frequency[type])) 
				Display(frequency[type], "utilF frequency[type]")

				end

			if frequency[type] and frequency[type]["radio"]   then
				for radioN = 1, #frequency[type]["radio"] do
					local passe = true
					if nRadio ~= nil and nRadio ~= radioN then
						passe = false
					end
					for wave, freqRange in pairs(frequency[type]["radio"][radioN]) do
						if wave == range and passe then
							local i = 1
							repeat
								local rangeMin = camp.radioC[side][range].min
								local rangeMax = camp.radioC[side][range].max
								if freqRange and camp.radioC[side][range].min < freqRange.min then rangeMin = freqRange.min end
								if freqRange and camp.radioC[side][range].max > freqRange.max then rangeMax = freqRange.max end

								freq = math.random(rangeMin, rangeMax)
								local deci = math.random(0, 9) / 10									--random first decimal place
								-- local mil = math.random(0, 3) * 25 / 1000							--random second and third decimal place (00/25/50/75)
								local mil = 00														--impossible pour certain avions, comme le M2000
								freq = freq + deci + mil											--combine to complete frequency
								i=i+1

							until Assigned_freq[freq] == nil and FreqCapability(freq, type, radioN) and (freq<121.45 or freq>121.55)	and freq ~= 123.1 or i > 1000		--repeat until a frequency is found that is not yet in use

							if i>=1000 then
								print("UtilF          BUG A range "..range .. " with "..tostring(type))
							end
							Assigned_freq[freq] = true												--mark frequency in use

							if overide ~= nil then
								Package_freq[side][range][targetname] = freq							--store frequency for package
							end
							
							if Debug.debug then print("UtilF_Debug GetFrequency return H1 VHF Package_freq "..tostring(freq)) end
							return freq
						end
					end

				end
			end
		elseif range == "LVHF" then

			if frequency[type] and frequency[type]["radio"]   then
				for radioN = 1, #frequency[type]["radio"] do
					for wave, freqRange in pairs(frequency[type]["radio"][radioN]) do
						if wave == range  then

							repeat
								freq = math.random(camp.radioC[side][range].min, camp.radioC[side][range].max - 1)
							until Assigned_freq[freq] == nil and freq ~= 4125 and freq ~= 5680		--repeat until a frequency is found that is not yet in use

							Assigned_freq[freq] = true												--mark frequency in use
							Package_freq[side][range][targetname] = freq							--store frequency for package
							
							
							if Debug.debug then print("UtilF_Debug GetFrequency return I LVHF Package_freq "..tostring(freq)) end
							return freq
						end
					end
				end
			end
		elseif range == "HF" then

			if frequency[type] and frequency[type]["radio"]   then
				repeat
					freq = math.random(camp.radioC[side][range].min * 10, camp.radioC[side][range].max * 10)		--find random frequency in mHz
				until Assigned_freq[freq] == nil and freq ~= 4125 and freq ~= 5680										--repeat until a frequency is found that is not yet in use

				freq = freq /10
				local freqRemp
				repeat
					-- local deci = math.random(0, 4) 									--random first decimal place
					local mil = math.random(0, 3) * 25 / 1000							--random second and third decimal place (00/25/50/75)
					freqRemp = freq + mil											--combine to complete frequency
				until freqRemp >= camp.radioC[side][range].min and freqRemp <= camp.radioC[side][range].max
				freq = freqRemp

				Assigned_freq[freq] = true												--mark frequency in use
				Package_freq[side][range][targetname] = freq							--store frequency for package
				
				if Debug.debug then print("UtilF_Debug GetFrequency return J HF Package_freq "..tostring(freq)) end
				return freq																--return frequency				
			end
		end
	end

	--TODO faire des functions pour nettoyer ce code
	if type and type ~= nil and  task ~= "coalition" then --and  waves ~= nil 
		if frequency[type] and frequency[type].prefFreqPackage then

			local result = GetLocFrequency(side, targetname, frequency[type].prefFreqPackage.nRadio, type, frequency[type].prefFreqPackage.range)

			if Debug.debug then print("UtilF_Debug GetFrequency return >K result "..tostring(result)) end
			return result
		end
	end

	local result

	if waves == nil or waves == false then
		waves = "UHF"
		local foundUHFwave = false
		if frequency[type] and frequency[type]["radio"] then
			for numRadio = 1, #frequency[type]["radio"] do
				if frequency[type]["radio"][numRadio][waves] then
					foundUHFwave = true
				end
			end

			if not foundUHFwave then
				for waveName, waveTab in pairs( frequency[type]["radio"][1] ) do
					if waveName == "HF" or waveName == "LVHF" or waveName == "VHF" or waveName == "UHF" then
						waves = waveName
					end
				end
			end
		end
	end

	if task == "EWR" then
		if camp.radio[side][1] and camp.radio[side][1]["UHF"] and camp.radio[side][1]["UHF"]["player"] then
			result = GetLocFrequency(side, targetname, nRadio, type,  "UHF")
		elseif camp.radio[side][1] and camp.radio[side][1]["VHF"] and camp.radio[side][1]["VHF"]["player"] then
			result = GetLocFrequency(side, targetname, nRadio, type,  "VHF")
		else
			result = GetLocFrequency(side, targetname, nRadio, type,  "UHF")
		end
	elseif task == "coalition" then

		result = GetLocFrequency(side, "", "", type,  waves)

		if Debug.debug then print("UtilF_Debug GetFrequency return L result "..tostring(result)) end
		return result

	elseif task == "group" then   --prend obligatoirement le channel 1 de la radio 1

		result = GetLocFrequency(side, targetname, 1, type,  waves)

		if Debug.debug then print("UtilF_Debug GetFrequency return M result "..tostring(result)) end
		return result
	else
		result = GetLocFrequency(side, targetname, nRadio, type,  waves)
		-- if Debug.debug then print("UtilF_Debug GetFrequency PASSE ELSE "..tostring(result)) end
	end

	if result then
		if Debug.debug then print("UtilF_Debug GetFrequency PASSE return O "..tostring(result)) end
		return result
	else
		result = GetLocFrequency(side, targetname, nRadio, type,  "UHF")
		if result then
			if Debug.debug then print("UtilF_Debug GetFrequency PASSE return P UHF "..tostring(result)) end
			return result
		else
			result = GetLocFrequency(side, targetname, nRadio, type,  "LVHF")
			if result then
				if Debug.debug then print("UtilF_Debug GetFrequency PASSE return Q LVHF "..tostring(result)) end
				return result
			else
				if not camp.radio[side] then camp.radio[side] = {} end
				if not camp.radio[side][nRadio] then camp.radio[side][nRadio] = {} end
				if not camp.radio[side][nRadio]["VHF"] then camp.radio[side][nRadio]["VHF"]  = {} end
				camp.radio[side][nRadio]["VHF"] = {
					min = 118,
					max = 136,
				}
				result = GetLocFrequency(side, targetname, nRadio, type,  "VHF")
				if Debug.debug then print("UtilF_Debug GetFrequency PASSE return R VHF  "..tostring(result)) end

				if result then

					if Debug.debug then print("UtilF_Debug GetFrequency return S result "..tostring(result)) end
					return result
				else
					
					--TODO ajouter ici (ou ailleurs) une condition pour utiliser la bande de freq preféré du joueur

					camp.radio[side][nRadio]["UHF"] = {
						min = 225,
						max = 300,
					}
					local range = "UHF"
					repeat
						freq = math.random(camp.radio[side][nRadio][range].min, camp.radio[side][nRadio][range].max - 1)		--find random frequency in mHz
						local deci = math.random(0, 9) / 10									--random first decimal place
						-- local mil = math.random(0, 3) * 25 / 1000							--random second and third decimal place (00/25/50/75)
						local mil = 00														--impossible pour certain avions, comme le M2000
						freq = freq + deci + mil											--combine to complete frequency
					until Assigned_freq[freq] == nil and (freq<242.9 or freq>243.1)			--repeat until a frequency is found that is not yet in use

					Assigned_freq[freq] = true												--mark frequency in use
					Package_freq[side][range][targetname] = freq							--store frequency for package

					if Debug.debug then print("UtilF_Debug GetFrequency PASSE return Z UHF  "..tostring(freq)) end
					return freq
				end
			end
		end
	end

	print()
	print("********************ATTENTION******************")
	print("**** Note for the Campaign Maker: Impossible to assign a frequency to  "..tostring(type).."**********")
	print("********************ATTENTION******************")
	print()
	os.execute 'pause'
end

-- http://www.lua.org/pil/19.3.html
-- Trier un tableau A[b] en le classant par A, et non b... pas simple .. ^^
-- function PairsByKeys (t, f)
-- 	local a = {}
-- 	for n in pairs(t) do table.insert(a, n) end
-- 		table.sort(a, f)
-- 		local i = 0      -- iterator variable
-- 		local iter = function ()   -- iterator function
-- 		i = i + 1
-- 		if a[i] == nil then return nil
-- 		else return a[i], t[a[i]]
-- 		end
-- 	end
-- 	return iter
-- end

local function loadoutPylon(loadoutTable)
	for plane, loadoutByTask in pairs(loadoutTable) do
		for task, ltable in pairs(loadoutByTask) do
			for loadoutName, loadout in pairs(ltable) do
				local newSortPylons = {}
				local newSort = false
				if loadout.stores and loadout.stores.pylons then
					for chapterN, emport in pairs(loadout.stores.pylons) do

						if emport.num and emport.num ~= chapterN then
							-- print("UtilF incoherence pylon N and Num: "..tostring(plane).." "..tostring(task).." "..tostring(loadoutName).." "..tostring(chapterN))
							-- os.execute 'pause'
							newSort = true
						end
					end

					if newSort then
						for chapterN, emport in pairs(loadout.stores.pylons) do
							newSortPylons[emport.num] =
							{
								["CLSID"] =	emport.CLSID,
							}
							newSort = true
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

-- modification M49.a big central db_loadout

local function buildsLoadout()
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



	if  campMod.selectLoadout == "init" then
		require("Init/db_loadouts")
	else
		-- charge le loadout central en premier pour avoir la table de code_loadout
		dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_db_loadouts.lua")
	end


	-- --si ADD_loadouts existe, on le precharge pour prendre en compte son/ses codes code_loadout que l'on ajoutera au central
	-- local loadoutFile02 = "../../../Missions/Campaigns/"..camp.title.."/Init/ADD_loadouts.lua"
	-- local TestPathADD_loadouts = io.open(loadoutFile02, "r")																--cette maniere de chercer la presence d un fichier evite un plantage
	-- if TestPathADD_loadouts ~= nil  then																	--check si le fichier existe dans ScriptsMod
	-- 	dofile("../../../Missions/Campaigns/"..camp.title.."/Init/ADD_loadouts.lua")	
	-- 	addLoadoutsTag = true

	-- 	if add_campaigns_code_loadout then
	-- 		campaigns_code_loadout = add_campaigns_code_loadout
	-- 	end
	-- end


	-- -- cherche le code a appliquer au loadout, pour charger le bon..loadout ^^
	-- if (not ( campConfMod and  campConfMod.code_loadout) and campaigns_code_loadout )then 
	-- 	campConfMod = {}
	-- 	local maxOcc = 0
	-- 	for codeName , name in pairs(campaigns_code_loadout) do			
	-- 		local j = 0
	-- 		if type(name) == "table" then
	-- 			for i=1, #name do
	-- 				print("UtilF title "..camp.title.." string.find "..name[i])
	-- 				if  camp.title == name[i] or  string.find(string.lower(camp.title) , string.lower(name[i])) then
	-- 					j = j +1 
	-- 					print("UtilF   PasseB "..j.." #name "..#name.." >?maxOcc ".. maxOcc)
	-- 					if j == #name and #name > maxOcc then						-- il a trouv� toutes les occurences du nom
	-- 						print("UtilF     PasseC ")
	-- 						campConfMod.code_loadout = codeName
	-- 						maxOcc = #name											--assigne le nomCode seulement � celui qui a le plus d'occurence
	-- 					end
	-- 				end
	-- 			end
	-- 		else
	-- 			if  string.find(string.lower(camp.title) , string.lower(name)) then
	-- 				campConfMod.code_loadout = codeName
	-- 			end
	-- 		end
	-- 	end
	-- end


	-- cherche le code a appliquer au loadout, pour charger le bon..loadout ^^
	if (not ( campConfMod and  campConfMod.code_loadout) and campaigns_code_loadout )then 
		local bestMatch = nil
		local bestMatchCount = 0
		campConfMod = {}

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
					if bestMatchCount < 1 then -- Priorité pour les correspondances plus spécifiques
						bestMatch = codeName
						bestMatchCount = 1
					end
				end
			end
		end

		campConfMod.code_loadout = bestMatch
	end

	if not campConfMod or not campConfMod.code_loadout or campConfMod.code_loadout == nil then
		campConfMod = {
			code_loadout = "all",
		}
	end

	-- print("UtilF Z code_loadout "..campConfMod.code_loadout)
	-- os.execute "pause"

	if Debug.debug then
		print("UtilF camp.title |"..camp.title.."| campConfMod.code_loadout |"..campConfMod.code_loadout )
	-- os.execute "pause"
	end

	if campMod.selectLoadout == "init" then
		-- require("Init/db_loadouts")
	else
		-- modification M49.a big central db_loadout
		--construit la table loadout en fonction du loadout général et de la campagne
		db_loadouts = {}

		for plane, planeTab  in pairs(db_all_loadouts) do
			for taskName, loadout  in pairs(planeTab) do
				for loadoutName, value  in pairs(loadout) do
					if value.code_loadout and value.code_loadout ~= "" then
						for code_loadout_number, code in pairs(value.code_loadout) do
							if string.lower(campConfMod.code_loadout) == string.lower(code) or string.lower(code) == "all" then
								if not db_loadouts[plane] then
									db_loadouts[plane] = {}
								end
								if not db_loadouts[plane][taskName] then db_loadouts[plane][taskName] = {} end
								if not db_loadouts[plane][taskName][loadoutName] then db_loadouts[plane][taskName][loadoutName] = {} end
								db_loadouts[plane][taskName][loadoutName] = value
							end
						end
					elseif  value.code_loadout == "" or not value.code_loadout  or not value.code_loadout == nil  then
						if not db_loadouts[plane] then
							db_loadouts[plane] = {}
						end
						if not db_loadouts[plane][taskName] then db_loadouts[plane][taskName] = {} end
						if not db_loadouts[plane][taskName][loadoutName] then db_loadouts[plane][taskName][loadoutName] = {} end
						db_loadouts[plane][taskName][loadoutName] = value
					end
				end
			end
		end
	end


	-- if TestPathADD_loadouts ~= nil and add_loadouts  then																	--check si le fichier existe dans ScriptsMod
	-- 	for plane, planeTab  in pairs(add_loadouts) do		
	-- 		for taskName, loadout  in pairs(planeTab) do					
	-- 			for loadoutName, value  in pairs(loadout) do
	-- 				if value.code_loadout and value.code_loadout ~= "" then 								
	-- 					for code_loadout_number, code in pairs(value.code_loadout) do																																
	-- 						if string.lower(campConfMod.code_loadout) == string.lower(code) or string.lower(code) == "all" then
	-- 							if not db_loadouts[plane] then							
	-- 								db_loadouts[plane] = {}
	-- 							end 
	-- 							if not db_loadouts[plane][taskName] then db_loadouts[plane][taskName] = {} end 
	-- 							if not db_loadouts[plane][taskName][loadoutName] then db_loadouts[plane][taskName][loadoutName] = {} end 

	-- 							local n = 0
	-- 							local insertionAutorise = false
	-- 							local insertionOK  = false
	-- 							repeat

	-- 								if not db_loadouts[plane][taskName][loadoutName] then
	-- 									db_loadouts[plane][taskName][loadoutName] = value
	-- 									insertionOK = true
	-- 								end

	-- 								if not insertionOK and  db_loadouts[plane][taskName][loadoutName..tostring(n)] then
	-- 									n = tonumber(n) + 1
	-- 								else
	-- 									insertionAutorise = true
	-- 								end

	-- 								if insertionAutorise then
	-- 									db_loadouts[plane][taskName][loadoutName..tostring(n)] = value
	-- 									insertionOK = true
	-- 								end

	-- 								if tonumber(n) > 50 then
	-- 									print("MainNM MEGA BUG ADD_loadout")
	-- 								end
	-- 							until insertionOK or tonumber(n) > 50


	-- 						end						
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end

	--routine de verification des code campagne
	-- dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_db_loadouts.lua")

	if campaigns_code_loadout and not addLoadoutsTag then
		for planeType, plane  in pairs(db_loadouts) do
			for taskName, loadouts in pairs(plane) do
				for loadoutName, loadout  in pairs(loadouts) do
					-- print("UtilF "..plane.." "..taskName.." "..loadoutName)
					if loadout and loadout.code_loadout and loadout.code_loadout ~= "" then
						for code_loadout_number, code in ipairs(loadout.code_loadout) do
							if not campaigns_code_loadout[code]  then	--and not string.lower(code) == "all"

								if  string.lower(code) ~= "all"  then

									print()
									print("********************ATTENTION******************")
									print("***************Note for the Campaign Maker*****"..planeType.." ||| "..taskName.." ||| "..loadoutName.." ||| "..code.." not found in campaigns_code_loadout****************")
									print("********************ATTENTION******************")
									print()
									-- os.execute 'pause'
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


	db_loadouts = loadoutPylon(db_loadouts)

	-- copy_all_loadouts = makeStrutureLoadout(copy_all_loadouts)

	if Debug.debug then
		local test_loadouts = Deepcopy(db_loadouts)
		test_loadouts = makeStrutureLoadout(test_loadouts)

		local test_str = "db_loadouts = " .. TableSerializationLoadout(test_loadouts, 0, 0)						--make a string	
		local testFile = io.open("Debug/loadouts_clean.lua", "w") or error("Failed to open debug file")
		testFile:write(test_str)															--save new data
		testFile:close()

		if db_all_loadouts then

			local copy_all_loadouts = Deepcopy(db_all_loadouts)
			copy_all_loadouts = loadoutPylon(copy_all_loadouts)

			copy_all_loadouts = makeStrutureLoadout(copy_all_loadouts)

			local test_str = "db_all_loadouts = " .. TableSerializationLoadout(copy_all_loadouts, 0, 0)						--make a string	
			local testFile = io.open("Debug/loadouts_global_clean.lua", "w") or error("Failed to open debug file")
			testFile:write(test_str)															--save new data
			testFile:close()
		end
	end

	-- db_all_loadouts = copy_all_loadouts

end

buildsLoadout()


-- modification M54		revoir CustomTaskScript et TaskBombing
-- check si tous les avions pr�vu dans oob_air ont leur task d�clar� possible dans la table TaskByPlane
function Check_TaskPossibleByPlane()

	-- StrikeCombi = {
		-- ["CAS"] = false,
		-- ["Ground Attack"] = false,
		-- -- ["Runway Attack"] = false,
		-- ["Pinpoint Strike"] = true,
	-- }


	--si ADD_data existe, on le precharge pour l'ajouter au DATA centram
	local addDataFile02 = "../../../Missions/Campaigns/"..camp.title.."/Init/ADD_data.lua"
	local TestPathADD_addData = io.open(addDataFile02, "r")										--cette maniere de chercher la presence d un fichier evite un plantage
	if TestPathADD_addData ~= nil  then														--check si le fichier existe dans ScriptsMod
		dofile("../../../Missions/Campaigns/"..camp.title.."/Init/ADD_data.lua")

		if add_EPLRS_Capacity then
			for key , value in pairs(add_EPLRS_Capacity) do
				if not EPLRS_Capacity[key] then
					EPLRS_Capacity[key] = true
				end
			end
		end

		if add_TaskByPlane then
			for task , plane in pairs(add_TaskByPlane) do
				for planeName , value in pairs(plane) do
					if  TaskByPlane[task] then
						if  not TaskByPlane[task][planeName] then
							TaskByPlane[task][planeName] = true
						end
					else
						TaskByPlane = {
							task = {
								planeName = true,
							}
						}
					end
				end
			end
		end

	end

	local checkOobAir = Deepcopy(oob_air)


	for side, squadTbl in  pairs(checkOobAir) do
		for squad_n, squad in  pairs(squadTbl) do

			local foundPlane = false
			-- print("UtilF side "..side.." "..squad_n.." "..tostring(squad.name))
			if squad.tasks and type(squad.tasks) == "table" then --not squad.inactive and 

				-- StrikeCombi
				local addMultipleStrike = false
				for taskOA, valueOA in  pairs(squad.tasks) do
					if taskOA == "Strike" and valueOA == true  then
						addMultipleStrike = true
					end
				end

				--ajoute les vrais id des differents Strike
				if addMultipleStrike then
					squad.tasks["Strike"] = nil
					squad.tasks["CAS"] = true
					squad.tasks["Ground Attack"] = true
					squad.tasks["Pinpoint Strike"] = true
					-- squad.tasks["Runway Attack"] = true				
				end

				local foundStrikeTask = false
				for taskOA, valueOA in  pairs(squad.tasks) do

					local foundTask = false

					-- print("UtilF passe A "..taskOA.." valueOA: "..tostring(valueOA))

					if taskOA == "Escort Jammer" then
						taskOA = "Ground Attack"
					elseif taskOA == "Flare Illumination" then
						taskOA = "Ground Attack"
					elseif taskOA == "Laser Illumination" then
						taskOA = "AFAC"
					elseif taskOA == "Anti-ship Strike" then
						taskOA = "Antiship Strike"
					elseif taskOA == "SAR" or taskOA == "CSAR" then
						taskOA = "Transport"
					end

					if  type(valueOA) ~= "boolean" then
						print("UtilF ATTENTION is not a boolean value for : "..tostring(squad.type).." "..tostring(taskOA))
						os.execute 'pause'
					end

					if valueOA == true and TaskByPlane[taskOA] then
						for plane_TbP, value in  pairs(TaskByPlane[taskOA]) do
							if squad.type == plane_TbP   then
								foundPlane = true
								foundTask = true
								if taskOA == "CAS" or taskOA == "Ground Attack" or taskOA == "Pinpoint Strike"  then
									foundStrikeTask = true
								end
							end
						end

						--toutes les tasks sauf strike
						if not foundTask and not addMultipleStrike and not tostring(taskOA) == "Fighter Sweep" then
							print("(Error UutilF C01) this task, requested in Init\\oob_air_init.lua, is not listed in the UTIL_Data.lua file : "..tostring(squad.type).." "..tostring(taskOA))
							os.execute 'pause'
						end

					elseif valueOA == true and not TaskByPlane[taskOA] and not tostring(taskOA) == "Fighter Sweep" then
						print("(Error UutilF C02) this task, requested in Init\\oob_air_init.lua, is not listed in the UTIL_Data.lua file : "..tostring(squad.type).." "..tostring(taskOA))
						os.execute 'pause'
					end
				end

				--si aucune tasks strike n'a �t� trouv�
				if not foundStrikeTask and  addMultipleStrike then
					print("(Error UutilF C03) this task, requested in Init\\oob_air_init.lua, is not listed in the UTIL_Data.lua file : "..tostring(squad.type).." "..tostring("Strike ( CAS or Ground Attack or Pinpoint Strike )"))
					os.execute 'pause'
				end
				if not squad.inactive and not foundPlane   then
					--TODO revoir ce pb, exemple avec campaign Hornet Over Carrier SC
					print("(Error UutilF C04)||"..tostring(squad.type).."||"..tostring(squad.name).."||  impossible to find a task/aircraft match with all files concerned ".." (oob_air_init or  UTIL_Data.lua or bad Task or bad boolean task)")

					for taskOA, valueOA in  pairs(squad.tasks) do
						print(tostring(taskOA).." : "..tostring(valueOA))
					end
					os.execute 'pause'
				end
			end
		end
	end
end


--M43 assignation des numeros de parking du type C08 
ParkOccupied = {}
function GetParkingId(parkingId, baseName)
	local s
	local counter = 0
	if not ParkOccupied[baseName]  then
		ParkOccupied[baseName] = {}
	end

	-- parking_id = {
	-- 	[""] = {25,26},                   --["C"] = {2,10},
	-- },	

	for prefix, value in pairs(parkingId) do

		local valueCopy = Deepcopy(value)
		counter = 0
		local single = false
		local singleTest = string.lower(tostring(valueCopy[1]))

		--signifie que l'on prend uniquement les chiffres proposé, on ne prend pas la plage entre 2 chiffres
		if singleTest == "single" then
			single = true
			table.remove(valueCopy, 1)
		end

		if #valueCopy == 2 and not single then
			local lower = tonumber(valueCopy[1])
			local upper = tonumber(valueCopy[2])

			-- Validation explicite que lower et upper sont des entiers
			if lower and upper then
				repeat
					counter = counter + 1
					local randomValue = math.random(math.floor(lower), math.floor(upper)) -- Forcer en entiers
					s = prefix .. randomValue
				until ParkOccupied[baseName][s] == nil or counter == 100
			else
				print("Error: Range limits are not valid numbers."..baseName.." prefix: "..tostring(prefix))
			end

		elseif #valueCopy > 2 or single then
			repeat
				counter = counter + 1
				local r = math.random(1,#valueCopy)
				s = valueCopy[r]
				-- s = prefix..string.format("%02d", s)
				s = prefix.. s
			until ParkOccupied[baseName][s] == nil 	or counter == 100
		end

		if ParkOccupied[baseName][s] == nil then
			break
		end
	end

	--ne trouve pas de place libre:
	if counter >= 100 then
		return false
	end

	ParkOccupied[baseName][s] = true

	return tostring(s)

	-- local parkParameters = {}

	-- if ParkListPosition and NameTheatre then

	-- 	local airdromeId = db_airbases[baseName].airdromeId

	-- 	if airdromeId and ParkListPosition[NameTheatre] and ParkListPosition[NameTheatre][airdromeId] then

	-- 		for n, parkList in pairs(ParkListPosition[NameTheatre][airdromeId]) do
	-- 			if s == tostring(parkList["parking_id"]) then
	-- 				parkParameters = {
	-- 					["heading"] = parkList["heading"],
	-- 					["parking"] = parkList["parking"],
	-- 					["parking_id"] = parkList["parking_id"],
	-- 					["x"] = parkList["x"],
	-- 					["y"] = parkList["y"],
	-- 				}
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- return parkParameters

	-- if not parkParameters.parking_id then
	-- 	parkParameters["parking_id"] = s
	-- end


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

		-- if show then
		-- 	_affiche(point, "point")

		-- 	print("UtilsF i "..tostring(i))
		-- 	_affiche(polygon[i], "polygon[i]")

		-- 	print("UtilsF j "..tostring(j))
		-- 	_affiche(polygon[j], "polygon[j]")

		-- 	print("UtilsF polygon[i].x "..tostring(polygon[i].x))
		-- 	print("UtilsF polygon[i].y "..tostring(polygon[i].y))

		-- 	print("UtilsF point.x "..tostring(point.x))
		-- 	print("UtilsF point.y "..tostring(point.y))

		-- 	print("UtilsF polygon[j].x "..tostring(polygon[j].x))
		-- 	print("UtilsF polygon[j].y "..tostring(polygon[j].y))

		-- end

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





function CheckConfModMaster()

	dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_ConfModCheck.lua")
	local confModCheck = {
		mission_ini = mission_ini_check,
		mission_forcedOptions = mission_forcedOptions_check,
		-- campaign_ini = campaign_ini_check,
		Debug = Debug_check,
		campMod = campMod_check,

	}

	local confModLocal = {
		mission_ini = mission_ini,
		mission_forcedOptions = mission_forcedOptions,
		-- campaign_ini = campaign_ini,
		Debug = Debug,
		campMod = campMod,

	}

	local function checkChanged()

		local found = true
		for var1, value1 in pairs(confModCheck) do
			if type(value1) ~= "table" then
				if confModLocal[var1] == nil then found = false   return false end

			elseif type(value1) == "table" then
				for var2, value2 in pairs(value1) do
					if type(value2) ~= "table" then
						if confModLocal[var1][var2] == nil then found = false   return false end

					elseif type(value2) == "table" then
						for var3, value3 in pairs(value2) do
							if type(value3) ~= "table" then
								if  confModLocal[var1] == nil or  confModLocal[var1][var2] == nil or  confModLocal[var1][var2][var3] == nil then found = false   return false end

							end
						end
					end
				end
			end
		end

		--on change de sens, on regarde s'il y a des infos en trop en local
		for var1, value1 in pairs(confModLocal) do
			-- print("UtilF var1 |"..var1  )

			if type(value1) ~= "table" then
				if confModCheck[var1] == nil then found = false print("UtilF B not found var1 |"..var1  )  return false end
			elseif type(value1) == "table" then
				for var2, value2 in pairs(value1) do
					if type(value2) ~= "table" then
						if confModCheck[var1] == nil or confModCheck[var1][var2] == nil  then
							found = false
							-- print("UtilF B not found var2 |"..var1.." "..var2  ) 
							return false
						end

					elseif type(value2) == "table" then
						for var3, value3 in pairs(value2) do
							if type(value3) ~= "table" then
								-- print("UtilF var1 |"..var1.." var2 "..var2.." var3 "..var3  )
								if confModCheck[var1] == nil or confModCheck[var1][var2] == nil or confModCheck[var1][var2][var3] == nil  then
									-- print("UtilF B not found var3 |"..var3  )
									found = false return false
								end

							end
						end
					end
				end
			end
		end

		return true

	end


	local integrity = checkChanged()


	if integrity == false then
		return 1
	else
		return 0
	end
end


--met à jour automatiquement le conf_mod en fonction des nouveautés apporté par UTIL_ConfModCheck
function UpdateConfMod()
    --version UpdateConfMod VA_1.12

	
	-- local weather_override = {
	-- 	temperature = 20,  -- 🌡️ Température en degrés Celsius
	-- 	wind_speed = 5,    -- 🌬️ Vitesse du vent (m/s)
	-- 	wind_dir = 180,    -- 🧭 Direction du vent
	-- 	turbulence = 0,    -- 🌪️ Pas de turbulence
	-- }

	local weather_override = {
		pHigh = 20,				--probability of high pressure weather system
		pLow = 80,					--probability of low pressure weather system
		refTemp = 18,				--average day max temperature
	}
    
	local function deepCopy(orig)
		local copy
		if type(orig) == 'table' then
			copy = {}
			for orig_key, orig_value in pairs(orig) do
				copy[orig_key] = deepCopy(orig_value)
			end
			setmetatable(copy, deepCopy(getmetatable(orig)))
		else
			copy = orig
		end
		return copy
	end

    -- Fonction pour charger la configuration avec la structure	
	local function loadConfigWithStructure(filePath)
		-- version loadConfigWithStructure VA_1.38b
		local config = {}
		local structure = {}
		local stack = {}
		local currentTable = config
		local currentKey = nil
		local pendingTable = nil -- Stocker temporairement le nom d'une table qui attend `{`
	
		for line in io.lines(filePath) do
			line = line:gsub("_check", "") -- Supprimer "_check"
	
			-- print("\nLCWS A "..line) -- Debug simple sans icône
	
			-- Ignorer les lignes commentées
			if line:match("^%s*%-%-") then
				table.insert(structure, line)
	
			-- Ignorer les lignes versionDCE
			elseif line:match("versionDCE") then
				
			else
				table.insert(structure, line) -- Stockage brut de la structure du fichier
				
				-- Détection des structures Lua
				local singleLineTable = line:match("(%S+)%s*=%s*{(.-)}%s*,?%s*$")
				local tableStart = line:match("(%S+)%s*=%s*{")
				local tableEnd = line:match("^%s*}%s*[,]?")
				local listValue = line:match('^%s*"(.-)",?%s*$')
				local tableStartUnique = line:match('%["([^"]+)"%]%s*=%s*$') or line:match("(%S+)%s*=%s*$")


				-- print("lCWS E1 tableStart?: "..tostring(tableStart))
				-- print("lCWS E2 singleLineTable?: "..tostring(singleLineTable))
				-- print("lCWS E6 tableEnd?: "..tostring(tableEnd))
				-- print("lCWS E7 tableStartUnique?: "..tostring(tableStartUnique))
				-- print("lCWS E8 currentKey?: "..tostring(currentKey))
		
	
				local key, value, comment = line:match('(%S+)%s*=%s*(["]?[%w%s%p]+["]?)%s*,?%s*%-%-%s*(.*)')
				-- print("lCWS AA1 value?: "..tostring(value))
				if not key then
					key, value = line:match('(%S+)%s*=%s*(["]?[%w%s%p]+["]?)%s*,?')
					-- print("lCWS AA2 value?: "..tostring(value))
					
				end

	
				-- 1️⃣ Tables sur une seule ligne (ex: `x = {1, 2, 3}`)
				if singleLineTable then
					-- print("LCWS B ")
					local name, contents = line:match("(%S+)%s*=%s*{(.-)}")
					local newTable = {}
					for value in contents:gmatch("[^,]+") do
						value = value:match("^%s*(.-)%s*$") -- Supprimer les espaces blancs
						newTable[#newTable + 1] = tonumber(value) or value
					end
					currentTable[name] = newTable
	
				-- 2️⃣ `pictureBrief =` suivi de `{` sur la ligne suivante
				elseif tableStartUnique then
					-- print("LCWS C ")
					pendingTable = tableStartUnique -- Retenir le nom de la table
	
				elseif line:match("^%s*{%s*$") and pendingTable then
					-- print("\nLCWS D ")
					currentTable[pendingTable] = {} -- Créer la table
					table.insert(stack, { table = currentTable, key = currentKey }) -- Sauvegarde du contexte
					currentTable = currentTable[pendingTable]
					currentKey = pendingTable
					pendingTable = nil -- Réinitialisation
	
				-- 3️⃣ Tables classiques (`key = {`)
				elseif tableStart then
					-- print("LCWS E ")
				
					if not currentTable[tableStart] then
						currentTable[tableStart] = {} -- Créer la table si elle n'existe pas
					end
					table.insert(stack, { table = currentTable, key = currentKey })
					currentTable = currentTable[tableStart]
					currentKey = tableStart
				
	
				-- 4️⃣ `blue = {` et `red = {` sous `pictureBrief`
				elseif (line:match("^%s*(blue|red)%s*=%s*{") or line:match("^%s*%[%d+%]%s*=%s*{")) and currentKey == "pictureBrief" then
					-- print("LCWS F ")
					local subKey = line:match("^%s*(blue|red)%s*=%s*{") or line:match("^%s*%[(%d+)%]%s*=%s*{")
					if not currentTable[subKey] then
						currentTable[subKey] = {}
					end
					table.insert(stack, { table = currentTable, key = currentKey })
					currentTable = currentTable[subKey]
					currentKey = subKey
	
				-- 5️⃣ Fermeture de table (`}`)
				elseif tableEnd then
					-- print("LCWS G ")
					if #stack > 0 then
						local popped = table.remove(stack)
						currentTable = popped.table
						currentKey = popped.key
					end
	
				-- 6️⃣ Détection des listes `"texte",`
				elseif listValue then
					-- print("LCWS H ")

					table.insert(currentTable, listValue)
	
				-- 7️⃣ Détection des valeurs indexées `[1] = "..."``
				elseif line:match("^%s*%[%d+%]%s*=%s*") then
					-- print("LCWS I ")
					local index, listValue = line:match("^%s*%[(%d+)%]%s*=%s*\"(.-)\"")
					if index and listValue and currentKey then
						
						currentTable[tonumber(index)] = listValue
						
					end
				-- 8️⃣ Variables classiques `key = value`
				elseif key and value then
					-- ✅ Suppression propre des `,` et espaces parasites en fin de valeur
					value = value:match("^%s*(.-)%s*$") -- Trim des espaces inutiles
					value = value:gsub(",%s*$", "")     -- Supprimer `,` en fin de ligne
				
					-- ✅ Conversion propre en nombre
					local numValue = tonumber(value)
					-- print("LCWS J2 "..tostring(value))
					currentTable[key] = numValue or value  -- Si c'est un nombre, on le stocke en tant que nombre
				
					
				end
			end
		end
	
		return config, structure
	end
	
	-- ✅ Fonction pour récupérer la vraie valeur (sans toujours mettre des strings)
	local function getFormattedValue(value)
	
		-- ✅ Si `value` est une table contenant { value = ..., comment = ... }
		if type(value) == "table" and value.value ~= nil then
			return getFormattedValue(value.value) -- Récupérer directement `value`
		end
	
		-- ✅ Gestion des types normaux (string, booléens, nombres)
		if type(value) == "string" then
			if value == "true" or value == "false" then
				return value -- Garder sans guillemets
			elseif tonumber(value) then
				return value -- Convertir en nombre
			else
				return '"' .. value:gsub('"', '') .. '"' -- Supprime les doubles guillemets parasites
			end
		elseif type(value) == "boolean" then
			return tostring(value)
		elseif type(value) == "number" then
			return value
		elseif type(value) == "table" then
			-- 🔍 Vérifier si c'est une liste indexée
			local isArray = (#value > 0) and (next(value, #value) == nil)
		
			if isArray then
				return "{ " .. table.concat(value, ", ") .. " }"  -- ✅ Format propre des listes !
			else
				local formattedTable = {}
				for k, v in pairs(value) do
					table.insert(formattedTable, "[" .. tostring(k) .. "] = " .. getFormattedValue(v))
				end
				return "{ " .. table.concat(formattedTable, ", ") .. " }"
			end

		else
			return tostring(value)
		end
	end

    -- Fonction pour supprimer les clés obsolètes
    local function removeObsoleteEntries(clientConfig, referenceConfig)
        --version removeObsoleteEntries VA_1.12
        local function deepClean(clientTable, referenceTable)
            for key, value in pairs(clientTable) do
                if key ~= "pictureBrief" and key ~= "movedBullseye" then
					if type(value) == "table" then
						if not referenceTable[key] then
							clientTable[key] = nil  -- Supprime la table complète si elle est absente du modèle
						else
							deepClean(value, referenceTable[key])  -- Nettoie récursivement les sous-tables
						end
					elseif not referenceTable[key] then
						clientTable[key] = nil  -- Supprime les variables obsolètes
					end
				else

				end
            end
        end

        deepClean(clientConfig, referenceConfig)
        return clientConfig
    end

	local function mergeTables(clientTable, defaultTable, structure)
		for key, defaultValue in pairs(defaultTable) do
			local clientValue = clientTable[key]
	
			-- 🖼️ `pictureBrief` ne doit pas être touché
			if key == "pictureBrief" then
				-- print("[mergeTables] A `pictureBrief` préservé")
	
			-- 🌍 `movedBullseye` doit fusionner **ET** accepter de nouvelles maps
			elseif key == "movedBullseye" and type(defaultValue) == "table" then
				-- print("[mergeTables] B Fusion `movedBullseye`")
				if type(clientValue) ~= "table" then
					-- print("[mergeTables] C `movedBullseye` absent dans clientTable, création")
					clientTable[key] = {}
				end
	
				-- 🔄 Fusion normale des maps existantes
				mergeTables(clientValue, defaultValue, structure)
	
				-- ✅ Ajouter les nouvelles maps du client qui n'existent pas dans `defaultTable`
				for mapName, mapData in pairs(clientValue) do
					-- print("[mergeTables] D Map détectée :", mapName)
					if not defaultValue[mapName] then
						-- print("[mergeTables] E Nouvelle map ajoutée :", mapName)
						defaultValue[mapName] = deepCopy(mapData) -- Ajoute la map à `config_default`
						
						-- 🏗 Ajouter aussi `mapName` à `structure` pour garantir l'écriture
						table.insert(structure, "\t" .. mapName .. " = {")
						table.insert(structure, "\t\tpos = {")
						table.insert(structure, "\t\t\tx = " .. getFormattedValue(mapData.pos.x) .. ",")
						table.insert(structure, "\t\t\ty = " .. getFormattedValue(mapData.pos.y) .. ",")
						table.insert(structure, "\t\t},")
						table.insert(structure, "\t\trayon = " .. getFormattedValue(mapData.rayon) .. ",")
						table.insert(structure, "\t},")
					end
				end
	
			-- 🌦️ `weather` doit **toujours** être remplacé par `weather_override`
			elseif key == "weather" then
				-- print("[mergeTables] 🌦 Application de `weather_override`")
				clientTable[key] = deepCopy(weather_override)
	
			-- 🔀 Fusion normale des sous-tables
			elseif type(defaultValue) == "table" then
				if not clientValue then
					-- print("[mergeTables] 🆕 Copie de la table absente :", key)
					clientTable[key] = deepCopy(defaultValue)
				elseif type(clientValue) == "table" then
					mergeTables(clientValue, defaultValue, structure)
				end
	
			-- 📝 Valeur simple : on applique la valeur par défaut si absente
			else
				if clientValue == nil then
					-- print("[mergeTables] 📝 Valeur par défaut appliquée :", key)
					clientTable[key] = defaultValue
				end
			end
		end
	end

    -- Nouvelle fonction pour insérer les nouvelles tables et variables manquantes dans la structure
	local function updateConfiguration(clientConfig, defaultConfig)
		-- version updateConfiguration VA_1.34 (Ajout du retour clientConfig)
	
		-- local function mergeTables(clientTable, defaultTable)
		-- 	for key, defaultValue in pairs(defaultTable) do
		-- 		local clientValue = clientTable[key]
		
		-- 		-- 🚨 Exception : `pictureBrief` doit rester **intact**
		-- 		if key == "pictureBrief" then
		-- 			print("🚨 `pictureBrief` préservé, aucune modification !")
		-- 			if type(clientValue) ~= "table" then
		-- 				clientTable[key] = {}  -- Assurer que c'est bien une table
		-- 			end
		-- 		elseif type(defaultValue) == "table" then
		-- 			if not clientValue then
		-- 				clientTable[key] = deepCopy(defaultValue)
		-- 			elseif type(clientValue) == "table" then
		-- 				mergeTables(clientValue, defaultValue)
		-- 			end
		-- 		else
		-- 			if clientValue == nil then
		-- 				clientTable[key] = defaultValue
		-- 			end
		-- 		end
		-- 	end
		-- end

		
		

		-- local function mergeTables(clientTable, defaultTable)
		-- 	-- version mergeTables VA_1.12 (Debug movedBullseye & weather)
		
		-- 	for key, defaultValue in pairs(defaultTable) do
		-- 		local clientValue = clientTable[key]
		
		-- 		-- 🚨 Vérif de `pictureBrief`
		-- 		if key == "pictureBrief" then
		-- 			print("[mergeTables] A `pictureBrief` préservé")
		
		-- 		-- 🌍 Vérif de `movedBullseye`
		-- 		elseif key == "movedBullseye" and type(defaultValue) == "table" then
		-- 			print("[mergeTables] B Fusion `movedBullseye` en cours...key: "..tostring(key))
		-- 			if type(clientValue) ~= "table" then
		-- 				print("[mergeTables] C `movedBullseye` absent dans clientTable, création key: "..tostring(key))
		-- 				clientTable[key] = {}  -- Créer `movedBullseye` si absent
		-- 			end
		
		-- 			-- 🔄 Fusionner les maps existantes
		-- 			mergeTables(clientValue, defaultValue)

		-- 			-- ✅ Ajouter les nouvelles maps du client qui n'existent pas dans `defaultTable`
		-- 			for mapName, mapData in pairs(clientValue) do
		-- 				print("[mergeTables] D  map ? :", mapName)

		-- 				if not defaultValue[mapName] then
		-- 					print("[mergeTables] E Nouvelle map ajoutée :", mapName)
		-- 					clientTable[key][mapName] = deepCopy(mapData)  -- 🔥 Ajouter à `clientTable`, pas `defaultTable`
		-- 				end
		-- 			end

		
		-- 		-- 🌦 Vérif de `weather`
		-- 		elseif key == "weather" then
		-- 			print("[mergeTables] 🌦 Application de `weather_override`")
		-- 			clientTable[key] = deepCopy(weather_override) -- **Force les valeurs définies**
		
		-- 		-- 🔀 Fusion normale des sous-tables
		-- 		elseif type(defaultValue) == "table" then
		-- 			if not clientValue then
		-- 				print("[mergeTables] 🆕 Copie de la table absente :", key)
		-- 				clientTable[key] = deepCopy(defaultValue)
		-- 			elseif type(clientValue) == "table" then
		-- 				mergeTables(clientValue, defaultValue)
		-- 			end
		
		-- 		-- 📝 Prendre la valeur par défaut si absente
		-- 		else
		-- 			if clientValue == nil then
		-- 				print("[mergeTables] 📝 Valeur par défaut appliquée :", key)
		-- 				clientTable[key] = defaultValue
		-- 			end
		-- 		end
		-- 	end
		-- end
		
		mergeTables(clientConfig, defaultConfig)

		return clientConfig  -- ✅ Ajout du retour de la table mise à jour !
	end
	

	
	local function saveUpdatedConfig(filePath, updatedConfig, structure)
		-- version saveUpdatedConfig VA_1.50 (Correction des valeurs sous forme de table et commentaires)

		if updatedConfig.weather then
			for key, forcedValue in pairs(weather_override) do
				updatedConfig.weather[key] = forcedValue  -- **Écrase l'existant OU ajoute si absent**
			end
		end

		local file = io.open(filePath, "w")
		if not file then error("Cannot open file for writing: " .. filePath) end
	
		local indentLevel = 0
		local stack = {}  -- Suivi des tables imbriquées
	
		-- ✅ Fonction d'indentation stricte
		local function getIndent(level)
			return string.rep("\t", level)
		end
	
		-- -- ✅ Fonction pour récupérer la vraie valeur (sans toujours mettre des strings)
		-- local function getFormattedValue(value)
			
		-- 	-- ✅ Si `value` est une table contenant { value = ..., comment = ... }
		-- 	if type(value) == "table" and value.value ~= nil then
		-- 		return getFormattedValue(value.value) -- Récupérer directement `value`
		-- 	end
		
		-- 	-- ✅ Gestion des types normaux (string, booléens, nombres)
		-- 	if type(value) == "string" then
		-- 		if value == "true" or value == "false" then
		-- 			return value -- Garder sans guillemets
		-- 		elseif tonumber(value) then
		-- 			return value -- Convertir en nombre
		-- 		else
		-- 			return '"' .. value:gsub('"', '') .. '"' -- Supprime les doubles guillemets parasites
		-- 		end
		-- 	elseif type(value) == "boolean" then
		-- 		return tostring(value)
		-- 	elseif type(value) == "number" then
		-- 		return value
		-- 	elseif type(value) == "table" then
		-- 		-- 🔍 Vérifier si c'est une liste indexée
		-- 		local isArray = (#value > 0) and (next(value, #value) == nil)
			
		-- 		if isArray then
		-- 			return "{ " .. table.concat(value, ", ") .. " }"  -- ✅ Format propre des listes !
		-- 		else
		-- 			local formattedTable = {}
		-- 			for k, v in pairs(value) do
		-- 				table.insert(formattedTable, "[" .. tostring(k) .. "] = " .. getFormattedValue(v))
		-- 			end
		-- 			return "{ " .. table.concat(formattedTable, ", ") .. " }"
		-- 		end

		-- 	else
		-- 		return tostring(value)
		-- 	end
		-- end
		
	
		local function writeStructureLines(currentTable, structure, level)
			
			local maxKeyLength = 0
			local maxValueLength = 0
			
			for i, line in ipairs(structure) do
				local trimmedLine = line:match("^%s*(.-)%s*$") -- Supprimer espaces début/fin
				-- print("A "..line)

				local key, value, comment = line:match('(%S+)%s*=%s*([^%s,]+)%s*,?%s*%-%-%s*(.*)')
				if not key then
					key, value = line:match('(%S+)%s*=%s*([^%s,]+)')
				end
	
				-- ✅ Conserver les commentaires et lignes vides
				if trimmedLine:match("^%-%-") or trimmedLine == "" then
					-- print("B "..getIndent(level) .. line .. "\n")
					file:write(getIndent(level) .. line .. "\n")
	
				-- ✅ Détection des tables sur une seule ligne
				elseif trimmedLine:match("(%S+)%s*=%s*{.-}%s*,?%s*$") then
					local key = trimmedLine:match("(%S+)%s*=%s*{")
					local clientValue = currentTable[key]
					if clientValue then
						-- print("C1 "..getIndent(level) .. key .. " = " .. getFormattedValue(clientValue) .. ",\n")
						file:write(getIndent(level) .. key .. " = " .. getFormattedValue(clientValue) .. ",\n")
					end
	
				-- ✅ Détection de déclaration de table avec indentation correcte
				elseif trimmedLine:match("(%S+)%s*=%s*{") then
					local key = trimmedLine:match("(%S+)%s*=%s*{")
					local clientValue = currentTable[key]
					if clientValue and type(clientValue) == "table" and next(clientValue) then
						-- print("D1 "..getIndent(level) .. key .. " = {\n")
						file:write(getIndent(level) .. key .. " = {\n")
						table.insert(stack, { name = key, table = currentTable })
						currentTable = clientValue
						level = level + 1
						-- print("D2 #stack "..tostring(#stack))
					end
	
					-- ✅ Détection des fermetures de table
					elseif trimmedLine:match("^%s*}%s*[,]?") then
						-- print("E1 #stack "..tostring(#stack))
						if #stack > 0 then
							local popped = table.remove(stack)
							currentTable = popped.table
							level = level - 1
						end

						-- 🏗 Vérifier si on doit ajouter une virgule après `}`
						local nextLine = structure[i + 1] or ""
						local addComma = not nextLine:match("^%s*}%s*$")

						if level > 0 then
							-- print("E2 "..getIndent(level) .. "}" .. (addComma and "," or "") .. "\n")
							-- print("E2 "..getIndent(level) .. "}" .. (addComma and ",") .. "\n")
							-- file:write(getIndent(level) .. "}" .. (addComma and ",") .. "\n")
							file:write(getIndent(level) .. "}" .. (addComma and "," or "") .. "\n")
						else
							-- print("E3 "..getIndent(level) .. "}\n")
							file:write(getIndent(level) .. "}\n")
						end
	
				-- ✅ Gestion des affectations (Valeur + Commentaire propre)
				else
					local key, value, comment = line:match('(%S+)%s*=%s*(.-)%s*%-%-%s*(.*)')
					if not key then
						key, value = line:match('(%S+)%s*=%s*(.-)%s*$')
					end

					-- print("F1 ")

					if key then
						local clientValue = currentTable[key] or value
						local formattedValue = getFormattedValue(clientValue)

						-- 📏 Calcul de la largeur max des clés pour un alignement automatique
						local keyColumnWidth = 0  
						for k, _ in pairs(currentTable) do
							if type(k) == "string" then
								keyColumnWidth = math.max(keyColumnWidth, #k)
							end
						end
						keyColumnWidth = keyColumnWidth + 2  -- Ajout de 2 espaces pour plus de lisibilité

					
						-- 🏗 Ajustement de l'alignement
						local spacingAfterKey = string.rep(" ", keyColumnWidth - #key)

						local spacingAfterEqual = " "  
						local valueColumnWidth = 8  -- 🛠 Réduit l'espace après la valeur
						local spacingAfterValue = string.rep(" ", math.max(1, valueColumnWidth - #tostring(formattedValue))) 
					
						-- 📝 Vérifier si on ajoute une virgule
						local nextLine = structure[i + 1] or ""
						local addComma = not nextLine:match("^%s*}%s*$")
					
						-- 📌 Écriture avec **espacement plus serré**
						if comment then
							-- print("F2 "..getIndent(level) .. key .. spacingAfterKey .. "=" .. spacingAfterEqual .. formattedValue .. (addComma and "," or "") .. spacingAfterValue .. "-- " .. comment .. "\n")
							file:write(getIndent(level) .. key .. spacingAfterKey .. "=" .. spacingAfterEqual .. formattedValue .. (addComma and "," or "") .. spacingAfterValue .. "-- " .. comment .. "\n")
						else
							-- print("F3 "..getIndent(level) .. key .. spacingAfterKey .. "=" .. spacingAfterEqual .. formattedValue .. (addComma and ",") .. "\n")
							file:write(getIndent(level) .. key .. spacingAfterKey .. "=" .. spacingAfterEqual .. formattedValue .. (addComma and ",") .. "\n")
						end
					end
				end
			end
	
			-- ✅ Vérification finale : s'assurer que toutes les tables sont bien fermées
			while #stack > 0 do
				local popped = table.remove(stack)
				level = level - 1
				file:write(getIndent(level) .. "}\n")
			end

			-- 🖼️ Ajout manuel de `pictureBrief` à la fin si présent
			if currentTable.pictureBrief then
				file:write("\n" .. getIndent(level) .. "pictureBrief = {\n")
				level = level + 1
				
				for category, images in pairs(currentTable.pictureBrief) do
					file:write(getIndent(level) .. category .. " = {\n")
					for _, image in ipairs(images) do
						file:write(getIndent(level + 1) .. '"' .. image .. '",\n')
					end
					file:write(getIndent(level) .. "},\n")  -- Fermeture de `blue` ou `red`
				end

				level = level - 1
				file:write(getIndent(level) .. "}\n")  -- Fermeture de `pictureBrief`
			end

	
		end
	
		-- print("[saveUpdatedConfig] 🔍 Contenu final avant écriture :")
		-- Display(updatedConfig, "FINAL")


		-- ✅ Écrire la structure dans le fichier en respectant les valeurs du client
		writeStructureLines(updatedConfig, structure, indentLevel)
	
		file:close()
	end
	
    -- Chemins des fichiers de configuration
    local clientConfigPath = "Init/conf_mod.lua"
    local defaultConfigPath = "../../../ScriptsMod." .. versionPackageICM .. "/UTIL_ConfModCheck.lua"


    -- Charger les fichiers de configuration client et par défaut
    local clientConfig, clientStructure = loadConfigWithStructure(clientConfigPath)

	-- 🌟 Sauvegarde `pictureBrief` original AVANT toute modification
	local backupPictureBrief = clientConfig.pictureBrief and Deepcopy(clientConfig.pictureBrief) or nil

    local defaultConfig, defaultStructure = loadConfigWithStructure(defaultConfigPath)

	mergeTables(clientConfig, defaultConfig, clientStructure)


    -- Nettoyer les variables obsolètes du client
    clientConfig = removeObsoleteEntries(clientConfig, defaultConfig)

	-- Mettre à jour la configuration client avec les valeurs par défaut manquantes
	clientConfig = updateConfiguration(clientConfig, defaultConfig)

	if backupPictureBrief then
		-- print("🔄 Restauration de `pictureBrief` après traitement !")
		clientConfig.pictureBrief = backupPictureBrief
	end
	

	-- Sauvegarder la configuration mise à jour
	-- clientConfigPath = "Init/conf_mod_BBB.lua"
	saveUpdatedConfig(clientConfigPath, clientConfig, defaultStructure)

	dofile("Init/conf_mod.lua")
end	


  --a function that automatically updates the conf_mod keeping as much as possible the old settings of the player
function UpdateConfMod_OLD_INIT()

	dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_ConfModCheck.lua")
	local confModCheck = {
		mission_ini = mission_ini_check,
		mission_forcedOptions = mission_forcedOptions_check,
		-- campaign_ini = campaign_ini_check,
		Debug = Debug_check,
		campMod = campMod_check,

	}

	local monfichier = io.open("../../../ScriptsMod."..versionPackageICM.."/UTIL_ConfModCheck.lua", "r")

	if not monfichier then return end

	io.input(monfichier)

	local tableName, tableNameSub, tableId
	local txt = ""
	local nTable = {}
	local n = 0
	local ligne = 0

	for line in io.lines() do
		local one, two, com, com1, com2, varName, str_length, result, comTemp, com1a, com2b, showVarName
		local firstTab = ""
		local nextTab = ""

		ligne = ligne +1
		--cherche le nom de la table "principal" dans le fichier de ref UTIL_ConfModCheck
		if string.find(line, "=") and string.find(line, "{") and not string.find(line, "versionDCE")  then
			n = n +1																								--compte le nombre de sous table
			one, two = line:match("(.*)=(.*)")																		--s�pare la ligne en 2, au niveau de =
			if string.find(one, "_check") and not string.find(one, "%-%-") then										--trouve le nom d'une table principale, finissant par _check
				tableName = one:gsub("_check", "")
				tableName = tableName:gsub("	", "")
				tableName = tableName:gsub(" ", "")
				nTable[n] = tableName																				--compte le nombre de sous-table, ici, on ajoute n+1
				txt = txt ..""..tableName.." = {\n"
			--cherche le nom de la table "secondaire n+1"
			elseif not string.find(one, "%-%-") then																--si la ligne n'est pas un commentaire
				tableNameSub = one:gsub("	", "")
				tableNameSub = tableNameSub:gsub(" ", "")
				nTable[n] = tableNameSub
				for m = 2, n do
					firstTab = firstTab.."	"
				end
				txt = txt ..firstTab..tableNameSub.." = {\n"
			end

			--colle les valeurs weather de campaign_ini
			if nTable[2] == "weather" then
				-- if 
			end

		--cherche le nom de la variable (key)
		elseif string.find(line, "=") and string.find(line, ",") and not string.find(line, "{") then
			one, two = line:match("(.*)=(.*)")																		--s�pare la ligne en 2, au niveau de =

			if  not string.find(one, "%-%-") then
				varName = one:gsub("	", "")
				showVarName = varName

				if string.find(varName, "%[") then																--si la key est une autre table, on enleve les crochets, guillemet				
					varName = varName:gsub("%[", "")
					varName = varName:gsub("%]", "")
					varName = varName:gsub("\"", "")

					if string.sub(varName, -1) == " " then
						varName = varName:sub(1, -2)
					end
				else
					varName = varName:gsub(" ", "")

				end
			end
			--traitement du commentaire avec la valeur de la variable
			com1, com2 = two:match("(.*)-(.*)")
			if com2 and string.find(com2, "%-%-") then
				comTemp, com2 = com2:match("(.*)-(.*)")
			end

		elseif string.find(line, "}") and not string.find(line, "=") then
			nTable[n] = nil																								--supprime la sous-table, comme si on fermait par }
			n = n -1																									--ferme la sous table ou l'iteration
			txt = txt ..""..line.."\n"
		else
			txt = txt ..""..line.."\n"
		end

		if not com2 or com2 == nil then
			com2 = ""
		end

		-- _affiche(nTable, "UtilF AA nTable")

		local check = {}
		if (nTable[1] == "mission_ini" or nTable[1] == "mission_forcedOptions" or nTable[1] == "Debug" or nTable[1] == "campMod" ) and varName then
				
			if nTable[1] == "mission_ini" then 
				tableId = mission_ini												-- donne le nom de la clef
				
			elseif nTable[1] == "mission_forcedOptions" then 
				tableId = mission_forcedOptions						-- donne le nom de la clef
				
			elseif nTable[1] == "Debug" then 
				tableId = Debug														-- donne le nom de la clef
				
			elseif nTable[1] == "campMod" then 
				tableId = campMod													-- donne le nom de la clef

			end

			--test si les sous table existent
			-- si elle n'existe pas, on load la table _check � la place
			local notLoad = false
			local testSubTableId = Deepcopy(tableId)
			if #nTable >=2 then																						--iteration des cascades de sous table
				for n = 2, #nTable do
					if  testSubTableId[nTable[n]] == nil then
						notLoad = true
					else
						testSubTableId =  testSubTableId[nTable[n]]													--prend la valeur de la table du joueur  n-1
					end
				end
			end

			--la table est inconnue dans le conf_mod du joueur, donc  on load la table _check � la place
			if not tableId or notLoad then
				if nTable[1] == "mission_ini" then tableId = mission_ini_check
				elseif nTable[1] == "mission_forcedOptions" then tableId = mission_forcedOptions_check
				elseif nTable[1] == "Debug" then tableId = Debug_check
				elseif nTable[1] == "campMod" then tableId = campMod_check
				-- elseif nTable[1] == "campaign_ini" then tableId = campaign_ini_check
				end
			end

			_affiche(tableId, "UtilF BB tableIdA")

			print()
			print("#nTable "..tostring(#nTable))

			for m = 1, n do
				firstTab = firstTab.."	"
			end
			if #nTable >=2 then																						--iteration des cascades de sous table
				for m = 2, #nTable do
					print("m "..m)
					_affiche(nTable[m], "UtilF CC nTable[m]")

					tableId =  tableId[nTable[m]]																	--prend la valeur de la table n-1
				end
			end

			if camp.weather then
				if tableId.pHigh and camp.weather.pHigh then  tableId.pHigh = camp.weather.pHigh  end
				if tableId.pLow and camp.weather.pLow then tableId.pLow = camp.weather.pLow end
				if tableId.refTemp and camp.weather.refTemp then tableId.refTemp = camp.weather.refTemp end
			end

			-- on lui colle la value du conf_mod player
			if  not tableId[varName] then
				if com1 then
					com1a, com2b = com1:match("(.*),(.*)")

					com1a = com1a:gsub(" ", "")
					if  not string.find(com1a, "true") and not string.find(com1a, "false") and not string.find(com1a, ".") and not string.find(com1a, "\"") and  type(com1a) ~= "number" then
						com1a = "\""..com1a.."\""
					end
					tableId[varName] = com1a

					if varName == "selectLoadout" and mission_ini.SelectLoadout then tableId[varName] = "\""..mission_ini.SelectLoadout.."\"" end
				else
					if n == 2 then
						--si la ligne est inconnue (donc la variable) du conf_mod joueur, on lui colle la valeur du UTIL_ConfModCheck
						tableId[varName] = confModCheck[nTable[1]][nTable[n]][varName]
					elseif n == 3 then
						tableId[varName] = confModCheck[nTable[1]][nTable[n-1]][nTable[n]][varName]
					elseif n== 4 then
						tableId[varName] = confModCheck[nTable[1]][nTable[n-2]][nTable[n-1]][nTable[n]][varName]
					end
				end
			end

			-- --récupère et format la valeur de la variable
			-- local resultNumber = tonumber(tableId[varName])
			-- local varIsStrBoolean = false

			-- if  type(tableId[varName]) ~= "boolean"	and not (string.find(tableId[varName], "true") or string.find(tableId[varName], "false"))
			-- and  not resultNumber then
			-- 	if com1a and not string.find(com1a, "\"") then
			-- 		result = tableId[varName]
			-- 	end

			-- 	if not string.find(tableId[varName], "\"") then
			-- 		result = "\""..tableId[varName].."\""
			-- 	else
			-- 		result = tableId[varName]
			-- 	end
			-- else
			-- 	result = tableId[varName]
			-- end

			--récupère et format la valeur de la variable
			local resultNumber
			local varIsStrBoolean = false
			local foundComma = false

			if tableId and varName and tableId[varName] then
				local checkValue = tableId[varName]
				resultNumber = tonumber(checkValue)

				-- print("UtilF varName: "..tostring(varName) .. " |:| "..tostring(tableId[varName]) )
				if checkValue and type(checkValue) == "string" then
					if string.find(checkValue, "\"") then
						foundComma = true
					end
					if (checkValue == "true" or checkValue == "false") then
						varIsStrBoolean = true
					end

				end
			end

			if  type(tableId[varName]) ~= "boolean" and not varIsStrBoolean and not resultNumber then
				if com1a and not string.find(com1a, "\"") then
					result = tableId[varName]
				end

				if not foundComma then
					result = "\""..tableId[varName].."\""
				else
					result = tableId[varName]
				end
			else
				result = tableId[varName]
			end


			--calcul l'espace necessaire pour afficher les commentaires
			str_length = string.len(tostring(firstTab..showVarName.." = "..tostring(result)))
			for n = 1, 14 - math.floor(str_length/4) do
				nextTab = nextTab .. "	"
			end

			txt = txt..firstTab..showVarName.." = "..tostring(result)..","..nextTab.."--"..com2.."\n"
		end
	end

	io.close(monfichier)

	txt = txt.. "pictureBrief = " .. TableSerialization(pictureBrief, 0)

	local updateFile = io.open("Init/conf_mod.lua", "w") or error("Failed to open debug file")
	updateFile:write(txt)																		--save new data

	io.close(updateFile)

	dofile("Init/conf_mod.lua")
end

function ModifiCampInit()

	-- camp = {
	-- 	--any modification of this part requires a restart of the campaign to be taken into account.
	-- 	title = "WOC-80s-Blue-GC22-5",		--Title of campaign (name of missions)
	-- 	version = "V25-gc",
	-- 	mission = 1,					--campaig mission number
	-- 	date = {						--campaign date
	-- 		day = 6,
	-- 		year = 1986,
	-- 		month = 4,
	-- 	},
	-- 	time = 11700,					--Daytime in seconds
	-- 	variation = 4,					--variation in degrees from true north to magneitic north

	local txt = ""
	local nTab = 0
	local compareVariable = {
		"camp",
		"title",
		"version",
		"mission",
		"date",
		"day",
		"year",
		"month",
		"time",
		"variation"
	}

	local monfichier = io.open("Init/camp_init.lua", "r") or error("Failed to open debug file")

	io.input(monfichier)
	local n = 0
	local nTab = {
		false,
		false,
		false,
		false,
	}
	for line in io.lines() do

		local addLine = false
		local varString, com2, comTemp

		if string.find(line, "%-%-")  then
			--traitement du commentaire avec la valeur de la variable
			varString, com2 = line:match("(.*)-(.*)")
			if com2 and string.find(com2, "%-%-") then
				comTemp, com2 = com2:match("(.*)-(.*)")
			end
		else
			varString = line
		end

		if string.find(line, "{")   then n = n+1  end
		if string.find(line, "}")   then n = n-1  end

		if varString ~= nil and string.find(varString, "=") then

			local varString, varValue = varString:match("(.*)=(.*)")

			varString = varString:gsub(" ", "")
			varString = varString:gsub("\t", "")

			for m, varRef in ipairs(compareVariable) do

				if varString == varRef  then
					txt = txt .. line .. "\n"
					addLine = true
					if string.find(line, "{")   then nTab[n] = true end
					if string.find(line, "}")   then nTab[n+1] = false end
					-- print("UtilF passe ADD  H n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]))
					break
				end
			end

			if string.find(line, "}") and not addLine and varString == nil   then
				n = n - 1
				if not addLine then
					txt = txt .. line .. "\n"
					if string.find(line, "{")   then nTab[n] = true end
					if string.find(line, "}")   then nTab[n+1] = false end
					-- print("UtilF passe ADD  I n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]))
					break
				end
			end

		else

			if not string.find(line, "}")   then
				txt = txt .. line .. "\n"
				-- print("UtilF passe ADD  J n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]))
			else

				-- print("UtilF passe ADD  K1 n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]).." nTabn+1 "..tostring(nTab[n+1]))

				if nTab[n+1] == true then
					txt = txt .. line .. "\n"
					-- print("UtilF passe ADD  K2 n:|"..tostring(n).." nTab[n]: "..tostring(nTab[n]))
					nTab[n+1] = false
				end
			end

		end

	end

	io.close(monfichier)

	local updateFile = io.open("Init/camp_init.lua", "w") or error("Failed to open debug file")
	updateFile:write(txt)																		--save new data

	io.close(updateFile)

	dofile("Init/camp_init.lua")

end

--assigne un CallName � tous les squad West pour tout le reste de la campagne 
function AssignCallnameSquad()
	--le callsign ou callname sera dorenavant assign� � un squad "west" pour toute la campagne
	--par default, l'assignation se fait lors de la premiere mission ou a n'importe quel skipMission si cela n'avait pas �t� fait avant
	--l'assignation se fait en priorit� avec des SpecificCallnames s'ils existent, ensuite, le choix est automatique et al�atoire.
	--le joueur � la possibilit� de "forcer" le callsign � un ou plusieurs squads dans Init/oob_air_init.lua
	--Il peut meme le changer au cours de la campagne, DCE le prendra en compte
	-- il existe une "protection" contre les mauvais callsign ajout� par le joueur, s'il se trompe
	--https://wiki.hoggitworld.com/view/DCS_enum_callsigns

	--******************************

	--the callsign or callname will now be assigned to a "west" squad for the entire campaign
	--by default, the assignment is done at the first mission or at any skipMission if it was not done before
	--the assignment is done in priority with SpecificCallnames if they exist, then, the choice is automatic and random.
	--the player has the possibility to "force" the callsign to one or more squads in Init/oob_air_init.lua
	--he can even change it during the campaign, DCE will take it into account
	-- there is a "protection" against bad callsign added by the player, if he is wrong
	--https://wiki.hoggitworld.com/view/DCS_enum_callsigns



	--si le joueur veut changer de callname � un squad, nous mettons � jour le Active/oob_air par rapport au Init/oob_air_init
	dofile("Init/oob_air_init.lua")
	local initOobAir = Deepcopy(oob_air)

	oob_air = nil

	dofile("Active/oob_air.lua")

	for initSide, initUnit in pairs(initOobAir) do
		for n = 1, #initUnit do
			if initUnit[n].callsign then												--si le joueur a enregistr� une callname perso
				for side, unit in pairs(oob_air) do
					for r = 1, #unit do
						if unit[r].name == initUnit[n].name and unit[r].callsign ~= initUnit[n].callsign then				--si c'est le meme suad

							unit[r].callsign = initUnit[n].callsign
							-- print("utilFct CORRECTION callsign "..unit[r].callsign)
							-- os.execute 'pause'
						end
					end
				end
			end
		end
	end



	local CallSigneAssigned = {}

	for side,unit in pairs(oob_air) do
		for n = 1, #unit do
			--regarde les CallName d�j� attribu� par le concepteur de campagne
			-- if WestCallsign[unit[n].country] == "west" and unit[n].callsign then
			if IsWesternCountry(unit[n].country) and unit[n].callsign then
				CallSigneAssigned[unit[n].callsign] = true
			end
		end
	end

	for side, unit_ in pairs(oob_air) do
		for n = 1, #unit_ do
			local unit = unit_[n]
			local category
			if  not unit.inactive then
				local Imax = 0
				-- if WestCallsign[unit.country] == "west" and not unit.callsign then
				if IsWesternCountry(unit.country) and not unit.callsign then
						local assigneOk = false

						--s'il existe une table avec des CallName sp�cifique � un type d'avion
						if  SpecificCallnames[unit.type] and SpecificCallnames[unit.type][unit.country]  then

							--recherch l'index le plus haut de la table SpecificCallnames
							local Imax = 0
							for index, value in pairs(SpecificCallnames[unit.type][unit.country]) do
								if index > Imax then
									Imax = index
								end
							end

							local j = 0
							repeat
								local i =  math.random(9, Imax)

								if not CallSigneAssigned[SpecificCallnames[unit.type][unit.country][i]] then
									unit.callsign = SpecificCallnames[unit.type][unit.country][i]
									unit.callsignId = i
									CallSigneAssigned[unit.callsign] = true
									assigneOk = true
									break
								end
								j = j + 1
							until j > 50 or assigneOk
						end

						if not assigneOk then
							if unit.tasks["AWACS"] then
								category = "AWACS"
							elseif unit.tasks["Refueling"] then
								category = "tanker"
							else
								category = "generic"
							end

							for i = 1, #Callsign_west[category] do
								if not CallSigneAssigned[Callsign_west[category][i]] then
									unit.callsign = Callsign_west[category][i]
									unit.callsignId = i
									CallSigneAssigned[unit.callsign] = true
									assigneOk = true
									break
								end
							end

							if not assigneOk then
								local i =  math.random(1, #Callsign_west[category])
								unit.callsign = Callsign_west[category][i]
								unit.callsignId = i
								CallSigneAssigned[unit.callsign] = true
								assigneOk = true
								break
							end
						end

				-- elseif WestCallsign[unit.country] == "west" and unit.callsign then								--controle si le callsign renseign� par le joueur/campaignMaker est compatible
				elseif IsWesternCountry(unit.country) and unit.callsign then
					local GoodCallSign = false
					if  not unit.inactive and SpecificCallnames[unit.type] and SpecificCallnames[unit.type][unit.country]  then

						--recherch l'index le plus haut de la table SpecificCallnames
						local Imax = 0
						for index, value in pairs(SpecificCallnames[unit.type][unit.country]) do
							if index > Imax then
								Imax = index
							end
						end
						for i = 9, Imax do
							if SpecificCallnames[unit.type][unit.country][i] == unit.callsign then
								unit.callsignId = i
								GoodCallSign = true
								break
							end
						end
					end

					if not GoodCallSign then
						if unit.tasks["AWACS"] then
							category = "AWACS"
						elseif unit.tasks["Refueling"] then
							category = "tanker"
						else
							category = "generic"
						end
						for i = 1, #Callsign_west[category] do
							if Callsign_west[category][i] == unit.callsign then
								GoodCallSign = true
								unit.callsignId = i
								break
							end
						end
					end

					if not GoodCallSign then
						print("Error(UtilFct) This callsign: ("..tostring(unit.callsign)..") is not compatible with this type of aircraft ("..tostring(unit.type)..")")
						print(" This callsign is ignored for this mission. Change this callsign in /Init/oob_air_init.lua for this squadron ("..tostring(unit.name)..")")
						print(" select a new callsign corresponding to the aircraft type as in this page. Or delete it, DCE will automatically assign the right one.")
						print("https://wiki.hoggitworld.com/view/DCS_enum_callsigns")
						os.execute 'pause'
						unit.callsign = nil
					end
				end
			end
		end
	end
end

function InsertBugList(txt)
	if not BugList then BugList = {} end

	if #BugList >=1 then
		for n=1, #BugList do
			if BugList[n] == txt then
				-- le bug est déjà enregistré, inutile de l'ajouter
				return
			end
		end
	end

	table.insert(BugList,txt)

end


	--sort() trie la table alpha en fonction du priority
function TargetlistToNum()
	local targetlistTempB = {}

	for target_name, target in pairs(targetlist["blue"]) do
		target.titleName = target_name
		if not target.name then target.name = target_name end
		-- print("UtilFct titleName "..tostring(target.titleName))
		table.insert(targetlistTempB, target)
	end
	table.sort(targetlistTempB,  function(a,b)  return a.priority > b.priority  end)
	targetlist["blue"] = targetlistTempB

	local targetlistTempB = {}
	for target_name, target in pairs(targetlist["red"]) do
		target.titleName = target_name
		if not target.name then target.name = target_name end
		-- print("UtilFct titleName "..tostring(target.titleName))
		table.insert(targetlistTempB, target)
	end
	table.sort(targetlistTempB,  function(a,b)  return a.priority > b.priority  end)
	targetlist["red"] = targetlistTempB

end


function ListSpotterAircraft()
	-- local isAfacAircraft = {}
	-- for side, oob_side in pairs(oob_air) do
	-- 	for n, sqd in pairs(oob_side) do
	-- 		if sqd.type and TaskByPlane.AFAC[sqd.type] then
	-- 			isAfacAircraft[sqd.type] = true
	-- 		end
	-- 	end
	-- end
	-- return isAfacAircraft

	local isAfacAircraft = {}
	for side, oob_side in pairs(oob_air) do
		for n, sqd in pairs(oob_side) do
			if sqd.tasks  then
				for taskName, value in pairs(sqd.tasks) do
					if string.lower(taskName) == "spotter" and value == true then
						isAfacAircraft[sqd.type] = true
					end
				end
			end
		end
	end

	return isAfacAircraft

end


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


-- Fonction pour convertir les degrés en radians
local function deg_to_rad(deg)
    return deg * (math.pi / 180)
end

-- Fonction pour convertir les radians en degrés
local function rad_to_deg(rad)
    return rad * (180 / math.pi)
end


-- Constantes pour WGS84
local a = 6378137.0 -- Demi-grand axe en mètres (WGS84)
local f = 1 / 298.257223563 -- Aplatissement inverse (WGS84)
local e2 = 2 * f - f * f -- Excentricité au carré
local k0 = 0.9996 -- Facteur d'échelle sur le méridien central

-- Fonction pour convertir des coordonnées UTM en latitude et longitude
local function dcs_to_gps(easting, northing, P0_lat, P0_lon)
    -- Convertir l'origine en radians
    local lat0_rad = math.rad(P0_lat)
    local lon0_rad = math.rad(P0_lon)

    -- Delta en mètres par rapport au point de référence P0
    local delta_easting = easting
    local delta_northing = northing

    -- Calcul du méridien d'origine
    local M0 = a * ((1 - e2 / 4 - 3 * e2^2 / 64 - 5 * e2^3 / 256) * lat0_rad
                - (3 * e2 / 8 + 3 * e2^2 / 32 + 45 * e2^3 / 1024) * math.sin(2 * lat0_rad)
                + (15 * e2^2 / 256 + 45 * e2^3 / 1024) * math.sin(4 * lat0_rad)
                - (35 * e2^3 / 3072) * math.sin(6 * lat0_rad))

    -- Calcul de la latitude intermédiaire
    local M = M0 + delta_northing / k0
    local mu = M / (a * (1 - e2 / 4 - 3 * e2^2 / 64 - 5 * e2^3 / 256))

    -- Calcul de phi1 (latitude initiale en radians)
    local phi1_rad = mu + (3 * (3 * e2 / 8 + 3 * e2^2 / 32 + 45 * e2^3 / 1024) / 2) * math.sin(2 * mu)
                    + (21 * e2^2 / 16 - 55 * e2^3 / 32) * math.sin(4 * mu)
                    + (151 * e2^3 / 96) * math.sin(6 * mu)

    -- Calcul des termes nécessaires
    local N1 = a / math.sqrt(1 - e2 * math.sin(phi1_rad)^2)
    local T1 = math.tan(phi1_rad)^2
    local C1 = e2 * math.cos(phi1_rad)^2 / (1 - e2)
    local R1 = a * (1 - e2) / ((1 - e2 * math.sin(phi1_rad)^2) ^ 1.5)
    local D = delta_easting / (N1 * k0)

    -- Calcul de la latitude finale
    local latitude_rad = phi1_rad - (N1 * math.tan(phi1_rad) / R1) * (D^2 / 2 - (5 + 3 * T1 + 10 * C1 - 4 * C1^2 - 9 * e2) * D^4 / 24
                    + (61 + 90 * T1 + 298 * C1 + 45 * T1^2 - 252 * e2 - 3 * C1^2) * D^6 / 720)

    -- Calcul de la longitude finale
    local longitude_rad = lon0_rad + (D - (1 + 2 * T1 + C1) * D^3 / 6 + (5 - 2 * C1 + 28 * T1 - 3 * C1^2 + 8 * e2 + 24 * T1^2) * D^5 / 120) / math.cos(phi1_rad)

    -- Conversion en degrés
    local latitude = math.deg(latitude_rad)
    local longitude = math.deg(longitude_rad)

    return latitude, longitude
end

-- Fonction pour convertir les degrés en radians
local function toRadians(degrees)
    return degrees * math.pi / 180
end

-- Fonction pour convertir les radians en degrés
local function toDegrees(radians)
    return radians * 180 / math.pi
end

-- Implémentation de atan2 manuelle
local function atan2(y, x)
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

-- Fonction pour vérifier l'existence d'un fichier
function FileExists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- Écriture sécurisée dans un fichier
function WriteToFile(path, content)
    local file, err = io.open(path, "w")
    if not file then
        error("Impossible d'ouvrir le fichier '" .. path .. "' pour écriture : " .. tostring(err))
    end
    file:write(content)
    file:close()
end

function CheckTarawa(txt)

	for basename, base in pairs(db_airbases) do															--iterate through airbases
		if base.unitname and base.unitname == "LHA_Tarawa" then																			--if airbase is a carrier, find the unit in the OOB Ground
			print("UtilF LHA_Tarawa "..txt.." "..tostring(base.x) )
		end
	end
end




