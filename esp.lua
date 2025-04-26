loadstring([[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function createESP(player)
    local character = player.Character
    if not character then return end

    local espBox = Instance.new("Part")
    espBox.Size = character:FindFirstChild("HumanoidRootPart").Size + Vector3.new(1, 2, 1)
    espBox.Position = character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0, 3, 0)  -- Adjust to position above the player
    espBox.Anchored = true
    espBox.CanCollide = false
    espBox.Material = Enum.Material.SmoothPlastic
    espBox.BrickColor = BrickColor.new("Bright red")
    espBox.Transparency = 0.5
    espBox.Parent = workspace -- Keep the box in the workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Parent = espBox
    billboard.Adornee = espBox
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = billboard
    nameLabel.Text = player.Name
    nameLabel.TextSize = 18
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
end

RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not player.Character:FindFirstChild("ESP_Box") then
                createESP(player)
            end
        end
    end
end)
]])()
