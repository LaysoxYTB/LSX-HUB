\--

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/twistedk1d/BloxStrike/refs/heads/main/Source/UI/source.lua"))()



\--// Window creation

local Window = Rayfield:CreateWindow({

&#x20;   Name = "Sqilss",

&#x20;   Icon = 0,

&#x20;   LoadingTitle = "loading Sqilss (Blox Strike)",

&#x20;   LoadingSubtitle = "by Sqilss",

&#x20;   ShowText = "Menu",

&#x20;   Theme = "Bloom",

&#x20;   ToggleUIKeybind = Enum.KeyCode.RightShift,

&#x20;   DisableRayfieldPrompts = false,

&#x20;   DisableBuildWarnings = false,

&#x20;   ConfigurationSaving = {

&#x20;       Enabled = true,

&#x20;       FolderName = "Sqilss",

&#x20;       FileName = "Sqilss\_config"

&#x20;   }

})



\--// Services \& Globals

local RS = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

local TweenService = game:GetService("TweenService")

local CAS = game:GetService("ContextActionService")

local Players = game:GetService("Players")

local Workspace = game:GetService("Workspace")

local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local camera = Workspace.CurrentCamera

local CharactersFolder = Workspace:WaitForChild("Characters", 10)



\--// TABS

local Tab\_Combat = Window:CreateTab("Combat", "crosshair")

local Tab\_Skins = Window:CreateTab("Skins", "swords")

local Tab\_Visuals = Window:CreateTab("Visuals", "eye")



Tab\_Skins:CreateLabel("skin changerby twistedk1d (not made by me)", "code", Color3.fromRGB(80,80,80), false)



\--// SHARED LOGIC

local function getTFolder() return CharactersFolder:FindFirstChild("Terrorists") end

local function getCTFolder() return CharactersFolder:FindFirstChild("Counter-Terrorists") end

local function isAlive()

&#x20;   local t, ct = getTFolder(), getCTFolder()

&#x20;   return (t and t:FindFirstChild(player.Name)) or (ct and ct:FindFirstChild(player.Name))

end

local function getEnemyFolder()

&#x20;   if not isAlive() then return nil end

&#x20;   local t, ct = getTFolder(), getCTFolder()

&#x20;   if t and t:FindFirstChild(player.Name) then return ct end

&#x20;   if ct and ct:FindFirstChild(player.Name) then return t end

&#x20;   return nil

end



\--// AIMBOT (unchanged)

local AimbotEnabled = false

local ShowFOV = false

local FOV\_Radius = 100

local Smoothing = 3

local AimKey = Enum.UserInputType.MouseButton2

local isAiming = false

local FOVCircle = Drawing.new("Circle")

FOVCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

FOVCircle.Radius = FOV\_Radius

FOVCircle.Filled = false

FOVCircle.Color = Color3.fromRGB(255, 255, 255)

FOVCircle.Visible = false

FOVCircle.Thickness = 1



local function getClosestEnemyToMouse()

&#x20;   local closestEnemy = nil

&#x20;   local shortestDistance = FOV\_Radius

&#x20;   local enemyFolder = getEnemyFolder()

&#x20;   if not enemyFolder or not AimbotEnabled then return nil end

&#x20;

&#x20;   local mousePos = UserInputService:GetMouseLocation()

&#x20;

&#x20;   for \_, enemy in ipairs(enemyFolder:GetChildren()) do

&#x20;       local hum = enemy:FindFirstChildOfClass("Humanoid")

&#x20;       local head = enemy:FindFirstChild("Head")

&#x20;       if hum and hum.Health > 0 and head then

&#x20;           local headPos, onScreen = camera:WorldToViewportPoint(head.Position)

&#x20;           if onScreen then

&#x20;               local distance = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude

&#x20;               if distance < shortestDistance then

&#x20;                   shortestDistance = distance

&#x20;                   closestEnemy = head

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;   end

&#x20;   return closestEnemy

end



UserInputService.InputBegan:Connect(function(input)

&#x20;   if input.UserInputType == AimKey then isAiming = true end

end)

UserInputService.InputEnded:Connect(function(input)

&#x20;   if input.UserInputType == AimKey then isAiming = false end

end)



RunService.RenderStepped:Connect(function()

&#x20;   if ShowFOV then

&#x20;       FOVCircle.Position = UserInputService:GetMouseLocation()

&#x20;       FOVCircle.Radius = FOV\_Radius

&#x20;       FOVCircle.Visible = true

&#x20;   else

&#x20;       FOVCircle.Visible = false

&#x20;   end

&#x20;   if not isAiming or not isAlive() or not AimbotEnabled then return end

&#x20;

&#x20;   local targetHead = getClosestEnemyToMouse()

&#x20;   if targetHead then

&#x20;       local headPos = camera:WorldToViewportPoint(targetHead.Position)

&#x20;       local mousePos = UserInputService:GetMouseLocation()

&#x20;       local moveX = (headPos.X - mousePos.X) / Smoothing

&#x20;       local moveY = (headPos.Y - mousePos.Y) / Smoothing

&#x20;       if mousemoverel then mousemoverel(moveX, moveY) end

&#x20;   end

end)



Tab\_Combat:CreateSection("Aimbot Settings")

Tab\_Combat:CreateToggle({Name = "Enable Aimbot (Hold Right Click)", CurrentValue = false, Flag = "AimbotToggle", Callback = function(Value) AimbotEnabled = Value end})

Tab\_Combat:CreateToggle({Name = "Show FOV Circle", CurrentValue = false, Flag = "FOVToggle", Callback = function(Value) ShowFOV = Value end})

Tab\_Combat:CreateSlider({Name = "FOV Radius", Range = {10, 500}, Increment = 10, Suffix = "px", CurrentValue = 100, Flag = "FOVSlider", Callback = function(Value) FOV\_Radius = Value end})

Tab\_Combat:CreateSlider({Name = "Aimbot Smoothing", Range = {1, 10}, Increment = 1, Suffix = " (Lower is faster)", CurrentValue = 3, Flag = "AimbotSmoothing", Callback = function(Value) Smoothing = Value end})



\--// TriggerBot, Hitbox, Bhop (unchanged)

local TriggerBotEnabled = false

local TriggerBotDelay = 0

Tab\_Combat:CreateSection("TriggerBot Settings")

Tab\_Combat:CreateToggle({Name = "Enable TriggerBot", CurrentValue = false, Flag = "TriggerBotToggle", Callback = function(Value) TriggerBotEnabled = Value end})

Tab\_Combat:CreateSlider({Name = "Shot Delay", Range = {0, 500}, Increment = 10, Suffix = "ms", CurrentValue = 0, Flag = "TriggerBotDelay", Callback = function(Value) TriggerBotDelay = Value end})



task.spawn(function()

&#x20;   while task.wait(0.01) do

&#x20;       if TriggerBotEnabled and isAlive() then

&#x20;           local viewportSize = camera.ViewportSize

&#x20;           local ray = camera:ViewportPointToRay(viewportSize.X / 2, viewportSize.Y / 2)

&#x20;           local raycastParams = RaycastParams.new()

&#x20;           raycastParams.FilterType = Enum.RaycastFilterType.Exclude

&#x20;           local ignoreList = {camera}

&#x20;           if player.Character then table.insert(ignoreList, player.Character) end

&#x20;           raycastParams.FilterDescendantsInstances = ignoreList

&#x20;           local result = Workspace:Raycast(ray.Origin, ray.Direction \* 1000, raycastParams)

&#x20;           if result and result.Instance then

&#x20;               local hitPart = result.Instance

&#x20;               local model = hitPart:FindFirstAncestorOfClass("Model")

&#x20;               if model and model:FindFirstChildOfClass("Humanoid") then

&#x20;                   local enemyFolder = getEnemyFolder()

&#x20;                   if enemyFolder and model.Parent == enemyFolder then

&#x20;                       local hum = model:FindFirstChildOfClass("Humanoid")

&#x20;                       if hum and hum.Health > 0 then

&#x20;                           if TriggerBotDelay > 0 then task.wait(TriggerBotDelay / 1000) end

&#x20;                           if mouse1click then mouse1click() end

&#x20;                           task.wait(0.05)

&#x20;                       end

&#x20;                   end

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;   end

end)



local HitboxEnabled = false

local HitboxSize = 3

local originalHeadSizes = {}

Tab\_Combat:CreateSection("Simple Hitbox (Max 3)")

Tab\_Combat:CreateToggle({Name = "Enable Hitbox", CurrentValue = false, Flag = "HitboxToggle", Callback = function(Value) HitboxEnabled = Value end})

