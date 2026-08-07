

function Disp_time(time)
	local days = math.floor(time/86400)
	local hours = math.floor((time% 86400)/3600)
	local minutes = math.floor((time%3600)/60)
	local seconds = math.floor((time%60))
	return string.format("%d days %02d hours",days,hours)
  end


--function to return various date and time formats of a number in seconds
function FormatTime(t, form)
    local day = math.floor(t / 86400)
    local hour = math.floor((t % 86400) / 3600)
    local minute = math.floor((t % 3600) / 60)
    local second = math.floor(t % 60)

    local dayStr = string.format("%02d", day)
    local hourStr = string.format("%02d", hour + day * 24) -- total heures pour hh:mm
    local hourOnlyStr = string.format("%02d", hour)
    local minuteStr = string.format("%02d", minute)
    local secondStr = string.format("%02d", second)

    if form == "dd:hh:mm" then
        return dayStr .. "d " .. hourOnlyStr .. "h" .. minuteStr
    elseif form == "hh:mm" then
        return hourStr .. "h" .. minuteStr
    elseif form == "hh:mm:ss" then
        return hourStr .. "h" .. minuteStr .. "mn " .. secondStr
    end
end



--function to format date
function FormatDate(day, month, year)
	if month == 1 then
		month = "January"
	elseif month == 2 then
		month = "February"
	elseif month == 3 then
		month = "March"
	elseif month == 4 then
		month = "April"
	elseif month == 5 then
		month = "May"
	elseif month == 6 then
		month = "June"
	elseif month == 7 then
		month = "July"
	elseif month == 8 then
		month = "August"
	elseif month == 9 then
		month = "September"
	elseif month == 10 then
		month = "October"
	elseif month == 11 then
		month = "November"
	elseif month == 12 then
		month = "December"
	end

	return month .. " " .. day .. ", " .. year
end

-- Convertit une date en "nombre absolu de jours" depuis 1/1/0001
function dateToAbsoluteDays(y, m, d)
    local monthDays = {31,28,31,30,31,30,31,31,30,31,30,31}

    local function isLeap(year)
        return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
    end

    local days = d

    -- Ajouter les jours des mois précédents
    for i = 1, m - 1 do
        days = days + monthDays[i]
        if i == 2 and isLeap(y) then
            days = days + 1
        end
    end

    -- Ajouter les jours des années précédentes
    for year = 1, y - 1 do
        days = days + (isLeap(year) and 366 or 365)
    end

    return days
end

function SecondsBetween(date1, date2)
    local abs1 = dateToAbsoluteDays(date1.year, date1.month, date1.day)
    local abs2 = dateToAbsoluteDays(date2.year, date2.month, date2.day)

    local deltaDays = math.abs(abs2 - abs1)
    return deltaDays * 24 * 3600
end



function ExtractDateFromCondition(condition)
	local day = condition:match("camp%.date%.day%s*[<>=]+%s*(%d+)")
	local month = condition:match("camp%.date%.month%s*[<>=]+%s*(%d+)")
	local year = condition:match("camp%.date%.year%s*[<>=]+%s*(%d+)")
	if day and month and year then
		return { day = tonumber(day), month = tonumber(month), year = tonumber(year) }
	end
	return nil
end
