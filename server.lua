QBCore = exports['qb-core']:GetCoreObject()

local pTalking = {}

QBCore.Commands.Add('plist', "Opens Active Officers List (Police Only)", {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        local type = "toggle"
        TriggerEvent("nv:officers:refresh")

        if args[1] == "0" then
            type = "drag"
        end

        TriggerClientEvent("nv:officers:open", src, type)
    end
end)

RegisterNetEvent('pma-voice:setTalkingOnRadio')
AddEventHandler('pma-voice:setTalkingOnRadio', function(talking)
    local src = source
    local channel = GetRadioChannel(src)
    local players = exports['pma-voice']:getPlayersInRadioChannel(channel)

    pTalking[tostring(src)] = talking

    -- Loop all the players in the same radio channel as the current player
    for playerSrc, _ in pairs(players) do
        -- Send them whether he's talking or not
        TriggerClientEvent('nv:officers:setTalkingOnRadio', playerSrc, src, talking)
    end
end)

RegisterNetEvent('pma-voice:setPlayerRadio', function(channel)
    local src = source
    TriggerClientEvent('nv:officers:setPlayerRadio', -1, src, channel)
    TriggerClientEvent('nv:officers:setTalkingOnRadio', -1, src, false)
end)

RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(source)
    Wait(3500) -- Waiting for last player update, dont touch this line
    local src = source
    TriggerClientEvent('nv:officers:removePlayer', -1, src)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    TriggerClientEvent('nv:officers:removePlayer', -1, src)
end)

AddEventHandler('QBCore:Server:OnMetaDataUpdate', function(source, meta, val)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerEvent("nv:officers:refresh")
    end
end)

function GetRadioChannel(source)
    return Player(source).state['radioChannel']
end

RegisterServerEvent("nv:officers:refresh")
AddEventHandler("nv:officers:refresh", function(ch)
    local data = {}
    local src = source

    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player and Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
            local name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
            local grade = Player.PlayerData.job.grade.name;
            local callsign = Player.PlayerData.metadata['callsign'];
            local isTalking = pTalking[tostring(v)] or false
            local channel = 0

            if ch then
                channel = ch
            else
                channel = GetRadioChannel(v)
            end

            table.insert(data, {
                src = v,
                name = name,
                grade = grade,
                channel = channel,
                callsign = callsign,
                isTalking = isTalking,
            })
        else
            TriggerClientEvent("nv:officers:open", v, 'force_exit')
        end
    end

    TriggerClientEvent("nv:officers:refresh", -1, data)
end)