Tab\_Combat:CreateSlider({Name = "Hitbox Size", Range = {1, 3}, Increment = 0.1, Suffix = " Studs", CurrentValue = 3, Flag = "HitboxSize", Callback = function(Value) HitboxSize = Value end})



task.spawn(function()

&#x20;   while task.wait(0.5) do

&#x20;       local enemyFolder = getEnemyFolder()

&#x20;       if enemyFolder then

&#x20;           for \_, enemy in ipairs(enemyFolder:GetChildren()) do

&#x20;               local head = enemy:FindFirstChild("Head")

&#x20;               local hum = enemy:FindFirstChildOfClass("Humanoid")

&#x20;               if head and hum and hum.Health > 0 then

&#x20;                   if not originalHeadSizes\[head] then originalHeadSizes\[head] = head.Size end

&#x20;                   if HitboxEnabled then

&#x20;                       head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)

&#x20;                       head.CanCollide = false

&#x20;                       head.Transparency = 0.5

&#x20;                   else

&#x20;                       if originalHeadSizes\[head] and head.Size \~= originalHeadSizes\[head] then

&#x20;                           head.Size = originalHeadSizes\[head]

&#x20;                           head.Transparency = 0

&#x20;                       end

&#x20;                   end

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;   end

end)



local BhopEnabled = false

Tab\_Combat:CreateSection("Movement Settings")

Tab\_Combat:CreateToggle({Name = "Enable Bunny Hop (Hold Space)", CurrentValue = false, Flag = "BhopToggle", Callback = function(Value) BhopEnabled = Value end})



RunService.RenderStepped:Connect(function()

&#x20;   if BhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) and isAlive() then

&#x20;       if player.Character then

&#x20;           local hum = player.Character:FindFirstChildOfClass("Humanoid")

&#x20;           if hum and hum:GetState() \~= Enum.HumanoidStateType.Jumping and hum:GetState() \~= Enum.HumanoidStateType.Freefall then

&#x20;               hum.Jump = true

&#x20;           end

&#x20;       end

&#x20;   end

end)



\--// SKINS TAB (unchanged)

local scriptRunning = false

local selectedKnife = "Butterfly Knife"

local spawned = false

local inspecting = false

local swinging = false

local lastAttackTime = 0

local ATTACK\_COOLDOWN = 1

local ACTION\_INSPECT = "InspectKnifeAction"

local ACTION\_ATTACK = "AttackKnifeAction"



pcall(function() RS.Assets.Weapons.Karambit.Camera.ViewmodelLight.Transparency = 1 end)



local knives = {

&#x20;   \["Karambit"] = {Offset = CFrame.new(0, -1.5, 1.5)},

&#x20;   \["Butterfly Knife"] = {Offset = CFrame.new(0, -1.5, 1.5)},

&#x20;   \["M9 Bayonet"] = {Offset = CFrame.new(0, -1.5, 1)},

&#x20;   \["Flip Knife"] = {Offset = CFrame.new(0, -1.5, 1.25)},

&#x20;   \["Gut Knife"] = {Offset = CFrame.new(0, -1.5, 0.5)},

}



local vm, animator

local equipAnim, idleAnim, inspectAnim, HeavySwingAnim, Swing1Anim, Swing2Anim



local function getKnifeInCamera() return camera:FindFirstChild("T Knife") or camera:FindFirstChild("CT Knife") end

local function cleanPart(part)

&#x20;   if not part:IsA("BasePart") then return end

&#x20;   part.CanCollide, part.Anchored, part.CastShadow, part.CanTouch, part.CanQuery = false, false, false, false, false

end

local function disableCollisions(model)

&#x20;   for \_, part in model:GetDescendants() do cleanPart(part) end

end

local function hideOriginalKnife(knife)

&#x20;   for \_, part in knife:GetDescendants() do

&#x20;       if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Texture") then part.Transparency = 1 end

&#x20;   end

end

local function playSound(folder, name)

&#x20;   local weaponSounds = RS.Sounds:FindFirstChild(selectedKnife)

&#x20;   if not weaponSounds then return end

&#x20;   local sound = weaponSounds:WaitForChild(folder):WaitForChild(name):Clone()

&#x20;   sound.Parent = camera

&#x20;   sound:Play()

&#x20;   sound.Ended:Once(function() sound:Destroy() end)

&#x20;   return sound

end



local function attachAsset(folder, armPartName, assetModelName, finalName, offset)

&#x20;   local targetArm = vm:FindFirstChild(armPartName)

&#x20;   if not targetArm then return end

&#x20;   local assetMesh = folder:WaitForChild(assetModelName):Clone()

&#x20;   cleanPart(assetMesh)

&#x20;   assetMesh.Name = finalName

&#x20;   assetMesh.Parent = targetArm

&#x20;   local motor = Instance.new("Motor6D")

&#x20;   motor.Part0, motor.Part1, motor.C0, motor.Parent = targetArm, assetMesh, offset, targetArm

end



local function handleAction(actionName, inputState, inputObject)

&#x20;   if inputState \~= Enum.UserInputState.Begin or not spawned or not animator or not isAlive() then return Enum.ContextActionResult.Pass end

&#x20;   if actionName == ACTION\_INSPECT then

&#x20;       if (equipAnim and equipAnim.IsPlaying) or inspecting or swinging then return Enum.ContextActionResult.Pass end

&#x20;       inspecting = true

&#x20;       if idleAnim then idleAnim:Stop() end

&#x20;       inspectAnim:Play()

&#x20;       inspectAnim.Stopped:Once(function() inspecting = false end)

&#x20;   elseif actionName == ACTION\_ATTACK then

&#x20;       local currentTime = os.clock()

&#x20;       if (equipAnim and equipAnim.IsPlaying) or (currentTime - lastAttackTime < ATTACK\_COOLDOWN) then return Enum.ContextActionResult.Pass end

&#x20;       lastAttackTime = currentTime

&#x20;       if inspecting then inspecting = false; if inspectAnim then inspectAnim:Stop() end end

&#x20;       swinging = true

&#x20;       if idleAnim then idleAnim:Stop() end

&#x20;       local anims = {HeavySwingAnim, Swing1Anim, Swing2Anim}

&#x20;       local chosenAnim = anims\[math.random(1, #anims)]

&#x20;       local soundFolder = (chosenAnim == HeavySwingAnim and "HitOne") or (chosenAnim == Swing1Anim and "HitTwo") or "HitThree"

&#x20;       chosenAnim:Play()

&#x20;       local s = playSound(soundFolder, "1")

&#x20;       if s then s.Volume = 5 end

&#x20;       chosenAnim.Stopped:Once(function() swinging = false end)

&#x20;   end

&#x20;   return Enum.ContextActionResult.Pass

end



local function removeViewmodel()

&#x20;   spawned = false

&#x20;   CAS:UnbindAction(ACTION\_INSPECT)

&#x20;   CAS:UnbindAction(ACTION\_ATTACK)

&#x20;   if vm then vm:Destroy() vm = nil end

&#x20;   animator, inspecting, swinging = nil, false, false

end



local function spawnViewmodel(knife)

&#x20;   if spawned or not scriptRunning then return end

&#x20;   local myModel = isAlive()

&#x20;   if not myModel then return end

&#x20;   spawned = true

&#x20;   local knifeTemplate = RS.Assets.Weapons:WaitForChild(selectedKnife)

&#x20;   local knifeOffset = knives\[selectedKnife].Offset

&#x20;   vm = knifeTemplate:WaitForChild("Camera"):Clone()

&#x20;   vm.Name, vm.Parent = selectedKnife, camera

&#x20;   disableCollisions(vm)

&#x20;   hideOriginalKnife(knife)

&#x20;   if myModel.Parent.Name == "Terrorists" then

&#x20;       local tGloves = RS.Assets.Weapons:WaitForChild("T Glove")

&#x20;       attachAsset(tGloves, "Left Arm", "Left Arm", "Glove", CFrame.new(0, 0, -1.5))

&#x20;       attachAsset(tGloves, "Right Arm", "Right Arm", "Glove", CFrame.new(0, 0, -1.5))

&#x20;   else

&#x20;       local sleeves = RS.Assets.Sleeves:WaitForChild("IDF")

&#x20;       local ctGloves = RS.Assets.Weapons:WaitForChild("CT Glove")

&#x20;       attachAsset(sleeves, "Left Arm", "Left Arm", "Sleeve", CFrame.new(0, 0, 0.5))

&#x20;       attachAsset(ctGloves, "Left Arm", "Left Arm", "Glove", CFrame.new(0, 0, -1.5))

&#x20;       attachAsset(sleeves, "Right Arm", "Right Arm", "Sleeve", CFrame.new(0, 0, 0.5))

