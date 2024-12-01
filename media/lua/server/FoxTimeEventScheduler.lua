-- Arquivo: FoxTimeEventScheduler.lua

FoxTimeEventScheduler = {}

-- Função para agendar a próxima verificação
function FoxTimeEventScheduler.scheduleNextVerification()
    -- Remover verificações anteriores
    Events.EveryDays.Remove(FoxTimeEventScheduler.verifyNextEvent)
    Events.EveryHours.Remove(FoxTimeEventScheduler.verifyNextEvent)
    Events.EveryTenMinutes.Remove(FoxTimeEventScheduler.verifyNextEvent)
    Events.EveryOneMinute.Remove(FoxTimeEventScheduler.verifyNextEvent)

    if #FoxTimeEvent.events == 0 then
        print("[FoxTimeEventScheduler] Nenhum evento pendente. Verificação suspensa.")
        return
    end

    -- Obter o próximo evento e o tempo atual
    local nextEvent = FoxTimeEvent.events[1]
    local currentTime = FoxTimeEventUtils.getCurrentGameTime()
    local hoursDifference = FoxTimeEventUtils.calculateHoursDifference(currentTime, nextEvent.data_end)

    -- Ajustar a frequência de verificação com base no tempo restante, incluindo margens
    if hoursDifference >= 26 then  -- Margem de 1 hora
        print("[FoxTimeEventScheduler] Verificação agendada para EveryDays.")
        Events.EveryDays.Add(FoxTimeEventScheduler.verifyNextEvent)
    elseif hoursDifference >= 1 + (10/60) + (1/60) then  -- Margem de 11 minutos
        print("[FoxTimeEventScheduler] Verificação agendada para EveryHours.")
        Events.EveryHours.Add(FoxTimeEventScheduler.verifyNextEvent)
    elseif hoursDifference >= (10/60) + (1/60) then  -- Margem de 1 minuto
        print("[FoxTimeEventScheduler] Verificação agendada para EveryTenMinutes.")
        Events.EveryTenMinutes.Add(FoxTimeEventScheduler.verifyNextEvent)
    else
        print("[FoxTimeEventScheduler] Verificação agendada para EveryOneMinute.")
        Events.EveryOneMinute.Add(FoxTimeEventScheduler.verifyNextEvent)
    end
end

-- Função para verificar o próximo evento
function FoxTimeEventScheduler.verifyNextEvent()
    if #FoxTimeEvent.events == 0 then
        return
    end

    local nextEvent = FoxTimeEvent.events[1]
    local currentTime = FoxTimeEventUtils.getCurrentGameTime()

    -- Log para depuração
    print("[FoxTimeEvent] Tempo atual: " .. table.concat(currentTime, ","))
    print("[FoxTimeEvent] Tempo do próximo evento: " .. table.concat(nextEvent.data_end, ","))
    print("[FoxTimeEvent] Verificando se é hora de acionar o evento ID: " .. nextEvent.idprocess)

    if FoxTimeEventUtils.isTimeToTrigger(currentTime, nextEvent.data_end) then
        -- Obter o callback a partir do idprocess
        local callbackFunc = FoxTimeEvent.callbacks[nextEvent.idprocess]
        if callbackFunc then
            callbackFunc(nextEvent)
        else
            print("[FoxTimeEvent] Callback não encontrado para o evento ID: " .. nextEvent.idprocess)
        end

        -- Remover o evento da lista e salvar
        table.remove(FoxTimeEvent.events, 1)
        FoxTimeEvent.callbacks[nextEvent.idprocess] = nil
        FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)
    end

    -- Após a verificação, reagendar a próxima verificação
    FoxTimeEventScheduler.scheduleNextVerification()
end
