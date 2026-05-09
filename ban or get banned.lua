-- ============================================================
--  Laysox Hub - Infinite Money | Ban or Get Banned
--  Discord : https://discord.gg/tFkAe2RVKB
-- ============================================================

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui    = game:GetService("CoreGui")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local SPIN_SPEED = 25
local isActive  = false
local loopConn  = nil
local spinAngle = 0
local hue       = 0

-- Old GUI remover
local oldGui = CoreGui:FindFirstChild("LaysoxInfMoneyGUI")
if oldGui then oldGui:Destroy() end

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "LaysoxInfMoneyGUI"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.Parent         = CoreGui

local frame = Instance.new("Frame")
frame.Size                   = UDim2.new(0, 230, 0, 115)
frame.Position               = UDim2.new(0.5, -115, 0.78, 0)
frame.BackgroundColor3       = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel        = 0
frame.Parent                 = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local border = Instance.new("UIStroke", frame)
border.Color        = Color3.fromRGB(0, 200, 100)
border.Thickness    = 1.5
border.Transparency = 0.4

local title = Instance.new("TextLabel")
title.Size                   = UDim2.new(1, 0, 0.36, 0)
title.BackgroundTransparency = 1
title.Text                   = "Laysox Hub - Infinite Money"
title.TextColor3             = Color3.fromRGB(0, 255, 100)
title.TextScaled             = true
title.Font                   = Enum.Font.GothamBold
title.Parent                 = frame

local discordLbl = Instance.new("TextLabel")
discordLbl.Size                   = UDim2.new(1, 0, 0.22, 0)
discordLbl.Position               = UDim2.new(0, 0, 0.34, 0)
discordLbl.BackgroundTransparency = 1
discordLbl.Text                   = "discord.gg/tFkAe2RVKB"
discordLbl.TextColor3             = Color3.fromRGB(150, 150, 150)
discordLbl.TextScaled             = true
discordLbl.Font                   = Enum.Font.Gotham
discordLbl.Parent                 = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size             = UDim2.new(0.62, 0, 0.30, 0)
toggleBtn.Position         = UDim2.new(0.19, 0, 0.64, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
toggleBtn.Text             = "OFF"
toggleBtn.TextScaled       = true
toggleBtn.Font             = Enum.Font.GothamBold
toggleBtn.BorderSizePixel  = 0
toggleBtn.Parent           = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- Drag
local dragging, dragStart, panelStart, dragInput = false, nil, nil, nil
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging   = true
        dragStart  = input.Position
        panelStart = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput and dragStart then
        local delta = dragInput.Position - dragStart
        frame.Position = UDim2.new(
            panelStart.X.Scale, panelStart.X.Offset + delta.X,
            panelStart.Y.Scale, panelStart.Y.Offset + delta.Y
        )
    end
end)

-- Logic
local function getTorso()
    character = player.Character
    if not character then return nil end
    return character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end

local function getMoneyParts()
    local results = {}
    local decoration = workspace:FindFirstChild("Decoration")
    if not decoration then return results end
    for _, child in ipairs(decoration:GetChildren()) do
        if child:IsA("BasePart") then
            local hasScript = child:FindFirstChildOfClass("Script")
            local hasTouch  = child:FindFirstChildOfClass("TouchTransmitter") or child:FindFirstChild("TouchInterest")
            if hasScript and hasTouch then table.insert(results, child) end
        end
    end
    return results
end

local function preparePart(part)
    if not part or not part:IsA("BasePart") then return end
    part.Anchored   = true
    part.CanCollide = false
end

local function startLoop()
    if loopConn then loopConn:Disconnect() end
    local moneyParts = getMoneyParts()
    if #moneyParts == 0 then warn("[Laysox] Aucune money part trouvee.") return end
    for _, p in ipairs(moneyParts) do preparePart(p) end
    loopConn = RunService.Heartbeat:Connect(function(dt)
        local torso = getTorso()
        if not torso then return end
        local anyMissing = false
        for _, p in ipairs(moneyParts) do
            if not p or not p.Parent then anyMissing = true break end
        end
        if anyMissing then
            moneyParts = getMoneyParts()
            for _, p in ipairs(moneyParts) do preparePart(p) end
            if #moneyParts == 0 then return end
        end
        hue = (hue + dt * 0.08) % 1
        spinAngle = (spinAngle + dt * SPIN_SPEED) % (2 * math.pi)
        for _, p in ipairs(moneyParts) do
            pcall(function() p.Color = Color3.fromHSV(hue, 1, 1) end)
            p.CFrame = CFrame.new(torso.Position)
                * CFrame.Angles(spinAngle, spinAngle * 1.3, spinAngle * 0.7)
        end
    end)
end

local function stopLoop()
    if loopConn then loopConn:Disconnect(); loopConn = nil end
end

local function turnOn()
    isActive = true
    toggleBtn.Text             = "ON"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    border.Transparency        = 0
    startLoop()
end

local function turnOff()
    isActive = false
    toggleBtn.Text             = "OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    border.Transparency        = 0.4
    stopLoop()
end

toggleBtn.Activated:Connect(function()
    if isActive then turnOff() else turnOn() end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    newChar:WaitForChild("HumanoidRootPart")
    if isActive then task.wait(0.5); startLoop() end
end)

print("[Laysox] Infinite Money charge - discord.gg/tFkAe2RVKB")