&#x20;       attachAsset(ctGloves, "Right Arm", "Right Arm", "Glove", CFrame.new(0, 0, -1.5))

&#x20;   end

&#x20;   local animController = vm:FindFirstChildOfClass("AnimationController") or vm:FindFirstChildOfClass("Animator")

&#x20;   animator = animController:FindFirstChildWhichIsA("Animator") or animController

&#x20;   local animFolder = RS.Assets.WeaponAnimations:WaitForChild(selectedKnife):WaitForChild("CameraAnimations")

&#x20;   equipAnim = animator:LoadAnimation(animFolder:WaitForChild("Equip"))

&#x20;   idleAnim = animator:LoadAnimation(animFolder:WaitForChild("Idle"))

&#x20;   inspectAnim = animator:LoadAnimation(animFolder:WaitForChild("Inspect"))

&#x20;   HeavySwingAnim = animator:LoadAnimation(animFolder:WaitForChild("Heavy Swing"))

&#x20;   Swing1Anim = animator:LoadAnimation(animFolder:WaitForChild("Swing1"))

&#x20;   Swing2Anim = animator:LoadAnimation(animFolder:WaitForChild("Swing2"))

&#x20;   vm:SetPrimaryPartCFrame(camera.CFrame \* CFrame.new(0, -1.5, 5))

&#x20;   TweenService:Create(vm.PrimaryPart, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {

&#x20;       CFrame = camera.CFrame \* knifeOffset

&#x20;   }):Play()

&#x20;   equipAnim:Play()

&#x20;   playSound("Equip", "1")

&#x20;   CAS:BindAction(ACTION\_INSPECT, handleAction, false, Enum.KeyCode.F)

&#x20;   CAS:BindAction(ACTION\_ATTACK, handleAction, false, Enum.UserInputType.MouseButton1)

end



RunService.RenderStepped:Connect(function()

&#x20;   if not scriptRunning or not vm or not vm.PrimaryPart then return end

&#x20;   vm.PrimaryPart.CFrame = camera.CFrame \* knives\[selectedKnife].Offset

&#x20;   if not (equipAnim and equipAnim.IsPlaying) and not inspecting and not swinging then

&#x20;       if idleAnim and not idleAnim.IsPlaying then idleAnim:Play() end

&#x20;   end

end)



task.spawn(function()

&#x20;   while task.wait(0.1) do

&#x20;       local living = isAlive()

&#x20;       local currentKnife = getKnifeInCamera()

&#x20;       if scriptRunning and living and currentKnife and not spawned then

&#x20;           spawnViewmodel(currentKnife)

&#x20;       elseif (not scriptRunning or not currentKnife or not living) and spawned then

&#x20;           removeViewmodel()

&#x20;       end

&#x20;   end

end)



local SkinChangerEnabled = false

local SelectedSkins = {}

local DropdownObjects = {}

local SkinOptions = {}

local COOLDOWN = 0.1

local WEAR = "Factory New"

local CT\_ONLY = {\["USP-S"]=true, \["Five-SeveN"]=true, \["MP9"]=true, \["FAMAS"]=true, \["M4A1-S"]=true, \["M4A4"]=true, \["AUG"]=true}

local SHARED = {\["P250"]=true, \["Desert Eagle"]=true, \["Dual Berettas"]=true, \["Negev"]=true, \["P90"]=true, \["Nova"]=true, \["XM1014"]=true, \["AWP"]=true, \["SSG 08"]=true}

local KNIVES = {\["Karambit"]=true, \["Butterfly Knife"]=true, \["M9 Bayonet"]=true, \["Flip Knife"]=true, \["Gut Knife"]=true, \["T Knife"]=true, \["CT Knife"]=true}

local GLOVES = {\["Sports Gloves"]=true}

local SkinsFolder = RS:WaitForChild("Assets"):WaitForChild("Skins")

local IgnoreFolders = {\["HE Grenade"]=true, \["Incendiary Grenade"]=true, \["Molotov"]=true, \["Smoke Grenade"]=true, \["Flashbang"]=true, \["Decoy Grenade"]=true, \["C4"]=true, \["CT Glove"]=true, \["T Glove"]=true}



local function applyWeaponSkin(model)

&#x20;   if not model or not SkinChangerEnabled or not isAlive() then return end

&#x20;   local skinName = SelectedSkins\[model.Name]

&#x20;   if not skinName then return end

&#x20;   pcall(function()

&#x20;       local skinFolder = SkinsFolder:FindFirstChild(model.Name)

&#x20;       if not skinFolder then return end

&#x20;       local skinType = skinFolder:FindFirstChild(skinName)

&#x20;       local sourceFolder = skinType and skinType:FindFirstChild("Camera") and skinType.Camera:FindFirstChild(WEAR)

&#x20;       if not sourceFolder then return end

&#x20;       for \_, obj in camera:GetChildren() do

&#x20;           local left, right = obj:FindFirstChild("Left Arm"), obj:FindFirstChild("Right Arm")

&#x20;           if left or right then

&#x20;               local gloveFolder = SkinsFolder:FindFirstChild("Sports Gloves")

&#x20;               local gloveSkin = gloveFolder and gloveFolder:FindFirstChild(SelectedSkins\["Sports Gloves"])

&#x20;               local gloveSource = gloveSkin and gloveSkin:FindFirstChild("Camera") and gloveSkin.Camera:FindFirstChild(WEAR)

&#x20;               if gloveSource then

&#x20;                   for \_, side in {"Left Arm", "Right Arm"} do

&#x20;                       local arm, src = obj:FindFirstChild(side), gloveSource:FindFirstChild(side)

&#x20;                       if arm and src then

&#x20;                           local gloveMesh = arm:FindFirstChild("Glove")

&#x20;                           if gloveMesh then

&#x20;                               local existing = gloveMesh:FindFirstChildOfClass("SurfaceAppearance")

&#x20;                               if existing then existing:Destroy() end

&#x20;                               local clone = src:Clone()

&#x20;                               clone.Name, clone.Parent = "SurfaceAppearance", gloveMesh

&#x20;                           end

&#x20;                       end

&#x20;                   end

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;       if not GLOVES\[model.Name] then

&#x20;           local weaponFolder = model:FindFirstChild("Weapon")

&#x20;           if weaponFolder then

&#x20;               for \_, part in weaponFolder:GetDescendants() do

&#x20;                   if part:IsA("BasePart") then

&#x20;                       local newSkin = sourceFolder:FindFirstChild(part.Name)

&#x20;                       if newSkin then

&#x20;                           local existing = part:FindFirstChildOfClass("SurfaceAppearance")

&#x20;                           if existing then existing:Destroy() end

&#x20;                           local clone = newSkin:Clone()

&#x20;                           clone.Name, clone.Parent = "SurfaceAppearance", part

&#x20;                       end

&#x20;                   end

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;       model:SetAttribute("SkinApplied", skinName)

&#x20;   end)

end



Tab\_Skins:CreateToggle({Name = "Enable Skin Changer", CurrentValue = false, Flag = "SkinChangerToggle", Callback = function(Value) SkinChangerEnabled = Value; if not Value then for \_, obj in camera:GetChildren() do obj:SetAttribute("SkinApplied", nil) end end end})

Tab\_Skins:CreateButton({Name = "🎲 Randomize All Skins", Callback = function()

&#x20;   for weaponName, optionsList in pairs(SkinOptions) do

&#x20;       if #optionsList > 0 then

&#x20;           local randomSkin = optionsList\[math.random(1, #optionsList)]

&#x20;           if DropdownObjects\[weaponName] then

&#x20;               for \_, dropdown in ipairs(DropdownObjects\[weaponName]) do dropdown:Set({randomSkin}) end

&#x20;           end

&#x20;       end

&#x20;   end

end})



local function CreateSkinDropdown(weaponName)

&#x20;   local folder = SkinsFolder:FindFirstChild(weaponName)

&#x20;   if not folder then return end

&#x20;   local options = {}

&#x20;   for \_, skin in folder:GetChildren() do table.insert(options, skin.Name) end

&#x20;   SkinOptions\[weaponName] = options

&#x20;   if not SelectedSkins\[weaponName] then SelectedSkins\[weaponName] = options\[1] end

&#x20;   local dp = Tab\_Skins:CreateDropdown({

&#x20;       Name = weaponName,

&#x20;       Options = options,

&#x20;       CurrentOption = {SelectedSkins\[weaponName]},

&#x20;       Flag = "Skin\_" .. weaponName,

&#x20;       Callback = function(opt)

&#x20;           local newSkin = opt\[1]

&#x20;           SelectedSkins\[weaponName] = newSkin

&#x20;           if DropdownObjects\[weaponName] then

&#x20;               for \_, other in DropdownObjects\[weaponName] do

