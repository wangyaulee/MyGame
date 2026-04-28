1. The Data Module (All Weapons)

Location: ReplicatedStorage > ItemModule (ModuleScript)

Lua
local ItemModule = {}

ItemModule.MasterInventory = {
	["Rifle Spear"] = {"Spear-Shaft", "Kinetic-Point"}, ["Energy Sniper"] = {"Rail-Frame", "Ion-Charge"},
	["Energy Revolver"] = {"Rotary-Frame", "Plasma-Cell"}, ["Flashbang Launcher"] = {"Thumper-Tube", "Magnesium-Core"},
	["Bandage"] = {"Cloth-Wrap", "Healing-Salve"}, ["Bear Trap"] = {"Heavy-Spring", "Serrated-Jaws"},
	["Assault Rifle"] = {"Assault-Receiver", "Standard-Mag"}, ["Burst Rifle"] = {"Triple-Trigger", "Burst-Capacitor"},
	["Sniper"] = {"Bolt-Action", "High-Caliber-Bolt"}, ["Energy Rifle"] = {"Heat-Sink-Frame", "Battery-Pack"},
	["Shotgun"] = {"Pump-Action", "Buckshot-Shell"}, ["Auto Shotgun"] = {"Drum-Action", "Dragon-Breath-Core"},
	["Handgun"] = {"Semi-Slide", "9mm-Clip"}, ["Revolver"] = {"Cylinder-Frame", "Magnum-Hammer"},
	["Uzi"] = {"Micro-Receiver", "High-Speed-Mag"}, ["Minigun"] = {"Rotary-Barrel", "Endless-Belt"},
	["RPG"] = {"Tube-Launcher", "Explosive-Rocket"}, ["Grenade Launcher"] = {"Revolving-Drum", "HE-Grenade"},
	["Exogun"] = {"Alien-Chassis", "Pulse-Engine"}, ["Flamethrower"] = {"Fuel-Tank", "Igniter-Nozzle"},
	["Bow"] = {"Tension-String", "Sharp-Arrow"}, ["Crossbow"] = {"Mechanical-String", "Heavy-Bolt"},
	["Slingshot"] = {"Elastic-Snap", "Pebble-Payload"}, ["Katana"] = {"Hilt-Grip", "Razor-Edge"},
	["Knife"] = {"Compact-Handle", "Steel-Blade"}, ["Daggers"] = {"Dual-Grips", "Swift-Points"},
	["Gunblade"] = {"Trigger-Hilt", "Hybrid-Edge"}, ["Scythe"] = {"Curved-Pole", "Void-Edge"},
	["Battle Axe"] = {"Weighted-Handle", "Cleaving-Head"}, ["Chainsaw"] = {"Motor-Housing", "Saw-Chain"},
	["Maul"] = {"Long-Staff", "Crushing-Weight"}, ["Ban Hammer"] = {"Admin-Handle", "Ban-Core"},
	["Chain Whip"] = {"Link-Handle", "Barbed-Steel"}, ["Nature Branch"] = {"Living-Wood", "Spore-Pod"},
	["Electric Rifle"] = {"Tesla-Frame", "Volt-Capacitor"}, ["Air Handgun"] = {"Pneumatic-Grip", "Compressed-O2"},
	["Fists"] = {"Bare-Knuckle", "Pure-Grit"}, ["Warper"] = {"Warp-Handle", "Void-Link"},
	["Grappling Hook"] = {"Winch-Unit", "Claw-Anchor"}, ["Warpstone"] = {"Focus-Stone", "Blink-Energy"},
	["Jump Pad"] = {"Pressure-Plate", "Launch-Spring"}, ["Trowel"] = {"Builder-Grip", "Instant-Brick"},
	["Riot Shield"] = {"Arm-Brace", "Impact-Plate"}, ["Medkit"] = {"Injector-Case", "Nano-Serum"},
	["War Horn"] = {"Brass-Valve", "Buff-Frequency"}, ["Grenade"] = {"Pin-Mechanism", "Explosive-Powder"}
}

function ItemModule.Split(name)
	local p = ItemModule.MasterInventory[name]
	return p and p[1], p and p[2]
end

return ItemModule
2. The Server Brain (Wins, Rounds, 1HP)

Location: ServerScriptService > GameHandler

