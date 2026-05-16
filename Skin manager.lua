--!strict
-- ServerScriptService.SkinManager
-- Author: Skin Boss

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SkinModule = require(ReplicatedStorage.Modules.SkinModule)

-- RemoteEvent for syncing data
local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Name = "SkinRemotes"
RemoteEvent.Parent = ReplicatedStorage

local PlayerData = {} -- Session cache
local SkinDataStore = DataStoreService:GetDataStore("PlayerSkinData_v1")

--[[
    Load data when player joins
]]
local function OnPlayerJoin(player)
    local key = "Player_" .. player.UserId
    local success, data = pcall(function()
        return SkinDataStore:GetAsync(key)
    end)

    if success and data then
        PlayerData[player.UserId] = data
    else
        -- Default data
        PlayerData[player.UserId] = {
            OwnedSkins = {"default_rifle"},
            EquippedSkin = "default_rifle",
            Currency = 0
        }
    end

    -- Send initial data to client
    RemoteEvent:FireClient(player, "InitData", PlayerData[player.UserId])
end

--[[
    Save data when player leaves
]]
local function OnPlayerLeave(player)
    local key = "Player_" .. player.UserId
    if PlayerData[player.UserId] then
        pcall(function()
            SkinDataStore:SetAsync(key, PlayerData[player.UserId])
        end)
    end
    PlayerData[player.UserId] = nil
end

--[[
    Handle Client Requests (Equip, Buy)
]]
RemoteEvent.OnServerEvent:Connect(function(player, action, ...)
    local args = ...
    local data = PlayerData[player.UserId]
    if not data then return end

    if action == "BuySkin" then
        local skinId = args
        local skinInfo = SkinModule.GetSkin(skinId)
        if not skinInfo then return end

        -- Check if already owns
        if table.find(data.OwnedSkins, skinId) then return end

        -- Check currency (assuming you have a currency system, here we just check price vs dummy var)
        if data.Currency >= skinInfo.Price then
            data.Currency -= skinInfo.Price
            table.insert(data.OwnedSkins, skinId)
            RemoteEvent:FireClient(player, "UpdateData", data)
        else
            RemoteEvent:FireClient(player, "Notify", "Not enough money!")
        end

    elseif action == "EquipSkin" then
        local skinId = args
        if table.find(data.OwnedSkins, skinId) then
            data.EquippedSkin = skinId
            RemoteEvent:FireClient(player, "UpdateData", data)
        end
    end
end)

Players.PlayerAdded:Connect(OnPlayerJoin)
Players.PlayerRemoving:Connect(OnPlayerLeave)
