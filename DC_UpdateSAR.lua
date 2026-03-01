-- updates the situation of the rejected pilots
-- fill in the useful tables during the game
------------------------------------------------------------------------------------------------------- 
-- last modification:  debug_h
if not versionDCE then versionDCE = {} end
versionDCE["DC_UpdateSAR.lua"] = "1.4.19"
-------------------------------------------------------------------------------------------------------
-- adjustement_g			(f coldAtStart)(d: enregistre les ref des circles dans la mission)(c inTheEnemyCamp)(b detect not camp_ZoneSAR.blue )(a boundary)
-- cleanCode_a
-- debug_h 					(h base.x)(g aliasYear Unix time 1970)(f loss boundary)(e empty table)(d id duplicates)(c il reste des MIA)(b: camp_ZoneSAR)
-- modification M61_d		SAR	 (d theatre)
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START DC_UpdateSAR.lua "..versionDCE["DC_UpdateSAR.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end



-- camp.SAR = {
-- 	helicopter = {
-- 		[1] = "machprout",
-- 		[2] = "machprout2",
-- 	},
-- 	pilotEjected = {
-- 		[1] = {
-- 			name = "ejected1",
-- 			smokeTiming = 0,
-- 			embarked = false,
-- 			embarkAndSafe = false,
-- 		},
-- 		[2] = {
-- 			name = "ejected2",
-- 			smokeTiming = 0,
-- 			embarked = false,
-- 			embarkAndSafe = false,
-- 		},
-- 	}
-- }

--mise à jour de la structure des ejectedPilot
-- ["pos"] = 
-- {
--     ["y"] = 369606.85478994,
--     ["Vec3x"] = 22004.83531289,
--     ["z"] = 362.05462646484,
--     ["Vec3y"] = 362.05462646484,
--     ["Vec3z"] = 369606.85478994,
--     ["x"] = 22004.83531289,
-- },


if camp_ZoneSAR and camp_ZoneSAR ~= nil then
    for zoneSideName, sideSAR in pairs(camp_ZoneSAR) do
        for zoneName, zone in pairs(sideSAR) do

            for pilotN, pilot in ipairs(zone) do
                if not pilot.pos then
                    pilot = PatchEjectedPilotStructure(pilot, "updateSAR")
                end
                -- pilot = PatchEjectedPilotStructure(pilot, "updateSAR")
            end
        end
    end
end

--temporaire, transforme les variables renommé:
if camp_ZoneSAR and camp_ZoneSAR ~= nil then
    for _, sideSAR in pairs(camp_ZoneSAR) do
        for _, zone in pairs(sideSAR) do

            for _, pilot in ipairs(zone) do

                if pilot.initiatorSIDE then pilot.initiatorSIDE = nil end
                if pilot.side then
                    pilot.sideName = pilot.side
                    pilot.side = nil
                end
                if pilot.Coalition then
                    pilot.coalitionId = pilot.Coalition
                    pilot.Coalition = nil
                end
                if pilot.country then
                    pilot.countryName = pilot.country
                    pilot.country = nil
                end

                if pilot.x then
                    pilot["pos"] = {
                        x = pilot.x,
                        y = pilot.y,
                        z = pilot.z,
                        Vec3x = pilot.x,
                        Vec3y = pilot.z,
                        Vec3z = pilot.y,
                    }
                    pilot.x = nil
                    pilot.y = nil
                    pilot.z = nil

                end

                if pilot.x2d then pilot.x2d = nil end
                if pilot.y2d then pilot.y2d = nil end
                if pilot.z2d then pilot.z2d = nil end
                if pilot.initiatorMissionID then pilot.initiatorMissionID = nil end
                if pilot.initiatorCountry then pilot.initiatorCountry = nil end


            end
        end
    end
end


local function checkPointInPoly2(point, poly)

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

-- calcule la distance minimale entre un point et un segment
local function distancePointToSegment(point, a, b)

    local px = point.x
    local py = point.y

    local ax = a.x
    local ay = a.y
    local bx = b.x
    local by = b.y

    local dx = bx - ax
    local dy = by - ay

    local lengthSquared = dx * dx + dy * dy

    if lengthSquared == 0 then
        -- a et b sont le même point
        local dxp = px - ax
        local dyp = py - ay
        return math.sqrt(dxp * dxp + dyp * dyp)
    end

    -- projection du point sur le segment (paramètre t)
    local t = ((px - ax) * dx + (py - ay) * dy) / lengthSquared

    -- on limite t entre 0 et 1 (segment, pas droite infinie)
    if t < 0 then
        t = 0
    elseif t > 1 then
        t = 1
    end

    -- point projeté sur le segment
    local projx = ax + t * dx
    local projy = ay + t * dy

    local distx = px - projx
    local disty = py - projy

    return math.sqrt(distx * distx + disty * disty)
end

-- retourne la distance minimale entre un point et un polygone
local function distanceToPolygonBoundary(point, poly)

    local minDist = math.huge

    for i = 1, #poly - 1 do
        local dist = distancePointToSegment(point, poly[i], poly[i + 1])
        if dist < minDist then
            minDist = dist
        end
    end

    return minDist
end

