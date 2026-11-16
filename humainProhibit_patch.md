# humainProhibit_IAOnly + correctif humainOnly — patch

## 0. Resume

- Nouveau drapeau squad : `["humainProhibit_IAOnly"] = true` (a poser dans **Init/oob_air_init.lua**). Le squad n'est jamais propose a un humain, il reste un squad IA pour la generation.
- Si le squad est deja `player = true` : `player` passe a `false` silencieusement (+ ligne AddLog), l'avertissement habituel "pas de joueur" prend le relais.
- Correctif `humainOnly` : (a) generation correcte dans `ATO_Generator_C_Core.lua` (fichier complet joint), (b) nettoyage apres affectation dans `ATO_PlayerAssign.lua` (`PruneHumainOnlyAI`, desactivable par `HUMAIN_ONLY_PRUNE = false`).
- Hypothese a valider : **Init/oob_air_init.lua fait autorite** pour le drapeau (ajout/retrait a chaud pris en compte a chaque appel de `ApplyHumainProhibit`).

Fichiers : 
| Fichier | Livraison |
|---|---|
| ATO_Generator_C_Core.lua | fichier complet joint (2 blocs modifies : `passHumain` dans processEligibleLoadout, `passIsClientCondition` dans la boucle support) |
| UTIL_Functions.lua | section 1 : nouvelles fonctions + `SetUnitClient` complete |
| ATO_PlayerAssign.lua | section 2 : 3 modifications |
| BAT_FirstMission / BAT_SkipMission / DEBRIEF_Master | section 3 : modifications d'une ligne |
| UTIL_ChangePlane.lua | section 4 : corps complet (garder votre en-tete versionDCE tel quel) |
| UTIL_ChangePlane_DceM.lua | section 5 : fichier complet |

---

## 1. UTIL_Functions.lua

Ajouter les fonctions et **remplacer** l'ancienne `SetUnitClient` (qui appelait `SetBaseHumain` deux fois) par celle-ci. Les nouvelles fonctions doivent etre definies au niveau global, avant tout appel.

```lua
--=========================================================================
-- Squad interdit aux humains : variable ["humainProhibit_IAOnly"] = true dans oob_air
-- (a poser dans Init/oob_air_init.lua, sur le squad concerne).
--   - le squad n'est jamais propose aux joueurs (menus [C], Multi, assignation du vol)
--   - il reste un squad IA normal pour la generation des missions
-- Ne pas confondre avec ["humainOnly"] = true : le squad n'existe QUE pour un humain.
--=========================================================================
HUMAIN_PROHIBIT_KEY = "humainProhibit_IAOnly"
HumainProhibitLast = nil		-- { side =, squad = } du dernier squad joueur retire par ApplyHumainProhibit

function IsHumainProhibited(squad)
	return type(squad) == "table" and squad[HUMAIN_PROHIBIT_KEY] == true
end

-- A appeler apres chargement de oob_air, AVANT de chercher le squad joueur (squad.player).
--   1) Init/oob_air_init.lua fait autorite pour le drapeau (ajout comme retrait, a chaud)
--   2) un squad interdit perd player et client : il redevient un squad IA
function ApplyHumainProhibit()

	HumainProhibitLast = nil

	-- 1) lecture du drapeau dans Init, sans toucher a oob_air (meme methode que AssignCallnameSquad)
	local initNames = {}		-- initNames[nomSquad] = true si le squad existe dans Init
	local initFlag = {}			-- initFlag[nomSquad] = true si le drapeau est pose dans Init
	local initOk = false

	local chunk = loadfile("Init/oob_air_init.lua")
	if chunk then
		local tempEnv = {}
		setfenv(chunk, tempEnv)
		if pcall(chunk) and type(tempEnv.oob_air) == "table" then
			initOk = true
			for _, squads in pairs(tempEnv.oob_air) do
				if type(squads) == "table" then
					for _, sq in pairs(squads) do
						if type(sq) == "table" and sq.name then
							initNames[sq.name] = true
							if sq[HUMAIN_PROHIBIT_KEY] == true then
								initFlag[sq.name] = true
							end
						end
					end
				end
			end
		end
	end

	-- 2) synchronisation + application sur oob_air
	for side, squads in pairs(oob_air) do
		for squad_n, squad in pairs(squads) do
			if type(squad) == "table" then

				if initOk and initNames[squad.name] then
					if initFlag[squad.name] then
						squad[HUMAIN_PROHIBIT_KEY] = true
					else
						squad[HUMAIN_PROHIBIT_KEY] = nil
					end
				end

				if IsHumainProhibited(squad) then
					if squad.player then
						HumainProhibitLast = { side = side, squad = squad.name }
						AddLog("HumainProhibit: squad "..tostring(squad.name).." was the player squad, player flag removed (squad is AI only). Choose another squad with [C].")
					end
					squad.player = false
					squad.client = nil
				end
			end
		end
	end
end

function SetUnitClient(unitName)
	--parse la table oob_air puis trouve unitName puis y ajoute la variable : client = true
	for sideName, squads in pairs(oob_air) do
		for squadN, squad in pairs(squads) do
			if squad.name == unitName then

				-- squad interdit aux humains : refus central, valable pour tous les menus Multi
				if IsHumainProhibited(squad) then
					AddLog("HumainProhibit: SetUnitClient refused for squad "..tostring(squad.name))
					return false
				end

				squad.client = true
				local result = SetBaseHumain(squad.base)
				if not result then
					AddLog("BatSM ECHEC to set HumanBase " ..tostring(squad.base))
				end
				return true
			end
		end
	end

	-- print("SetUnitClient return FALSE")
	return false
end
```

