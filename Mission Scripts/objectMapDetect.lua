
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
function TableSerialization(t, i, params)

	local crlf = ""
	local tab1 = ""
	for n = 1, i do
		tab1 = tab1 .. "\t"
	end

	local text = "\n"..crlf..tab1.."{\n"..crlf

	local tab = ""
	for n = 1, i + 1 do
		tab = tab .. "\t"
	end

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
	for n = 1, i do
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"		..crlf
	else
		text = text .. tab .. "},\n"	..crlf
	end
	return text
end



local protoTargetList = {}

local function checkZone(searchZone,zoneName)

	local function IfFound(obj)
		local objVec3 = obj:getPoint()
		-- local objName = obj:getName()
		local objType = obj:getTypeName()
		
		if not protoTargetList[zoneName] then
			protoTargetList[zoneName] = {
				inactive = true,
				task = "Strike",
				priority = 1,
				picture = {},
				attributes = {"Structure"},
				firepower = {
					min = 4,
					max = 8,
				},
				elements = {
					{
						name = zoneName.." - "..tostring(objType).." - 1",
						x = objVec3.x,
						y = objVec3.y,
						z = objVec3.z,
					}
				}

			}
		else
			local element = {
				name = zoneName.." - "..tostring(objType).." - "..#protoTargetList[zoneName].elements,
				x = objVec3.x,
				y = objVec3.y,
				z = objVec3.z,
			}
			table.insert(protoTargetList[zoneName].elements, element)
		end
	end

	local searchArea = {
		id = world.VolumeType.SPHERE,
		params = {
			point = {
				x = searchZone.point.x,
				y = land.getHeight({x = searchZone.point.x, y = searchZone.point.z}),
				z = searchZone.point.z
			},
			radius = searchZone.radius
		}
	}
	world.searchObjects(Object.Category.SCENERY, searchArea, IfFound)
end

for zoneN_, zone in pairs(env.mission.triggers.zones) do
	trigger.action.outText("zone.name: "..tostring(zone.name), 5)
	local searchZone = trigger.misc.getZone(zone.name)
	if searchZone then
		checkZone(searchZone, zone.name)
	end
end

local nbTarget = 0
local nbElements = 0
for zoneName_, zoneData in pairs(protoTargetList) do
	nbTarget = nbTarget + 1
	if zoneData.elements then
		nbElements = nbElements + #zoneData.elements
	end
end

trigger.action.outText("nbTarget: "..tostring(nbTarget).." nbElements: "..tostring(nbElements), 20)

local logStr = "protoTargetList = " .. TableSerialization(protoTargetList, 0)
local file = io.open("protoTargetList.lua", "w")

if file then
	file:write(logStr)
	file:close()
else
	env.info("DCE_avoidArea: Failed to open log file for writing.")
end
