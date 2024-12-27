



local function parseGroups()

    local loCoalitions = {coalition.side.BLUE, coalition.side.RED}
    local loCategories = {Group.Category.AIRPLANE, Group.Category.HELICOPTER}
    local locTimer = timer.getTime()

    trigger.action.outText( "..***..START TimerCycle: "..locTimer.."..***",20,false)

    for coalitionN, sideNum in ipairs(loCoalitions) do
        for categoryN, category in ipairs(loCategories) do
            local groups = coalition.getGroups(sideNum, category)

            for gpN, gp in pairs(groups) do
                local wingmen = gp:getUnits()

                for winmanN, _unit in ipairs(wingmen) do
                    if _unit and _unit:isActive()  then --and _unit:inAir()
                        local playerName =  _unit:getPlayerName()
                        local unitName = _unit:getName()


                        env.info("DEBUG getGroups() : coalitionN: "..coalitionN.." categoryN: "..categoryN.." gpN: "..gpN
                        .." unitName: "..unitName.." playerName? ("..tostring(playerName)..")")

                        trigger.action.outText( "coalitionN: "..coalitionN.." categoryN: "..categoryN.." gpN: "..gpN
                        .." unitName: "..unitName.." playerName? ("..tostring(playerName)..")", 20, false)



                    end
                end
            end
        end
    end

    trigger.action.outText( "..***..END TimerCycle: "..locTimer.."..***",20,false)

    return timer.getTime() + 30
end

local function parseGroups_B()

    -- local loCoalitions = {coalition.side.BLUE, coalition.side.RED}
    -- local loCategories = {Group.Category.AIRPLANE, Group.Category.HELICOPTER}
    local locTimer = timer.getTime()

    trigger.action.outText( "..***..START TimerCycle: "..locTimer.."..***",20,false)

    -- for coalitionN, sideNum in ipairs(loCoalitions) do
    --     for categoryN, category in ipairs(loCategories) do
            local groups = coalition.getGroups(coalition.side.RED, Group.Category.AIRPLANE)

            for gpN, gp in pairs(groups) do
                local gpName = gp:getName()
                trigger.action.outText( "BB gpN: "..gpN.." gpName: "..gpName, 20, false)

                local wingmen = gp:getUnits()

                for winmanN, _unit in ipairs(wingmen) do
                    if _unit and _unit:isActive()  then --and _unit:inAir()
                        local playerName =  _unit:getPlayerName()
                        local unitName = _unit:getName()

                        env.info("DEBUG_B getGroups() : gpN: "..gpN.." unitName: "..unitName.." playerName? ("..tostring(playerName)..")")

                        trigger.action.outText( "BB gpN: "..gpN.." unitName: "..unitName.." playerName? ("..tostring(playerName)..")", 20, false)

                    end
                end
            end
    --     end
    -- end

    trigger.action.outText( "..***..END TimerCycle: "..locTimer.."..***",20,false)

    return timer.getTime() + 30
end



timer.scheduleFunction(parseGroups, nil, timer.getTime() + 30)
timer.scheduleFunction(parseGroups_B, nil, timer.getTime() + 60)