---

## 2. ATO_PlayerAssign.lua

### 2.1 Squads interdits (a placer apres `if not camp.MultiPlayer["pack_n"] then ... end`, avant la boucle `for side, pack in pairs(ATO)`)

```lua
-- humainProhibit_IAOnly : liste des squads interdits aux humains (filet de securite cote generation)
local prohibitedSquad = {}
for _, squads in pairs(oob_air) do
	for _, sq in pairs(squads) do
		if IsHumainProhibited and IsHumainProhibited(sq) then
			prohibitedSquad[sq.name] = true
		end
	end
end

```

### 2.2 Filtre dans la boucle qui construit `playable`

Remplacer la ligne `if flight[f].playable == true then` (une seule occurrence, dans la boucle imbriquee `for f = 1, #flight do`) par :

```lua
				if flight[f].name and prohibitedSquad[flight[f].name] then			--humainProhibit_IAOnly : jamais jouable
					flight[f].playable = false
				end

				if flight[f].playable == true then										--if flight is playable by player
```

### 2.3 Nettoyage des vols IA des squads humainOnly

Placer la fonction et l'appel juste avant le dernier bloc `if Debug.debug then` du fichier.

```lua
-- ====================================================================================================
-- Squads "humainOnly" : une fois les joueurs affectes, on supprime de l'ATO les vols IA de ces squads
-- (ni player, ni client). Sans cela, le joueur qui choisit une mission de ce squad voit les autres vols
-- du squad voler en IA, ce qui n'est pas le but de humainOnly.
-- Mettre HUMAIN_ONLY_PRUNE = false pour desactiver ce nettoyage (retour au comportement precedent).
-- ====================================================================================================
local HUMAIN_ONLY_PRUNE = true

local function PruneHumainOnlyAI()
	if not HUMAIN_ONLY_PRUNE then return end

	-- squads concernes (un squad interdit aux humains est traite comme IA : jamais nettoye)
	local humainOnlySquad = {}
	local nbSquad = 0
	for _, squads in pairs(oob_air) do
		for _, sq in pairs(squads) do
			if sq.humainOnly and not (IsHumainProhibited and IsHumainProhibited(sq)) then
				humainOnlySquad[sq.name] = true
				nbSquad = nbSquad + 1
			end
		end
	end
	if nbSquad == 0 then return end

	local remap = {}				-- remap[side][ancien index de package] = nouvel index (nil si package supprime)
	local anyDropped = false
	local nbRemoved = 0

	for side, packs in pairs(ATO) do
		local nOld = #packs

		-- packages references par un vol d'un AUTRE package (target_pack/target_side) : on ne les vide pas
		local referenced = {}
		for s2, packs2 in pairs(ATO) do
			for p2 = 1, #packs2 do
				for _, flights2 in pairs(packs2[p2]) do
					if type(flights2) == "table" then
						for f2 = 1, #flights2 do
							local fl2 = flights2[f2]
							if fl2.target_pack and fl2.target_side == side and not (s2 == side and p2 == fl2.target_pack) then
								referenced[fl2.target_pack] = true
							end
						end
					end
				end
			end
		end

		local kept = {}
		remap[side] = {}

		for p = 1, nOld do
			local pack = packs[p]

			-- un package qui contient un humain, ou qui est reference, garde au moins un vol main
			local protected = referenced[p] == true
			for _, flights in pairs(pack) do
				if type(flights) == "table" then
					for f = 1, #flights do
						if flights[f].player or flights[f].client then protected = true end
					end
				end
			end

			local removedHere = 0
			for role, flights in pairs(pack) do
				if type(flights) == "table" then
					for f = #flights, 1, -1 do
						local fl = flights[f]
						-- package protege : on garde au moins un vol main (sinon ATO_Timing / DC_Briefing plantent)
						if role == "main" and protected and #flights <= 1 then break end
						if fl.name and humainOnlySquad[fl.name] and not fl.player and not fl.client then
							table.remove(flights, f)
							removedHere = removedHere + 1
						end
					end
				end
			end
			nbRemoved = nbRemoved + removedHere

			if removedHere > 0 then
				if not protected and (not pack.main or #pack.main == 0) then
					-- plus de vol main : package supprime en entier (ATO_Timing / DC_Briefing lisent main[1])
					anyDropped = true
					AddLog("PruneHumainOnlyAI: package "..side.." #"..p.." removed (main flight was humainOnly AI)")
				else
					-- roles vides (SEAD, escort...) : on retire la cle
					for role, flights in pairs(pack) do
						if type(flights) == "table" and #flights == 0 and role ~= "main" then
							pack[role] = nil
						end
					end
					table.insert(kept, pack)
					remap[side][p] = #kept
				end
			else
				table.insert(kept, pack)
				remap[side][p] = #kept
			end
		end

		-- reecriture de ATO[side] avec les packages restants
		if #kept ~= nOld then
			for p = 1, nOld do packs[p] = nil end
			for i = 1, #kept do packs[i] = kept[i] end
		end
	end

	if nbRemoved == 0 then return end
	AddLog("PruneHumainOnlyAI: "..nbRemoved.." AI flight(s) removed from humainOnly squads")

	if not anyDropped then return end

	-- ---- renumerotation des references a un index de package ----
	for side, packs in pairs(ATO) do
		for p = 1, #packs do
			for _, flights in pairs(packs[p]) do
				if type(flights) == "table" then
					for f = 1, #flights do
						local fl = flights[f]
						if fl.target_pack and fl.target_side and remap[fl.target_side] then
							fl.target_pack = remap[fl.target_side][fl.target_pack] or fl.target_pack
						end
						if fl.init_packN and remap[side] then
							fl.init_packN = remap[side][fl.init_packN] or fl.init_packN
						end
					end
				end
			end
		end
	end

	if camp.player and camp.player.side and remap[camp.player.side] then
		camp.player.pack_n = remap[camp.player.side][camp.player.pack_n] or camp.player.pack_n
	end

	if camp.client then
		for _, cl in ipairs(camp.client) do
			if cl.side and remap[cl.side] then
				cl.pack_n = remap[cl.side][cl.pack_n] or cl.pack_n
			end
		end
	end

	-- HumainPack et camp.MultiPlayer.pack_n sont indexes par numero de package (camp humain : cote du joueur)
	local humainSide = camp.player and camp.player.side
	if humainSide and remap[humainSide] then
		local newHP, newMP = {}, {}
		for p, v in pairs(HumainPack) do
			local np = remap[humainSide][p]
			if np then newHP[np] = v end
		end
		for p, v in pairs(camp.MultiPlayer.pack_n) do
			local np = remap[humainSide][p]
			if np then newMP[np] = v end
		end
		HumainPack = newHP
		camp.MultiPlayer.pack_n = newMP
	end
end

-- Appel, juste apres la fonction ci-dessus (et avant le "if Debug.debug then" final) :
if not TaskRefused then
	PruneHumainOnlyAI()
end
```