&#x20;                   if other.CurrentOption\[1] \~= newSkin then other:Set({newSkin}) end

&#x20;               end

&#x20;           end

&#x20;           for \_, obj in camera:GetChildren() do obj:SetAttribute("SkinApplied", nil); applyWeaponSkin(obj) end

&#x20;       end

&#x20;   })

&#x20;   DropdownObjects\[weaponName] = DropdownObjects\[weaponName] or {}

&#x20;   table.insert(DropdownObjects\[weaponName], dp)

end



Tab\_Skins:CreateToggle({Name = "Enable Custom Knife", CurrentValue = false, Flag = "KnifeToggle", Callback = function(Value) scriptRunning = Value; if not Value then removeViewmodel() end end})

Tab\_Skins:CreateDropdown({Name = "Selected Custom Knife", Options = {"Butterfly Knife", "Karambit", "M9 Bayonet", "Flip Knife", "Gut Knife"}, CurrentOption = {"Butterfly Knife"}, MultipleOptions = false, Flag = "KnifeDropdown", Callback = function(Options) selectedKnife = Options\[1]; if spawned then removeViewmodel() end end})



Tab\_Skins:CreateSection("Knives Skins")

for name in pairs(KNIVES) do CreateSkinDropdown(name) end

Tab\_Skins:CreateSection("Gloves")

for name in pairs(GLOVES) do CreateSkinDropdown(name) end

Tab\_Skins:CreateSection("CT Weapons")

for name in pairs(CT\_ONLY) do CreateSkinDropdown(name) end

Tab\_Skins:CreateSection("T Weapons")

for name in pairs(SHARED) do CreateSkinDropdown(name) end

for \_, folder in SkinsFolder:GetChildren() do

&#x20;   local n = folder.Name

&#x20;   if not IgnoreFolders\[n] and not KNIVES\[n] and not GLOVES\[n] and not CT\_ONLY\[n] and not SHARED\[n] then CreateSkinDropdown(n) end

end



camera.ChildAdded:Connect(function(obj)

&#x20;   if not SkinChangerEnabled or not isAlive() then return end

&#x20;   task.wait(COOLDOWN); applyWeaponSkin(obj)

end)



task.spawn(function()

&#x20;   while task.wait(0.5) do

&#x20;       if SkinChangerEnabled and isAlive() then

&#x20;           for \_, obj in camera:GetChildren() do

&#x20;               if SelectedSkins\[obj.Name] and obj:GetAttribute("SkinApplied") \~= SelectedSkins\[obj.Name] then applyWeaponSkin(obj) end

&#x20;           end

&#x20;       end

&#x20;   end

end)



\--// ESP + CHAMS (unchanged)

local EspEnabled = false

local EspBox = true

local EspName = true

local EspHealth = true

local EspDistance = true

local EspSkeleton = false

local EspHeadDot = false

local EspTracers = false

local EspMaxDistance = 0



local RainbowESP = false

local RainbowESP\_Speed = 2.0

local RainbowChams = false

local RainbowChams\_Speed = 2.0



local BoxColor = Color3.fromRGB(255, 50, 50)

local TextColor = Color3.fromRGB(255, 255, 255)

local SkeletonColor = Color3.fromRGB(255, 255, 255)

local TracerColor = Color3.fromRGB(255, 50, 50)

local HeadDotColor = Color3.fromRGB(255, 255, 255)

local EspTextSize = 15

local BoxThickness = 1.5



local ChamsEnabled = false

local ChamsColor = Color3.fromRGB(255, 0, 255)

local ChamsFillTransparency = 0.7

local ChamsOutlineTransparency = 0



local WeaponChamsEnabled = false

local WeaponChamsColor = Color3.fromRGB(0, 255, 255)

local WeaponChamsFillTransparency = 0.5

local WeaponChamsOutlineTransparency = 0.0



local espCache = {}

local chamsCache = {}

local weaponChamsCache = {}



local function getRainbowColor(speed)

&#x20;   local time = tick() \* speed

&#x20;   return Color3.fromHSV(time % 1, 1, 1)

end



local function createESP()

&#x20;   local esp = {

&#x20;       boxOutline = Drawing.new("Square"),

&#x20;       box = Drawing.new("Square"),

&#x20;       name = Drawing.new("Text"),

&#x20;       distance = Drawing.new("Text"),

&#x20;       healthOutline = Drawing.new("Line"),

&#x20;       healthBackground = Drawing.new("Line"),

&#x20;       healthBar = Drawing.new("Line"),

&#x20;       headDot = Drawing.new("Circle"),

&#x20;       tracer = Drawing.new("Line"),

&#x20;       skeleton = {

&#x20;           headToNeck = Drawing.new("Line"),

&#x20;           neckToTorso = Drawing.new("Line"),

&#x20;           torsoToLeftUpper = Drawing.new("Line"),

&#x20;           torsoToRightUpper = Drawing.new("Line"),

&#x20;           leftUpperToLower = Drawing.new("Line"),

&#x20;           rightUpperToLower = Drawing.new("Line"),

&#x20;           leftLowerToFoot = Drawing.new("Line"),

&#x20;           rightLowerToFoot = Drawing.new("Line")

&#x20;       }

&#x20;   }



&#x20;   esp.boxOutline.Thickness = 3

&#x20;   esp.boxOutline.Filled = false

&#x20;   esp.boxOutline.Color = Color3.new(0, 0, 0)



&#x20;   esp.box.Thickness = BoxThickness

&#x20;   esp.box.Filled = false



&#x20;   esp.name.Center = true

&#x20;   esp.name.Outline = true

&#x20;   esp.name.Size = EspTextSize



&#x20;   esp.distance.Center = true

&#x20;   esp.distance.Outline = true

&#x20;   esp.distance.Size = EspTextSize - 2



&#x20;   esp.healthOutline.Thickness = 3

&#x20;   esp.healthOutline.Color = Color3.new(0, 0, 0)



&#x20;   esp.healthBackground.Thickness = 4

&#x20;   esp.healthBackground.Color = Color3.new(0, 0, 0)

&#x20;   esp.healthBackground.Transparency = 0.7



&#x20;   esp.healthBar.Thickness = 2



&#x20;   esp.headDot.Radius = 3

&#x20;   esp.headDot.Filled = true

&#x20;   esp.headDot.Transparency = 1



&#x20;   esp.tracer.Thickness = 1.5

&#x20;   esp.tracer.Transparency = 0.8



&#x20;   for \_, line in pairs(esp.skeleton) do

&#x20;       line.Thickness = 1.5

&#x20;       line.Transparency = 0.9

&#x20;   end



&#x20;   return esp

end



