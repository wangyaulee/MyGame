local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Scores = {}

Players.PlayerAdded:Connect(function(plr)
    Scores[plr.Name] = {Kills = 0, Deaths = 0, Points = 0}
    plr.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.MaxHealth = 1
        hum.Health = 1
        hum.Died:Connect(function()
            RS.Events.ToggleSpectate:FireClient(plr, true)
        end)
    end)
end)

RS.Events.ScorePoint.OnServerEvent:Connect(function(player, target)
    local s = Scores[player.Name]
    s.Kills += 1
    s.Points += 1
    
    if s.Points == 4 then RS.Events.Announce:FireAllClients("MATCH POINT: " .. player.Name) end
    if s.Points >= 5 then RS.Events.EndMatch:FireAllClients(player.Name, s) end
end)