Lua
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GAME_MODE = "InstantDeath" -- "Normal" or "InstantDeath"
local WIN_LIMIT = (GAME_MODE == "InstantDeath") and 50 or 5
local Scores = {}

Players.PlayerAdded:Connect(function(player)
	Scores[player.Name] = {Points = 0, Kills = 0, Deaths = 0, Swaps = 0}
	player.CharacterAdded:Connect(function(char)
		char:WaitForChild("Humanoid").MaxHealth = 1
		char.Humanoid.Health = 1
		char.Humanoid.Died:Connect(function()
			Scores[player.Name].Deaths += 1
			RS.Events.ToggleSpectate:FireClient(player, true)
		end)
	end)
end)

RS.Events.ScorePoint.OnServerEvent:Connect(function(player, target)
	if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
		target.Humanoid.Health = 0
		Scores[player.Name].Kills += 1
		Scores[player.Name].Points += 1
		
		local p = Scores[player.Name].Points
		if GAME_MODE ~= "InstantDeath" and p == 4 then RS.Events.Announce:FireAllClients("MATCH POINT") end
		
		if p >= WIN_LIMIT then
			RS.Events.EndGame:FireAllClients(player.Name, Scores[player.Name])
		end
	end
end)

RS.Events.SwapWeapon.OnServerEvent:Connect(function(player, itemName)
	if Scores[player.Name].Swaps < 2 then
		Scores[player.Name].Swaps += 1
		local tool = Instance.new("Tool")
		tool.Name = itemName
		local h = Instance.new("Part") h.Name = "Handle" h.Parent = tool
		tool.Parent = player.Backpack
	end
end)
3. The Movement & Combat (Universal Engine)

Location: StarterCharacterScripts > MainController (LocalScript)

Lua
local CAS = game:GetService("ContextActionService")
local RS = game:GetService("ReplicatedStorage")
local ItemModule = require(RS.ItemModule)
local lp = game.Players.LocalPlayer
local char = script.Parent
local hum = char:WaitForChild("Humanoid")

lp.CameraMode = Enum.CameraMode.LockFirstPerson

-- SLIDING
CAS:BindAction("Slide", function(name, state)
	if state == Enum.UserInputState.Begin and hum.MoveDirection.Magnitude > 0 then
		local bv = Instance.new("BodyVelocity")
		bv.Velocity = char.PrimaryPart.CFrame.LookVector * 50
		bv.MaxForce = Vector3.new(10000, 0, 10000)
		bv.Parent = char.PrimaryPart
		hum.CameraOffset = Vector3.new(0, -1.5, 0)
		task.wait(0.5)
		bv:Destroy()
		hum.CameraOffset = Vector3.new(0, 0, 0)
	end
end, true, Enum.KeyCode.LeftShift)

-- COMBAT
game:GetService("UserInputService").InputBegan:Connect(function(i, p)
	if p or i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if not tool then return end
	
	local mech, core = ItemModule.Split(tool.Name)
	local mouse = lp:GetMouse()
	
	-- All Ranged Detection
	if mech:find("Frame") or mech:find("Receiver") or mech:find("Tube") or mech:find("Grip") then
		local ray = workspace:Raycast(char.PrimaryPart.Position, (mouse.Hit.p - char.PrimaryPart.Position).Unit * 500)
		if ray and ray.Instance.Parent:FindFirstChild("Humanoid") then
			RS.Events.ScorePoint:FireServer(ray.Instance.Parent)
		end
	-- All Melee Detection
	elseif mech:find("Hilt") or mech:find("Handle") or mech:find("Grip") then
		if mouse.Target and (char.PrimaryPart.Position - mouse.Target.Position).Magnitude < 10 then
			RS.Events.ScorePoint:FireServer(mouse.Target.Parent)
		end
	end
end)
4. Spectate & Stats UI

Location: StarterGui > GameGui (LocalScript)

Lua
local RS = game:GetService("ReplicatedStorage")
local lp = game.Players.LocalPlayer

RS.Events.EndGame.OnClientEvent:Connect(function(winnerName, stats)
	local gui = script.Parent.WinnerFrame
	gui.Visible = true
	gui.WinnerText.Text = winnerName .. " WINS!"
	gui.StatsText.Text = "K:" .. stats.Kills .. " D:" .. stats.Deaths
	gui.LeaveBtn.MouseButton1Click:Connect(function() lp:Kick("Match Ended") end)
end)

