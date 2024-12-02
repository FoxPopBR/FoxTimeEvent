-- File: FoxTimeEvent.lua

-- Define the mod's namespace
FoxTimeEvent = {}
FoxTimeEvent.events = {}    -- List of scheduled events
FoxTimeEvent.callbacks = {} -- Callback table by event

-- Import required modules
require "FoxTimeEventUtils"
require "FoxTimeEventStorage"
require "FoxTimeEventScheduler"

-- Function to check if an event is already registered for a player and specific date
function FoxTimeEvent.isEventAlreadyRegistered(idPlayer, data_end)
    for _, event in ipairs(FoxTimeEvent.events) do
        if event.idPlayer == idPlayer and table.concat(event.data_end, ",") == table.concat(data_end, ",") then
            return true
        end
    end
    return false
end

-- Public function to register an event with a time interval
function FoxTimeEvent.registerEventWithInterval(addTimeTable, idPlayer, modName, callbackName, customMessage)
    -- Input validation
    if not addTimeTable or type(addTimeTable) ~= "table" then
        error("[FoxTimeEvent] Error: Invalid addTimeTable provided.")
        return nil
    end
    if not idPlayer or idPlayer == "" then
        error("[FoxTimeEvent] Error: idPlayer is required.")
        return nil
    end
    if not modName or modName == "" then
        error("[FoxTimeEvent] Error: modName is required.")
        return nil
    end
    if not callbackName or callbackName == "" then
        error("[FoxTimeEvent] Error: callbackName is required.")
        return nil
    end

    local currentTime = FoxTimeEventUtils.getCurrentGameTime()
    local targetDate = FoxTimeEventUtils.addTimeToCurrent(currentTime, addTimeTable)

    -- Check if the event is already registered
    if FoxTimeEvent.isEventAlreadyRegistered(idPlayer, targetDate) then
        print("[FoxTimeEvent] Event already registered for player: " .. idPlayer)
        return nil
    end

    -- Validate if the callback exists in the global scope
    if not _G[callbackName] then
        print("[FoxTimeEvent] Error: Callback '" .. callbackName .. "' not found in the global scope.")
        return nil
    end

    -- Create the event
    local event = {
        idprocess = FoxTimeEventUtils.generateId(modName),
        idPlayer = idPlayer,
        data_start = currentTime,
        data_end = targetDate,
        modName = modName,
        callbackName = callbackName,
        customMessage = customMessage or "customize this msg"
    }

    -- Add the event to the list and save
    table.insert(FoxTimeEvent.events, event)
    FoxTimeEvent.callbacks[event.idprocess] = _G[callbackName]
    FoxTimeEventUtils.sortEvents(FoxTimeEvent.events)
    FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)

    -- Schedule the next verification
    FoxTimeEventScheduler.scheduleNextVerification()

    -- Return the event information
    return event
end

-- Public function to register an event at a specific date
function FoxTimeEvent.registerEventAtDate(targetDate, idPlayer, modName, callbackName, customMessage)
    -- Input validation
    if not targetDate or type(targetDate) ~= "table" then
        error("[FoxTimeEvent] Error: Invalid targetDate provided.")
        return
    end
    if not idPlayer or idPlayer == "" then
        error("[FoxTimeEvent] Error: idPlayer is required.")
        return
    end
    if not modName or modName == "" then
        error("[FoxTimeEvent] Error: modName is required.")
        return
    end
    if not callbackName or callbackName == "" then
        error("[FoxTimeEvent] Error: callbackName is required.")
        return
    end

    -- Normalize the target date
    targetDate = FoxTimeEventUtils.normalizeTime(
        targetDate[1], targetDate[2], targetDate[3], targetDate[4], targetDate[5]
    )

    -- Check if the event is already registered
    if FoxTimeEvent.isEventAlreadyRegistered(idPlayer, targetDate) then
        print("[FoxTimeEvent] Event already registered for player: " .. idPlayer)
        return
    end

    -- Validate if the callback exists in the global scope
    if not _G[callbackName] then
        print("[FoxTimeEvent] Error: Callback '" .. callbackName .. "' not found in the global scope.")
        return
    end

    -- Create the event
    local event = {
        idprocess = FoxTimeEventUtils.generateId(modName),
        idPlayer = idPlayer,
        data_start = FoxTimeEventUtils.getCurrentGameTime(),
        data_end = targetDate,
        modName = modName,
        callbackName = callbackName,
        customMessage = customMessage or "customize this msg"
    }

    -- Add the event to the list and save
    table.insert(FoxTimeEvent.events, event)
    FoxTimeEvent.callbacks[event.idprocess] = _G[callbackName]
    FoxTimeEventUtils.sortEvents(FoxTimeEvent.events)
    FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)

    -- Schedule the next verification
    FoxTimeEventScheduler.scheduleNextVerification()
    return event
end

-- Initialization function when the game starts
function FoxTimeEvent.init()
    -- Load persisted events
    FoxTimeEvent.events = FoxTimeEventStorage.loadEvents()

    -- Reassociate callbacks
    for _, event in ipairs(FoxTimeEvent.events) do
        if event.callbackName then
            local callbackFunc = _G[event.callbackName]
            if callbackFunc then
                FoxTimeEvent.callbacks[event.idprocess] = callbackFunc
                print("[FoxTimeEvent] Callback reassociated for event ID: " .. event.idprocess)
            else
                print("[FoxTimeEvent] Callback not found for event ID: " .. event.idprocess)
            end
        end
    end

    -- Clean up expired or invalid events
    FoxTimeEvent.cleanupExpiredEvents()
    FoxTimeEvent.cleanupOrphanEvents()

    -- Sort events and schedule the next verification if there are events
    if #FoxTimeEvent.events > 0 then
        FoxTimeEventUtils.sortEvents(FoxTimeEvent.events)
        FoxTimeEventScheduler.scheduleNextVerification()
    end
end

-- Function to clean up expired events
function FoxTimeEvent.cleanupExpiredEvents()
    local currentTime = FoxTimeEventUtils.getCurrentGameTime()
    local validEvents = {}

    for _, event in ipairs(FoxTimeEvent.events) do
        if FoxTimeEventUtils.compareDates(currentTime, event.data_end) == -1 then
            table.insert(validEvents, event)
        else
            print("[FoxTimeEvent] Removing expired event ID: " .. event.idprocess)
            FoxTimeEvent.callbacks[event.idprocess] = nil
        end
    end

    FoxTimeEvent.events = validEvents
    FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)
end

-- Function to clean up events with invalid callbacks
function FoxTimeEvent.cleanupOrphanEvents()
    local validEvents = {}

    for _, event in ipairs(FoxTimeEvent.events) do
        if FoxTimeEvent.callbacks[event.idprocess] then
            table.insert(validEvents, event)
        else
            print("[FoxTimeEvent] Removing event with invalid callback ID: " .. event.idprocess)
        end
    end

    FoxTimeEvent.events = validEvents
    FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)
end

-- Register the initialization function to the OnGameStart event
Events.OnGameStart.Add(FoxTimeEvent.init)

-- Loading message
print("[FoxTimeEvent] FoxTimeEvent.lua script loaded successfully!")
