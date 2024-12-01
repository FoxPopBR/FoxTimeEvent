-- Arquivo: FoxTimeEventStorage.lua

FoxTimeEventStorage = {}

local eventsFilePath = "/FoxTimeEvent/eventos_ativos.txt"
local counterFilePath = "/FoxTimeEvent/event_counter.txt"

-- Função para verificar ou criar um arquivo
function FoxTimeEventStorage.verifyOrCreateFile(filePath)
    local file = getFileReader(filePath, false)
    if not file then
        local newFile = getFileWriter(filePath, true, false)
        if newFile then
            newFile:write("")
            newFile:close()
            print("Arquivo criado: " .. filePath)
        else
            print("Erro ao criar o arquivo: " .. filePath)
        end
    else
        file:close()
    end
end

-- Função para carregar eventos do arquivo
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
                    print("[FoxTimeEventStorage] Evento inválido ignorado: " .. line)
                end
            end
            line = file:readLine()
        end
        file:close()
    else
        print("Erro ao carregar os eventos salvos em " .. eventsFilePath)
    end
    return events
end

-- Função para salvar eventos no arquivo
function FoxTimeEventStorage.saveEvents(events)
    local file = getFileWriter(eventsFilePath, false, false)
    if file then
        for _, event in ipairs(events) do
            local idPlayer = tostring(event.idPlayer or "UnknownPlayer")
            local customMessage = tostring(event.customMessage or "customize this msg")
            customMessage = customMessage:sub(1, 50)  -- Limitar a 50 caracteres

            print(string.format("[FoxTimeEventStorage] Salvando evento: idprocess=%s, idPlayer=%s", event.idprocess, idPlayer))

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
        print("Erro ao salvar os eventos em " .. eventsFilePath)
    end
end

-- Função para analisar uma linha do arquivo de eventos
function FoxTimeEventStorage.parseEventLine(line)
    -- Remover os caracteres de início e fim '|'
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
        print("Linha inválida no arquivo de eventos: " .. line)
        return nil
    end
end

-- Função para converter uma string de tempo em uma tabela
function FoxTimeEventStorage.parseTimeTable(timeString)
    local timeParts = {}
    for part in string.gmatch(timeString, "([^,]+)") do
        table.insert(timeParts, tonumber(part))
    end
    return timeParts
end

-- Função para obter o contador de IDs
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

-- Função para salvar o contador de IDs
function FoxTimeEventStorage.saveEventIdCounter(counter)
    local file = getFileWriter(counterFilePath, false, false)
    if file then
        file:write(tostring(counter))
        file:close()
    else
        print("Erro ao salvar o contador de eventos em " .. counterFilePath)
    end
end
