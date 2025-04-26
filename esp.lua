local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- CONFIG --
local PREDICTION_COLOR = Color3.fromRGB(255, 50, 50) -- Bright red
local PREDICTION_SIZE = Vector3.new(5, 0.3, 5) -- Width, Height, Length
local PREDICTION_TRANSPARENCY = 0.6 -- 0 = Solid, 1 = Invisible
local MAX_PREDICTION_TIME = 2 -- Max seconds ahead to predict
local UPDATE_RATE = 0.1 -- Smoother performance

-- Find the ball (works even if it's renamed)
local function findBall()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name == "Volleyball") then
            return obj
        end
    end
    return nil
end

-- Create the landing marker
local marker = Instance.new("Part")
marker.Name = "BallLandingMarker"
marker.Anchored = true
marker.CanCollide = false
marker.Size = PREDICTION_SIZE
marker.Color = PREDICTION_COLOR
marker.Transparency = PREDICTION_TRANSPARENCY
marker.Material = Enum.Material.Neon
marker.Parent = Workspace

-- Better physics prediction
local function predictLanding(ball)
    if not ball or not ball:IsDescendantOf(Workspace) then return nil end
    
    local pos = ball.Position
    local vel = ball.Velocity
    local gravity = Workspace.Gravity
    
    -- Ignore if ball is moving too slow
    if vel.Magnitude < 5 then return nil end
    
    -- Calculate time until landing (quadratic formula)
    local a = -0.5 * gravity
    local b = vel.Y
    local c = pos.Y - marker.Size.Y/2
    
    local discriminant = b^2 - 4*a*c
    if discriminant < 0 then return nil end -- Ball won't land
    
    local t = math.min((-b - math.sqrt(discriminant)) / (2*a), MAX_PREDICTION_TIME)
    local landingPos = pos + vel * t + Vector3.new(0, 0.1, 0)
    
    return landingPos
end

-- Main update loop (now with error handling)
RunService.Heartbeat:Connect(function()
    local ball = findBall()
    if not ball then
        marker.Transparency = 1 -- Hide if no ball
        return
    end
    
    local landingPos = predictLanding(ball)
    if landingPos then
        marker.Position = landingPos
        marker.Transparency = PREDICTION_TRANSPARENCY
    else
        marker.Transparency = 1 -- Hide if not landing soon
    end
end)

-- Toggle with [P] key
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        marker.Transparency = (marker.Transparency == 1) and PREDICTION_TRANSPARENCY or 1
    end
end)
