-------------------------------------------------------------------------------
-- UTIL_Data.lua  --  RELAIS DE COMPATIBILITÉ (shim)
--
-- Le fichier réel est désormais dans DATA/UTIL_Data.lua.
-- Ce relais n'existe que pour les versions de DCE_Manager (ou de scripts
-- tiers) qui appellent encore ce chemin en dur à la racine.
--
-- MODÈLE : pour créer un autre relais, copier ce fichier, changer les deux
-- occurrences du nom et le dossier de destination. Rien d'autre.
--
-- À SUPPRIMER le jour où SCRIPTSMOD_API.min passera à 2.
-------------------------------------------------------------------------------

local FILE_NAME  = "UTIL_Data.lua"
local NEW_FOLDER = "DATA/"

-- Auto-localisation : fonctionne quel que soit le répertoire courant et quel
-- que soit le moteur (Lua 5.1 de DCS comme Lua 5.4 de NLua), car on repart du
-- chemin qui a servi à charger CE fichier.
local src = debug.getinfo(1, "S").source
if src:sub(1, 1) == "@" then src = src:sub(2) end
local here = src:match("^(.*[/\\])") or "./"

-- Signalement. Si UTIL_Include.lua a déjà été chargé, l'avertissement remonte
-- proprement jusqu'à DCE_Manager ; sinon on se rabat sur la console.
if type(CompatLegacy) == "function" then
	CompatLegacy(FILE_NAME, NEW_FOLDER)
else
	print("[DCE][COMPAT] " .. FILE_NAME .. " a été appelé par son ancien chemin "
		.. "(racine). Nouvel emplacement : " .. NEW_FOLDER .. FILE_NAME .. ". "
		.. "Mettez à jour DCE_Manager.")
end

dofile(here .. NEW_FOLDER .. FILE_NAME)