RunService.RenderStepped:Connect(function()

&#x20;   if not EspEnabled or not isAlive() then

&#x20;       for \_, e in pairs(espCache) do

&#x20;           for \_, drawing in pairs(e) do

&#x20;               if typeof(drawing) == "table" then

&#x20;                   for \_, line in pairs(drawing) do line.Visible = false end

&#x20;               else

&#x20;                   drawing.Visible = false

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;       return

&#x20;   end



&#x20;   local enemyFolder = getEnemyFolder()

&#x20;   if not enemyFolder then return end



&#x20;   local currentAlive = {}

&#x20;   local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)

&#x20;   local rainbowColor = RainbowESP and getRainbowColor(RainbowESP\_Speed) or nil



&#x20;   for \_, enemy in ipairs(enemyFolder:GetChildren()) do

&#x20;       local hum = enemy:FindFirstChildOfClass("Humanoid")

&#x20;       local root = enemy:FindFirstChild("HumanoidRootPart")

&#x20;       local head = enemy:FindFirstChild("Head")



&#x20;       if hum and hum.Health > 0 and root and head then

&#x20;           currentAlive\[enemy] = true

&#x20;           if not espCache\[enemy] then espCache\[enemy] = createESP() end



&#x20;           local esp = espCache\[enemy]

&#x20;           local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)

&#x20;           local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.4, 0))

&#x20;           local legPos = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.2, 0))



&#x20;           local distance = (camera.CFrame.Position - root.Position).Magnitude



&#x20;           if EspMaxDistance > 0 and distance > EspMaxDistance then

&#x20;               for \_, d in pairs(esp) do

&#x20;                   if typeof(d) == "table" then

&#x20;                       for \_, l in pairs(d) do l.Visible = false end

&#x20;                   else

&#x20;                       d.Visible = false

&#x20;                   end

&#x20;               end

&#x20;               continue

&#x20;           end



&#x20;           if onScreen then

&#x20;               local boxHeight = math.abs(headPos.Y - legPos.Y) \* 1.05

&#x20;               local boxWidth = boxHeight \* 0.55

&#x20;               local boxX = rootPos.X - boxWidth / 2

&#x20;               local boxY = headPos.Y



&#x20;               local currentBoxColor = RainbowESP and rainbowColor or BoxColor

&#x20;               local currentTextColor = RainbowESP and rainbowColor or TextColor

&#x20;               local currentSkeletonColor = RainbowESP and rainbowColor or SkeletonColor

&#x20;               local currentTracerColor = RainbowESP and rainbowColor or TracerColor

&#x20;               local currentHeadDotColor = RainbowESP and rainbowColor or HeadDotColor



&#x20;               if EspBox then

&#x20;                   esp.boxOutline.Size = Vector2.new(boxWidth, boxHeight)

&#x20;                   esp.boxOutline.Position = Vector2.new(boxX, boxY)

&#x20;                   esp.boxOutline.Visible = true



&#x20;                   esp.box.Size = Vector2.new(boxWidth, boxHeight)

&#x20;                   esp.box.Position = Vector2.new(boxX, boxY)

&#x20;                   esp.box.Color = currentBoxColor

&#x20;                   esp.box.Thickness = BoxThickness

&#x20;                   esp.box.Visible = true

&#x20;               else

&#x20;                   esp.boxOutline.Visible = false

&#x20;                   esp.box.Visible = false

&#x20;               end



&#x20;               if EspHealth then

&#x20;                   local hpPct = hum.Health / hum.MaxHealth

&#x20;                   local barX = boxX - 7

&#x20;                   local barTop = boxY

&#x20;                   local barBottom = boxY + boxHeight



&#x20;                   esp.healthBackground.From = Vector2.new(barX, barTop)

&#x20;                   esp.healthBackground.To = Vector2.new(barX, barBottom)

&#x20;                   esp.healthBackground.Visible = true



&#x20;                   esp.healthOutline.From = Vector2.new(barX - 1, barTop - 1)

&#x20;                   esp.healthOutline.To = Vector2.new(barX + 1, barBottom + 1)

&#x20;                   esp.healthOutline.Visible = true



&#x20;                   esp.healthBar.From = Vector2.new(barX, barBottom)

&#x20;                   esp.healthBar.To = Vector2.new(barX, barBottom - (boxHeight \* hpPct))

&#x20;                   esp.healthBar.Color = Color3.fromHSV(hpPct \* 0.33, 1, 1)

&#x20;                   esp.healthBar.Visible = true

&#x20;               else

&#x20;                   esp.healthBackground.Visible = false

&#x20;                   esp.healthOutline.Visible = false

&#x20;                   esp.healthBar.Visible = false

&#x20;               end



&#x20;               if EspName then

&#x20;                   esp.name.Text = enemy.Name

&#x20;                   esp.name.Position = Vector2.new(rootPos.X, headPos.Y - 22)

&#x20;                   esp.name.Color = currentTextColor

&#x20;                   esp.name.Size = EspTextSize

&#x20;                   esp.name.Visible = true

&#x20;               else

&#x20;                   esp.name.Visible = false

&#x20;               end



&#x20;               if EspDistance then

&#x20;                   esp.distance.Text = string.format("\[%d studs]", math.floor(distance))

&#x20;                   esp.distance.Position = Vector2.new(rootPos.X, boxY + boxHeight + 4)

&#x20;                   esp.distance.Color = currentTextColor

&#x20;                   esp.distance.Size = EspTextSize - 2

&#x20;                   esp.distance.Visible = true

&#x20;               else

&#x20;                   esp.distance.Visible = false

&#x20;               end



&#x20;               if EspHeadDot then

&#x20;                   esp.headDot.Position = Vector2.new(headPos.X, headPos.Y)

&#x20;                   esp.headDot.Color = currentHeadDotColor

&#x20;                   esp.headDot.Visible = true

&#x20;               else

&#x20;                   esp.headDot.Visible = false

&#x20;               end



&#x20;               if EspTracers then

&#x20;                   esp.tracer.From = screenCenter

&#x20;                   esp.tracer.To = Vector2.new(rootPos.X, rootPos.Y + boxHeight / 2)

&#x20;                   esp.tracer.Color = currentTracerColor

&#x20;                   esp.tracer.Visible = true

&#x20;               else

&#x20;                   esp.tracer.Visible = false

&#x20;               end



&#x20;               if EspSkeleton then

&#x20;                   local neck = enemy:FindFirstChild("Neck") or head

&#x20;                   local torso = enemy:FindFirstChild("UpperTorso") or enemy:FindFirstChild("Torso")

&#x20;                   local leftUpper = enemy:FindFirstChild("LeftUpperArm")

&#x20;                   local rightUpper = enemy:FindFirstChild("RightUpperArm")

&#x20;                   local leftLower = enemy:FindFirstChild("LeftLowerArm")

&#x20;                   local rightLower = enemy:FindFirstChild("RightLowerArm")

&#x20;                   local leftFoot = enemy:FindFirstChild("LeftFoot") or enemy:FindFirstChild("Left Leg")

&#x20;                   local rightFoot = enemy:FindFirstChild("RightFoot") or enemy:FindFirstChild("Right Leg")



&#x20;                   local function w2s(pos)

&#x20;                       local p = camera:WorldToViewportPoint(pos)

&#x20;                       return Vector2.new(p.X, p.Y)

&#x20;                   end



&#x20;                   local lines = esp.skeleton

&#x20;                   for \_, line in pairs(lines) do

&#x20;                       line.Color = currentSkeletonColor

&#x20;                       line.Visible = true

&#x20;                   end



&#x20;                   lines.headToNeck.From = Vector2.new(headPos.X, headPos.Y)

&#x20;                   lines.headToNeck.To = w2s(neck.Position)



&#x20;                   lines.neckToTorso.From = w2s(neck.Position)

&#x20;                   lines.neckToTorso.To = w2s(torso and torso.Position or root.Position)



&#x20;                   lines.torsoToLeftUpper.From = w2s(torso and torso.Position or root.Position)

&#x20;                   lines.torsoToLeftUpper.To = w2s(leftUpper and leftUpper.Position or root.Position)



&#x20;                   lines.torsoToRightUpper.From = w2s(torso and torso.Position or root.Position)

&#x20;                   lines.torsoToRightUpper.To = w2s(rightUpper and rightUpper.Position or root.Position)



&#x20;                   lines.leftUpperToLower.From = w2s(leftUpper and leftUpper.Position or root.Position)

&#x20;                   lines.leftUpperToLower.To = w2s(leftLower and leftLower.Position or root.Position)



&#x20;                   lines.rightUpperToLower.From = w2s(rightUpper and rightUpper.Position or root.Position)

&#x20;                   lines.rightUpperToLower.To = w2s(rightLower and rightLower.Position or root.Position)



&#x20;                   lines.leftLowerToFoot.From = w2s(leftLower and leftLower.Position or root.Position)

&#x20;                   lines.leftLowerToFoot.To = w2s(leftFoot and leftFoot.Position or root.Position)



&#x20;                   lines.rightLowerToFoot.From = w2s(rightLower and rightLower.Position or root.Position)

&#x20;                   lines.rightLowerToFoot.To = w2s(rightFoot and rightFoot.Position or root.Position)

&#x20;               else

&#x20;                   for \_, line in pairs(esp.skeleton) do line.Visible = false end

&#x20;               end

&#x20;           else

&#x20;               for \_, d in pairs(esp) do

&#x20;                   if typeof(d) == "table" then

&#x20;                       for \_, l in pairs(d) do l.Visible = false end

&#x20;                   else

&#x20;                       d.Visible = false

&#x20;                   end

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;   end



&#x20;   for cEnemy, e in pairs(espCache) do

&#x20;       if not currentAlive\[cEnemy] then

&#x20;           for \_, d in pairs(e) do

&#x20;               if typeof(d) == "table" then

&#x20;                   for \_, l in pairs(d) do l:Remove() end

&#x20;               else

&#x20;                   d:Remove()

&#x20;               end

&#x20;           end

&#x20;           espCache\[cEnemy] = nil

&#x20;       end

&#x20;   end

end)



local function updatePlayerChams()

&#x20;   local enemyFolder = getEnemyFolder()

&#x20;   if not enemyFolder then return end

&#x20;   local rainbowColor = RainbowChams and getRainbowColor(RainbowChams\_Speed) or ChamsColor



&#x20;   for \_, enemy in ipairs(enemyFolder:GetChildren()) do

&#x20;       local hum = enemy:FindFirstChildOfClass("Humanoid")

&#x20;       if hum and hum.Health > 0 then

&#x20;           if not chamsCache\[enemy] then

&#x20;               local highlight = Instance.new("Highlight")

&#x20;               highlight.Adornee = enemy

