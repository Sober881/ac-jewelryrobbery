local Data = {
    IsAlarmOff = false,
    IsPowerOff = false,
    IsAlerted = false
}

Wrapper.CreateCallback('ac-jewelryrobbery:[Server]:GetAlarmState', function(source, cb)
    cb(Data.IsAlarmOff)
end)

Wrapper.CreateCallback('ac-jewelryrobbery:[Server]:GetPowerState', function(source, cb)
    cb(Data.IsPowerOff)
end)

Wrapper.CreateCallback('ac-jewelryrobbery:[Server]:GetAlertState', function(source, cb)
    cb(Data.IsAlerted)
end)

RegisterNetEvent('ac-jewelryrobbery:[Server]:Alert', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if RemoveItem(SHConfig.Main.LaptopItem) then
        TriggerClientEvent('ac-jewelryrobbery:[Client]:SetAlarmOff', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'YOU DONT HAVE ITEMS (1x ' .. SHConfig.Main.LaptopItem .. ')', 'inform')
    end
end)

RegisterNetEvent('ac-jewelryrobbery:[Server]:Power', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if RemoveItem(SHConfig.Main.ElectricBoxItem) then
        TriggerClientEvent('ac-jewelryrobbery:[Client]:SetPowerOff', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'YOU DONT HAVE ITEMS (1x ' .. SHConfig.Main.ElectricBoxItem .. ')', 'inform')
    end
end)

RegisterNetEvent('ac-jewelryrobbery:[Server]:ChangeAlarmState', function(Bool)
    Data.IsAlarmOff = Bool
end)

RegisterNetEvent('ac-jewelryrobbery:[Server]:ChangePowerState', function(Bool)
    Data.IsPowerOff = Bool
end)

RegisterNetEvent('ac-jewelryrobbery:[Server]:ChangeAlertState', function(Bool)
    Data.IsAlerted = Bool
end)

RegisterServerEvent('ac-jewelryrobbery:[Server]:ChangeRobbedState', function(Glass)
    SHConfig.Main.GlassCoords[Glass].Robbed = true
    TriggerClientEvent('ac-jewelryrobbery:[Client]:ChangeRobbedState', -1, Glass)
end)

RegisterNetEvent('ac-jewelryrobbery:[Server]:CollectItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    for i = #SHConfig.Main.Items, 1, -1 do
        Item = math.random(1, i)
        Player.Functions.AddItem(SHConfig.Main.Items[Item], 1)
    end
end)

RegisterNetEvent('ac-jewelryrobbery:[Client]:ResetCooldown', function()
    Wait(SHConfig.Main.Cooldown * (60 * 1000))
    -- Wait(1000)
    Data.IsAlarmOff = false
    Data.IsPowerOff = false
    Data.IsAlerted = false
    for i = #SHConfig.Main.GlassCoords, 1, -1 do SHConfig.Main.GlassCoords[i].Robbed = false end
end)