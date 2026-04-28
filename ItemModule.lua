local ItemModule = {}

ItemModule.Items = {
    -- Shooting
    ["Assault Rifle"] = {Type = "Shooting"}, ["Burst Rifle"] = {Type = "Shooting"}, ["Sniper"] = {Type = "Shooting"}, ["Energy Rifle"] = {Type = "Shooting"}, ["Rifle Spear"] = {Type = "Shooting"}, ["Energy Sniper"] = {Type = "Shooting"}, ["Exogun"] = {Type = "Shooting"}, ["Flamethrower"] = {Type = "Shooting"}, ["Electric Rifle"] = {Type = "Shooting"}, ["Air Handgun"] = {Type = "Shooting"}, ["Warper"] = {Type = "Shooting"},
    -- Reload
    ["Handgun"] = {Type = "Reload"}, ["Revolver"] = {Type = "Reload"}, ["Uzi"] = {Type = "Reload"}, ["Minigun"] = {Type = "Reload"}, ["RPG"] = {Type = "Reload"}, ["Grenade Launcher"] = {Type = "Reload"}, ["Shotgun"] = {Type = "Reload"}, ["Auto Shotgun"] = {Type = "Reload"},
    -- Melee
    ["Katana"] = {Type = "Melee"}, ["Knife"] = {Type = "Melee"}, ["Daggers"] = {Type = "Melee"}, ["Gunblade"] = {Type = "Melee"}, ["Scythe"] = {Type = "Melee"}, ["Battle Axe"] = {Type = "Melee"}, ["Chainsaw"] = {Type = "Melee"}, ["Maul"] = {Type = "Melee"}, ["Ban Hammer"] = {Type = "Melee"}, ["Chain Whip"] = {Type = "Melee"}, ["Nature Branch"] = {Type = "Melee"}, ["Fists"] = {Type = "Melee"},
    -- Utility
    ["Bandage"] = {Type = "Utility"}, ["Bear Trap"] = {Type = "Utility"}, ["Grappling Hook"] = {Type = "Utility"}, ["Warpstone"] = {Type = "Utility"}, ["Jump Pad"] = {Type = "Utility"}, ["Trowel"] = {Type = "Utility"}, ["Riot Shield"] = {Type = "Utility"}, ["Medkit"] = {Type = "Utility"}, ["War Horn"] = {Type = "Utility"}, ["Grenade"] = {Type = "Utility"},
    -- Scope
    ["Scope Module"] = {Type = "Scope"}, ["Laser Sight"] = {Type = "Scope"}
}

function ItemModule.ValidateCraft(selection)
    local stats = {Melee = 0, Utility = 0, Reload = 0, Shooting = 0, Scope = 0}
    for _, name in pairs(selection) do
        local item = ItemModule.Items[name]
        if item then stats[item.Type] = (stats[item.Type] or 0) + 1 end
    end
    -- Crafting Rules: At least 1 Reload and 1 Shooting
    return stats.Reload >= 1 and stats.Shooting >= 1
end

return ItemModule
