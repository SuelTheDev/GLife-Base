---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Dylan Malandain.
--- DateTime: 28/08/2019 22:31
---
local Player = {
    Handcuff = false
}

Player.Vehicle = 0
Player.Ped = 0
Player.ActivePlayer = GetActivePlayers()

Player.Health = 0

Player.Identity = {}

Player.Model = 0
Player.Face = {}
Player.Outfit = {}
Player.Tattoo = {}
Player.Weapon = {}
Player.FarmLimit = 0
Player.Strength = 0
Player.Inventory = {["Vide"] = {}}

Player.InVehicle = false
Player.InCombat = false
Player.Ragdoll = false
Player.isDead = false
Player.isLoaded = false
Player.isBusy = true
Player.isCinematic = false

Player.Position = {}
Player.ZoneName = nil
Player.Hud = true
Player.InteriorID = 0
Player.Armed = false
Player.Shooting = false
Player.MeleeCombat = false
Player.Cuffed = false
Player.isInWater = false
Player.isDiving = false
Player.Running = false

---GetMatrix
---@param Callback function
---@return table
---@public
function Player:GetMatrix(Callback)
    Callback(GetEntityMatrix(self.Ped))
    return GetEntityMatrix(self.Ped)
end

---GetVehicle
---@return number
---@public
function Player:GetVehicle()
    local vehicle = self.InVehicle and GetVehiclePedIsUsing(self.Ped)
    return vehicle and vehicle > 0 and vehicle
end

---Set
---@param Value string
---@param Arg string
---@return void
---@public
function Player:Set(Value, Arg)
    self[Value] = Arg
end

---GetPlayer
---@return table
function LocalPlayer()
    return Player
end

Player.UpdateHud = function()
    if Player.isCinematic or not Player.Hud then
        TriggerEvent("es:setMoneyDisplay", 0.0)
    else
        TriggerEvent("es:setMoneyDisplay", 0.8)
    end
end

Citizen.CreateThread(
    function()
        while true do
            Player.Ped = PlayerPedId()
            Player.Pos = GetEntityCoords(Player.Ped)
            Player.Position = EntityGetCoords(Player.Ped)
            Citizen.Wait(1600)
        end
    end
)

Citizen.CreateThread(
    function()
        for i = 1, 500, 1 do
            Wait(10)
            FreezePlayer(PlayerId(), false)
        end
        --print("end")
        while true do
            Citizen.Wait(1)
            --FreezePlayer(PlayerId(),false)
            if Player.Ragdoll then
                SetPedToRagdoll(Player.Ped, 1000, 1000, 0, 0, 0, 0)
                if not Player.KO and not Player.isDead then
                    SetTextComponentFormat("STRING")
                    AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour vous relevez")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(0, Keys["E"]) then
                        Player.Ragdoll = not Player.Ragdoll
                    end
                end
            end
        end
    end
)

function SetFarmLimit(f)
    if f == nil then
        f = 0
    end
    if Player.FarmLimit == nil then
        Player.FarmLimit = 0
    end
    Player.FarmLimit = Player.FarmLimit + f
end

function GetFarmLimit()
    if Player.FarmLimit == nil then
        Player.FarmLimit = 0
    end
    return Player.FarmLimit
end

function SetPlayerInventoryPrefix(inventoryPrefix)
    Player.InventoryPrefix = inventoryPrefix
end