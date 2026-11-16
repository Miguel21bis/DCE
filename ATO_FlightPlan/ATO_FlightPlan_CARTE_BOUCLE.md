# Carte de la boucle principale de ATO_FlightPlan.lua

Générée automatiquement à partir de l'analyse du code (fichier d'origine de 8475 lignes). Les numéros de ligne sont ceux de l'ORIGINAL. Rien n'est modifié par ce document.

La boucle est `for sideName` > `for p` (paquets) > `for role` > **`for f` (un vol)** : lignes 1872 à 7592. Le corps de `for f` fait 5708 lignes. C'est lui qu'on découpe.

## 1. Les 10 phases d'un vol

| Phase | Lignes | Taille | Rôle |
|---|---|---|---|
| A | 1884-2380 | 497 | Préparation du vol (type, base, parking, SAR, validation de la tâche) |
| B | 2381-4870 | 2490 | Boucle des waypoints `for w` : route + tâches DCS (coeur de la boucle) |
| C | 4871-5075 | 205 | Après les waypoints : ETA/speed verrouillés, Taxi, CSAR, niveau/skills |
| D | 5076-5422 | 347 | Création des unités `for n` (callsign, sidenumber, loadout, skill, datalink par unité) |
| E | 5423-5572 | 150 | Datalink Link16 / SADL / IDM du vol |
| F | 5573-5712 | 140 | Fréquences + création de la table `group` |
| G | 5713-6062 | 350 | Apparition : deck / air / catapulte / sixpack (`spawnOn`) |
| H | 6063-6924 | 862 | Cas SAR / Intercept / pedro / récupération MP / porte-avions |
| I | 6925-7190 | 266 | Insertion du groupe dans la mission (pays, hélico, joueur) |
| J | 7191-7589 | 399 | Triggers d'activation + infos de debug |

La phase B est à elle seule 2490 lignes (44 % de la boucle). Les phases A, C, E, F, J sont courtes et très reliées au reste ; D, G, H, I sont de taille moyenne.

## 2. Matrice de couplage : quelles variables relient les phases

Pour chaque variable : R = lue, W = réaffectée (`x = ...`), M = contenu modifié (`x.y = ...`, `table.insert(x, ...)`). On ne garde que les variables utilisées dans au moins 2 phases. Une variable dans beaucoup de colonnes, surtout avec W, est ce qui rend le découpage difficile. Lecture seule partout = facile à passer à une fonction.

| Variable | Déclarée | A | B | C | D | E | F | G | H | I | J |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `debugTxt_AtoFP` | fichier L22 |  | RW |  |  |  |  | RW |  |  | RW |
| `baseIsCarrier` | fichier L41 | RW | R |  |  |  |  | R | R | R |  |
| `is_helicopter` | fichier L39 | RW | R |  | R |  |  |  | R | R |  |
| `altRole` | fichier L36 |  | RW |  |  |  |  |  | R |  |  |
| `baseIsFARP` | fichier L40 | RW |  |  |  |  |  | R |  |  |  |
| `playerTask` | fichier L32 | RW |  |  |  |  |  |  | R |  |  |
| `dbg` | fichier L24 | R | R |  | R |  | R | R | R |  |  |
| `parkSarAirBase` | fichier L38 |  | R |  | R |  |  | R | RM |  |  |
| `Get_L16_Id` | fichier L774 |  |  |  |  | R |  |  | R |  |  |
| `Get_SADL_Id` | fichier L828 |  |  |  |  | R |  |  | R |  |  |
| `debugStart` | fichier L21 |  |  |  |  |  |  | R |  |  | R |
| `get_IDM_Id` | fichier L852 |  |  |  |  | R |  |  | R |  |  |
| `modify_Activate_GroupTime` | fichier L1025 |  |  |  |  |  |  | R | R |  |  |
| `pack_IDM_unitId` | fichier L770 |  |  |  |  | RM |  |  | RM |  |  |
| `pack_L16_unitId` | fichier L766 |  |  |  |  | RM |  |  | RM |  |  |
| `pack_SADL_unitId` | fichier L768 |  |  |  |  | RM |  |  | RM |  |  |
| `spawnOn` | fichier L1066 |  |  |  |  |  |  | R | R |  |  |
| `start_time` | vol L1889 | RW | RW |  |  |  | R | RW | RW |  | R |
| `calcWish` | vol L5074 |  |  | RW | RW |  |  |  |  |  |  |
| `infoFlight` | vol L1885 | RW |  |  |  |  |  |  |  |  | RW |
| `totFlightDist` | vol L1886 | RW | RW |  |  |  |  |  |  |  |  |
| `type_withData` | vol L1892 | RW |  |  |  |  | RW |  |  |  |  |
| `isHumain` | vol L1887 | RW | R | R | R |  | R | R | R | R | R |
| `waypoints` | vol L2383 |  | RWM | RM | RM |  | RM | RM | RM |  | R |
| `groupName` | vol L1888 | RW | R |  | R |  | R | R |  | R |  |
| `units` | vol L5062 |  |  | RW | RM | RM | R |  | RM |  | R |
| `group` | vol L5605 |  |  |  |  |  | RWM | RM | RM | RM | R |
| `limitedParkTiming` | vol L1963 | RW |  |  | R |  |  | R | R |  |  |
| `departure_time` | vol L2382 |  | RW |  |  |  |  | R | R |  |  |
| `farp_MorePlace` | vol L1884 | RW |  |  |  |  |  | R | R |  |  |
| `goupTaskTemp` | vol L2191 | RW | R |  |  |  | R |  |  |  |  |
| `navTargetPoints` | vol L2151 | RW | RM |  |  |  | R |  |  |  |  |
| `flagPoints` | vol L2152 | RW | RM |  |  |  |  |  |  |  |  |
| `groupRTB` | vol L6704 |  |  |  |  |  |  |  | RWM | R |  |
| `id_task` | vol L2247 | RW | R |  |  |  |  |  |  |  |  |
| `skillTab` | vol L5054 |  |  | RW | R |  |  |  |  |  |  |
| `typeCible` | vol L2221 | RW | R |  |  |  |  |  |  |  |  |
| `type_withProp` | vol L1893 | RW |  |  | R |  |  |  |  |  |  |
| `weaponType` | vol L2176 | RW | R |  |  |  |  |  |  |  |  |
| `f` | boucle | R | R | R | R | R | R | R | R | R | R |
| `flight` | boucle | R | RM | RM | RM | R | RM | RM | R | RM | R |
| `p` | boucle |  | R |  | R | R | R | R | R | R | R |
| `sideName` | boucle |  |  | R | R |  | R |  | R | R |  |
| `role` | boucle |  | R |  |  |  |  | R | R |  |  |

