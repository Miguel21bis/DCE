-- helps the CampaignMaker 
-- appeler par BAT_FirstMission ou BAT_SkipMission
-- avec la commmande w2
-- Supprime un Groupe entier en donnant son numero de groupe
------------------------------------------------------------------------------------------------------- 
-- Last Modification cleancode_a
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Divers.lua"] = "1.3.22"
------------------------------------------------------------------------------------------------------- 
-- cleancode_a				(a springCleaning)
-- adjustment_a				(a ajout dataMap)
-- modification M38_n		Check and Help CampaignMaker (n: delete Ngroug)
------------------------------------------------------------------------------------------------------- 



require("Active/oob_ground")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Data.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_DataMap.lua")
dofile("../../../ScriptsMod."..versionPackageICM.."/UTIL_Functions.lua")


-- debugKT = true

function DelGroup(NGroup)
	FoundN_Group = 0
	for side_name,side in pairs(oob_ground) do														--side table(red/blue)											
		for country_n,country in pairs(side) do														--country table (number array)
			if country.vehicle then																	--if country has vehicles
				for group_n,group in pairs(country.vehicle.group) do								--groups table (number array)
					if NGroup == group.groupId then
						
						FoundN_Group = group_n
						print("UtilD DelGroup table.remove vehicle "..group.name.." "..group.units[1].name)
						break
					end
				end
				if FoundN_Group ~= 0 then table.remove(country.vehicle.group, FoundN_Group ) end
			end
			if country.static and FoundN_Group == 0 then																--if country has static objects	
				for group_n,group in pairs(country.static.group) do								--groups table (number array)
					if NGroup == group.groupId then
						
						FoundN_Group = group_n
						print("UtilD DelGroup table.remove static "..group.name.." "..group.units[1].name)
						break
					end
				end
				print("UtilD DelGroup passe B ")
				if FoundN_Group ~= 0 then table.remove(country.static.group, FoundN_Group )  print("UtilD DelGroup passe C "..FoundN_Group) end
			end
			if country.ship  and FoundN_Group == 0  then																--if country has ships
				for group_n,group in pairs(country.ship.group) do								--groups table (number array)
					if NGroup == group.groupId then
						
						FoundN_Group = group_n
						print("UtilD DelGroup table.remove ship "..group.name.." "..group.units[1].name)
						break
					end
				end
				if FoundN_Group ~= 0 then table.remove(country.ship.group, FoundN_Group ) end
			end
		end
	end
end

--===================================================================================
-- Ecran N 1



repeat
	local input = 0
	local inputString = ""
		
	print("N  de groupe a supprimer ")				--ask for user confirmation
	print("(S) Stop script ?")
	inputString = string.lower(io.read())

	if inputString == "s" then
		break
	else
		 -- Convertir inputString en nombre
		 local convertedInput = tonumber(inputString) -- Conversion potentiellement nil
		 if convertedInput then
			 input = convertedInput -- Assigner seulement si la conversion a réussi
			 DelGroup(input)
		 else
			 print("Erreur : Entrée invalide. Veuillez entrer un nombre.")
		 end
	end


	io.write( "\n")	
	
until  input == "s" or inputString == "s"
io.write( "\n")	

local ground_str = "oob_ground = " .. TableSerialization(oob_ground, 0)						--make a string
local groundFile = io.open("Active/oob_ground.lua", "w") or error("Failed to open debug file")
groundFile:write(ground_str)																--save new data
groundFile:close()

StopBug = true

os.execute 'pause'																					--pause command window for user to read text
os.exit()