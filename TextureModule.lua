--!strict
-- ReplicatedStorage.Modules.TextureModule
-- Author: Skin Boss

local TextureModule = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage:WaitForChild("Assets") -- Assuming a folder for textures

--[[
    Applies a Decal to a specific face of a Part.
]]
function TextureModule.ApplyDecal(part: BasePart, textureId: string, face: Enum.NormalId?)
    local existingDecal = part:FindFirstChildOfClass("Decal")
    if existingDecal then existingDecal:Destroy() end

    local decal = Instance.new("Decal")
    decal.Texture = textureId
    decal.Face = face or Enum.NormalId.Front
    decal.Parent = part
end

--[[
    Swaps the material of a Part and all its descendants.
]]
function TextureModule.SwapMaterial(model: Model, material: Enum.Material)
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("BasePart") then
            desc.Material = material
        end
    end
end

--[[
    Loads a texture set for a Map.
    Assumes Map model has Parts named "Floor", "Wall", "Prop".
]]
function TextureModule.LoadMapTextures(mapModel: Model, theme: string)
    -- Define textures in a local table or load from ReplicatedStorage
    local themes = {
        SciFi = {
            Wall = "rbxassetid://6765234876", -- Example tiled metal
            Floor = "rbxassetid://6765235123", -- Example grid
            Prop = "rbxassetid://6765235532"
        },
        Ancient = {
            Wall = "rbxassetid://123456789", -- Stone
            Floor = "rbxassetid://123456790", -- Dirt
            Prop = "rbxassetid://123456791"
        }
    }

    local selectedTheme = themes[theme]
    if not selectedTheme then 
        warn("Texture theme not found: " .. theme)
        return 
    end

    for _, part in ipairs(mapModel:GetDescendants()) do
        if part:IsA("BasePart") then
            local partNameLower = part.Name:lower()
            
            if partNameLower:find("wall") then
                TextureModule.ApplyDecal(part, selectedTheme.Wall)
            elseif partNameLower:find("floor") then
                TextureModule.ApplyDecal(part, selectedTheme.Floor)
            elseif partNameLower:find("prop") then
                TextureModule.ApplyDecal(part, selectedTheme.Prop)
            end
        end
    end
end

return TextureModule
