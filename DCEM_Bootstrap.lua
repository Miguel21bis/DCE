-------------------------------------------------------------------------------
-- DCEM_Bootstrap.lua
--
-- SEUL fichier dont DCE_Manager.exe connaît le chemin en dur.
-- À partir d'ici, tout est résolu par Include() : ranger, déplacer ou
-- renommer un fichier côté Lua ne demande plus AUCUNE modification C#,
-- ni recompilation de DCE_Manager.
--
-- DCE_Manager doit poser AVANT de charger ce fichier :
--     pathScriptsMod      = chemin absolu de ScriptsMod.XX
--     pathCampaign        = chemin absolu de la campagne (optionnel)
--     DCEM_API_REQUIRED   = niveau d'API attendu par le C#
-------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["DCEM_Bootstrap.lua"] = "1.0.1"

-------------------------------------------------------------------------------
-- GLOBALES ATTENDUES PAR LES FICHIERS HISTORIQUES
--
-- Certains fichiers supposent qu'une globale existe déjà parce que, dans la
-- chaîne .bat, leur appelant la posait juste avant de les charger. Le bootstrap
-- change cet ordre : il charge les données AVANT que ces appelants n'existent.
-- Tout ce que les fichiers de DATA/ tiennent pour acquis se pose donc ici.
--
-- Chaque garde est conditionnelle : si la vraie implémentation est déjà là
-- (DCS en jeu, ou un fichier chargé plus tôt), on ne l'écrase pas.
-------------------------------------------------------------------------------

-- Plusieurs fichiers testent Debug.debug sans vérifier que Debug existe.
Debug = Debug or { debug = false }

-- Fonction DCS, appelée par UTIL_Data.lua (~ligne 658) dans ses définitions de
-- tâches. En jeu, DCS la fournit. Hors DCS, elle était définie en tête de
-- DCEM_Function.lua, qui chargeait UTIL_Data.lua juste après - l'ordre suffisait.
-- Ce n'est plus vrai depuis que le bootstrap charge les données en premier.
-- NE PAS CHANGER LA CASSE (nom imposé par DCS).
if type(aircraft_task) ~= "function" then
	function aircraft_task(taskName)
		return taskName
	end
end

-------------------------------------------------------------------------------
-- COMPATIBILITÉ Lua 5.1 -> 5.4 (DCE_Manager passe par NLua = Lua 5.4)
-- ScriptsMod a été écrit pour Lua 5.1 (luae.exe) : setfenv / getfenv / unpack / loadstring
-- n'existent plus en 5.4. UTIL_Data.lua (lecture des entry.lua des modules) appelle setfenv.
-- Chaque garde est conditionnelle : sous Lua 5.1 rien n'est remplacé.
-------------------------------------------------------------------------------
if not setfenv and debug and debug.getupvalue and debug.upvaluejoin and debug.setupvalue then
	function setfenv(f, env)
		if type(f) ~= "function" then error("setfenv : function expected", 2) end
		local up, name = 0, nil
		repeat
			up = up + 1
			name = debug.getupvalue(f, up)
		until name == "_ENV" or name == nil
		if name then
			debug.upvaluejoin(f, up, function() return name end, 1)
			debug.setupvalue(f, up, env)
		end
		return f
	end

	function getfenv(f)
		if type(f) ~= "function" then return _G end
		local up, name, val = 0, nil, nil
		repeat
			up = up + 1
			name, val = debug.getupvalue(f, up)
		until name == "_ENV" or name == nil
		return val or _G
	end
end

unpack = unpack or table.unpack
loadstring = loadstring or load

-- Unique chemin construit à la main de tout le système.
local root = (pathScriptsMod or "."):gsub("[/\\]+$", "")
dofile(root .. "/UTIL_Include.lua")

-- Compare le niveau annoncé par le C# et celui de ScriptsMod.
CompatCheck()

-------------------------------------------------------------------------------
-- Ce dont DCE_Manager a besoin.
-- IncludeOnce  : le fichier doit exister.
-- IncludeOptional : toléré absent pendant la transition (ScriptsMod pas
--                   encore découpé, ou fichier pas encore créé).
-------------------------------------------------------------------------------
IncludeOnce("UTIL_Data.lua")						-- trouvé dans DATA/ ou à la racine
IncludeOptional("UTIL_DataCompilation.lua")			-- créé à l'étape 2 du découpage
IncludeOnce("UTIL_Changelog.lua")					-- reste à la racine

-- Trace sur disque uniquement s'il y a un avertissement.
CompatWriteLog(pathCampaign and (pathCampaign .. "/Debug") or nil)

return DCEM_Compat
