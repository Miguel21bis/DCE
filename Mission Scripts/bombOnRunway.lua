-- Bruce_D
--https://forum.dcs.world/topic/204133-runway-damage/?do=findComment&comment=3859511
--23/05/2022
-- detects the impact of ammunition on a runway.
-- finds the life value of the runway
------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- last modification: Reglage_d
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts\bombOnRunway.lua"] = "1.4.10"
------------------------------------------------------------------------------------------------------- 					
-- cleanCode_a	
-- debug_d					(d getCategory)	
-- Reglage_d				(d time & sort) (c December 10, 2020)(b September 10, 2019)(a April 15, 2019)
-- modification M66_b		bombOnRunway (b:explode trigger)					
------------------------------------------------------------------------------------------------------- 

env.info("load bombOnRunway Start")


runwayLife = {} 						-- nome das bases incluso FARP
local baseAerea = world.getAirbases()	 -- todas as bases incluso FARP
WorksiteVehicles = {}

-- Object.Category
--   UNIT    1
--   WEAPON  2
--   STATIC  3
--   BASE    4
--   SCENERY 5
--   Cargo   6

for a, b in pairs(baseAerea) do 
	if Object.getCategory(b) == Object.Category.BASE then
		
		local Id = b:getID()
		local baseLife0 = b:getLife()
		local point = b:getPoint()

		runwayLife[Id] = {
			name = tostring(b:getName()),
			baseObject = b,
			life0 = baseLife0,
			life = 3600,
			point = point,
		}

	end	
end

function cleanWorksiteVehicles()
	for i, worker in ipairs(WorksiteVehicles) do
		
		local element = StaticObject.getByName(worker)
		element:destroy()
	end

	WorksiteVehicles = {}
end


function addWorksiteVehicles(arg)

	local pos = arg[1] 
	local runwayName = arg[2] 
	local countryId  = arg[3]
	local staticName = "t_e_m_p"

	local hidden = false
	-- if camp.debug then
	-- 	hidden = false
	-- end

	local posVehicle = {
		[1] = GetOffsetPoint( {x=pos.x, y=pos.z}, math.random(5,45),  math.random(50,100)),
		[2] = GetOffsetPoint( {x=pos.x, y=pos.z}, math.random(50,180),  math.random(50,100)),
		[3] = GetOffsetPoint( {x=pos.x, y=pos.z}, math.random(190,350),  math.random(50,100)),
	}

	-- env.info("bombOnRunway addWorksiteVehicles |x:|"..tostring(posVehicle[1].x).."|y:|"..tostring(posVehicle[1].y))

	--************* [1] ***************************
	staticName = "Static_"..tostring(runwayName).."_1_ATZ-60_Maz_"..math.floor(timer.getTime())
	local staticObj = {
		["category"] = "Unarmed",
		["type"] = "ATZ-60_Maz",
		["rate"] = 3,
		["y"] =  posVehicle[1].y,
		["x"] = posVehicle[1].x,
		["name"] = staticName,
		["heading"] = 4.5378560551853,
		["dead"] = false,
	}
	table.insert(WorksiteVehicles, staticName )
	coalition.addStaticObject(countryId, staticObj)


	--************* [2] ***************************
	staticName = "Static_"..tostring(runwayName).."_2_S-75 Tractor (ZIL-131)_"..math.floor(timer.getTime())
	staticObj = {
		["category"] = "Unarmed",
		["type"] = "S_75_ZIL",
		["rate"] = 3,
		["y"] =  posVehicle[2].y,
		["x"] = posVehicle[2].x,
		["name"] = staticName,
		["heading"] = 4.5378560551853,
		["dead"] = false,
	}
	table.insert(WorksiteVehicles, staticName )
	coalition.addStaticObject(countryId, staticObj)


	--************* [3] ***************************
	staticName = "Static_"..tostring(runwayName).."_3_GAZ-66_"..math.floor(timer.getTime())
	staticObj = {

		["category"] = "Unarmed",
		["type"] = "GAZ-66",
		["rate"] = 2,
		["y"] =  posVehicle[3].y,
		["x"] = posVehicle[3].x,
		["name"] = staticName,
		["heading"] = 4.5378560551853,
		["dead"] = false,
	}
	table.insert(WorksiteVehicles, staticName )
	coalition.addStaticObject(countryId, staticObj)



	-- env.info("bombOnRunway addWorksiteVehicles BB2 ")
	-- _affiche(WorksiteVehicles, "bombOnRunway WorksiteVehicles BB² ")
