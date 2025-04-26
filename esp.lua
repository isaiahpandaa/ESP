-- Elemental Power Tycoon OP Auto-Farm Script
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Auto-Farm Settings
local AUTO_FARM = true
local AUTO_REBIRTH = true
local AUTO_BUY_UPGRADES = true
local FARM_SPEED = 0.5 -- Seconds between clicks (lower = faster)
local REBIRTH_AT = 10 -- Rebirth when you reach this level

-- Find your Tycoon
local function getYourTycoon()
    for _, tycoon in pairs(Workspace.Tycoons:GetChildren()) do
        if tycoon:FindFirstChild("Owner") and tycoon.Owner.Value == LocalPlayer then
            return tycoon
        end
    end
end

-- Auto-Click Function
local function autoClick()
    while AUTO_FARM and task.wait(FARM_SPEED) do
        local tycoon = getYourTycoon()
        if tycoon and tycoon:FindFirstChild("Buttons") then
            for _, button in pairs(tycoon.Buttons:GetChildren()) do
                if button:FindFirstChild("Click") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, button, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, button, 1)
                end
            end
        end
    end
end

-- Auto-Rebirth Function
local function autoRebirth()
    while AUTO_REBIRTH and task.wait(5) do
        if LocalPlayer:FindFirstChild("Level") and LocalPlayer.Level.Value >= REBIRTH_AT then
            ReplicatedStorage.Rebirth:FireServer()
        end
    end
end

-- Auto-Buy Upgrades
local function autoBuyUpgrades()
    while AUTO_BUY_UPGRADES and task.wait(3) do
        local tycoon = getYourTycoon()
        if tycoon and tycoon:FindFirstChild("Upgrades") then
            for _, upgrade in pairs(tycoon.Upgrades:GetChildren()) do
                if upgrade:FindFirstChild("Click") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, upgrade, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, upgrade, 1)
                end
            end
        end
    end
end

-- Start All Functions
coroutine.wrap(autoClick)()
coroutine.wrap(autoRebirth)()
coroutine.wrap(autoBuyUpgrades)()

-- GUI (Press Right Shift to toggle)
local UIS = game:GetService("UserInputService")
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Elemental Power Tycoon Hacks", "DarkTheme")

local Main = Window:NewTab("Main")
local AutoFarm = Main:NewSection("Auto Farm")

AutoFarm:NewToggle("Auto-Click", "Automatically clicks buttons", function(state)
    AUTO_FARM = state
    if state then coroutine.wrap(autoClick)() end
end)

AutoFarm:NewToggle("Auto-Rebirth", "Auto rebirth at set level", function(state)
    AUTO_REBIRTH = state
    if state then coroutine.wrap(autoRebirth)() end
end)

AutoFarm:NewToggle("Auto-Upgrades", "Buys all upgrades automatically", function(state)
    AUTO_BUY_UPGRADES = state
    if state then coroutine.wrap(autoBuyUpgrades)() end
end)

AutoFarm:NewSlider("Click Speed", "Lower = faster", 2, 0.1, function(value)
    FARM_SPEED = value
end)

AutoFarm:NewTextBox("Rebirth At Level", "Set rebirth level", function(text)
    REBIRTH_AT = tonumber(text) or 10
end)
