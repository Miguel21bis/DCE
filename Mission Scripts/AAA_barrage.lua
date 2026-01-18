-- Targeted flak barrage that follows a specified COALITION's aircraft,
-- ONLY fires when the target aircraft is INSIDE a named trigger zone.
-- Up to MAX_SIMULTANEOUS_TARGETS aircraft can be engaged at once,
-- spread across EMITTERS, with sticky targeting to avoid constant retarget jitter.
-------------------------------------------------------------------------------------------------------
-- Grateful thanks to Bandit648 for allowing the use and adaptation of his mod. 
-- His work delivers a true FPS‑like solution with immersive flak effects.
-------------------------------------------------------------------------------------------------------
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/AAA_barrage.lua"] = "1.1.2"
-------------------------------------------------------------------------------------------------------

env.info("DCE START LOADING AAA_barrage.lua " .. tostring(versionDCE["Mission Scripts/AAA_barrage.lua"]))

env.info("AAA_barrage START ")

-- Which coalition to target:
local TARGET_COALITION         = coalition.side.BLUE -- coalition.side.RED

-- Zone restriction:
local FIRE_ONLY_IN_ZONE        = true

-- (Optional) prefer airplanes, then helicopters if no airplanes exist
local PREFER_AIRPLANES         = true

-- Density / pattern
local EMITTERS                 = 6   -- number of parallel emitters (set to 6 to match your goal)
local EVENT_MIN_DT             = 0.5 -- seconds between events per emitter
local EVENT_MAX_DT             = 1.1
local CLUSTER_MIN              = 4   -- bursts per event
local CLUSTER_MAX              = 4
local CLUSTER_RADIUS_M         = 160 -- burst spread around event center (meters)

-- Offset / aim around the aircraft
local AIM_RADIUS_M             = 450 -- how far from the aircraft the event center can be
local LEAD_SECONDS             = 0.6 -- lead target based on velocity (0 to disable)

-- Altitude behavior
local ALTITUDE_MODE            = "MSL" -- "MSL" or "AGL"
local ALT_JITTER_M             = 120   -- +/- meters around target altitude
local ALT_MIN_MSL              = 200   -- clamp for safety (MSL meters)
local ALT_MAX_MSL              = 12000

-- Explosion strength
local POWER_MIN                = 4
local POWER_MAX                = 12

-- Multi-target behavior
local MAX_SIMULTANEOUS_TARGETS = 6     -- cap number of distinct aircraft we engage at once
local STICKY_TARGET_SECONDS    = 3.0   -- how long each emitter keeps its chosen aircraft before retargeting
local ALLOW_SAME_TARGET        = false -- if false, emitters will try to avoid sharing targets

-- Debug
local DEBUG_TEXT               = false

local aaaZones                 = {}

