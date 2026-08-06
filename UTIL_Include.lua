-------------------------------------------------------------------------------
-- UTIL_Include.lua
-- Résolution centralisée des chemins ScriptsMod + couche de compatibilité.
--
-- Compatible Lua 5.1 (luae.exe / DCS) ET Lua 5.4 (NLua / DCE_Manager).
-- N'utilise volontairement rien qui diffère entre les deux moteurs.
--
-- Ce fichier ne doit RIEN charger de lui-même : il ne fait que fournir
-- Include() / IncludeOnce() / IncludeOptional() et le contrôle de version.
-------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Include.lua"] = "1.0.0"


-------------------------------------------------------------------------------
-- 1. NIVEAU D'API  --  contrat entre ScriptsMod (Lua) et DCE_Manager (C#)
-------------------------------------------------------------------------------
-- level : à incrémenter à CHAQUE changement du contrat C# <-> Lua
--         (fichier déplacé, renommé, fonction retirée, signature changée...)
-- min   : plus ancien niveau encore accepté. Reste à 1 tant que les shims
--         de compatibilité sont en place à la racine. Le jour où tu les
--         supprimes, tu passes min à 2 et les vieux DCE_Manager sont
--         proprement rejetés avec un message clair.
-------------------------------------------------------------------------------
SCRIPTSMOD_API = {
	level = 2,
	min   = 1,
	notes = {
		[1] = "Historique : tous les fichiers à la racine de ScriptsMod",
		[2] = "Dossiers UTIL/ et DATA/, point d'entrée unique DCEM_Bootstrap.lua",
	},
}


-------------------------------------------------------------------------------
-- 2. COLLECTE DES AVERTISSEMENTS
-------------------------------------------------------------------------------
-- Trois canaux, parce qu'on ne sait pas lequel sera visible :
--   - print()   -> fenêtre console de la génération
--   - table DCEM_Compat -> lue par DCE_Manager pour afficher une MessageBox
--   - fichier log -> via CompatWriteLog(), pour le support utilisateur
-------------------------------------------------------------------------------
DCEM_Compat = DCEM_Compat or { warnings = {}, legacy = {}, ok = true }

function CompatWarn(msg)
	for _, m in ipairs(DCEM_Compat.warnings) do
		if m == msg then return false end					-- pas de doublon
	end
	DCEM_Compat.warnings[#DCEM_Compat.warnings + 1] = msg
	DCEM_Compat.ok = false
	print("[DCE][COMPAT] " .. msg)
	return true
end

-- Appelée par les relais restés à la racine (voir UTIL_Data.lua shim)
function CompatLegacy(fileName, newFolder)
	DCEM_Compat.legacy[fileName] = newFolder
	CompatWarn(fileName .. " a été appelé par son ancien chemin (racine). "
		.. "Nouvel emplacement : " .. newFolder .. fileName .. ". "
		.. "Mettez à jour DCE_Manager.")
end


-------------------------------------------------------------------------------
-- 3. RACINE DE SCRIPTSMOD
-------------------------------------------------------------------------------
-- Trois situations, dans cet ordre de priorité :
--   a) DCE_Manager a posé pathScriptsMod (chemin absolu)
--   b) la chaîne de génération tourne depuis le dossier de campagne
--      et connaît VersionPackageICM
--   c) sinon, on se localise depuis l'emplacement de CE fichier
-------------------------------------------------------------------------------
local function selfDir()
	local src = debug.getinfo(1, "S").source
	if src:sub(1, 1) == "@" then src = src:sub(2) end
	return src:match("^(.*[/\\])")
end

if pathScriptsMod and pathScriptsMod ~= "" then
	MOD_PATH = pathScriptsMod
elseif VersionPackageICM then
	MOD_PATH = "../../../ScriptsMod." .. VersionPackageICM
else
	MOD_PATH = selfDir() or "./"
end

MOD_PATH = MOD_PATH:gsub("[/\\]+$", "") .. "/"			-- un seul séparateur final


-------------------------------------------------------------------------------
-- 4. DOSSIERS FOUILLÉS
-------------------------------------------------------------------------------
-- L'ORDRE COMPTE. Les dossiers neufs passent AVANT la racine : si une
-- installation utilisateur conserve un vieux fichier orphelin à la racine
-- après mise à jour, c'est bien la nouvelle version qui l'emporte.
--
-- Ajouter un dossier au projet = ajouter une ligne ici, rien d'autre.
-------------------------------------------------------------------------------
IncludeDirs = { "UTIL/", "DATA/", "" }

-------------------------------------------------------------------------------
-- NE PAS DÉPLACER (chemins en dur côté DCE_Manager.exe) :
--   UTIL_Changelog.lua   -> racine
--   DCEM_Bootstrap.lua   -> racine
--   UTIL_Include.lua     -> racine
-- Compléter cette liste au fur et à mesure, et la vider dès que le C#
-- ne connaîtra plus que DCEM_Bootstrap.lua.
-------------------------------------------------------------------------------

local function fileExists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

-- Renvoie le chemin complet du fichier, et le dossier où il a été trouvé.
function IncludeResolve(name)
	if not name:match("%.lua$") then name = name .. ".lua" end
	for _, dir in ipairs(IncludeDirs) do
		local path = MOD_PATH .. dir .. name
		if fileExists(path) then return path, dir end
	end
	return nil
