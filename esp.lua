local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- CONFIG --
local PREDICTION_COLOR = Color3.fromRGB(255, 0, 0) -- Red marker
local PREDICTION_SIZE = Vector3.new(4, 0.2, 4) -- Width, Height, Length
local PREDICTION_TRANSPARENCY = 0.5 -- 0 = Solid, 1 = Invisible
local MAX_PREDICTION_TIME = 3 -- Seconds ahead to predict
local UPDATE_RATE = 0.05 -- How often it updates (lower = smoother)

-- Find the ball (adjust name if needed)
local ball = Workspace:FindFirstChild("Ball") or Workspace:WaitForChild("Ball")

-- Create the prediction marker
local marker = Instance.new("Part")
marker.Name = "BallPrediction"
marker.Anchored = true
marker.CanCollide = false
marker.Size = PREDICTION_SIZE
marker.Color = PREDICTION_COLOR
marker.Transparency = PREDICTION_TRANSPARENCY
marker.Material = Enum.Material.Neon
marker.Shape = Enum.PartType.Block
marker.Parent = Workspace

-- Advanced trajectory calculation
local function calculateLandingPosition()
    if not ball or not ball:IsDescendantOf(Workspace) then return nil end
    
    local velocity = ball.Velocity
    local position = ball.Position
    local gravity = Workspace.Gravity
    
    -- Ignore if ball isn't moving
    if velocity.Magnitude < 1 then return nil end
    
    -- Calculate time until ball hits ground (quadratic formula)
    local a = 0.5 * gravity
    local b = velocity.Y
    local c = position.Y - marker.Size.Y/2
    local discriminant = b^2 - 4*a*c
    
    if discriminant < 0 then return nil end -- Ball won't hit ground
    
    local t = (-b - math.sqrt(discriminant)) / (2 * a)
    t = math.clamp(t, 0, MAX_PREDICTION_TIME)
    
    -- Calculate landing position (X and Z movement)
    local landingPos = position + velocity * t + Vector3.new(0, 0.1, 0)
    return landingPos
end

-- Smooth updates
local lastUpdate = 0
RunService.Heartbeat:Connect(function(deltaTime)
    lastUpdate = lastUpdate + deltaTime
    if lastUpdate < UPDATE_RATE then return end
    lastUpdate = 0
    
    local landingPos = calculateLandingPosition()
    if landingPos then
        marker.Position = landingPos
        marker.Transparency = PREDICTION_TRANSPARENCY
    else
        marker.Transparency = 1 -- Hide when not applicable
    end
end)

-- Cleanup when script ends
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then -- Press P to toggle
        marker.Transparency = marker.Transparency == 1 and PREDICTION_TRANSPARENCY or 1
    end
end)
