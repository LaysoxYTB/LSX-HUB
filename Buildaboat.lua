-- Build A Boat For Treasure | Laysox
-- Interface: Linoria Rewrite
-- Base: alsk._. | Fixes: mort coffre + délai relance

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local plr = Players.LocalPlayer

local cfg = {
    farmActive    = false,
    farmCancelled = false,
    tpDelay       = 0.8,
    runDelay      = 0.5,
    antiAfk       = false,
}

local ouro = 0

-- ANTI AFK
local function startAntiAfk()
    task.spawn(function()
        while cfg.antiAfk do
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new())
            end)
            task.wait(55)
        end
    end)
end

-- FIX MORT AU COFFRE : invincible temporaire
local function setInvincible(state)
    pcall(function()
        local c = plr.Character; if not c then return end
        local h = c:FindFirstChildWhichIsA("Humanoid"); if not h then return end
        if state then
            h.MaxHealth = math.huge
            h.Health    = math.huge
        else
            h.MaxHealth = 100
            h.Health    = 100
        end
    end)
end

-- CORE FARM
local function doRun()
    local char = plr.Character
    if not char then
        plr.CharacterAdded:Wait()
        char = plr.Character
        task.wait(1)
    end

    local r = char:FindFirstChild("HumanoidRootPart")
    if not r then return end

    local stages = workspace:FindFirstChild("BoatStages")
        and workspace.BoatStages:FindFirstChild("NormalStages")
    if not stages then return end

    -- Parcours CaveStage 1 à 10
    for i = 1, 10 do
        if not cfg.farmActive or cfg.farmCancelled then return end

        char = plr.Character; if not char then return end
        r = char:FindFirstChild("HumanoidRootPart"); if not r then return end

        local stage = stages:FindFirstChild("CaveStage" .. i)
        if stage then
            local dp = stage:FindFirstChild("DarknessPart")
            if dp then
                local floor = Instance.new("Part")
                floor.Anchored    = true
                floor.CanCollide  = true
                floor.Size        = Vector3.new(10, 1, 10)
                floor.Transparency = 1
                floor.Position    = dp.Position - Vector3.new(0, 2.5, 0)
                floor.Parent      = workspace

                r.CFrame = dp.CFrame + Vector3.new(0, 1, 0)
                task.wait(cfg.tpDelay)
                floor:Destroy()
            end
        end
    end

    if not cfg.farmActive or cfg.farmCancelled then return end

    -- TP coffre final avec protection mort
    local theEnd = stages:FindFirstChild("TheEnd")
    if theEnd then
        local chest = theEnd:FindFirstChild("GoldenChest")
        if chest then
            local trigger = chest:FindFirstChild("Trigger")
            if trigger then
                char = plr.Character; if not char then return end
                r = char:FindFirstChild("HumanoidRootPart"); if not r then return end

                -- Invincible avant coffre
                setInvincible(true)

                local floor2 = Instance.new("Part")
                floor2.Anchored    = true
                floor2.CanCollide  = true
                floor2.Size        = Vector3.new(20, 1, 20)
                floor2.Transparency = 1
                floor2.Position    = trigger.Position - Vector3.new(0, 3, 0)
                floor2.Parent      = workspace

                r.CFrame = trigger.CFrame + Vector3.new(0, 1, 0)

                -- Attente coffre max 4s
                local waited = 0
                local got    = false
                while waited < 4 and cfg.farmActive do
                    task.wait(0.25)
                    waited += 0.25
                    if Lighting.ClockTime ~= 14 then
                        got = true
                        break
                    end
                end

                floor2:Destroy()
                setInvincible(false)

                if got then ouro += 100 end
            end
        end
    end

    if not cfg.farmActive or cfg.farmCancelled then return end

    -- Attente respawn rapide (timeout 10s)
    local spawned = false
    local conn
    conn = plr.CharacterAdded:Connect(function()
        spawned = true
        conn:Disconnect()
    end)
    local t = 0
    while not spawned and cfg.farmActive and t < 10 do
        task.wait(0.3); t += 0.3
    end
    if spawned then task.wait(0.8) end
    task.wait(cfg.runDelay)
end

local function farmLoop()
    while cfg.farmActive and not cfg.farmCancelled do
        local ok, _ = pcall(doRun)
        if not ok then task.wait(2) end
    end
end

-- ========================
-- LINORIA REWRITE
-- ========================
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library      = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager  = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title    = 'Build A Boat | Laysox',
    Center   = true,
    AutoShow = true,
})

local Tabs = {
    Farm     = Window:AddTab('Farm'),
    Settings = Window:AddTab('UI Settings'),
}

-- FARM TAB
local FarmBox = Tabs.Farm:AddLeftGroupbox('Auto Farm')

FarmBox:AddToggle('FarmToggle', {
    Text     = 'Auto Farm',
    Default  = false,
    Tooltip  = 'Farm gold automatique - coffre final',
    Callback = function(v)
        cfg.farmActive    = v
        cfg.farmCancelled = not v
        if v then
            task.spawn(farmLoop)
            Library:Notify('Auto Farm ON', 2)
        else
            Library:Notify('Auto Farm OFF', 2)
        end
    end
})

FarmBox:AddSlider('TpDelay', {
    Text     = 'Delai TP entre stages (sec)',
    Default  = 0.8,
    Min      = 0.1,
    Max      = 3,
    Rounding = 1,
    Callback = function(v) cfg.tpDelay = v end
})

FarmBox:AddSlider('RunDelay', {
    Text     = 'Delai entre runs (sec)',
    Default  = 0.5,
    Min      = 0,
    Max      = 5,
    Rounding = 1,
    Callback = function(v) cfg.runDelay = v end
})

FarmBox:AddToggle('AntiAfk', {
    Text     = 'Anti AFK',
    Default  = false,
    Callback = function(v)
        cfg.antiAfk = v
        if v then startAntiAfk() end
        Library:Notify(v and 'Anti AFK ON' or 'Anti AFK OFF', 2)
    end
})

-- Stats gold live
local InfoBox   = Tabs.Farm:AddRightGroupbox('Stats')
local goldLabel = InfoBox:AddLabel('Gold ramasse : 0')

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            goldLabel:SetText('Gold ramasse : ' .. tostring(ouro))
        end)
    end
end)

InfoBox:AddLabel('Fixes :')
InfoBox:AddLabel('→ Invincible au coffre final')
InfoBox:AddLabel('→ Floor anti-chute a chaque stage')
InfoBox:AddLabel('→ Relance ultra rapide')

-- SETTINGS TAB
local MenuBox = Tabs.Settings:AddLeftGroupbox('Menu')
MenuBox:AddButton({
    Text = 'Discord LSX',
    Func = function()
        pcall(function() setclipboard('https://discord.gg/94CnwG3ySJ') end)
        Library:Notify('Lien Discord copie!', 3)
    end
})
MenuBox:AddButton({
    Text = 'Fermer le script',
    Func = function()
        cfg.farmActive    = false
        cfg.farmCancelled = true
        Library:Unload()
    end
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder('LaysoxScripts/BuildABoat')
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Library:Notify('Build A Boat charge! Active Auto Farm.', 4)