local function addSoldierAliasPilot(soldier)
    -- print("DcUS GG passe AddPilotSoldier ")
    -- [element] = {
    --     ['nameId'] = '100085',
    --     ['y'] = 779691.4375,
    --     ['x'] = -157903.609375,
    --     ['name'] = 'Pack 13 - VMA 311 - Strike 1-1',
    --     ['z'] = 806.19799804688,
    --     ['status'] = 'MIA',
    --     ['groupSAR'] = '',
    --     ['MGRS_Chute'] = '38T_MN_3_8',
    --     ['side'] = 'neutrals',
    --      ['country'] = 'USA',
    -- },

    local hidden = true
    -- if camp.debug then
    --     hidden = false
    -- end
    local CircleName =""
    if soldier.circle and soldier.circle.id then
        CircleName =  "circle "..tostring(soldier.circle.id).."_x_"..tostring(soldier.circle.x).."_y_"..tostring(soldier.circle.y)
    end


    local addGroup = {
        ["visible"] = false,
        ["tasks"] =
        {
        }, -- end of ["tasks"]
        ["uncontrollable"] = false,
        ["task"] = "Pas de sol",
        ["taskSelected"] = true,
        ["route"] =
        {
            ["spans"] =
            {
            }, -- end of ["spans"]
            ["points"] =
            {
                [1] =
                {
                    ["alt"] = tonumber(soldier.pos.z),
                    ["type"] = "Turning Point",
                    ["ETA"] = 0,
                    ["name"] = tostring(CircleName),
                    ["alt_type"] = "BARO",
                    ["formation_template"] = "",
                    ["y"] = tonumber(soldier.pos.y),
                    ["x"] = tonumber(soldier.pos.x),
                    ["ETA_locked"] = true,
                    ["speed"] = 0,
                    ["action"] = "Off Road",
                    ["task"] =
                    {
                        ["id"] = "ComboTask",
                        ["params"] =
                        {
                            ["tasks"] =
                            {
                                [1] =
								{
									["enabled"] = true,
									["auto"] = false,
									["id"] = "WrappedAction",
                                    ["name"] = "Tir defensif",
									["number"] = 1,
									["params"] =
									{
										["action"] =
										{
											["id"] = "Option",
											["params"] =
											{
												["name"] = 0,
												["value"] = 4,
											}, -- end of ["params"]
										}, -- end of ["action"]
									}, -- end of ["params"]
								}, -- end of [2]
                                [2] =
                                {
                                    ["number"] = 2,
                                    ["auto"] = false,
                                    ["id"] = "EmbarkToTransport",
                                    ["enabled"] = true,
                                    ["params"] =
                                    {
                                        ["y"] = tonumber(soldier.pos.y),
                                        ["x"] = tonumber(soldier.pos.x),
                                        ["zoneRadius"] = 2000,
                                    }, -- end of ["params"]
                                }, -- end of [2]

                      
                            }, -- end of ["tasks"]
                        }, -- end of ["params"]
                    }, -- end of ["task"]
                    ["speed_locked"] = true,
                }, -- end of [1]
            }, -- end of ["points"]
        }, -- end of ["route"]
        ["groupId"] = GenerateIDGroup(),
        ["hidden"] = hidden,
        ["units"] =
        {
            [1] =
            {
                ["type"] = "Soldier M4",
                ["unitId"] = GenerateIDUnit(soldier.name),
                ["livery_id"] = "winter",
                ["skill"] = "Average",
                ["y"] = tonumber(soldier.pos.y),
                ["x"] = tonumber(soldier.pos.x),
                ["name"] = soldier.name,
                ["heading"] = 0,
                ["playerCanDrive"] = false,
                ["coldAtStart"] = false,
            }, -- end of [1]
        }, -- end of ["units"]
        ["y"] = tonumber(soldier.pos.y),
        ["x"] = tonumber(soldier.pos.x),
        ["name"] = "Group_"..soldier.name,
        ["start_time"] = 0,
    }

    -- if Debug.debug then
    --     -- AddGroup["visible"] = true
    --     print("DcUsar AddSoldierAliasPilot groupId "..tostring(AddGroup.groupId).." NAME: "..tostring(AddGroup.name))
    --     print("DcUsar AddSoldierAliasPilot unitId "..tostring(AddGroup.units[1].unitId).." NAME: "..tostring(AddGroup.units[1].name))
    -- end

    for coal_name, coal in pairs(oob_ground) do
        for country_n, country in ipairs(coal) do
            if string.lower(country.name) == string.lower(soldier.countryName) then
               if country.vehicle then
                    local found = false
                    for group_n, group in ipairs(country.vehicle.group) do
                        if group.units[1].name == soldier.name then
                            found = true
                        end
                    end
                    if not found then
                        table.insert(country.vehicle.group, addGroup)
                     end
                else
                    country.vehicle = {
                            ["group"] = {
                                [1] = addGroup
                            }
                        }
                end
            end
        end
    end
end

local function deleteSoldierAliasPilot(ejectedPilot)
    local found = false
    local foundTarget = false

    for coal_name, coal in pairs(oob_ground) do
        for country_n, country in ipairs(coal) do
            if string.lower(country.name) == string.lower(ejectedPilot.countryName) then
               if country.vehicle then

                    for group_n, group in ipairs(country.vehicle.group) do
                        if group.units[1].name == ejectedPilot.name then
                            table.remove(country.vehicle.group, group_n)
                            found = true
                            break
                        end
                    end
                end
            end
            if found then break end
        end
        if found then break end
    end

    for side, targets in pairs(targetlist) do
        for i = #targets, 1, -1 do
           
            if targets[i].name == ejectedPilot.name then

                table.remove(targets, i)

            end
        end
    end


--[[        
         for side, targets in pairs(targetlist) do     
            if targets[i].elements then
                for elementN, element in ipairs(targets[i].elements) do
                    if element.name == ejectedPilot.name then

                        table.remove(targets[i].elements, elementN)
                        foundTarget = true
                        --supprime la zone SAR s'il n'y a plus d'élément dedans
                        if not targets[i].elements or not next(targets[i].elements) then
                            table.remove(targets, i)
                            
                        end


                        break
                    end
                end
            end 
            if foundTarget then break end
        end
        if foundTarget then break end
    end
]]

    return found, foundTarget
end

local function deleteAliasPilotInOobGround(ejectedPilot)
    local found = false

    for coal_name, coal in pairs(oob_ground) do
        for country_n, country in ipairs(coal) do
            if string.lower(country.name) == string.lower(ejectedPilot.countryName) then
               if country.vehicle then

                    for group_n, group in ipairs(country.vehicle.group) do
                        if group.units[1].name == ejectedPilot.name then
                            table.remove(country.vehicle.group, group_n)
                            found = true
                            break
                        end
                    end
                end
            end
            if found then break end
        end
        if found then break end
    end
    return found
