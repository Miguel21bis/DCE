# ATO_FlightPlan — organisation des fichiers (état après réorganisation)

But atteint : un nouvel assistant (ou toi dans 6 mois) comprend le FlightPlan en quelques minutes, sans relire 8000 lignes.
`ATO_FlightPlan.lua` est passé de 8475 à 993 lignes ; le code d'origine est inchangé (déplacé, pas réécrit).

## 1. Les fichiers (dossier `ATO_FlightPlan\`)

| Fichier | Rôle |
|---|---|
| `ATO_FlightPlan.lua` | Point d'entrée (inclus par `MAIN_NextMission.lua`, inchangé). Chef d'orchestre : préparation, boucle sur les vols, étape finale. |
| `ATO_FP_Check.lua` | Contrôle automatique (rapport de règles, globales oubliées) + `AtoFP.Guard` (anti-plantage) + `AtoFP.LogPath`. |
| `ATO_FP_20_Tasks.lua` | Constructeurs de tâches DCS : `Task_Option`, `Task_Script`, `Task_EngageAir`, `Task_Orbit`, `Task_Service`, `Task_CarpetBombing`, `Task_AttackGroup`, `Task_Bombing`, `Task_FAC`, `Task_Follow`. |
| `ATO_FP_30_Identity.lua` | Indicatifs (`getCallsign`), identifiants Link16 / SADL / IDM, TACAN tanker, `fct_movedBullseye`. |
| `ATO_FP_40_Spawn.lua` | Apparition / activation du groupe : `spawnOn`, `activate_Group_WithFlag`, `activate_group_time_after`, `start_Set_Ai_Task`, `createBombingChapter`, `modify_Activate_GroupTime`. |
| `ATO_FP_60_Loop.lua` | Les ÉTAPES du traitement d'un vol (27 fonctions, phases A à J) dans l'ordre d'exécution. |
| `ATO_FP_90_Final.lua` | Étape finale : fichiers debug, briefing, nettoyages, `GetSidenumber`, `GeWpindex` (globales voulues). |

Chargement : `Include("ATO_FlightPlan/ATO_FP_xx.lua")` (le chargeur `UTIL_Include.lua` cherche aussi dans `UTIL/`, `DATA/`).

## 2. Comment les fichiers communiquent
- Table globale `AtoFP`, remise à zéro (`AtoFP = {}`) en tête de `ATO_FlightPlan.lua` à chaque passe de génération.
- Un fichier range ce qu'il fournit dans `AtoFP.xxx` (fin de fichier) ; le consommateur fait `local xxx = AtoFP.xxx` (en-tête de fichier = « pont »).
- Les variables locales de la boucle ne traversent pas les fichiers : elles sont passées en PARAMÈTRES et les valeurs modifiées sont RENVOYÉES (`-- Rend : ...`).
- Scalaires partagés en direct : `AtoFP.debugTxt_AtoFP` (texte de debug), `AtoFP.is_helicopter` (copie de `is_helicopter`).
- Lua 5.1 : max 200 locals par fonction et 60 upvalues par fermeture — c'est pourquoi la boucle est découpée.

## 3. La boucle (for sideName > p > role > f) — un vol à la fois
Chaque étape est précédée de `AtoFP.phase = "..."` (repère lu par le rapport de crash).