## 3. Où vit chaque tâche (famille) dans le code

Chaque nombre = une ligne (hors commentaires) qui compare `...task` au nom de la tâche (`if`, `elseif`, `and`, `or`). 'Phase' = la phase où il se trouve. Une tâche éparpillée dans plusieurs phases est plus difficile à rassembler en une fonction.

| Tâche | Nb de tests | Phases | Lignes (`~` = test de différence `~=`) |
|---|---|---|---|
| SAR | 12 | ABFGH | 2079, 2215, 2464, 2467, 2782~, 2802, 5648, 5788~, 6033~, 6064, 6071, 6378 |
| Anti-ship Strike | 9 | ABD | 2213, 2232, 2264, 3219, 3589, 4644, 4670, 4864, 5400 |
| Intercept | 8 | BGH | 2464, 2782~, 2802, 5788~, 6033~, 6272, 6567~, 6586~ |
| Strike | 7 | AB | 2193, 2223, 2228, 2264, 3391, 4644, 4670 |
| AFAC | 6 | ABDF | 2211, 4057, 4274, 5115, 5636, 5659 |
| SEAD | 6 | B | 3013, 3172~, 3199, 3792, 4559, 4670 |
| Refueling | 6 | BDJ | 4252, 4456, 4502, 5129, 5176, 7468 |
| Runway Attack | 4 | AB | 2217, 2234, 3356, 3564 |
| Transport | 4 | BF | 2822, 2823, 2873, 5601 |
| AWACS | 4 | BDHJ | 4231, 5129, 6374, 7468 |
| Escort Jammer | 3 | AB | 2205, 3013, 4162 |
| Flare Illumination | 3 | AB | 2207, 3657, 4670 |
| Laser Illumination | 3 | AB | 2209, 3714, 4670 |
| CSAR | 3 | ABC | 2215, 3764, 5005 |
| CAP | 3 | B | 2680, 4080, 4198 |
| Nothing | 3 | B | 2822, 2823, 2873 |
| Escort | 3 | B | 3895, 4119, 4607 |
| Reconnaissance | 2 | B | 4698, 4721 |
| Fighter Sweep | 1 | B | 3833 |

## 4. Points sensibles repérés

- **Insertion avec position** `table.insert(waypoints, w, ...)` : lignes 2935, 4955. Elle décale la table `waypoints` par rapport à `flight[f].route` : après elle, `waypoints[w]` n'est plus le point `flight[f].route[w]` (le commentaire ligne 2939 : « W == Stacking, W+1 == Land »). C'est LE point à ne pas casser : tout code placé après cette insertion dans la même passe doit voir le même décalage.
- **Bonne nouvelle pour `20_Tasks`** : les tâches DCS sont ajoutées toujours de la même façon, `table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)` : 60 endroits dans la phase B. Chaque tâche construit une `task_entry` (table) puis l'ajoute au waypoint : c'est exactement la forme d'une fonction qui reçoit des paramètres et RETOURNE `task_entry`. C'est le premier candidat, avant même de découper la boucle.
- Le compteur `w` n'est jamais réaffecté dans la boucle `for w` (vérifié) : on peut donc le passer en lecture seule.
- `speed` est réaffectée à de nombreux endroits de la phase B (une quinzaine) : elle doit être rendue par la fonction qui la change. `alreadyTreated` est écrite à la ligne 4188 (phase B).
- Variables du fichier principal (colonne « fichier » de la matrice) : `baseIsCarrier`, `is_helicopter`, `baseIsFARP`, `altRole`, `playerTask`, `parkSarAirBase`, `debugTxt_AtoFP`. Les trois premières sont réaffectées au début de chaque vol (phase A) et lues partout ensuite.