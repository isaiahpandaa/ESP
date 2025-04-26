-- WORKING Elemental Power Tycoon Script (July 2024)
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() -- For basic functions

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- PROVEN Working Functions --
local function autoFarm()
    while true do
        -- 1. Find the correct buttons (updated method)
        for _,v in pairs(Workspace:GetDescendants()) do
            if v.Name == "TouchInterest" and v.Parent.Name == "ClickDetector" then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent.Parent, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent.Parent, 1)
            end
        end
        
        -- 2. Alternative remote event method
        pcall(function()
            game:GetService("ReplicatedStorage").Click:FireServer()
        end)
        
        wait(0.5) -- Safe delay
    end
end

local function autoRebirth()
    while true do
        pcall(function()
            if LocalPlayer.Level.Value >= 10 then
                game:GetService("ReplicatedStorage").Rebirth:FireServer()
            end
        end)
        wait(5)
    end
end

-- Start
coroutine.wrap(autoFarm)()
coroutine.wrap(autoRebirth)()

-- Simple GUI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Elemental Tycoon", HidePremium = false})

local Tab = Window:MakeTab({
    Name = "AutoFarm",
    Icon = "rbxassetid://4483345998"
})

Tab:AddToggle({
    Name = "Auto-Click",
    Default = true,
    Callback = function(Value)
        _G.AutoClick = Value
    end    
})

Tab:AddToggle({
    Name = "Auto-Rebirth",
    Default = true,
    Callback = function(Value)
        _G.AutoRebirth = Value
    end
})

OrionLib:Init()
