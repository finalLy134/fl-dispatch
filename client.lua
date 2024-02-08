QBCore = exports['qb-core']:GetCoreObject()

local PlayerJob = {}
local Enabled = false

CreateThread(function()
    Wait(10)
    while not QBCore.Functions.GetPlayerData().job do
        Wait(10)
    end

    PlayerJob = QBCore.Functions.GetPlayerData().job
    TriggerServerEvent("nv:officers:refresh")
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    TriggerServerEvent("nv:officers:refresh")
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobInfo)
    if Enabled then
        if PlayerJob.name ~= "police" then
            SendNUIMessage({ action = "close" })
        end
    end

    TriggerServerEvent("nv:officers:refresh")
end)

RegisterNetEvent("nv:officers:open")
AddEventHandler("nv:officers:open", function(type)
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

RegisterNetEvent("nv:officers:refresh")
AddEventHandler("nv:officers:refresh", function(data)
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

RegisterNetEvent('nv:officers:removePlayer')
AddEventHandler('nv:officers:removePlayer', function(src)
    SendNUIMessage({
        action = "removePlayer",
        data = {
            src = src,
        },
    })
    TriggerServerEvent("nv:officers:refresh")
end)

RegisterNetEvent("nv:officers:setTalkingOnRadio")
AddEventHandler("nv:officers:setTalkingOnRadio", function(src, talking)
    SendNUIMessage({
        action = "setTalkingOnRadio",
        data = {
            src = src,
            talking = talking
        },
    })
end)

RegisterNetEvent("nv:officers:setPlayerRadio")
AddEventHandler("nv:officers:setPlayerRadio", function(src, channel)
    SendNUIMessage({
        action = "setPlayerRadio",
        data = {
            src = src,
            channel = channel
        },
    })
end)
