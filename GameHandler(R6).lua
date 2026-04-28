local lp = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- 1. FORCE R6/FIRST PERSON
lp.CameraMode = Enum.CameraMode.LockFirstPerson 

-- 2. SPECTATE LOGIC
RS.Events.ToggleSpectate.OnClientEvent:Connect(function()
    local plrs = game.Players:GetPlayers()
    local target = plrs[math.random(1, #plrs)]
    if target.Character and target.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
    end
end)