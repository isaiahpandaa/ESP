loadstring([[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local function drawRay(player)
    local character = player.Character
    if not character then return end

    -- Get the position of the head or HumanoidRootPart
    local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    if not head then return end

    -- Create the ray in the direction the player is looking
    local direction = (camera.CFrame.LookVector * 1000)  -- Ray direction (long distance)
    local origin = head.Position + Vector3.new(0, 1, 0)  -- Start point (above the player's head)
    
    -- Create a part to represent the ray
    local rayPart = Instance.new("Part")
    rayPart.Size = Vector3.new(0.2, 0.2, direction.Magnitude)
    rayPart.CFrame = CFrame.new(origin, origin + direction)
    rayPart.Anchored = true
    rayPart.CanCollide = false
    rayPart.Material = Enum.Material.Neon
    rayPart.BrickColor = BrickColor.new("Bright blue")
    rayPart.Transparency = 0.5
    rayPart.Parent = workspace

    -- Destroy the ray part after 1 second
    game.Debris:AddItem(rayPart, 1)
end

-- Continuously check where each player is looking
RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            drawRay(player)
        end
    end
end)
]])()
