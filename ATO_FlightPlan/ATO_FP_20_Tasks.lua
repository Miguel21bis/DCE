--=======================================================================================
-- ATO_FP_20_Tasks.lua  (appelé par ATO_FlightPlan.lua, via Include)
-- Fabricants de tâches DCS : chaque fonction construit UNE tâche et la RETOURNE (table).
-- C'est l'appelant qui l'ajoute au waypoint :  table.insert(waypoints[w]["task"]["params"]["tasks"], task_entry)
--
-- Pour ajouter une famille : écrire la fonction ici, l'exporter dans la table AtoFP en bas du fichier,
-- puis la reprendre en local dans ATO_FlightPlan.lua (comme Task_Option).
--=======================================================================================

-- Tâche "Option" (WrappedAction) : réglage d'un comportement de l'IA (réaction aux menaces, largage d'urgence...).
--   tasks    = liste des tâches du waypoint (sert uniquement à numéroter la nouvelle tâche)
--   label    = texte affiché dans l'éditeur de mission
--   optName  = numéro de l'option DCS (1 = réaction aux menaces, 15 = interdiction de largage d'urgence...)
--   optValue = valeur de l'option
--   auto     = true / false (false si absent)
local function Task_Option(tasks, label, optName, optValue, auto)
	return {
		["number"] = #tasks + 1,
		["auto"] = auto or false,
		["id"] = "WrappedAction",
		["name"] = label,
		["enabled"] = true,
		["params"] =
		{
			["action"] =
			{
				["id"] = "Option",
				["params"] =
				{
					["value"] = optValue,
					["name"] = optName,
				},
			},
		},
	}
end

-- Tâche "Script" (WrappedAction) : exécute une commande Lua dans la mission (OrbitPosition, env.info...).
--   command = texte de la commande     label = nom affiché (nil = pas de nom)     auto = true / false (false si absent)
local function Task_Script(tasks, command, label, auto)
	return {
		["number"] = #tasks + 1,
		["auto"] = auto or false,
		["id"] = "WrappedAction",
		["name"] = label,
		["enabled"] = true,
		["params"] =
		{
			["action"] =
			{
				["id"] = "Script",
				["params"] =
				{
					["command"] = command,
				},
			},
		},
	}
end


-- Tâche "EngageTargets" contre les avions (ControlledTask) : Escort, Fighter Sweep, CAP...
--   label = nom affiché (nil = pas de nom)     maxDist = distance maximale d'engagement (mètres)
local function Task_EngageAir(tasks, label, maxDist)
	return {
		["name"] = label,
		["enabled"] = true,
		["auto"] = false,
		["id"] = "ControlledTask",
		["number"] = #tasks + 1,
		["params"] =
		{
			["task"] =
			{
				["enabled"] = true,
				["auto"] = false,
				["id"] = "EngageTargets",
				["params"] =
				{
					["targetTypes"] =
					{
						[1] = "Air",
					},
					["priority"] = 0,
					["value"] = "Air;",
					["noTargetTypes"] =
					{
						[1] = "Cruise missiles",
						[2] = "Antiship Missiles",
						[3] = "AA Missiles",
						[4] = "AG Missiles",
						[5] = "SA Missiles",
					},
					["maxDistEnabled"] = true,
					["maxDist"] = maxDist,
				},
			},
		},
	}
end

-- Tâche "Orbit" (ControlledTask) : tourne en rond jusqu'à l'heure stopTime (secondes).
--   altitude / speed = altitude (m) et vitesse (m/s)     pattern = "Circle" ou "Race-Track"     label = nom affiché (nil = pas de nom)
local function Task_Orbit(tasks, label, altitude, pattern, speed, stopTime)
	return {
		["enabled"] = true,
		["auto"] = false,
		["id"] = "ControlledTask",
		["name"] = label,
		["number"] = #tasks + 1,
		["params"] =
		{
			["task"] =
			{
				["id"] = "Orbit",
				["params"] =
				{
					["altitude"] = altitude,
					["pattern"] = pattern,
					["speed"] = speed,
				},
			},
			["stopCondition"] =
			{
				["time"] = stopTime,
			},
		},
	}
end


