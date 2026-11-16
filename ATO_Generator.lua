--ATO_Generator.lua
--Point d'entree du generateur d'ATO : charge, dans l'ordre, les fichiers du dossier ATO_Generator\
--Appele par MAIN_NextMission.lua : Include("ATO_Generator.lua")
--Ce fichier ne contient aucune logique : il ne fait que charger les autres (comme ATO_FlightPlan.lua pour son dossier).
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["ATO_Generator.lua"] = "1.21.137"
-------------------------------------------------------------------------------------------------------

if Debug.debug then
	print("START ATO_Generator.lua "..versionDCE["ATO_Generator.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

--L'ORDRE COMPTE : chaque fichier utilise les fonctions globales des precedents.
Include("ATO_Generator/ATO_Gen_00_Debug.lua")		--logs de debug, suivi des rejets et des echecs (debugLog, rejectStep...)
Include("ATO_Generator/ATO_Gen_01_Eval.lua")		--mini moteur de conditions (eval.test / eval.group / eval.attributesCond)
Include("ATO_Generator/ATO_Gen_Main.lua")		--orchestrateur du generateur ; charge lui-meme les sous-fichiers 10 State, 20 Eligibility, 30 Sorties, 40/41 WG, 50 Support, 60 Package, 90 RangePref
