loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
-- Fixed Version:
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Configuration
local LINE_LENGTH = 50
local LINE_THICKNESS = 0.2
local LINE_COLOR = Color3.fromRGB(0, 255, 0) -- Bright green
local LINE_TRANSPARENCY = 0.4
local UPDATE_INTERVAL = 0.05 -- Seconds between updates

-- Cache for line parts to avoid constant Instance.new()
local lineCache = {}
local lastUpdate = 0

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
    local endPos = head.Position + (lookDirection * LINE_LENGTH)
    
    linePart.CFrame = CFrame.new(head.Position, endPos)
    linePart.Parent = workspace
end

-- Main update loop
RunService.Heartbeat:Connect(function(deltaTime)
    lastUpdate = lastUpdate + deltaTime
    if lastUpdate < UPDATE_INTERVAL then return end
    lastUpdate = 0

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
