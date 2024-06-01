QBCore = exports[Config.Core]:GetCoreObject()

local PlayerJob = {}
local Enabled = false

CreateThread(function()
    Wait(10)
    while not QBCore.Functions.GetPlayerData().job do
        Wait(10)
    end

    PlayerJob = QBCore.Functions.GetPlayerData().job
    TriggerServerEvent("fl-dispatch:server:refresh")
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    TriggerServerEvent("fl-dispatch:server:refresh")
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobInfo)
    PlayerJob = jobInfo
    if Enabled and not IsJobAllowed(PlayerJob.name) then
        SendNUIMessage({ action = "close" })
    end

    TriggerServerEvent("fl-dispatch:server:refresh")
end)

RegisterNetEvent("fl-dispatch:client:open")
AddEventHandler("fl-dispatch:client:open", function(type)
    if type == 'toggle' then
        if Enabled then
            Enabled = false
            SendNUIMessage({ action = 'close' })
        else
            Enabled = true
            SendNUIMessage({ action = 'open' })
        end
    elseif type == 'drag' then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'drag' })
    elseif type == 'force_exit' then
        Enabled = false
        SendNUIMessage({ action = 'close' })
    end
end)

RegisterNUICallback("Close", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("fl-dispatch:client:refresh")
AddEventHandler("fl-dispatch:client:refresh", function(data)
    local id = GetPlayerServerId(PlayerId())
    local filteredData = {}

    for _, jobData in pairs(data) do
        if jobData.job == PlayerJob.name then
            for i, v in ipairs(jobData.players) do
                if v.src == id then
                    jobData.players[i].me = true
                end
            end
            table.insert(filteredData, jobData)
        end
    end

    SendNUIMessage({
        action = 'refresh',
        data = filteredData
    })
end)

RegisterNetEvent('fl-dispatch:client:removePlayer')
AddEventHandler('fl-dispatch:client:removePlayer', function(src)
    SendNUIMessage({
        action = "removePlayer",
        data = {
            src = src,
        },
    })
    TriggerServerEvent("fl-dispatch:server:refresh")
end)

RegisterNetEvent("fl-dispatch:client:setTalkingOnRadio")
AddEventHandler("fl-dispatch:client:setTalkingOnRadio", function(src, talking)
    SendNUIMessage({
        action = "setTalkingOnRadio",
        data = {
            src = src,
            talking = talking
        },
    })
end)

RegisterNetEvent("fl-dispatch:client:setPlayerRadio")
AddEventHandler("fl-dispatch:client:setPlayerRadio", function(src, channel)
    SendNUIMessage({
        action = "setPlayerRadio",
        data = {
            src = src,
            channel = channel
        },
    })
end)

RegisterCommand("+dispatch", function()
    TriggerServerEvent('fl-dispatch:server:open', GetPlayerServerId(PlayerId()), {})
end, false)

RegisterKeyMapping('+dispatch', 'Opens Job Dispatch List', Config.ToggleKey['group'], Config.ToggleKey['key'])

function IsJobAllowed(job)
    for _, allowedJob in ipairs(Config.Jobs) do
        if allowedJob == job then
            return true
        end
    end
    return false
end
