Wrapper = {
    ServerCallbacks = {}
}

if SHConfig.Settings.Core == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif SHConfig.Settings.Core == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
end

Wrapper.CreateCallback = function(name, cb)
    Wrapper.ServerCallbacks[name] = cb
end

Wrapper.TriggerCallback = function(name, source, cb, ...)
    if Wrapper.ServerCallbacks[name] ~= nil then
        Wrapper.ServerCallbacks[name](source, cb, ...)
    end
end

function RemoveItem(ItemName)
    local src = source
    if SHConfig.Settings.Core == 'QB' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveItem(ItemName, 1) then
            return true
        end
    end
    if SHConfig.Settings.Core == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.removeInventoryItem(ItemName, 1) then
            return true
        end
    end
end

RegisterNetEvent('Wrapper:Server:TriggerCallback', function(name, ...)
    local src = source
    Wrapper.TriggerCallback(name, src, function(...)
        TriggerClientEvent('Wrapper:Client:TriggerCallback', src, name, ...)
    end, ...)
end)