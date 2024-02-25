local QBCore = exports['qb-core']:GetCoreObject()
local Data = {
    Peds = {}
}

function BreakClass()
    QBCore.Functions.Progressbar('jewelry_robbery', 'COLLECTING', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 49,
    }, {}, {}, function()
		StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        TriggerServerEvent('ac-jewelryrobbery:[Server]:CollectItem')
    end, function()
        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
    end)
end

function SpawnPed()
    Wrapper.TriggerCallback('ac-jewelryrobbery:[Server]:GetAlertState', function(Alerted)
        if not Alerted then
            TriggerServerEvent('ac-jewelryrobbery:[Server]:ChangeAlertState', true)
            for k, v in pairs(SHConfig.Peds.PedCoords) do
                RequestModel(SHConfig.Peds.Model)
                while not HasModelLoaded(SHConfig.Peds.Model) do Wait(0) end
                local ped = CreatePed(4, SHConfig.Peds.Model, v, 0.0, true, true)

                AddRelationshipGroup("JewelryGuard")
                SetPedRelationshipGroupHash(ped, "JewelryGuard")
                TaskCombatPed(ped, PlayerPedId())
                SetPedFiringPattern(ped, -957453492)
                GiveWeaponToPed(ped, GetHashKey(SHConfig.Peds.Weapon), 9999, false, true)
                SetPedArmour(ped, SHConfig.Peds.Armour)
                SetPedAccuracy(ped, SHConfig.Peds.Accuracy)
                SetPedSuffersCriticalHits(ped, SHConfig.Peds.CriticalHits)
            end

            SetTimeout(120000, function()
                for _, Ped in pairs(Data.Peds) do
                    DeleteEntity(Ped)
                end
            end)
        end
    end)
end

RegisterNetEvent('ac-jewelryrobbery:[Client]:SetAlarmOff', function()
    Wrapper.TriggerCallback('ac-jewelryrobbery:[Server]:GetPowerState', function(Power)
        Wrapper.TriggerCallback('ac-jewelryrobbery:[Server]:GetAlarmState', function(Alarm)
            if not Power then
                if not Alarm then
                    if AlarmHack() then
                        PoliceAlert()
                        TriggerServerEvent('ac-jewelryrobbery:[Server]:ChangeAlarmState', true)
                        TriggerServerEvent('ac-jewelryrobbery:[Client]:ResetCooldown')
                        Wrapper:Notify('ALARM IS ALREADY OFF', 'error')
                    else
                        SpawnPed()
                        Wrapper:Notify('HACK FAILED AND SWAT ON YOUR WAY', 'error')
                    end
                else
                    Wrapper:Notify('ALARM IS ALREADY OFF', 'error')
                end
            end
        end)
    end)
end)

RegisterNetEvent('ac-jewelryrobbery:[Client]:ChangeRobbedState', function(Glass)
    SHConfig.Main.GlassCoords[Glass].Robbed = true
end)

RegisterNetEvent('ac-jewelryrobbery:[Client]:SetPowerOff', function()
    Wrapper.TriggerCallback('ac-jewelryrobbery:[Server]:GetAlarmState', function(Alarm)
        Wrapper.TriggerCallback('ac-jewelryrobbery:[Server]:GetPowerState', function(Power)
            if Alarm then
                if not Power then
                    if PowerHack() then
                        TriggerServerEvent('ac-jewelryrobbery:[Server]:ChangePowerState', true)
                        Wrapper:Notify('HACK SUCCESS', 'success')
                    else
                        Wrapper:Notify('HACK FAILED', 'error')
                    end
                else
                    Wrapper:Notify('POWER IS ALREADY OFF', 'error')
                end
            else
                Wrapper:Notify('ALARM IS ALREADY ON', 'error')
            end
        end)
    end)
end)

RegisterNetEvent('ac-jewelryrobbery:[Client]:BreakGlass')
AddEventHandler('ac-jewelryrobbery:[Client]:BreakGlass', function()
    Wrapper.TriggerCallback('ac-jewelryrobbery:[Server]:GetAlarmState', function(Alarm)
        Wrapper.TriggerCallback('ac-jewelryrobbery:[Server]:GetPowerState', function(Power)
            if Alarm then
                if Power then
                    for k, v in pairs(SHConfig.Main.GlassCoords) do
                        local distance = #(GetEntityCoords(PlayerPedId()) - vector3(v[1]))
                        if distance <= 1.35 then
                            if not v.Robbed then
                                BreakClass()
                                TriggerServerEvent('ac-jewelryrobbery:[Server]:ChangeRobbedState', k)
                            else
                                Wrapper:Notify('THIS GLASS ALREADY ROBBED', 'error')
                            end
                            return
                        end
                    end
                else
                    Wrapper:Notify('POWER IS ALREADY ON', 'error')
                end
            else
                Wrapper:Notify('ALARM IS ALREADY ON', 'error')
            end
        end)
    end)
end)

CreateThread(function()
    Wrapper:Target(SHConfig.Main.ElectricBoxCoords, 'jewelry_target_electricbox', 'server', 'ac-jewelryrobbery:[Server]:Power', 'fas fa-list', 'Control Panel', 0.55, 0.55)
    Wrapper:Target(SHConfig.Main.LaptopCoords, 'jewelry_target_laptop', 'server', 'ac-jewelryrobbery:[Server]:Alert', 'fas fa-laptop', 'Laptop', 0.55, 0.55)
    for k, v in pairs(SHConfig.Main.GlassCoords) do Wrapper:Target(v[1], 'jewelry_target_' .. k, 'client', 'ac-jewelryrobbery:[Client]:BreakGlass', 'fas fa-hammer', 'Break', 0.35, 0.35) end
end)