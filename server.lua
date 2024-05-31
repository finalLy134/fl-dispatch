QBCore = exports['qb-core']:GetCoreObject()

local pTalking = {}

QBCore.Commands.Add('plist', "Opens Job Dispatch List", {}, false, function(source, args)
    TriggerEvent('fl-dispatch:server:open', source, args)
end)

RegisterServerEvent('fl-dispatch:server:open', function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if IsJobAllowed(Player.PlayerData.job.name) and Player.PlayerData.job.onduty then
        local type = "toggle"
        TriggerEvent("fl-dispatch:server:refresh")

        if args[1] == "0" then
            type = "drag"
        end

        TriggerClientEvent("fl-dispatch:client:open", src, type)
    end
end)

RegisterNetEvent('pma-voice:setTalkingOnRadio')
AddEventHandler('pma-voice:setTalkingOnRadio', function(talking)
    local src = source
    local channel = GetRadioChannel(src)
    local players = exports['pma-voice']:getPlayersInRadioChannel(channel)

    pTalking[tostring(src)] = talking

    for playerSrc, _ in pairs(players) do
        TriggerClientEvent('fl-dispatch:client:setTalkingOnRadio', playerSrc, src, talking)
    end
end)

RegisterNetEvent('pma-voice:setPlayerRadio', function(channel)
    local src = source
    TriggerClientEvent('fl-dispatch:client:setPlayerRadio', -1, src, channel)
    TriggerClientEvent('fl-dispatch:client:setTalkingOnRadio', -1, src, false)
end)

RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(source)
    Wait(3500)
    local src = source
    TriggerClientEvent('fl-dispatch:client:removePlayer', -1, src)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    TriggerClientEvent('fl-dispatch:client:removePlayer', -1, src)
end)

AddEventHandler('QBCore:Server:OnMetaDataUpdate', function(source, meta, val)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if IsJobAllowed(Player.PlayerData.job.name) and Player.PlayerData.job.onduty then
        TriggerEvent("fl-dispatch:server:refresh")
    end
end)

function GetRadioChannel(source)
    return Player(source).state['radioChannel']
end

RegisterServerEvent("fl-dispatch:server:refresh")
AddEventHandler("fl-dispatch:server:refresh", function(ch)
    local data = {}

    for _, job in ipairs(Config.Jobs) do
        local jobData = {
            job = job,
            players = {}
        }

        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)
            if Player and Player.PlayerData.job.name == job and Player.PlayerData.job.onduty then
                local name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
                local grade = Player.PlayerData.job.grade.name
                local callsign = Player.PlayerData.metadata['callsign']
                local isTalking = pTalking[tostring(v)] or false
                local channel = 0

                if ch then
                    channel = ch
                else
                    channel = GetRadioChannel(v)
                end

                table.insert(jobData.players, {
                    src = v,
                    name = name,
                    grade = grade,
                    channel = channel,
                    callsign = callsign,
                    isTalking = isTalking,
                })
            end
        end

        table.insert(data, jobData)
    end

    TriggerClientEvent("fl-dispatch:client:refresh", -1, data)
end)

function IsJobAllowed(job)
    for _, allowedJob in ipairs(Config.Jobs) do
        if allowedJob == job then
            return true
        end
    end
    return false
end
