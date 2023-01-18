---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Dylan Malandain.
--- DateTime: 31/08/2019 00:17
---

Selector = {}

local function ReturnSexWithModel(Model)
    if (Model == "mp_f_freemode_01") then
        return "Femme"
    else
        return "Homme"
    end
end

function Selector.LoadContent(Appearance, Identity, Jobs, Users)
    local interiorID = GetInteriorAtCoordsWithType(vector3(399.9, -998.7, -100.0), "v_mugshot")
    local ped = PlayerPedId()

    LoadInterior(interiorID)

    while not IsInteriorReady(interiorID) do
        Citizen.Wait(0)
    end
    ForceRoomForEntity(ped, interiorID, GetHashKey("v_mugshot"))
    ForceRoomForEntity(ped, interiorID, GetHashKey("V_WinningRoom"))

    SetOverrideWeather("EXTRASUNNY")
    SetWeatherTypePersist("EXTRASUNNY")
    while not IsInteriorReady(interiorID) do
        Citizen.Wait(0)
    end

    RequestAssets()
    Citizen.Wait(1000)
    SetEntityVisible(ped, 0, 0)
    SetEntityInvincible(ped, 1)
    FreezeEntityPosition(ped, 1)
    setOldF(Users[1].limit_farm)
    PlyUuid = Users[1].uuid
    SetFarmLimit(Users[1].limit_farm)
    --StartScenario()
    DoScreenFadeIn(500)
    RemoveLoadingPrompt()
    TriggerServerEvent("mugroom:SelectedPlayer", Users[1].uuid)
    Citizen.Wait(600)
    onSelectorTick.Controls = true
end

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        if (#GetPedList() >= 0) then
            for key, value in pairs(GetPedList()) do
                DeleteEntity(value.Entity)
            end
            local ped = PlayerPedId()
            SetEntityVisible(ped, 1, 0)
            SetEntityInvincible(ped, 0)
            FreezeEntityPosition(ped, 0)
            FreezePlayer(PlayerId(), false)
            DeleteAssets()
        end
    end
)