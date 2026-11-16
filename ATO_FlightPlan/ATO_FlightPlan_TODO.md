# ATO_FlightPlan — TODO bugs anciens (hors périmètre de la réorganisation)

Règle convenue : pendant la réorganisation on NE corrige PAS les anciens bugs (sauf s'ils sont fondamentalement graves).
Seul objectif : aucune capacité perdue entre l'ancien fichier et la nouvelle organisation (dossier ATO_FlightPlan\ATO_FP_xx.lua).
Chaque ligne ci-dessous existait AVANT la réorganisation (observée dans les logs ou dans le code d'origine).
Organisation actuelle : voir `ATO_FlightPlan_ARCHITECTURE.md`. Logs : `Debug\ATO_FlightPlan_LOG\`.

## Ouverts
1. **unitId en doublon** (grave, intermittent) : GenerateIDUnit (FUNC_Ids.lua, compteur à partir de 3000) peut redonner un id déjà pris par une unité de oob_ground (zone 3xxx). Vu : 3589 (Pedro LHA Tarawa), 3677, 3678 (escorte vs RED_078_MECH_G3-2). Piste : enregistrer tous les unitId de la mission et de oob_ground dans AllIdUnit au début du FlightPlan. Règle I02 du Check le surveille (0 doublon sur les dernières générations, mais dû au hasard).
2. **Tâches de waypoint : numéros non séquentiels / doublons** (`number` = 1,2,4,4,5 sur le waypoint 1 des Strike). Le code d'origine met des `["number"] = 4` en dur (plusieurs endroits) à côté de `#tasks + 1`. Impact DCS probablement nul mais à nettoyer. Règle T01 (info).
3. **Carburant (`payload.fuel`) parfois un texte** au lieu d'un nombre (~10 % des appareils, ex. `fuel=4900`). Vient de `flight[f].loadout.stores.fuel` (données loadout). Règle U04 (info).
4. **Hawk Battery 1 - AA** : unité sans nom (alerte vue une fois par le Check, hors FlightPlan, probablement dans oob_ground).
5. **Globales créées par le FlightPlan** (voulues ou oublis d'origine) : CommonFreq, GeWpindex, GetSidenumber, Missionfunc, TableTransportPilotNames, trig_n. À rendre locales/propres plus tard.
6. **TypeAlias / BaseNameAlias** lus sans exister (optionnels, définis dans Init/various_table.lua) — sans risque.
7. **Premier SAR sur porte-avions remplacé par un Pedro** : code volontaire ("Truc débile" dans l'original, phase H1/H3) — à reprendre proprement.
8. **Joueur en hélicoptère** : génération impossible tant que le script de transport du Wargame logistic n'est pas fini (hors FlightPlan). Les branches hélico du FlightPlan ont été exercées seulement par des hélicos IA (SAR, Pedro, Strike).
9. **Tâches peu exercées** : FAC, CarpetBombing (jamais vus dans les signatures) ; AttackGroup vu une fois. Builders comparés à l'original par évaluation symbolique, pas testés en vrai.
10. **Mélange d'indentations** (espaces/tabulations) à quelques endroits de la phase B (cosmétique).

## Fermés
(rien)