---

## 3. Menus : une ligne chacune

**BAT_FirstMission.lua, BAT_SkipMission.lua, DEBRIEF_Master.lua** (ancres exactes, a verifier dans chaque fichier) :

1. Juste **avant** `local n_player = 0` ajouter :
```lua
ApplyHumainProhibit()		--humainProhibit_IAOnly : retire player/client des squads interdits aux humains
```
2. Remplacer
`if Playable_m[unit.type] and unit.inactive ~= true and not stopLoop then`
par
`if Playable_m[unit.type] and unit.inactive ~= true and not stopLoop and not IsHumainProhibited(unit) then`
3. Remplacer
`if Playable_m[unit.type] and unit.inactive ~= true then`
par
`if Playable_m[unit.type] and unit.inactive ~= true and not IsHumainProhibited(unit) then`

(ne remplacer que les lignes qui construisent `playable_type` / `tabTaskAvailable` ; si une des deux ancres n'existe pas dans un fichier, c'est normal.)

---

## 4. UTIL_ChangePlane.lua (corps complet, apres votre en-tete)

```lua
--gives the player the possibility to change planes during the campaign.
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
-- local function cmp(a, b)
--    a = tostring(a.name)
--    b = tostring(b.name)
--    local patt = '^(.-)%s*(%d+)$'
--    local _,_, col1, num1 = a:find(patt)
--    local _,_, col2, num2 = b:find(patt)
--    if (col1 and col2) and col1 == col2 then
--       return tonumber(num1) < tonumber(num2)
--    end
--    return a < b
-- end

local playerPlane, playerSquad, playerCountry, playerSide

--affiche le type d'avion selectionne et son squadron
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

--humainProhibit_IAOnly : le squad du joueur vient d'etre retire (ApplyHumainProhibit), il n'y a donc
--plus de squad player. On repart du camp et du nom de l'ancien squad pour que le changement fonctionne.
if not playerSide and HumainProhibitLast then
	playerSide = HumainProhibitLast.side
	playerSquad = HumainProhibitLast.squad
end

--aucun squad player (cas anormal) : on propose le premier camp
if not playerSide then
	for side, _ in PairsByKeys(oob_air) do
		playerSide = side
		break
	end
end

--TIPS sort (attention suite a un tri, la boucle doit etre fait avec ipairs)
local oobAirSide = oob_air[playerSide]
table.sort(oobAirSide, function(a, b) return a.type:upper() < b.type:upper() end)

local nType = 1
local tabSquad = {}

for unitN , unit in ipairs(oobAirSide) do
	--un squad humainProhibit_IAOnly n'est jamais propose : on le considere comme un squad IA
	if Playable_m[unit.type] and not IsHumainProhibited(unit) then	--and unit.inactive ~= true  
		table.insert(tabSquad,nType, unit.name)

		local inactive = ""
		if unit.inactive then
			inactive = " (inactive)"
		end

		io.write("\n"..nType .." | "..unit.type .." | "..unit.name.." | "..unit.country .." | "..inactive)

		nType = nType + 1
	end
end

io.write( "\n")

if nType == 1 then
	print("\nNo squadron can be selected by a human on this side (all are humainProhibit_IAOnly or not playable).\n")
	do return end
end

--===================================================================================
-- Ecran N1 Selection Nombre d'avion Multiplayer
repeat
	local input = tonumber(io.stdin:read())

	if  tabSquad[input] then
		oldSquadName = playerSquad or ""
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
		for side, squadTL in pairs(oob_air) do
			for squad_n, squad in pairs(squadTL) do
				if squad.name == newSquadName then
					squad.player = true
					squad.inactive = false
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
			if (trig.action[n] == 'Action.CampaignEnd("win")' or  trig.action[n] == 'Action.CampaignEnd("loss")')
				and oldSquadName ~= "" then										--pas d'ancien squad connu : rien a remplacer dans les triggers

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
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/BAT_SkipMission.lua")
	IncludeOnce("BAT_SkipMission.lua")
elseif Firstmission_flag then
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/BAT_FirstMission.lua")
	IncludeOnce("BAT_FirstMission.lua")
end


-- local test_str = "oob_air = " .. TableSerialization(oob_air, 0)						--make a string
-- local testFile = io.open("Debug/oob_airChangePlane.lua", "w")								--open targetlist file
-- testFile:write(test_str)							--save new data
-- testFile:close()
```

