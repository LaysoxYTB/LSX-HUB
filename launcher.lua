-- Laysox Launcher | Linoria UI
local repo         = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library      = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager  = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")

local player = Players.LocalPlayer
repeat task.wait(0.5) until player.Character
local character        = player.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local Camera           = workspace.CurrentCamera

local function sc(f,...) pcall(f,...) end

local flySpeed   = 100
local flyActive  = false
local flyKeyName = "G"
local noclip     = false
local wsActive   = false
local wsValue    = 50
local ijConn     = nil
local HMC        = {}

local function refresh()
    character        = player.Character; if not character then return end
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(function()
    task.wait(1); refresh()
    flyActive=false; noclip=false; wsActive=false
end)

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
        if UIS:IsKeyDown(Enum.KeyCode.W) then mv=mv+cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then mv=mv-cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then mv=mv-cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then mv=mv+cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then mv=mv+Vector3.new(0,1,0) end
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

task.spawn(function()
    while task.wait(0.25) do
        if not noclip then continue end
        local c=player.Character; if not c then continue end
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)

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

UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.UserInputType~=Enum.UserInputType.Keyboard then return end
    if input.KeyCode.Name==flyKeyName then
        if flyActive then stopFly() else startFly() end
    end
end)

-- WINDOW
local Window=Library:CreateWindow({
    Title='Laysox Launcher',
    Center=true,
    AutoShow=true,
    TabPadding=8,
    MenuFadeTime=0.2,
})

local Tabs={
    Universel = Window:AddTab('Universel'),
    Jeux      = Window:AddTab('Jeux'),
    Settings  = Window:AddTab('Settings'),
}

-- TAB UNIVERSEL
local ULeft  = Tabs.Universel:AddLeftGroupbox('Fly')
local URight = Tabs.Universel:AddRightGroupbox('Mouvement')

ULeft:AddSlider('UniFlySPD',{Text='Vitesse Fly',Default=100,Min=10,Max=2000,Rounding=0,Callback=function(v) flySpeed=v end})
ULeft:AddToggle('UniFlyTog',{Text='Activer Fly',Default=false,Callback=function(v) if v then startFly() else stopFly() end end})
ULeft:AddDropdown('UniFlyKey',{
    Text='Touche Fly',
    Values={'G','Q','E','R','T','F','H','J','K','L','Z','X','C','V','B','N','M','F1','F2','F3','F4','F5','F6','LeftShift','LeftAlt','Tab'},
    Default=1,
    Callback=function(v) flyKeyName=v end,
})
ULeft:AddLabel('W/A/S/D | Space monter | Ctrl descendre')

URight:AddToggle('UniNoclip',{Text='Noclip',Default=false,Callback=function(v) noclip=v end})
URight:AddDivider()
URight:AddSlider('UniWSVal',{Text='WalkSpeed',Default=50,Min=16,Max=500,Rounding=0,Callback=function(v) wsValue=v; if wsActive then startWS() end end})
URight:AddToggle('UniWSTog',{Text='Activer WalkSpeed',Default=false,Callback=function(v) wsActive=v; if v then startWS() else stopWS() end end})
URight:AddDivider()
URight:AddToggle('UniIJ',{Text='Infinite Jump',Default=false,Callback=function(v) if v then startIJ() else stopIJ() end end})

local UniTPBox=Tabs.Universel:AddLeftGroupbox('Teleport rapide')
local tpX,tpY,tpZ=0,0,0
UniTPBox:AddInput('UniTPX',{Default='0',Text='X',Callback=function(v) tpX=tonumber(v) or tpX end})
UniTPBox:AddInput('UniTPY',{Default='0',Text='Y',Callback=function(v) tpY=tonumber(v) or tpY end})
UniTPBox:AddInput('UniTPZ',{Default='0',Text='Z',Callback=function(v) tpZ=tonumber(v) or tpZ end})
UniTPBox:AddButton({Text='Teleporter',Func=function()
    if humanoidRootPart then
        humanoidRootPart.CFrame=CFrame.new(tpX,tpY,tpZ)
        Library:Notify(('TP X:%d Y:%d Z:%d'):format(tpX,tpY,tpZ),2)
    end
end})

-- TAB JEUX
local currentPlaceId=game.PlaceId

local allScripts={
    {name='Carpet Cleaning Simulator', placeId=124374448373637, script='https://raw.githubusercontent.com/laysox/laysoxUI/main/CarpetClean.lua'},
    {name='Build A Boat For Treasure', placeId=537413528,       script='https://raw.githubusercontent.com/laysox/laysoxUI/main/BuildABoat.lua'},
    {name='Blox Strike',               placeId=0,               script=''},
    {name='Ban or Get Banned',         placeId=0,               script=''},
}

local scriptsDispos={}
local scriptsNonDispo={}
for _,g in ipairs(allScripts) do
    if g.placeId==currentPlaceId and g.script~='' then
        table.insert(scriptsDispos,g)
    else
        table.insert(scriptsNonDispo,g)
    end
end

local JLeft  = Tabs.Jeux:AddLeftGroupbox('Scripts disponibles')
local JRight = Tabs.Jeux:AddRightGroupbox('Scripts non disponibles')

if #scriptsDispos==0 then
    JLeft:AddLabel('Aucun script disponible sur ce jeu.')
    JLeft:AddLabel('Fais une demande sur le Discord !')
    JLeft:AddButton({Text='Discord LSX',Func=function()
        sc(function() setclipboard('https://discord.gg/94CnwG3ySJ') end)
        Library:Notify('Lien copie !',2)
    end})
else
    for _,g in ipairs(scriptsDispos) do
        JLeft:AddButton({
            Text=g.name,
            Func=function()
                Library:Notify('Chargement '..g.name..'...',3)
                task.wait(0.5)
                Library.Unloaded=true
                task.wait(0.3)
                sc(function() loadstring(game:HttpGet(g.script))() end)
            end,
        })
    end
end

for _,g in ipairs(scriptsNonDispo) do
    JRight:AddLabel(g.name)
end
JRight:AddDivider()
JRight:AddLabel('Place ID actuel : '..tostring(currentPlaceId))

-- TAB SETTINGS
local SLeft  = Tabs.Settings:AddLeftGroupbox('Menu')
local SRight = Tabs.Settings:AddRightGroupbox('Liens')

SLeft:AddKeybind('MenuKeybind',{
    Text='Toggle Menu',
    Default='LeftShift',
    NoUI=true,
    Callback=function() Library:ToggleWindowVisibility() end,
})

SRight:AddButton({Text='Discord LSX',Func=function()
    sc(function() setclipboard('https://discord.gg/94CnwG3ySJ') end)
    Library:Notify('Lien Discord copie !',3)
end})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('LaysoxLauncher')
SaveManager:SetFolder('LaysoxLauncher/configs')
SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])

Library:Notify('Laysox Launcher charge !',3)
