-- Laysox Launcher | Linoria UI
local repo         = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library      = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager  = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UIS           = game:GetService("UserInputService")
local Lighting      = game:GetService("Lighting")
local TeleportSvc   = game:GetService("TeleportService")
local StarterGui    = game:GetService("StarterGui")
local VirtualUser   = game:GetService("VirtualUser")

local player = Players.LocalPlayer
repeat task.wait(0.5) until player.Character
local character        = player.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local Camera           = workspace.CurrentCamera

local function sc(f,...) return pcall(f,...) end

-- ============================================================
-- LANCEMENT SCRIPT
-- ============================================================
local function launchScript(name, url)
    Library:Notify('Chargement '..name..'...', 2)
    task.wait(0.3)
    Library.Unloaded = true
    task.spawn(function()
        task.wait(0.1)
        loadstring(game:HttpGet(url))()
    end)
end

-- ============================================================
-- VARIABLES
-- ============================================================
local flySpeed    = 100
local flyActive   = false
local flyKeyName  = "G"
local noclip      = false
local wsActive    = false
local wsValue     = 50
local ijConn      = nil
local HMC         = {}
local spawnCFrame = nil

-- TP Continu
local tpContinu       = false
local tpContinuTarget = nil
local tpContinuConn   = nil

-- ESP
local espHighlights = {}

-- Anti AFK
local afkConn = nil

-- Click TP
local clickTpConn = nil

-- Freecam
local freecamActive = false
local freecamPart   = nil
local freecamConn   = nil
local freecamSpeed  = 1

-- Anti Void
local antiVoidConn = nil

-- Water Walk
local waterWalkConn = nil

-- Spin Bot
local spinConn = nil

-- Fake Lag
local fakeLagConn = nil

-- Auto Respawn
local autoRespawnConn = nil

-- Spectate
local spectateConn = nil

-- Shift Lock
local shiftLockEnabled = false

local function refresh()
    character        = player.Character; if not character then return end
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(function()
    task.wait(1); refresh()
    flyActive=false; noclip=false; wsActive=false
end)

-- ============================================================
-- FLY
-- ============================================================
local function startFly()
    if flyActive then return end; flyActive=true
    local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then flyActive=false; return end
    sc(function()
        if hrp:FindFirstChild("FG") then hrp.FG:Destroy() end
        if hrp:FindFirstChild("FV") then hrp.FV:Destroy() end
    end)
    local gyro=Instance.new("BodyGyro"); gyro.Name="FG"
    gyro.MaxTorque=Vector3.new(1,1,1)*math.huge; gyro.P=100000
    gyro.CFrame=hrp.CFrame; gyro.Parent=hrp
    local vel=Instance.new("BodyVelocity"); vel.Name="FV"
    vel.MaxForce=Vector3.new(1,1,1)*math.huge; vel.P=10000
    vel.Velocity=Vector3.zero; vel.Parent=hrp
    local conn
    conn=RunService.RenderStepped:Connect(function()
        if not flyActive or not hrp or not hrp.Parent then
            if conn then conn:Disconnect() end
            sc(function() gyro:Destroy() end); sc(function() vel:Destroy() end)
            return
        end
        local mv=Vector3.zero; local cf=Camera.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W)           then mv=mv+cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S)           then mv=mv-cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A)           then mv=mv-cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D)           then mv=mv+cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)       then mv=mv+Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then mv=mv-Vector3.new(0,1,0) end
        vel.Velocity=mv.Magnitude>0 and mv.Unit*flySpeed or Vector3.zero
        gyro.CFrame=Camera.CFrame
    end)
end

local function stopFly()
    flyActive=false
    local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        sc(function()
            if hrp:FindFirstChild("FG") then hrp.FG:Destroy() end
            if hrp:FindFirstChild("FV") then hrp.FV:Destroy() end
        end)
    end
end

-- ============================================================
-- NOCLIP
-- ============================================================
task.spawn(function()
    while task.wait(0.25) do
        if not noclip then continue end
        local c=player.Character; if not c then continue end
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)

-- ============================================================
-- WALKSPEED
-- ============================================================
local function startWS()
    local h=player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    if not h then return end
    local function apply() h.WalkSpeed=wsValue end; apply()
    if HMC.ws then HMC.ws:Disconnect() end
    HMC.ws=h:GetPropertyChangedSignal("WalkSpeed"):Connect(apply)
