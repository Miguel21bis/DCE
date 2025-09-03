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

local debugNoPow = false 		-- false : fonctionnement normal (true: evite les POW lors des randoms)
local debugDcUS = false

if debugNoPow then
	print("==============********ATTENTION********==========")
	print("pas de Random-POW possible, la variable debugNoPow = true est activé dans DC_UpdateSAR")
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

function CheckPointInPoly2(point, poly)

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

function AddSoldierAliasPilot(element)
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
    if element.circle and element.circle.id then
        CircleName =  "circle "..tostring(element.circle.id).."_x_"..tostring(element.circle.x).."_y_"..tostring(element.circle.y)
    end


    local AddGroup = {
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
                    ["alt"] = tonumber(element.z2d),
                    ["type"] = "Turning Point",
                    ["ETA"] = 0,
                    ["name"] = tostring(CircleName),
                    ["alt_type"] = "BARO",
                    ["formation_template"] = "",
                    ["y"] = tonumber(element.y2d),
                    ["x"] = tonumber(element.x2d),
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
                                        ["y"] = tonumber(element.y2d),
                                        ["x"] = tonumber(element.x2d),
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
                ["unitId"] = GenerateIDUnit(element.name),
                ["livery_id"] = "winter",
                ["skill"] = "Average",
                ["y"] = tonumber(element.y2d),
                ["x"] = tonumber(element.x2d),
                ["name"] = element.name,
                ["heading"] = 0,
                ["playerCanDrive"] = false,
                ["coldAtStart"] = false,
            }, -- end of [1]
        }, -- end of ["units"]
        ["y"] = tonumber(element.y2d),
        ["x"] = tonumber(element.x2d),
        ["name"] = "Group_"..element.name,
        ["start_time"] = 0,
    }

    -- if Debug.debug then
    --     -- AddGroup["visible"] = true
    --     print("DcUsar AddSoldierAliasPilot groupId "..tostring(AddGroup.groupId).." NAME: "..tostring(AddGroup.name))
    --     print("DcUsar AddSoldierAliasPilot unitId "..tostring(AddGroup.units[1].unitId).." NAME: "..tostring(AddGroup.units[1].name))
    -- end

    for coal_name, coal in pairs(oob_ground) do
        for country_n, country in ipairs(coal) do
            if string.lower(country.name) == string.lower(element.country) then
               if country.vehicle then
                    local found = false
                    for group_n, group in ipairs(country.vehicle.group) do
                        if group.units[1].name == element.name then
                            found = true
                        end
                    end
                    if not found then
                        table.insert(country.vehicle.group, AddGroup)
                     end
                else
                    country.vehicle = {
                            ["group"] = {
                                [1] = AddGroup
                            }
                        }
                end
            end
        end
    end
end

function DeleteSoldierAliasPilot(element)
    local found = false
    for coal_name, coal in pairs(oob_ground) do
        for country_n, country in ipairs(coal) do
            if string.lower(country.name) == string.lower(element.country) then
               if country.vehicle then
                    local found = false
                    for group_n, group in ipairs(country.vehicle.group) do
                        if group.units[1].name == element.name then
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
    return
end

if not camp_ZoneSAR or camp_ZoneSAR == nil or not camp_ZoneSAR.blue or camp_ZoneSAR.blue == nil  then

    camp_ZoneSAR = {
        ["blue"] = {},
        ["red"] = {},
        ["neutrals"] = {},
    }
end

--ajoute les ejectedPilot du fichier temp zoneSAR au fichier camp_ZoneSAR
if zoneSAR and zoneSAR ~= nil then
    for Nside, sideName in pairs(DCS_Side)	 do
        for zoneName, element in pairs(zoneSAR) do
            for i = 1, #element do
                if  element[i].side == "" then
                    element[i].side = "neutrals"
                end
                if element[i].side == sideName then
                     if not camp_ZoneSAR[sideName][zoneName] then
                        camp_ZoneSAR[sideName][zoneName] = {
                            [1] = element[i]
                        }
                    else
                        local foundElement = false
                        for n=1, #camp_ZoneSAR[sideName][zoneName] do
                             if element[i].name == camp_ZoneSAR[sideName][zoneName][n].name then

                                foundElement = true
                                break
                            end
                        end
                        if not foundElement then
                            table.insert(camp_ZoneSAR[sideName][zoneName], element[i] )
                        end
                    end
                end
            end
        end
    end
