-- [[ LSX V1 - WINDUI EDITION ]]
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

-- Configuration Junkie
Junkie.service = "LSX V1"
Junkie.identifier = "1067295"
Junkie.provider = "LSX"

-- Initialisation du Service de Clé
WindUI.Services.junkiedevelopment = {
    Name = "LSX Authentication", 
    Icon = "shield-check",
    Args = { "ServiceId", "ApiKey", "Provider" },

    New = function()
        local function Verify(key)
            local result = Junkie.check_key(key)
            if result and result.valid then
                if result.message == "KEYLESS" then
                    getgenv().SCRIPT_KEY = "KEYLESS"
                    return true, "Accès Keyless"
                elseif result.message == "KEY_VALID" then
                    getgenv().SCRIPT_KEY = key
                    return true, "Clé Valide"
                else
                    return false, "Clé Invalide"
                end
            end
        end

        local function Copy()
            local link = Junkie.get_key_link()
            if setclipboard then setclipboard(link) end
            return link
        end

        return { Verify = Verify, Copy = Copy }
    end
}

-- Création de la Fenêtre avec KeySystem
local Window = WindUI:CreateWindow({
    Title = "LSX V1",
    Icon = "Zap",
    Theme = "Dark",
    Transparent = true,
    Resizable = true,
    KeySystem = {
        Note = "Système de sécurité LSX. Entrez votre clé.",
        SaveKey = true,
        API = {
            {
                Title = "Obtenir la clé",
                Desc  = "Copier le lien Junkie",
                Icon  = "key-round",
                Type  = "junkiedevelopment"
            }
        }
    }
})

-- Bloque l'exécution tant que la clé n'est pas là
while not getgenv().SCRIPT_KEY do
    task.wait(0.1)
end

-- ==========================================
-- LE CŒUR DU SCRIPT (Moteur Optimisé)
-- ==========================================

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local lp         = Players.LocalPlayer
local Mouse      = lp:GetMouse()
local Camera     = workspace.CurrentCamera

local Cfg = {
    Aim=false, AimPart="Head", AimFOV=150, AimSens=0.3,
    AimTarget=nil, RMB=false, WallCheck=true,
    SA=false, SAPart="Head", SAFOV=200, SAIntensity=100,
    ESP=false, ESPColor=Color3.fromRGB(0,150,255), ESPTrans=0.3,
    ESPNames=true, ESPHP=true,
    WS=false, WSVal=25.2, JP=false, JPVal=50,
    Noclip=false, IJ=false, Fly=false, FlySpd=100,
    Smoke=false, Spin=false, SpinSpd=10, SpinDir=1, SpinAxis="Y"
}

local character, hrp, humanoid
local function refresh()
    character = lp.Character
    if character then
        hrp = character:FindFirstChild("HumanoidRootPart")
        humanoid = character:FindFirstChildWhichIsA("Humanoid")
    end
end
refresh()
lp.CharacterAdded:Connect(refresh)

-- [ ANTI-CRASH : MOUVEMENTS ET NOCLIP ]
task.spawn(function()
    while true do
        if Cfg.Noclip and lp.Character then
            for _, v in ipairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
        task.wait(0.15) -- Optimisation i7 : On ne sature pas le bus de données
    end
end)

RunService.Heartbeat:Connect(function()
    if not humanoid or not humanoid.Parent then return end
    if Cfg.WS then humanoid.WalkSpeed = Cfg.WSVal end
    if Cfg.JP then humanoid.UseJumpPower = true; humanoid.JumpPower = Cfg.JPVal end
end)

-- [ ESP OPTIMISÉ : RECYCLAGE D'INSTANCES ]
local function updateESP()
    if not Cfg.ESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                if p.Character:FindFirstChild("LSX_HL") then p.Character.LSX_HL:Destroy() end
                if p.Character:FindFirstChild("LSX_BB") then p.Character.LSX_BB:Destroy() end
            end
        end
        return
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local hl = char:FindFirstChild("LSX_HL") or Instance.new("Highlight", char)
            hl.Name = "LSX_HL"
            hl.FillColor = Cfg.ESPColor
            hl.FillTransparency = Cfg.ESPTrans
            hl.OutlineTransparency = 1
            hl.Enabled = true

            if Cfg.ESPNames then
                local head = char:FindFirstChild("Head")
                if head then
                    local bb = char:FindFirstChild("LSX_BB") or Instance.new("BillboardGui", char)
                    bb.Name = "LSX_BB"
                    bb.Adornee = head
                    bb.Size = UDim2.new(0, 100, 0, 20)
                    bb.AlwaysOnTop = true
                    bb.StudsOffset = Vector3.new(0, 2, 0)
                    
                    local lbl = bb:FindFirstChild("LBL") or Instance.new("TextLabel", bb)
                    lbl.Name = "LBL"
                    lbl.BackgroundTransparency = 1
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.TextColor3 = Cfg.ESPColor
                    lbl.TextScaled = true
                    lbl.Font = Enum.Font.SourceSansBold
                    
                    local hp = char:FindFirstChildWhichIsA("Humanoid") and math.floor(char.Humanoid.Health) or 100
                    lbl.Text = Cfg.ESPHP and p.Name.." ["..hp.." HP]" or p.Name
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do updateESP() end
end)

-- ==========================================
-- INTERFACE WINDUI
-- ==========================================

local TabCombat = Window:Tab({ Title = "Combat", Icon = "sword" })
local TabVisual = Window:Tab({ Title = "Visuals", Icon = "eye" })
local TabMisc   = Window:Tab({ Title = "Misc", Icon = "package" })

-- SECTION COMBAT
TabCombat:Section({ Title = "Aimbot" })
TabCombat:Toggle({ Title = "Activer Aimbot", Value = false, Callback = function(v) Cfg.Aim = v end })
TabCombat:Slider({ Title = "FOV", Min = 10, Max = 600, Default = 150, Callback = function(v) Cfg.AimFOV = v end })
TabCombat:Slider({ Title = "Sensibilité", Min = 1, Max = 100, Default = 30, Callback = function(v) Cfg.AimSens = v/100 end })

TabCombat:Section({ Title = "Silent Aim" })
TabCombat:Toggle({ Title = "Activer Silent Aim", Value = false, Callback = function(v) Cfg.SA = v end })

-- SECTION VISUALS
TabVisual:Section({ Title = "ESP Settings" })
TabVisual:Toggle({ Title = "Activer ESP", Value = false, Callback = function(v) Cfg.ESP = v end })
TabVisual:Toggle({ Title = "Voir Noms", Value = true, Callback = function(v) Cfg.ESPNames = v end })
TabVisual:Toggle({ Title = "Voir HP", Value = true, Callback = function(v) Cfg.ESPHP = v end })
TabVisual:Colorpicker({ Title = "Couleur ESP", Default = Cfg.ESPColor, Callback = function(v) Cfg.ESPColor = v end })

-- SECTION MISC
TabMisc:Section({ Title = "Mouvements" })
TabMisc:Toggle({ Title = "Noclip", Value = false, Callback = function(v) Cfg.Noclip = v end })
TabMisc:Slider({ Title = "WalkSpeed", Min = 16, Max = 300, Default = 25, Callback = function(v) 
    Cfg.WSVal = v 
    Cfg.WS = true
end })

TabMisc:Section({ Title = "Actions" })
TabMisc:Button({ Title = "Rage Quit", Callback = function() lp:Kick("LSX V1 - Déconnexion") end })

WindUI:Notify({
    Title = "LSX V1",
    Content = "Script chargé avec succès ! Bonne session.",
    Duration = 5
})
