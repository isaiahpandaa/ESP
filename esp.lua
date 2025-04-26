local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Settings
local LINE_LENGTH = 50
local LINE_THICKNESS = 0.2
local LINE_COLOR = Color3.fromRGB(0, 255, 0) -- Bright green
local LINE_TRANSPARENCY = 0.4
local UPDATE_INTERVAL = 0.05 -- Seconds between updates

-- Store lines per player
local lineCache = {}

local function createLine()
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = LINE_COLOR
    part.Transparency = LINE_TRANSPARENCY
    part.Size = Vector3.new(LINE_THICKNESS, LINE_THICKNESS, LINE_LENGTH)
    return part
end

local function updateLookLine(player, linePart)
    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local lookDirection = head.CFrame.LookVector
    local startPos = head.Position + (lookDirection * 0.5) -- Start slightly in front of the head
    local endPos = startPos + (lookDirection * LINE_LENGTH) -- Extend forward

    -- Position the line so it only appears in front
    linePart.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -LINE_LENGTH/2)
    linePart.Parent = workspace
end

-- Main loop
RunService.Heartbeat:Connect(function(deltaTime)
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        if not lineCache[player] then
            lineCache[player] = createLine()
        end

        updateLookLine(player, lineCache[player])
    end
end)

-- Cleanup when players leave
Players.PlayerRemoving:Connect(function(player)
    if lineCache[player] then
        lineCache[player]:Destroy()
        lineCache[player] = nil
    end
end)