## 5. UTIL_ChangePlane_DceM.lua (fichier complet)

```lua
---@diagnostic disable: undefined-global, need-check-nil, lowercase-global
--gives the player the possibility to change planes during the campaign.
------------------------------------------------------------------------------------------------------- 
-- last modification: cleanCode_b
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_ChangePlane_DceM.lua"] = "1.3.8"
-------------------------------------------------------------------------------------------------------
-- adjustment_c				(b Playable_m from Data_divers)
-- cleanCode_b				(b springCleaning)
-- modification M55_c		player can change the type of plane (c:triggers part)(b:same Side)
-------------------------------------------------------------------------------------------------------


--====================================================================================================
--====================================================================================================
-- partie Plane
--change le type d'avion dans le fichier/table oob_air
--====================================================================================================
--====================================================================================================

dofile(pathScriptsMod.."/UTIL_Data.lua")
dofile(pathCampaign.."/Init/oob_air_init.lua")



--function to turn a table into a string
local function TableSerialization(t, i)
	
	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do															--controls the indent for the current text line
		tab = tab .. "\t"
	end
	for k,v in pairs(t) do
		if type(k) == "string" then
			text = text .. tab .. "['" .. k .. "'] = "
		else
			text = text .. tab .. "[" .. k .. "] = "
		end
		if type(v) == "string" then
			text = text .. "'" .. v .. "',\n"
		elseif type(v) == "number" then
			text = text .. v .. ",\n"
		elseif type(v) == "table" then
			text = text .. TableSerialization(v, i + 1)
		elseif type(v) == "boolean" then
			if v == true then
				text = text .. "true,\n"
			else
				text = text .. "false,\n"
			end
		elseif type(v) == "function" then
			text = text .. v .. ",\n"
		elseif v == nil then
			text = text .. "nil,\n"
		end
	end
	tab = ""
	for n = 1, i do																--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"												--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"											--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end


local oldSquadName = ""
local newSquadName = ""


--affiche le type d'avion selectionne et son squadrons
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

--humainProhibit_IAOnly : si le squad player de l'Init est lui-meme interdit aux humains, ou s'il n'y a
--aucun squad player, on retombe sur le premier camp pour que la liste puisse etre construite.
if not playerSide or not oob_air[playerSide] then
	for side, _ in pairs(oob_air) do
		playerSide = side
		break
	end
end

-- oobAirSide = oob_air[playerSide]
-- table.sort(oobAirSide, cmp)

--TIPS sort (attention suite a un tri, la boucle doit etre fait avec ipairs)
oobAirSide = oob_air[playerSide]
table.sort(oobAirSide, function(a, b) return a.type:upper() < b.type:upper() end)

-- Playable_m = {}
-- for planeType, value in pairs(frequency) do	
-- 	Playable_m[planeType] = true
-- end	

Playable_m = {}
for planeType, plane in pairs(Data_divers) do
	if plane.playable then
		Playable_m[planeType] = true
	end
end


local nType = 1
local TabSquad = {}

for m , unit in ipairs(oobAirSide) do
	--un squad humainProhibit_IAOnly n'est jamais propose a l'humain (considere comme un squad IA)
	if Playable_m[unit.type] and unit["humainProhibit_IAOnly"] ~= true then

		table.insert(TabSquad,nType, unit.type.." | "..unit.name.." | "..unit.base)

		nType = nType + 1
	end
end

local test_str = "TabSquad = " .. TableSerialization(TabSquad, 0)						--make a string
local testFile = io.open(pathCampaign.."/Debug/TabSquad.lua", "w")								--open targetlist file
testFile:write(test_str)															--save new data
testFile:close()

return TabSquad
```

