-- Laysox Launcher
task.wait(2)

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")

local player = Players.LocalPlayer
repeat task.wait(0.5) until player.Character
local character = player.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

local function sc(f,...) pcall(f,...) end

local flySpeed = 100
local flyActive = false
local flyKeyName = "G"
local noclip = false
local wsActive = false
local wsValue = 50
local ijConnection = nil
local HumanModCons = {}

local function refresh()
    character = player.Character; if not character then return end
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end

player.CharacterAdded:Connect(function()
    task.wait(1); refresh()
    flyActive = false; noclip = false; wsActive = false
end)

local function startFly()
    if flyActive then return end
    flyActive = true
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    sc(function()
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
        if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
    end)
    local gyro = Instance.new("BodyGyro"); gyro.Name="FlyGyro"
    gyro.MaxTorque = Vector3.new(1,1,1)*math.huge; gyro.P=100000
    gyro.CFrame = hrp.CFrame; gyro.Parent = hrp
    local vel = Instance.new("BodyVelocity"); vel.Name="FlyVelocity"
    vel.MaxForce = Vector3.new(1,1,1)*math.huge; vel.P=10000
    vel.Velocity = Vector3.zero; vel.Parent = hrp
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not flyActive or not hrp or not hrp.Parent then
            if conn then conn:Disconnect() end
            sc(function() gyro:Destroy() end); sc(function() vel:Destroy() end)
            return
        end
        local mv = Vector3.zero; local cf = Camera.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W) then mv = mv + cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then mv = mv - cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then mv = mv - cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then mv = mv + cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then mv = mv - Vector3.new(0,1,0) end
        vel.Velocity = mv.Magnitude > 0 and mv.Unit * flySpeed or Vector3.zero
        gyro.CFrame = Camera.CFrame
    end)
end

local function stopFly()
    flyActive = false
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        sc(function()
            if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
            if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
        end)
    end
end