&#x20;               highlight.Parent = enemy

&#x20;               highlight.FillTransparency = ChamsFillTransparency

&#x20;               highlight.OutlineTransparency = ChamsOutlineTransparency

&#x20;               highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

&#x20;               chamsCache\[enemy] = highlight

&#x20;           end

&#x20;           local hl = chamsCache\[enemy]

&#x20;           hl.FillColor = rainbowColor

&#x20;           hl.OutlineColor = rainbowColor

&#x20;           hl.FillTransparency = ChamsFillTransparency

&#x20;           hl.OutlineTransparency = ChamsOutlineTransparency

&#x20;       end

&#x20;   end



&#x20;   for model, hl in pairs(chamsCache) do

&#x20;       if not model.Parent or (model:FindFirstChildOfClass("Humanoid") and model:FindFirstChildOfClass("Humanoid").Health <= 0) then

&#x20;           if hl then hl:Destroy() end

&#x20;           chamsCache\[model] = nil

&#x20;       end

&#x20;   end

end



local function updateWeaponChams()

&#x20;   if not WeaponChamsEnabled then

&#x20;       for \_, hl in pairs(weaponChamsCache) do

&#x20;           if hl then hl:Destroy() end

&#x20;       end

&#x20;       weaponChamsCache = {}

&#x20;       return

&#x20;   end



&#x20;   local rainbowColor = RainbowChams and getRainbowColor(RainbowChams\_Speed) or WeaponChamsColor



&#x20;   for \_, obj in ipairs(camera:GetChildren()) do

&#x20;       if obj:IsA("Model") and (obj.Name:find("Knife") or obj:FindFirstChild("Weapon")) then

&#x20;           if not weaponChamsCache\[obj] then

&#x20;               local highlight = Instance.new("Highlight")

&#x20;               highlight.Adornee = obj

&#x20;               highlight.Parent = obj

&#x20;               highlight.FillTransparency = WeaponChamsFillTransparency

&#x20;               highlight.OutlineTransparency = WeaponChamsOutlineTransparency

&#x20;               highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

&#x20;               weaponChamsCache\[obj] = highlight

&#x20;           end

&#x20;           local hl = weaponChamsCache\[obj]

&#x20;           hl.FillColor = rainbowColor

&#x20;           hl.OutlineColor = rainbowColor

&#x20;           hl.FillTransparency = WeaponChamsFillTransparency

&#x20;           hl.OutlineTransparency = WeaponChamsOutlineTransparency

&#x20;       end

&#x20;   end



&#x20;   for obj, hl in pairs(weaponChamsCache) do

&#x20;       if not obj.Parent then

&#x20;           if hl then hl:Destroy() end

&#x20;           weaponChamsCache\[obj] = nil

&#x20;       end

&#x20;   end

end



task.spawn(function()

&#x20;   while task.wait(0.05) do

&#x20;       if ChamsEnabled then

&#x20;           updatePlayerChams()

&#x20;       end

&#x20;       updateWeaponChams()

&#x20;   end

end)



\--// ADVANCED BULLET TRACERS WITH PATTERNS (unchanged)

local BulletTracersEnabled = false

local BulletTracerColor = Color3.fromRGB(0, 255, 255)

local BulletTracerTransparency = 0.3

local BulletTracerDuration = 0.6

local BulletTracerThickness = 0.2

local BulletTracerPattern = "Straight"



local tracerParts = {}



local function createAdvancedTracer(origin, direction)

&#x20;   local tracer = Instance.new("Part")

&#x20;   tracer.Anchored = true

&#x20;   tracer.CanCollide = false

&#x20;   tracer.Transparency = BulletTracerTransparency

&#x20;   tracer.Color = BulletTracerColor

&#x20;   tracer.Material = Enum.Material.Neon

&#x20;   tracer.Size = Vector3.new(BulletTracerThickness, BulletTracerThickness, 300)

&#x20;   tracer.CFrame = CFrame.new(origin, origin + direction) \* CFrame.new(0, 0, -150)

&#x20;   tracer.Parent = Workspace



&#x20;   if BulletTracerPattern == "Wave" then

&#x20;       task.spawn(function()

&#x20;           local startTime = tick()

&#x20;           while tracer.Parent and (tick() - startTime) < BulletTracerDuration do

&#x20;               local t = (tick() - startTime) \* 15

&#x20;               local offset = Vector3.new(math.sin(t) \* 2, 0, 0)

&#x20;               tracer.CFrame = CFrame.new(origin + offset, origin + direction + offset) \* CFrame.new(0, 0, -150)

&#x20;               RunService.Heartbeat:Wait()

&#x20;           end

&#x20;           if tracer.Parent then tracer:Destroy() end

&#x20;       end)

&#x20;   elseif BulletTracerPattern == "Spiral" then

&#x20;       task.spawn(function()

&#x20;           local startTime = tick()

&#x20;           while tracer.Parent and (tick() - startTime) < BulletTracerDuration do

&#x20;               local t = (tick() - startTime) \* 20

&#x20;               local offset = Vector3.new(math.cos(t) \* 1.5, math.sin(t) \* 1.5, 0)

&#x20;               tracer.CFrame = CFrame.new(origin + offset, origin + direction + offset) \* CFrame.new(0, 0, -150)

&#x20;               RunService.Heartbeat:Wait()

&#x20;           end

&#x20;           if tracer.Parent then tracer:Destroy() end

&#x20;       end)

&#x20;   elseif BulletTracerPattern == "Dashed" then

&#x20;       task.spawn(function()

&#x20;           local startTime = tick()

&#x20;           while tracer.Parent and (tick() - startTime) < BulletTracerDuration do

&#x20;               tracer.Transparency = (math.sin(tick() \* 30) > 0) and BulletTracerTransparency or 1

&#x20;               RunService.Heartbeat:Wait()

&#x20;           end

&#x20;           if tracer.Parent then tracer:Destroy() end

&#x20;       end)

&#x20;   else

&#x20;       task.delay(BulletTracerDuration, function()

&#x20;           if tracer and tracer.Parent then tracer:Destroy() end

&#x20;       end)

&#x20;   end



&#x20;   table.insert(tracerParts, tracer)

end



UserInputService.InputBegan:Connect(function(input)

&#x20;   if input.UserInputType == Enum.UserInputType.MouseButton1 and BulletTracersEnabled and isAlive() then

&#x20;       local origin = camera.CFrame.Position

&#x20;       local direction = camera.CFrame.LookVector \* 300

&#x20;       createAdvancedTracer(origin, direction)

&#x20;   end

end)



RunService.Heartbeat:Connect(function()

&#x20;   for i = #tracerParts, 1, -1 do

&#x20;       if not tracerParts\[i].Parent then

&#x20;           table.remove(tracerParts, i)

&#x20;       end

&#x20;   end

end)



\--// PARTICLE EFFECTS (unchanged)

local ParticleEffectsEnabled = false

local ParticleColor = Color3.fromRGB(255, 100, 0)

local ParticleAmount = 25

local ParticleLifetime = 1.2

local ParticleStyle = "Spark"



local function createParticleEffect(position)

&#x20;   if not ParticleEffectsEnabled then return end



&#x20;   local attachment = Instance.new("Attachment")

&#x20;   attachment.Position = position

&#x20;   attachment.Parent = Workspace.Terrain



&#x20;   local particle = Instance.new("ParticleEmitter")

&#x20;   particle.Color = ColorSequence.new(ParticleColor)

&#x20;   particle.Texture = "rbxassetid://243660364"

&#x20;   particle.Lifetime = NumberRange.new(ParticleLifetime \* 0.6, ParticleLifetime)

&#x20;   particle.Rate = 0

&#x20;   particle.EmissionDirection = Enum.NormalId.Front

&#x20;   particle.SpreadAngle = Vector2.new(35, 35)

&#x20;   particle.Speed = NumberRange.new(8, 18)

&#x20;   particle.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 0.1)})

&#x20;   particle.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})

&#x20;   particle.Parent = attachment



&#x20;   if ParticleStyle == "Smoke" then

&#x20;       particle.Texture = "rbxassetid://243098098"

&#x20;       particle.Speed = NumberRange.new(2, 6)

&#x20;   elseif ParticleStyle == "Fire" then

&#x20;       particle.Texture = "rbxassetid://241650934"

&#x20;       particle.Speed = NumberRange.new(5, 12)

&#x20;   elseif ParticleStyle == "Explosion" then

&#x20;       particle.Lifetime = NumberRange.new(0.4, 0.8)

&#x20;       particle.Speed = NumberRange.new(15, 30)

&#x20;       particle.SpreadAngle = Vector2.new(80, 80)

