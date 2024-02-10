QBCore = exports['qb-core']:GetCoreObject()

local PlayerJob = {}
local Enabled = false

CreateThread(function()
    Wait(10)
    while not QBCore.Functions.GetPlayerData().job do
        Wait(10)
    end

    PlayerJob = QBCore.Functions.GetPlayerData().job
    TriggerServerEvent("fl-activeofficers:server:refresh")
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    TriggerServerEvent("fl-activeofficers:server:refresh")
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobInfo)
    if Enabled then
        if PlayerJob.name ~= "police" then
            SendNUIMessage({ action = "close" })
        end
    end

    TriggerServerEvent("fl-activeofficers:server:refresh")
end)

RegisterNetEvent("fl-activeofficers:client:open")
AddEventHandler("fl-activeofficers:client:open", function(type)
    if type == 'toggle' then
        if Enabled then
            Enabled = false
            SendNUIMessage({ action = 'close' })
            print("close")
        else
            Enabled = true
            SendNUIMessage({ action = 'open' })
            print("open")
        end
    elseif type == 'drag' then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'drag' })
    elseif type == 'force_exit' then
        Enabled = false
        SendNUIMessage({ action = 'close' })
        print("exit")
    end
end)

RegisterNUICallback("Close", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("fl-activeofficers:client:refresh")
AddEventHandler("fl-activeofficers:client:refresh", function(data)
    local id = GetPlayerServerId(PlayerId())
    for i, v in ipairs(data) do
        if v.src == id then
            data[i].me = true
        end
    end

    SendNUIMessage({
        action = 'refresh',
        data = data
    })
end)

RegisterNetEvent('fl-activeofficers:client:removePlayer')
AddEventHandler('fl-activeofficers:client:removePlayer', function(src)
    SendNUIMessage({
        action = "removePlayer",
        data = {
            src = src,
        },
    })
    TriggerServerEvent("fl-activeofficers:server:refresh")
end)

RegisterNetEvent("fl-activeofficers:client:setTalkingOnRadio")
AddEventHandler("fl-activeofficers:client:setTalkingOnRadio", function(src, talking)
    SendNUIMessage({
        action = "setTalkingOnRadio",
        data = {
            src = src,
            talking = talking
        },
    })
end)

RegisterNetEvent("fl-activeofficers:client:setPlayerRadio")
AddEventHandler("fl-activeofficers:client:setPlayerRadio", function(src, channel)
    SendNUIMessage({
        action = "setPlayerRadio",
        data = {
            src = src,
            channel = channel
        },
    })
end)

RegisterCommand("+plist_drag", function()
    TriggerServerEvent('fl-activeofficers:server:open', GetPlayerServerId(PlayerId()), {})
end, false)

RegisterKeyMapping('+plist_drag', 'Opens Active Officers List', Config.ToggleKey['group'], Config.ToggleKey['key'])
