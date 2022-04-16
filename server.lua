local HTML = ""
local CallSigns = {}

QBCore = nil 

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

RegisterCommand("plist", function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    if xPlayer.PlayerData.job.name == "police" then
        local type = "toggle"
        TriggerEvent("nv:officers:refresh")
        
        if args[1] == "0" then
            type = "drag"
        end

        TriggerClientEvent("nv:officers:open", src, type)
    end
end)

RegisterCommand("callsign", function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer and (xPlayer.PlayerData.job.name == 'police') and args[1] then
        if args[1] == 'none' then
            CallSigns[xPlayer.PlayerData.license] = xPlayer.PlayerData.source
            SaveResourceFile(GetCurrentResourceName(), "callsigns.json", json.encode(CallSigns))
            TriggerEvent("nv:officers:refresh")
            TriggerClientEvent('QBCore:Notify', source, "Restored Callsign.", "success")
        else
            CallSigns[xPlayer.PlayerData.license] = args[1]
            SaveResourceFile(GetCurrentResourceName(), "callsigns.json", json.encode(CallSigns))
            TriggerEvent("nv:officers:refresh")
            TriggerClientEvent('QBCore:Notify', source, "Updated Callsign: " .. args[1], "success")
        end
    end
end)

RegisterServerEvent("nv:officers:refresh")
AddEventHandler("nv:officers:refresh", function()
    local new = ""

    for k,v in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(v)
        if xPlayer and (xPlayer.PlayerData.job.name == 'police') then
            local name = GetName(v)
            local dutyClass = ""
            local duty = ""
            
            if xPlayer.PlayerData.job.onduty then
                dutyClass = 'duty'
                duty = "On Duty"
            else
                dutyClass = 'offduty'
                duty = "Off Duty"
            end
            
            local callSign = CallSigns[xPlayer.PlayerData.license] ~= nil and CallSigns[xPlayer.PlayerData.license] or xPlayer.PlayerData.source
            new = new .. '<div class="officer"><span class="callsign">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. xPlayer.PlayerData.job.grade.name .. '</span> - <span class="' .. dutyClass .. '">' .. duty .. '</span></div>'
        end
    end

    HTML = new
    TriggerClientEvent("nv:officers:refresh", -1, HTML)
end)

function GetName(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer ~= nil and xPlayer.PlayerData.charinfo.firstname ~= nil and xPlayer.PlayerData.charinfo.lastname ~= nil then
         return xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    else
        return ""
    end
end

CreateThread(function()
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "callsigns.json"))

    if result then
        CallSigns = result
    end
end)
