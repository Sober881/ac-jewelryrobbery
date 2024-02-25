Wrapper = {
    ResName = GetCurrentResourceName(),
    Zone = {},
    ServerCallbacks = {},
}

if SHConfig.Settings.Core == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif SHConfig.Settings.Core == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
end

function Wrapper:Notify(Text, Type, Length)
    if SHConfig.Settings.Notify == 'QB' then
        QBCore.Functions.Notify(Text, Type, Length)
    end
    if SHConfig.Settings.Notify == 'ESX' then
        ESX.ShowNotification(Text)
    end
    if SHConfig.Settings.Notify == 'ST' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(Text)
        DrawNotification(0, 1)
    end
end

function Wrapper:Target(coords, name, type, trigger, icon, label, zonex, zoney)
    if SHConfig.Settings.Target == 'QB' then
        exports['qb-target']:AddBoxZone(name, coords, zonex, zoney, {
            name = name,
            heading = 0.0,
            debugPoly = false,
            minZ = coords.z - 2,
            maxZ = coords.z + 2,
        }, {
            options = {
                {
                    type = type,
                    event = trigger,
                    icon = icon,
                    label = label,
                },
            },
            distance = 1.0
        })
    end
    if SHConfig.Settings.Target == 'OX' then
        Wrapper.Zone[name] = exports["ox_target"]:addBoxZone({
        coords = vec3(coords.x, coords.y, coords.z),
        size = vec3(zonex, zoney, 3),
        rotation = 0.0,
        debug = false,
            options = {
                {
                    type = type,
                    event = trigger,
                    icon = icon,
                    label = label,
                },
            }
        })
    end
    if SHConfig.Settings.Target == 'BT' then
        exports['bt-target']:AddBoxZone(name, vector3(coords.x,coords.y,coords.z), zonex, zoney, {
            name = name,
            heading = 0.0,
            minZ = coords.z - 2,
            maxZ = coords.z + 2,
        }, {
            options = {
                {
                    type = type,
                    event = trigger,
                    icon = icon,
                    label = label,
                },
            },
            distance = 1.0
        })
    end
end

Wrapper.TriggerCallback = function(name, cb, ...)
    Wrapper.ServerCallbacks[name] = cb
    TriggerServerEvent("Wrapper:Server:TriggerCallback", name, ...)
end

RegisterNetEvent('Wrapper:Client:TriggerCallback', function(name, ...)
    if Wrapper.ServerCallbacks[name] ~= nil then
        Wrapper.ServerCallbacks[name](...)
        Wrapper.ServerCallbacks[name] = nil
    end
end)