-- Tâche "Tanker" ou "AWACS" (ControlledTask) : service actif jusqu'à l'heure stopTime (secondes).
--   serviceId = "Tanker" ou "AWACS"
local function Task_Service(tasks, serviceId, stopTime)
	return {
		["enabled"] = true,
		["auto"] = false,
		["id"] = "ControlledTask",
		["number"] = #tasks + 1,
		["params"] =
		{
			["task"] =
			{
				["id"] = serviceId,
				["params"] = {},
			},
			["stopCondition"] =
			{
				["time"] = stopTime,
			},
		},
	}
end

-- Tâche "CarpetBombing" : bombardement en tapis sur la cible (x, y).
--   expendQty = quantité larguée     weaponType / altitude = type d'arme et altitude d'attaque
local function Task_CarpetBombing(tasks, expendQty, x, y, weaponType, altitude)
	return {
		["enabled"] = true,
		["auto"] = false,
		["id"] = "CarpetBombing",
		["number"] = #tasks + 1,
		["params"] =
		{
			["attackType"] = "Carpet",
			["attackQtyLimit"] = false,
			["attackQty"] = 1,
			["expend"] = tostring(expendQty),
			["y"] = y,
			["x"] = x,
			["carpetLength"] = 500,
			["groupAttack"] = false,
			["altitudeEnabled"] = false,
			["weaponType"] = weaponType,
			["altitude"] = altitude,
		},
	}
end


-- Tâche "AttackGroup" : attaque d'un groupe précis (groupId du groupe cible).
local function Task_AttackGroup(tasks, groupId, weaponType, expend)
	return {
		["enabled"] = true,
		["auto"] = false,
		["id"] = "AttackGroup",
		["number"] = #tasks + 1,
		["params"] =
		{
			["groupId"] = groupId,
			["weaponType"] = weaponType,
			["expend"] = expend,
			["attackQty"] = 1,
			["altitudeEnabled"] = false,
		},
	}
end


-- Tâche "Bombing" (bombardement sur un point x, y). Elle est créée DESACTIVEE (enabled = false), comme à l'origine.
local function Task_Bombing(tasks, x, y, expend, weaponType)
	return {
		["enabled"] = false,
		["auto"] = false,
		["id"] = "Bombing",
		["number"] = #tasks + 1,
		["params"] = {
			["x"] = x,
			["y"] = y,
			["direction"] = 0,
			["attackQtyLimit"] = false,
			["attackQty"] = 1,
			["expend"] = expend,
			["altitude"] = 1524,
			["directionEnabled"] = false,
			["groupAttack"] = true,
			["altitudeEdited"] = true,
			["altitudeEnabled"] = true,
			["weaponType"] = weaponType,
		},
	}
end


-- Tâche "FAC" (AFAC). On lui passe la table waypoints[w]["task"] (et non la liste des tâches) :
-- c'est ce que faisait le code d'origine pour numéroter la tâche.
local function Task_FAC(wpTask)
	return {
		["enabled"] = true,
		["auto"] = true,
		["id"] = "FAC",
		["number"] = #wpTask + 1,
		["params"] =
		{
			["number"] = #wpTask["params"]["tasks"] + 1,
			["designation"] = "Auto",
			["modulation"] = 0,
			["callname"] = 1,
			["datalink"] = true,
		},
	}
end


-- Tâche "Follow" (suivre le groupe) : le groupe suivi et le dernier waypoint sont remplis plus tard par le code appelant.
local function Task_Follow()
	return {
		["enabled"] = true,
		["auto"] = false,
		["id"] = "Follow",
		["name"] = "Follow : (id == IP or Target)",
		["number"] = 1,
		["params"] =
		{
			["lastWptIndexFlagChangedManually"] = true,
			["groupId"] = "toBeDefinedLater",
			["lastWptIndex"] = "toBeDefinedLater",
			["lastWptIndexFlag"] = true,
			["pos"] =
			{
				["y"] = -600,
				["x"] = -600,
				["z"] = -600,
			},
		},
	}
end

--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = =
-- Ce que ce fichier rend à ATO_FlightPlan.lua
AtoFP.Task_Option = Task_Option
AtoFP.Task_Script = Task_Script
AtoFP.Task_EngageAir = Task_EngageAir
AtoFP.Task_Orbit = Task_Orbit
AtoFP.Task_Service = Task_Service
AtoFP.Task_CarpetBombing = Task_CarpetBombing
AtoFP.Task_AttackGroup = Task_AttackGroup
AtoFP.Task_Bombing = Task_Bombing
AtoFP.Task_FAC = Task_FAC
AtoFP.Task_Follow = Task_Follow
