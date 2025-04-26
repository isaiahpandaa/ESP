-- Finds the weakest opponent position automatically
local function findWeakSpot()
    -- Placeholder - you can add logic to detect open court areas
    return Vector3.new(
        math.random(-30, 30),
        5,
        math.random(-45, -20) -- Always aims to opponent side
    )
end

local function smartAimServe()
    local ball = findBall()
    if not ball then return end
    
    if (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
        local target = findWeakSpot()
        ball.CFrame = CFrame.lookAt(ball.Position, target + AIM_OFFSET)
    end
end
