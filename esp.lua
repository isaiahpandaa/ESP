loadstring([[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local function drawLookAtLine(player)
    local character = player.Character
    if not character then return end

    -- Get the position of the head
    local head = character:FindFirstChild("Head")
    if not head then return end

    -- Create the direction vector (where the player is looking)
    local lookDirection = head.CFrame.LookVector
    local lineLength = 50 -- Length of the "stick"

    -- Calculate the end position for the line (lookDirection * lineLength)
    local endPos = head.Position + lookDirection * lineLength

    -- Create a part to represent the line
    local linePart = Instance.new("Part")
    linePart.Size = Vector3.new(0.2, 0.2, lineLength)
    linePart.CFrame = CFrame.new(head.Position, endPos)
    linePart.Anchored = true
    linePart.CanCollide = false
    linePart.Material = Enum.Material.SmoothPlastic
    linePart.BrickColor = BrickColor.new("Bright green")
    linePart.Transparency = 0.6
    linePart.Parent = workspace

    -- Destroy the line after a short time
    game.Debris:AddItem(linePart, 0.1)
end

-- Continuously check where each player is looking
RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            drawLookAtLine(player)
        end
    end
end)
]])()
