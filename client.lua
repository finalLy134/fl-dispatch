local QBCore = exports['qb-core']:GetCoreObject()

local Enabled = false

CreateThread(function()
    while QBCore == nil do
        Wait(1)
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
    end

    while not QBCore.Functions.GetPlayerData().job do
        Wait(1)
    end

    TriggerServerEvent("nv:officers:refresh")
end)

CreateThread(function()
    while true do
        Wait(2)
        if QBCore.Functions.GetPlayerData().job.name == "police" then
            if IsControlJustPressed(1, 83) then
                TriggerEvent("nv:officers:open", 'drag')
            end
            if IsControlJustPressed(1, 84) then
                TriggerEvent("nv:officers:open", 'toggle')
            end
        end
    end
end)

-- Refresh Menu --
CreateThread(function()
    while true do
        Wait(3000)
        TriggerServerEvent("nv:officers:refresh")
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobInfo)
    if Enabled then
        if QBCore.Functions.GetPlayerData().job.name == "police" then
            SendNUIMessage({ ['action'] = "close" })
        end
    end
    
    TriggerServerEvent("nv:officers:refresh")
end)

RegisterNetEvent("nv:officers:open")
AddEventHandler("nv:officers:open", function(type)
    if type == 'toggle' then
        if Enabled then
            Enabled = false
            SendNUIMessage({ ['action'] = 'close' })
            print("close")
        else
            Enabled = true
            SendNUIMessage({ ['action'] = 'open' })
            print("open")
        end
    elseif type == 'drag' then
        SetNuiFocus(true, true)
        SendNUIMessage({ ['action'] = 'drag' })
    end
end)

RegisterNUICallback("Close", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("nv:officers:refresh")
AddEventHandler("nv:officers:refresh", function(data)
    SendNUIMessage({ ['action'] = 'refresh', ['data'] = data })
end)