end


if zoneSAR and zoneSAR ~= nil then
    for Nside, sideName in pairs(DCS_Side)	 do
        for zoneName, element in pairs(zoneSAR) do
            for i = 1, #element do
               if  element[i].side == "" then
                    element[i].side = "neutrals"
                end
                if element[i].side == sideName then
                    if not camp_ZoneSAR[sideName][zoneName] then
                        camp_ZoneSAR[sideName][zoneName] = {
                            [1] = element[i]
                        }
                    else
                         for n=1, #camp_ZoneSAR[sideName][zoneName] do
                            if element[i].name == camp_ZoneSAR[sideName][zoneName][n].name then
                                 if element[i].embarked == true  and  camp_ZoneSAR[sideName][zoneName][n].status ~= "rescued" then
                                     camp_ZoneSAR[sideName][zoneName][n].status = "rescued"

                                    if element[i].initiatorPilotName then
                                        print("DcUS rescued "..tostring(zoneName).." "..tostring(element[i].initiatorPilotName))
                                    else
                                        print("DcUS rescued "..tostring(zoneName).." "..tostring(element[i].name))
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


--charge les coordonnées des boundary dessiné par le CampaignMaker
local boundary = {
    red = {},
    blue = {},
    neutral = {},
}

local tableDrawings = {}
if last_Mission and last_Mission.drawings then
    tableDrawings = last_Mission.drawings
elseif mission and mission.drawings then
    tableDrawings = mission.drawings
end
local foundBoundary = false

-- creation des frontieres en fonction des dessins dans base_Mission red et blue qui comporte le nom border ou boundary
if  tableDrawings and tableDrawings.layers then
    for Nlayers, layer in ipairs( tableDrawings.layers) do
        if (layer.name == "Red" or layer.name == "Blue" or layer.name == "Neutral" ) and layer.objects and #layer.objects >= 1 then
            for Nobjet, objet in ipairs(layer.objects) do
                local testName = string.lower(objet.name)
                 if ( string.find( testName , "border") or string.find( testName , "boundary") or string.find( testName , "frontline")   ) and #objet.points >= 3 then
					for n, point in ipairs(objet.points) do
                        local newPoints = {
                            x = point.x +  objet.mapX,
                            y = point.y +  objet.mapY,
                        }

                        table.insert(boundary[string.lower(layer.name)], newPoints)

						foundBoundary = true
					end
                end
            end
        end
    end
end

if not foundBoundary and Debug.debug then
    print(" * * * DcUsar there are no valid borders in this campaign * * * ")
end

camp.boundary = boundary

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

-- Remplace une année inférieure à 1970 par 1970 pour éviter les problèmes avec os.time
local aliasYear = camp.date.year
if aliasYear and aliasYear < 1970 then
    aliasYear = 1970
end

local timeActualCampaignSecond = os.time{day=camp.date.day, year=aliasYear, month=camp.date.month}

