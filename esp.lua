-- Elemental Power Tycoon ULTIMATE Auto-Farm
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Settings
local settings = {
    AutoFarm = true,
    AutoRebirth = true,
    AutoUpgrades = true,
    AutoOrbs = true,
    FarmDelay = 0.3,
    RebirthAt = 10
}

-- Load GUI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Elemental Power Tycoon", "DarkTheme")

-- Improved Tycoon Finder
local function getTycoon()
    for _, tycoon in pairs(Workspace.Tycoons:GetChildren()) do
        if tycoon:FindFirstChild("Owner") and tycoon.Owner.Value == LocalPlayer then
            return tycoon
        end
    end
end

-- Fixed Click Function
local function clickButton(button)
    pcall(function()
        if button:FindFirstChild("Click") then
            ReplicatedStorage.Click:FireServer(button)
        end
    end)
end

-- Main Farm Function
local function autoFarm()
    while settings.AutoFarm and task.wait(settings.FarmDelay) do
        local tycoon = getTycoon()
        if tycoon then
            -- Click money buttons
            for _, button in pairs(tycoon.Buttons:GetDescendants()) do
                if button.Name == "Click" then
                    clickButton(button.Parent)
                end
            end
            
            -- Buy upgrades
            if settings.AutoUpgrades then
                for _, upgrade in pairs(tycoon.Upgrades:GetDescendants()) do
                    if upgrade.Name == "Click" then
                        clickButton(upgrade.Parent)
                    end
                end
            end
        end
    end
end

-- Auto-Rebirth
local function autoRebirth()
    while settings.AutoRebirth and task.wait(5) do
        if LocalPlayer:FindFirstChild("Level") and LocalPlayer.Level.Value >= settings.RebirthAt then
            pcall(function()
                ReplicatedStorage.Rebirth:FireServer()
            end)
        end
    end
end

-- Auto-Collect Orbs
local function collectOrbs()
    while settings.AutoOrbs and task.wait(0.5) do
        pcall(function()
            for _, orb in pairs(Workspace:GetDescendants()) do
                if orb.Name:find("Orb") and orb:IsA("BasePart") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, orb, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, orb, 1)
                end
            end
        end)
    end
end

-- GUI Setup
local MainTab = Window:NewTab("Main")
local FarmSection = MainTab:NewSection("Auto Farm")

FarmSection:NewToggle("Auto-Farm", "Automatically clicks buttons", function(state)
    settings.AutoFarm = state
    if state then coroutine.wrap(autoFarm)() end
end)

FarmSection:NewToggle("Auto-Upgrades", "Buys upgrades automatically", function(state)
    settings.AutoUpgrades = state
end)

FarmSection:NewToggle("Auto-Rebirth", "Rebirths at set level", function(state)
    settings.AutoRebirth = state
    if state then coroutine.wrap(autoRebirth)() end
end)

FarmSection:NewToggle("Auto-Orbs", "Collects all orbs", function(state)
    settings.AutoOrbs = state
    if state then coroutine.wrap(collectOrbs)() end
end)

FarmSection:NewSlider("Click Speed", "Lower = faster", 1, 0.1, function(value)
    settings.FarmDelay = value
end)

FarmSection:NewTextBox("Rebirth At Level", "Set rebirth level", function(text)
    settings.RebirthAt = tonumber(text) or 10
end)

-- Start all functions
coroutine.wrap(autoFarm)()
coroutine.wrap(autoRebirth)()
coroutine.wrap(collectOrbs)()
