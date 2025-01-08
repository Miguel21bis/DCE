-- helps the CampaignMaker to balance the campaign
--
------------------------------------------------------------------------------------------------------- 
-- Last Modification cleancode_a
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_HelpBalancePower.lua"] = "1.4.9"
------------------------------------------------------------------------------------------------------- 
-- adjustment_b				(a: depreciated variable capability)
-- cleancode_a				(a springCleaning)	
-- modification M56_a		AssignCallnameSquad
-- modification M38_e		helps to balance the game
------------------------------------------------------------------------------------------------------- 


local balance = {}
local balanceTS = {}
local tabMaxSum = {}


for side, unit in pairs(oob_air) do
	for n = 1, #unit do
		if unit[n].inactive ~= true and db_airbases[unit[n].base] and db_airbases[unit[n].base].inactive ~= true then
			local plane = unit[n].type
			for task,task_bool in pairs(unit[n].tasks) do

				if task_bool then
					local temp_Draft_sorties = {}														--temporary table to hold additional draft sorties with escorts assigned
					--get possible loadouts
					local unit_loadouts = {}														--table to hold all loadouts for this aircraft type and task
					for loadout_name, ltable in pairs(db_loadouts[unit[n].type][task]) do			--iterate through all loadouts for the aircraft type and task
						ltable.name = loadout_name
						unit_loadouts[#unit_loadouts+1] = ltable
					end

					-- ajoute dans une table les informations aux plus hautes valeurs
					if unit[n].number > 0 and db_loadouts[unit[n].type][task]  then																				--has ready aircraft

						local somme = 0
						local sum_fireP = 0
						for l = 1, #unit_loadouts do
							sum_fireP = sum_fireP +  unit_loadouts[l].firepower
							
							-- local break_loop = false
							for m = 1, 6 do

								if not tabMaxSum[side] then tabMaxSum[side] = {} end
								if not tabMaxSum[side][m] then tabMaxSum[side][m] = {}  tabMaxSum[side][m]["sum"] = 0 end

								if ((sum_fireP )  /#unit_loadouts) > tabMaxSum[side][m]["sum"] then

									-- tabMaxSum[side][m] = nil
									tabMaxSum[side][m] = {
										["sum"] = (sum_fireP )  /#unit_loadouts,
										["plane"] = plane,
										["task"] = task,
										["name"] = unit_loadouts[l].name,
										["firepower"] = unit_loadouts[l].firepower,
										-- ["capability"] = unit_loadouts[l].capability,
										["nbLoadout"] = #unit_loadouts
									}
									-- break_loop = true
									-- break

								end
								-- if break_loop then break end
							end
						end

						--(sum_fireP  /#unit_loadouts) pour calculer la moyenne des firepowers
						-- aditionne ici les plus hautes valeurs

						if not balanceTS[task] then 
							balanceTS[task] = {
								["blue"] = 
								{
									["numberblue"] = 0,
									["sommeblue"] = 0,
								},
								["red"] = 
								{
									["numberred"] = 0,
									["sommered"] = 0,
								},
							} 
						end
	
						if task == "Escort" or task == "CAP" or task == "Intercept" then
							somme = ((sum_fireP )  /#unit_loadouts)  * unit[n].number
							balanceTS[task][side]["somme"..side] = balanceTS[task][side]["somme"..side] + somme
							balanceTS[task][side]["number"..side] = balanceTS[task][side]["number"..side] + unit[n].number

						else
							somme = (sum_fireP  /#unit_loadouts)  * unit[n].number
							balanceTS[task][side]["somme"..side] = balanceTS[task][side]["somme"..side] + somme
							balanceTS[task][side]["number"..side] = balanceTS[task][side]["number"..side] + unit[n].number

						end

					end
				end

			end

		end

	end

end

-- if Debug.debug then
-- 	local camp_str = "BalancePower = " .. TableSerialization(balanceTS, 0)						--make a string
-- 	local campFile = io.open("Debug/BalancePower.lua", "w")  or error("Failed to open debug file")
-- 	campFile:write(camp_str)																		--save new data
-- 	campFile:close()
-- end

print()
print("The 6 highest values of each camp:")
_affiche(tabMaxSum)

function Space(txt, space_)
	space_ = space_ - string.len(tostring(txt))

	for n = 1, space_ * 1.0 do	 --for n = 1, space_ * 1.5 do														
		txt = txt .. " "																	--add 1.5 spaces for every missing letter
	end

	return txt

end

local s = "\\n"																	--make a list with details of the player waypoints

local entries = {																			--list entries that are making up the navigaion overview

	[1] = {
		lookup = "task",
		header = "Task",
		str_length = 20,
	},
	[2] = {
		lookup = "numberblue",
		header = "Nb Blue",
		str_length = 8,
	},
	[3] = {
		lookup = "sommeblue",
		header = "TotFirepowerBlue",
		str_length = 16,
	},
	[4] = {
		lookup = "numberred",
		header = "Nb Red",
		str_length = 8,
	},
	[5] = {
		lookup = "sommered",
		header = "TotFirepowerRed",
		str_length = 16,
	},
}

--build the list header
for e = 1, #entries do																		--iterate through all entries
	s = s .. entries[e].header																--add entry of this waypoint to list
																							--if this is not the last entry of the waypoints, add spaces to the next entry	
	local space = entries[e].str_length + 0 - string.len(tostring(entries[e].header))		--calculate number of spaces that need to be added for alignement (string length of largest entry of same type + 3 - length of current entry = number of spaces)
	entries[e]["space"] = space
	for n = 1, space * 1.0 do
		s = s .. " "																		--add 1.5 spaces for every missing letter
	end

end
s = s .. "\\n"


local test = ""
for task, _side in pairs(balanceTS) do
	for e = 1, #entries do
		local entry = ""
		if entries[e].lookup == "task" then
			entry = Space(task, entries[e].str_length)
		end
		s = s.. entry
	end


	for side, _value in pairs(_side) do
		for e = 1, #entries do
			-- io.write("D")
			local entry = ""

			if entries[e].lookup == "number"..side then
				entry = ""..Space(balanceTS[task][side]["number"..side], entries[e].str_length)
				-- io.write("|E_/"..entry.."/")
			elseif entries[e].lookup == "somme"..side then
				entry = ""..Space(balanceTS[task][side]["somme"..side], entries[e].str_length)
				-- io.write("|F_/"..entry.."/")
			end
			s = s.. entry
		end
	end

	s = s .. "\\n"

end
print()
print("Nb: ".." Number of plane in oob_air_init ")
-- print("CAP or Escorte or Intercept Tot : ".." Tot = ((sum_firepower * sum_capability)  /#unit_loadouts)  * unit[n].number ")
print("Example Tot :                       ".." Tot = ((sum_firepower)  /#unit_loadouts)  * unit[n].number ")
local DebugTXT = StringToTxt(s)
print("UTIL_HBP HelpBalancePwer "..DebugTXT)
print()
print("You can change oob_air_init.lua or db_loadout.lua file ")
print("And touch any key for restart the script without closing/opening a dos windows ")
