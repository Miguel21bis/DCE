--Various functions
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Functions.lua"] = "2.20.140"
------------------------------------------------------------------------------------------------------- 

-- Include("FUNC/FUNC_Core.lua")
Include("FUNC/FUNC_Table.lua")
Include("FUNC/FUNC_File.lua")
Include("FUNC/FUNC_Time.lua")
Include("FUNC/FUNC_Geometry.lua")
Include("FUNC/FUNC_Coordinates.lua")
Include("FUNC/FUNC_Radio.lua")
Include("FUNC/FUNC_Loadout.lua")
Include("FUNC/FUNC_Ids.lua")
-- Include("FUNC/FUNC_Config.lua")
-- Include("FUNC/FUNC_Campaign.lua")
-- Include("FUNC/FUNC_Target.lua")

if Debug.debug then
	print("START UTIL_Functions.lua "..versionDCE["UTIL_Functions.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end


T_GetTD  = 0
T_GetD = 0

--local variable

--variable camp global
if not camp.AuthorizedLoadout then
	camp.AuthorizedLoadout = {}
end

--variable global
NameTheatreLower = ""
NameTheatre  = ""

Assigned_freq = {}
MinPercentDestroyed = 95		----variable pour destructions batiment de DCS en pourcentage
RayonDamaged = 50				----variable pour destructions batiment de DCS en metres
RosterJumpTempPercent = 0.25			-- suite à un saut temporel, enleve une partie des presents pour éviter un effectif neuf comme un démarrage de DCE
WingmenPlayer = false			-- si true, les wingmen playable sont proposé aux joueurs
LoadoutsList = {}				-- construit la table loadout en fonction du loadout général et de la campagne
EPLRS_Capacity = {}
CurrentPlayerAircraftType = nil
AircraftInCampaign = {}				-- liste de tous les types d'avions utilisés dans la campagne
AircraftCampaignBySide = {
	["red"] = {},
	["blue"] = {},
}
HelicoBySide= {
	["red"] = {},
	["blue"] = {},
}
PlaneBySide= {
	["red"] = {},
	["blue"] = {},
}


Brief = {
	red = {},
	blue = {},
}

-- par défaut, on assigne une valeur superieur au camp du joueur, qu'il soit rouge ou bleu.
SkillWish = {
	["red"] = 50,
	["blue"] = 50,
}

DCS_Side = {"blue", "red", "neutrals"}

DCS_ENI_Side = {
	["blue"] = "red",
	["red"] = "blue"
	}

Attribut2Target = {
	["airbase"] = "airbase",
	["base"] = "airbase",
	["Runway"] = "runway",
	["sam"] = "sam",
	["ewr"] = "ewr",
	["bridge"] = "bridge",
}

if not _ then
	function _(text)
		return text
	end
end


--****************************************** ****************************************** ******************************************
--****************************************** ****************************************** ******************************************
--****************************************** ****************************************** ******************************************
-- Pour chaque variable logique, les chemins possibles, du plus récent
-- (schéma cible) au plus ancien (legacy), dans l'ordre où ils sont essayés.
WEATHER_PATHS = {
	trend        = { "campMod.weather.trend",       "mission_ini.weather.trend" },
	variance     = { "campMod.weather.variance",     "mission_ini.weather.variance" },
	refTemp      = { "campMod.weather.refTemp",      "mission_ini.weather.refTemp", "camp.weather.refTemp" },
	instability  = { "campMod.weather.instability",  "mission_ini.weather.instability" },
	windActivity = { "campMod.weather.windActivity", "mission_ini.weather.windActivity" },
	winDirection = { "campMod.weather.winDirection", "mission_ini.weather.winDirection" },
	weather_playerBias = { "mission_ini.weather_playerBias" },
}

PICTURE_BRIEF_PATHS = {
	pictureBrief        = { "camp.pictureBrief",       "pictureBrief" },
}




--****************************************** ****************************************** ******************************************
--****************************************** ****************************************** ******************************************
--****************************************** ****************************************** ******************************************




--function to return subsequent IDs
-- Gestion propre des IDs pour groupes et unités





--function to format altitude in metric or imperial measurement
function FormatDistance(a, unitsUse)
	a = a / 1000																			--round to km
	if unitsUse == "metric" or unitsUse =="russian" then															--metric units
		return math.floor(a) .. " km"															--kilometers
	else 													--imperial units
		a = a * 0.539957																	--covert to nm
		return math.floor(a) .. " nm"															--nautical miles
	end
end


--function to format altitude in metric or imperial measurement
function FormatAlt(a, unitsUse)
	if unitsUse == "metric" or unitsUse =="russian" then															--metric units
		a = math.ceil(a / 10) * 10															--round to tens
		if a <= 1000 then																	--for altitudes until 1000m
			a = a .. " m AGL"																--meters AGL
		else
			a = a .. " m MSL"																--meters MSL
		end
	else													--imperial units
		a = a * 3.28																		--covert to feet
		a = math.ceil(a / 100) * 100														--round to hunderts
		if a <= 3300 then																	--for altitudes until 3300ft
			a = a .. " ft AGL"																--feet AGL
		else
			a = a .. " ft MSL"																--feet MSL
		end
	end
	return a
end


--function to format speed in metric or imperial measurement
function FormatSpeed(a, unitsUse)
	if  unitsUse == "metric" or unitsUse =="russian" then															--metric units
		a = a * 3.6
		a = math.floor(a / 10) * 10															--round to tens
		a = a .. " kph"																		--km per hour
	else												--imperial units
		a = a * 1.94																		--covert to knots
		a = math.floor(a / 5) * 5															--round to fives
		a = a .. " kts"																		--knots
	end
	return a
end


--function to replace certain type names
function AliasTypeName(s)
	if TypeAlias and TypeAlias[s] then
		return TypeAlias[s]
	else
		return s
	end
end

--function to replace certain type names Init\various_table.lua
function AliasBaseName(s)
	if BaseNameAlias and BaseNameAlias[s] then
		return BaseNameAlias[s]
	else
		return s
	end
end

-- Fonction récursive pour afficher une table en évitant les erreurs
function Display(t, indent)
    indent = indent or ""

    if type(t) ~= "table" then
        print(indent .. tostring(t)) -- Affiche directement la valeur si ce n'est pas une table
        return
    end

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(indent .. tostring(key) .. ":")
            Display(value, indent .. "  ")
        else
            print(indent .. tostring(key) .. ": " .. tostring(value))
        end
    end
end



function _affiche(t, indent)
    indent = indent or ""

    if type(t) ~= "table" then
        print(indent .. tostring(t)) -- Affiche directement la valeur si ce n'est pas une table
        return
    end

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(indent .. tostring(key) .. ":")
            Display(value, indent .. "  ")
        else
            print(indent .. tostring(key) .. ": " .. tostring(value))
        end
    end
end


function _afficheTXT(_table, titre, prof)

	--export custom mission log
	local logExp = "logExp  "

	if not prof or prof == nil then prof = 999 end 						-- prof = profondeur de niveau dans la hierarchie
	logExp = logExp.."\n"

    if titre == nil then logExp = logExp.. string.format(" _affiche() titre = nil ")
    elseif type( titre) == "string" then
		logExp = logExp.. string.format(" _affiche(titre) "..tostring(titre)).."\n"
	end

	if type( _table) == "table"  then --and  (table.getn(_table) ~= 0 or table.getn(_table) ~= nil

		for a, b in pairs(_table) do --for a, b in pairs(event.initiator) do --for a, b in pairs(_ammo) do

			if  type(b) ~= "table" then
				logExp = logExp.." _affiche (a b)     "..tostring(a).." "..tostring(b).."\n"
			elseif type(b) == "table"   and prof >= 2 then
				for c, d in pairs(b) do
					logExp = logExp.. " _affiche(a c)           "..tostring(a).." "..tostring(c).."\n"


					if type(d)~= "table"  then
						logExp = logExp.. " _affiche(d)                "..tostring(d).."\n"
					elseif type(d) == "table"  and prof >= 3 then
						for e, f in pairs(d) do

							if type( f ) ~= "table"  then
								logExp = logExp.. " _affiche(e f)                          "..tostring(e).." "..tostring(f).."\n"
							elseif type( f ) == "table"  and prof >= 4 then
								logExp = logExp.. " _affiche( e)                                "..tostring(e).."\n"
								for g, h in pairs(f) do
									logExp = logExp.. " _affiche(Ig)                                 "..tostring(g).."\n"


									if type( h ) ~= "table"  then
										logExp = logExp.. " _affiche(g h)                                    "..tostring(g).." "..tostring(h).."\n"
									elseif type( h ) == "table"  and prof >= 5 then
										logExp = logExp.. " _affiche( g)                                         "..tostring(g).."\n"
										for i, j in pairs(h) do

											if type( j ) ~= "table"  then
												logExp = logExp.. " _affiche(i j)                                              "..tostring(i).." "..tostring(j).."\n"
											elseif type( j ) == "table" and prof >= 6 then
												logExp = logExp.. " _affiche(i)                                                  "..tostring(i).."\n"
												for k, l in pairs(j) do

													if type( l ) ~= "table"  then
														logExp = logExp.. " _affiche(k l)                                                   "..tostring(k).." "..tostring(l).."\n"
													elseif type( l ) == "table" and prof >= 7 then
														logExp = logExp.. " _affiche(k)                                                       "..tostring(k).."\n"
														for m, n in pairs(l) do
															logExp = logExp.. " _affiche(m)                                                        "..tostring(m).."\n"


															if type( n ) ~= "table"  then
																logExp = logExp.. " _affiche(m n)                                                   "..tostring(m).." "..tostring(n).."\n"
															elseif type( n ) == "table" and prof >= 7 then
																logExp = logExp.. " _affiche(m)                                                       "..tostring(m).."\n"
																for o, p in pairs(n) do
																	logExp = logExp.. " _affiche(o)                                                        "..tostring(o).."\n"


																	if type( p ) ~= "table"  then
																		logExp = logExp.. " _affiche(p)                                                             "..tostring(p).."\n"
																	elseif type( p ) == "table"  and prof >= 8 then
																		logExp = logExp.. " p est une table                                                              "..tostring(p).."---------------------------".."\n"

																	end
																end
															end --if
														end --for l
													end --if
												end -- for j
											end --if
										end -- for h
									end --if
								end --for f
							end --elseif
						end -- for d
					end -- if d
				end -- for v
			end -- if v
		end  -- for _table

	else logExp = logExp.. "_affiche NoTable==> " ..tostring(_table).."\n"

	end -- if if type( _table) == "table"

	return logExp

end -- function affiche



-- Charge les mods d'un dossier, exécute chaque fichier dans un env isolé
-- relativeFolder = "../../../Missions/Campaigns/"..camp.title.."/Mods" par exemple
-- ACCEPT_NEW_TABLES = true --toutes les tables créées par le mod seront ajoutées à _G
-- function LoadModData(relativeFolder, ACCEPT_NEW_TABLES)
--     ACCEPT_NEW_TABLES = not not ACCEPT_NEW_TABLES    -- bool
--     local fullFolder = "../../../Missions/Campaigns/"..camp.title.."/"..relativeFolder
--     -- print("DCE : Scanning Mods folder : " .. tostring(fullFolder))

--     local cmd = 'dir "' .. fullFolder .. '" /b'
--     local p = io.popen(cmd)
--     if not p then
--         -- print("DCE ERROR : impossible de lire le dossier Mods : " .. fullFolder)
--         return
--     end

--     for file in p:lines() do
--         if file:match("%.lua$") then
--             local fullpath = fullFolder .. "/" .. file
--             -- print("DCE : Chargement MOD -> " .. fullpath)

--             -- load the chunk (file) without executing it globally
--             local chunk, loadErr = loadfile(fullpath)
--             if not chunk then
--                 -- print("DCE ERROR : loadfile failed for " .. fullpath .. " : " .. tostring(loadErr))
--             else
--                 -- create an isolated env that falls back to _G for reads (so mod can call DCE functions)
--                 local env = {}
--                 setmetatable(env, { __index = _G })

--                 -- set this env as the chunk's environment (Lua 5.1)
--                 setfenv(chunk, env)

--                 -- execute the chunk safely
--                 local ok, execErr = pcall(chunk)
--                 if not ok then
--                     -- print("DCE ERROR : execution failed for " .. fullpath .. " : " .. tostring(execErr))
--                 else
--                     -- enumerate what the mod defined in env
--                     for k, v in pairs(env) do
--                         -- skip metamethods and inherited keys (if index produced inherited, pairs won't show them)
--                         if type(k) == "string" then
--                             -- only consider tables defined by the mod (ignore functions, numbers...)
--                             if type(v) == "table" then
--                                 -- print("DCE : Table détectée dans MOD '" .. file .. "' : " .. tostring(k))

--                                 -- si DCE (global) a déjà une table du même nom -> merge dedans
--                                 if type(_G[k]) == "table" then
--                                     -- print("DCE : Fusion dans DCE -> " .. tostring(k))
--                                     MergeTablesDeep(_G[k], v)
--                                 else
--                                     -- table nouvelle, décider selon ACCEPT_NEW_TABLES
--                                     if ACCEPT_NEW_TABLES then
--                                         -- print("DCE : Ajout d'une nouvelle table globale -> " .. tostring(k))
--                                         _G[k] = v
--                                     else
--                                         -- print("DCE : Table nouvelle ignorée (pour l'instant) -> " .. tostring(k))
--                                     end
--                                 end
--                             else
--                                 -- si le mod définit des scalaires ou fonctions globaux qu'on souhaite conserver ou logger
--                                 -- par défaut on ignore pour éviter de polluer _G
--                                 -- Si tu veux autoriser certaines clés non-table, tu peux les whitelist ici.
--                             end
--                         end
--                     end
--                 end
--             end
--         end
--     end

--     p:close()
-- end

-- Charge les mods d'un dossier, exécute chaque fichier dans un env isolé
-- relativeFolder = "../../../Missions/Campaigns/"..camp.title.."/Mods" par exemple
-- ACCEPT_NEW_TABLES = true --toutes les tables créées par le mod seront ajoutées à _G
function LoadModData(relativeFolder, ACCEPT_NEW_TABLES)


    ACCEPT_NEW_TABLES = not not ACCEPT_NEW_TABLES    -- bool
    local fullFolder = "../../../Missions/Campaigns/"..camp.title.."/"..relativeFolder
    -- print("DCE : Scanning Mods folder : " .. tostring(fullFolder))

    -- CORRECTIF : "2>nul" ajouté. Sans ça, si le dossier Mods n'existe pas,
    -- cmd.exe écrit "Fichier introuvable" sur stderr, non capturé par
    -- io.popen (qui ne lit que stdout) : le message fuit tel quel dans la
    -- console/log au lieu d'être silencieusement ignoré.
    local cmd = 'dir "' .. fullFolder .. '" /b 2>nul'
    local p = io.popen(cmd)
    if not p then
        -- print("DCE ERROR : impossible de lire le dossier Mods : " .. fullFolder)
        return
    end

    for file in p:lines() do
        if file:match("%.lua$") then
            local fullpath = fullFolder .. "/" .. file
            -- print("DCE : Chargement MOD -> " .. fullpath)

            -- load the chunk (file) without executing it globally
            local chunk, loadErr = loadfile(fullpath)
            if not chunk then
                -- print("DCE ERROR : loadfile failed for " .. fullpath .. " : " .. tostring(loadErr))
            else
                -- create an isolated env that falls back to _G for reads (so mod can call DCE functions)
                local env = {}
                setmetatable(env, { __index = _G })

                -- set this env as the chunk's environment (Lua 5.1)
                setfenv(chunk, env)

                -- execute the chunk safely
                local ok, execErr = pcall(chunk)
                if not ok then
                    -- print("DCE ERROR : execution failed for " .. fullpath .. " : " .. tostring(execErr))
                else
                    -- enumerate what the mod defined in env
                    for k, v in pairs(env) do
                        -- skip metamethods and inherited keys (if index produced inherited, pairs won't show them)
                        if type(k) == "string" then
                            -- only consider tables defined by the mod (ignore functions, numbers...)
                            if type(v) == "table" then
                                -- print("DCE : Table détectée dans MOD '" .. file .. "' : " .. tostring(k))

                                -- si DCE (global) a déjà une table du même nom -> merge dedans
                                if type(_G[k]) == "table" then
                                    -- print("DCE : Fusion dans DCE -> " .. tostring(k))
                                    mergeTablesDeep(_G[k], v)
                                else
                                    -- table nouvelle, décider selon ACCEPT_NEW_TABLES
                                    if ACCEPT_NEW_TABLES then
                                        -- print("DCE : Ajout d'une nouvelle table globale -> " .. tostring(k))
                                        _G[k] = v
                                    else
                                        -- print("DCE : Table nouvelle ignorée (pour l'instant) -> " .. tostring(k))
                                    end
                                end
                            else
                                -- si le mod définit des scalaires ou fonctions globaux qu'on souhaite conserver ou logger
                                -- par défaut on ignore pour éviter de polluer _G
                                -- Si tu veux autoriser certaines clés non-table, tu peux les whitelist ici.
                            end
                        end
                    end
                end
            end
        end
    end

    p:close()
end

-- modification M54		revoir CustomTaskScript et TaskBombing
-- check si tous les avions pr�vu dans oob_air ont leur task d�clar� possible dans la table TaskByPlane
local error = 0
local debugTempFLIGHT
function Check_TaskPossibleByPlane()

	-- StrikeCombi = {
		-- ["CAS"] = false,
		-- ["Ground Attack"] = false,
		-- -- ["Runway Attack"] = false,
		-- ["Pinpoint Strike"] = true,
	-- }


	local checkOobAir = DeepCopy(oob_air)
	for side, squadTbl in pairs(checkOobAir) do
		for squad_n, squad in pairs(squadTbl) do

			local foundPlane = false

			if squad.tasks and type(squad.tasks) == "table" and not squad.inactive then

				-- StrikeCombi
				local addMultipleStrike = false
				for taskOA, valueOA in pairs(squad.tasks) do
					if taskOA == "Strike" and valueOA == true  then
						addMultipleStrike = true
					end
				end

				--ajoute les vrais id des differents Strike
				if addMultipleStrike then
					squad.tasks["Strike"] = nil
					squad.tasks["CAS"] = true
					squad.tasks["Ground Attack"] = true
					squad.tasks["Pinpoint Strike"] = true
					-- squad.tasks["Runway Attack"] = true				
				end

				local foundStrikeTask = false
				for taskOA, valueOA in pairs(squad.tasks) do

					local foundTask = false

					-- print("UtilF passe A "..taskOA.." valueOA: "..tostring(valueOA))

					if taskOA == "Escort Jammer" then
						taskOA = "Ground Attack"
					elseif taskOA == "Flare Illumination" then
						taskOA = "Ground Attack"
					elseif taskOA == "Laser Illumination" then
						taskOA = "AFAC"
					elseif taskOA == "Anti-ship Strike" then
						taskOA = "Antiship Strike"
					elseif taskOA == "SAR" or taskOA == "CSAR" then
						taskOA = "Transport"
					end

					if type(valueOA) ~= "boolean" then
						debugTempFLIGHT = "UtilF ATTENTION is not a boolean value for : "..tostring(squad.type).." "..tostring(taskOA)
						error = error + 1
					end

					if valueOA == true and TaskByPlane[taskOA] then
						for plane_TbP, value in pairs(TaskByPlane[taskOA]) do
							if squad.type == plane_TbP then
								foundPlane = true
								foundTask = true
								if taskOA == "CAS" or taskOA == "Ground Attack" or taskOA == "Pinpoint Strike"  then
									foundStrikeTask = true
								end
							end
						end

						--toutes les tasks sauf strike
						if not foundTask and not addMultipleStrike and not tostring(taskOA) == "Fighter Sweep" then
							debugTempFLIGHT = "(Error UutilF C01) this task, requested in Init\\oob_air_init.lua, is not listed in the UTIL_Data.lua file : "..tostring(squad.type).." "..tostring(taskOA)
							error = error + 1
							AddLog(debugTempFLIGHT)
						end

					elseif valueOA == true and not TaskByPlane[taskOA] and not tostring(taskOA) == "Fighter Sweep" then
						debugTempFLIGHT = "(Error UutilF C02) this task, requested in Init\\oob_air_init.lua, is not listed in the UTIL_Data.lua file : "..tostring(squad.type).." "..tostring(taskOA)
						error = error + 1
					end
				end

				--si aucune tasks strike n'a été trouvée
				if not foundStrikeTask and addMultipleStrike then
					debugTempFLIGHT = "(Error UutilF C03) this task, requested in Init\\oob_air_init.lua, is not listed in the UTIL_Data.lua file : "..tostring(squad.type).." "..tostring("Strike ( CAS or Ground Attack or Pinpoint Strike )")
					print(debugTempFLIGHT )
					AddLog(debugTempFLIGHT)
					error = error + 1
					-- os.execute 'pause'
				end
				if not squad.inactive and not foundPlane then
					--TODO revoir ce pb, exemple avec campaign Hornet Over Carrier SC
					debugTempFLIGHT = "(Error UutilF C04)||"..tostring(squad.type).."||"..tostring(squad.name).."||  impossible to find a task/aircraft match with all files concerned ".." (oob_air_init or  UTIL_Data.lua or bad Task or bad boolean task)"
					AddLog(debugTempFLIGHT)

					for taskOA, valueOA in pairs(squad.tasks) do
						debugTempFLIGHT = tostring(taskOA).." : "..tostring(valueOA)
						AddLog(debugTempFLIGHT)
					end
					error = error + 1
				end
			end
		end
	end
end

if error >= 1 then

	if BugList and type(BugList) == "table" and #BugList >= 1 then
		local table_Str = "BugList = " .. TableSerialization(BugList, 0)
		local bugFile = io.open("Debug/BugList.lua", "w") or error("Failed to open debug file")
		bugFile:write(table_Str)
		bugFile:close()
	end

	os.execute('start "BugList" "notepad.exe" "Debug/BugList.lua"')			--open the BugList file with notepad

	os.execute 'pause'
end

ParkOccupied = {}
function GetParkingId(parkingId, baseName)
	local s
	local counter = 0
	if not ParkOccupied[baseName]  then
		ParkOccupied[baseName] = {}
	end

	-- parking_id = {
	-- 	[""] = {25,26},                   --["C"] = {2,10},
	-- },	

	for prefix, value in pairs(parkingId) do
		local valueCopy = DeepCopy(value)
		counter = 0
		local single = false
		local singleTest = string.lower(tostring(valueCopy[1]))

		--signifie que l'on prend uniquement les chiffres proposé, on ne prend pas la plage entre 2 chiffres
		if singleTest == "single" then
			single = true
			table.remove(valueCopy, 1)
		end

		if #valueCopy == 2 and not single then
			local lower = tonumber(valueCopy[1])
			local upper = tonumber(valueCopy[2])

			-- Validation explicite que lower et upper sont des entiers
			if lower and upper then
				repeat
					counter = counter + 1
					local randomValue = math.random(math.floor(lower), math.floor(upper)) -- Forcer en entiers
					s = prefix .. randomValue
				until ParkOccupied[baseName][s] == nil or counter == 100
			else
				AddLog("Error: GetParkingId(): Range limits are not valid numbers."..baseName.." prefix: "..tostring(prefix))
			end
		elseif #valueCopy > 2 or single then
			repeat
				counter = counter + 1
				local r = math.random(1,#valueCopy)
				s = valueCopy[r]
				-- s = prefix..string.format("%02d", s)
				s = prefix.. s
			until ParkOccupied[baseName][s] == nil 	or counter == 100
		end

		if ParkOccupied[baseName][s] == nil then
			break
		end
	end

	--ne trouve pas de place libre:
	if counter >= 100 then
		AddLog("GetParkingId() G no parking id available for base "..tostring(baseName))
		return false
	end

	ParkOccupied[baseName][s] = true

	return tostring(s)

end



--assigne un CallName � tous les squad West pour tout le reste de la campagne 
function AssignCallnameSquad()
	--le callsign ou callname sera dorenavant assign� � un squad "west" pour toute la campagne
	--par default, l'assignation se fait lors de la premiere mission ou a n'importe quel skipMission si cela n'avait pas �t� fait avant
	--l'assignation se fait en priorit� avec des SpecificCallnames s'ils existent, ensuite, le choix est automatique et al�atoire.
	--le joueur � la possibilit� de "forcer" le callsign � un ou plusieurs squads dans Init/oob_air_init.lua
	--Il peut meme le changer au cours de la campagne, DCE le prendra en compte
	-- il existe une "protection" contre les mauvais callsign ajout� par le joueur, s'il se trompe
	--https://wiki.hoggitworld.com/view/DCS_enum_callsigns

	--******************************

	--the callsign or callname will now be assigned to a "west" squad for the entire campaign
	--by default, the assignment is done at the first mission or at any skipMission if it was not done before
	--the assignment is done in priority with SpecificCallnames if they exist, then, the choice is automatic and random.
	--the player has the possibility to "force" the callsign to one or more squads in Init/oob_air_init.lua
	--he can even change it during the campaign, DCE will take it into account
	-- there is a "protection" against bad callsign added by the player, if he is wrong
	--https://wiki.hoggitworld.com/view/DCS_enum_callsigns


	-- Charger oob_air_init sans écraser oob_air actuel
	local initOobAir = nil
	do
		local tempEnv = {} -- Crée un environnement temporaire pour charger oob_air_init
		local f = assert(loadfile("Init/oob_air_init.lua"))
		setfenv(f, tempEnv)
		f()
		initOobAir = DeepCopy(tempEnv.oob_air or {}) -- Copie profonde pour éviter les références partagées
	end

	-- Comparer et mettre à jour les callsigns si nécessaire
	for _, initUnit in pairs(initOobAir) do
		for n = 1, #initUnit do
			for _, unit in pairs(oob_air) do
				if initUnit[n].callsign then -- Si le joueur a enregistré un callsign personnalisé
					for r = 1, #unit do
						if unit[r].name == initUnit[n].name and unit[r].callsign ~= initUnit[n].callsign then -- Si c'est le même squad
							unit[r].callsign = initUnit[n].callsign
							-- print("utilFct CORRECTION callsign "..unit[r].callsign)
						end
					end
				end
			end
		end
	end



	local callSigneAssigned = {}

	for side,unit in pairs(oob_air) do
		for n = 1, #unit do
			--regarde les CallName d�j� attribu� par le concepteur de campagne
			-- if WestCallsign[unit[n].country] == "west" and unit[n].callsign then
			if IsWesternCountry(unit[n].country) and unit[n].callsign then
				callSigneAssigned[unit[n].callsign] = true
			end
		end
	end

	for side, unit_ in pairs(oob_air) do
		for n = 1, #unit_ do
			local unit = unit_[n]
			local category
			if not unit.inactive then
				-- local Imax = 0
				-- if WestCallsign[unit.country] == "west" and not unit.callsign then
				if IsWesternCountry(unit.country) and not unit.callsign then
						local assigneOk = false

						--s'il existe une table avec des CallName sp�cifique � un type d'avion
						if SpecificCallnames[unit.type] and SpecificCallnames[unit.type][unit.country]  then

							--recherch l'index le plus haut de la table SpecificCallnames
							local Imax = 0
							for index, value in pairs(SpecificCallnames[unit.type][unit.country]) do
								if index > Imax then
									Imax = index
								end
							end

							local j = 0
							repeat
								local i =  math.random(9, Imax)

								if not callSigneAssigned[SpecificCallnames[unit.type][unit.country][i]] then
									unit.callsign = SpecificCallnames[unit.type][unit.country][i]
									unit.callsignId = i
									callSigneAssigned[unit.callsign] = true
									assigneOk = true
									break
								end
								j = j + 1
							until j > 50 or assigneOk
						end

						if not assigneOk then
							if unit.tasks["AWACS"] then
								category = "AWACS"
							elseif unit.tasks["Refueling"] then
								category = "tanker"
							else
								category = "generic"
							end

							for i = 1, #Callsign_west[category] do
								if not callSigneAssigned[Callsign_west[category][i]] then
									unit.callsign = Callsign_west[category][i]
									unit.callsignId = i
									callSigneAssigned[unit.callsign] = true
									assigneOk = true
									break
								end
							end

							if not assigneOk then
								local i =  math.random(1, #Callsign_west[category])
								unit.callsign = Callsign_west[category][i]
								unit.callsignId = i
								callSigneAssigned[unit.callsign] = true
								assigneOk = true
								break
							end
						end

				-- elseif WestCallsign[unit.country] == "west" and unit.callsign then								--controle si le callsign renseign� par le joueur/campaignMaker est compatible
				elseif IsWesternCountry(unit.country) and unit.callsign then
					local GoodCallSign = false
					if  not unit.inactive and SpecificCallnames[unit.type] and SpecificCallnames[unit.type][unit.country]  then

						--recherch l'index le plus haut de la table SpecificCallnames
						local Imax = 0
						for index, value in pairs(SpecificCallnames[unit.type][unit.country]) do
							if index > Imax then
								Imax = index
							end
						end
						for i = 9, Imax do
							if SpecificCallnames[unit.type][unit.country][i] == unit.callsign then
								unit.callsignId = i
								GoodCallSign = true
								break
							end
						end
					end

					if not GoodCallSign then
						if unit.tasks["AWACS"] then
							category = "AWACS"
						elseif unit.tasks["Refueling"] then
							category = "tanker"
						else
							category = "generic"
						end
						for i = 1, #Callsign_west[category] do
							if Callsign_west[category][i] == unit.callsign then
								GoodCallSign = true
								unit.callsignId = i
								break
							end
						end
					end

					if not GoodCallSign then
						print("Error(UtilFct) This callsign: ("..tostring(unit.callsign)..") is not compatible with this type of aircraft ("..tostring(unit.type)..")")
						print(" This callsign is ignored for this mission. Change this callsign in /Init/oob_air_init.lua for this squadron ("..tostring(unit.name)..")")
						print(" select a new callsign corresponding to the aircraft type as in this page. Or delete it, DCE will automatically assign the right one.")
						print("https://wiki.hoggitworld.com/view/DCS_enum_callsigns")
						print("Error ") os.execute 'pause'
						unit.callsign = nil
					end
				end
			end
		end
	end
end

function AddLog(txt)
	if not BugList then BugList = {} end

	if #BugList >=1 then
		for n=1, #BugList do
			if BugList[n] == txt then
				-- le bug est déjà enregistré, inutile de l'ajouter
				return
			end
		end
	end

	table.insert(BugList,txt)

end

	--sort() trie la table alpha en fonction du priority
function TargetlistToNum(tableWorking)
	local targetlistTempB = {}

	for target_name, target in pairs(tableWorking["blue"]) do
		target.titleName = target_name
		if not target.name then target.name = target_name end
		-- print("UtilFct titleName "..tostring(target.titleName))
		table.insert(targetlistTempB, target)
	end
	table.sort(targetlistTempB,  function(a,b)  return a.priority > b.priority  end)
	tableWorking["blue"] = targetlistTempB

	targetlistTempB = {}
	for target_name, target in pairs(tableWorking["red"]) do
		target.titleName = target_name
		if not target.name then target.name = target_name end
		-- print("UtilFct titleName "..tostring(target.titleName))
		table.insert(targetlistTempB, target)
	end
	table.sort(targetlistTempB,  function(a,b)  return a.priority > b.priority  end)
	tableWorking["red"] = targetlistTempB

end

function CompareTargetLists(reference, working)
    local changes = {
        added = {},    -- Éléments ajoutés
        removed = {},  -- Éléments supprimés
    }

    -- Parcourir les éléments de la table de référence pour détecter les suppressions
    for side, targets in pairs(reference) do
        for refIndex, refData in ipairs(targets) do
            local found = false
            if working[side] then
                for workIndex, workData in ipairs(working[side]) do
                    if refData.name == workData.name then
                        found = true
                        break
                    end
                end
            end
            if not found then
				-- Si l'élément n'existe pas dans la table de référence, il a été ajouté
				table.insert(changes.added, { side = side, data = refData })

            end
        end
    end

    -- Parcourir les éléments de la table de travail pour détecter les ajouts
    for side, targets in pairs(working) do
        for workIndex, workData in ipairs(targets) do
            local found = false
            if reference[side] then
                for refIndex, refData in ipairs(reference[side]) do
                    if workData.name == refData.name then
                        found = true
                        break
                    end
                end
            end
            if not found then
                -- Si l'élément n'existe pas dans la table de travail, il a été supprimé
              table.insert(changes.removed, { side = side, data = workData })
            end
        end
    end

    return changes
end

function CompareTableNumericTrigger(reference, working)
    local changes = {
        added = {},    -- Éléments ajoutés
        removed = {},  -- Éléments supprimés
    }

    -- Parcourir les éléments de la table de référence pour détecter les ajouts
    for refN, refData in ipairs(reference) do
        local found = false
		-- print("UtilF A refData.name: "..tostring(refData.name))
        for workN, workData in ipairs(working) do
			-- print("UtilF   BB refName: "..tostring(refData.name).." workName: "..tostring(workData.name))
            if refData.name == workData.name then
				-- print("UtilF       CCC ----------------->> FOUND ok")
                found = true
                break
            end
        end
        if not found then
			-- print("CompareTrigger refData.name: "..tostring(refData.name))
			-- print("CompareTrigger refData.condition: "..tostring(refData.condition))

			local dateCible = ExtractDateFromCondition(refData.condition)
			if dateCible then
				-- print("CompareTrigger Date extraite : " .. dateCible.day .. "/" .. dateCible.month .. "/" .. dateCible.year)
				-- Désactive si la date de la campagne est au moins 1 jour strictement après la date cible
				-- Utilise Julian Day Number (JDN) pour être indépendant de os.time et compatible avant 1970
				local function date_to_jdn(d)
					if not d then return nil end
					local y = tonumber(d.year)
					local m = tonumber(d.month)
					local day = tonumber(d.day)
					if not (y and m and day) then return nil end
					if m <= 2 then
						y = y - 1
						m = m + 12
					end
					local A = math.floor(y / 100)
					local B = 2 - A + math.floor(A / 4)
					local jd = math.floor(365.25 * (y + 4716)) + math.floor(30.6001 * (m + 1)) + day + B - 1524
					return jd
				end

				local camp_jd = date_to_jdn(camp.date)
				local cible_jd = date_to_jdn(dateCible)
				if camp_jd and cible_jd then
					local day_diff = camp_jd - cible_jd
					if day_diff >= 1 then
						refData.active = false
						-- print("CompareTrigger refData.active FALSE (camp >= cible +1 jour)")
						-- _affiche(camp.date, "camp.date: ")
						-- os.execute 'pause'
					end
				else
					-- print("CompareTrigger erreur lors de la conversion des dates (JDN)")
				end
			else
				-- print("CompareTrigger Impossible d'extraire la date")
			end

            -- Si l'élément n'existe pas dans la table de travail, il a été ajouté
          table.insert(changes.added, refData)
			-- print("UtilF          DDDD ----------------->> BAD ")
        end
    end

    -- -- Parcourir les éléments de la table de travail pour détecter les suppressions
    -- for workName, workData in ipairs(working) do
    --     local found = false
    --     for refName, refData in ipairs(reference) do
    --         if workName == refName then
    --             found = true
    --             break
    --         end
    --     end
    --     if not found then
    --         -- Si l'élément n'existe pas dans la table de référence, il a été supprimé
    --       table.insert(changes.removed, workData)
    --     end
    -- end

    return changes
end

function CompareTableAlphaNumeric(reference, working)
    local changes = {
        added = {},    -- Éléments ajoutés
        removed = {},  -- Éléments supprimés
    }

    -- Parcourir les éléments de la table de référence pour détecter les ajouts
    for refKey, refData in pairs(reference) do
        local found = false
        for workKey, workData in pairs(working) do
            if refKey == workKey then
                found = true
                break
            end
        end
        if not found then
            -- Si l'élément n'existe pas dans la table de travail, il a été ajouté
          table.insert(changes.added, { name = refKey, data = refData })
        end
    end

    -- Parcourir les éléments de la table de travail pour détecter les suppressions
    for workKey, workData in pairs(working) do
        local found = false
        for refKey, refData in pairs(reference) do
            if workKey == refKey then
                found = true
                break
            end
        end
        if not found then
            -- Si l'élément n'existe pas dans la table de référence, il a été supprimé
          table.insert(changes.removed, { name = workKey, data = workData })
        end
    end

    return changes
end


function ListSpotterAircraft()
	-- local isAfacAircraft = {}
	-- for side, oob_side in pairs(oob_air) do
	-- 	for n, sqd in pairs(oob_side) do
	-- 		if sqd.type and TaskByPlane.AFAC[sqd.type] then
	-- 			isAfacAircraft[sqd.type] = true
	-- 		end
	-- 	end
	-- end
	-- return isAfacAircraft

	local isAfacAircraft = {}
	for side, oob_side in pairs(oob_air) do
		for n, sqd in pairs(oob_side) do
			if sqd.tasks and type(sqd.tasks) == "table" then
				-- print("UtilFct sqd.name : "..tostring(sqd.name).." sqd.type: "..tostring(sqd.type))
				-- _affiche(sqd.tasks, "UtilFct sqd.tasks: ")
				for taskName, value in pairs(sqd.tasks) do
					if string.lower(taskName) == "spotter" and value == true then
						isAfacAircraft[sqd.type] = true
					end
				end
			end
		end
	end

	return isAfacAircraft

end



function CheckTarawa(txt)

	for basename, base in pairs(db_airbases) do
		if base.unitname and base.unitname == "LHA_Tarawa" then																			--if airbase is a carrier, find the unit in the OOB Ground
			print("UtilF LHA_Tarawa "..txt.." "..tostring(base.x) )
		end
	end
end

function CheckTarget(tgt, txt)

	for sideName, targets in pairs(targetlist) do
		for targetN, target in pairs(targets) do
			if target.titleName  == tgt then

				print("UtilF CheckTarget |"..txt.."| |"..tgt.."| alive?: "..tostring(target.alive) )

				if target.elements and target.elements[1] then

					print("UtilF CheckTarget |"..txt.."| |"..target.elements[1].name.."| dead? "..tostring(target.elements[1].dead) )

				end
			end
		end
	end
end

function FoundSquadSide(squadName)
	--local squadName = "VFA-113"
	local foundSide = false
	for side, unit in pairs(oob_air) do
		for n = 1, #unit do
			if unit[n].name == squadName then
				foundSide = side
				break
			end
		end
	end

	return foundSide
end


function KillTarget(targetName, targetName2)

	local findTarget = false
	for side_name,side in pairs(oob_ground) do														--side table(red/blue)											
		for country_n,country in pairs(side) do														--country table (number array)
			if country.vehicle then																	--if country has vehicles
				for group_n,group in pairs(country.vehicle.group) do								--groups table (number array)
					if group.name == targetName or group.name == targetName2 then
						for unit_n,unit in pairs(group.units) do										--units table (number array)					
							if not unit.dead then
								if Debug.AfficheSol then print("DC_DT Kill "..unit.name) end

								unit.dead = true														--mark unit as dead in oob_ground
								-- unit.dead_last = true													--mark unit as died in last mission
								unit.CheckDay = camp.date.CampTotalTimeS
								findTarget = true
							end
						end
					end
				end
			end
			if country.static then																--if country has static objects	
				for group_n,group in pairs(country.static.group) do								--groups table (number array)
					if group.name == targetName or group.name == targetName2 then
						for unit_n,unit in pairs(group.units) do									--units table (number array)
							if Debug.AfficheSol then print("DC_DT Kill "..unit.name) end

							if not unit.dead then											--unit is not yet dead (some static objects that are spawned in a destroyed state are logged dead at mission start, these must be excluded here)
								group.dead = true												--mark group as dead in oob_ground (static objects can be set as group.dead and spawned in a destroyed state)
								--TODO si le vehicle revit, il faudrait lui coller le hidden d'origine
								group.hidden = true												--hide dead static object
								unit.dead = true												--mark unit as dead in oob_ground (this is for the targetlist)
								-- unit.dead_last = true
								unit.CheckDay = camp.date.CampTotalTimeS
								findTarget = true
							end
						end
					end
				end
			end
			if country.ship then																--if country has ships
				for group_n,group in pairs(country.ship.group) do								--groups table (number array)
					if group.name == targetName or group.name == targetName2 then
						for unit_n,unit in pairs(group.units) do									--units table (number array)	
							if Debug.AfficheSol then print("DC_DT Kill "..unit.name) end

							unit.dead = true													--mark unit as dead in oob_ground
							-- unit.dead_last = true												--mark unit as died in last mission
							unit.CheckDay = camp.date.CampTotalTimeS                              -- ajoute la date de destruction    Miguel21 modification M19 : Repair SAM   
							findTarget = true
						end
					end
				end
			end
		end
	end

	for side_name, targets in pairs(targetlist) do											--iterate through targetlist
		for targetN, target in pairs(targets) do										--iterate through targets
			if target.titleName == targetName or target.titleName == targetName2 then
				if target.elements and target.elements[1].x then 						--if the target has subelements and is a scenery object target (element has x coordinate)
					for element_n,element in pairs(target.elements) do					--iterate through target elements

						if Debug.AfficheSol then print("DC_DT Kill __SCENERY__ "..element.name) end
						element.dead = true
						element.CheckDay = camp.date.CampTotalTimeS

					end
				end
			end
		end
	end
end

--rafraichit certain fichier si l'utilisateur avance le temps, cela permet de choisir les cibles rafraichi en fonction des triggers actif ou pas
function UpdateFilesAfterTimeJump()

	----- unpack template mission file ----
	local minizip = require('minizip')

	local zipFile = minizip.unzOpen("Init/base_mission.miz", 'rb')

	zipFile:unzLocateFile('mission')
	local misStr = zipFile:unzReadAllCurrentFile()
	local misStrFunc = loadstring(misStr)()

	zipFile:unzClose()

	CampTotalTimeS = SecondsBetween(camp.dateInit, camp.date)
	CampTotalTimeH = CampTotalTimeS / 3600

	-- print("UTIL_function_UpdateFilesAfterTimeJump() The campaign will start on this date: " .. tostring(camp.dateInit.day) .. "." .. tostring(camp.dateInit.month) .. "." .. tostring(camp.dateInit.year) .. ".\n")
	-- print("UTIL_function_UpdateFilesAfterTimeJump() The current date of the campaign is: " .. tostring(camp.date.day) .. "." .. tostring(camp.date.month) .. "." .. tostring(camp.date.year) .. ".\n")

	camp.date.CampTotalTimeS = CampTotalTimeS
	camp.date.CampTotalTimeH = CampTotalTimeH

	require("Active/oob_ground")

    -- dofile("../../../ScriptsMod." .. VersionPackageICM .. "/DC_UpdateTargetlist.lua")
	-- dofile("../../../ScriptsMod." .. VersionPackageICM .. "/DC_Refpoints.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_Weather.lua")
	-- dofile("../../../ScriptsMod." .. VersionPackageICM .. "/DC_NavalEnvironment.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_CheckTriggers.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateTargetlist.lua")
	-- dofile("../../../ScriptsMod."..VersionPackageICM.."/DC_UpdateOOBGround.lua")
	Include ("DC_UpdateTargetlist.lua")
	Include ("DC_Refpoints.lua")
	Include ("DC_Weather.lua")
	Include ("DC_NavalEnvironment.lua")
	Include ("DC_CheckTriggers.lua")
	Include ("DC_UpdateTargetlist.lua")
	Include ("DC_UpdateOOBGround.lua")

	local airbases_Str = "db_airbases = " .. TableSerialization(db_airbases, 0)
	local trigFile = io.open("Active/db_airbases.lua", "w") or error("Failed to open debug file")
	trigFile:write(airbases_Str)
	trigFile:close()

	local ground_str = "oob_ground = " .. TableSerialization(oob_ground, 0)						--make a string
	local groundFile = io.open("Active/oob_ground.lua", "w") or error("Failed to open debug file")
	groundFile:write(ground_str)																--save new data
	groundFile:close()


	local tgt_str = "targetlist = " .. TableSerialization(targetlist, 0)						--make a string
	local tgtFile = io.open("Active/targetlist.lua", "w") or error("Failed to open debug file")
	tgtFile:write(tgt_str)																		--save new data
	tgtFile:close()

	local trigStr = "camp_triggers = " .. TableSerializationAG_triggers(camp_triggers, 0)
	trigFile = io.open("Active/camp_triggers.lua", "w") or error("Failed to open debug file")
	trigFile:write(trigStr)
	trigFile:close()

end

function ConvertAlphaToNumeric(tbl)
    local numericTbl = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            v.name = k -- copie la clé alphanumérique dans le champ 'name'
          table.insert(numericTbl, v)
        end
    end
    return numericTbl
end




function PatchEjectedPilotStructure(pilot, from)

	if not pilot.type then
		pilot.type = "ejectedPilot"
	end

	-- print("utilF pilot.x2d "..tostring(pilot.x2d).." pilot.y2d "..tostring(pilot.y2d).." pilot.z2d "..tostring(pilot.z2d).." pilot.name "..tostring(pilot.name) )

	pilot.radio_on = nil
	pilot.smokeTiming = nil
	pilot.radio_start = nil
	pilot.closeRoad = nil
	-- pilot.pos = nil
	pilot.groupSAR = nil
	pilot.nameId = nil
	pilot.unit = nil
	pilot.initiatorMissionID = nil
	pilot.createdSoldier = nil
	pilot.initiator = nil
	pilot.unitObj = nil

	if not pilot.date then
		pilot.date = {
			day = pilot.day,
			month = pilot.month,
			year = pilot.year,
			hour = pilot.hour,
		}
		pilot.day = nil
		pilot.month = nil
		pilot.year = nil
		pilot.hour = nil
	end

	if not pilot.pos then
		if pilot.vec3x then
			pilot.pos = {
				vec3x = pilot.vec3x,
				vec3y = pilot.vec3y,
				vec3z = pilot.vec3z,
				x = pilot.vec3x,
				y = pilot.vec3z,
				z = pilot.vec3y,
				surfaceType = pilot.SurfaceType,
			}
		elseif pilot.x2d then
			pilot.pos = {
				vec3x = pilot.x2d,
				vec3y = pilot.z2d,
				vec3z = pilot.y2d,
				x = pilot.x2d,
				y = pilot.y2d,
				z = pilot.z2d,
				surfaceType = pilot.SurfaceType,
			}
		else
			print("Error PatchEjectedPilotStructure no pos for pilot "..tostring(pilot.name) )
		end
		pilot.x = nil
		pilot.y = nil
		pilot.z = nil
		pilot.x2d = nil
		pilot.y2d = nil
		pilot.z2d = nil
		pilot.SurfaceType = nil
	end

	if from == "targetlist" then
		
		if not pilot.x then
			-- dans targetlist on a pas le side
			pilot.x = pilot.pos.x
			pilot.y = pilot.pos.y
			pilot.z = pilot.pos.z
		end

		if pilot.firepower.max then
			pilot.firepower.max = 1
		end
	end

	-- if not pilot.sumEjectedPilotDay then
	-- 	pilot.sumEjectedPilotDay = pilot.SumEjectedPilotDay
		pilot.SumEjectedPilotDay = nil
	-- end


	if not pilot.dataPOW then
		pilot.dataPOW = {
			initChoicePOW = pilot.initChoicePOW or false,
			ejectNbDay = pilot.ejectNbDay or 0,
			POW_nextDayCheck = pilot.POW_nextDayCheck or 2,
			PowDayMax = pilot.PowDayMax or math.random(3, 15),
		}
		pilot.initChoicePOW = nil
		pilot.ejectNbDay = nil
		pilot.POW_nextDayCheck = nil
		pilot.PowDayMax = nil
	end

	return pilot

end




--demandé par 2 fichiers, normalement via MAIN_NextMission et UTIL_DIvers outils
function AddIconLayer(layersObjects, targetListRequired)


        -- [4] = 
        -- {
        --     ["visible"] = true,
    --     ["name"] = "Common",
        --     ["objects"] = 
        --     {
            -- [27] = 
            --     {
            --         ["visible"] = true,
            --         ["mapY"] = 445695.43,
            --         ["primitiveType"] = "Icon",
            --         ["scale"] = 1,
            --         ["file"] = "P91000072.png",
            --         ["colorString"] = "0x000000ff",
            --         ["mapX"] = 63776.31,
            --         ["layerName"] = "Common",
            --         ["name"] = "Warehouse - 20",
            --         ["angle"] = 0,



    local dataType = {
        ["warehouse"] = {
            ["type"] = "icon",
            ["data"] = "P91000072.png",
        },
        ["ammo_supply"] = {
            ["type"] = "icon",
            ["data"] = "P91000072.png",
        },
        ["logistic_center"] = {
            ["type"] = "icon",
            ["data"] = "P91000072.png",
        },
        ["fuel_storage"] = {
            ["type"] = "icon",
            ["data"] = "P91000207.png",
        },
        ["fuel_tank"] = {
            ["type"] = "icon",
            ["data"] = "P91000207.png",
        },
        ["power_plant"] = {
            ["type"] = "txt",
            ["data"] = "PP",
        },
        ["power_supply"] = {
            ["type"] = "txt",
            ["data"] = "PS",
        },
        ["rail_bridge"] = {
            ["type"] = "txt",
            ["data"] = "RB",
        },
        ["road_bridge"] = {
            ["type"] = "txt",
            ["data"] = "B",
        },
        ["control_tower"] = {
            ["type"] = "txt",
            ["data"] = "CT",
        },
        ["command_center"] = {
            ["type"] = "txt",
            ["data"] = "HQ",
        },
        ["airplane_shelter"] = {
            ["type"] = "txt",
            ["data"] = "AS",
        },
        ["default_target"] = {
            ["type"] = "txt",
            ["data"] = "T",
        },
        ["civil_ship"] = {
            ["type"] = "txt",
            ["data"] = "CS",
        },
        ["loading_crane"] = {
            ["type"] = "txt",
            ["data"] = "LC",
        },
        ["communication_center"] = {
            ["type"] = "txt",
            ["data"] = "CC",
        },
		["runway part"] = {
            ["type"] = "txt",
            ["data"] = "RW",
        },
    }

    -- Les couleurs dans DCS sont généralement définies au format hexadécimal ARGB (Alpha, Rouge, Vert, Bleu).
    -- Par exemple : "0xRRGGBBAA" où AA est l'opacité (FF = opaque).
    -- Les couleurs standards utilisées dans les fichiers mission DCS sont souvent :
    local colorType = {
        ["red"]   = "0xff0000ff", -- Rouge pur, opaque
        ["blue"]  = "0x0000ffff", -- Bleu pur, opaque
        ["black"] = "0x000000ff", -- Noir, opaque
        ["white"] = "0xffffffff", -- Blanc, opaque
        ["green"] = "0x00ff00ff", -- Vert pur, opaque
        ["yellow"]= "0xffff00ff", -- Jaune, opaque
    }

    local x_Legend = 999999999
    local y_Legend = 999999999

    local nb = 0
    for targetClientN, targetClientName in pairs(targetListRequired) do
        for targetSide, targets in pairs(targetlist) do
            for targetN, target in pairs(targets) do
                 if target.name == targetClientName and target.elements then
                    for elementN, element in pairs(target.elements) do

                        local function matchTypeFromName(name)
                            local lowerName = string.lower(name)
                            for key, val in pairs(dataType) do
                                local allFound = true
                                for sub in string.gmatch(key, "([^_]+)") do
                                    if not string.find(lowerName, sub) then
                                        allFound = false
                                        break
                                    end
                                end
                                if allFound then
                                    return key, val
                                end
                            end
                            return "default_target", dataType["default_target"]
                        end

                        -- Utilisation dans ta boucle :
                        local colorDefine
                        local tempObject = {}
                        local typeMatched, dataInfo = matchTypeFromName(element.name)
                        local data = dataInfo.data
                        local layerType = dataInfo.type


                        -- print("Element Name: " .. element.name .. ", Matched Type: " .. typeMatched)
                        -- _affiche(dataInfo, "dataInfo ")


                        if typeMatched then
                            data = dataType[typeMatched].data
                            layerType = dataType[typeMatched].type

                            --definitions des couleurs
                            if element.dead then
                                colorDefine = colorType["black"]
                            else
                                colorDefine = colorType["red"]
                            end

                            if layerType == "icon" then
                              tempObject = {
                                    ["visible"] = true,
                                    ["mapX"] = element.x,
                                    ["mapY"] = element.y,
                                    ["primitiveType"] = "Icon",
                                    ["scale"] = 1,
                                    ["file"] = tostring(data),
                                    ["name"] = tostring(element.name),
                                    ["colorString"] = tostring(colorDefine),
                                    ["layerName"] = "Common",
                                    ["angle"] = 0,
                                }
                            elseif layerType == "txt" then
                              tempObject =
                                {
                                    ["visible"] = true,
                                    ["borderThickness"] = 0,
                                    ["fillColorString"] = "0xffffff00", -- fond est transparent
                                    ["fontSize"] = 15,
                                    ["mapX"] = element.x,
                                    ["mapY"] = element.y,
                                    ["layerName"] = "Common",
                                    ["primitiveType"] = "TextBox",
                                    ["font"] = "DejaVuLGCSansCondensed.ttf",
                                    ["text"] = tostring(data),
                                    ["name"] = tostring(element.name),
                                    ["colorString"] = tostring(colorDefine),
                                    ["angle"] = 0,
                                }
                            end

                            -- Trouver la position la plus à gauche (minX) et la plus en bas (minY) de tous les éléments du groupe
                            -- On initialise minX et minY si ce n'est pas déjà fait
                            if not x_Legend or element.x -200 < x_Legend then
                                x_Legend = element.x -200
                            end
                            if not y_Legend or element.y - 200 < y_Legend then
                                y_Legend = element.y - 200
                            end

                            nb = nb + 1
                          table.insert(mission.drawings.layers[4].objects, tempObject)
                        end
                    end
                end
            end
        end
    end

    -- print("Number of targets added to the mission: " .. nb)
    -- print("x_Legend: " .. x_Legend.." y_Legend: " .. y_Legend)



    x_Legend = x_Legend -500 -- Ajuster la position ordonné pour le texte

    if nb > 0 and LayerObjectsLegend then
        -- Trouver le point d'ancrage de la légende (origine du template)
        local legend_minX = math.huge
        local legend_minY = math.huge
        for _, object in ipairs(LayerObjectsLegend) do
            if object.mapX and object.mapX < legend_minX then legend_minX = object.mapX end
            if object.mapY and object.mapY < legend_minY then legend_minY = object.mapY end
        end

        -- Décaler chaque objet de la légende pour l'aligner sur la cible
        for _, object in ipairs(LayerObjectsLegend) do
            local delta_x = (object.mapX or 0) - legend_minX
            local delta_y = (object.mapY or 0) - legend_minY

            object.mapX = x_Legend + delta_x
            object.mapY = y_Legend + delta_y

            -- print("object.mapX: "..object.mapX.." (x_Legend: "..x_Legend.." + delta_x: "..delta_x..")")
            -- print("object.mapY: "..object.mapY.." (y_Legend: "..y_Legend.." + delta_y: "..delta_y..")")

          table.insert(mission.drawings.layers[4].objects, object)
        end
    end

        -- os.execute 'pause'

    return layersObjects

end

--cration de la table listant les avions uniquement necessaire à la campagne:
function CreateAircraftListInCampaign()
	for sideName, squads in pairs(oob_air) do
		for squadN, squad in pairs(squads) do
			--ne pas tenir compte des escadrilles inactives, car si activation en cours, ça bug
			-- if not squad.inactive then
				if not AircraftInCampaign[squad.type] then
					AircraftInCampaign[squad.type] = true
					AircraftCampaignBySide[sideName][squad.type] = true

					if IsHelicopter[squad.type] then
						HelicoBySide[sideName][squad.type] = true
					else
						PlaneBySide[sideName][squad.type] = true
					end
				end
					if squad.player then
						AircraftInCampaign[squad.type] = "player"
						SidePlayer = sideName
					end
					if squad.client then
						AircraftInCampaign[squad.type] = "client"
					end
			-- end
		end
	end
end


--supprime de la mega table Data_divers les avions qui ne sont pas listé dans CampaignAircraft
function CleanDataDivers()

	-- _affiche(AircraftInCampaign, "AircraftInCampaign: ")
	for planeType, _ in pairs(Data_divers) do
		if not AircraftInCampaign[planeType] then
			Data_divers[planeType] = nil
		end
	end
	for planeType, _ in pairs(Db_Frequency) do
		-- print("CleanDataDivers A: Db_Frequency planeType present dans AircraftInCampaign?  "..planeType)
		if not AircraftInCampaign[planeType] then
			Db_Frequency[planeType] = nil
			-- print("CleanDataDivers B delete "..planeType.." In Db_Frequency ")
		end
	end

	-- camp_str = "AircraftInCampaign = " .. TableSerialization(AircraftInCampaign, 0)						--make a string
	-- campFile = io.open("Debug/Z_AircraftInCampaign.lua", "w")	 or error("Failed to open debug file")
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()

	-- camp_str = "Db_Frequency = " .. TableSerialization(Db_Frequency, 0)						--make a string
	-- campFile = io.open("Debug/Z2_Db_Frequency.lua", "w")	 or error("Failed to open debug file")
	-- campFile:write(camp_str)																		--save new data
	-- campFile:close()

end


function SetBoundaryFromCamp()
	
	-- print("BOUNDARY SetBoundaryFromCamp _A ".." camp.boundary "..tostring(camp.boundary) )

	--ecrase mission pour mettre à jour son boundary
	if camp.boundary then

		-- print("BOUNDARY SetBoundaryFromCamp _B camp.boundary existe, on met à jour le boundary de la mission en cours")
		
		--si camp.boundary existe, il faut ecraser celui de la mission en cours
		-- car ce n'est peut etre pas le meme

		local drawTbl = {}
		if mission and mission.drawings then

			-- print("BOUNDARY SetBoundaryFromCamp _C mission.drawings existe, on cherche une ligne border a ecraser dans les layers de la mission")

			drawTbl = mission.drawings
			
			-- cherche si un bordery existe et le remplace
			if drawTbl and drawTbl.layers then
				for layersN, layer in ipairs( drawTbl.layers) do
					if (layer.name == "Red" or layer.name == "Blue" or layer.name == "Neutral" ) and layer.objects and #layer.objects >= 1 then
						for objetN, objet in ipairs(layer.objects) do
							local testName = string.lower(objet.name)
							if ( string.find( testName , "border") or string.find( testName , "boundary") or string.find( testName , "frontline")   ) and #objet.points >= 3 then
								if string.find( testName , "blue") then

									if camp.boundary.data and camp.boundary.data.blue then
										objet.colorString = camp.boundary.data.blue.color or "0x0000ffff"
										objet.mapY = camp.boundary.data.blue.mapY or 0
										objet.mapX = camp.boundary.data.blue.mapX or 0

										-- objet.points = camp.boundary.blue

										local newPoints = {}
										for n, point in ipairs(camp.boundary.blue) do
											newPoints[n] = {
												x = point.x - camp.boundary.data.blue.mapX,
												y = point.y - camp.boundary.data.blue.mapY,
											}
										end
										objet["points"] = newPoints
									end



								elseif string.find( testName , "red") then

									if camp.boundary.data and camp.boundary.data.red then
										objet.colorString = camp.boundary.data.red.color or "0xff0000ff"
										objet.mapY = camp.boundary.data.red.mapY or 0
										objet.mapX = camp.boundary.data.red.mapX or 0

										-- objet.points = camp.boundary.red
									
										local newPoints = {}
										for n, point in ipairs(camp.boundary.red) do
											newPoints[n] = {
												x = point.x - camp.boundary.data.red.mapX,
												y = point.y - camp.boundary.data.red.mapY,
											}
										end
										objet["points"] = newPoints
									end
								end
							end
						end
					end
				end
			end

		else

			-- print("BOUNDARY SetBoundaryFromCamp _D mission.drawings n'existe pas, on le crée avec le boundary du camp")

			mission.drawings = {
				["options"] = 
					{
						["hiddenOnF10Map"] = 
						{
							["Observer"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["Observer"]
							["Instructor"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["Instructor"]
							["ForwardObserver"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["ForwardObserver"]
							["Pilot"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["Pilot"]
							["Spectrator"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["Spectrator"]
							["ArtilleryCommander"] = 
							{
								["Neutral"] = false,
								["Blue"] = false,
								["Red"] = false,
							}, -- end of ["ArtilleryCommander"]
						}, -- end of ["hiddenOnF10Map"]
					}, -- end of ["options"]
				layers =
				{
					[1] = 
					{
						["visible"] = true,
						["name"] = "Red",
						["objects"] = {},
					}, -- end of [1]
					[2] = 
					{
						["visible"] = true,
						["name"] = "Blue",
						["objects"] = {},
					}, -- end of [2]
					[3] = 
					{
						["visible"] = true,
						["name"] = "Neutral",
						["objects"] = {},
					}, -- end of [3]
					[4] = 
					{
						["visible"] = true,
						["name"] = "Common",
						["objects"] = {},
					}, -- end of [4]
					[5] = 
					{
						["visible"] = true,
						["name"] = "Author",
						["objects"] = {},
					}, -- end of [5]
				}, -- end of ["layers"]
			}

			if camp.boundary.blue and #camp.boundary.blue >= 3 then
				-- print("BOUNDARY SetBoundaryFromCamp _E camp.boundary.blue existe et comporte au moins 3 points, on ajoute une ligne blue dans les layers de la mission")

				mission.drawings.layers[2] = {
					name = "Blue",
					visible = true,
					objects = {
						[1] = {
							["visible"] = true,
							["colorString"] = camp.boundary.data.blue.color or "0x0000ffff",
							["lineMode"] = "segments",
							["mapY"] = camp.boundary.data.blue.mapY or 0,
							["primitiveType"] = "Line",
							["style"] = "solid",
							["closed"] = false,
							["thickness"] = 8,
							["mapX"] = camp.boundary.data.blue.mapX or 0,
							["layerName"] = "Blue",
							["name"] = "Border-Blue",
							-- ["points"] = camp.boundary.blue,
						},
					},
				}

				local newPoints = {}
				for n, point in ipairs(camp.boundary.blue) do
					newPoints[n] = {
						x = point.x - camp.boundary.data.blue.mapX,
						y = point.y - camp.boundary.data.blue.mapY,
					}
				end
				mission.drawings.layers[2].objects[1]["points"] = newPoints

			end

			if camp.boundary.red and #camp.boundary.red >= 3 then
				mission.drawings.layers[1] = {
					name = "Red",
					visible = true,
					objects = {
						[1] = {
							["visible"] = true,
							["colorString"] = camp.boundary.data.red.color or "0xff0000ff",
							["lineMode"] = "segments",
							["mapY"] = camp.boundary.data.red.mapY or 0,
							["primitiveType"] = "Line",
							["style"] = "solid",
							["closed"] = false,
							["thickness"] = 8,
							["mapX"] = camp.boundary.data.red.mapX or 0,
							["layerName"] = "Red",
							["name"] = "Border-Red",
							-- ["points"] = camp.boundary.red,
						},
					},
				}

				local newPoints = {}
				for n, point in ipairs(camp.boundary.red) do
					newPoints[n] = {
						x = point.x - camp.boundary.data.red.mapX,
						y = point.y - camp.boundary.data.red.mapY,
					}
				end
				mission.drawings.layers[1].objects[1]["points"] = newPoints

			end

		end


	end
end

--recupere les info boundary de base_mission ou mission trigger pour remplir le camp.boundary
function GetBoundary(missionWork)

	-- print("BOUNDARY GetBoundary _A missionWork "..tostring(missionWork).." camp.boundary "..tostring(camp.boundary) )

	if not missionWork then missionWork = mission end
		
	local boundary = {
		red = {},
		blue = {},
		neutral = {},
	}

	local tableDrawings = {}
	if missionWork and missionWork.drawings then
		tableDrawings = missionWork.drawings
	else
		AddLog("Error: No drawings found in the mission to extract boundary information.")
		return false
	end
	local foundBoundary = false

	-- creation des frontieres en fonction des dessins dans missionWork red et blue qui comporte le nom border ou boundary
	if tableDrawings and tableDrawings.layers then
		-- print("BOUNDARY GetBoundary _B tableDrawings.layers existe, on cherche une ligne border dans les layers de la mission")

		for layersN, layer in ipairs( tableDrawings.layers) do
			-- print("BOUNDARY GetBoundary _C layer.name "..tostring(layer.name).." layer.objects "..tostring(layer.objects) )

			if (layer.name == "Red" or layer.name == "Blue" or layer.name == "Neutral" ) and layer.objects and #layer.objects >= 1 then
				-- print("BOUNDARY GetBoundary _D layer.name "..tostring(layer.name).." correspond à une faction et comporte des objets, on cherche un objet border ou boundary dans les objets du layer")

				for objetN, objet in ipairs(layer.objects) do
					local testName = string.lower(objet.name)
					-- print("BOUNDARY GetBoundary _E objet.name "..tostring(objet.name).." testName "..tostring(testName) )

					if ( string.find( testName , "border") or string.find( testName , "boundary") or string.find( testName , "frontline")   ) and #objet.points >= 3 then
						-- print("BOUNDARY GetBoundary _F objet.name "..tostring(objet.name).." correspond à une frontière et comporte au moins 3 points, on ajoute les points à la table boundary")

						if objet.points and #objet.points >= 3 then
							-- print("BOUNDARY GetBoundary _G objet.name "..tostring(objet.name).." comporte "..#objet.points.." points, on les ajoute à la table boundary")

							camp.boundary = camp.boundary or {}
							camp.boundary.data = camp.boundary.data or {}
							camp.boundary.data[string.lower(layer.name)] = camp.boundary.data[string.lower(layer.name)] or {}
							camp.boundary.data[string.lower(layer.name)].color = objet.colorString or (layer.name == "Red" and "0xff0000ff" or "0x0000ffff")
							camp.boundary.data[string.lower(layer.name)].mapX = objet.mapX or 0
							camp.boundary.data[string.lower(layer.name)].mapY = objet.mapY or 0

							for n, point in ipairs(objet.points) do
								local newPoints = {
									x = point.x + objet.mapX,
									y = point.y + objet.mapY,
								}

								table.insert(boundary[string.lower(layer.name)], newPoints)

								foundBoundary = true
							end

							camp.boundary[string.lower(layer.name)] = boundary[string.lower(layer.name)]
						end
					end
				end
			end
		end
	end

	if not foundBoundary then
		local bugTxt = " * * * DcUsar there are no valid borders in this campaign * * * "
		AddLog("Note for the Campaign Maker"..bugTxt)
		return false
	else
		return true
	end
end

function LoadMissionFromMizIsolated(misStr)

    local chunk, err = loadstring(misStr)
    if not chunk then
        error("Erreur loadstring mission: "..tostring(err))
    end

    local env = {}
    setmetatable(env, { __index = _G })

    setfenv(chunk, env)

    local ok, execErr = pcall(chunk)
    if not ok then
        error("Erreur execution mission: "..tostring(execErr))
    end

    return env.mission
end


---------------------------------------------------------------------
-- Formate un nombre avec des zéros devant (ex: 7 -> "007")
-- Pourquoi : DCS ne supporte pas %0*d dans string.format
---------------------------------------------------------------------
function padnumber(num, size)

    local s = tostring(num)

    while #s < size do
        s = "0" .. s
    end

    return s
end



function SetBaseHumain(baseSelected)
	for baseName, base in pairs(db_airbases) do
		if baseName == baseSelected then
			base["humainSquad"] = true
			return true
			-- break
		end
	end
	return false
end
function ResetBaseHumain()
	for baseName, base in pairs(db_airbases) do
		base.humainSquad = nil
	end
end

function SetUnitClient(unitName)
	--parse la table oob_air puis trouve unitName puis y ajoute la variable : client = true
	for sideName, squads in pairs(oob_air) do
		for squadN, squad in pairs(squads) do
			if squad.name == unitName then
				squad.client = true
				SetBaseHumain(squad.base)
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

function ResetUnitClient()
	--parse la table oob_air et met à nil tout squad.client
	for sideName, squads in pairs(oob_air) do
		for squadN, squad in pairs(squads) do
			squad.client = nil
		end
	end
end



-- Résout un chemin pointé ("mission_ini.weather.trend") en valeur réelle,
-- sans lever d'erreur si un maillon du chemin est absent.
function getByPath(path)
	local value = _G
	for segment in path:gmatch("[^.]+") do
		if type(value) ~= "table" then return nil end
		value = value[segment]
		if value == nil then return nil end
	end
	return value
end

-- Essaie chaque chemin candidat dans l'ordre, retourne la première valeur
-- trouvée. Loggue un avertissement si la valeur vient d'un chemin autre
-- que le premier (donc un chemin legacy) — c'est ce log qui te dira,
-- plus tard, quand tu peux supprimer les chemins legacy en toute sécurité.
function resolveValue(fieldName, candidatePaths, default)
	for i, path in ipairs(candidatePaths) do
		local value = getByPath(path)
		if value ~= nil then
			if i > 1 then
				-- print("[ConfigResolver] '" .. fieldName .. "' trouvé via chemin legacy : " .. path
				-- 	.. " (chemin cible : " .. candidatePaths[1] .. ")")
			end
			return value
		end
	end
	-- print("[ConfigResolver] '" .. fieldName .. "' introuvable, valeur par défaut : " .. tostring(default))
	return default
end

function resolveGroup(pathsByField, defaults)
	local resolved = {}
	for fieldName, candidatePaths in pairs(pathsByField) do
		resolved[fieldName] = resolveValue(fieldName, candidatePaths, defaults and defaults[fieldName])
	end
	return resolved
end

function generateSolid_G_Variable()
	Weather = resolveGroup(WEATHER_PATHS, {
		trend = 50, variance = 30, refTemp = 20,
		instability = 60, windActivity = 2.5, winDirection = 158, weather_playerBias = 0
	})

	PictureBrief = resolveGroup(PICTURE_BRIEF_PATHS, {
    	pictureBrief = { blue = {}, red = {} 
	},
})


end

--construit les variables de maniere robuste, suite aux changements de structure de conf_mod.lua et mission_ini.lua
generateSolid_G_Variable()

