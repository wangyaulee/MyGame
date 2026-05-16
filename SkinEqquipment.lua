--!strict
-- StarterPlayerScripts.SkinEquipper
-- Author: Skin Boss

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local SkinModule = require(ReplicatedStorage.Modules.SkinModule)
local Remotes = ReplicatedStorage:WaitForChild("SkinRemotes")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- State
local myData = {
    OwnedSkins = {},
    EquippedSkin = "",
    Currency = 0
}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkinShopGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false -- Hidden by default, toggle with a keybind (e.g., 'K')
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "SKIN SHOP"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollingFrame

-- Logic: Create UI for a skin
local function CreateSkinButton(skinId: string)
    local skinData = SkinModule.GetSkin(skinId)
    if not skinData then return end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 80)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = ""
    btn.Parent = ScrollingFrame

    local rarityColor = SkinModule.GetRarityColor(skinData.Rarity)
    local border = Instance.new("UIStroke")
    border.Color = rarityColor
    border.Thickness = 2
    border.Parent = btn

    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(0, 200, 1, 0)
    nameText.Position = UDim2.new(0, 10, 0, 0)
    nameText.BackgroundTransparency = 1
    nameText.Text = skinData.Name .. " [" .. skinData.Rarity .. "]"
    nameText.TextColor3 = rarityColor
    nameText.TextXAlignment = Enum.TextXAlignment.Left
    nameText.Font = Enum.Font.Gotham
    nameText.TextSize = 18
    nameText.Parent = btn

    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(0, 100, 0, 40)
    actionBtn.Position = UDim2.new(1, -110, 0.5, -20)
    actionBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    actionBtn.Text = "EQUIP"
    actionBtn.TextColor3 = Color3.new(1, 1, 1)
    actionBtn.Font = Enum.Font.GothamBold
    actionBtn.Parent = btn

    -- Logic to set button state (Equip vs Buy vs Equipped)
    local function UpdateButton()
        local owned = table.find(myData.OwnedSkins, skinId)
        if owned then
            if myData.EquippedSkin == skinId then
                actionBtn.Text = "EQUIPPED"
                actionBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            else
                actionBtn.Text = "EQUIP"
                actionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
                actionBtn.MouseButton1Click:Connect(function()
                    Remotes:FireServer("EquipSkin", skinId)
                end)
            end
        else
            actionBtn.Text = "BUY $" .. skinData.Price
            actionBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
            actionBtn.MouseButton1Click:Connect(function()
                Remotes:FireServer("BuySkin", skinId)
            end)
        end
    end

    UpdateButton()
end

-- Populate UI
local function RefreshUI()
    -- Clear old buttons
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local allSkins = SkinModule.GetAllSkins()
    for id, _ in pairs(allSkins) do
        CreateSkinButton(id)
    end
end

-- Networking
Remotes.OnClientEvent:Connect(function(action, data)
    if action == "InitData" or action == "UpdateData" then
        myData = data
        RefreshUI()
        
        -- If we just equipped a skin, apply it to current character weapon
        if action == "UpdateData" then
            local char = Player.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    SkinModule.ApplySkinToWeapon(tool, SkinModule.GetSkin(myData.EquippedSkin))
                end
            end
        end
    elseif action == "Notify" then
        -- Simple notification
        local notify = Instance.new("Message")
        notify.Text = data
        notify.Parent = PlayerGui
        task.delay(2, function() notify:Destroy() end)
    end
end)

-- Toggle GUI (Press 'K')
UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initial Refresh when player loads (triggered by server InitData)
-- We wait slightly to ensure data arrives
task.wait(1)
RefreshUI()
