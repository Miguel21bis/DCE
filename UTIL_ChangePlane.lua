--gives the player the possibility to change planes during the campaign.
------------------------------------------------------------------------------------------------------- 
-- last modification: cleanCode_c
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_ChangePlane.lua"] = "1.5.9"
-------------------------------------------------------------------------------------------------------

-- cleanCode_c				(b springCleaning)
-- adjustment_a
-- debug_a					(a recipient == nil)
-- modification M63_a		compatible Datacard Generator or CombatFlite
-- modification M55_c		player can change the type of plane (c:triggers part)(b:same Side)
-------------------------------------------------------------------------------------------------------


--====================================================================================================
--====================================================================================================
-- partie Plane
--change le type d'avion dans le fichier/table oob_air
--====================================================================================================
--====================================================================================================

local oldSquadName = ""
local newSquadName = ""

--essais de trier par type d'avion
--try to sort by aircraft type
--https://stackoverflow.com/questions/27909784/lua-sort-table-alphabetically-except-numbers
local function cmp(a, b)
   a = tostring(a.name)
   b = tostring(b.name)
   local patt = '^(.-)%s*(%d+)$'
   local _,_, col1, num1 = a:find(patt)
   local _,_, col2, num2 = b:find(patt)
   if (col1 and col2) and col1 == col2 then
      return tonumber(num1) < tonumber(num2)
   end
   return a < b
end

local playerPlane, playerSquad, playerCountry, playerSide

--affiche le type d'avion selectionné et son squadron
for side, squadTL in pairs(oob_air) do
	for squad_n, squad in  pairs(squadTL) do
		if squad.player then
			playerPlane = squad.type
			playerSquad = squad.name
			playerCountry = squad.country
			playerSide = side
			break
		end
	end
end


--TIPS sort (attention suite à un tri, la boucle doit etre fait avec ipairs)
local oobAirSide = oob_air[playerSide]
table.sort(oobAirSide, function(a, b) return a.type:upper() < b.type:upper() end)

local nType = 1
local tabSquad = {}

for unitN , unit in ipairs(oobAirSide) do
	if Playable_m[unit.type] and unit.inactive ~= true  then
		table.insert(tabSquad,nType, unit.name)

		io.write("\n"..nType .." | "..unit.type .." | "..unit.name.." | "..unit.country)

		nType = nType + 1
	end
end

io.write( "\n")
--===================================================================================
-- Ecran N�1 Selection Nombre d'avion Multiplayer
repeat
	local input = tonumber(io.stdin:read())

	if  tabSquad[input] then
		oldSquadName = playerSquad
		newSquadName = tabSquad[input]

		--supprime le player de l'ancien squad
		for side, squadTL in  pairs(oob_air) do
			for squad_n, squad in  pairs(squadTL) do
				if squad.name == oldSquadName then
					squad.player = false
				end
			end
		end

		--ajout le player du nouveau squad
		for side, squadTL in  pairs(oob_air) do
			for squad_n, squad in  pairs(squadTL) do
				if squad.name == newSquadName then
					squad.player = true
				end
			end
		end

	else
		print("\nInvalid entry.\n")
	end
until tabSquad[input]

----- save updated oob_air files  -----
local air_str = "oob_air = " .. TableSerialization(oob_air, 0)								--make a string
local airFile = io.open("Active/oob_air.lua", "w") or error("Failed to open debug file")
airFile:write(air_str)																		--save new data
airFile:close()



--====================================================================================================
--====================================================================================================
-- partie trigger
--change les conditions de victoire/defaite dans la table camp_triggers
--en changeant le nom du squad (on prend le nouveau squad et son Reinforce)
--====================================================================================================
--====================================================================================================
-- monfichier = io.open("../../../Missions/Campaigns/"..camp.title.."/Active/camp_triggers.lua", "r")
-- RadioFile2 = "../../../Missions/Campaigns/"..camp.title.."/Init/radios_freq_compatible.lua"

-- oldSquadName = playerSquad
-- newSquadName = tabSquad[input]