if camp_ZoneSAR and camp_ZoneSAR ~= nil then
    for sideName, sideSAR in pairs(camp_ZoneSAR) do
        for ZoneName, zone in pairs(sideSAR) do

            for Nelement, element in ipairs(zone) do
                if element.status ~= "rescued" and element.embarked then
                    element.status = "rescued"
                end
                
                local lowerName = string.lower(element.name)
                if string.find(lowerName, "pedro") and  string.find(lowerName, "damaged")  then
                    element.status = "error"
                end

                -- if element.initiatorPilotName and element.initiatorPilotName == "Rayak_71_CEF" then
                --     debugNoPow = true
                --     print("Sauvez le Soldat Rayak_71_CEF")
                --     element.status = "EVAC_possible"
                -- else
                --     debugNoPow = false
                -- end

                if (element.status == "MIA" or element.status == "EVAC_possible" ) and element.side == sideName and sideName ~= "neutrals" then
                    --change le point sur une route proche, si elle est atteignable
                    -- if element.CloseRoad and element.CloseRoad.x and element.CloseRoad.x ~= element.x then

                    --     local distance = math.sqrt(math.pow(element.x - element.CloseRoad.x, 2) + math.pow(element.y - element.CloseRoad.y, 2))
                    --     if distance <= 50000 then
                    --         element.x = element.CloseRoad.x
                    --         element.y = element.CloseRoad.y
                    --     end
                    -- end                   

					if debugDcUS then print("DcUS EjectedPilot name: "..tostring(element.name)) end

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
                            [3000] = 0,
                            [20000] = 0,
                            [200000] = 0
                        },
                        blue = {
                            [500] = 0,
                            [3000] = 0,
                            [20000] = 0,
                            [200000] = 0
                        },
                    }

                    --defini si le pilot est capturé ou récupérable
                     --recherche le nombre d'AMI ENI proche
                    for DistanceN, refD in ipairs(redDistance) do
                        for side, oob in pairs(oob_ground) do
                            for country_n, country in pairs(oob_ground[side]) do
                                if country.static then
                                    for group_n, group in pairs(country.static.group) do

                                        local distance = math.sqrt(math.pow(element.x2d - group.x, 2) + math.pow(element.y2d - group.y, 2))
                                        if not nbAMI_ENI[side][refD] then
                                            nbAMI_ENI[side][refD] = 0
                                        end
                                        if distance <= refD then
                                            nbAMI_ENI[side][refD] = nbAMI_ENI[side][refD] + #group.units
                                        end
                                    end
                                end
                                if  country.vehicle then
                                    for group_n, group in pairs(country.vehicle.group) do
                                        if not string.find(group.name, "_Pilot_") then
                                            local distance = math.sqrt(math.pow(element.x2d - group.x, 2) + math.pow(element.y2d - group.y, 2))

                                            if not nbAMI_ENI[side][refD] then
                                                nbAMI_ENI[side][refD] = 0
                                            end
                                            if distance <= refD then
                                                nbAMI_ENI[side][refD] = nbAMI_ENI[side][refD] + #group.units
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
                    if sideName == "blue" then
                        enemy = "red"
                    else
                        enemy = "blue"
                    end

                    if debugDcUS then
                        print("DcUS AA initChoicePOW "..tostring(element.initChoicePOW))
                    end

                    local aliasInitYear = camp.dateInit.year
                    if aliasInitYear < 1970 then
                        aliasInitYear = 1970
                    end
                
                    local aliasYear = camp.date.year
                    if aliasYear < 1970 then
                        aliasYear = 1970
                    end

                    --ajoute et met à jour le nb de jour depuis son ejection
                    if not element.ejectNbDay then
                        if element.year and element.month and element.day then
                            local timeEjectSecond = os.time{day=element.day, year=aliasYear, month=element.month}
                            local daysfrom = os.difftime(timeActualCampaignSecond, timeEjectSecond) / (24 * 60 * 60) -- seconds in a day 
                            element.ejectNbDay = daysfrom
                        else
                            element.ejectNbDay = 0
                        end
                    else
                        if element.year and element.month and element.day then
                            local timeEjectSecond = os.time{day=element.day, year=aliasYear, month=element.month}
                            local daysfrom = os.difftime(timeActualCampaignSecond, timeEjectSecond) / (24 * 60 * 60) -- seconds in a day 
                            element.ejectNbDay = tonumber(daysfrom)
                        end
                    end

                    if not element.POW_nextDayCheck then
                        element.POW_nextDayCheck =  element.ejectNbDay + 2
                    end

                    if debugDcUS then
                        print("DcUS AAb ejectNbDay "..tostring(element.ejectNbDay).." POW_nextDayCheck: "..tostring(element.POW_nextDayCheck))
                    end

                    --cherche s'il est ejecté chez l'ENI
                    if not element.initChoicePOW or element.initChoicePOW == nil then
                        element.inTheEnemyCamp =  CheckPointInPoly2({x=element.x2d,y=element.y2d}, boundary[enemy])
                        -- element.inTheEnemyCamp =  CheckPointInPoly2({x=element.y2d,y=element.x2d}, boundary[enemy])

                        if debugDcUS then
                            print("DcUS BB inTheEnemyCamp "..tostring(element.inTheEnemyCamp))
                        end

                        -- if element.inTheEnemyCamp then
                        --     math.random(1, 100)
                        --     math.random(1, 100)
                        --     math.random(1, 100)
                        --     local probaCapture = math.random(1, 100)

                        --     if probaCapture > 50 and not debugNoPow then
                        --         element.status = "POW"
                        --         if debugDcUS then 
                        --             print("DcUS CC RandomCapture POW if probaCapture > 50 "..element.status)
                        --         end
                        --         -- DeleteSoldierAliasPilot(element)

                        --     else
                        --         if debugDcUS then 
                        --             print("DcUS DD freeAtMoment "..element.status)
                        --         end

                        --     end

                        -- end

                        element.initChoicePOW = true

                        local PowDayMax = math.random(3, 15)

                        element.PowDayMax = PowDayMax

                        if debugDcUS then
                            print("DcUS EE initChoicePOW "..tostring(element.initChoicePOW))
                        end

                    elseif element.initChoicePOW and element.inTheEnemyCamp then
                            -- reference = os.time{day=15, year=2015, month=2}
                            -- daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
                            -- wholedays = math.floor(daysfrom)
                            -- print(wholedays) -- today it prints "1"

                        if not element.PowDayMax then
                            local PowDayMax = math.random(3, 15)

                            element.PowDayMax = PowDayMax
                        end

                        if element.PowDayMax and element.year and element.month and element.day then
                            local timeEjectSecond = os.time{day=element.day, year=element.year, month=element.month}
                            local daysfrom = os.difftime(timeActualCampaignSecond, timeEjectSecond) / (24 * 60 * 60) -- seconds in a day
                            if debugDcUS then print("DcUS daysfrom: "..tostring(daysfrom)) end
                            if daysfrom >  element.PowDayMax then
                                element.status = "POW"
                                if debugDcUS then print("DcUS too long: POW ") os.execute 'pause' end
                            end
                        end


                    end

                    --////////////////////////////************************////////////////////
                    if debugDcUS then
                        print("DcUS FFc ejectNbDay "..tostring(element.ejectNbDay).." POW_nextDayCheck: "..tostring(element.POW_nextDayCheck))
                    end

					if element.status ~= "POW" and  element.inTheEnemyCamp and not debugNoPow  and (element.ejectNbDay < element.POW_nextDayCheck) then

                        --indique de ne pas regarder à chaque generation le random POW, cela fausse les stats
                        --ne regarde qu'une fois par jour, ou tous les 2 jours ou...
                        element.POW_nextDayCheck = element.ejectNbDay + 2

                        -- if debugDcUS then print("DcUS IF_111A status ~= POW and inTheEnemyCamp ") end

                        -- _affiche(nbAMI_ENI, "nbAMI_ENI")

						if nbAMI_ENI[sideName][500] >= 2  then
							element.status = "EVAC_possible"
                            if debugDcUS then print("DcUS A ") end
						elseif  nbAMI_ENI[sideName][500] == 0 and  nbAMI_ENI[enemy][500] >= 2  then
							element.status = "POW"
                            if debugDcUS then print("DcUS B POW enemy][500] >= 2 ")  os.execute 'pause' end
                            -- DeleteSoldierAliasPilot(element)
						elseif nbAMI_ENI[sideName][3000] >= 2  and  nbAMI_ENI[enemy][3000] < 2 then
							element.status = "EVAC_possible"
                            if debugDcUS then print("DcUS C ") end
						elseif nbAMI_ENI[sideName][3000] < 2  and  nbAMI_ENI[enemy][3000] >= 2 then
							element.status = "POW"
                            if debugDcUS then print("DcUS D POW enemy][3000] >= 2 ")  os.execute 'pause' end
                            -- DeleteSoldierAliasPilot(element)
						elseif nbAMI_ENI[sideName][3000] >= 2  and  nbAMI_ENI[enemy][3000] >= 2  then
							local pourcent = (nbAMI_ENI[sideName][3000] / ( nbAMI_ENI[sideName][3000] + nbAMI_ENI[enemy][3000]))*100
							local coef = (element.ejectNbDay*(-1) + 5) -- plus le nb de jour augmente, plus les chances d etre capturé augmente
                            if coef < 1 then coef = 1 end
                            local randomMalChance = math.random(1, 100) / coef

                            if debugDcUS then print("DcUS F coef "..coef)
                                print("DcUS J POW [enemy][3000] >= 2 | randomMalChance  "..randomMalChance.." > pourcent? "..pourcent)
                            end
							if randomMalChance > pourcent then
								element.status = "POW"
                                if debugDcUS then print("DcUS F POW ")  os.execute 'pause' end
							elseif  not debugNoPow then
								 element.status = "EVAC_possible"
                                if debugDcUS then print("DcUS E enemy][3000] >= 2 ||if randomMalChance > pourcent ") end
                            end
						elseif nbAMI_ENI[sideName][20000] >= 2  and  nbAMI_ENI[enemy][20000] < 2 then
							element.status = "EVAC_possible"
                            if debugDcUS then print("DcUS G ") end
						elseif nbAMI_ENI[sideName][20000] < 2  and  nbAMI_ENI[enemy][20000] >= 2 then

                            element.status = "EVAC_possible"
                            if debugDcUS then print("DcUS H  POW [enemy][20000] >= 2 ")  end

                            -- element.status = "POW"
                            -- if debugDcUS then print("DcUS H  POW [enemy][20000] >= 2 ")   os.execute 'pause' end
                            -- DeleteSoldierAliasPilot(element)
						elseif nbAMI_ENI[sideName][20000] >= 2  and  nbAMI_ENI[enemy][20000] >= 2  then

							local pourcent = (nbAMI_ENI[sideName][20000] / ( nbAMI_ENI[sideName][20000] + nbAMI_ENI[enemy][20000]))*100
                            local coef = (element.ejectNbDay*(-1) + 5) -- plus le nb de jour augmente, plus les chances d etre capturé augmente
                            if coef < 1 then coef = 1 end
                            if debugDcUS then print("DcUS Ja POW [enemy][20000] >= 2 | Nb_sideName  "..nbAMI_ENI[sideName][20000].." Nb_enemy: ".. nbAMI_ENI[enemy][20000].." coef: "..coef) end

							local randomMalChance = math.random(1, 100)/coef
                            if debugDcUS then print("DcUS F coef "..coef)
                                print("DcUS Jb POW [enemy][20000] >= 2 | randomMalChance  "..randomMalChance.." > pourcent? "..pourcent)
                            end

							if randomMalChance > pourcent then
                                element.status = "POW"
                                if debugDcUS then
                                    print("DcUS Jc POW [enemy][20000] >= 2 | randomMalChance  "..randomMalChance.." > pourcent? "..pourcent)  os.execute 'pause'
                                end
							elseif  not debugNoPow then
								element.status = "EVAC_possible"
                                if debugDcUS then print("DcUS I ") end
                            end

						elseif nbAMI_ENI[sideName][200000] >= 2  and  nbAMI_ENI[enemy][200000] < 2 then
							element.status = "EVAC_possible"
                            if debugDcUS then print("DcUS K ") end
						elseif nbAMI_ENI[sideName][200000] < 2  and  nbAMI_ENI[enemy][200000] >= 2 then
							element.status = "EVAC_possible"
                            if debugDcUS then print("DcUS L ") end
						elseif nbAMI_ENI[sideName][200000] >= 2  and  nbAMI_ENI[enemy][200000] >= 2  then
							element.status = "EVAC_possible"
                            if debugDcUS then print("DcUS M ") end

                            element.status = "EVAC_possible"
                        else
                            element.status = "EVAC_possible"
						end

                    elseif  element.status == "POW" then
                        -- if debugDcUS then print("DcUS IF_111B status == POW ") end

                    elseif not  element.inTheEnemyCamp then

                        element.status = "EVAC_possible"

                        -- if debugDcUS then print("DcUS IF_111C not  element.inTheEnemyCamp status = EVAC_possible ") end
					end

                    --////////////////////////////************************////////////////////

                    if debugDcUS then
                        print("DcUS Q FINAL: "..tostring(element.status))
                    end

                    if camp.theatre and camp.theatre == "caucasus" then
                        dofile("../../../ScriptsMod."..VersionPackageICM.."/UTIL_Data_circleSAR_Caucasus.lua")

                        element.theatreCercle = true

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

                        if debugDcUS then print("DcUSAR passe 0 CIRCLE ") end
                        for nCircle, circle in ipairs(circleSAR) do

                            --Pixel axe x : horizontal vers la droite
                            --Pixel axe y : horizontal vers le bas
                            --x=0 et y=0, les origines en haut à gauche

                            --mission axe x: vertical vers le haut      (ordonne)
                            --mission axe y: horizontal vers la droite  (abscissse)

                            -- local mission2d_x = (ref_DCS_metre_ordonne * circle.pixel_y) / ref_pixel_ordonne     --pas assez precis
                            local mission2d_x = 58538.7 - (47.2304 * circle.pixel_y )
                                                --  58538.7−47.2304x


                            -- local mission2d_y = (ref_DCS_metre_abscissse * circle.pixel_x) / ref_pixel_abscissse    --pas assez precis                 
                            -- local mission2d_y = (564387 * circle.x2d) / offsett_pix_x
                            local mission2d_y = (47.2287 * circle.pixel_x) + 70914
                                                -- 47.2287x+70914

                            local testX = math.abs(element.x2d - mission2d_x)
                            local testY =  math.abs(element.y2d - mission2d_y)
                            -- print("DcUSAR passe A element x: "..tostring(element.x2d).." Y: "..tostring(element.y2d).." ||mission X: "..tostring(mission2d_x).." Y: "..tostring(mission2d_y).." ||Delat "..tostring(testX).." Y: "..tostring(testY))

                            if math.abs(element.x2d - mission2d_x) <= 2000 and math.abs(element.y2d - mission2d_y) <= 2000 then
                                -- print("DcUSAR passe B x: "..tostring(mission2d_x).." Y: "..tostring(mission2d_y))

                                local result = math.pow ((element.x2d - mission2d_x), 2) + math.pow((element.y2d - mission2d_y), 2) <= math.pow((circle.radius * 47.2287), 2)
                                if result then

                                    --le soldierEjectedPilot est déjà dans une zone SAR possible
                                    -- on arrete donc de chercher
                                    if debugDcUS then
                                        print("DcUS DcUSAR déjà sur une zone SAR pour poser l'helico: "..tostring(element.name))
                                        print("DcUS DcUSAR circle.pixel_x: "..tostring(circle.pixel_x))
                                        print("DcUS DcUSAR circle.pixel_y: "..tostring(circle.pixel_y))
                                    end

                                    element.landingPossible = true
                                    inSarZone = true
                                    element["circle"] = {
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
                        local initElementX2D =  element.x2d
                        local initElementY2D =  element.y2d

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

                                -- if math.abs(element.x2d - newZone_metre_x) <= 2000 and math.abs(element.y2d - newZone_metre_y) <= 2000 then 

                                if math.abs(element.x2d - newZone_metre_x) <= 20000 and math.abs(element.y2d - newZone_metre_y) <= 20000 then

                                    --distance de la nouvelle zone degagé depuis la zone de chute
                                    local distChuteNewZone = math.sqrt(math.pow(element.x2d - newZone_metre_x, 2) + math.pow(element.y2d - newZone_metre_y, 2))

                                                -- local result = Math.Pow((element.x2d - circle.x2d), 2) + Math.Pow((element.y2d - circle.y2d), 2) <= Math.Pow((circle.radius * 47.2287), 2)
                                                -- local distance = math.sqrt(math.pow(element.x2d - newZone_metre_x, 2) + math.pow(element.y2d - newZone_metre_y, 2))

                                    if distChuteNewZone < distanceSelected and not debugNoPow then

                                        --ne se déplace pas en territoire ENI
                                        local testEnyCamp =  CheckPointInPoly2({x=newZone_metre_x,y=newZone_metre_y}, boundary[enemy])

                                        if element.inTheEnemyCamp or (not element.inTheEnemyCamp and not testEnyCamp) then
                                            distanceSelected = distChuteNewZone

                                            --pour info, ce n'est pas la position xy mais une reference circle
                                            xy_Selected.x = circle.pixel_x
                                            xy_Selected.y = circle.pixel_y

                                            element.x2d = newZone_metre_x + (Nelement * 100)
                                            element.y2d = newZone_metre_y + (Nelement * 100)
                                            element["circle"] = {
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
                            element.landingPossible = true

                            if debugDcUS then
                                print("DcUS DcUSAR trouve une NOUVELLE  zone SAR pour poser l'helico "..tostring(element.name))
                                print("DcUS DcUSAR circle.pixel_x: "..tostring(xy_Selected.x))
                                print("DcUS DcUSAR circle.pixel_y: "..tostring(xy_Selected.y))
                                print("DcUS DcUSAR : "..tostring(element.name).." inTheEnemyCamp? AVANT "..tostring(element.inTheEnemyCamp))
                            end


                            element.inTheEnemyCamp =  CheckPointInPoly2({x=element.x2d,y=element.y2d}, boundary[enemy])



                            if debugDcUS then

                                print("DcUS DcUSAR : "..tostring(element.name).." inTheEnemyCamp? APRES "..tostring(element.inTheEnemyCamp))

                            end

                        end
                    else
                        element.landingPossible = false
                        element.theatreCercle = false
                    end

               end
                --selectionne la base la plus proche pour leur porter secours
                local selectedDistance = 9999999
                local selectedUnitName = ""
                for side_name,side in pairs(oob_air) do
                    if side_name == element.side then
                        for n, unit in pairs(side) do
                            if unit.tasks.SAR  and not unit.inactive  then
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

                                    -- if unit.base and db_airbases[unit.base]  and not db_airbases[unit.base].x then
                                    --     print("DcUSAR not base.x on "..unit.base)
                                    -- end

                                    if unit.base and db_airbases[unit.base] and db_airbases[unit.base].x then
                                        local distance = math.sqrt(math.pow(element.x2d -  db_airbases[unit.base].x, 2) + math.pow(element.y2d -  db_airbases[unit.base].y, 2))
                                        if distance <= selectedDistance then
                                            selectedDistance = distance
                                            selectedUnitName = unit.name

                                            if debugDcUS then
                                                print("DcUS EE_1 selectedUnitSAR "..tostring(element.MGRS_Chute )..tostring(element.name).." SUnitName: "..selectedUnitName.." "..selectedDistance)
                                            end

                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if selectedUnitName ~= "" then
                    element.selectedUnitSAR = selectedUnitName
                    if debugDcUS then
                        print("DcUS EEE_2 selectedUnitSAR "..tostring(element.MGRS_Chute ).." SUnitName: "..tostring(element.name).." SUnitName: "..selectedUnitName.." "..selectedDistance)
                    end
                end

                if debugDcUS then
                    print("DcUS GG initChoicePOW "..tostring(element.initChoicePOW))
                end

            end
        end
    end
end

--supprime de oob_ground les ejectedPilot capturé ou sauvé
if camp_ZoneSAR and camp_ZoneSAR ~= nil then
    for sideName, sideSAR in pairs(camp_ZoneSAR) do
        for ZoneName, zone in pairs(sideSAR) do
            for Nelement, element in ipairs(zone) do
                if element.status == "rescued" or element.status == "POW" or element.status == "error" then
                    
                    local result = DeleteSoldierAliasPilot(element)
                    
                    if not result then
                        print("DcUS GG (rescued or POW) No pilot to delete")
                    else
                    --    print("DcUS GG Deleted pilot: "..tostring(result))
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


if not camp.SAR then camp.SAR = {} end
camp.SAR.pilotEjected = {}

--creation table de la liste des pilote ejecté à utiliser dans le game DC_StaticAircraft
--UTIL pour calculer en temps réel la distance séparant ces pilotes des helico pour déclencher le fumigene
if camp_ZoneSAR and camp_ZoneSAR ~= nil then   -- and camp_ZoneSAR.blue ????
    for sideName, sideSAR in pairs(camp_ZoneSAR) do
        for ZoneName, zone in pairs(sideSAR) do
            for Nelement, element in ipairs(zone) do

				-- land.SurfaceType 
				-- LAND             1
				-- SHALLOW_WATER    2
				-- WATER            3 
				-- ROAD             4
				-- RUNWAY           5

                -- supprime d'abord le soldat existant, pour actualiser sa position et son status
                local result = DeleteSoldierAliasPilot(element)
                    if not result then
                        print("DcUS GG (maj) No pilot to delete "..tostring(element.name))
                    else
                    --    print("DcUS GG Deleted pilot: "..tostring(result))
                    end

                if element.status == "EVAC_possible" and element.SurfaceType ~= 5  then

                    local AddPilot = element
                    AddPilot.smokeTiming = 0
                    AddPilot.embarked = false
                    AddPilot.embarkAndSafe = false
                    AddPilot.landingPossible = element.landingPossible
                    AddPilot.inTheEnemyCamp = element.inTheEnemyCamp
                    AddPilot.radio_on  = false
                    AddPilot.radio_start = 0
                    if element.MGRS_Chute_10KM then
                        AddPilot.MGRS_Chute_10KM = element.MGRS_Chute_10KM
                    end
                    -- local AddPilot = {
                    --         name = element.name,
                    --         initiatorPilotName = element.initiatorPilotName,
                    --         side = element.side,
                    --         smokeTiming = 0,
                    --         embarked = false,
                    --         embarkAndSafe = false,
                    --         MGRS_Chute = element.MGRS_Chute,
                    --     }
                    table.insert(camp.SAR.pilotEjected, AddPilot)

                    --ne spawn pas dans l'eau (pas encore)
                    if element.SurfaceType ~= 3 then
                        AddSoldierAliasPilot(element)
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
