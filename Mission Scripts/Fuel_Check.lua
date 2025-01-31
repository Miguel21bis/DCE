----------------------------------------------------------------------------------------
---
-- Name: Simple Fuel Check Script
-- Author: Michael Normandeau
-- ak: "Norman99"
--
-- Version: 1.0
-- Date Created: 03 April 2021
--
----------------------------------------------------------------------------------------
--using VIACOM and adding a "Fuel Check" voice command
------------------------------------------------------------------------------------------------------- 
-- last
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/Fuel_Check.lua"] = "0.1.3"
------------------------------------------------------------------------------------------------------- 
-- Reglage_b						(b: test all plane(description.fuelMassMax))
------------------------------------------------------------------------------------------------------- 

Units = "imperial"

function FuelCheck()														-- create fuel check function	
	local coef  = 1
	if Units == "imperial" then	
		 coef  =  2.205
	end
	
	local pu = world.getPlayer()											-- get player unit
	local pg = Unit.getGroup(pu)											-- get player group		
	local wingman = pg:getUnits()
	
	for n = 2, #wingman do			
		local Nwingman = pg:getUnit(n)		
		local qty = Nwingman:getFuel()		
		local description = Nwingman:getDesc()		
		qty = qty * description.fuelMassMax * coef							--F14 7348 kg
		qty = math.floor(qty/100)/10		
		trigger.action.outText(Unit.getName(Nwingman)..":  "..qty,10,false)
	end	
end

missionCommands.addCommand("Fuel Check",nil,FuelCheck)						-- add fuel check item to F10 menu & call fuelcheck function