end
local function stopWS()
    if HMC.ws then HMC.ws:Disconnect() end
    local h=player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    if h then h.WalkSpeed=16 end
end

-- ============================================================
-- INFINITE JUMP
-- ============================================================
local function startIJ()
    if ijConn then return end
    ijConn=UIS.JumpRequest:Connect(function()
        local c=player.Character
        if c then
            local h=c:FindFirstChildWhichIsA("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end
local function stopIJ()
    if ijConn then ijConn:Disconnect(); ijConn=nil end
end

-- ============================================================
-- TP CONTINU
-- ============================================================
local function startTpContinu()
    if tpContinuConn then return end
    tpContinuConn = RunService.Heartbeat:Connect(function()
        if not tpContinu or not tpContinuTarget then return end
        local target    = Players:FindFirstChild(tpContinuTarget)
        local targetHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local myHRP     = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and myHRP then
            myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 0)
        end
    end)
end

local function stopTpContinu()
    tpContinu = false
    if tpContinuConn then tpContinuConn:Disconnect(); tpContinuConn = nil end
end

-- ============================================================
-- ESP
-- ============================================================
local function updateESP(enabled)
    if enabled then
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                if not espHighlights[p.Name] then
                    local h = Instance.new("Highlight")
                    h.Adornee         = p.Character
                    h.FillColor       = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor    = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency    = 0.5
                    h.OutlineTransparency = 0
                    h.DepthMode       = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent          = p.Character
                    espHighlights[p.Name] = h
                end
            end
        end
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(c)
                if not espHighlights[p.Name] then
                    local h = Instance.new("Highlight")
                    h.Adornee         = c
                    h.FillColor       = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor    = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency    = 0.5
                    h.OutlineTransparency = 0
                    h.DepthMode       = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent          = c
                    espHighlights[p.Name] = h
                end
            end)
        end)
    else
        for name, h in pairs(espHighlights) do
            sc(function() h:Destroy() end)
            espHighlights[name] = nil
        end
    end
end

-- ============================================================
-- FULLBRIGHT
-- ============================================================
local originalBrightness = Lighting.Brightness
local originalAmbient    = Lighting.Ambient
local originalOutdoor    = Lighting.OutdoorAmbient

local function setFullBright(enabled)
    if enabled then
        Lighting.Brightness     = 10
        Lighting.Ambient        = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
        for _,v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end
    else
        Lighting.Brightness     = originalBrightness
        Lighting.Ambient        = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoor
        for _,v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = true
            end
        end
    end
end

-- ============================================================
-- ANTI AFK
-- ============================================================
local function setAntiAFK(enabled)
    if enabled then
        if afkConn then return end
        afkConn = player.Idled:Connect(function()
            sc(function() VirtualUser:CaptureController() end)
            sc(function() VirtualUser:ClickButton2(Vector2.new()) end)
        end)
    else
        if afkConn then afkConn:Disconnect(); afkConn=nil end
    end
end

-- ============================================================
-- CLICK TP
-- ============================================================
local function setClickTP(enabled)
    if enabled then
        if clickTpConn then return end
        clickTpConn = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local unitRay = Camera:ScreenPointToRay(input.Position.X, input.Position.Y)
                local ray = Ray.new(unitRay.Origin, unitRay.Direction * 1000)
                local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
                if hit then
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0)) end
                end
            end
        end)
    else
        if clickTpConn then clickTpConn:Disconnect(); clickTpConn=nil end
    end
end

-- ============================================================
-- FREECAM
-- ============================================================
local function startFreecam()
    if freecamActive then return end
    freecamActive = true
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Anchored = true end
    local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.WalkSpeed = 0 end

    freecamPart = Instance.new("Part")
    freecamPart.Anchored    = true
    freecamPart.CanCollide  = false
    freecamPart.Transparency = 1
    freecamPart.Size        = Vector3.new(1,1,1)
    freecamPart.CFrame      = Camera.CFrame
    freecamPart.Parent      = workspace

    Camera.CameraType    = Enum.CameraType.Scriptable
    Camera.CameraSubject = freecamPart

    local spd = 1
    freecamConn = RunService.RenderStepped:Connect(function(dt)
        if not freecamActive then return end
        local mv = Vector3.zero
        local cf = Camera.CFrame
        spd = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 3 or 1
        if UIS:IsKeyDown(Enum.KeyCode.W)           then mv = mv + cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S)           then mv = mv - cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A)           then mv = mv - cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D)           then mv = mv + cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)       then mv = mv + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then mv = mv - Vector3.new(0,1,0) end
        if mv.Magnitude > 0 then
            freecamPart.CFrame = freecamPart.CFrame + mv.Unit * spd * dt * 60
        end
        Camera.CFrame = freecamPart.CFrame
    end)
