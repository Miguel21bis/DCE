--changes the settings of the campaign according to the user's choice
--[[

**Curseur de longueur de campagne:**
	*elle change la valeur "condition" pour obtenir une defaite ou une victoire, exemple:
		condition = 'GroundTarget["blue"].percent < 45',
		condition = 'Return.TargetAlive("Lar Airbase") < 4 '
	LIMITATIONS:
		-> ne change pas les valeurs de AirUnitReady et AirUnitAlive et ShipHealth
		-> ne sait pas gerer les commandes : OR ou les parentheses : ()
		-> ne prend en compte que < ou <=
	*change le nombre d'avion de reserve, plus il y en a, et plus la campagne dura

**Curseur de difficulté de campagne:**
	*change le skill des 2 camps
		par défaut, celui du joueur est toujours supérieur é l'ENI
		quand le curseur est activé, le coeficient directeur est comme ceci:
		valeur pour le camp AMI
			-- 1 (easy player)		70
			-- 4 (very difficult)	55
		valeur pour le camp ENI
			-- 1 (easy player)		30
			-- 4 (very difficult)	60
		Calculé pour que la valeur 3 soit la valeur par defaut (AMI = 60 ENI = 50)
	
	*change le nombre d'avion ENI ready (et number de reference)
		change le nombre d'avion ENI disponible, plus il y en a, et plus ce sera difficile
		selon une courbe passant par ces points
		1	0.8
		2	0.9
		3	1
		4	1.4
		le resultat (exemple 1.4) est le coeficient
		LIMITATIONS:
			->fonctionne seulement pour les escadrons ayant une ligne reserve, c'est plus simple (nouveau systeme de gestion reserve)
		
**RAZ**
si le joueur repasse (a n'importe quel moment de la campagne) une variable é "false", les valeurs reprennent la valeur d'origine, moins les avions déjé perdu
(sauf les escadrons ayant un escadron de ravitaillement é part, parceque c'est chiant ^^)

**FAQ**
*doit on changer la valeur dans le conf_mod seulement au début de la campagne?
	-> non, é tout moment de la campagne, seul un skipMission sera necessaire

* le RAZ prent'il en compte les pertes anterieur ou remet-il é 0 les pertes et le stock é full?
	-> il prend en compte les pertes antérieur
]]--

------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------- 
-- last modification: cleancode_d
if not versionDCE then versionDCE = {} end
versionDCE["DC_CampaignSettings.lua"] = "1.4.19"
------------------------------------------------------------------------------------------------------- 
-- cleancode_d			(d springCleaning)	
-- adjustment_f			(f InitNumber)(d prend en compte l ancien transfert)(c: slider_PercentPlane)
-- modification M53_b	automatic update of the conf_mod file (b conf_mod reconfiguration)
-- modification M52_f	campaign player's choices  (f bug transfert)(e bug sourceName01) (d: corrige automatic bug CVN & debug CVN)(c: debug)(b: difficulté de campagne)(a: durée de la campagne)
------------------------------------------------------------------------------------------------------- 
if Debug.debug then
	print("START DC_CampaignSettings.lua "..versionDCE["DC_CampaignSettings.lua"].." =-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
end

--[[
PARTIE slider_CampaignDuration ***************************************************************************
]]--

--[[
droite é 2 points
trouver le coeficient directeur
0 = 100
4 = 0
https://calculis.net/droite
]]--

if mission_ini.slider_CampaignDuration and mission_ini.slider_CampaignDuration == true and type(mission_ini.slider_CampaignDuration ~= "number") then
	print()
	print("********************ATTENTION******************")
	print("*************** In the conf_mod file, for the option 'slider_CampaignDuration' we expect as value: 'false' or a value between 1 and 4.****************")
	print("********************ATTENTION******************") os.execute 'pause'
end

local airUnitReinforce = {}										--creation table qui reinforce qui, pour plus de souplesse d emploi


--[[
	change toutes les valeurs des triggers compris dans le fichier trigger_init
	puis ne selectionne que les trigger concernant la victoire ou perte de la campagne
]]--
for name, trig in pairs(camp_triggers) do
	if trig.action and type(trig.action == "table") then
		for n = 1, #trig.action do
			if trig.action[n] == 'Action.CampaignEnd("win")' or  trig.action[n] == 'Action.CampaignEnd("loss")' then
				local EndOne, EndTwo = trig.action[n]:match("([^,]+)\"([^,]+)")
				local EndOne2, winLoss = EndOne:match("([^,]+)\"([^,]+)")
				-- print()
				-- print("DcCS BEFORE  "..tostring(trig.condition))					

				local s = trig.condition

				local delimiter = " and "
				local tempConcat = ""
				for strMatch in (s..delimiter):gmatch("(.-)"..delimiter) do
					-- print("DcCS strMatch  "..tostring(strMatch))
					local trigChanged = false
					if mission_ini.slider_CampaignDuration and type(mission_ini.slider_CampaignDuration == "number") then

						local stringEgal = ""
						local stringAnd = ""
						local one, two = strMatch:match("([^,]+)<([^,]+)")

						if one == nil and two == nil and  string.find(strMatch, "==") then
							one, two = strMatch:match("([^,]+)=([^,]+)")
							-- print("DcCS one  "..tostring(one))
							-- print("DcCS two  "..tostring(two))

							one = one:gsub( "=", "")

						end

						-- si la condition est une addition de plusieurs additions
						-- Return.AirUnitReady("23 TFS")
						local oneNb = 0
						local oneDelimiter = "+"
					

						if two and string.find(two, "=") then
							stringEgal = "="
						end

						--condition = 'GroundTarget["blue"].percent < 45',
						--condition = 'Return.TargetAlive("Lar Airbase") < 4 						
						if one and (string.find(strMatch, "percent") or  string.find(strMatch, "TargetAlive")) then

							--ATTENTION this bug:condition = 'Return.TargetAlive("CVN-71 Theodore Roosevelt") == 0',
							--This good: condition = 'Return.UnitDead("CVN-71 Theodore Roosevelt")',
							--ceci répare un bug récurent dans camp_triggers_init qui tente de trouver le %alive d'un target qui n'existe pas, mais l'unité existe
							if(string.find(strMatch, "CV") and string.find(strMatch, "==")) then

								one:gsub("TargetAlive", "UnitDead" )
								tempConcat = one
								trig.condition = tempConcat

								-- print("DcCS trig.condition "..tostring(trig.condition))
							end
						elseif string.find(strMatch, "AirUnitReady") or string.find(strMatch, "AirUnitAlive")  then

							-- print("DcCS passe 02 strMatch/AirUnitReady/AirUnitAlive "..tostring(strMatch))

							--[[
							two = oneNb - (( oneNb/4) * mission_ini.slider_CampaignDuration)
							
							-- if winLoss == "win" then
								-- two = oneNb - (( oneNb/4) * mission_ini.slider_CampaignDuration)
							-- elseif winLoss == "loss" then
								-- two =  oneNb - (( oneNb/4) * mission_ini.slider_CampaignDuration)														
							-- end							

							if two >= oneNb then two = oneNb - 2 end
							if two <= 0 then two = 2 end
							]]--
						elseif not string.find(strMatch, "ShipHealth") and string.find(strMatch, "<") then
							-- TrigChanged = true
							-- -- print("DcCS passe 03 strMatch/not/ShipHealth "..tostring(strMatch))

							-- two = tonumber(two) * mission_ini.slider_CampaignDuration							
							-- if two >= 100 then
								-- print()
								-- print("********************ATTENTION******************")
								-- print(" "..tostring(strMatch))
								-- print("*************** slider_CampaignDuration: attention, the induced percentage exceeds 100%.****************")
								-- print("********************ATTENTION******************") os.execute 'pause'								
								-- two = 90								
							-- elseif two <= 0 then							
								-- two = 2							
							-- end
						end

						if trigChanged  then
							trig.condition = ""
							tempConcat = one.." <"..stringEgal .." ".. tostring(two).." "

							if string.find(s, " and ") then stringAnd = " and " end
							if trig.condition ~= "" then
								trig.condition = trig.condition..stringAnd..tempConcat
							else
								trig.condition = tempConcat
							end
							--sauvegarde l'etat initial de la condition pour pouvoir la remetre 
							if not trig.InitCondition then
								trig.InitCondition = s
							end
						end

					elseif mission_ini.slider_CampaignDuration == false and trig.InitCondition then
						trig.condition = trig.InitCondition
					end




				end
				-- print("DcCS AFTER  "..tostring(trig.condition))					
				break
			end
		end
	end
end

--recherche le nombre prevu de renfort
--recherche dans les triggers 
--AirUnitReinforce
for _, trigger in pairs(camp_triggers) do
	--action = 'Action.AirUnitReinforce("R/335 TFS", "335 TFS", 6)',
	if trigger.action and type(trigger.action) ~= "table" and type(trigger.action) == "string" and string.find(trigger.action, "Action.AirUnitReinforce")  then

		-- print("DcCS trigger.action "..tostring(trigger.action))
		local sourceName01, destName, dechet02
		local dechet01, sourceName

		if string.find(trigger.action, ",") then
			-- print("DcCS A trigger.action "..tostring(trigger.action))
			sourceName01, destName = trigger.action:match("([^,]+),([^,]+)")
			dechet01, sourceName = sourceName01:match("([^,]+)\"([^,]+)")
		else
			-- print("DcCS B else trigger.action "..tostring(trigger.action))
			destName = trigger.action:gsub( "\"", "")
			sourceName = destName
		end

		sourceName = sourceName:gsub( "\"", "")
		sourceName = sourceName:gsub( "\\(", "")
		destName = destName:gsub( "\"", "")



		if destName ~= nil and  string.find(destName, ",") then
			destName, dechet02 = destName:match("([^,]+),([^,]+)")
			destName = destName:gsub( "\"", "")
		end

		--trim
		destName = string.gsub(destName, '%s+', '')
		destName = string.gsub(destName, '[ \t]+%f[\r\n%z]', '')

		sourceName = string.gsub(sourceName, '%s+', '')
		sourceName = string.gsub(sourceName, '[ \t]+%f[\r\n%z]', '')

		if destName ~=nil and   sourceName ~= nil then
			airUnitReinforce[destName] = sourceName
		end

	end
end

--[[
	change le nombre d'avion de reserve, plus il y en a, et plus la campagne dura
	
	on se base pour une valeur 3 qui correspond aux valeurs de depart de Cef
	
	garde la retroCompatibilité entre les escadron Reserves et la ligne reserve d'un escadron active
]]--
for side,unit in pairs(oob_air) do
	for n = 1, #unit do
		--crée la nouvelle clef transfert
		if not unit[n].roster.trans then
			unit[n].roster.trans = 0
		end

		--creer une clef init qui fera reference
		if not unit[n].InitNumber then
			unit[n].InitNumber = unit[n].number
		end

		if mission_ini.slider_CampaignDuration and type(mission_ini.slider_CampaignDuration == "number") then
			if unit[n].base == 'Reserves' then

				-- --créer une clef init qui fera reference, puisque l'on touchera é celui reserve
				-- if not unit[n].InitNumber then 
				-- 	unit[n].InitNumber = unit[n].number
				-- end										
				unit[n].roster.ready =  math.ceil(( unit[n].InitNumber/3) * mission_ini.slider_CampaignDuration) - unit[n].roster.trans
			elseif unit[n].reserve then

				--créer une clef init qui fera reference, puisque l'on touchera é celui reserve
				if not unit[n].InitReserve then
					unit[n].InitReserve = unit[n].reserve
				end
				unit[n].roster.reserve =  math.ceil(( unit[n].InitReserve/3) * mission_ini.slider_CampaignDuration) - unit[n].roster.trans
			end
		elseif mission_ini.slider_CampaignDuration == false then		--retabli les valeurs d'origine si le joueur le souhaite

			local transfert = 0
			if unit[n].roster.trans then
				transfert = unit[n].roster.trans
			end


			if unit[n].base == 'Reserves'  then
				-- --créer une clef init qui fera reference, puisque l'on touchera é celui reserve
				-- if not unit[n].InitNumber then 
				-- 	unit[n].InitNumber = unit[n].number
				-- end
				unit[n].roster.ready = unit[n].InitNumber - transfert
			elseif unit[n].reserve  then
				--créer une clef init qui fera reference, puisque l'on touchera é celui reserve
				if not unit[n].InitReserve then
					unit[n].InitReserve = unit[n].reserve
				end
				unit[n].roster.reserve =   unit[n].InitReserve - transfert
			end
		end
	end
end
-- end

--[[
PARTIE slider_EnemyLevel ***************************************************************************
]]--
for side , oob_airSide in pairs(oob_air) do														--pour afficher l'exemple de selection du premier avion présenté
	for m , unit in pairs(oob_airSide) do
		if unit.player  then
			TypePlanePlayer = unit.type
			SidePlayer = side
		end
	end
end

-- par défaut, on assigne une valeur superieur au camp du joueur, qu'il soit rouge ou bleu.
for side, wish in pairs(SkillWish) do
	if side == SidePlayer then
		SkillWish[side] = 62
	else
		SkillWish[side] = 50
	end
end


if mission_ini.slider_EnemyLevel and type(mission_ini.slider_EnemyLevel == "number") then
	-- print()
	-- print()
	-- print("DcCSPARTIE slider_EnemyLevel ***************************************************************************")
	-- print("DcCS slider_EnemyLevel:  "..tostring(mission_ini.slider_EnemyLevel))

	for side, wish in pairs(SkillWish) do
		--change la valeur Skill
		if side == SidePlayer then
			-- 1 (easy player)		70
			-- 4 (very difficult)	55
			SkillWish[side] = ((-5 * mission_ini.slider_EnemyLevel) + 75) 									--change la valeur Skill du camp 
		else
			-- 1 (easy player)		30
			-- 4 (very difficult)	60
			SkillWish[side] = ((10 * mission_ini.slider_EnemyLevel) + 20)											--change la valeur Skill du camp adverse
		end

		if SkillWish[side] < 0 then
			SkillWish[side] = 0
		elseif SkillWish[side] > 100 then
			SkillWish[side] = 100
		end
		-- print("DcCS AFTER Skill "..tostring(side).." "..tostring(SkillWish[side]))
	end
end
	--[[
		change le nombre d'avion ENI disponible, plus il y en a, et plus ce sera difficile
		1	0.8
		2	0.9
		3	1
		4	1.3 (1.4)
		
		https://www.dcode.fr/recherche-equation-fonction
		0.13x+0.65
	]]--

for side,unit in pairs(oob_air) do
	if side ~= SidePlayer then
		for n = 1, #unit do
			if not unit[n].roster.trans then
				unit[n].roster.trans = 0
			end
			if unit[n].reserve then
				--créer une clef init qui fera reference, puisque l'on touchera é celui reserve
				if not unit[n].InitNumber then
					unit[n].InitNumber = unit[n].number
				end

				if mission_ini.slider_EnemyLevel and type(mission_ini.slider_EnemyLevel == "number") then

					--change la valeur ready:
					unit[n].roster.ready =  math.floor( unit[n].InitNumber * (mission_ini.slider_EnemyLevel * 0.19 + 0.55)) - unit[n].roster.lost  - unit[n].roster.damaged + unit[n].roster.trans
					--change la valeur number, qui sert de reference pour le recompletement
					unit[n].number =  math.floor( unit[n].InitNumber * (mission_ini.slider_EnemyLevel * 0.19 + 0.55))
				elseif  mission_ini.slider_EnemyLevel == false then


					--change la valeur ready:
					unit[n].roster.ready =   unit[n].InitNumber  - unit[n].roster.lost  - unit[n].roster.damaged + unit[n].roster.trans
					--change la valeur number, qui sert de reference pour le recompletement
					unit[n].number =  unit[n].InitNumber

					-- print("DcCampaignSetting slider_EnemyLevel "..unit[n].name.." InitNumber: "..unit[n].InitNumber.." number: "..unit[n].number)	
				end
			end
		end
	end
end


if mission_ini.slider_PercentPlane and type(mission_ini.slider_PercentPlane == "number") then
	local nbTotalAeronefInit, nbTotalAeronefAfter = 0, 0
	local view_oob_air = DeepCopy(oob_air)
	for side,unit in pairs(oob_air) do
		for n = 1, #unit do
			if 	not unit[n].inactive then

				--créer une clef init qui fera reference, puisque l'on touchera é celui reserve
				if not unit[n].InitNumber then
					unit[n].InitNumber = unit[n].number
				end
				nbTotalAeronefInit = nbTotalAeronefInit + unit[n].InitNumber

				local coef = mission_ini.slider_PercentPlane / 100

				if not unit[n].player then

					local transfert = 0
					if airUnitReinforce[unit[n].name] then
						for Vside, Vunit in pairs(view_oob_air) do
							for m = 1, #Vunit do
								if Vunit[m].name == airUnitReinforce[unit[n].name] then
									transfert = Vunit[m].roster.trans
								end
							end

						end
					else
						transfert = unit[n].roster.trans

					end

					--change la valeur ready:
					unit[n].roster.ready =  math.ceil( unit[n].InitNumber * coef) - (unit[n].roster.lost * coef)  - (unit[n].roster.damaged * coef) + (transfert * coef)
					-- unit[n].roster.ready =  math.ceil( unit[n].InitNumber * coef) - (unit[n].roster.lost)  - (unit[n].roster.damaged ) + (transfert )					
					if unit[n].roster.ready < 0 then
						unit[n].roster.ready = 0
					end
					--change la valeur number, qui sert de reference pour le recompletement
					unit[n].number =  math.ceil( unit[n].InitNumber * coef)
					nbTotalAeronefAfter = nbTotalAeronefAfter + unit[n].number

				end
			end
		end
	end
	-- print("DcCampaignSetting NbTotalAeronefInit: "..NbTotalAeronefInit.." NbTotalAeronefAfter: "..NbTotalAeronefAfter)	

end