| Phase | Repère | Fonction | Rôle |
|---|---|---|---|
| A | `A:PrepBaseAndModules` | PrepBaseAndModules | base FARP / porte-avions, modules requis, BaseAirStart |
| A | `A:PrepParking` | PrepParking | `limitedParkTiming`, occupation parkings (TabLPark) |
| A | `A:PrepWeaponAndTask` | PrepWeaponAndTask | `pn`, type d'arme, tâche DCS, type de cible |
| A | `A:PrepTaskCheck` | PrepTaskCheck | validation de la tâche, mode dégradé, `id_task` |
| B | `B:WpBuild` … `B:WpHumanBriefing` | WpBuild, WpSpecialCases, WpTypesSpeeds, WpAltitudeLand, WpDepartureSpawn, WpAttackPrep, WpIpAttack, WpTaskByRole, WpStationAssemble, WpSeadEgressRecon, WpHumanBriefing | corps de la boucle `for w` (waypoints) : construit `waypoints[w]` et ses tâches |
| C | `C` | FlightAfterWaypoints | verrouille le 1er waypoint, taxi, waypoints du briefing joueur |
| D | `D` | FlightCreateUnits | unités : niveau, nom, charge, carburant |
| E | `E` | FlightDatalink | Link16 / SADL / IDM |
| F | `F` | FlightFrequencyAndGroup | fréquences radio, table `group` |
| G | `G` | FlightGroupAndSpawn | apparition (pont, air, catapulte), activation |
| H | `H1`…`H5` | FlightSarAlert, FlightInterceptAwacs, FlightPedroSar, FlightStartAndCallsign, FlightRecovery | SAR alerte, Intercept/GCI/AWACS, Pedro, multijoueur, recovery (RTB) |
| I | `I` | FlightInsertInMission | déroutements du briefing + insertion dans `mission.coalition...` |
| J | `J` | FlightTriggersAndDebug | triggers d'activation + debug |

Points sensibles (inchangés par rapport à l'original) :
- `table.insert(waypoints, w, ...)` (empilement des tankers, dans `WpAltitudeLand` (stacking) et `FlightAfterWaypoints` (point supplémentaire)) décale `waypoints` par rapport à `flight[f].route` ; `w` n'est jamais réaffecté.
- `speed` est réaffecté ~15 fois dans la phase B (renvoyé par les fonctions concernées).
- L'ordre des `math.random` compte (même graine = même mission) : ne pas déplacer les tirages.

## 4. Logs (dossier `Debug\ATO_FlightPlan_LOG\`)
- `FlightPlan_Check.txt` : `VERDICT` en tête, tableau des règles (G01…I02), globales lues/créées, signature des groupes.
  Règles « i » = simple observation (T01, U04) ; « ! » = alerte ; « ERR » = erreur.
- `FlightPlan_Crash.txt` : seulement si ça plante — message, phase, camp/paquet/rôle/vol, numéro de waypoint, pile d'appels, 30 dernières lignes de `dbg`.
- `FlightPlan_FLIGHT_Debug.lua` : texte de debug du FlightPlan.
- Ligne `|+FPCHK|` dans le log principal pour chaque problème grave.
- Couper le contrôle : `CHECK_ACTIF = false` dans `ATO_FP_Check.lua`.

## 5. Recettes
- **Ajouter une tâche DCS** : écrire un constructeur dans `ATO_FP_20_Tasks.lua` (en-tête = mode d'emploi), l'exporter `AtoFP.Task_xxx`, l'ajouter à la liste `attendu` de `ATO_FP_Check.lua`, faire `local Task_xxx = AtoFP.Task_xxx` dans le fichier qui l'utilise.
- **Modifier une étape** : ouvrir `ATO_FP_60_Loop.lua`, chercher le repère de phase. Nouvelle variable locale de la boucle utilisée → paramètre + argument de l'appel dans `ATO_FlightPlan.lua`. Variable modifiée → la renvoyer (`return`) et l'affecter à l'appel.
- **Déboguer un « nil »** : lire « Globales LUES alors qu'elles n'existent pas » du Check — un nom qui ressemble à une variable locale = paramètre oublié.
- **Après toute modification** : faire une génération et lire le VERDICT. Une fonction manquante ou un pont oublié donne `ECHEC`.

## 6. Comment la réorganisation a été vérifiée (à refaire pour toute extraction)
Outils Python : voir `ATO_FlightPlan_outils.md` (analyseur de variables libres `lua_free.py`, extracteur `extract_range.py`, vérificateurs).
1. Syntaxe Lua 5.1 (`lupa.lua51`, `loadstring`).
2. Variables libres : aucune lecture/écriture nouvelle d'un nom global entre avant/après.
3. Corps de fonction identique à l'original (aux espaces près).
4. Génération réelle + `FlightPlan_Check.txt` → `VERDICT: OK`.

Bugs anciens connus (non corrigés volontairement) : voir `ATO_FlightPlan_TODO.md`.