end

local function stopFreecam()
    freecamActive = false
    if freecamConn then freecamConn:Disconnect(); freecamConn=nil end
    if freecamPart then freecamPart:Destroy(); freecamPart=nil end
    Camera.CameraType    = Enum.CameraType.Custom
    Camera.CameraSubject = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Anchored = false end
    local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.WalkSpeed = wsActive and wsValue or 16 end
end

-- ============================================================
-- DISABLE FOG
-- ============================================================
local function setDisableFog(enabled)
    Lighting.FogEnd = enabled and 1e6 or 1000
end

-- ============================================================
-- ANTI VOID
-- ============================================================
local function setAntiVoid(enabled)
    if enabled then
        if antiVoidConn then return end
        antiVoidConn = RunService.Heartbeat:Connect(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -100 then
                hrp.CFrame = CFrame.new(hrp.Position.X, 10, hrp.Position.Z)
            end
        end)
    else
        if antiVoidConn then antiVoidConn:Disconnect(); antiVoidConn=nil end
    end
end

-- ============================================================
-- WATER WALK
-- ============================================================
local function setWaterWalk(enabled)
    if enabled then
        if waterWalkConn then return end
        waterWalkConn = RunService.Stepped:Connect(function()
            local c = player.Character; if not c then return end
            for _,p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end)
        sc(function()
            for _,v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Material == Enum.Material.Water then
                    v.CanCollide = true
                end
            end
        end)
    else
        if waterWalkConn then waterWalkConn:Disconnect(); waterWalkConn=nil end
        sc(function()
            for _,v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Material == Enum.Material.Water then
                    v.CanCollide = false
                end
            end
        end)
    end
end

-- ============================================================
-- SPIN BOT
-- ============================================================
local function setSpinBot(enabled)
    if enabled then
        if spinConn then return end
        spinConn = RunService.RenderStepped:Connect(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(15), 0)
            end
        end)
    else
        if spinConn then spinConn:Disconnect(); spinConn=nil end
    end
end

-- ============================================================
-- FAKE LAG
-- ============================================================
local function setFakeLag(enabled)
    if enabled then
        if fakeLagConn then return end
        fakeLagConn = RunService.Heartbeat:Connect(function()
            local start = tick()
            while tick() - start < 0.15 do end
        end)
    else
        if fakeLagConn then fakeLagConn:Disconnect(); fakeLagConn=nil end
    end
end

-- ============================================================
-- AUTO RESPAWN
-- ============================================================
local function setAutoRespawn(enabled)
    if enabled then
        if autoRespawnConn then return end
        autoRespawnConn = player.CharacterAdded:Connect(function(c)
            local hum = c:WaitForChild("Humanoid")
            hum.Died:Connect(function()
                task.wait(1)
                sc(function() player:LoadCharacter() end)
            end)
        end)
        -- Applique aussi au perso actuel
        local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.Died:Connect(function()
                task.wait(1)
                sc(function() player:LoadCharacter() end)
            end)
        end
    else
        if autoRespawnConn then autoRespawnConn:Disconnect(); autoRespawnConn=nil end
    end
end

-- ============================================================
-- PLATFORM STAND
-- ============================================================
local function setPlatformStand(enabled)
    local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.PlatformStand = enabled end
end

-- ============================================================
-- SHIFT LOCK
-- ============================================================
local shiftLockGui = nil
local function setShiftLock(enabled)
    shiftLockEnabled = enabled
    sc(function()
        local PlayerModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
        local controls     = PlayerModule:GetControls()
        if enabled then
            Camera.CameraType = Enum.CameraType.Custom
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
        end
    end)
    -- Methode directe : verrouillage de la camera sur le perso
    if enabled then
        RunService:BindToRenderStep("ShiftLock", 200, function()
            if not shiftLockEnabled then
                RunService:UnbindFromRenderStep("ShiftLock")
                return
            end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z))
            end
        end)
    else
        RunService:UnbindFromRenderStep("ShiftLock")
    end
