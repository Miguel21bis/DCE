-- script for campaignMakers,
-- file to add to a simple mission (using the mission editor), add circles with a future target name, and the elements will be added to a file in targetList format
-------------------------------------------------------------------------------------------------------
-- last modification:  
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/objectMapDetect.lua"] = "1.1.4"
-------------------------------------------------------------------------------------------------------

local acceptedTargetTypes = {
	['ULAK001'] = "Warehouse",
	['ULAK004'] = "Warehouse",
	['ULAK015'] = "Warehouse",
	['ULAK058'] = "Warehouse",
	['ULAK082'] = "Warehouse",
	['UMOE16'] = "Warehouse",
	['SMAC01_MILITARY_TRAINING_CENTRE_D'] = "Warehouse",
	['SMAC36_ANCILLARY_BUILDING_04'] = "Warehouse",
	['WAREHOUSE_04'] = "Warehouse",
	['ULAK066'] = "Warehouse",
	['ENNA32'] = "Warehouse",
	['XLMV01'] = "Warehouse",
	['XLMV04'] = "Warehouse",
	['XLMV08'] = "Warehouse",
	['XLMV43'] = "Warehouse",
	['XLMV45'] = "Warehouse",
	['XLMV56'] = "Warehouse",
	['BODO216'] = "Warehouse",
	['ESPA16'] = "Warehouse",
	['UMOE64'] = "Warehouse",
	['ULAK006'] = "Warehouse",
	['XLMV40'] = "Power Plant",
	['WAREHOUSE_02'] = "Power Plant",
	['ELECTRIC_TRANSFORMER_01'] = "Power Supply",
	['UMOE46'] = "Power Supply",
	['ULAK055'] = "Power Supply",
	['ULAK105'] = "Power Supply",
	['ULAK107'] = "Power Supply",
	['UMOE73'] = "Fuel Storage",
	['ULAK062'] = "Fuel Storage",
	['SILO_01'] = "Fuel Storage",
	['SILO_02'] = "Fuel Storage",
	['SILO_03'] = "Fuel Storage",
	['UMOE31'] = "Fuel Storage",
	['XLMV42'] = "Fuel Storage",
	['UMOE36'] = "Fuel Storage",
	['UMOE10'] = "Logistic Center",
	['UOLE13'] = "Logistic Center",
	['XLMV06'] = "Logistic Center",
	['ORBX_HAS_03'] = "Ammo Supply",
	['SMS201'] = "Ammo Supply",
	['XLMW47'] = "Control Tower",
	['KDP'] = "Control Tower",
	['ULAK068'] = "Command Center",
	['ULAK077'] = "Communication Center",
	['ORBX_HAS_04'] = "Airplane Shelter",
	['ESPA14'] = "Airplane Shelter",
	['CAR_BRIDGE_2LINE'] = "Road Bridge",
    ['CAR_BRIDGE_4LINE'] = "Road Bridge",
    ['WOODEN_BRIDGE_2LINE'] = "Road Bridge",
    ['RW_BRIDGE_1LINE'] = "Rail Bridge",
    ['RW_BRIDGE_2LINE'] = "Rail Bridge",
    ['CRANE_01'] = "Loading Crane",
    ['LOADING_CRANE_01'] = "Loading Crane",
    ['LOADING_CRANE_02'] = "Loading Crane",
    ['LOADING_CRANE_03'] = "Loading Crane",
    ['BOAT001'] = "Civil Ship",
    ['BOAT003'] = "Civil Ship",
    ['BOAT010'] = "Civil Ship", 

}



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
local tabByNameIdx = {}

local function checkZone(searchZone,zoneName)

	local function IfFound(obj)
		local objVec3 = obj:getPoint()
		local objName = obj:getName()
		local objType = obj:getTypeName()

		if acceptedTargetTypes[objType] then
            local typeNameDCE = zoneName .. " " .. acceptedTargetTypes[objType]
			
            if not tabByNameIdx[objName] then
                tabByNameIdx[objName] = true
				
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
								name = tostring(typeNameDCE).." - 1",
								x = math.floor(objVec3.x * 100 + 0.5) / 100,
								y = math.floor(objVec3.z * 100 + 0.5) / 100,
							}
						}

					}
				else
					local element = {
						name = tostring(typeNameDCE).." - "..(#protoTargetList[zoneName].elements + 1),
							x = math.floor(objVec3.x * 100 + 0.5) / 100,
							y = math.floor(objVec3.z * 100 + 0.5) / 100,
					}
					table.insert(protoTargetList[zoneName].elements, element)
				end
			end
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