for zoneN, zone in pairs(env.mission.triggers.zones) do
	env.info("AAA_barrage A :check zone name " .. tostring(zone.name))
	if string.sub(zone.name, 1, 9) == "AAA_ZONE_" then
		aaaZones[#aaaZones + 1] = zone.name
		env.info("AAA_barrage B :is  AAA_ZONE_: " .. tostring(zone.name))
	end
end

if #aaaZones == 0 then
	trigger.action.outText("FLAK: No AAA_ZONE_* found in mission", 10)
    env.info("AAA_barrage FLAK: No AAA_ZONE_* found in mission ")
else
	env.info("AAA_barrage FLAK: nb AAA_ZONE_* found in mission " .. tostring(#aaaZones))
end


-- ---------- helpers ----------
local function clamp(v, lo, hi)
	if v < lo then return lo end
	if v > hi then return hi end
	return v
end

local function randInCircle(radius)
	local r = radius * math.sqrt(math.random())
	local t = 2 * math.pi * math.random()
	return r * math.cos(t), r * math.sin(t)
end

local function getGroupsSafe(side, cat)
	local ok, groups = pcall(coalition.getGroups, side, cat)
	if not ok then return nil end
	return groups
end

local function isPointInZoneXZ(x, z, zone)
	if not zone or not zone.point or not zone.radius then return false end
	local dx = x - zone.point.x
	local dz = z - zone.point.z
	return (dx * dx + dz * dz) <= (zone.radius * zone.radius)
end

local function spawnExplosionAt(x, z, altMSL, power)
	trigger.action.explosion({ x = x, y = altMSL, z = z }, power)
end


local function createAAAZone(zoneName)
	local ZONE = trigger.misc.getZone(zoneName)
	local emitterState = {}

	-- Choose up to MAX_SIMULTANEOUS_TARGETS distinct units from eligible list (stable-ish order)
	local function pickEngagementSet(eligible)
		local picked = {}
		local used = {}

		-- First: keep any currently-sticky targets that are still eligible
		for id = 1, EMITTERS do
			local st = emitterState[id]
			if st and st.unitName then
				for _, u in ipairs(eligible) do
					if u:getName() == st.unitName and not used[st.unitName] then
						picked[#picked + 1] = u
						used[st.unitName] = true
						break
					end
				end
			end
			if #picked >= MAX_SIMULTANEOUS_TARGETS then break end
		end

		-- Then: fill remaining slots with other eligible aircraft
		if #picked < MAX_SIMULTANEOUS_TARGETS then
			for _, u in ipairs(eligible) do
				local name = u:getName()
				if not used[name] then
					picked[#picked + 1] = u
					used[name] = true
					if #picked >= MAX_SIMULTANEOUS_TARGETS then break end
				end
			end
		end

		return picked
	end

    local function pickTargetForEmitter(emitterId, engagementSet, t, reservedNames)
        local st = emitterState[emitterId]
        if st and st.unitName and st.untilT and t < st.untilT then
            -- Try to keep sticky target if still in engagement set and not reserved
            for _, u in ipairs(engagementSet) do
                if u:getName() == st.unitName then
                    if (not reservedNames) or (not reservedNames[st.unitName]) then
                        return u
                    end
                end
            end
        end

        -- Pick a new one from engagement set (prefer unreserved)
        if #engagementSet == 0 then return nil end

        if reservedNames and (not ALLOW_SAME_TARGET) then
            for _, u in ipairs(engagementSet) do
                local name = u:getName()
                if not reservedNames[name] then
                    emitterState[emitterId] = { unitName = name, untilT = t + STICKY_TARGET_SECONDS }
                    return u
                end
            end
        end

        -- Fallback: allow sharing or no unreserved available
        local u = engagementSet[math.random(1, #engagementSet)]
        emitterState[emitterId] = { unitName = u:getName(), untilT = t + STICKY_TARGET_SECONDS }
        return u
    end
	

	-- Return a list of eligible aircraft units (alive; if zone restricted, inside zone)
	local function getEligibleAircraft(side)
		local results = {}

		local cats = {}
		if PREFER_AIRPLANES then
			cats = { Group.Category.AIRPLANE, Group.Category.HELICOPTER }
		else
			cats = { Group.Category.HELICOPTER, Group.Category.AIRPLANE }
		end

		for _, cat in ipairs(cats) do
			local groups = getGroupsSafe(side, cat)
			if groups then
				for _, g in ipairs(groups) do
					if g and g:isExist() then
						local units = g:getUnits()
						if units then
							for _, u in ipairs(units) do
								if u and u:isExist() and u:getLife() > 0 then
									if FIRE_ONLY_IN_ZONE then
										if ZONE then
											local p = u:getPoint()
											if isPointInZoneXZ(p.x, p.z, ZONE) then
												results[#results + 1] = u
											end
										end
									else
										results[#results + 1] = u
									end
								end
							end
						end
					end
				end
			end
		end

		return results
	end

	-- Build target state from a unit (returns nil if not eligible now)
	local function buildTargetState(u)
		if not u or (not u:isExist()) or u:getLife() <= 0 then return nil end

		local p = u:getPoint()
		local v = u:getVelocity() or { x = 0, y = 0, z = 0 }

		-- Zone safety check (in case target moved out while sticky)
		if FIRE_ONLY_IN_ZONE and ZONE then
			if not isPointInZoneXZ(p.x, p.z, ZONE) then
				return nil
			end
		end

		-- Lead the burst center slightly in front of the aircraft
		local leadX, leadZ = 0, 0
		if LEAD_SECONDS and LEAD_SECONDS > 0 then
			leadX = v.x * LEAD_SECONDS
			leadZ = v.z * LEAD_SECONDS
		end

		-- Determine target altitude for bursts (explosions require MSL)
		local targetAltMSL = p.y
		if ALTITUDE_MODE == "AGL" then
			local ground = land.getHeight({ x = p.x, y = 0, z = p.z })
			targetAltMSL = ground + (p.y - ground)
		end

		local g = u:getGroup()
		return {
			x = p.x + leadX,
			z = p.z + leadZ,
			altMSL = targetAltMSL,
			unitName = u:getName(),
			groupName = (g and g:getName()) or "unknown",
		}
	end

	-- ---------- emitter ----------
	local function makeEmitter(emitterId)
		return function(_, t)
			-- Fail safe: if zone restriction enabled but zone missing, no fire
			if FIRE_ONLY_IN_ZONE and (not ZONE) then
				if DEBUG_TEXT then
					trigger.action.outText("FLAK: Zone restriction enabled but zone not found, holding fire.", 2)
					env.info("AAA_barrage FLAK: Zone restriction enabled but zone not found, holding fire.")
				end
				return t + 2
			end

			local eligible = getEligibleAircraft(TARGET_COALITION)
			if #eligible == 0 then
				if DEBUG_TEXT then
					local sideName = (TARGET_COALITION == coalition.side.BLUE and "BLUE")
						or (TARGET_COALITION == coalition.side.RED and "RED")
						or tostring(TARGET_COALITION)
					if FIRE_ONLY_IN_ZONE and ZONE then
						trigger.action.outText("FLAK: No eligible " .. sideName .. " aircraft in zone, holding fire.", 2)
						env.info("AAA_barrage FLAK: No eligible " .. sideName .. " aircraft in zone, holding fire.")
					else
						trigger.action.outText("FLAK: No alive aircraft found for coalition " .. sideName, 2)
						env.info("AAA_barrage FLAK: No alive aircraft found for coalition " .. tostring(sideName))
					end
				end
				emitterState[emitterId] = nil
                return t + 1.0
            else
				env.info("AAA_barrage FLAK: #eligible " .. tostring(#eligible))
			end

			-- Cap how many aircraft we engage at once (<= 6)
			local engagementSet = pickEngagementSet(eligible)

			-- Reserve other emitters' sticky targets (best-effort deconfliction)
			local reserved = {}
			if not ALLOW_SAME_TARGET then
				for id, st in pairs(emitterState) do
					if id ~= emitterId and st and st.unitName and st.untilT and t < st.untilT then
						reserved[st.unitName] = true
					end
				end
			end

			local unit = pickTargetForEmitter(emitterId, engagementSet, t, reserved)
			if not unit then
				emitterState[emitterId] = nil
				env.info("AAA_barrage FLAK: return not unit " .. tostring(t + 0.25))
				return t + 0.25
			end

			local tgt = buildTargetState(unit)
			if not tgt then
                -- Target moved/died/out of zone; drop sticky and retry soon
				env.info("AAA_barrage FLAK: return not tgt " .. tostring(t + 0.25))
				emitterState[emitterId] = nil
				return t + 0.25
			end

			-- Choose an event center near the aircraft
			local ox, oz = randInCircle(AIM_RADIUS_M)
			local cx, cz = tgt.x + ox, tgt.z + oz

			-- Cluster bursts
            local n = math.random(CLUSTER_MIN, CLUSTER_MAX)
			env.info("AAA_barrage FLAK: Cluster bursts " .. tostring(n))
			for _ = 1, n do
				local dx, dz = randInCircle(CLUSTER_RADIUS_M)

				local alt = tgt.altMSL + math.random(-ALT_JITTER_M, ALT_JITTER_M)
				alt = clamp(alt, ALT_MIN_MSL, ALT_MAX_MSL)

                local power = math.random(POWER_MIN, POWER_MAX)
				env.info("AAA_barrage FLAK: spawnExplosionAt, power: " .. tostring(power))
				spawnExplosionAt(cx + dx, cz + dz, alt, power)
			end

			if DEBUG_TEXT then
				trigger.action.outText(
					string.format("FLAK E%d: %d bursts near %s (%s) @ ~%.0fm MSL in zone %s",
						emitterId, n, tgt.unitName, tgt.groupName, tgt.altMSL, zoneName),
					1)
				env.info("AAA_barrage " .. string.format("FLAK E%d: %d bursts near %s (%s) @ ~%.0fm MSL in zone %s",
					emitterId, n, tgt.unitName, tgt.groupName, tgt.altMSL, zoneName))
			end

			return t + (EVENT_MIN_DT + math.random() * (EVENT_MAX_DT - EVENT_MIN_DT))
		end
	end

	for i = 1, EMITTERS do
		timer.scheduleFunction(makeEmitter(i), nil, timer.getTime() + 1 + (i * 0.15))
	end
end

for _, name in ipairs(aaaZones) do
    createAAAZone(name)
end

env.info("AAA_barrage loading complete")