end

-- ============================================================
-- FPS BOOST
-- ============================================================
local function setFpsBoost(enabled)
    if enabled then
        Lighting.GlobalShadows = false
        sc(function()
            for _,v in ipairs(Lighting:GetDescendants()) do
                if v:IsA("PostEffect") then v.Enabled = false end
            end
            for _,v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = false
                end
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                end
            end
        end)
    else
        Lighting.GlobalShadows = true
        sc(function()
            for _,v in ipairs(Lighting:GetDescendants()) do
                if v:IsA("PostEffect") then v.Enabled = true end
            end
            for _,v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = true
                end
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 0
                end
            end
        end)
    end
end

-- ============================================================
-- SPECTATE
-- ============================================================
local spectateTarget = nil
local function startSpectate(targetName)
    if spectateConn then spectateConn:Disconnect(); spectateConn=nil end
    local target = Players:FindFirstChild(targetName)
    if not target then Library:Notify('Joueur introuvable !', 2); return end
    spectateTarget = targetName
    local hum = target.Character and target.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then
        Camera.CameraType    = Enum.CameraType.Custom
        Camera.CameraSubject = hum
        Library:Notify('Spectate : '..targetName, 2)
    end
    spectateConn = Players.PlayerRemoving:Connect(function(p)
        if p.Name == spectateTarget then
            Camera.CameraType    = Enum.CameraType.Custom
            Camera.CameraSubject = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
            spectateTarget = nil
        end
    end)
end

local function stopSpectate()
    if spectateConn then spectateConn:Disconnect(); spectateConn=nil end
    Camera.CameraType    = Enum.CameraType.Custom
    Camera.CameraSubject = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    spectateTarget = nil
    Library:Notify('Spectate desactive', 2)
end

-- ============================================================
-- KEYBIND FLY
-- ============================================================
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.UserInputType~=Enum.UserInputType.Keyboard then return end
    if input.KeyCode.Name==flyKeyName then
        if flyActive then stopFly() else startFly() end
    end
end)

-- ============================================================
-- WINDOW
-- ============================================================
local Window=Library:CreateWindow({
    Title       = 'Laysox Launcher',
    Center      = true,
    AutoShow    = true,
    TabPadding  = 8,
    MenuFadeTime= 0.2,
})

local Tabs={
    Universel = Window:AddTab('Universel'),
    Extras    = Window:AddTab('Extras'),
    Jeux      = Window:AddTab('Jeux'),
    Settings  = Window:AddTab('Settings'),
}

-- ============================================================
-- TAB UNIVERSEL – FLY & MOUVEMENT
-- ============================================================
local ULeft  = Tabs.Universel:AddLeftGroupbox('Fly')
local URight = Tabs.Universel:AddRightGroupbox('Mouvement')

ULeft:AddSlider('UniFlySPD',{Text='Vitesse Fly',Default=100,Min=10,Max=2000,Rounding=0,
    Callback=function(v) flySpeed=v end})
ULeft:AddToggle('UniFlyTog',{Text='Activer Fly',Default=false,
    Callback=function(v) if v then startFly() else stopFly() end end})
ULeft:AddDropdown('UniFlyKey',{
    Text='Touche Fly',
    Values={'G','Q','E','R','T','F','H','J','K','L','Z','X','C','V','B','N','M',
            'F1','F2','F3','F4','F5','F6','LeftShift','LeftAlt','Tab'},
    Default=1,
    Callback=function(v) flyKeyName=v end,
})
ULeft:AddLabel('W/A/S/D | Space monter | Ctrl descendre')

URight:AddToggle('UniNoclip',{Text='Noclip',Default=false,Callback=function(v) noclip=v end})
URight:AddDivider()
URight:AddSlider('UniWSVal',{Text='WalkSpeed',Default=50,Min=16,Max=500,Rounding=0,
    Callback=function(v) wsValue=v; if wsActive then startWS() end end})
URight:AddToggle('UniWSTog',{Text='Activer WalkSpeed',Default=false,
    Callback=function(v) wsActive=v; if v then startWS() else stopWS() end end})
