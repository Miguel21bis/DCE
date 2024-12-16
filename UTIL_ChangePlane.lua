--gives the player the possibility to change planes during the campaign.
------------------------------------------------------------------------------------------------------- 
-- last modification: cleanCode_b
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_ChangePlane.lua"] = "1.5.8"
-------------------------------------------------------------------------------------------------------

-- cleanCode_b				(b springCleaning)
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

local playerPlane,playerSquad,playerCountry,playerSide

--affiche le type d'avion selectionné et son squadron
for side, squadTL in  pairs(oob_air) do
	for squad_n, squad in  pairs(squadTL) do
		if squad.player then
			playerPlane = squad.type
			playerSquad = squad.name
			playerCountry = squad.country
			playerSide = side
		end
	end
end


--TIPS sort (attention suite à un tri, la boucle doit etre fait avec ipairs)
local oobAirSide = oob_air[playerSide]
table.sort(oobAirSide, function(a, b) return a.type:upper() < b.type:upper() end)

local nType = 1
local TabSquad = {}
-- for nSide , oob_airSide in pairs(oob_air) do														--pour afficher l'exemple de selection du premier avion pr�sent�
	-- if nSide == playerSide then
		-- for i,v in ipairs(animals) do print(v.name) end
		for m , unit in ipairs(oobAirSide) do
			if Playable_m[unit.type] and unit.inactive ~= true  then
				table.insert(TabSquad,nType, unit.name)

				io.write("\n"..nType .." | "..unit.type .." | "..unit.name.." | "..unit.country)

				nType = nType + 1
			end
		end
	-- end
-- end
io.write( "\n")
--===================================================================================
-- Ecran N�1 Selection Nombre d'avion Multiplayer
repeat
	local input = tonumber(io.stdin:read())

	if  TabSquad[input] then
		oldSquadName = playerSquad
		newSquadName = TabSquad[input]

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
until   TabSquad[input]

----- save updated oob_air files  -----
local air_str = "oob_air = " .. TableSerialization(oob_air, 0)								--make a string
if TypeAlias then
	air_str = air_str .. "TypeAlias = " .. TableSerialization(TypeAlias, 0)
end
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
-- newSquadName = TabSquad[input]

local oldSquadNameInit = oldSquadName

if Skipmission_flag then
	-- dofile("../../../Missions/Campaigns/"..camp.title.."/Active/camp_triggers.lua")	
	dofile("Active/camp_triggers.lua")
elseif Firstmission_flag then
	dofile("../../../Missions/Campaigns/"..camp.title.."/Init/camp_triggers_init.lua")
	-- dofile("Init/camp_triggers.lua")	
end


local Reinforce = {}
--recherche l'escadron de ravitaillement, s'il existe
--['action'] = 'Action.AirUnitReinforce("R/3.IAP", "3.IAP", 12)',
for name, trig in pairs(camp_triggers) do
	if trig.action and  type(trig.action) ~= "table" then
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

			if recipient ~= nil and not Reinforce[recipient]  then Reinforce[recipient] = donor end
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
					local TrigChanged = false

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

						TrigChanged = true
						one = one:gsub(oldSquadName, newSquadName)

						if Reinforce[newSquadName] then
							--condition = 'Return.AirUnitAlive("VFA-106") + Return.AirUnitReady("R/VFA-106") < 5',								
							one = one .. " + Return.AirUnitReady(\""..Reinforce[newSquadName].."\")"							
						end
					end

					if TrigChanged  then
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
	dofile("../../../ScriptsMod."..versionPackageICM.."/BAT_SkipMission.lua")
elseif Firstmission_flag then
	dofile("../../../ScriptsMod."..versionPackageICM.."/BAT_FirstMission.lua")
end



-- local test_str = "oob_air = " .. TableSerialization(oob_air, 0)						--make a string
-- local testFile = io.open("Debug/oob_airChangePlane.lua", "w")								--open targetlist file
-- testFile:write(test_str)															--save new data
-- testFile:close()