---

## 6. Points de test

1. Squad A `humainProhibit_IAOnly` + `player = true` : au lancement, `player` retire, log AddLog, [C] ne propose pas A, A genere des vols IA.
2. Multi : squad A absent des listes ; un client ne peut pas etre affecte a A (`SetUnitClient` renvoie false).
3. humainOnly Solo : joueur dans un autre squad -> aucun vol du squad humainOnly. Joueur dans le squad humainOnly -> seul le vol choisi reste dans l'ATO.
4. humainOnly Multi : seuls les vols choisis par les clients restent.
5. Nettoyage : package supprime quand son main etait IA humainOnly ; verifier Intercept/CAP qui referencent un package (`target_pack`), `camp.player.pack_n`, `HumainPack`, `camp.MultiPlayer.pack_n` apres renumerotation. Les packages contenant un humain ou references par un autre package gardent au moins un vol main.
6. Les avions reserves (`camp.Aircraft_availability`) des vols supprimes ne sont **pas** liberes par le nettoyage : a surveiller si les stocks baissent a tort. Dire si on doit le faire.
7. Debug : `HUMAIN_ONLY_PRUNE = false` desactive le nettoyage sans toucher au reste.

---

## 7. Prompt pour le clone DCE_Manager (C#)

> Contexte : cote Lua (DCE scriptsMod), un nouveau drapeau de squad `["humainProhibit_IAOnly"] = true` existe dans `Init/oob_air_init.lua` (et se propage dans `Active/oob_air.lua`). Un tel squad est **interdit aux humains** : il ne doit jamais etre propose ni selectionnable, nulle part (choix du squad solo, liste Multi, selection d'un vol), et est traite comme un squad IA normal. A l'inverse, `["humainOnly"] = true` (squad reserve a un humain) est inchange.
>
> Ta mission, en verifiant toi-meme dans le code du clone (ne presume rien, cherche) :
> 1. Retrouve tous les endroits ou DCE_Manager lit `oob_air` / les squads : parseur Lua ou modele de donnees (classe Squad), ecran de choix de squad / avion (solo, [C] changement d'avion), ecran Multi (groupes, nombre d'avions, type), liste des vols jouables envoyes par le protocole `##DCEM_...##`, et tout filtre existant sur `inactive`, `player`, `client`, `humainOnly`.
> 2. Ajoute la lecture du champ `humainProhibit_IAOnly` (booleen, absent = false) dans le modele, y compris a l'ecriture : le champ doit etre **conserve** quand oob_air_init / oob_air sont reserialises (ne pas le perdre ni le renommer).
> 3. Filtre ces squads de **toute** liste proposee a l'utilisateur (types d'avion, squads, vols). Aucun message : ils n'apparaissent simplement pas. Si l'utilisateur n'a plus aucun squad selectionnable sur un camp, affiche un message clair.
> 4. Ne modifie pas le protocole `##DCEM_...##` existant (formats de lignes inchanges). Le cote Lua filtre deja ; cote C# le filtrage evite seulement d'afficher un choix refuse.
> 5. Si le squad actuellement marque joueur porte le drapeau, ne bloque pas : Lua le repasse a `player = false` ; l'UI doit simplement reflechir l'etat relu.
> 6. A la fin, liste les fichiers/methodes modifies, les endroits que tu as juges non concernes et pourquoi, et propose 2 cas de test manuels (solo, multi).
