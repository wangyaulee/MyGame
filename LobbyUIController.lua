local RS = game:GetService("ReplicatedStorage")
local gui = script.Parent

-- Map Voting
gui.RandomBtn.MouseButton1Click:Connect(function()
    local maps = {"Library","Crossroad","Museum","Lobby","Shooting range","Dimension","Farm","Spaceship","Village","Playground","Theatre","Hospital","Titanic ship","Jail","Minecraft","Black city","Undreground","World war II","Police station","Office","Big areana","Pack of toy", "Arena"}
    RS.Events.VoteMap:FireServer(maps[math.random(1, #maps)])
end)

-- Buy Currency
gui.ShopFrame.BuyMoney.MouseButton1Click:Connect(function(tier)
    RS.Events.BuyCurrency:FireServer(tier)
end)