-- if Skipmission_flag then
-- 	-- dofile("../../../Missions/Campaigns/"..camp.title.."/Active/camp_triggers.lua")	
-- 	dofile("Active/camp_triggers.lua")
-- elseif Firstmission_flag then
-- 	dofile("../../../Missions/Campaigns/"..camp.title.."/Init/camp_triggers_init.lua")
-- 	-- dofile("Init/camp_triggers.lua")	
-- end

-- --****************************************************************************************
-- --ajout automatique d'elements en cours de campagne: START
-- --****************************************************************************************
-- --********************************* targetlist ******************************************************
-- dofile("Init/targetlist_init.lua")
-- local targetlist_init = targetlist
-- if not targetlist_init.blue[1] then
-- 	TargetlistToNum(targetlist_init)
-- end

-- dofile("Active/targetlist.lua")
-- if not targetlist.blue[1] then
-- 	TargetlistToNum(targetlist)
-- end

-- local changes = CompareTargetLists(targetlist_init, targetlist)

-- -- Afficher les résultats
-- for _, added in ipairs(changes.added) do
-- 	print("Added TargetList: Name:", added.data.name)
-- end
-- -- for _, removed in ipairs(changes.removed) do
-- -- 	print("Removed TargetList: Name:", removed.data.name)
-- -- end

-- -- Ajout des éléments manquants dans targetlist
-- for _, added in ipairs(changes.added) do
-- 	if not targetlist[added.side] then
-- 		targetlist[added.side] = {}
-- 	end
-- 	-- Insérer l'élément à la fin de la table numérique
-- 	table.insert(targetlist[added.side], added.data)
-- end

-- -- -- Suppression des éléments retirés de targetlist
-- -- for _, removed in ipairs(changes.removed) do
-- -- 	if targetlist[removed.side] then
-- -- 		for i, target in ipairs(targetlist[removed.side]) do
-- -- 			if target.name == removed.name then
-- -- 				table.remove(targetlist[removed.side], i)
-- -- 				break
-- -- 			end
-- -- 		end
-- -- 	end
-- -- end

-- --********************************* camp_triggers ******************************************************
-- -- Charger les fichiers de référence et de travail
-- dofile("Init/camp_triggers_init.lua")
-- local camp_triggers_init = camp_triggers

-- dofile("Active/camp_triggers.lua")

-- -- Comparer les deux tables
-- changes = CompareTableNumeric(camp_triggers_init, camp_triggers)

-- -- Afficher les résultats
-- for _, added in ipairs(changes.added) do
-- 	print("Added triggers: Name:", added.name)
-- end
-- for _, removed in ipairs(changes.removed) do
-- 	print("Removed triggers: Name:", removed.name)
-- end

-- -- Ajouter les éléments manquants dans camp_triggers
-- for _, added in ipairs(changes.added) do
-- 	table.insert(camp_triggers, added)
-- end
-- -- Supprimer les éléments retirés de camp_triggers
-- for _, removed in ipairs(changes.removed) do
-- 	for i, trigger in ipairs(camp_triggers) do
-- 		if trigger.name == removed.name then
-- 			table.remove(camp_triggers, i)
-- 			break
-- 		end
-- 	end
-- end



-- --********************************* db_airbases ******************************************************
-- -- Charger les fichiers de référence et de travail
-- dofile("Init/db_airbases.lua")
-- local db_airbases_init = db_airbases

-- dofile("Active/db_airbases.lua")

-- -- Comparer les deux tables
-- changes = CompareTableAlphaNumeric(db_airbases_init, db_airbases)

-- -- Afficher les résultats
-- for _, added in ipairs(changes.added) do
--     print("\nAdded db_airbases Name:", added.name)
-- end
-- for _, removed in ipairs(changes.removed) do
--     print("\nRemoved db_airbases: Name:", removed.name)
-- end

-- -- Ajouter les éléments manquants dans db_airbases
-- for _, added in ipairs(changes.added) do
--     db_airbases[added.name] = added.data
-- end
-- -- Supprimer les éléments retirés de db_airbases
-- for _, removed in ipairs(changes.removed) do
--     db_airbases[removed.name] = nil
-- end

-- --****************************************************************************************
-- --ajout automatique d'elements en cours de campagne: FIN
-- --****************************************************************************************

LoadFileAndUpdate("UTIL_ChangePlane "..debug.getinfo(1).currentline)

