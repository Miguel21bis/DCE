--Header data of the various user files (
--targetList, triggerList, taskList, etc.) 
------------------------------------------------------------------------------------------------------- 

if not versionDCE then versionDCE = {} end
versionDCE["UTIL_Header.lua"] = "1.1.1"

local camp_triggers_header = {
--Initial campaign triggers (static file, not updated)
--Copied to Status/camp_triggers.lua in first mission and subsequently read and updated there
--Campaign triggers are defined with conditions and actions
-------------------------------------------------------------------------------------------------------

--List of Return functions to build conditions:
--Return.Time()												returns time of day in seconds
--Return.Day()												returns day of month
--Return.Month()											returns month as number
--Return.Year()												returns year as number
--Return.Mission()											returns campaign mission number
--Return.CampFlag(flag-n)									returns value of campaign flag
--Return.AirUnitActive("UnitName")							returned boolean whether the air unit is active			
--Return.AirUnitReady("UnitName")							returns amount of ready aircraft in unit
--Return.AirUnitAlive("UnitName")							returns amount of ready and damaged aircraft in unit
--Return.AirUnitBase("UnitName")							returns the name of the airbase the unit operats from
--Return.AirUnitPlayer("UnitName")							returns boolean whether the air units is playable
--Return.TargetAlive("TargetName")							returns percentage of alive sub elements in target
--Return.UnitDead(unitname)									(ADD) return vehicle/ship units dead (ADD)
--Return.GroupHidden("GroupName")							returns group hidden status
--Return.GroupProbability("GroupName")						returns group spawn probability value between 0 and 1
--Return.ShipGroupInPoly(GroupName, PolyZonesTable)			(ADD) return boolean whether ship group is in polygon (ADD)
--Return.PlaceLogistic("AirbaseName")						returns the logistics of a base in weight which can be increased by the landing of transport aircraft or helicopters


--List of Action functions for trigger actions:
--Action.None()																				--void action
--Action.Text("your briefing text")															--add briefing text
--Action.TextPlayMission(arg)																--add trigger text to briefing text of this mission only if it is playable
--Action.SetCampFlag(flag-n, boolean/number)												--set campagn flag to value
--Action.AddCampFlag(flag-n, number)														--add or subtract to campaign flag
--Action.AddImage("filname.jpg")															--add briefing picture
--Action.CampaignEnd("win"/"draw"/"loss")													--end campaign
--Action.TargetActive("TargetName", boolean)												--set target active/inactive
--Action.AirUnitActive("UnitName", boolean)													--set unit active/inactive
--Action.SideBase("side", "BaseName")														--change le camp d'une base, ATTENTION, deplacer les unites avant--Action.SideBase("blue", "Incirlik Airbase")
--Action.AirUnitBase("UnitName", "BaseName")												--set unit base
--Action.AirUnitPlayer("UnitName", boolean)													--set unit playable
--Action.AirUnitReinforce("SourceUnitName", "DestinationUnitName", destNumber)				--send reinforcement aircraft from one unit to another
--Action.AirUnitRepair()																	--repair damaged aircraft in all air units
--Action.GroundUnitRepair()																	-- (ADD) M19.f : Repair Ground
--Action.AddGroundTargetIntel("sideName")													--add ground target intel updates to briefing
--Action.GroupHidden("GroupName", boolean)													--change vehicle/ship group hidden status
--Action.GroupProbability("GroupName", number 0-1)											--change vehicle/ship group probability status
																							--due to the way stats are reset for a new playrun upon completing a FirstMission, groups probability changed by trigger in first mission will not be carried over to second mission! Repeat trigger on second mission or use the trigger from mission 2 on only for flawless function.
--Action.GroupMove(GroupName, ZoneName)														-- (ADD) move vehicle group to refpoint (See the DC_CheckTriggers.lua file for more explanation)
--Action.GroupSlave(GroupName, master, bearing, distance)									-- (ADD)
--Action.ShipMission(GroupName, WPtable, CruiseSpeed, PatrolSpeed, StartTime)				-- (ADD) assign and run a movement mission to a ship group (See the DC_CheckTriggers.lua file for more explanation)
--Action.TemplateActive(TabFile)															-- (ADD) M40 : Template Active GroundGroup moving front (single file : active template) (if tab file: random activation)



--Important notes:
--for condition and action strings: outside with single quotes '', inside with double quotes ""!
}

local targetlist_header = {
-- attributesCond = {
-- op = "AND",
-- { op = "AND", playerSquad = true, category = "helico" },
-- { op = "OR", planeType = { "OH-6A", "OH58D", "UH-1H" } },
-- { op = "OR", squadName = { "160th SOAR Det 1", "US Army 1-6 A" } },
-- },
}

local oob_air = {
--Order of Battle - Aircraft/Helicopter
--organized in units (squadrons/regiments) containing a number of aircraft
--Campaign Version-V20.00

-- Miguel Fichier Revision M42
------------------------------------------------------------------------------------------------------- 

-- miguel21 modification M42 : liveryModex ajoute des Skin lié au numero de l avion
-- Miguel21 modification M33.e 	Custom Briefing (e: divers)
-- ATO_G_adjustment02 TASK Coef


--[[ Unit Entry Example ----------------------------------------------------------------------------

[1] = {
	inactive = true,								--true if unit is not active
	player = true,									--true for player unit
	name = "527 TFS",								--unit name
	type = "F-5E-3",								--aircraft type
	helicopter = true,								--true for helicopter units
	country = "USA",								--unit country
	livery = {"USAF Euro Camo"},					--unit livery
	liveryModex = {									--unit livery Modex  (optional)
		[100] = "VF-101 Dark",
		[110] = "VF-101 Grim Reapers Low Vis",
		},
	base = "Groom Lake AFB",						--unit base
	skill = "Random",								--unit skill
	tasks = {										--list of eligible unit tasks. Note: task names do not necessary match DCS tasks)
		["AWACS"] = true,							
		["Anti-ship Strike"] = true,
		["CAP"] = true,
		["Fighter Sweep"] = true,	
		["Intercept"] = true,
		["Reconnaissance"] = true,
		["Refueling"] = true,
		["Strike"] = true,							--Generic air-ground task (replaces "Ground Attack", "CAS" and "Pinpoint Strike")
		["Transport"] = true,
		["Escort"] = true,							--Support task: Fighter escort for package
		["SEAD"] = true,							--Support task: SEAD escort for package
		["Escort Jammer"] = true,					--Support task: Single airraft in center of package for defensive jamming
		["Flare Illumination"] = true,				--Support task: Illuminate target with flares for package
		["Laser Illumination"] = true,				--Support task: Lase target for package
		["Stand-Off Jammer"] = true,				--Not implemeted yet: On-station jamming
		["Chaff Escort"] = true,					--Not implemented yet: Lay chaff corrdior ahead of package
		["A-FAC"] = true,							--Not implemented yet: Airborne forward air controller
	},
	tasksCoef = {									--unit tasks coef (optional)
		["Strike"] = 1,								-- coef normal : = 1
		["SEAD"] = 1,
		["Laser Illumination"] = 1,
		["Intercept"] = 1,
		["CAP"] = 0.2,
		["Escort"] = 3,
		["Fighter Sweep"] = 1,	
	},
	number = 12,									--number of airframes
	refuelable = false,								--aucun affichage de TACAN ou autre Frequence des TANKER dans le briefing
},

]]-----------------------------------------------------------------------------------------------------
}
