-- Arquivo: FoxTimeEvent.lua

-- Definir o namespace do mod
FoxTimeEvent = {}
FoxTimeEvent.events = {}    -- Lista de eventos agendados
FoxTimeEvent.callbacks = {} -- Tabela de callbacks por evento

-- Importar módulos necessários
require "FoxTimeEventUtils"
require "FoxTimeEventStorage"
require "FoxTimeEventScheduler"

-- Função para verificar se um evento já está registrado para o jogador e a data específica
function FoxTimeEvent.isEventAlreadyRegistered(idPlayer, data_end)
    for _, evento in ipairs(FoxTimeEvent.events) do
        if evento.idPlayer == idPlayer and table.concat(evento.data_end, ",") == table.concat(data_end, ",") then
            return true
        end
    end
    return false
end

-- Função pública para registrar um evento com acréscimo de tempo
function FoxTimeEvent.registerEventWithInterval(addTimeTable, idPlayer, modName, callbackName, customMessage)
    -- Validação de entrada
    if not addTimeTable or type(addTimeTable) ~= "table" then
        error("[FoxTimeEvent] Erro: addTimeTable inválido fornecido.")
        return
    end
    if not idPlayer or idPlayer == "" then
        error("[FoxTimeEvent] Erro: idPlayer é obrigatório.")
        return
    end
    if not modName or modName == "" then
        error("[FoxTimeEvent] Erro: modName é obrigatório.")
        return
    end
    if not callbackName or callbackName == "" then
        error("[FoxTimeEvent] Erro: callbackName é obrigatório.")
        return
    end

    local currentTime = FoxTimeEventUtils.getCurrentGameTime()
    local targetDate = FoxTimeEventUtils.addTimeToCurrent(currentTime, addTimeTable)

    -- Verificar se o evento já está registrado
    if FoxTimeEvent.isEventAlreadyRegistered(idPlayer, targetDate) then
        print("[FoxTimeEvent] Evento já registrado para o jogador: " .. idPlayer)
        return
    end

    -- Validar se o callback existe no escopo global
    if not _G[callbackName] then
        print("[FoxTimeEvent] Erro: Callback '" .. callbackName .. "' não encontrado no escopo global.")
        return
    end

    -- Criar o evento
    local evento = {
        idprocess = FoxTimeEventUtils.generateId(modName),
        idPlayer = idPlayer,
        data_start = currentTime,
        data_end = targetDate,
        modName = modName,
        callbackName = callbackName,
        customMessage = customMessage or "customize this msg"
    }

    -- Adicionar o evento à lista e salvar
    table.insert(FoxTimeEvent.events, evento)
    FoxTimeEvent.callbacks[evento.idprocess] = _G[callbackName]
    FoxTimeEventUtils.sortEvents(FoxTimeEvent.events)
    FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)

    -- Agendar a próxima verificação
    FoxTimeEventScheduler.scheduleNextVerification()
end

-- Função pública para registrar um evento em uma data específica
function FoxTimeEvent.registerEventAtDate(targetDate, idPlayer, modName, callbackName, customMessage)
    -- Validação de entrada
    if not targetDate or type(targetDate) ~= "table" then
        error("[FoxTimeEvent] Erro: targetDate inválido fornecido.")
        return
    end
    if not idPlayer or idPlayer == "" then
        error("[FoxTimeEvent] Erro: idPlayer é obrigatório.")
        return
    end
    if not modName or modName == "" then
        error("[FoxTimeEvent] Erro: modName é obrigatório.")
        return
    end
    if not callbackName or callbackName == "" then
        error("[FoxTimeEvent] Erro: callbackName é obrigatório.")
        return
    end

    -- Normalizar a data alvo
    targetDate = FoxTimeEventUtils.normalizeTime(
        targetDate[1], targetDate[2], targetDate[3], targetDate[4], targetDate[5]
    )

    -- Verificar se o evento já está registrado
    if FoxTimeEvent.isEventAlreadyRegistered(idPlayer, targetDate) then
        print("[FoxTimeEvent] Evento já registrado para o jogador: " .. idPlayer)
        return
    end

    -- Validar se o callback existe no escopo global
    if not _G[callbackName] then
        print("[FoxTimeEvent] Erro: Callback '" .. callbackName .. "' não encontrado no escopo global.")
        return
    end

    -- Criar o evento
    local evento = {
        idprocess = FoxTimeEventUtils.generateId(modName),
        idPlayer = idPlayer,
        data_start = FoxTimeEventUtils.getCurrentGameTime(),
        data_end = targetDate,
        modName = modName,
        callbackName = callbackName,
        customMessage = customMessage or "customize this msg"
    }

    -- Adicionar o evento à lista e salvar
    table.insert(FoxTimeEvent.events, evento)
    FoxTimeEvent.callbacks[evento.idprocess] = _G[callbackName]
    FoxTimeEventUtils.sortEvents(FoxTimeEvent.events)
    FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)

    -- Agendar a próxima verificação
    FoxTimeEventScheduler.scheduleNextVerification()
end

-- Função para inicializar o mod ao iniciar o jogo
function FoxTimeEvent.init()
    -- Carregar eventos persistidos
    FoxTimeEvent.events = FoxTimeEventStorage.loadEvents()

    -- Reassociar callbacks
    for _, evento in ipairs(FoxTimeEvent.events) do
        if evento.callbackName then
            local callbackFunc = _G[evento.callbackName]
            if callbackFunc then
                FoxTimeEvent.callbacks[evento.idprocess] = callbackFunc
            else
                print("[FoxTimeEvent] Callback não encontrado para o evento ID: " .. evento.idprocess)
            end
        end
    end

    -- Limpar eventos expirados ou inválidos
    FoxTimeEvent.cleanupExpiredEvents()
    FoxTimeEvent.cleanupOrphanEvents()

    -- Ordenar eventos e agendar a próxima verificação, se houver eventos
    if #FoxTimeEvent.events > 0 then
        FoxTimeEventUtils.sortEvents(FoxTimeEvent.events)
        FoxTimeEventScheduler.scheduleNextVerification()
    end
end

-- Função para limpar eventos expirados
function FoxTimeEvent.cleanupExpiredEvents()
    local currentTime = FoxTimeEventUtils.getCurrentGameTime()
    local validEvents = {}

    for _, evento in ipairs(FoxTimeEvent.events) do
        if FoxTimeEventUtils.compareDates(currentTime, evento.data_end) == -1 then
            table.insert(validEvents, evento)
        else
            print("[FoxTimeEvent] Removendo evento expirado ID: " .. evento.idprocess)
            FoxTimeEvent.callbacks[evento.idprocess] = nil
        end
    end

    FoxTimeEvent.events = validEvents
    FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)
end

-- Função para limpar eventos com callbacks inválidos
function FoxTimeEvent.cleanupOrphanEvents()
    local validEvents = {}

    for _, evento in ipairs(FoxTimeEvent.events) do
        if FoxTimeEvent.callbacks[evento.idprocess] then
            table.insert(validEvents, evento)
        else
            print("[FoxTimeEvent] Removendo evento com callback inválido ID: " .. evento.idprocess)
        end
    end

    FoxTimeEvent.events = validEvents
    FoxTimeEventStorage.saveEvents(FoxTimeEvent.events)
end

-- Registrar a função de inicialização no evento OnGameStart
Events.OnGameStart.Add(FoxTimeEvent.init)

-- Mensagem de carregamento
print("[FoxTimeEvent] Script FoxTimeEvent.lua carregado com sucesso!")