end

-- if not camp_ZoneSAR or camp_ZoneSAR == nil or not camp_ZoneSAR.blue or camp_ZoneSAR.blue == nil  then
if not camp_ZoneSAR or not camp_ZoneSAR.blue then

    camp_ZoneSAR = {
        ["blue"] = {},
        ["red"] = {},
        ["neutrals"] = {},
    }
end

-- if not zoneSAR then
--     print("DcuSAR zoneSAR NIL ")
--     os.execute 'pause'
-- end

--ajoute les ejectedPilot du fichier temp zoneSAR au fichier camp_ZoneSAR
if zoneSAR then
    for sideN, dcs_sideName in pairs(DCS_Side) do
       for zoneName, pilots in pairs(zoneSAR) do
            for pilotN, pilot in pairs(pilots) do
                 if type(pilot) == "table" then
                    pilot = PatchEjectedPilotStructure(pilot, "updateSAR")

                    if pilot.sideName == "" then
                        pilot.sideName = "neutrals"
                    end
                    if pilot.sideName == dcs_sideName then
                        if not camp_ZoneSAR[dcs_sideName][zoneName] then
                            camp_ZoneSAR[dcs_sideName][zoneName] = {
                                [1] = pilot
                            }
                        else
                            local foundElement = false
                            for n=1, #camp_ZoneSAR[dcs_sideName][zoneName] do
                                if pilot.name == camp_ZoneSAR[dcs_sideName][zoneName][n].name then
                                   foundElement = true
                                    break
                                end
                            end
                            if not foundElement then
                                table.insert(camp_ZoneSAR[dcs_sideName][zoneName], pilot )
                           end
                        end
                    end
                end
            end
        end
    end
end

--TODO quel est l'interet de cette partie? afficher seulement si un joueur est secouru?
if zoneSAR and zoneSAR ~= nil then
    for Nside, dcs_sideName in pairs(DCS_Side)	 do
        for zoneName, pilot in pairs(zoneSAR) do
            for i = 1, #pilot do
               if pilot[i].sideName == "" then
                    pilot[i].sideName = "neutrals"
                end
                if pilot[i].sideName == dcs_sideName then
                    if not camp_ZoneSAR[dcs_sideName][zoneName] then
                        camp_ZoneSAR[dcs_sideName][zoneName] = {
                            [1] = pilot[i]
                        }
                    else
                         for n=1, #camp_ZoneSAR[dcs_sideName][zoneName] do
                            if pilot[i].name == camp_ZoneSAR[dcs_sideName][zoneName][n].name then
                                 if pilot[i].embarked == true  and  camp_ZoneSAR[dcs_sideName][zoneName][n].status ~= "rescued" then
                                     camp_ZoneSAR[dcs_sideName][zoneName][n].status = "rescued"

                                    if pilot[i].initiatorPilotName then
                                        print("DcUS rescued "..tostring(zoneName).." "..tostring(pilot[i].initiatorPilotName))
                                    else
                                        print("DcUS rescued "..tostring(zoneName).." "..tostring(pilot[i].name))
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

local boundaryTemp = {
        red = {},
        blue = {},
        neutral = {},
    }
local boundary = boundaryTemp

if camp.boundary then
    boundary = camp.boundary
end



-- camp_ZoneSAR = {
-- 	['neutrals'] = {
-- 	},
-- 	['blue'] = {
-- 		['SAR_37T_FH_8_6'] = {
-- 			[1] = {
-- 				['PilotName'] = 'Miguel21',
-- 				['initiatorSIDE'] = 'blue',
-- 				['SurfaceType'] = 1,
-- 				['status'] = 'MIA',
-- 				['MGRS_Chute'] = '37T_FH_8_6',
-- 				['initiatorMissionID'] = '100043',
-- 				['nameId'] = '100043',
-- 				['initiatorCountry'] = 'USA',
-- 				['initiator'] = 'Pack 6 - VF-143 - Escort 1-1',
-- 				['y'] = 571795.125,
-- 				['x'] = -204344.34375,
-- 				['CloseRoad'] = {
-- 					['y'] = 570390.09920973,
-- 					['x'] = -203542.94492411,
-- 				},
-- 				['z'] = 615.92309570313,
-- 				['side'] = 'blue',
-- 				['name'] = '1_1_160.08_Pilot_Pack 6 - VF-143 - Escort 1-1',
-- 				['groupSAR'] = '',
-- 				['country'] = 'USA',
-- 			},
-- 			[2] = {
-- 				['PilotName'] = 'Miguel21',
-- 				['initiatorSIDE'] = 'blue',
-- 				['SurfaceType'] = 1,
-- 				['status'] = 'MIA',
-- 				['MGRS_Chute'] = '37T_FH_8_6',
-- 				['initiatorMissionID'] = '100043',
-- 				['nameId'] = '100043',
-- 				['initiatorCountry'] = 'USA',
-- 				['initiator'] = 'Pack 6 - VF-143 - Escort 1-1',
-- 				['y'] = 571799.1875,
-- 				['x'] = -204350.09375,
-- 				['CloseRoad'] = {
-- 					['y'] = 570390.24834848,
-- 					['x'] = -203542.64119108,
-- 				},
-- 				['z'] = 616.72100830078,
-- 				['side'] = 'blue',
-- 				['name'] = '1_1_160.1_Pilot_Pack 6 - VF-143 - Escort 1-1',
-- 				['groupSAR'] = '',
-- 				['country'] = 'USA',
-- 			},
-- 		},
-- 	},
-- 	['red'] = {
-- 	},
-- }

--selectionne la base la plus proche pour leur porter secours
--defini si le pilot est capturé ou récupérable

