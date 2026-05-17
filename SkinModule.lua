--!strict
-- ReplicatedStorage.Modules.SkinModule
-- Author: Skin Boss

local SkinModule = {}
SkinModule.Skin = {
    --skins
    {red = price10},{orange = price10},{yellow = price10},{green = price10},{lime = price10},{blue = price10},{purple = price10},{violet = price10},{maroon = price10},{black = price10},{whote = price10}
}
-- Definitions
export type SkinData = {
    Id: string,
    Name: string,
    Rarity: string, -- Common, Rare, Epic, Legendary, Mythic
    TextureId: string?, -- Optional: If nil, uses Color3 only
    Color3: Color3?,
    Price: number
}

type RarityColor = { [string]: Color3 }

local RARITY_COLORS: RarityColor = {
    Common = Color3.fromRGB(150, 150, 150),    -- Gray
    Rare = Color3.fromRGB(0, 100, 255),        -- Blue
    Epic = Color3.fromRGB(180, 50, 255),       -- Purple
    Legendary = Color3.fromRGB(255, 140, 0),   -- Orange
    Mythic = Color3.fromHSV(0, 0, 1)           -- Rainbow handled in logic
}

local SKIN_DATABASE: { [string]: SkinData } = {
    -- Default
    ["default_rifle"] = {
        Id = "default_rifle",
        Name = "Standard Issue",
        Rarity = "Common",
        Color3 = Color3.fromRGB(80, 80, 80),
        Price = 0
    },
    
    -- Custom Skins
    ["blue_steel"] = {
        Id = "blue_steel",
        Name = "Blue Steel",
        Rarity = "Rare",
        TextureId = "rbxassetid://6754049134", -- Example metal texture
        Color3 = Color3.fromRGB(50, 50, 150),
        Price = 500
    },
    
    ["golden_god"] = {
        Id = "golden_god",
        Name = "Golden God",
        Rarity = "Legendary",
        TextureId = "rbxassetid://277874025", -- Gold texture
        Color3 = Color3.fromRGB(255, 215, 0),
        Price = 5000
    },

    ["void_walker"] = {
        Id = "void_walker",
        Name = "Void Walker",
        Rarity = "Mythic",
        Color3 = Color3.fromRGB(50, 0, 50), -- Base purple
        Price = 99999
    }
}

--[[
    Get Skin Data by ID
]]
function SkinModule.GetSkin(skinId: string): SkinData?
    return SKIN_DATABASE[skinId]
end

--[[
    Get all skins in the game
]]
function SkinModule.GetAllSkins(): { [string]: SkinData }
    return SKIN_DATABASE
end

--[[
    Get the Color3 associated with a Rarity string
]]
function SkinModule.GetRarityColor(rarity: string): Color3
    return RARITY_COLORS[rarity] or Color3.new(1, 1, 1)
end

--[[
    Apply a skin to a Weapon Model.
    @param weaponModel Model - The tool/weapon mesh
    @param skinData SkinData - The skin to apply
]]
function SkinModule.ApplySkinToWeapon(weaponModel: Model, skinData: SkinData)
    -- 1. Apply Color to primary parts (usually named "Body", "Handle", or "Mesh")
    for _, part in ipairs(weaponModel:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Identify parts that are meant to be skinned (exclude inner mechanics)
            if part.Name:match("Body") or part.Name:match("Mesh") or part.Name == "Handle" then
                part.Color = skinData.Color3 or Color3.new(1, 1, 1)
                part.Material = Enum.Material.SmoothPlastic -- Reset material or change based on skin

                -- 2. Apply Texture if provided
                if skinData.TextureId then
                    -- Remove old textures
                    for _, child in ipairs(part:GetChildren()) do
                        if child:IsA("Texture") or child:IsA("Decal") then
                            child:Destroy()
                        end
                    end
                    
                    local texture = Instance.new("Texture")
                    texture.Texture = skinData.TextureId
                    texture.Face = Enum.NormalId.Front -- Simplified; usually needs UV mapping logic
                    texture.StudsPerTileU = 1
                    texture.StudsPerTileV = 1
                    texture.Parent = part
                end
            end
        end
    end
    
    -- Special handling for Mythic Rainbow effect
    if skinData.Rarity == "Mythic" then
        -- Spawn a script or use a loop to tween hue (omitted for simplicity, returns base data)
        warn("Mythic skin applied - rainbow logic recommended")
    end
end

return SkinModule