end


-------------------------------------------------------------------------------
-- 5. LES TROIS VERBES DE CHARGEMENT
-------------------------------------------------------------------------------
-- Include        : poste de la chaîne de montage. Rejoué à chaque appel.
--                  -> DC_*, ATO_*, MAIN_*
-- IncludeOnce    : réserve de données ou de fonctions. Chargée une seule fois.
--                  -> DATA/*, UTIL_Functions...
-- IncludeOptional: fichier qui peut ne pas exister encore (transition).
--                  Ne plante pas, se contente de renvoyer false.
-------------------------------------------------------------------------------
function Include(name)
	local path = IncludeResolve(name)
	if not path then
		error("Include : fichier introuvable -> " .. tostring(name)
			.. "   (racine testée : " .. MOD_PATH .. ")", 2)
	end
	dofile(path)
	return true
end

local loadedOnce = {}

function IncludeOnce(name)
	if loadedOnce[name] then return false end
	loadedOnce[name] = true
	return Include(name)
end

function IncludeOptional(name)
	if IncludeResolve(name) then return Include(name) end
	return false
end


-------------------------------------------------------------------------------
-- 6. VÉRIFICATION DE COMPATIBILITÉ
-------------------------------------------------------------------------------
-- DCE_Manager pose la globale DCEM_API_REQUIRED avant de charger
-- DCEM_Bootstrap.lua. Un DCE_Manager antérieur ne la pose pas : on le
-- détecte par son absence.
-------------------------------------------------------------------------------
function CompatCheck()
	local req = DCEM_API_REQUIRED

	if req == nil then
		CompatWarn("DCE_Manager n'annonce aucun niveau d'API : version antérieure "
			.. "à l'API 2. Le mode compatibilité est actif, mais mettez à jour "
			.. "DCE_Manager.")

	elseif req > SCRIPTSMOD_API.level then
		CompatWarn("DCE_Manager attend l'API " .. req .. " alors que ScriptsMod "
			.. "ne fournit que l'API " .. SCRIPTSMOD_API.level .. ". "
			.. "Mettez à jour ScriptsMod.")

	elseif req < SCRIPTSMOD_API.min then
		CompatWarn("DCE_Manager attend l'API " .. req .. ", devenue obsolète "
			.. "(minimum supporté : " .. SCRIPTSMOD_API.min .. "). "
			.. "Mettez à jour DCE_Manager.")
	end

	DCEM_Compat.apiLevel    = SCRIPTSMOD_API.level
	DCEM_Compat.apiMin      = SCRIPTSMOD_API.min
	DCEM_Compat.apiRequired = req
	return DCEM_Compat
end

-- Écrit un log seulement s'il y a quelque chose à signaler.
function CompatWriteLog(folder)
	if #DCEM_Compat.warnings == 0 then return false end

	local target = (folder or MOD_PATH):gsub("[/\\]+$", "") .. "/DCEM_Compat.log"
	local f = io.open(target, "w")
	if not f then return false end

	f:write("DCE - avertissements de compatibilité - " .. os.date() .. "\n")
	f:write("ScriptsMod API " .. SCRIPTSMOD_API.level
		.. " (minimum accepté : " .. SCRIPTSMOD_API.min .. ")\n")
	f:write("DCE_Manager demande : " .. tostring(DCEM_Compat.apiRequired) .. "\n")
	f:write("Moteur Lua : " .. _VERSION .. "\n\n")
	for _, m in ipairs(DCEM_Compat.warnings) do
		f:write("- " .. m .. "\n")
	end
	f:close()
	return true
end


-------------------------------------------------------------------------------
-- 7. CHEMINS ET DOSSIERS DE DONNÉES
-------------------------------------------------------------------------------
-- ModPath() remplace toutes les auto-localisations du type
--      local src = debug.getinfo(1).source:sub(2)
--      local baseDir = src:match("(.*/)")
-- qui cassent dès que le fichier qui les contient change de dossier.
--
-- Un chemin se calcule TOUJOURS depuis la racine de ScriptsMod, jamais
-- depuis la position du fichier qui pose la question.
-------------------------------------------------------------------------------
function ModPath(sub)
	if not sub or sub == "" then return MOD_PATH end
	return MOD_PATH .. sub:gsub("^[/\\]+", "")
end

-------------------------------------------------------------------------------
-- Liste les fichiers .lua d'un sous-dossier de ScriptsMod.
-- Renvoie : table des chemins complets, chemin du dossier interrogé.
-- Windows uniquement (utilise dir /b), comme le code existant.
-------------------------------------------------------------------------------
function ListLuaFiles(sub)
	local folder  = ModPath(sub):gsub("[/\\]+$", "")
	local winPath = folder:gsub("/", "\\")				-- dir n'aime pas les /
	local files   = {}

	local p = io.popen('dir "' .. winPath .. '\\*.lua" /b 2>nul')
	if not p then return files, folder end

	for name in p:lines() do
		if name:match("%.lua$") then
			files[#files + 1] = folder .. "/" .. name
		end
	end
	p:close()

	return files, folder
end