&#x20;       particle.Amount = ParticleAmount \* 2

&#x20;   elseif ParticleStyle == "Magic" then

&#x20;       particle.Texture = "rbxassetid://243098098"

&#x20;       particle.RotSpeed = NumberRange.new(-200, 200)

&#x20;   end



&#x20;   particle:Emit(ParticleAmount)



&#x20;   task.delay(ParticleLifetime + 0.5, function()

&#x20;       if attachment then attachment:Destroy() end

&#x20;   end)

end



UserInputService.InputBegan:Connect(function(input)

&#x20;   if input.UserInputType == Enum.UserInputType.MouseButton1 and ParticleEffectsEnabled and isAlive() then

&#x20;       local ray = camera:ViewportPointToRay(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

&#x20;       local raycastParams = RaycastParams.new()

&#x20;       raycastParams.FilterType = Enum.RaycastFilterType.Exclude

&#x20;       raycastParams.FilterDescendantsInstances = {camera, player.Character or {}}

&#x20;       local result = Workspace:Raycast(ray.Origin, ray.Direction \* 500, raycastParams)



&#x20;       if result and result.Position then

&#x20;           createParticleEffect(result.Position)

&#x20;       else

&#x20;           local muzzlePos = camera.CFrame.Position + camera.CFrame.LookVector \* 3

&#x20;           createParticleEffect(muzzlePos)

&#x20;       end

&#x20;   end

end)



\--// KILL EFFECTS (NEW)

local KillEffectsEnabled = false

local KillEffectColor = Color3.fromRGB(255, 0, 100)

local KillEffectDuration = 0.8

local KillEffectIntensity = 0.6



local killFlashGui = nil

local killText = nil



local function createKillEffects()

&#x20;   if not KillEffectsEnabled then return end



&#x20;   -- Screen Flash

&#x20;   if not killFlashGui then

&#x20;       killFlashGui = Instance.new("ScreenGui")

&#x20;       killFlashGui.ResetOnSpawn = false

&#x20;       killFlashGui.Parent = player:WaitForChild("PlayerGui")



&#x20;       local flashFrame = Instance.new("Frame")

&#x20;       flashFrame.Size = UDim2.new(1, 0, 1, 0)

&#x20;       flashFrame.BackgroundColor3 = KillEffectColor

&#x20;       flashFrame.BackgroundTransparency = 1

&#x20;       flashFrame.BorderSizePixel = 0

&#x20;       flashFrame.Parent = killFlashGui

&#x20;       killFlashGui.Frame = flashFrame

&#x20;   end



&#x20;   local flash = killFlashGui.Frame

&#x20;   flash.BackgroundTransparency = 0.2

&#x20;   TweenService:Create(flash, TweenInfo.new(KillEffectDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()



&#x20;   -- Floating Kill Text

&#x20;   local text = Instance.new("TextLabel")

&#x20;   text.Size = UDim2.new(0, 300, 0, 100)

&#x20;   text.Position = UDim2.new(0.5, -150, 0.4, 0)

&#x20;   text.BackgroundTransparency = 1

&#x20;   text.Text = "KILL"

&#x20;   text.TextColor3 = KillEffectColor

&#x20;   text.TextScaled = true

&#x20;   text.Font = Enum.Font.GothamBold

&#x20;   text.TextStrokeTransparency = 0

&#x20;   text.TextStrokeColor3 = Color3.new(0, 0, 0)

&#x20;   text.Parent = player.PlayerGui



&#x20;   TweenService:Create(text, TweenInfo.new(KillEffectDuration \* 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0.25, 0), TextTransparency = 1}):Play()



&#x20;   task.delay(KillEffectDuration, function()

&#x20;       if text and text.Parent then text:Destroy() end

&#x20;   end)

end



\-- Detect kills (monitor enemy health dropping to 0)

task.spawn(function()

&#x20;   local lastHealth = {}

&#x20;   while task.wait(0.1) do

&#x20;       if not KillEffectsEnabled then continue end

&#x20;       local enemyFolder = getEnemyFolder()

&#x20;       if not enemyFolder then continue end



&#x20;       for \_, enemy in ipairs(enemyFolder:GetChildren()) do

&#x20;           local hum = enemy:FindFirstChildOfClass("Humanoid")

&#x20;           if hum then

&#x20;               local currentHealth = hum.Health

&#x20;               if lastHealth\[enemy] and lastHealth\[enemy] > 0 and currentHealth <= 0 then

&#x20;                   createKillEffects()

&#x20;               end

&#x20;               lastHealth\[enemy] = currentHealth

&#x20;           end

&#x20;       end

&#x20;   end

end)



\--// Visuals Tab UI

Tab\_Visuals:CreateSection("ESP Master Switch")

Tab\_Visuals:CreateToggle({Name = "Enable Player ESP", CurrentValue = false, Flag = "ESPToggle", Callback = function(Value) EspEnabled = Value end})



Tab\_Visuals:CreateSection("ESP Visual Settings")

Tab\_Visuals:CreateToggle({Name = "Show Box", CurrentValue = true, Flag = "EspBoxToggle", Callback = function(Value) EspBox = Value end})

Tab\_Visuals:CreateToggle({Name = "Show Health Bar", CurrentValue = true, Flag = "EspHealthToggle", Callback = function(Value) EspHealth = Value end})

Tab\_Visuals:CreateToggle({Name = "Show Name", CurrentValue = true, Flag = "EspNameToggle", Callback = function(Value) EspName = Value end})

Tab\_Visuals:CreateToggle({Name = "Show Distance", CurrentValue = true, Flag = "EspDistanceToggle", Callback = function(Value) EspDistance = Value end})

Tab\_Visuals:CreateToggle({Name = "Show Skeleton", CurrentValue = false, Flag = "EspSkeletonToggle", Callback = function(Value) EspSkeleton = Value end})

Tab\_Visuals:CreateToggle({Name = "Show Head Dot", CurrentValue = false, Flag = "EspHeadDotToggle", Callback = function(Value) EspHeadDot = Value end})

Tab\_Visuals:CreateToggle({Name = "Show Tracers", CurrentValue = false, Flag = "EspTracersToggle", Callback = function(Value) EspTracers = Value end})



Tab\_Visuals:CreateSection("Rainbow Settings")

Tab\_Visuals:CreateToggle({Name = "🌈 Rainbow ESP", CurrentValue = false, Flag = "RainbowESPToggle", Callback = function(Value) RainbowESP = Value end})

Tab\_Visuals:CreateSlider({Name = "Rainbow ESP Speed", Range = {0.1, 10}, Increment = 0.1, Suffix = "", CurrentValue = 2.0, Flag = "RainbowESPSpeed", Callback = function(Value) RainbowESP\_Speed = Value end})



Tab\_Visuals:CreateToggle({Name = "🌈 Rainbow Chams", CurrentValue = false, Flag = "RainbowChamsToggle", Callback = function(Value) RainbowChams = Value end})

Tab\_Visuals:CreateSlider({Name = "Rainbow Chams Speed", Range = {0.1, 10}, Increment = 0.1, Suffix = "", CurrentValue = 2.0, Flag = "RainbowChamsSpeed", Callback = function(Value) RainbowChams\_Speed = Value end})



Tab\_Visuals:CreateSection("Player Chams (See Through Walls)")

Tab\_Visuals:CreateToggle({Name = "Enable Player Chams", CurrentValue = false, Flag = "ChamsToggle", Callback = function(Value) ChamsEnabled = Value; if not Value then for \_, hl in pairs(chamsCache) do hl:Destroy() end chamsCache = {} end end})

Tab\_Visuals:CreateColorPicker({Name = "Player Chams Color (when Rainbow off)", Color = Color3.fromRGB(255, 0, 255), Flag = "ChamsColorPicker", Callback = function(Value) ChamsColor = Value end})

Tab\_Visuals:CreateSlider({Name = "Player Chams Fill Transparency", Range = {0, 1}, Increment = 0.05, Suffix = "", CurrentValue = 0.7, Flag = "ChamsFillTrans", Callback = function(Value) ChamsFillTransparency = Value end})

Tab\_Visuals:CreateSlider({Name = "Player Chams Outline Transparency", Range = {0, 1}, Increment = 0.05, Suffix = "", CurrentValue = 0, Flag = "ChamsOutlineTrans", Callback = function(Value) ChamsOutlineTransparency = Value end})



Tab\_Visuals:CreateSection("Weapon Chams")

Tab\_Visuals:CreateToggle({Name = "Enable Weapon Chams", CurrentValue = false, Flag = "WeaponChamsToggle", Callback = function(Value) WeaponChamsEnabled = Value end})

