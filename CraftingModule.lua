local CraftingModule = {}
local ItemModule = require(script.Parent.ItemModule)

-- Crafting recipes: Result = {Required Items (any order, 1 of each)}
CraftingModule.Recipes = {
    -- Combine 2 weapons
    EnergySniper = {Required = {"AssaultRifle", "Sniper"}, Result = "EnergySniper", SuccessRate = 0.8},
    PlasmaGun = {Required = {"EnergyRifle", "RPG"}, Result = "PlasmaGun", SuccessRate = 0.7},
    VoidBlade = {Required = {"Katana", "Scythe"}, Result = "VoidBlade", SuccessRate = 0.75},
    GoldenBanHammer = {Required = {"BanHammer", "GoldIngot"}, Result = "GoldenBanHammer", SuccessRate = 0.6},
    InfinityGauntlet = {Required = {"Chainsaw", "EnergyRifle", "RPG"}, Result = "InfinityGauntlet", SuccessRate = 0.5},
    DoubleBarrel = {Required = {"Shotgun", "Shotgun"}, Result = "DoubleBarrel", SuccessRate = 0.9},
    DualUzis = {Required = {"Uzi", "Uzi"}, Result = "DualUzis", SuccessRate = 0.9},
    LaserSword = {Required = {"Katana", "EnergyCell"}, Result = "LaserSword", SuccessRate = 0.85},
    FlameKatana = {Required = {"Katana", "Flamethrower"}, Result = "FlameKatana", SuccessRate = 0.7},
    ExogunMK2 = {Required = {"Exogun", "EnergyCell", "EnergyCell"}, Result = "ExogunMK2", SuccessRate = 0.65},
    MinigunTurret = {Required = {"Minigun", "MetalScrap", "MetalScrap", "MetalScrap"}, Result = "MinigunTurret", SuccessRate = 0.55},
    SniperShotgun = {Required = {"Sniper", "Shotgun"}, Result = "SniperShotgun", SuccessRate = 0.8},
    ElectricWarper = {Required = {"ElectricRifle", "Warper"}, Result = "ElectricWarper", SuccessRate = 0.6},
    AssaultRiflePlus = {Required = {"AssaultRifle", "ScopeModule", "LaserSight"}, Result = "AssaultRiflePlus", SuccessRate = 0.9},
}

-- Random chest combine (put any items, get random reward)
function CraftingModule.CombineRandom(itemsPlaced)
    -- itemsPlaced is a table of item names the player put in the chest
    if not itemsPlaced or #itemsPlaced < 2 then
        return nil, "Need at least 2 items to combine!"
    end
    
    -- Calculate total value of items placed
    local totalValue = 0
    for _, itemName in pairs(itemsPlaced) do
        totalValue = totalValue + (ItemModule.GetPrice(itemName) or 0)
    end
    
    -- Determine chest rarity based on total value
    local chestType = "Common"
    if totalValue >= 5000 then
        chestType = "Legendary"
    elseif totalValue >= 2000 then
        chestType = "Epic"
    elseif totalValue >= 800 then
        chestType = "Rare"
    end
    
    -- Get possible rewards based on chest type
    local possibleRewards = {}
    for name, data in pairs(ItemModule.Weapons) do
        if data.Rarity == chestType then
            table.insert(possibleRewards, name)
        elseif chestType == "Legendary" and data.Rarity == "Epic" then
            table.insert(possibleRewards, name)
        elseif chestType == "Epic" and data.Rarity == "Rare" then
            table.insert(possibleRewards, name)
        elseif chestType == "Rare" and data.Rarity == "Common" then
            table.insert(possibleRewards, name)
        end
    end
    
    if #possibleRewards == 0 then
        possibleRewards = {"Knife", "Handgun", "Bandage"}
    end
    
    -- Random reward
    local reward = possibleRewards[math.random(1, #possibleRewards)]
    return reward, "Success! You got: " .. reward, chestType
end

-- Combine specific recipe
function CraftingModule.CombineRecipe(itemsPlaced, recipeName)
    local recipe = CraftingModule.Recipes[recipeName]
    if not recipe then
        return nil, "Unknown recipe!"
    end
    
    -- Check if all required items are present
    local requiredCopy = {}
    for _, req in pairs(recipe.Required) do
        requiredCopy[req] = (requiredCopy[req] or 0) + 1
    end
    
    local itemsCopy = {}
    for _, item in pairs(itemsPlaced) do
        itemsCopy[item] = (itemsCopy[item] or 0) + 1
    end
    
    for reqItem, reqCount in pairs(requiredCopy) do
        if (itemsCopy[reqItem] or 0) < reqCount then
            return nil, "Missing: " .. reqItem
        end
    end
    
    -- Check success rate
    if math.random() <= recipe.SuccessRate then
        return recipe.Result, "Crafting successful! You got: " .. recipe.Result
    else
        -- Fail - lose all items
        return nil, "Crafting failed! All items were destroyed."
    end
end

-- Get all available recipes
function CraftingModule.GetRecipes()
    local recipes = {}
    for name, data in pairs(CraftingModule.Recipes) do
        table.insert(recipes, {Name = name, Required = data.Required, Result = data.Result, SuccessRate = data.SuccessRate})
    end
    return recipes
end

return CraftingModule
