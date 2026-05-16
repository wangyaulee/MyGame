local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local Events = ReplicatedStorage:WaitForChild("Events")
local MatchService = require(ReplicatedStorage:WaitForChild("MatchService"))
local ItemModule = require(ReplicatedStorage.Modules.ItemModule)
local CraftingModule = require(ReplicatedStorage.Modules.CraftingModule)
local TradeModule = require(ReplicatedStorage.Modules.TradeModule)

-- Data stores
local levelStore = DataStoreService:GetDataStore("PlayerLevels")
local moneyStore = DataStoreService:GetDataStore("PlayerMoney")
local killsStore = DataStoreService:GetDataStore("PlayerKills")
local rebirthStore = DataStoreService:GetDataStore("PlayerRebirths")
local inventoryStore = DataStoreService:GetDataStore("PlayerInventory")
local codesStore = DataStoreService:GetDataStore("RedeemCodes")

-- Player data storage
local playerData = {}

-- Initialize player
Players.PlayerAdded:Connect(function(player)
    -- Load or create data
    local success, savedLevel = pcall(function() return levelStore:GetAsync(player.UserId) end)
    local success2, savedMoney = pcall(function() return moneyStore:GetAsync(player.UserId) end)
    local success3, savedKills = pcall(function() return killsStore:GetAsync(player.UserId) end)
    local success4, savedRebirths = pcall(function() return rebirthStore:GetAsync(player.UserId) end)
    local success5, savedInventory = pcall(function() return inventoryStore:GetAsync(player.UserId) end)
    
    playerData[player.Name] = {
        Level = (success and savedLevel) or 1,
        Money = (success2 and savedMoney) or 500,
        TotalKills = (success3 and savedKills) or 0,
        Deaths = 0,
        CurrentStreak = 0,
        BestStreak = 0,
        Rebirths = (success4 and savedRebirths) or 0,
        Inventory = (success5 and savedInventory) or {Fists = 1, Knife = 1, Handgun
