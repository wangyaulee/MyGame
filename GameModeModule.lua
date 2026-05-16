local GameModeModule = {}

GameModeModule.Modes = {
    -- Team modes
    ["1v1"] = {Type = "Team", TeamSize = 1, NumTeams = 2, MinPlayers = 2, MaxPlayers = 2, WinScore = 5, Description = "1 vs 1 duel"},
    ["2v2"] = {Type = "Team", TeamSize = 2, NumTeams = 2, MinPlayers = 4, MaxPlayers = 4, WinScore = 5, Description = "2 vs 2 battle"},
    ["3v3"] = {Type = "Team", TeamSize = 3, NumTeams = 2, MinPlayers = 6, MaxPlayers = 6, WinScore = 5, Description = "3 vs 3 fight"},
    ["4v4"] = {Type = "Team", TeamSize = 4, NumTeams = 2, MinPlayers = 8, MaxPlayers = 8, WinScore = 5, Description = "4 vs 4 war"},
    ["5v5"] = {Type = "Team", TeamSize = 5, NumTeams = 2, MinPlayers = 10, MaxPlayers = 10, WinScore = 5, Description = "5 vs 5 clash"},
    
    -- Multi-team modes
    ["1v1v1"] = {Type = "FFA", PlayerCount = 3, MinPlayers = 3, MaxPlayers = 3, WinScore = 5, Description = "3-player free for all"},
    ["2v2v2"] = {Type = "Team", TeamSize = 2, NumTeams = 3, MinPlayers = 6, MaxPlayers = 6, WinScore = 5, Description = "2v2v2 battle"},
    ["3v3v3"] = {Type = "Team", TeamSize = 3, NumTeams = 3, MinPlayers = 9, MaxPlayers = 9, WinScore = 5, Description = "3v3v3 clash"},
    
    -- FFA modes
    ["FFA"] = {Type = "FFA", PlayerCount = 10, MinPlayers = 4, MaxPlayers = 10, WinScore = 10, Description = "Free for all (10 kills to win)"},
    ["Elimination"] = {Type = "FFA", PlayerCount = 8, MinPlayers = 4, MaxPlayers = 8, WinScore = 50, InstantSpawn = true, Description = "FFA with instant spawn, 50 points to win"},
    
    -- Special modes
    ["Juggernaut"] = {Type = "Special", JuggernautHP = 4000, JuggernautSpeed = 10, NormalSpeed = 16, DamageMultiplier = 3, MinPlayers = 8, MaxPlayers = 8, Description = "1 Juggernaut (4000 HP, 3x damage, slower speed) vs 7 players"},
}

function GameModeModule.GetModeData(modeName)
    return GameModeModule.Modes[modeName]
end

function GameModeModule.GetAllModes()
    local modes = {}
    for name, data in pairs(GameModeModule.Modes) do
        table.insert(modes, {Name = name, Description = data.Description, MinPlayers = data.MinPlayers})
    end
    return modes
end

function GameModeModule.GetQueueDisplay(modeName)
    local data = GameModeModule.Modes[modeName]
    if not data then return nil end
    return {
        Name = modeName,
        Description = data.Description,
        MinPlayers = data.MinPlayers,
        MaxPlayers = data.MaxPlayers,
        Type = data.Type
    }
end

return GameModeModule
