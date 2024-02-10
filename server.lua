QBCore = exports['qb-core']:GetCoreObject()

local pTalking = {}

QBCore.Commands.Add('plist', "Opens Active Officers List (Police Only)", {}, false, function(source, args)
    TriggerEvent('fl-activeofficers:server:open', source, args)
end)

RegisterServerEvent('fl-activeofficers:server:open', function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        local type = "toggle"
        TriggerEvent("fl-activeofficers:server:refresh")

        if args[1] == "0" then
            type = "drag"
        end

        TriggerClientEvent("fl-activeofficers:client:open", src, type)
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
        TriggerClientEvent('fl-activeofficers:client:setTalkingOnRadio', playerSrc, src, talking)
    end
end)

RegisterNetEvent('pma-voice:setPlayerRadio', function(channel)
    local src = source
    TriggerClientEvent('fl-activeofficers:client:setPlayerRadio', -1, src, channel)
    TriggerClientEvent('fl-activeofficers:client:setTalkingOnRadio', -1, src, false)
end)

RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(source)
    Wait(3500) -- Waiting for last player update, dont touch this line
    local src = source
    TriggerClientEvent('fl-activeofficers:client:removePlayer', -1, src)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    TriggerClientEvent('fl-activeofficers:client:removePlayer', -1, src)
end)

AddEventHandler('QBCore:Server:OnMetaDataUpdate', function(source, meta, val)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerEvent("fl-activeofficers:server:refresh")
    end
end)

function GetRadioChannel(source)
    return Player(source).state['radioChannel']
end

RegisterServerEvent("fl-activeofficers:server:refresh")
AddEventHandler("fl-activeofficers:server:refresh", function(ch)
    local data = {}

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

            table.insert(data, {
                src = 2,
                name = "Mike Smith",
                grade = "Asst. Chief",
                channel = 1,
                callsign = 201,
                isTalking = isTalking,
            })

            table.insert(data, {
                src = 3,
                name = "Josh James",
                grade = "Lieutenant",
                channel = 2,
                callsign = 206,
                isTalking = isTalking,
            })

            table.insert(data, {
                src = 4,
                name = "Jenny Bar",
                grade = "Sergeant",
                channel = 1,
                callsign = 403,
                isTalking = true,
            })

            table.insert(data, {
                src = 5,
                name = "Eli Cohen",
                grade = "Sheriff",
                channel = 1,
                callsign = 400,
                isTalking = isTalking,
            })

            table.insert(data, {
                src = 6,
                name = "Adam Cole",
                grade = "Ranger",
                channel = 4,
                callsign = 511,
                isTalking = isTalking,
            })

            table.insert(data, {
                src = 7,
                name = "Lewis Rhodes",
                grade = "Sergeant",
                channel = 4,
                callsign = 503,
                isTalking = isTalking,
            })

            table.insert(data, {
                src = 8,
                name = "Abby Newman",
                grade = "Officer",
                channel = 1,
                callsign = 263,
                isTalking = true,
            })

            table.insert(data, {
                src = 9,
                name = "Robert Brooks",
                grade = "Deputy",
                channel = 1,
                callsign = 415,
                isTalking = isTalking,
                me = me
            })

            table.insert(data, {
                src = 10,
                name = "Adam Newman",
                grade = "Sn. Officer",
                channel = 1,
                callsign = 265,
                isTalking = isTalking,
            })
            table.insert(data, {
                src = 11,
                name = "Bobbie Banks",
                grade = "Cadet",
                channel = 1,
                callsign = 280,
                isTalking = isTalking,
            })

            table.insert(data, {
                src = 12,
                name = "Donald Banks",
                grade = "Trooper",
                channel = 1,
                callsign = 464,
                isTalking = isTalking,
            })

            table.insert(data, {
                src = 13,
                name = "Robbie Bradley",
                grade = "Sergeant",
                channel = 1,
                callsign = 453,
                isTalking = isTalking,
            })

            table.insert(data, {
                src = 14,
                name = "Mark Gomez",
                grade = "Corporal",
                channel = 1,
                callsign = 458,
                isTalking = isTalking,
            })

            table.insert(data, {
                src = 15,
                name = "Devon Carter",
                grade = "Commander",
                channel = 2,
                callsign = "H-202",
                isTalking = isTalking,
            })
        else
            TriggerClientEvent("fl-activeofficers:client:open", v, 'force_exit')
        end
    end

    TriggerClientEvent("fl-activeofficers:client:refresh", -1, data)
end)
