local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Auto-Farm Settings
local AUTO_STEAL = true
local AUTO_UPGRADE = true
local STEAL_DELAY = 0.5 -- Seconds between steals
local TARGET_RICHEST = true -- Steal from richest players first

-- Time Stealing Function
local function stealTime()
    if not LocalPlayer.Character then return end
    
    local target
    if TARGET_RICHEST then
        -- Find player with most time
        local richestPlayer, maxTime = nil, 0
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local time = player:FindFirstChild("Time") and player.Time.Value or 0
                if time > maxTime then
                    richestPlayer = player
                    maxTime = time
                end
            end
        end
        target = richestPlayer
    else
        -- Steal from random player
        local validPlayers = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(validPlayers, player)
            end
        end
        target = validPlayers[math.random(#validPlayers)]
    end

    if target then
        game:GetService("ReplicatedStorage").StealTime:FireServer(target)
    end
end

-- Auto-Upgrade Function
local function upgradeStats()
    local reborn = LocalPlayer:FindFirstChild("Reborns") and LocalPlayer.Reborns.Value or 0
    if reborn >= 5 then
        game:GetService("ReplicatedStorage").Reborn:FireServer()
    else
        game:GetService("ReplicatedStorage").Upgrade:FireServer("Speed")
        game:GetService("ReplicatedStorage").Upgrade:FireServer("StealAmount")
    end
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    if AUTO_STEAL then
        stealTime()
        wait(STEAL_DELAY)
    end
    if AUTO_UPGRADE then
        upgradeStats()
    end
end)

-- GUI Toggle
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Steal Time Hacks", "DarkTheme")

local MainTab = Window:NewTab("Main")
local AutoFarmSection = MainTab:NewSection("Auto Farm")

AutoFarmSection:NewToggle("Auto Steal Time", "Steals automatically", function(state)
    AUTO_STEAL = state
end)

AutoFarmSection:NewToggle("Auto Upgrade", "Upgrades automatically", function(state)
    AUTO_UPGRADE = state
end)

AutoFarmSection:NewSlider("Steal Delay", "Seconds between steals", 5, 0.1, function(value)
    STEAL_DELAY = value
end)

AutoFarmSection:NewToggle("Target Richest", "Steals from richest players", function(state)
    TARGET_RICHEST = state
end)