local reinforce = {}
--recherche l'escadron de ravitaillement, s'il existe
--['action'] = 'Action.AirUnitReinforce("R/3.IAP", "3.IAP", 12)',
for name, trig in pairs(camp_triggers) do
	if trig.action and type(trig.action) ~= "table" and type(trig.action) == "string" then
		if string.find(trig.action, "Action.AirUnitReinforce")  then
			local s  = ""

			s = trig.action
			s = s:gsub("\"", '')

			local donor, recipient = s:match("([^,]+),([^,]+)")
			if recipient ~= nil then
				recipient = recipient:gsub(" ", "", 1)
			end
			if donor ~= nil then
				-- un_, donor = donor:match("([^,]+)%(([^,]+)")
				donor = string.gsub(donor, "[()]", "")
			else

				donor = string.gsub(s, "Action.AirUnitReinforce", "")
				donor = string.gsub(donor, "[()]", "")
				recipient = donor
			end

			if recipient ~= nil and not reinforce[recipient]  then reinforce[recipient] = donor end
		end
	end
end

for name, trig in pairs(camp_triggers) do
	if trig.action and type(trig.action) == "table" then
		for n = 1, #trig.action do
			if (trig.action[n] == 'Action.CampaignEnd("win")' or  trig.action[n] == 'Action.CampaignEnd("loss")')  then

				if string.find( oldSquadName, "%-") and not  string.find( oldSquadName, "%%") then
					oldSquadName = oldSquadName:gsub("%-", "%%-" )
				end

				if string.find(trig.condition, oldSquadName) then

					local s = trig.condition
					local stringEgal = ""
					local trigChanged = false

					local one, nValue = s:match("([^,]+)<([^,]+)")

					if one == nil and nValue == nil and  string.find(s, "==") then
						one, nValue = s:match("([^,]+)=([^,]+)")
						one = one:gsub( "=", "")
					end


					if nValue and string.find(nValue, "=") then
						stringEgal = "="
					end

					if one:find("+") then
						one, _ = s:match("([^,]+)+([^,]+)")
					end


					if string.find(one, "AirUnitReady") or string.find(one, "AirUnitAlive")  then
						--['condition'] = 'Return.AirUnitAlive("VFA-106") + Return.AirUnitReady("R/VFA-106") < 5',

						trigChanged = true
						one = one:gsub(oldSquadName, newSquadName)

						if reinforce[newSquadName] then
							--condition = 'Return.AirUnitAlive("VFA-106") + Return.AirUnitReady("R/VFA-106") < 5',								
							one = one .. " + Return.AirUnitReady(\""..reinforce[newSquadName].."\")"							
						end
					end

					if trigChanged  then
						trig.condition = ""
						local stringAnd = ""
						local tempConcat = one.."<"..stringEgal .."".. tostring(nValue).." "

						if string.find(s, " and ") then stringAnd = " and " end
						if trig.condition ~= "" then
							trig.condition = trig.condition..stringAnd..tempConcat
						else
							trig.condition = tempConcat
						end
						--sauvegarde l'etat initial de la condition pour pouvoir la remettre 
						-- if not trig.InitCondition then
							-- trig.InitCondition = s
						-- end
						if not trig.nValue then
							trig.nValue = tonumber(nValue)
						end
					end
				end
			end
		end
	end
end

----- save updated oob_air files  -----
local trigStr = "camp_triggers = " .. TableSerializationAG(camp_triggers, 0)
local trigFile = io.open("Active/camp_triggers.lua", "w") or error("Failed to open debug file")
trigFile:write(trigStr)
trigFile:close()

ChangePlane = true
if Skipmission_flag then
	dofile("../../../ScriptsMod."..VersionPackageICM.."/BAT_SkipMission.lua")
elseif Firstmission_flag then
	dofile("../../../ScriptsMod."..VersionPackageICM.."/BAT_FirstMission.lua")
end


-- local test_str = "oob_air = " .. TableSerialization(oob_air, 0)						--make a string
-- local testFile = io.open("Debug/oob_airChangePlane.lua", "w")								--open targetlist file
-- testFile:write(test_str)															--save new data
-- testFile:close()