URight:AddDivider()
URight:AddToggle('UniIJ',{Text='Infinite Jump',Default=false,
    Callback=function(v) if v then startIJ() else stopIJ() end end})

-- ============================================================
-- TAB UNIVERSEL – SPAWN POINT
-- ============================================================
local UniSPBox = Tabs.Universel:AddLeftGroupbox('Spawn Point')

UniSPBox:AddButton({Text='Definir Spawn Point ici', Func=function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        spawnCFrame = hrp.CFrame
        local pos   = hrp.CFrame.Position
        Library:Notify(('Spawn : %.0f / %.0f / %.0f'):format(pos.X,pos.Y,pos.Z), 3)
    else
        Library:Notify('Personnage introuvable !', 2)
    end
end})
UniSPBox:AddButton({Text='TP au Spawn Point', Func=function()
    if not spawnCFrame then Library:Notify('Aucun Spawn Point !', 2); return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = spawnCFrame; Library:Notify('TP Spawn Point !', 2)
    else Library:Notify('Personnage introuvable !', 2) end
end})

-- ============================================================
-- TAB UNIVERSEL – TP JOUEUR
-- ============================================================
local UniTPRight = Tabs.Universel:AddRightGroupbox('TP Joueur')

local function getPlayerNames()
    local names = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= player then table.insert(names, p.Name) end
    end
    if #names == 0 then names = {'(aucun joueur)'} end
    return names
end

local selectedPlayerName = nil
local tpPlayerDropdown
local tpContinuToggle

tpPlayerDropdown = UniTPRight:AddDropdown('UniTPPlayerDrop', {
    Text     = 'Choisir un joueur',
    Values   = getPlayerNames(),
    Default  = 1,
    Callback = function(v)
        selectedPlayerName = (v ~= '(aucun joueur)') and v or nil
        if tpContinu then tpContinuTarget = selectedPlayerName end
    end,
})
UniTPRight:AddButton({Text='Actualiser la liste', Func=function()
    local names = getPlayerNames()
    tpPlayerDropdown:SetValues(names)
    tpPlayerDropdown:SetValue(names[1])
    selectedPlayerName = (names[1] ~= '(aucun joueur)') and names[1] or nil
    Library:Notify('Liste actualisee', 2)
end})
UniTPRight:AddButton({Text='TP une fois', Func=function()
    if not selectedPlayerName then Library:Notify('Aucun joueur !', 2); return end
    local target    = Players:FindFirstChild(selectedPlayerName)
    local targetHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP     = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if targetHRP and myHRP then
        myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 0)
        Library:Notify('TP -> '..selectedPlayerName, 2)
    else Library:Notify('Personnage introuvable !', 2) end
end})
UniTPRight:AddDivider()
tpContinuToggle = UniTPRight:AddToggle('UniTPContinu', {
    Text    = 'TP Continu',
    Default = false,
    Callback = function(v)
        tpContinu = v
        if v then
            if not selectedPlayerName then
                Library:Notify('Selectionne un joueur !', 2)
                tpContinuToggle:SetValue(false); return
            end
            tpContinuTarget = selectedPlayerName
            startTpContinu()
            Library:Notify('TP Continu : '..selectedPlayerName, 2)
        else
            stopTpContinu()
            Library:Notify('TP Continu off', 2)
        end
    end,
})

-- ============================================================
-- TAB EXTRAS – VISUEL
-- ============================================================
local EL1 = Tabs.Extras:AddLeftGroupbox('Visuel')
local ER1 = Tabs.Extras:AddRightGroupbox('Joueur')

EL1:AddToggle('ESP',{Text='ESP Joueurs',Default=false,
    Callback=function(v) updateESP(v) end})
EL1:AddToggle('FullBright',{Text='FullBright',Default=false,
    Callback=function(v) setFullBright(v) end})
EL1:AddToggle('DisableFog',{Text='Disable Fog',Default=false,
    Callback=function(v) setDisableFog(v) end})
EL1:AddToggle('FpsBoost',{Text='FPS Boost',Default=false,
    Callback=function(v) setFpsBoost(v) end})
EL1:AddDivider()
EL1:AddSlider('FOVSlider',{Text='FOV Changer',Default=70,Min=30,Max=120,Rounding=0,
    Callback=function(v) Camera.FieldOfView = v end})
