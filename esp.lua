local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Settings
local LINE_LENGTH = 30  -- Shorter for volleyball
local LINE_THICKNESS = 0.15
local LINE_COLOR = Color3.fromRGB(0, 255, 100) -- Light green
local LINE_TRANSPARENCY = 0.5
local UPDATE_RATE = 0.1 -- Smoother updates

-- Store lines per player
local lineCache = {}

local function createBeam(player)
    local attachment0 = Instance.new("Attachment")
    local attachment1 = Instance.new("Attachment")
    local beam = Instance.new("Beam")

    -- Parent attachments to the player's head
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end

    attachment0.Parent = head
    attachment1.Parent = head

    -- Configure Beam
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.Width0 = LINE_THICKNESS
    beam.Width1 = LINE_THICKNESS
    beam.Color = ColorSequence.new(LINE_COLOR)
    beam.Transparency = NumberSequence.new(LINE_TRANSPARENCY)
    beam.LightEmission = 1
    beam.Parent = head

    return {beam = beam, attachment0 = attachment0, attachment1 = attachment1}
end

local function updateBeam(player, beamData)
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end

    local lookDir = head.CFrame.LookVector
    local startPos = head.Position + (lookDir * 1) -- Start slightly in front of head
    local endPos = startPos + (lookDir * LINE_LENGTH)

    -- Update beam positions (smooth & stable)
    beamData.attachment0.WorldPosition = startPos
    beamData.attachment1.WorldPosition = endPos
end

-- Main loop (optimized for stability)
RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        if not lineCache[player] then
            lineCache[player] = createBeam(player)
        end

        if lineCache[player] then
            updateBeam(player, lineCache[player])
        end
    end
end)

-- Cleanup when players leave
Players.PlayerRemoving:Connect(function(player)
    if lineCache[player] then
        lineCache[player].beam:Destroy()
        lineCache[player].attachment0:Destroy()
        lineCache[player].attachment1:Destroy()
        lineCache[player] = nil
    end
end)
