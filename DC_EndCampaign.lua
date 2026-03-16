--To delete mission content and prevent campaign progression if the campaign has ended
--Initiated by MAIN_NextMission.lua
------------------------------------------------------------------------------------------------------- 
if not versionDCE then versionDCE = {} end
versionDCE["DC_EndCampaign.lua"] = "1.2.9"
------------------------------------------------------------------------------------------------------- 
if Debug.debug then
	print("START DC_EndCampaign.lua "..versionDCE["DC_EndCampaign.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

if EndCampaign or camp.endCampaign then												--if the campaign has ended
	PlayerFlight = true											--set true to stop mission generation loop in DEBRIEF_Master.lua

	
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
		
	 -- ajout du BriefingImagesB/R sauvegard� dans le camp_status en cas de d'attente de generation de mission
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
		mapResource["ResKey_ImageBriefing_" .. mission.maxDictId] = BriefingImagesR[n]     --define key in mapResource file
		table.insert(mission.pictureFileNameR, "ResKey_ImageBriefing_" .. mission.maxDictId)  --add picture to blue briefing
	end


	mission.descriptionBlueTask = ""							--disable briefing
	mission.descriptionRedTask = ""								--disable briefing
	-- mission.descriptionText = ""
	mission.descriptionText = Briefing_status .. "\\n"
	
	
end