EL1:AddDivider()
EL1:AddLabel('Day/Night Changer :')
EL1:AddSlider('DayNight',{Text='Heure',Default=14,Min=0,Max=24,Rounding=0,
    Callback=function(v) Lighting.ClockTime = v end})

-- ============================================================
-- TAB EXTRAS – JOUEUR
-- ============================================================
ER1:AddToggle('AntiAFK',{Text='Anti AFK',Default=false,
    Callback=function(v) setAntiAFK(v) end})
ER1:AddToggle('AutoRespawn',{Text='Auto Respawn',Default=false,
    Callback=function(v) setAutoRespawn(v) end})
ER1:AddToggle('ShiftLock',{Text='Shift Lock',Default=false,
    Callback=function(v) setShiftLock(v) end})
ER1:AddToggle('AntiVoid',{Text='Anti Void',Default=false,
    Callback=function(v) setAntiVoid(v) end})
ER1:AddToggle('WaterWalk',{Text='Water Walk',Default=false,
    Callback=function(v) setWaterWalk(v) end})
ER1:AddToggle('PlatformStand',{Text='Platform Stand',Default=false,
    Callback=function(v) setPlatformStand(v) end})
ER1:AddToggle('SpinBot',{Text='Spin Bot',Default=false,
    Callback=function(v) setSpinBot(v) end})
ER1:AddToggle('FakeLag',{Text='Fake Lag',Default=false,
    Callback=function(v) setFakeLag(v) end})

-- ============================================================
-- TAB EXTRAS – CAMERA & DEPLACEMENT
-- ============================================================
local EL2 = Tabs.Extras:AddLeftGroupbox('Camera & Deplacement')
local ER2 = Tabs.Extras:AddRightGroupbox('Serveur')

EL2:AddToggle('Freecam',{Text='Freecam',Default=false,
    Callback=function(v) if v then startFreecam() else stopFreecam() end end})
EL2:AddLabel('(W/A/S/D + Space/Ctrl | Shift = rapide)')
EL2:AddDivider()
EL2:AddToggle('ClickTP',{Text='Click TP',Default=false,
    Callback=function(v) setClickTP(v) end})
EL2:AddDivider()
-- Teleport Tool : cree un outil dans le backpack qui tp au clic
EL2:AddButton({Text='Donner Teleport Tool', Func=function()
    sc(function()
        local tool  = Instance.new("Tool")
        tool.Name   = "TeleportTool"
        tool.RequiresHandle = false
        tool.Parent = player.Backpack
        local script = Instance.new("LocalScript", tool)
        script.Source = [[
            local tool = script.Parent
            local player = game.Players.LocalPlayer
            local Camera = workspace.CurrentCamera
            local UIS = game:GetService("UserInputService")
            tool.Activated:Connect(function()
                local unitRay = Camera:ScreenPointToRay(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)
                local ray = Ray.new(unitRay.Origin, unitRay.Direction * 1000)
                local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
                if hit then
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0)) end
                end
            end)
        ]]
        Library:Notify('Teleport Tool ajoute dans ton backpack !', 3)
    end)
end})

-- ============================================================
-- TAB EXTRAS – SERVEUR
-- ============================================================
ER2:AddButton({Text='Rejoin Server', Func=function()
    Library:Notify('Rejoin en cours...', 2)
    task.wait(0.5)
    sc(function() TeleportSvc:Teleport(game.PlaceId, player) end)
end})

ER2:AddButton({Text='Server Hop', Func=function()
    Library:Notify('Server Hop...', 2)
    task.spawn(function()
        local ok, servers = sc(function()
            return TeleportSvc:GetSortedGameInstances(game.PlaceId)
        end)
        if ok and servers and #servers > 0 then
            for _,srv in ipairs(servers) do
                if srv.CurrentPlayers < srv.MaxPlayers and srv.Id ~= game.JobId then
                    TeleportSvc:TeleportToPlaceInstance(game.PlaceId, srv.Id, player)
                    return
                end
            end
        end
        -- Fallback : rejoin simple
        TeleportSvc:Teleport(game.PlaceId, player)
    end)
end})

ER2:AddDivider()
ER2:AddLabel('Spectate joueur :')

