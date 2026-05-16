-- Put THIS SCRIPT inside EVERY stand part (1v1, 2v2, 3v3, etc.)
-- Example: Workspace.GameStands.Stand_1v1 - put this script inside it

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Events = ReplicatedStorage:WaitForChild("Events")

local standPart = script.Parent
local modeName = standPart.Name:gsub("Stand_", "") -- Gets "1v1", "2v2", etc.

-- Touch detector
local touchPart = Instance.new("Part")
touchPart.Size = Vector3.new(10, 5, 10)
touchPart.Position = standPart.Position + Vector3.new(0, 2, 0)
touchPart.Anchored = true
touchPart.CanCollide = false
touchPart.Transparency = 0.8
touchPart.BrickColor = BrickColor.new("Bright blue")
touchPart.Parent = standPart

-- Create a proximity prompt (better than touching)
local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Join " .. modeName
prompt.ObjectText = modeName
prompt.HoldDuration = 0
prompt.MaxActivationDistance = 8
prompt.Parent = touchPart

prompt.Triggered:Connect(function(player)
    -- Create simple map selection GUI for this player
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Create the GUI frame (simple like your example)
    local mapGui = Instance.new("ScreenGui")
    mapGui.Name = "MapSelectGui_" .. modeName
    mapGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = mapGui
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "🗺️ SELECT MAP - " .. modeName
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.new(0.2, 0.3, 0.5)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Parent = mainFrame
    
    -- Random Map Button (like your example!)
    local randomBtn = Instance.new("TextButton")
    randomBtn.Text = "🎲 RANDOM MAP"
    randomBtn.Size = UDim2.new(0, 200, 0, 50)
    randomBtn.Position = UDim2.new(0.5, -100, 0, 60)
    randomBtn.BackgroundColor3 = Color3.new(0.2, 0.5, 0.2)
    randomBtn.TextColor3 = Color3.new(1, 1, 1)
    randomBtn.BorderSizePixel = 0
    randomBtn.Parent = mainFrame
    
    -- Cancel button
    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Text = "CANCEL"
    cancelBtn.Size = UDim2.new(0, 200, 0, 40)
    cancelBtn.Position = UDim2.new(0.5, -100, 0, 120)
    cancelBtn.BackgroundColor3 = Color3.new(0.5, 0.2, 0.2)
    cancelBtn.TextColor3 = Color3.new(1, 1, 1)
    cancelBtn.BorderSizePixel = 0
    cancelBtn.Parent = mainFrame
    
    -- Map list (same as your example)
    local maps = {
        "Library", "Crossroad", "Museum", "Lobby", "Shooting range",
        "Dimension", "Farm", "Spaceship", "Village", "Playground",
        "Theatre", "Hospital", "Titanic ship", "Jail", "Minecraft",
        "Black city", "Undreground", "World war II", "Police station",
        "Office", "Big areana", "Pack of toy", "Arena"
    }
    
    -- Random map button click
    randomBtn.MouseButton1Click:Connect(function()
        local selectedMap = maps[math.random(1, #maps)]
        -- Send to server to join queue with selected map
        Events.QueueForMatch:FireServer(modeName, selectedMap)
        mapGui:Destroy()
        
        -- Show confirmation
        local confirmGui = Instance.new("ScreenGui")
        confirmGui.Parent = playerGui
        local confirmFrame = Instance.new("Frame")
        confirmFrame.Size = UDim2.new(0, 250, 0, 60)
        confirmFrame.Position = UDim2.new(0.5, -125, 0.5, -30)
        confirmFrame.BackgroundColor3 = Color3.new(0.1, 0.2, 0.1)
        confirmFrame.BorderSizePixel = 0
        confirmFrame.Parent = confirmGui
        
        local confirmText = Instance.new("TextLabel")
        confirmText.Text = "✅ Joined " .. modeName .. " on " .. selectedMap
        confirmText.Size = UDim2.new(1, 0, 1, 0)
        confirmText.BackgroundTransparency = 1
        confirmText.TextColor3 = Color3.new(0.3, 1, 0.3)
        confirmText.TextScaled = true
        confirmText.Parent = confirmFrame
        
        task.wait(2)
        confirmGui:Destroy()
    end)
    
    -- Cancel button
    cancelBtn.MouseButton1Click:Connect(function()
        mapGui:Destroy()
    end)
end) 