task.spawn(function()
    while task.wait(0.25) do
        if not noclip then continue end
        local c = player.Character; if not c then continue end
        for _, part in pairs(c:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local function startWS()
    local h = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    if not h then return end
    local function apply() h.WalkSpeed = wsValue end; apply()
    if HumanModCons.ws then HumanModCons.ws:Disconnect() end
    HumanModCons.ws = h:GetPropertyChangedSignal("WalkSpeed"):Connect(apply)
end
local function stopWS()
    if HumanModCons.ws then HumanModCons.ws:Disconnect() end
    local h = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    if h then h.WalkSpeed = 16 end
end

local function startIJ()
    if ijConnection then return end
    ijConnection = UIS.JumpRequest:Connect(function()
        local c = player.Character
        if c then
            local h = c:FindFirstChildWhichIsA("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end
local function stopIJ()
    if ijConnection then ijConnection:Disconnect(); ijConnection = nil end
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode.Name == flyKeyName then
        if flyActive then stopFly() else startFly() end
    end
end)

-- RAYFIELD
local Rayfield
sc(function()
    Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not Rayfield then
    task.wait(2)
    sc(function()
        Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    end)
end
if not Rayfield then return end

local Window = Rayfield:CreateWindow({
    Name = "Laysox Launcher",
    LoadingTitle = "Laysox Launcher",
    LoadingSubtitle = "Chargement...",
    Theme = "Default",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {Enabled = false},
    KeySystem = false,
})

-- TAB UNIVERSEL
local UniTab = Window:CreateTab("Universel", 4483362458)

UniTab:CreateSection("Fly")
UniTab:CreateSlider({
    Name = "Vitesse Fly", Range = {10,2000}, Increment = 10,
    Suffix = " studs/s", CurrentValue = 100, Flag = "UniFlySpeed",
    Callback = function(v) flySpeed = v end,
})
UniTab:CreateToggle({
    Name = "Activer Fly", CurrentValue = false, Flag = "UniFlyToggle",
    Callback = function(v)
        if v then startFly(); Rayfield:Notify({Title="Fly ON", Content=flySpeed.." studs/s", Duration=2})
        else stopFly(); Rayfield:Notify({Title="Fly OFF", Content="Retour au sol.", Duration=2}) end
    end,
})
UniTab:CreateDropdown({
    Name = "Touche Fly",
    Options = {"G","Q","E","R","T","F","H","J","K","L","Z","X","C","V","B","N","M","F1","F2","F3","F4","F5","F6","LeftShift","LeftAlt","Tab"},
    CurrentOption = {"G"}, Flag = "UniFlyKey", MultipleOptions = false,
    Callback = function(o)
        flyKeyName = o[1]
        Rayfield:Notify({Title="Touche Fly", Content="Fly -> "..o[1], Duration=2})
    end,
})
UniTab:CreateParagraph({
    Title = "Controles Fly",
    Content = "W/A/S/D -> Directions\nSpace -> Monter\nCtrl -> Descendre\nTouche configuree -> Toggle",
})

UniTab:CreateSection("Noclip")
UniTab:CreateToggle({
    Name = "Noclip", CurrentValue = false, Flag = "UniNoclip",
    Callback = function(v)
        noclip = v
        Rayfield:Notify({Title=v and "Noclip ON" or "Noclip OFF",
            Content=v and "Tu traverses les murs." or "Collisions restaurees.", Duration=2})
    end,
})

UniTab:CreateSection("Vitesse")
UniTab:CreateSlider({
    Name = "WalkSpeed", Range = {16,500}, Increment = 1,
    Suffix = " studs", CurrentValue = 50, Flag = "UniWalkSpeed",
    Callback = function(v) wsValue = v; if wsActive then startWS() end end,
})
UniTab:CreateToggle({
    Name = "Activer WalkSpeed", CurrentValue = false, Flag = "UniWSToggle",
    Callback = function(v)
        wsActive = v
        if v then startWS(); Rayfield:Notify({Title="Speed ON", Content=wsValue.." studs", Duration=2})
        else stopWS(); Rayfield:Notify({Title="Speed OFF", Content="Vitesse normale.", Duration=2}) end
    end,
})

UniTab:CreateSection("Saut")
UniTab:CreateToggle({
    Name = "Infinite Jump", CurrentValue = false, Flag = "UniIJ",
    Callback = function(v)
        if v then startIJ(); Rayfield:Notify({Title="Infinite Jump ON", Content="Saute sans limite!", Duration=2})
        else stopIJ(); Rayfield:Notify({Title="Infinite Jump OFF", Content="Saut normal.", Duration=2}) end
    end,
})

UniTab:CreateSection("Teleport rapide")
local qx, qy, qz = 0, 0, 0
UniTab:CreateInput({Name="X", PlaceholderText="100", RemoveTextAfterFocusLost=false, Flag="UniX",
    Callback=function(v) qx=tonumber(v) or qx end})
UniTab:CreateInput({Name="Y", PlaceholderText="50", RemoveTextAfterFocusLost=false, Flag="UniY",
    Callback=function(v) qy=tonumber(v) or qy end})
UniTab:CreateInput({Name="Z", PlaceholderText="200", RemoveTextAfterFocusLost=false, Flag="UniZ",
    Callback=function(v) qz=tonumber(v) or qz end})
UniTab:CreateButton({Name="Teleporter", Callback=function()
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(qx, qy, qz)
        Rayfield:Notify({Title="TP!", Content=("X:%d Y:%d Z:%d"):format(qx,qy,qz), Duration=2})
    end
end})

-- TAB JEUX
local GamesTab = Window:CreateTab("Jeux", 4483362458)

-- Place ID récupéré depuis la capture d'écran
local currentPlaceId = game.PlaceId

local games = {
    {
        name = "Carpet Cleaning Simulator",
        placeId = 124374448373637,
        script = "https://raw.githubusercontent.com/laysox/laysoxUI/main/CarpetClean.lua",
        description = "Auto job, XP farm, vitesse, tp...",
    },
}

GamesTab:CreateParagraph({
    Title = "Laysox Launcher - Jeux",
    Content = "Clique sur un jeu pour charger son script.\nPlace ID actuel : "..tostring(currentPlaceId),
})

GamesTab:CreateSection("Scripts disponibles")

for _, gameInfo in pairs(games) do
    local isCurrentGame = currentPlaceId == gameInfo.placeId
    local status = isCurrentGame and " [OK - Tu es ici]" or " [Pas ce jeu]"

    GamesTab:CreateButton({
        Name = gameInfo.name..status,
        Callback = function()
            if not isCurrentGame then
                Rayfield:Notify({
                    Title = "Mauvais jeu!",
                    Content = "Place ID du jeu : "..tostring(gameInfo.placeId).."\nTon Place ID actuel : "..tostring(currentPlaceId),
                    Duration = 6,
                })
                return
            end
            Rayfield:Notify({
                Title = "Chargement...",
                Content = "Chargement de "..gameInfo.name.."...",
                Duration = 3,
            })
            task.wait(1)
            Rayfield:Destroy()
            task.wait(0.5)
            sc(function()
                loadstring(game:HttpGet(gameInfo.script))()
            end)
        end,
    })

    GamesTab:CreateParagraph({
        Title = gameInfo.name,
        Content = gameInfo.description.."\nPlace ID attendu : "..tostring(gameInfo.placeId),
    })
end

GamesTab:CreateSection("Debug - Jeu actuel")
GamesTab:CreateParagraph({
    Title = "Ton Place ID",
    Content = tostring(currentPlaceId).."\n\nSi le bouton dit [Pas ce jeu] meme si tu es dans le bon jeu, copie ce Place ID et dis le moi pour corriger.",
})

-- TAB INFOS
local InfoTab = Window:CreateTab("Infos", 4483362458)
InfoTab:CreateParagraph({
    Title = "Comment utiliser",
    Content = "1. Onglet Universel : fonctionne partout\n2. Onglet Jeux : charge un script pour un jeu\n3. Tu dois etre dans le bon jeu\n4. Si [Pas ce jeu] : note ton Place ID dans Debug",
})
InfoTab:CreateParagraph({
    Title = "Scripts disponibles",
    Content = "Carpet Cleaning Simulator - Auto job, XP farm...",
})
InfoTab:CreateButton({
    Name = "Rejoindre le Discord LSX",
    Callback = function()
        sc(function() setclipboard("https://discord.gg/94CnwG3ySJ") end)
        Rayfield:Notify({Title="Discord", Content="Lien copie!", Duration=3})
    end,
})