Tab\_Visuals:CreateColorPicker({Name = "Weapon Chams Color", Color = Color3.fromRGB(0, 255, 255), Flag = "WeaponChamsColorPicker", Callback = function(Value) WeaponChamsColor = Value end})

Tab\_Visuals:CreateSlider({Name = "Weapon Chams Fill Transparency", Range = {0, 1}, Increment = 0.05, Suffix = "", CurrentValue = 0.5, Flag = "WeaponChamsFillTrans", Callback = function(Value) WeaponChamsFillTransparency = Value end})

Tab\_Visuals:CreateSlider({Name = "Weapon Chams Outline Transparency", Range = {0, 1}, Increment = 0.05, Suffix = "", CurrentValue = 0, Flag = "WeaponChamsOutlineTrans", Callback = function(Value) WeaponChamsOutlineTransparency = Value end})



Tab\_Visuals:CreateSection("Advanced Bullet Tracers")

Tab\_Visuals:CreateToggle({Name = "Enable Bullet Tracers", CurrentValue = false, Flag = "BulletTracersToggle", Callback = function(Value) BulletTracersEnabled = Value end})

Tab\_Visuals:CreateDropdown({Name = "Tracer Pattern", Options = {"Straight", "Wave", "Spiral", "Dashed"}, CurrentOption = {"Straight"}, Flag = "TracerPattern", Callback = function(Option) BulletTracerPattern = Option\[1] end})

Tab\_Visuals:CreateColorPicker({Name = "Tracer Color", Color = Color3.fromRGB(0, 255, 255), Flag = "BulletTracerColorPicker", Callback = function(Value) BulletTracerColor = Value end})

Tab\_Visuals:CreateSlider({Name = "Tracer Transparency", Range = {0, 1}, Increment = 0.05, Suffix = "", CurrentValue = 0.3, Flag = "BulletTracerTrans", Callback = function(Value) BulletTracerTransparency = Value end})

Tab\_Visuals:CreateSlider({Name = "Tracer Duration", Range = {0.1, 2}, Increment = 0.1, Suffix = " sec", CurrentValue = 0.6, Flag = "BulletTracerDuration", Callback = function(Value) BulletTracerDuration = Value end})

Tab\_Visuals:CreateSlider({Name = "Tracer Thickness", Range = {0.1, 1}, Increment = 0.05, Suffix = "", CurrentValue = 0.2, Flag = "BulletTracerThickness", Callback = function(Value) BulletTracerThickness = Value end})



Tab\_Visuals:CreateSection("Particle Effects")

Tab\_Visuals:CreateToggle({Name = "Enable Particle Effects", CurrentValue = false, Flag = "ParticleEffectsToggle", Callback = function(Value) ParticleEffectsEnabled = Value end})

Tab\_Visuals:CreateColorPicker({Name = "Particle Color", Color = Color3.fromRGB(255, 100, 0), Flag = "ParticleColorPicker", Callback = function(Value) ParticleColor = Value end})

Tab\_Visuals:CreateSlider({Name = "Particle Amount", Range = {5, 80}, Increment = 5, Suffix = "", CurrentValue = 25, Flag = "ParticleAmount", Callback = function(Value) ParticleAmount = Value end})

Tab\_Visuals:CreateSlider({Name = "Particle Lifetime", Range = {0.3, 3}, Increment = 0.1, Suffix = " sec", CurrentValue = 1.2, Flag = "ParticleLifetime", Callback = function(Value) ParticleLifetime = Value end})

Tab\_Visuals:CreateDropdown({Name = "Particle Style", Options = {"Spark", "Smoke", "Fire", "Explosion", "Magic"}, CurrentOption = {"Spark"}, Flag = "ParticleStyle", Callback = function(Option) ParticleStyle = Option\[1] end})



\--// Kill Effects Section

Tab\_Visuals:CreateSection("Kill Effects")

Tab\_Visuals:CreateToggle({Name = "Enable Kill Effects", CurrentValue = false, Flag = "KillEffectsToggle", Callback = function(Value) KillEffectsEnabled = Value end})

Tab\_Visuals:CreateColorPicker({Name = "Kill Effect Color", Color = Color3.fromRGB(255, 0, 100), Flag = "KillEffectColorPicker", Callback = function(Value) KillEffectColor = Value end})

Tab\_Visuals:CreateSlider({Name = "Kill Effect Duration", Range = {0.3, 2}, Increment = 0.1, Suffix = " sec", CurrentValue = 0.8, Flag = "KillEffectDuration", Callback = function(Value) KillEffectDuration = Value end})

Tab\_Visuals:CreateSlider({Name = "Kill Effect Intensity", Range = {0.2, 1}, Increment = 0.1, Suffix = "", CurrentValue = 0.6, Flag = "KillEffectIntensity", Callback = function(Value) KillEffectIntensity = Value end})



Tab\_Visuals:CreateSection("ESP Customization (when Rainbow is off)")

Tab\_Visuals:CreateColorPicker({Name = "Box Color", Color = Color3.fromRGB(255, 50, 50), Flag = "BoxColorPicker", Callback = function(Value) BoxColor = Value end})

Tab\_Visuals:CreateColorPicker({Name = "Text Color (Name/Distance)", Color = Color3.fromRGB(255, 255, 255), Flag = "TextColorPicker", Callback = function(Value) TextColor = Value end})

Tab\_Visuals:CreateColorPicker({Name = "Skeleton Color", Color = Color3.fromRGB(255, 255, 255), Flag = "SkeletonColorPicker", Callback = function(Value) SkeletonColor = Value end})

Tab\_Visuals:CreateColorPicker({Name = "Tracer Color", Color = Color3.fromRGB(255, 50, 50), Flag = "TracerColorPicker", Callback = function(Value) TracerColor = Value end})

Tab\_Visuals:CreateColorPicker({Name = "Head Dot Color", Color = Color3.fromRGB(255, 255, 255), Flag = "HeadDotColorPicker", Callback = function(Value) HeadDotColor = Value end})



Tab\_Visuals:CreateSlider({Name = "Text Size", Range = {10, 20}, Increment = 1, Suffix = "", CurrentValue = 15, Flag = "EspTextSize", Callback = function(Value) EspTextSize = Value end})

Tab\_Visuals:CreateSlider({Name = "Box Thickness", Range = {1, 3}, Increment = 0.1, Suffix = "", CurrentValue = 1.5, Flag = "BoxThickness", Callback = function(Value) BoxThickness = Value end})

Tab\_Visuals:CreateSlider({Name = "Max ESP Distance", Range = {0, 500}, Increment = 10, Suffix = " studs (0 = unlimited)", CurrentValue = 0, Flag = "EspDistanceLimit", Callback = function(Value) EspMaxDistance = Value end})



\--// Configs

Tab\_Visuals:CreateSection("Configs")

Tab\_Visuals:CreateButton({Name = "Save Current Config", Callback = function() Rayfield:SaveConfiguration() Rayfield:Notify({Title = "Config Saved", Content = "Settings saved successfully!", Duration = 3}) end})

Tab\_Visuals:CreateButton({Name = "Load Last Config", Callback = function() Rayfield:LoadConfiguration() Rayfield:Notify({Title = "Config Loaded", Content = "Last config loaded.", Duration = 3}) end})



\--// World \& Effects (Anti-Flash / Anti-Smoke only)

local AntiFlashEnabled, AntiSmokeEnabled = false, false

Tab\_Visuals:CreateSection("World \& Effects")

Tab\_Visuals:CreateToggle({Name = "Anti-Flashbang", CurrentValue = false, Flag = "AntiFlashToggle", Callback = function(Value) AntiFlashEnabled = Value end})

Tab\_Visuals:CreateToggle({Name = "Anti-Smoke", CurrentValue = false, Flag = "AntiSmokeToggle", Callback = function(Value) AntiSmokeEnabled = Value end})



task.spawn(function()

&#x20;   while task.wait(0.2) do

&#x20;       if AntiFlashEnabled then

&#x20;           local gui = player.PlayerGui:FindFirstChild("FlashbangEffect")

&#x20;           local effect = game:GetService("Lighting"):FindFirstChild("FlashbangColorCorrection")

&#x20;           if gui then gui:Destroy() end

&#x20;           if effect then effect:Destroy() end

&#x20;       end

&#x20;   end

end)



task.spawn(function()

&#x20;   while task.wait(0.5) do

&#x20;       if AntiSmokeEnabled then

&#x20;           local debris = Workspace:FindFirstChild("Debris")

&#x20;           if debris then

&#x20;               for \_, folder in ipairs(debris:GetChildren()) do

&#x20;                   if string.match(folder.Name, "Voxel") then folder:ClearAllChildren(); folder:Destroy() end

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;   end

end)



Rayfield:LoadConfiguration()