end

local function CheckAllBase()
	for Id, base in pairs(runwayLife) do 
			local baseLife = base.baseObject:getLife()
			runwayLife[Id].life = baseLife

			if baseLife < 3600 then
				env.info("bombOnRunway runwayLife "..tostring(base.name).." lifeHealth: "..tostring(baseLife))
			end
	end
	return timer.getTime() + 60
end

local function makeRunwayCratere(arg)
	-- env.info("bombOnRunway time "..tostring(timer.getTime()))
	-- _affiche(arg, "function makeRunwayCratere(arg)")

	--enleve préalablement les véhicules de chantier
	 cleanWorksiteVehicles()

	if camp.runwayCratere and type(camp.runwayCratere) == "table" then
		for baseName, base in pairs(camp.runwayCratere) do
			-- env.info("bombOnRunway baseName "..baseName)

			--melange l'ordre des elements de runway pour que ce ne soit pas toujours les memes de cassé
			-- for i = #base.elements, 2, -1 do
			-- 	local j = math.random(i)
			-- 	base.elements[i], base.elements[j] = base.elements[j], base.elements[i]
			-- end


			local sumExplo = 0
			for elementN, element in pairs(base.elements) do 

				-- env.info("bombOnRunway sumExplo"..tostring(sumExplo).." calcul: "..tostring((sumExplo +100)/36).." base.alive: "..base.alive)

				--explo = 100 equivaut = 400life (runwaysLife = 3600)
				-- donc 1 explo = 0.4
				--3600/100 = 36, 3600points de vie vaut 100%
				if (sumExplo +100)/36 < base.alive then

					local runwayCraterVec3 = {
						x = element.x,
						y = land.getHeight({x = element.x, y = element.y}),
						z = element.y,
					}

					
					local sideId = Airbase.getByName(base.db_airbaseName):getCoalition()

					-- 80: CJTF_BLUE
					-- 81: CJTF_RED
					local countryId =country.id.BELGIUM
					if coalitionIdNumeric[sideId] == "blue" then
						countryId = country.id.CJTF_BLUE
					elseif coalitionIdNumeric[sideId] == "red" then
						countryId = country.id.CJTF_RED
					end

					timer.scheduleFunction(addWorksiteVehicles, {runwayCraterVec3, element.name, countryId}, timer.getTime() + 60)

					sumExplo = sumExplo + 100

					trigger.action.explosion(runwayCraterVec3, 100)
					-- env.info("bombOnRunway explosion |x:|"..tostring(runwayCraterVec3.x).."|y:|"..tostring(runwayCraterVec3.y).."|z:|"..tostring(runwayCraterVec3.z))
				else
					-- env.info("bombOnRunway break ")
					break
				end
			end	
		end
	end
	if arg and arg == "repeat" then
		return timer.getTime() + 3500
	else
		return nil
	end
end


timer.scheduleFunction(CheckAllBase, nil, timer.getTime() + 60)

--first Time
-- timer.scheduleFunction(makeRunwayCratere, nil, timer.getTime() + 3610)
-- timer.scheduleFunction(makeRunwayCratere, nil, timer.getTime() + 150)

--next all hour
timer.scheduleFunction(makeRunwayCratere, "repeat", timer.getTime() + 300)


env.info("load bombOnRunway FIN ")