local ItemModule = {}

-- All weapons with full stats
ItemModule.Weapons = {
    -- Shooting Weapons
    AssaultRifle = {Type = "Shooting", Damage = 1, Range = 200, Price = 500, LevelReq = 1, Rarity = "Common"},
    BurstRifle = {Type = "Shooting", Damage = 1, Range = 220, Price = 600, LevelReq = 2, Rarity = "Common"},
    Sniper = {Type = "Shooting", Damage = 1, Range = 500, Price = 800, LevelReq = 3, Rarity = "Rare"},
    EnergyRifle = {Type = "Shooting", Damage = 1, Range = 250, Price = 1000, LevelReq = 5, Rarity = "Rare"},
    Exogun = {Type = "Shooting", Damage = 1, Range = 150, Price = 1200, LevelReq = 7, Rarity = "Epic"},
    Flamethrower = {Type = "Shooting", Damage = 1, Range = 80, Price = 1500, LevelReq = 10, Rarity = "Epic"},
    ElectricRifle = {Type = "Shooting", Damage = 1, Range = 200, Price = 1800, LevelReq = 12, Rarity = "Epic"},
    Warper = {Type = "Shooting", Damage = 1, Range = 300, Price = 2000, LevelReq = 15, Rarity = "Legendary"},
    
    -- Reload Weapons
    Handgun = {Type = "Reload", Damage = 1, Range = 150, Price = 200, LevelReq = 1, Rarity = "Common"},
    Revolver = {Type = "Reload", Damage = 1, Range = 180, Price = 400, LevelReq = 2, Rarity = "Common"},
    Uzi = {Type = "Reload", Damage = 1, Range = 120, Price = 600, LevelReq = 3, Rarity = "Common"},
    Minigun = {Type = "Reload", Damage = 1, Range = 200, Price = 2000, LevelReq = 10, Rarity = "Legendary"},
    RPG = {Type = "Reload", Damage = 1, Range = 300, Price = 2500, LevelReq = 12, Rarity = "Legendary"},
    Shotgun = {Type = "Reload", Damage = 1, Range = 80, Price = 800, LevelReq = 4, Rarity = "Rare"},
    AutoShotgun = {Type = "Reload", Damage = 1, Range = 90, Price = 1200, LevelReq = 8, Rarity = "Epic"},
    GrenadeLauncher = {Type = "Reload", Damage = 1, Range = 250, Price = 1500, LevelReq = 9, Rarity = "Epic"},
    
    -- Melee Weapons
    Knife = {Type = "Melee", Damage = 1, Range = 8, Price = 100, LevelReq = 1, Rarity = "Common"},
    Katana = {Type = "Melee", Damage = 1, Range = 10, Price = 300, LevelReq = 1, Rarity = "Common"},
    Daggers = {Type = "Melee", Damage = 1, Range = 8, Price = 400, LevelReq = 2, Rarity = "Common"},
    Gunblade = {Type = "Melee", Damage = 1, Range = 12, Price = 700, LevelReq = 4, Rarity = "Rare"},
    Scythe = {Type = "Melee", Damage = 1, Range = 12, Price = 1000, LevelReq = 6, Rarity = "Rare"},
    BattleAxe = {Type = "Melee", Damage = 1, Range = 10, Price = 1200, LevelReq = 7, Rarity = "Epic"},
    Chainsaw = {Type = "Melee", Damage = 1, Range = 10, Price = 1500, LevelReq = 8, Rarity = "Epic"},
    Maul = {Type = "Melee", Damage = 1, Range = 14, Price = 1800, LevelReq = 11, Rarity = "Epic"},
    BanHammer = {Type = "Melee", Damage = 1, Range = 15, Price = 5000, LevelReq = 20, Rarity = "Legendary"},
    ChainWhip = {Type = "Melee", Damage = 1, Range = 18, Price = 3000, LevelReq = 15, Rarity = "Legendary"},
    NatureBranch = {Type = "Melee", Damage = 1, Range = 10, Price = 50, LevelReq = 1, Rarity = "Common"},
    Fists = {Type = "Melee", Damage = 1, Range = 6, Price = 0, LevelReq = 1, Rarity = "Common"},
    
    -- Utility Items
    Bandage = {Type = "Utility", Heal = false, Price = 50, LevelReq = 1, Rarity = "Common"},
    Medkit = {Type = "Utility", Heal = true, Price = 200, LevelReq = 3, Rarity = "Rare"},
    BearTrap = {Type = "Utility", Price = 150, LevelReq = 2, Rarity = "Common"},
    GrapplingHook = {Type = "Utility", Price = 300, LevelReq = 3, Rarity = "Rare"},
    Warpstone = {Type = "Utility", Price = 500, LevelReq = 5, Rarity = "Epic"},
    JumpPad = {Type = "Utility", Price = 200, LevelReq = 2, Rarity = "Common"},
    Trowel = {Type = "Utility", Price = 100, LevelReq = 1, Rarity = "Common"},
    RiotShield = {Type = "Utility", Price = 400, LevelReq = 4, Rarity = "Rare"},
    WarHorn = {Type = "Utility", Price = 600, LevelReq = 6, Rarity = "Epic"},
    Grenade = {Type = "Utility", Price = 250, LevelReq = 3, Rarity = "Rare"},
    
    -- Scopes/Attachments
    ScopeModule = {Type = "Scope", Price = 300, LevelReq = 2, Rarity = "Rare"},
    LaserSight = {Type = "Scope", Price = 200, LevelReq = 2, Rarity = "Common"},
    
    -- Crafting Materials
    EnergyCell = {Type = "Material", Price = 100, LevelReq = 1, Rarity = "Common"},
    MetalScrap = {Type = "Material", Price = 50, LevelReq = 1, Rarity = "Common"},
    GoldIngot = {Type = "Material", Price = 500, LevelReq = 5, Rarity = "Rare"},
    DarkMatter = {Type = "Material", Price = 1000, LevelReq = 10, Rarity = "Epic"},
    LegendaryCore = {Type = "Material", Price = 2000, LevelReq = 15, Rarity = "Legendary"},
    LifeEssence = {Type = "Material", Price = 500, LevelReq = 8, Rarity = "Epic"},
    PlasmaCore = {Type = "Material", Price = 800, LevelReq = 10, Rarity = "Epic"},
    InfinityStone = {Type = "Material", Price = 5000, LevelReq = 25, Rarity = "Legendary"},
}

-- Get item data
function ItemModule.GetItem(itemName)
    return ItemModule.Weapons[itemName]
end

-- Get item price
function ItemModule.GetPrice(itemName)
    local item = ItemModule.Weapons[itemName]
    return item and item.Price or 0
end

-- Get item type
function ItemModule.GetType(itemName)
    local item = ItemModule.Weapons[itemName]
    return item and item.Type or nil
end

-- Get item rarity
function ItemModule.GetRarity(itemName)
    local item = ItemModule.Weapons[itemName]
    return item and item.Rarity or "Common"
end

-- Get all weapons of a type
function ItemModule.GetItemsByType(itemType)
    local items = {}
    for name, data in pairs(ItemModule.Weapons) do
        if data.Type == itemType then
            table.insert(items, name)
        end
    end
    return items
end

-- Get all purchasable items
function ItemModule.GetShopItems()
    local items = {}
    for name, data in pairs(ItemModule.Weapons) do
        if data.Price > 0 then
            table.insert(items, {Name = name, Price = data.Price, Type = data.Type, Rarity = data.Rarity})
        end
    end
    return items
end

return ItemModule