-- Spectate Switcher
script.Parent.NextBtn.MouseButton1Click:Connect(function()
	local plrs = game.Players:GetPlayers()
	workspace.CurrentCamera.CameraSubject = plrs[math.random(1,#plrs)].Character.Humanoid
end)
Final Steps: Create RemoteEvents in ReplicatedStorage.Events: ScorePoint, SwapWeapon, ToggleSpectate, Announce, EndGame.1. The Map List & Logic

Add this to the top of your ServerScriptService > GameHandler:

Lua
local ServerStorage = game:GetService("ServerStorage")
local MapFolder = ServerStorage:WaitForChild("Maps") -- Place your map models here

local MapList = {
	"CrossroadArena", "MuseumLobby", "ShootingRange", "DimensionFarm", 
	"SpaceShip", "Village", "Playground", "Theatre", "Hospital", 
	"Titanic", "Jail", "Minecraft4Chunk", "BlackCity", "Underground", 
	"WorldWarII", "PoliceStation", "Office", "BigArena", "Supermarket"
}

local currentVotes = {} -- [MapName] = VoteCount

-- TIE-BREAKER FUNCTION
local function GetWinningMap()
	local highest = -1
	local winners = {}

	for name, count in pairs(currentVotes) do
		if count > highest then
			highest = count
			winners = {name}
		elseif count == highest then
			table.insert(winners, name)
		end
	end

	-- If no one voted, pick a random map from the full list
	if #winners == 0 then
		return MapList[math.random(1, #MapList)]
	end

	-- Pick one randomly from the tied winners (50/50, etc)
	return winners[math.random(1, #winners)]
end
2. The Map Loader (Server-Side)

This handles clearing the old map and moving players to the new one.

Lua
local function LoadMap(mapName)
	-- 1. Clear existing map
	local oldMap = workspace:FindFirstChild("CurrentActiveMap")
	if oldMap then oldMap:Destroy() end

	-- 2. Clone new map from ServerStorage
	local template = MapFolder:FindFirstChild(mapName)
	if template then
		local newMap = template:Clone()
		newMap.Name = "CurrentActiveMap"
		newMap.Parent = workspace
		
		-- 3. Teleport all players to random spawns in the map
		local spawns = newMap:FindFirstChild("Spawns"):GetChildren()
		for _, player in pairs(game.Players:GetPlayers()) do
			if player.Character then
				local randomSpawn = spawns[math.random(1, #spawns)]
				player.Character.HumanoidRootPart.CFrame = randomSpawn.CFrame + Vector3.new(0, 3, 0)
			end
		end
	end
end
3. The Map Vote Remote (Server-Side)

Lua
game.ReplicatedStorage.Events.CastVote.OnServerEvent:Connect(function(player, mapName)
	-- Prevent double voting if you want
	currentVotes[mapName] = (currentVotes[mapName] or 0) + 1
end)
4. The Voting UI Logic (LocalScript)

Location: StarterGui > MapVoteGui > Frame

This script picks 3 random maps for the players to choose from at the start of the round.

Lua
local RS = game:GetService("ReplicatedStorage")
local VoteEvent = RS.Events:WaitForChild("CastVote")

local options = {"Titanic", "Office", "Minecraft4Chunk"} -- Logic to pick 3 randoms

for _, button in pairs(script.Parent:GetChildren()) do
	if button:IsA("TextButton") then
		button.MouseButton1Click:Connect(function()
			VoteEvent:FireServer(button.Name)
			-- Smooth UI: Highlight the choice
			button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			-- Disable other buttons
			for _, b in pairs(script.Parent:GetChildren()) do
				if b:IsA("TextButton") then b.Active = false end
			end
		end)
	end
end
🚀 How to build the Maps for 1-Week Success:

Map Folder: Create a folder in ServerStorage called Maps.

Organization: Inside each Map Model (e.g., "Titanic"), create a folder called Spawns.

Spawns: Put several invisible, non-collidable Parts in the Spawns folder. This is where the code will teleport players.

1HP Safety: Make sure every map has a "Kill Part" or a high ledge. If it's a Spaceship or Titanic, place a large part underneath the map that sets Humanoid.Health = 0 when touched so they respawn instantly.

One Week Reminder:

Don't build detail! For the Supermarket, just use shelves (cubes) and a floor. For the Theatre, just a stage and seats. The "Weird Guns" are the stars of the show—the maps just need to be solid enough to fight in!