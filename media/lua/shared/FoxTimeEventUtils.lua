-- File: FoxTimeEventUtils.lua

FoxTimeEventUtils = {}

-- Function to generate a unique identifier for each event
function FoxTimeEventUtils.generateId(modName)
    local eventIdCounter = FoxTimeEventStorage.getEventIdCounter()
    local id = "id" .. string.format("%09d", eventIdCounter) .. "_" .. modName
    eventIdCounter = eventIdCounter + 1
    FoxTimeEventStorage.saveEventIdCounter(eventIdCounter)
    return id
end

-- Function to get the current game time with adjusted month and day
function FoxTimeEventUtils.getCurrentGameTime()
    local gameTime = getGameTime()
    local adjustedMonth = gameTime:getMonth() + 1  -- Adjust month (0-11 to 1-12)
    local adjustedDay = gameTime:getDay() + 1      -- Adjust day (0-29 to 1-30)
    return {
        gameTime:getYear(),
        adjustedMonth,
        adjustedDay,
        gameTime:getHour(),
        gameTime:getMinutes()
    }
end

-- Function to normalize time, ensuring values are within limits
function FoxTimeEventUtils.normalizeTime(year, month, day, hour, minute)
    -- Adjust minutes and propagate to hours
    if minute >= 60 then
        hour = hour + math.floor(minute / 60)
        minute = minute % 60
    end

    -- Adjust hours and propagate to days
    if hour >= 24 then
        day = day + math.floor(hour / 24)
        hour = hour % 24
    end

    -- Adjust days and propagate to months (30 days per month)
    while day > 30 do
        day = day - 30
        month = month + 1
    end

    -- Adjust months and propagate to years (12 months per year)
    while month > 12 do
        month = month - 12
        year = year + 1
    end

    return {year, month, day, hour, minute}
end

-- Function to add a time interval to the current date
function FoxTimeEventUtils.addTimeToCurrent(currentTime, addTimeTable)
    local year = currentTime[1] + addTimeTable[1]
    local month = currentTime[2] + addTimeTable[2]
    local day = currentTime[3] + addTimeTable[3]
    local hour = currentTime[4] + addTimeTable[4]
    local minute = currentTime[5] + addTimeTable[5]

    return FoxTimeEventUtils.normalizeTime(year, month, day, hour, minute)
end

-- Function to compare two dates
-- Returns -1 if date1 < date2, 0 if equal, 1 if date1 > date2
function FoxTimeEventUtils.compareDates(date1, date2)
    for i = 1, 5 do
        if date1[i] < date2[i] then
            return -1
        elseif date1[i] > date2[i] then
            return 1
        end
    end
    return 0
end

-- Function to check if it's time to trigger the event
function FoxTimeEventUtils.isTimeToTrigger(currentTime, eventTime)
    local comparison = FoxTimeEventUtils.compareDates(currentTime, eventTime)
    return comparison >= 0  -- If currentTime >= eventTime, trigger the event
end

-- Function to calculate the difference in hours between two dates
function FoxTimeEventUtils.calculateHoursDifference(currentTime, eventTime)
    -- Calculate difference in each component
    local yearDiff = eventTime[1] - currentTime[1]
    local monthDiff = eventTime[2] - currentTime[2]
    local dayDiff = eventTime[3] - currentTime[3]
    local hourDiff = eventTime[4] - currentTime[4]
    local minuteDiff = eventTime[5] - currentTime[5]

    -- Adjust negative values and propagate correctly
    if minuteDiff < 0 then
        minuteDiff = minuteDiff + 60
        hourDiff = hourDiff - 1
    end
    if hourDiff < 0 then
        hourDiff = hourDiff + 24
        dayDiff = dayDiff - 1
    end
    if dayDiff < 0 then
        dayDiff = dayDiff + 30  -- Assuming 30 days per month
        monthDiff = monthDiff - 1
    end
    if monthDiff < 0 then
        monthDiff = monthDiff + 12
        yearDiff = yearDiff - 1
    end

    -- Calculate total hours
    local totalHours = yearDiff * 12 * 30 * 24 + monthDiff * 30 * 24 + dayDiff * 24 + hourDiff + minuteDiff / 60

    return totalHours
end

-- Function to sort events by end date (soonest first)
function FoxTimeEventUtils.sortEvents(events)
    table.sort(events, function(a, b)
        return FoxTimeEventUtils.compareDates(a.data_end, b.data_end) == -1
    end)
end
