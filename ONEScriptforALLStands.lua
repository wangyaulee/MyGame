-- ServerScriptService.StandManager - ONE script handles all stands

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")

local standsFolder = workspace:WaitForChild("GameStands")

-- Map list (same as your example)
local maps = {
    "Library", "Crossroad", "Museum", "Lobby", "Shooting range",
    "Dimension", "Farm", "Spaceship", "Village", "Playground",
    "Theatre", "Hospital", "Titanic ship", "Jail", "Minecraft",
    "Black city", "Undreground", "World war II", "Police station",
    "Office", "Big areana", "Pack of toy", "Arena"
}

-- Create touch zones for each stand
for _, stand in pairs(standsFolder:GetChildren()) do
    if stand:IsA("BasePart") then
        local modeName = stand.Name:gsub("Stand_", "")
        
        -- Create touch part
        local touchPart = Instance.new("Part")
        touchPart.Size = Vector3.new(8, 4, 8)
        touchPart.Position = stand.Position + Vector3.new(0, 2, 0)
        touchPart.Anchored = true
        touchPart.CanCollide = false
        touchPart.Transparency = 0.5
        touchPart.BrickColor = BrickColor.new("Bright blue")
        touchPart.Parent = stand
        
        -- Proximity prompt
        local prompt = Instance.new("ProximityPrompt")
        prompt.ActionText = "Join " .. modeName
        prompt.ObjectText = modeName
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = 10
        prompt.Parent = touchPart
        
        -- When player activates
        prompt.Triggered:Connect(function(player)
            -- Create GUI for this player
            local gui = Instance.new("ScreenGui")
            gui.Name = "MapSelect_" .. modeName
            gui.Parent = player:WaitForChild("PlayerGui")
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 300, 0, 200)
            frame.Position = UDim2.new(0.5, -150, 0.5, -100)
            frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
            frame.BackgroundTransparency = 0.05
            frame.BorderSizePixel = 0
            frame.Parent = gui
            
            -- Title
            local title = Instance.new("TextLabel")
            title.Text = "🗺️ " .. modeName .. " - SELECT MAP"
            title.Size = UDim2.new(1, 0, 0, 40)
            title.BackgroundColor3 = Color3.new(0.2, 0.3, 0.5)
            title.TextColor3 = Color3.new(1, 1, 1)
            title.TextScaled = true
            title.Parent = frame
            
            -- Random button (LIKE YOUR EXAMPLE!)
            local randomBtn = Instance.new("TextButton")
            randomBtn.Text = "🎲 RANDOM MAP"
            randomBtn.Size = UDim2.new(0, 200, 0, 50)
            randomBtn.Position = UDim2.new(0.5, -100, 0, 60)
            randomBtn.BackgroundColor3 = Color3.new(0.2, 0.5, 0.2)
            randomBtn.TextColor3 = Color3.new(1, 1, 1)
            randomBtn.BorderSizePixel = 0
            randomBtn.Parent = frame
            
            -- Cancel
            local cancelBtn = Instance.new("TextButton")
            cancelBtn.Text = "CANCEL"
            cancelBtn.Size = UDim2.new(0, 200, 0, 40)
            cancelBtn.Position = UDim2.new(0.5, -100, 0, 120)
            cancelBtn.BackgroundColor3 = Color3.new(0.5, 0.2, 0.2)
            cancelBtn.TextColor3 = Color3.new(1, 1, 1)
            cancelBtn.BorderSizePixel = 0
            cancelBtn.Parent = frame
            
            randomBtn.MouseButton1Click:Connect(function()
                local selectedMap = maps[math.random(1, #maps)]
                Events.QueueForMatch:FireServer(player, modeName, selectedMap)
                gui:Destroy()
                
                -- Quick confirmation
                local notif = Instance.new("TextLabel")
                notif.Text = "✅ Joined " .. modeName .. " on " .. selectedMap
                notif.Size = UDim2.new(0, 250, 0, 40)
                notif.Position = UDim2.new(0.5, -125, 0.7, 0)
                notif.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
                notif.TextColor3 = Color3.new(0.3, 1, 0.3)
                notif.TextScaled = true
                notif.BorderSizePixel = 0
                notif.Parent = player.PlayerGui
                task.wait(2)
                notif:Destroy()
            end)
            
            cancelBtn.MouseButton1Click:Connect(function()
                gui:Destroy()
            end)
        end)
    end
end
