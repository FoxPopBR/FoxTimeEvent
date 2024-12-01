-- Arquivo: FoxTimeEventUtils.lua

FoxTimeEventUtils = {}

-- Função para gerar um identificador único para cada evento
function FoxTimeEventUtils.generateId(modName)
    local eventIdCounter = FoxTimeEventStorage.getEventIdCounter()
    local id = "id" .. string.format("%09d", eventIdCounter) .. "_" .. modName
    eventIdCounter = eventIdCounter + 1
    FoxTimeEventStorage.saveEventIdCounter(eventIdCounter)
    return id
end

-- Função para obter o tempo atual do jogo com ajuste de mês e dia
function FoxTimeEventUtils.getCurrentGameTime()
    local gameTime = getGameTime()
    local adjustedMonth = gameTime:getMonth() + 1  -- Ajuste de mês (0-11 para 1-12)
    local adjustedDay = gameTime:getDay() + 1      -- Ajuste de dia (0-29 para 1-30)
    return {
        gameTime:getYear(),
        adjustedMonth,
        adjustedDay,
        gameTime:getHour(),
        gameTime:getMinutes()
    }
end

-- Função para normalizar o tempo, garantindo que os valores estejam dentro dos limites
function FoxTimeEventUtils.normalizeTime(year, month, day, hour, minute)
    -- Ajustar minutos e propagar para horas
    if minute >= 60 then
        hour = hour + math.floor(minute / 60)
        minute = minute % 60
    end

    -- Ajustar horas e propagar para dias
    if hour >= 24 then
        day = day + math.floor(hour / 24)
        hour = hour % 24
    end

    -- Ajustar dias e propagar para meses (30 dias por mês)
    while day > 30 do
        day = day - 30
        month = month + 1
    end

    -- Ajustar meses e propagar para anos (12 meses por ano)
    while month > 12 do
        month = month - 12
        year = year + 1
    end

    return {year, month, day, hour, minute}
end

-- Função para adicionar um intervalo de tempo à data atual
function FoxTimeEventUtils.addTimeToCurrent(currentTime, addTimeTable)
    local year = currentTime[1] + addTimeTable[1]
    local month = currentTime[2] + addTimeTable[2]
    local day = currentTime[3] + addTimeTable[3]
    local hour = currentTime[4] + addTimeTable[4]
    local minute = currentTime[5] + addTimeTable[5]

    return FoxTimeEventUtils.normalizeTime(year, month, day, hour, minute)
end

-- Função para comparar duas datas
-- Retorna -1 se date1 < date2, 0 se iguais, 1 se date1 > date2
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

-- Função para verificar se é hora de acionar o evento
function FoxTimeEventUtils.isTimeToTrigger(currentTime, eventTime)
    local comparison = FoxTimeEventUtils.compareDates(currentTime, eventTime)
    return comparison >= 0  -- Se currentTime >= eventTime, é hora de acionar
end

-- Função para calcular a diferença em horas entre duas datas
function FoxTimeEventUtils.calculateHoursDifference(currentTime, eventTime)
    -- Calcula a diferença em cada componente
    local yearDiff = eventTime[1] - currentTime[1]
    local monthDiff = eventTime[2] - currentTime[2]
    local dayDiff = eventTime[3] - currentTime[3]
    local hourDiff = eventTime[4] - currentTime[4]
    local minuteDiff = eventTime[5] - currentTime[5]

    -- Ajustar valores negativos e propagar corretamente
    if minuteDiff < 0 then
        minuteDiff = minuteDiff + 60
        hourDiff = hourDiff - 1
    end
    if hourDiff < 0 then
        hourDiff = hourDiff + 24
        dayDiff = dayDiff - 1
    end
    if dayDiff < 0 then
        dayDiff = dayDiff + 30  -- Supondo 30 dias por mês
        monthDiff = monthDiff - 1
    end
    if monthDiff < 0 then
        monthDiff = monthDiff + 12
        yearDiff = yearDiff - 1
    end

    -- Calcular total de horas
    local totalHours = yearDiff * 12 * 30 * 24 + monthDiff * 30 * 24 + dayDiff * 24 + hourDiff + minuteDiff / 60

    return totalHours
end

-- Função para ordenar os eventos por data de término (mais próximo primeiro)
function FoxTimeEventUtils.sortEvents(events)
    table.sort(events, function(a, b)
        return FoxTimeEventUtils.compareDates(a.data_end, b.data_end) == -1
    end)
end
