-- ATC ShutUp GENERIC
-- v 0.02A
-- by GC22 "Psyko"
--------------------------------------------------------------------------------------
-- DO NOT EDIT THE SCRIPT!!!

-- To use this script :
-- 1) create a trigger in the mission "time since mission start" with the action "execute file script" (or load script via lua with : dofile("myfolder\\ATC_ShutUp_GENERIC.lua"))
-- 2) A message "**ATC shutup script loaded**" will appears when the script is loaded
-- 3) When a client spawn in a unit, the script will disable the ATC on his coalition airbases (except FARP and ships)
-- 4) 
------------------------------------------------------------------------------------------------------- 
-- last modification:  M53_b
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/ATC_ShutUp_GENERIC.lua"] = "1.2.4"
------------------------------------------------------------------------------------------------------- 
-- Psyko modification       M59_a			silences the tower
-- miguel21 modification    M53_b			automatic update of the conf_mod file (b conf_mod reconfiguration)
------------------------------------------------------------------------------------------------------- 



EventClientSpawn = {}
    -- trigger.action.outText("**ATC shutup script loaded**", 5, 0)		--init text
	env.info("**ATC shutup script loaded**")
	
function EventClientSpawn:onEvent(event)

    if event.id == world.event.S_EVENT_BIRTH and camp.silenceATC then	--client spawning in a unit
        -- trigger.action.outText("**New Unit detected**", 5, 0)		-- debug text
		env.info("**New Unit detected**")
		
        UnitDesc = event.initiator:getDesc()

        if UnitDesc.category then
            if UnitDesc.category == 1 or UnitDesc.category == 0 then
            -- trigger.action.outText("**Plane or chopper detected**", 5, 0)		-- debug text
			env.info("**Plane or chopper detected**")
			
                local PilUnitCoal = event.initiator:getCoalition()      -- get coalition of the client unit
                -- trigger.action.outText("**Coalition : "..tostring(PilUnitCoal).."**", 5, 0)		-- debug text
				env.info("**Coalition : "..tostring(PilUnitCoal).."**")
				
                local BasesList = coalition.getAirbases(""..tostring(PilUnitCoal..""))    -- return table of PilUnit coalition
                -- trigger.action.outText("**Get the airbases = "..tostring(BasesList).."**", 5, 0)		-- debug text
				env.info("**Get the airbases = "..tostring(BasesList).."**")
				
                for i = 1, #BasesList do
                    if BasesList[i]:hasAttribute("Airfields") == true then
                        -- trigger.action.outText("**Airdrome selected**", 5, 0)		-- debug text
                        -- env.info("**Airdrome selected**")
						Airbase.getByName(BasesList[i]:getName()):setRadioSilentMode(true)      -- apply ATC shutup to the airbases in PilUnit coalition
                        -- trigger.action.outText("**ATC shutup has been activated**", 30, 0)		-- activation message
						-- env.info("**ATC shutup has been activated**")
					end
                end
            end
        end
    end
end

world.addEventHandler(EventClientSpawn)     -- add the eventhandler to SSE