local spectateDropdown
local spectateDropdown = ER2:AddDropdown('SpectateDropdown',{
    Text    = 'Choisir joueur',
    Values  = getPlayerNames(),
    Default = 1,
    Callback = function(v)
        if v ~= '(aucun joueur)' then
            startSpectate(v)
        end
    end,
})
ER2:AddButton({Text='Actualiser spectate liste', Func=function()
    local names = getPlayerNames()
    spectateDropdown:SetValues(names)
    spectateDropdown:SetValue(names[1])
end})
ER2:AddButton({Text='Arreter Spectate', Func=function()
    stopSpectate()
end})

-- ============================================================
-- TAB JEUX
-- ============================================================
local currentGameId  = game.GameId
local currentPlaceId = game.PlaceId

local allScripts = {
    {
        name    = 'Ninja Legends',
        gameId  = 1214557532,
        placeId = 3956818381,
        url     = 'https://raw.githubusercontent.com/LaysoxYTB/LSX-HUB/refs/heads/main/ninja_legends.lua',
    },
    {
        name    = 'Carpet Cleaning Simulator',
        gameId  = 0,
        placeId = 124374448373637,
        url     = 'https://raw.githubusercontent.com/LaysoxYTB/LSX-HUB/refs/heads/main/CarpetClean.lua',
    },
    {
        name    = 'BloxStrike',
        gameId  = 0,
        placeId = 0,
        url     = 'https://raw.githubusercontent.com/LaysoxYTB/LSX-HUB/refs/heads/main/bloxstrike_skin_changer.lua',
    },
    {
        name    = 'Ban or Get Banned',
        gameId  = 96017656548489,
        placeId = 96017656548489,
        url     = 'https://raw.githubusercontent.com/LaysoxYTB/LSX-HUB/refs/heads/main/ban%20or%20get%20banned.lua',
    },
}

local function matchesCurrentGame(g)
    if g.gameId  ~= 0 and g.gameId  == currentGameId  then return true end
    if g.placeId ~= 0 and g.placeId == currentPlaceId then return true end
    return false
end

local jeuxReconnus = {}
for _,g in ipairs(allScripts) do
    if matchesCurrentGame(g) then table.insert(jeuxReconnus, g) end
end

local JLeft  = Tabs.Jeux:AddLeftGroupbox('Jeu detecte')
local JRight = Tabs.Jeux:AddRightGroupbox('Tous les jeux')

if #jeuxReconnus > 0 then
    JLeft:AddLabel('[[ Jeu reconnu ]]')
    JLeft:AddDivider()
    for _,g in ipairs(jeuxReconnus) do
        JLeft:AddButton({
            Text = '>> '..g.name,
            Func = function() launchScript(g.name, g.url) end,
        })
    end
else
    JLeft:AddLabel('Aucun jeu reconnu.')
    JLeft:AddButton({Text='Discord LSX', Func=function()
        sc(function() setclipboard('https://discord.gg/94CnwG3ySJ') end)
        Library:Notify('Discord copie !', 2)
    end})
end
JLeft:AddDivider()
JLeft:AddLabel('PlaceId : '..tostring(currentPlaceId))
JLeft:AddLabel('GameId  : '..tostring(currentGameId))

JRight:AddLabel('Clique pour lancer :')
JRight:AddDivider()
for _,g in ipairs(allScripts) do
    JRight:AddButton({
        Text = g.name,
        Func = function() launchScript(g.name, g.url) end,
    })
end

-- ============================================================
-- TAB SETTINGS
-- ============================================================
local SLeft  = Tabs.Settings:AddLeftGroupbox('Menu')
local SRight = Tabs.Settings:AddRightGroupbox('Liens')

SLeft:AddKeybind('MenuKeybind',{
    Text     = 'Toggle Menu (minimiser)',
    Default  = 'LeftShift',
    NoUI     = false,
    Callback = function() Library:ToggleWindowVisibility() end,
})

SRight:AddButton({Text='Discord LSX', Func=function()
    sc(function() setclipboard('https://discord.gg/94CnwG3ySJ') end)
    Library:Notify('Lien Discord copie !', 3)
end})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder('LaysoxLauncher')
SaveManager:SetFolder('LaysoxLauncher/configs')
SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])

Library:Notify('Laysox Launcher charge !', 3)
