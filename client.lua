local QBCore = exports['qb-core']:GetCoreObject()


Citizen.CreateThread(function()
    local sleep
    while true do
        sleep = 2000
        pcord = GetEntityCoords(PlayerPedId())
        for i, v in ipairs(Config.Locations) do
            dst = GetDistanceBetweenCoords(pcord, v.coord)
            if dst < 3 and PlayerJob.name == v.job then
                sleep = 5
                DrawText3D(v.coord.x, v.coord.y, v.coord.z + 0.3, "[E] - "..v.name)
                DrawMarker(v.type, v.coord.x, v.coord.y, v.coord.z + 0.1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, v.MarkerSize.X, v.MarkerSize.Y, v.MarkerSize.Z, v.MarkerColor.R, v.MarkerColor.G, v.MarkerColor.B, v.MarkerColor.A, false, true, 2, nil, nil, false)
                if dst < 1 and IsControlJustReleased(1, 51)  then
                    OpenMenu(v)
                end
            end
        end
        Citizen.Wait(sleep)
    end
  end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)


AddEventHandler("onResourceStart", function(JobInfo)
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

function OpenMenu(data)
    local Menu = {
        {
            header = data.Menu.Header,
            txt = data.Menu.Info,
            params = {
                event = "src-stash:client:getstash",
                args = {
                    v = data
                }
            }
        }
    }
    Menu[#Menu+1] = {
        header = "⬅ Close Menu",
        params = {
            event = "qb-menu:client:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(Menu)
end






RegisterNetEvent('src-stash:client:getstash', function (data)
    s = data.v
    TriggerEvent('inventory:openInventoryAnim')
    TriggerEvent("inventory:client:SetCurrentStash", s.name)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", s.name)

end)

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
 
  end