-- local timeActualCampaignSecond = SecondsBetween(camp.dateInit, camp.date)

if camp_ZoneSAR and camp_ZoneSAR ~= nil then
    for zoneSideName, sideSAR in pairs(camp_ZoneSAR) do
        for zoneName, zone in pairs(sideSAR) do

            for pilotN, pilot in ipairs(zone) do

                --met à jour la nouvelle structure des ejectedPilot
                pilot = PatchEjectedPilotStructure(pilot, "updateSAR")
                local mia_Since

                if pilot.date then

                    mia_Since = SecondsBetween( camp.date, pilot.date) / (24 * 60 * 60)
                end

                if pilot.status ~= "rescued" and pilot.embarked then
                    pilot.status = "rescued"
                end
                
                local lowerName = string.lower(pilot.name)
                if string.find(lowerName, "pedro") and string.find(lowerName, "damaged") then
                    -- print("DcUS SAR pilot with damaged  "..tostring(pilot.name).." set to error")
                    pilot.status = "error"
                end

                for baseName, base in pairs(db_airbases) do
                    if base.side == pilot.sideName and base.x then
                        -- _affiche(base, "DcUS base ")
                        -- _affiche(pilot.pos, "pilot.pos ")

                        local distance = math.sqrt(math.pow(pilot.pos.x - base.x, 2) + math.pow(pilot.pos.y - base.y, 2))
                        if distance < 5000 then
                            -- print("DcUS SAR pilot on BASE  "..tostring(pilot.name).." set to error")
                            pilot.status = "error"
                        end

                    end
                end

                --*************************************************************
                if camp.code_loadout == "NAM" then

                    if pilot.sideName == "red" then
                    
                        local enemy = DCS_ENI_Side[zoneSideName]
                        pilot.inTheEnemyCamp = checkPointInPoly2({x=pilot.pos.x,y=pilot.pos.y}, boundary[enemy])

                        if not pilot.inTheEnemyCamp and pilot.date.year and pilot.date.month and pilot.date.day then
                            if mia_Since > 2 then
                                pilot.status = "rescued"
                            end
                        end

                    elseif pilot.sideName == "blue" then
                        --check si trop proche des grandes villes comme Hanoi
                        --["x"] = 132610,
                        --["y"] = 408650,

                        local town = {
                            ["Hanoi"] = {
                                x= 132610,
                                y = 408650,
                                distInfluence = 30000,
                            },
                            ["Haiphong"] = {
                                ["y"] = 452244,
                                ["x"] = 70023,
                                distInfluence = 20000,
                            },
                            ["Vihn"] = {
                                ["y"] = 344113.5,
                                ["x"] = -84651.667969,
                                distInfluence = 10000,
                            },
                        }

                      
                        --parse les villes pour déclarer les pilotes ejecté: capturés s'ils sont dans le cercle d'influence 
                        for townName, townData in pairs(town) do
                            local distance = math.sqrt(math.pow(pilot.pos.x - townData.x, 2) + math.pow(pilot.pos.y - townData.y, 2))
                            if distance < townData.distInfluence then
                                -- print("DcUS SAR pilot too close from "..tostring(townName).." "..tostring(pilot.name).." set to POW")
                                pilot.status = "POW"
                                pilot.reason = "too close from "..townName
                            end
                        end

                    end

                end

                -- print("DcUS update Status A "..tostring(pilot.name).." pilot.sideName "..tostring(pilot.sideName).." zoneSideName: "..zoneSideName)

                if (pilot.status == "MIA" or pilot.status == "EVAC_possible" ) and pilot.sideName == zoneSideName and zoneSideName ~= "neutrals" then
                    -- print("DcUS update Status B ")
					local redDistance ={500, 3000, 20000, 200000}
                    -- local nbAMI_ENI = {
                    --     neutrals = {},
                    --     red = {},
                    --     blue = {},
                    -- }

                    local nbAMI_ENI = {
                        neutrals = {
                        },
                        red = {
                            [500] = 0,
                            [1500] = 0,
                            [20000] = 0,
                            [200000] = 0
                        },
                        blue = {
                            [500] = 0,
                            [1500] = 0,
                            [20000] = 0,
                            [200000] = 0
                        },
                    }

                    --defini si le pilot est capturé ou récupérable
                     --recherche le nombre d'AMI ENI proche
                    for distanceN, refD in ipairs(redDistance) do
                        for sideName, oob in pairs(oob_ground) do
                            for country_n, country in pairs(oob_ground[sideName]) do
                                if country.static then
                                    for group_n, group in pairs(country.static.group) do

                                        local distance = math.sqrt(math.pow(pilot.pos.x - group.x, 2) + math.pow(pilot.pos.y - group.y, 2))
                                        if not nbAMI_ENI[sideName][refD] then
                                            nbAMI_ENI[sideName][refD] = 0
                                        end
                                        if distance <= refD then
                                            nbAMI_ENI[sideName][refD] = nbAMI_ENI[sideName][refD] + #group.units
                                        end
                                    end
                                end
                                if country.vehicle then
                                    for group_n, group in pairs(country.vehicle.group) do
                                        if not string.find(group.name, "_Pilot_") then
                                            local distance = math.sqrt(math.pow(pilot.pos.x - group.x, 2) + math.pow(pilot.pos.y - group.y, 2))

                                            if not nbAMI_ENI[sideName][refD] then
                                                nbAMI_ENI[sideName][refD] = 0
                                            end
                                            if distance <= refD then
                                                nbAMI_ENI[sideName][refD] = nbAMI_ENI[sideName][refD] + #group.units
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    -- nbAMI_ENI = {
                    --     neutrals = {
                    --     },
                    --     red = {
                    --         500 = 0,
                    --         3000 = 0,
                    --         20000 = 0,
                    --         200000 = 129
                    --     },
                    --     blue = {
                    --         500 = 0,
                    --         3000 = 0,
                    --         20000 = 0,
                    --         200000 = 19
                    --     },
                    -- }

                    local enemy																													--determine enemy side (opposite of unit side)
                    if zoneSideName == "blue" then
                        enemy = "red"
                    else
                        enemy = "blue"
                    end

                    --ajoute et met à jour le nb de jour depuis son ejection
                    if not pilot.dataPOW.ejectNbDay then
                        pilot.dataPOW.ejectNbDay = mia_Since
                    else
                
                        -- mia_Since = SecondsBetween( camp.date, pilot.date) / (24 * 60 * 60)
                        pilot.dataPOW.ejectNbDay = tonumber(mia_Since)

                    end

                    if not pilot.dataPOW.POW_nextDayCheck then
                        pilot.dataPOW.POW_nextDayCheck =  pilot.dataPOW.ejectNbDay + 2
                    end

                    --cherche s'il est ejecté chez l'ENI
                    if not pilot.dataPOW.initChoicePOW or pilot.dataPOW.initChoicePOW == nil then
                        pilot.inTheEnemyCamp = checkPointInPoly2({x=pilot.pos.x,y=pilot.pos.y}, boundary[enemy])
                        pilot.dataPOW.initChoicePOW = true
                        pilot.dataPOW.PowDayMax = math.random(3, 15)

                     elseif pilot.dataPOW.initChoicePOW and pilot.inTheEnemyCamp then

                        if pilot.dataPOW.PowDayMax and pilot.date.year and pilot.date.month and pilot.date.day then
                            if mia_Since > pilot.dataPOW.PowDayMax then
                                pilot.status = "POW"
                                pilot.reason = "set to POW after max days "..tostring(pilot.dataPOW.PowDayMax)
                                -- print("DcUS update Status A10 "..tostring(pilot.name).." set to POW after max days "..tostring(pilot.dataPOW.PowDayMax))
                            end
                        end
                    end

                     pilot.distanceFromFrontline = 0 

                    if pilot.inTheEnemyCamp then
                      pilot.distanceFromFrontline = distanceToPolygonBoundary(pilot.pos, boundary[enemy])
                    end

                    --  print("DcUS update Status B2 "..tostring(pilot.inTheEnemyCamp).." pilot.dataPOW.ejectNbDay "..tostring(pilot.dataPOW.ejectNbDay).." pilot.dataPOW.POW_nextDayCheck "..tostring(pilot.dataPOW.POW_nextDayCheck) )

                    --////////////////////////////************************////////////////////
                    if pilot.status ~= "POW" and pilot.inTheEnemyCamp and (pilot.dataPOW.ejectNbDay < pilot.dataPOW.POW_nextDayCheck) then

                        --indique de ne pas regarder à chaque generation le random POW, cela fausse les stats
                        --ne regarde qu'une fois par jour, ou tous les 2 jours ou...
                        pilot.dataPOW.POW_nextDayCheck = pilot.dataPOW.ejectNbDay + 2

                        if nbAMI_ENI[zoneSideName][500] >= 2  then
							pilot.status = "EVAC_possible"
						elseif  nbAMI_ENI[zoneSideName][500] == 0 and  nbAMI_ENI[enemy][500] >= 2  then
							pilot.status = "POW"
                            pilot.reason = "set to POW 500m ENI "
                            -- print("DcUS update Status D "..tostring(pilot.name).." set to POW 500m ENI")
						elseif nbAMI_ENI[zoneSideName][1500] >= 2  and nbAMI_ENI[enemy][1500] < 2 then
							pilot.status = "EVAC_possible"
						elseif nbAMI_ENI[zoneSideName][1500] < 2  and nbAMI_ENI[enemy][1500] >= 2 then
							pilot.status = "POW"
                            pilot.reason = "set to POW 3000m ENI "
                            -- print("DcUS update Status E "..tostring(pilot.name).." set to POW 3000m ENI")
						elseif nbAMI_ENI[zoneSideName][1500] >= 2  and nbAMI_ENI[enemy][1500] >= 2  then
							local pourcent = (nbAMI_ENI[zoneSideName][1500] / ( nbAMI_ENI[zoneSideName][1500] + nbAMI_ENI[enemy][1500]))*100
							local coef = (pilot.dataPOW.ejectNbDay*(-1) + 5) -- plus le nb de jour augmente, plus les chances d etre capturé augmente
                            if coef < 1 then coef = 1 end
                            local randomMalChance = math.random(1, 100) / coef

							if randomMalChance > pourcent then
								pilot.status = "POW"
                                pilot.reason = "set to POW 3000m both sides, randomMalChance > pourcent "..randomMalChance.." > ".. pourcent
                                -- print("DcUS update Status F "..tostring(pilot.name).." set to POW 3000m both sides")
							else
								pilot.status = "EVAC_possible"
                            end
						elseif nbAMI_ENI[zoneSideName][20000] >= 2 and nbAMI_ENI[enemy][20000] < 2 then
							pilot.status = "EVAC_possible"
						elseif nbAMI_ENI[zoneSideName][20000] < 2 and nbAMI_ENI[enemy][20000] >= 2 then

                            pilot.status = "EVAC_possible"

						elseif nbAMI_ENI[zoneSideName][20000] >= 2 and nbAMI_ENI[enemy][20000] >= 2  then

							local pourcent = (nbAMI_ENI[zoneSideName][20000] / ( nbAMI_ENI[zoneSideName][20000] + nbAMI_ENI[enemy][20000]))*100
                            local coef = (pilot.dataPOW.ejectNbDay*(-1) + 5) -- plus le nb de jour augmente, plus les chances d etre capturé augmente
                            if coef < 1 then coef = 1 end
                            local randomMalChance = math.random(1, 100)/coef
                           
							if randomMalChance > pourcent then
                                pilot.status = "POW"
                                pilot.reason = "set to POW 20000m both sides, randomMalChance > pourcent "..randomMalChance.." > ".. pourcent
                                -- print("DcUS update Status G "..tostring(pilot.name).." set to POW 20000m both sides")
							else
								pilot.status = "EVAC_possible"
                            end

						elseif nbAMI_ENI[zoneSideName][200000] >= 2 and nbAMI_ENI[enemy][200000] < 2 then
							pilot.status = "EVAC_possible"
						elseif nbAMI_ENI[zoneSideName][200000] < 2 and nbAMI_ENI[enemy][200000] >= 2 then
							pilot.status = "EVAC_possible"
						elseif nbAMI_ENI[zoneSideName][200000] >= 2 and nbAMI_ENI[enemy][200000] >= 2  then
							pilot.status = "EVAC_possible"
                        else
                            pilot.status = "EVAC_possible"
						end

                    elseif pilot.status == "POW" then
                        -- print("DcUS update Status H "..tostring(pilot.name).." remains POW")


                    elseif not pilot.inTheEnemyCamp then

                        pilot.status = "EVAC_possible"

					end

                    --////////////////////////////************************////////////////////

                   if camp.theatre and camp.theatre == "caucasus" then
                        dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data_circleSAR_Caucasus.lua")

                        pilot.theatreCercle = true

                        --===========PRINCIPE de CALCUL========================
                        -- a/ trouver la correlation, un pixel équivaut à combien de metre, chaque map screené est différente
                        -- b/ trouver le décallage entre l'origine screenMap (0/0 en haut à droite) et l'origine MAP DCS


                        -- ////Width: 18869 Height: 10391
                        -- // axe_X : 18869 pixel (gauche à droite)
                        -- // axe_Y : 10391 pixel (haut en bas)
                        -- // 0/0 point origine en haut à droite

                        -- //TODO trouver 2 bases eloigné, dessiner 2 cerles dessus et trouver la distance équivalente sur DCS
                        -- //426 nm => 788952 metre
                        -- // 1 pixel = 41.81 metre


                        --offset --caucasus
                        --TODO a faire pour les autres map


                        -- ['Vizianii'] = {

                        --     y = 904028.820,
                        --     x =	-319918.785,

                        --Pixel:
                        -- local offsett_pix_x = 17640
                        -- local offsett_pix_y = 8013

                            -- a => b
                            -- c => d
                            --
                            --  904028.820  =>  17640
                            --  319918.785  =>  8013

                            -- ad = bc
                            -- a = bc/d

                            -- mis_y => pix_x
                            -- 904028.820 => 17640           
                            --           
                            -- mis_y = (904028.820*pix_x) / 17640
                            -- mis_y = (ref_DCS_metre_abscissse*pix_x) / ref_pixel_abscissse


                            --pour les Ordonnées:
                            -- -220531 => 5900
                            -- mis_x => pix_y
                            -- mis_x = (-220531*pix_y) / 5900
                            -- mis_x = (-220531*pix_y) / ref_pixel_ordonne


                        -- ['Viazami'] = {

                            -- ["y"] = 904028.82022995,
                            -- ["x"] = -319918.78524314,
                        --Pixel:
                        local ref_DCS_metre_abscissse = 904028.820     --  vaziami
                        local ref_DCS_metre_ordonne = -319918.785      --  vaziami

                        local ref_pixel_abscissse = 17640        --  vaziami    
                        local ref_pixel_ordonne = 8013        --  vaziami

                        local inSarZone = false

                        --https://www.dcode.fr/recherche-equation-fonction
                        --exemple avec abcisse entre vaziami et anapa
                        --          abscissse       ordonne
                        --  1       17640           904028.820
                        --  2       3626            242165.401
                        --  47.2287x+70914
                        -- a faire pour l'ordonne


                        -- circleSAR = {    --  vaziami
                        --     {   
                        --         pixel_x = 17640,   
                        --         pixel_y = 8013,  
                        --         radius = 20,  
                        --         ordonne_m =	-319918.785,        x
                        --         abcisse_m = 904028.820,      y
                        --     }, 
                        -- }


                        -- circleSAR = {       --  anapa
                        --     {   
                        --         pixel_x = 3626,   
                        --         pixel_y = 1376,  
                        --         radius = 20, 
                        --         ordonne_m =	-6450.3910292297,        x
                        --         abcisse_m = 242165.40114826,      y 
                        --     }, 
                        -- }  

                        --     circleSAR = {    --  batumi
                        --     {   
                        --         pixel_x = 11587,   
                        --         pixel_y = 8784,  
                        --         radius = 20,  
                        --     }, 
                        -- }

                        for nCircle, circle in ipairs(circleSAR) do

                            --Pixel axe x : horizontal vers la droite
                            --Pixel axe y : horizontal vers le bas
                            --x=0 et y=0, les origines en haut à gauche

                            --mission axe x: vertical vers le haut      (ordonne)
                            --mission axe y: horizontal vers la droite  (abscissse)

                            -- local mission_x = (ref_DCS_metre_ordonne * circle.pixel_y) / ref_pixel_ordonne     --pas assez precis
                            local mission_x = 58538.7 - (47.2304 * circle.pixel_y )
                                                --  58538.7−47.2304x


                            -- local mission_y = (ref_DCS_metre_abscissse * circle.pixel_x) / ref_pixel_abscissse    --pas assez precis                 
                            -- local mission_y = (564387 * circle.pos.x) / offsett_pix_x
                            local mission_y = (47.2287 * circle.pixel_x) + 70914
                                                -- 47.2287x+70914

                            local testX = math.abs(pilot.pos.x - mission_x)
                            local testY =  math.abs(pilot.pos.y - mission_y)
                            -- print("DcUSAR passe A element x: "..tostring(element.pos.x).." Y: "..tostring(element.pos.y).." ||mission X: "..tostring(mission_x).." Y: "..tostring(mission_y).." ||Delat "..tostring(testX).." Y: "..tostring(testY))

                            if math.abs(pilot.pos.x - mission_x) <= 2000 and math.abs(pilot.pos.y - mission_y) <= 2000 then
                                -- print("DcUSAR passe B x: "..tostring(mission_x).." Y: "..tostring(mission_y))

                                local result = math.pow ((pilot.pos.x - mission_x), 2) + math.pow((pilot.pos.y - mission_y), 2) <= math.pow((circle.radius * 47.2287), 2)
                                if result then

                                    --le soldierEjectedPilot est déjà dans une zone SAR possible
                                    -- on arrete donc de chercher
                                    pilot.landingPossible = true
                                    inSarZone = true
                                    pilot["circle"] = {
                                        id = nCircle,
                                        x = circle.pixel_x,
                                        y = circle.pixel_y,
                                    }
                                    break

                                end
                            end
                        end

                        -- int testX = 10191;
                        -- int testY = 5020;
                        local initElementX2D =  pilot.pos.x
                        local initElementY2D =  pilot.pos.y

                        local distanceSAR = 9999999
                        local distanceSelected = 9999999
                        local selectedCircle = {}
                        local xy_Selected = {
                            x = 0,
                            y = 0,
                        }
                        if not inSarZone then
                            for nCircle, circle in ipairs(circleSAR) do

                                -- local newZone_metre_x = (ref_DCS_metre_ordonne * circle.pixel_y) / ref_pixel_ordonne         --pas assez precis
                                local newZone_metre_x = 58538.7 - (47.2304 * circle.pixel_y )


                                -- local newZone_metre_y = (ref_DCS_metre_abscissse * circle.pixel_x) / ref_pixel_abscissse      --pas assez precis
                                local newZone_metre_y = (47.2287 * circle.pixel_x) + 70914

                                -- if math.abs(element.pos.x - newZone_metre_x) <= 2000 and math.abs(element.pos.y - newZone_metre_y) <= 2000 then 

                                if math.abs(pilot.pos.x - newZone_metre_x) <= 20000 and math.abs(pilot.pos.y - newZone_metre_y) <= 20000 then

                                    --distance de la nouvelle zone degagé depuis la zone de chute
                                    local distChuteNewZone = math.sqrt(math.pow(pilot.pos.x - newZone_metre_x, 2) + math.pow(pilot.pos.y - newZone_metre_y, 2))

                                                -- local result = Math.Pow((element.pos.x - circle.pos.x), 2) + Math.Pow((element.pos.y - circle.pos.y), 2) <= Math.Pow((circle.radius * 47.2287), 2)
                                                -- local distance = math.sqrt(math.pow(element.pos.x - newZone_metre_x, 2) + math.pow(element.pos.y - newZone_metre_y, 2))

                                    if distChuteNewZone < distanceSelected then

                                        --ne se déplace pas en territoire ENI
                                        local testEnyCamp =  checkPointInPoly2({x=newZone_metre_x,y=newZone_metre_y}, boundary[enemy])

                                        if pilot.inTheEnemyCamp or (not pilot.inTheEnemyCamp and not testEnyCamp) then
                                            distanceSelected = distChuteNewZone

                                            --pour info, ce n'est pas la position xy mais une reference circle
                                            xy_Selected.x = circle.pixel_x
                                            xy_Selected.y = circle.pixel_y

                                            pilot.pos.x = newZone_metre_x + (pilotN * 100)
                                            pilot.pos.y = newZone_metre_y + (pilotN * 100)
                                            pilot["circle"] = {
                                                id = nCircle,
                                                x = circle.pixel_x,
                                                y = circle.pixel_y,
                                            }
                                        end
                                    end
                                end
                            end
                        end

                        if distanceSelected < 9999999 then
                            pilot.landingPossible = true
                            pilot.inTheEnemyCamp =  checkPointInPoly2({x=pilot.pos.x,y=pilot.pos.y}, boundary[enemy])
                        end
                    else
                        pilot.landingPossible = false
                        pilot.theatreCercle = false
                    end

                    --  print("DcUS update Status Z ")
                end


                --selectionne la base la plus proche pour leur porter secours
                local selectedDistance = 9999999
                local selectedUnitName = ""
                for oob_sidename, sideTab in pairs(oob_air) do
                    if oob_sidename == pilot.sideName then
                        for n, unit in pairs(sideTab) do
                            if (unit.tasks.SAR or unit.tasks.CSAR) and not unit.inactive then
                                local unitReserve = 0
                                if unit.roster and unit.roster.reserve then
                                    unitReserve = unit.roster.reserve
                                end
                                local nbRoster = unit.roster.ready + unit.roster.damaged + unitReserve
                                if nbRoster >= 1 then
                                    if not db_airbases[unit.base] or db_airbases[unit.base] == nil then
                                        print("ATTENTION this base does not exist in the database: "..unit.base.." this unit does not have the right base.: "..unit.name)
                                        print("ATTENTION ") os.execute 'pause'
                                    end

                                    if unit.base and db_airbases[unit.base] and db_airbases[unit.base].x and not db_airbases[unit.base].humainOnly then
                                        local distance = math.sqrt(math.pow(pilot.pos.x -  db_airbases[unit.base].x, 2) + math.pow(pilot.pos.y -  db_airbases[unit.base].y, 2))
                                        if distance <= selectedDistance then
                                            selectedDistance = distance
                                            selectedUnitName = unit.name

                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                -- if selectedUnitName ~= "" then
                    pilot.selectedUnitSAR = selectedUnitName
                -- end

            end
        end
    end
end

-- Supprime de oob_ground ET de camp_ZoneSAR les ejectedPilot capturés ou sauvés
if camp_ZoneSAR then
    for zone_sideName, sideTab in pairs(camp_ZoneSAR) do
        for zoneName, zone in pairs(sideTab) do
            -- Parcours à l'envers pour supprimer sans bug d'index
            for pilotN = #zone, 1, -1 do
                local pilot = zone[pilotN]
                if pilot.status == "rescued" or pilot.status == "POW" or pilot.status == "error" or pilot.status == "dead" then
                    local result, resultTarget = deleteSoldierAliasPilot(pilot)
                    -- if not result and not resultTarget and Debug.debug then
                    --     print("DcUS GG (rescued or POW) Unable to delete this pilot "..pilot.status.." // "..tostring(pilot.name))
                    -- end

                    if Debug.debug then
                        print("DcUS remove ejectedPilot from UpdateSAR "..pilot.name.." status: "..tostring(pilot.status).." Reason?: "..tostring(pilot.reason))
                    end

                    -- Suppression du pilote dans camp_ZoneSAR
                    table.remove(zone, pilotN)

                    
                    -- Supprimer la zone si elle est vide
                    if not next(zone) then
                        if Debug.debug then
                            print("DcUS GH Supprimer la zone si elle est vide zoneName "..tostring(zoneName))
                        end
                       
                        sideTab[zoneName] = nil

                    end

                end
            end
        end
    end
end


--mis à jour des status des pilotes ejecté en fonction de leur récuperation
-- SAR = {
-- 	helicopter = {
-- 		[1] = "machprout",
-- 		[2] = "machprout2",
-- 	},
-- 	pilotEjected = {
-- 		[1] = {
-- 			name = "ejected1",
-- 			smokeTiming = 0,
-- 			embarked = false,
-- 			embarkAndSafe = false,
-- 		},
-- 		[2] = {
-- 			name = "ejected2",
-- 			smokeTiming = 0,
-- 			embarked = false,
-- 			embarkAndSafe = false,
-- 		},
-- 	}
-- }
--mis à jour des status des pilotes ejecté en fonction de leur récuperation
-- if camp.SAR and camp.SAR.pilotEjected then
--     for N_Pilot, uPilot in ipairs(camp.SAR.pilotEjected) do

--         if uPilot.embarked then 

--             if camp_ZoneSAR and camp_ZoneSAR ~= nil then
--                 for sideName, sideSAR in pairs(camp_ZoneSAR) do
--                     for ZoneName, zone in pairs(sideSAR) do
--                         for Nelement, element in ipairs(zone) do
--                             -- if element.name == uPilot.name and element.status == "MIA" then
--                             if element.name == uPilot.name and element.status == "EVAC_possible" then


--                                 if uPilot.embarkAndSafe then 
--                                     element.status = "OK"
--                                 else
--                                     element.status = "KIA"
--                                 end
--                             end
--                         end
--                     end
--                 end
--             end
--         end
--     end
-- end

camp.SAR = {}
camp.SAR.pilotEjected = {}

-- if not camp.SAR then camp.SAR = {} end
-- camp.SAR.pilotEjected = {}

--creation table de la liste des pilote ejecté à utiliser dans le game DC_StaticAircraft
--UTIL pour calculer en temps réel la distance séparant ces pilotes des helico pour déclencher le fumigene
if camp_ZoneSAR and camp_ZoneSAR ~= nil then   -- and camp_ZoneSAR.blue ????
    for zone_sideName, sideTab in pairs(camp_ZoneSAR) do
        for zoneName, zone in pairs(sideTab) do
            for pilotN, pilot in ipairs(zone) do

				-- land.pos.surfaceType 
				-- LAND             1
				-- SHALLOW_WATER    2
				-- WATER            3 
				-- ROAD             4
				-- RUNWAY           5

                -- supprime d'abord le soldat existant, pour actualiser sa position et son status
                local result = deleteAliasPilotInOobGround(pilot)
                    if not result then
                        -- print("DcUS GG (maj) aliasPilot cannot be found and deleted in oob_ground "..tostring(pilot.name))
                    else
                    --    print("DcUS GG Deleted pilot: "..tostring(result))
                    end

                -- print("DcUS G1 (maj) pilot.status "..pilot.status.." // "..tostring(pilot.name))

                if pilot.status == "EVAC_possible" and pilot.pos.surfaceType ~= 5  then

                    local addPilot = pilot
                    -- addPilot.smokeTiming = 0
                    addPilot.embarked = false
                    addPilot.embarkAndSafe = false
                    addPilot.landingPossible = pilot.landingPossible
                    addPilot.inTheEnemyCamp = pilot.inTheEnemyCamp
                    addPilot.radio_on  = false
                    addPilot.radio_start = 0
                    pilot.MGRS_Chute_10KM = pilot.MGRS_Chute_10KM or nil

                    table.insert(camp.SAR.pilotEjected, addPilot)

                    --ne spawn pas dans l'eau (pas encore)
                    if pilot.pos.surfaceType ~= 3 then
                        addSoldierAliasPilot(pilot)
                    end
                end
           end
        end
    end
end


camp.SAR.alertSAR = {
		["blue"] = {
			base = {},
			assigned = {},
		},
		["red"] = {
			base = {},
			assigned = {},
		},
	}
camp.SAR.Flag = 600

-- if camp_ZoneSAR then
-- 	local ZoneSAR_str = "camp_ZoneSAR = " .. TableSerialization(camp_ZoneSAR, 0)					--make a string
-- 	local ZoneSARFile = io.open("Debug/camp_ZoneSAR_B.lua", "w")										--open ZoneSAR file
-- 	ZoneSARFile:write(ZoneSAR_str)																	--save new data
-- 	ZoneSARFile:close()
-- end


if Debug.debug then
	local camp_str = "camp_ZoneSAR = " .. TableSerialization(camp_ZoneSAR, 0)
	local campFile = io.open("Debug/camp_ZoneSAR_UpdateSAR.lua", "w") or error("Échec d'ouverture du fichier camp_ZoneSAR")
	campFile:write(camp_str)
	campFile:close()
end



