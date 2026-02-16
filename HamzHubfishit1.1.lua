-- HamzHub v4.5 | Quick Fix: Minimize Persist, Auto Sell & Fish Work

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local env = getgenv and getgenv() or _G

-- Loading Screen
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "HamzLoading"
local f = Instance.new("Frame", sg)
f.Size = UDim2.new(1,0,1,0)
f.BackgroundColor3 = Color3.fromRGB(10,10,20)
local title = Instance.new("TextLabel", f)
title.Size = UDim2.new(0.6,0,0.15,0)
title.Position = UDim2.new(0.2,0,0.35,0)
title.BackgroundTransparency = 1
title.Text = "HamzHub Is Loading..."
title.TextColor3 = Color3.fromRGB(200,200,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
wait(2.5)
sg:Destroy()

-- Load Kavo
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("HamzHub v4.5 - Fish It!", "DarkTheme")

-- Cari Kavo GUI
local KavoGui
for _, v in pairs(PlayerGui:GetChildren()) do
    if v:IsA("ScreenGui") and (
        v:FindFirstChild("Main") or
        (v:FindFirstChildWhichIsA("ScrollingFrame") and v.Name:lower():find("kavo"))
    ) then
        KavoGui = v
        break
    end
end

local minimized = false
local mainVisible = true

if KavoGui then
    -- Petir icon
    local icon = Instance.new("ImageLabel", KavoGui)
    icon.Size = UDim2.new(0,40,0,40)
    icon.Position = UDim2.new(0,10,0,10)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://3926305904"
    icon.ImageColor3 = Color3.fromRGB(255,215,0)

    -- Minimize / Restore Button (tetap muncul meski minimized)
    local minBtn = Instance.new("TextButton", KavoGui)
    minBtn.Size = UDim2.new(0,50,0,30)
    minBtn.Position = UDim2.new(0,60,0,10)
    minBtn.BackgroundColor3 = Color3.fromRGB(40,40,60)
    minBtn.Text = "HamzHub [-]"
    minBtn.TextColor3 = Color3.fromRGB(255,255,255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextScaled = true

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        minBtn.Text = minimized and "HamzHub [+]" or "HamzHub [-]"
        for _, child in pairs(KavoGui:GetDescendants()) do
            if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                local n = child.Name or ""
                local pn = child.Parent and child.Parent.Name or ""
                if n:find("Tab") or n:find("Section") or pn:find("Tab") then
                    child.Visible = not minimized
                end
            end
        end
    end)
end

-- Instant Catch Hook
env.InstantCatchEnabled = false
env.AutoFishEnabled = false

if hookmetamethod then
    local old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local m = getnamecallmethod()
        local a = {...}
        if m == "FireServer" and env.InstantCatchEnabled then
            local rn = tostring(self.Name):lower()
            local keys = {"reel", "catch", "fishcaught", "perfect", "rod", "cast", "throw", "reelin"}
            for _, k in keys do
                if rn:find(k) then
                    local na = {}
                    for i,v in a do na[i] = v end
                    if #na >= 1 then na[1] = true end
                    if #na >= 2 then na[2] = 100 end
                    local s, r = pcall(old, self, unpack(na))
                    if s then return r end
                    return old(self, unpack(a))
                end
            end
        end
        return old(self, ...)
    end))
end

local tab = Window:NewTab("Main")
local sec = tab:NewSection("Fitur Fix")

sec:NewToggle("Instant Catch", "Catch langsung", function(s)
    env.InstantCatchEnabled = s
end)

sec:NewToggle("Auto Fish", "Auto lempar + catch", function(s)
    env.AutoFishEnabled = s
    if s then
        spawn(function()
            while env.AutoFishEnabled do
                pcall(function()
                    local possibles = {"Cast", "CastRod", "ThrowRod", "ThrowBait", "StartFishing", "CastLine", "FishCast"}
                    local ev = RS:FindFirstChild("Events") or RS
                    for _, n in possibles do
                        local r = ev:FindFirstChild(n)
                        if r and r:IsA("RemoteEvent") then
                            r:FireServer()
                            break
                        end
                    end
                end)
                wait(1.8 + math.random(0.6, 1.8))
            end
        end)
    end
end)

sec:NewButton("Auto Sell (Fix)", "Jual semua ikan", function()
    pcall(function()
        local possibles = {"SellAll", "Sell", "SellAllFish", "SellInventory", "SellFish", "SellAllItems"}
        local ev = RS:FindFirstChild("Events") or RS
        for _, n in possibles do
            local r = ev:FindFirstChild(n)
            if r and r:IsA("RemoteEvent") then
                r:FireServer()
                print("HamzHub: Sell di-fire via " .. n)
                break
            end
        end
    end)
end)

-- Teleport tab tetep
local tptab = Window:NewTab("Teleport")
local tpsec = tptab:NewSection("Pulau")

local locs = {
    ["Ancient Jungle"] = CFrame.new(1482.88, 5.94, -339.56),
    ["Ancient Ruin"] = CFrame.new(6010.29, -585.93, 4641.64),
    ["Coral Reef"] = CFrame.new(-3074.15, 3.63, 2356.52),
    ["Crater Island"] = CFrame.new(1025.22, 14.13, 5088.76),
    ["Crystal Depth"] = CFrame.new(5721.09, -907.93, 15328.36),
    ["Esoteric Depth"] = CFrame.new(3298.39, -1302.86, 1369.86),
    ["Kohana Volcano"] = CFrame.new(-647.53, 40.99, 148.43),
    ["Secret Temple"] = CFrame.new(1488.65, -30.11, -694.77),
    ["Pirate Island"] = CFrame.new(3431, 4.06, 3431),
    ["Sisyphus Statue"] = CFrame.new(-3738.77, -135.08, -1009.51),
    ["Treasure Room"] = CFrame.new(-3594.6, -283.83, -1649.68),
    ["Tropical Grove"] = CFrame.new(-2073.76, 5.96, 3821.63),
}

for n, cf in pairs(locs) do
    tpsec:NewButton(n, "", function()
        local hrp = (Player.Character or Player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
        hrp.CFrame = cf + Vector3.new(0,6,0)
    end)
end

print("HamzHub v4.5 quick fix loaded! Minimize tetep, auto sell/fish di-scan lebih luas")
