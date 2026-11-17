Citizen.CreateThread(function()
    repeat Citizen.Wait(0) until NetworkIsPlayerActive(PlayerId())

    TriggerServerEvent "sample_util:PlayerReady"
end)

RegisterNetEvent("sample_util:RolesGiven")
AddEventHandler("sample_util:RolesGiven", function()
    Citizen.Wait(1000)
    ExecuteCommand "ea_rp"
end)
