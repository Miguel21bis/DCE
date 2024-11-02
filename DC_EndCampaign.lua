--To delete mission content and prevent campaign progression if the campaign has ended
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
-- last modification: debug_g
if not versionDCE then versionDCE = {} end
versionDCE["DC_EndCampaign.lua"] = "1.2.7"
------------------------------------------------------------------------------------------------------- 
-- debug_g 			(g bug end campaign)(f mission.maxDictId)(d: EndMission not remove static (FARPS))(c: oldImage)(ab: EndMission)
-- cleanCode_b
-- -------------------------------------------------------------------------------------------------------


if EndCampaign or camp.endCampaign then												--if the campaign has ended
	PlayerFlight = true											--set true to stop mission generation loop in DEBRIEF_Master.lua

	-- ----- unpack template mission file ----
	-- local minizip = require('minizip')

	-- local zipFile = minizip.unzOpen("../" .. camp.title .. "_ongoing.miz", 'rb')

	-- zipFile:unzLocateFile('mission')
	-- local misStr0 = zipFile:unzReadAllCurrentFile()
	-- misStr0 = misStr0:gsub("%(\"ResKey_Action", "(\\\\\"ResKey_Action")
	-- misStr0 = misStr0:gsub("%\"%)", "\\\\\")")

	-- -- local BriefingTmp = StringToTxt(misStr0)
	-- -- local Afile = io.open("Debug/misStr0.txt", "w")										--open targetlist file
	-- -- Afile:write(BriefingTmp)																		--save new data
	-- -- Afile:close()

	-- -- print("DcEC pause debug fucking end mission ")
	-- -- os.execute 'pause'

	-- local misStrFunc = loadstring(misStr0)()

	-- zipFile:unzLocateFile('options')
	-- local optStr = zipFile:unzReadAllCurrentFile()
	-- local optStrFunc = loadstring(optStr)()

	-- zipFile:unzLocateFile('warehouses')
	-- local warStr = zipFile:unzReadAllCurrentFile()
	-- local warStrFunc = loadstring(warStr)()

	-- zipFile:unzLocateFile('l10n/DEFAULT/dictionary')
	-- local dicStr = zipFile:unzReadAllCurrentFile()
	-- local dicStrFunc = loadstring(dicStr)()
	
	-- --a desactiver, sinon les anciennes images apparaissent dans mapResource
	-- -- zipFile:unzLocateFile('l10n/DEFAULT/mapResource')
	-- -- local resStr = zipFile:unzReadAllCurrentFile()
	-- -- local resStrFunc = loadstring(resStr)()

	-- zipFile:unzClose()
	
	if EndCampaign == "win" then
		mission.sortie = "CAMPAIGN VICTORY"
		mission.goals[1].score = 51
		mission.result.offline.actions[1] = 'a_set_mission_result(51)'
	elseif EndCampaign == "draw" then
		mission.sortie = "CAMPAIGN DRAW"
		mission.goals[1].score = 51
		mission.result.offline.actions[1] = 'a_set_mission_result(51)'
	elseif EndCampaign == "loss" then
		mission.sortie = "CAMPAIGN DEFEAT"
		mission.goals[1].score = 49
		mission.result.offline.actions[1] = 'a_set_mission_result(49)'
	end
	
	--remove mission triggers
	for x,v in pairs(mission.trig) do
		v = {}
	end
	mission.trigrules = {}
	
	--remove units
	for side_name,side in pairs(mission.coalition) do			--iterate through sides										
		for country_n,country in pairs(side.country) do			--iterate through contries
			-- country.ship = {}									--remove all ships
			country.vehicle = {}								--remove all vehicles
			-- country.plane = {}									--remove all planes
			-- country.helicopter = {}								--remove all helicopters
			-- country.static = {}									--remove all static
		end
	end
	
	repeat
		local TableRemove = false
		for side_name,side in pairs(mission.coalition) do			--iterate through sides										
			for country_n,country in pairs(side.country) do			--iterate through contries
				if country.plane and country.plane.group  then
					for Ngroup,group in pairs(country.plane.group) do					
						if group.units[1].skill == "Player" or  group.units[1].skill == "Client" then
							-- print("DcEC plane found Player")
						else
							-- print("DcEC plane table.remove "..Ngroup.." name: "..group.name)
							table.remove( country.plane.group, Ngroup)
							TableRemove = true
						end
					end
				end
			end
		end
	until TableRemove == false
	
	repeat
	local TableRemove = false
		for side_name,side in pairs(mission.coalition) do			--iterate through sides										
			for country_n,country in pairs(side.country) do			--iterate through contries
				if country.helicopter and country.helicopter.group  then
					for Ngroup,group in pairs(country.helicopter.group) do					
						if group.units[1].skill == "Player" or  group.units[1].skill == "Client" then
							-- print("DcEC helicopter found Player")
						else
							-- print("DcEC helicopter table.remove "..Ngroup.." name: "..group.name)
							table.remove( country.helicopter.group, Ngroup)
						end
					end
				end			
			end
		end
	until TableRemove == false
		
	 -- ajout du BriefingImagesB/R sauvegardé dans le camp_status en cas de d'attente de generation de mission
	if BriefingImagesB and camp.BriefingImagesB  then
		for iCamp = 1, #camp.BriefingImagesB do 	
			local found = false
			for iBase = 1, #BriefingImagesB do 
				if BriefingImagesB[iBase] == camp.BriefingImagesB[iCamp]  then
					found = true
					break
				end
			end
			if not found then
				table.insert(BriefingImagesB, camp.BriefingImagesB[iCamp])
			end
		end
		camp.BriefingImagesB = nil
	end

	if BriefingImagesR and camp.BriefingImagesR  then
		for iCamp = 1, #camp.BriefingImagesR do 	
			local found = false
			for iBase = 1, #BriefingImagesR do 
				if BriefingImagesR[iBase] == camp.BriefingImagesR[iCamp]  then
					found = true
					break
				end
			end
			if not found then
				table.insert(BriefingImagesR, camp.BriefingImagesR[iCamp])
			end
		end
		camp.BriefingImagesR = nil
	end


	for n = 1, #BriefingImagesB do
		mission.maxDictId = mission.maxDictId + 1
		mapResource["ResKey_ImageBriefing_" .. mission.maxDictId] = BriefingImagesB[n]     --define key in mapResource file
		table.insert(mission.pictureFileNameB, "ResKey_ImageBriefing_" .. mission.maxDictId)  --add picture to blue briefing
	end
	
	for n = 1, #BriefingImagesR do
		mission.maxDictId = mission.maxDictId + 1
		mapResource["ResKey_ImageBriefing_" .. mission.maxDictId] = BriefingImagesB[n]     --define key in mapResource file
		table.insert(mission.pictureFileNameR, "ResKey_ImageBriefing_" .. mission.maxDictId)  --add picture to blue briefing
	end


	mission.descriptionBlueTask = ""							--disable briefing
	mission.descriptionRedTask = ""								--disable briefing
	-- mission.descriptionText = ""
	mission.descriptionText = briefing_status .. "\\n"
	
	-- ----- convert tables back to strings for insertion into content files -----
	-- local misStr = "mission = " .. TableSerialization(mission, 0)
	-- local optStr = "options = " .. TableSerialization(options, 0)
	-- local warStr = "warehouses = " .. TableSerialization(warehouses, 0)
	-- local dicStr = "dictionary = " .. TableSerialization(dictionary, 0)
	-- local resStr = "mapResource = " .. TableSerialization(mapResource, 0)
	-- -- local gciStr = "GCI = " .. TableSerialization(GCI, 0)
	-- local cmpStr = "camp = " .. TableSerialization(camp, 0)

	-- ----- create temporary content files of new mission file -----
	-- local misFile = io.open("misFile.lua", "w")											--mission
	-- misFile:write(misStr)
	-- misFile:close()

	-- local optFile = io.open("optFile.lua", "w")											--options
	-- optFile:write(optStr)
	-- optFile:close()

	-- local warFile = io.open("warFile.lua", "w")											--warehouses
	-- warFile:write(warStr)
	-- warFile:close()

	-- local dicFile = io.open("dicFile.lua", "w")											--dictionary
	-- dicFile:write(dicStr)
	-- dicFile:close()

	-- local resFile = io.open("resFile.lua", "w")											--mapResource
	-- resFile:write(resStr)
	-- resFile:close()

	-- local cmpFile = io.open("Active/camp_status.lua", "w")								--campaign status file
	-- cmpFile:write(cmpStr)
	-- cmpFile:close()
	

	-- miz = minizip.zipCreate("../" .. camp.title .. "_ongoing.miz")
	
	-- miz:zipAddFile("mission", "misFile.lua")
	-- miz:zipAddFile("options", "optFile.lua")
	-- miz:zipAddFile("warehouses", "warFile.lua")
	-- miz:zipAddFile("l10n/DEFAULT/dictionary", "dicFile.lua")
	-- miz:zipAddFile("l10n/DEFAULT/mapResource", "resFile.lua")
	-- miz:zipAddFile("l10n/DEFAULT/EventsTracker.lua", "../../../ScriptsMod."..versionPackageICM.."/Mission Scripts/EventsTracker.lua")

	-- miz:zipAddFile("l10n/DEFAULT/ARM_Defence_Script.lua", "../../../ScriptsMod."..versionPackageICM.."/Mission Scripts/ARM_Defence_Script.lua")
	-- miz:zipAddFile("l10n/DEFAULT/CustomTasksScript.lua", "../../../ScriptsMod."..versionPackageICM.."/Mission Scripts/CustomTasksScript.lua")
	-- miz:zipAddFile("l10n/DEFAULT/CarrierIntoWindScript.lua", "../../../ScriptsMod."..versionPackageICM.."/Mission Scripts/CarrierIntoWindScript.lua")
	-- miz:zipAddFile("l10n/DEFAULT/AddCommandRadioF10.lua", "../../../ScriptsMod."..versionPackageICM.."/Mission Scripts/AddCommandRadioF10.lua")				-- Miguel21 Modification M29
	-- miz:zipAddFile("l10n/DEFAULT/Pedro.lua", "../../../ScriptsMod."..versionPackageICM.."/Mission Scripts/Pedro.lua")				-- Miguel21 Pedro TEST
	-- miz:zipAddFile("l10n/DEFAULT/camp_status.lua", "Active/camp_status.lua")
	-- miz:zipAddFile("l10n/DEFAULT/debugGenMission.txt", "Debug/debugGenMission.txt")
	-- miz:zipAddFile("l10n/DEFAULT/debugFlight.txt", "Debug/debugFlight.txt")
	
	
	-- local BriefingImages = {}
	-- for _i,_filename in ipairs(BriefingImagesB) do	
	-- 	findValue = false
	-- 	for i,filename in ipairs(BriefingImages) do
	-- 		if _filename == filename then findValue = true    break end
	-- 	end
	-- 	if not findValue then
	-- 		table.insert(BriefingImages, _filename)
	-- 	end 
	-- end
	-- for _i,_filename in ipairs(BriefingImagesR) do	
	-- 	findValue = false
	-- 	for i,filename in ipairs(BriefingImages) do
	-- 		if _filename == filename then findValue = true  break end
	-- 	end
	-- 	if not findValue then
	-- 		table.insert(BriefingImages, _filename)
	-- 	end 
	-- end

	-- for i,filename in ipairs(BriefingImages) do											-- Miguel21 M05.b : ajout picture Briefing + pictures Target
	-- 	if type(filename) == "string" and string.len(filename) > 0 then 				-- Miguel21 M05.c : ajout picture Briefing (c: correction path vide)
	-- 		miz:zipAddFile("l10n/DEFAULT/" .. filename, "Images/" .. filename)
	-- 	end
	-- end
	
	-- miz:zipClose()
	
end