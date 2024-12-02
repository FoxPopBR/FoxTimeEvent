-- File: FoxTimeEventStorage.lua
if FoxTimeEventStorage then return end
FoxTimeEventStorage = {}

local eventsFilePath = "/FoxTimeEvent/active_events.txt"
local counterFilePath = "/FoxTimeEvent/event_counter.txt"

-- Function to verify or create a file
function FoxTimeEventStorage.verifyOrCreateFile(filePath)
    local file = getFileReader(filePath, false)
    if not file then
        local newFile = getFileWriter(filePath, true, false)
        if newFile then
            newFile:write("")
            newFile:close()
            print("File created: " .. filePath)
        else
            print("Error creating file: " .. filePath)
        end
    else
        file:close()
    end
end

-- Function to load events from the file
function FoxTimeEventStorage.loadEvents()
    local events = {}
    FoxTimeEventStorage.verifyOrCreateFile(eventsFilePath)
    local file = getFileReader(eventsFilePath, false)
    if file then
        local line = file:readLine()
        while line do
            if line ~= "" then
                local event = FoxTimeEventStorage.parseEventLine(line)
                if event and event.idprocess and event.data_start and event.data_end then
                    table.insert(events, event)
                else
                    print("[FoxTimeEventStorage] Invalid event ignored: " .. line)
                end
            end
            line = file:readLine()
        end
        file:close()
    else
        print("Error loading events from " .. eventsFilePath)
    end
    return events
end

-- Function to save events to the file
function FoxTimeEventStorage.saveEvents(events)
    local file = getFileWriter(eventsFilePath, false, false)
    if file then
        for _, event in ipairs(events) do
            local idPlayer = tostring(event.idPlayer or "UnknownPlayer")
            local customMessage = tostring(event.customMessage or "customize this msg")
            customMessage = customMessage:sub(1, 50)  -- Limit to 50 characters

            print(string.format("[FoxTimeEventStorage] Saving event: idprocess=%s, idPlayer=%s", event.idprocess, idPlayer))

            local line = string.format("|%s|%s|%s|%s|%s|%s|%s|%s|\n",
                event.idprocess,
                os.date("%Y/%m/%d ((UTC)%H:%M:%S)", os.time()),
                idPlayer,
                table.concat(event.data_start, ","),
                table.concat(event.data_end, ","),
                event.modName,
                event.callbackName,
                customMessage
            )
            file:write(line)
        end
        file:close()
    else
        print("Error saving events to " .. eventsFilePath)
    end
end

-- Function to parse a line from the events file
function FoxTimeEventStorage.parseEventLine(line)
    -- Remove the starting and ending '|' characters
    line = line:sub(2, -2)
    local parts = {}
    for part in string.gmatch(line, "([^|]+)") do
        table.insert(parts, part)
    end

    if #parts >= 8 then
        local event = {
            idprocess = parts[1],
            timestamp = parts[2],
            idPlayer = parts[3],
            data_start = FoxTimeEventStorage.parseTimeTable(parts[4]),
            data_end = FoxTimeEventStorage.parseTimeTable(parts[5]),
            modName = parts[6],
            callbackName = parts[7],
            customMessage = parts[8]
        }
        return event
    else
        print("Invalid event line: " .. line)
        return nil
    end
end

-- Function to convert a time string to a table
function FoxTimeEventStorage.parseTimeTable(timeString)
    local timeParts = {}
    for part in string.gmatch(timeString, "([^,]+)") do
        table.insert(timeParts, tonumber(part))
    end
    return timeParts
end

-- Function to get the event ID counter
function FoxTimeEventStorage.getEventIdCounter()
    FoxTimeEventStorage.verifyOrCreateFile(counterFilePath)
    local file = getFileReader(counterFilePath, false)
    if file then
        local counterString = file:readLine()
        file:close()
        return tonumber(counterString) or 1
    end
    return 1
end

-- Function to save the event ID counter
function FoxTimeEventStorage.saveEventIdCounter(counter)
    local file = getFileWriter(counterFilePath, false, false)
    if file then
        file:write(tostring(counter))
        file:close()
    else
        print("Error saving event counter to " .. counterFilePath)
    end
end
