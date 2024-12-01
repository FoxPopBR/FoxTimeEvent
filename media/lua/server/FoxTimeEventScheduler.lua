-- File: FoxTimeEventScheduler.lua

FoxTimeEventScheduler = {}

-- Function to schedule the next verification
function FoxTimeEventScheduler.scheduleNextVerification()
    -- Remove previous verifications
    Events.EveryDays.Remove(FoxTimeEventScheduler.verifyNextEvent)
    Events.EveryHours.Remove(FoxTimeEventScheduler.verifyNextEvent)
    Events.EveryTenMinutes.Remove(FoxTimeEventScheduler.verifyNextEvent)
    Events.EveryOneMinute.Remove(FoxTimeEventScheduler.verifyNextEvent)

    if #FoxTimeEvent.events == 0 then
        print("[FoxTimeEventScheduler] No pending events. Verification suspended.")
        return
    end

    -- Get the next event and current time
    local nextEvent = FoxTimeEvent.events[1]
    local currentTime = FoxTimeEventUtils.getCurrentGameTime()
    local hoursDifference = FoxTimeEventUtils.calculateHoursDifference(currentTime, nextEvent.data_end)

    -- Adjust verification frequency based on remaining time, including margins
    if hoursDifference >= 26 then  -- Margin of 1 hour
        print("[FoxTimeEventScheduler] Scheduling verification for EveryDays.")
        Events.EveryDays.Add(FoxTimeEventScheduler.verifyNextEvent)
    elseif hoursDifference >= 1 + (10/60) + (1/60) then  -- Margin of 11 minutes
        print("[FoxTimeEventScheduler] Scheduling verification for EveryHours.")
        Events.EveryHours.Add(FoxTimeEventScheduler.verifyNextEvent)
    elseif hoursDifference >= (10/60) + (1/60) then  -- Margin of 1 minute
        print("[FoxTimeEventScheduler] Scheduling verification for EveryTenMinutes.")
        Events.EveryTenMinutes.Add(FoxTimeEventScheduler.verifyNextEvent)
    else
        print("[FoxTimeEventScheduler] Scheduling verification for EveryOneMinute.")
        Events.EveryOneMinute.Add(FoxTimeEventScheduler.verifyNextEvent)
    end
end

-- Function to verify the next event
function FoxTimeEventScheduler.verifyNextEvent()
    if #FoxTimeEvent.events == 0 then
        return
    end

    local nextEvent = FoxTimeEvent.events[1]
    local currentTime = FoxTimeEventUtils.getCurrentGameTime()

    -- Debugging logs
    print("[FoxTimeEvent] Current time: " .. table.concat(currentTime, ","))
    print("[FoxTimeEvent] Next event time: " .. table.concat(nextEvent.data_end, ","))
    print("[FoxTimeEvent] Checking if it's time to trigger event ID: " .. nextEvent.idprocess)

    if FoxTimeEventUtils.isTimeToTrigger(currentTime, nextEvent.data_end) then
        -- Get the callback using idprocess
        local callbackFunc = FoxTimeEvent.callbacks[nextEvent.idprocess]
        if callbackFunc then
            callbackFunc(nextEvent)
        else
            print("[FoxTimeEvent] Callback not found for event ID: " .. nextEvent.idprocess)
        end

        -- Remove the event from the list and save
        table.remove(FoxTimeEvent.events, 1)
        FoxTimeEvent.callbacks[nextEvent.idprocess] = nil
        FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)
    end

    -- Reschedule the next verification
    FoxTimeEventScheduler.scheduleNextVerification()
end
