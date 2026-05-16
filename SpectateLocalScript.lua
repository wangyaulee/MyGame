local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local Events = ReplicatedStorage:WaitForChild("Events")

-- Variables
local currentTarget = nil
local spawnConnection = nil
local deathConnection = nil
local isSpectating = false
local heartbeatConnection = nil

-- Force first person for instagib
lp.CameraMode = Enum.CameraMode.LockFirstPerson

-- Function to stop spectating completely
local function stopSpectating()
    if spawnConnection then
        spawnConnection:Disconnect()
        spawnConnection = nil
    end
    if deathConnection then
        deathConnection:Disconnect()
        deathConnection = nil
    end
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    
    -- Return camera to own character if alive
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        if hum.Health > 0 then
            CurrentCamera.CameraSubject = hum
        end
    end
    
    currentTarget = nil
    isSpectating = false
end

-- Function to start spectating a target
local function startSpectating(target)
    if not target or target == lp then return end
    
    stopSpectating()
    currentTarget = target
    isSpectating = true
    
    -- Update camera to target's current character
    local function updateCamera(char)
        if not char or not char.Parent then return end
        
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            CurrentCamera.CameraSubject = hum
        end
        
        -- Also track when target dies to switch to another player
        if hum and not deathConnection then
            deathConnection = hum.Died:Connect(function()
                task.wait(0.5) -- Wait for respawn
                -- Find a new alive target
                local newTarget = findBestSpectateTarget()
                if newTarget then
                    startSpectating(newTarget)
                end
            end)
        end
    end
    
    -- Spectate current character if exists
    if target.Character then
        updateCamera(target.Character)
    end
    
    -- Follow target when they respawn
    spawnConnection = target.CharacterAdded:Connect(updateCamera)
end

-- Find the best player to spectate
local function findBestSpectateTarget()
    local plrs = Players:GetPlayers()
    local alivePlayers = {}
    local deadPlayers = {}
    
    -- Separate alive and dead players
    for _, p in ipairs(plrs) do
        if p ~= lp then
            if p.Character and p.Character:FindFirstChild("Humanoid") then
                local hum = p.Character.Humanoid
                if hum.Health > 0 then
                    table.insert(alivePlayers, p)
                else
                    table.insert(deadPlayers, p)
                end
            else
                table.insert(deadPlayers, p)
            end
        end
    end
    
    -- Prioritize alive players
    if #alivePlayers > 0 then
        return alivePlayers[math.random(1, #alivePlayers)]
    elseif #deadPlayers > 0 then
        return deadPlayers[math.random(1, #deadPlayers)]
    end
    
    return nil
end

-- Handle spectate trigger from server
Events.ToggleSpectate.OnClientEvent:Connect(function()
    -- Don't spectate if we're in a match that hasn't started yet
    if lp:GetAttribute("InMatch") and not lp:GetAttribute("MatchActive") then
        return
    end
    
    local target = findBestSpectateTarget()
    
    if target then
        startSpectating(target)
        
        -- Show spectating UI hint
        local hint = Instance.new("TextLabel")
        hint.Text = "Spectating: " .. target.Name
        hint.Size = UDim2.new(0, 200, 0, 30)
        hint.Position = UDim2.new(0.5, -100, 1, -40)
        hint.BackgroundColor3 = Color3.new(0, 0, 0)
        hint.BackgroundTransparency = 0.5
        hint.TextColor3 = Color3.new(1, 1, 1)
        hint.TextScaled = true
        hint.Parent = lp.PlayerGui:FindFirstChild("MainGui") or workspace
        
        -- Remove hint after 2 seconds
        task.wait(2)
        hint:Destroy()
    end
end)

-- Handle match start (stop spectating, return to own character)
Events.MatchStarted.OnClientEvent:Connect(function(modeName, teamInfo)
    stopSpectating()
    
    -- Reset camera to own character when match starts
    task.wait(0.5)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        CurrentCamera.CameraSubject = lp.Character.Humanoid
    end
end)

-- Handle match end
Events.EndMatch.OnClientEvent:Connect(function(winnerName, scores)
    stopSpectating()
end)

-- When player respawns, stop spectating
lp.CharacterAdded:Connect(function(char)
    stopSpectating()
    
    -- Return camera to own character
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        CurrentCamera.CameraSubject = hum
    end
    
    -- If in Elimination mode with instant spawn, we're good
    -- If in normal mode, we wait for death to trigger spectate again
end)

-- Clean up when player leaves
lp.AncestryChanged:Connect(function()
    if not lp.Parent then
        stopSpectating()
    end
end)

-- Optional: Add keybind to switch spectate targets (Press 'N' for next)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.N and isSpectating then
        local newTarget = findBestSpectateTarget()
        if newTarget and newTarget ~= currentTarget then
            startSpectating(newTarget)
            
            -- Show quick hint
            local hint = Instance.new("TextLabel")
            hint.Text = "Now spectating: " .. newTarget.Name
            hint.Size = UDim2.new(0, 200, 0, 30)
            hint.Position = UDim2.new(0.5, -100, 1, -40)
            hint.BackgroundColor3 = Color3.new(0, 0, 0)
            hint.BackgroundTransparency = 0.5
            hint.TextColor3 = Color3.new(1, 1, 0)
            hint.TextScaled = true
            hint.Parent = lp.PlayerGui:FindFirstChild("MainGui") or workspace
            
            task.wait(1.5)
            hint:Destroy()
        end
    end
end)

-- Debug: Print status when spectating starts/stops
local function debugPrint(message)
    if game:GetService("RunService"):IsStudio() then
        print("[Spectate] " .. message)
    end
end

-- Success message
debugPrint("SpectateHandler loaded successfully!")
