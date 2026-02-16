-- HamzHub v4.4 | Fish It! Roblox | Fixed Precedence + Universal Copy + Tight Keywords

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Environment safe
local env = getgenv and getgenv() or _G

-- LOADING SCREEN (PlayerGui priority)
local function CreateLoadingScreen()
    local sg = Instance.new("ScreenGui")
    sg.Name = "HamzHubLoading"
    sg.Parent = PlayerGui
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true

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

    local sub = Instance.new("TextLabel", f)
    sub.Size = UDim2.new(0.5,0,0.08,0)
    sub.Position = UDim2.new(0.25,0,0.52,0)
    sub.BackgroundTransparency = 1
    sub.Text = "v4.4 • Precedence Fixed • Tight Hook"
    sub.TextColor3 = Color3.fromRGB(150,150,255)
    sub.TextScaled = true
    sub.Font = Enum.Font.Gotham

    local spinner = Instance.new("ImageLabel", f)
    spinner.Size = UDim2.new(0.1,0,0.1,0)
    spinner.Position = UDim2.new(0.45,0,0.6,0)
    spinner.BackgroundTransparency = 1
    spinner.Image = "rbxassetid://6034833295"
    spinner.ImageColor3 = Color3.fromRGB(180,180,255)

    TweenService:Create(spinner, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

    return sg
end

local loading = CreateLoadingScreen()
wait(3 + math.random(0.5, 1.8))
if loading and loading.Parent then loading:Destroy() end

-- MAIN GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("HamzHub - Fish It! v4.4", "DarkTheme")

-- Kavo GUI detection — precedence FIXED dengan kurung
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

if not KavoGui then
    for _, v in pairs(CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and (
            v:FindFirstChild("Main") or
            (v:FindFirstChildWhichIsA("ScrollingFrame") and v.Name:lower():find("kavo"))
        ) then
            KavoGui = v
            break
        end
    end
end

if KavoGui then
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0,50,0,50)
    icon.Position = UDim2.new(0,10,0,10)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://3926305904"
    icon.ImageColor3 = Color3.fromRGB(255,215,0)
    icon.Parent = KavoGui

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0,40,0,30)
    minBtn.Position = UDim2.new(1,-50,0,10)
    minBtn.BackgroundColor3 = Color3.fromRGB(30,30,50)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255,255,255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextScaled = true
    minBtn.Parent = KavoGui

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        minBtn.Text = minimized and "+" or "-"
        for _, child in pairs(KavoGui:GetDescendants()) do
            if (child:IsA("Frame") or child:IsA("ScrollingFrame")) then
                local name = child.Name or ""
                local p = child.Parent
                local parentName = p and p.Name or ""
                if name:find("Tab") or name:find("Section") or parentName:find("Tab") or parentName:find("Section") then
                    child.Visible = not minimized
                end
            end
        end
    end)
end

-- INSTANT CATCH - UNIVERSAL & TIGHT
env.InstantCatchEnabled = false
env.AutoFishEnabled = false

if hookmetamethod then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if method == "FireServer" and env.InstantCatchEnabled then
            local rn = tostring(self.Name):lower()
            -- Keyword super spesifik, hapus "success" biar aman
            local fishingKeywords = {"reel", "catch", "fishcaught", "perfectcatch", "rod", "castrod", "throwrod", "reelin"}
            for _, kw in ipairs(fishingKeywords) do
                if rn:find(kw) then
                    -- Manual copy — universal
                    local newArgs = {}
                    for i, v in ipairs(args) do
                        newArgs[i] = v
                    end

                    if #newArgs >= 1 then newArgs[1] = true end
                    if #newArgs >= 2 then newArgs[2] = 100 end

                    local success, result = pcall(oldNamecall, self, unpack(newArgs))
                    if success then
                        return result
                    else
                        -- Langsung original unmodified kalau gagal
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
        end

        return oldNamecall(self, ...)
    end))
else
    warn("HamzHub: hookmetamethod tidak tersedia — Instant Catch tidak aktif")
end

local TabMain = Window:NewTab("Instant & Auto")
local Sec = TabMain:NewSection("Instant Catch - Tight & Universal")

Sec:NewToggle("Enable Instant Catch", "Force success (keyword spesifik)", function(state)
    env.InstantCatchEnabled = state
    game.StarterGui:SetCore("SendNotification", {Title="HamzHub v4.4", Text="Instant Catch: " .. (state and "ON" or "OFF")})
end)

-- Auto Fish
local function GetHRP()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart", 8)
end

Sec:NewToggle("Auto Fish", "Auto lempar umpan", function(state)
    env.AutoFishEnabled = state
    if state then
        spawn(function()
            while env.AutoFishEnabled do
                pcall(function()
                    local eventsFolder = RS:FindFirstChild("Events")
                    local possibles = {"Cast", "CastRod", "ThrowRod", "Throw", "FishCast", "ReelIn"}
                    for _, name in ipairs(possibles) do
                        local rem = eventsFolder and eventsFolder:FindFirstChild(name) or RS:FindFirstChild(name)
                        if rem and rem:IsA("RemoteEvent") then
                            rem:FireServer()
                            break
                        end
                    end
                end)
                wait(1.6 + math.random(0.4, 1.4))
            end
        end)
    end
    game.StarterGui:SetCore("SendNotification", {Title="HamzHub v4.4", Text="Auto Fish: " .. (state and "ON" or "OFF")})
end)

Sec:NewButton("Sell All", "", function()
    pcall(function()
        local possibles = {"SellAll", "Sell", "SellInventory", "SellFish"}
        local events = RS:FindFirstChild("Events")
        for _, name in ipairs(possibles) do
            local rem = (events and events:FindFirstChild(name)) or RS:FindFirstChild(name)
            if rem and rem:IsA("RemoteEvent") then
                rem:FireServer()
                break
            end
        end
    end)
end)

-- Teleport (list lo)
local TabTP = Window:NewTab("Teleport Pulau")
local TPSection = TabTP:NewSection("Lokasi Pulau")

local locations = {
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

for name, cf in pairs(locations) do
    TPSection:NewButton(name, "", function()
        local hrp = GetHRP()
        if hrp then hrp.CFrame = cf + Vector3.new(0, 6, 0) end
    end)
end

print("HamzHub v4.4 loaded! Precedence fixed, universal args copy, tight keywords. ⚡🐟")
