-- Carpet Cleaning Simulator | laysox
-- Interface : Linoria Rewrite

local repo         = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library      = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager  = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local RS  = game:GetService("ReplicatedStorage")
local function sc(f,...) return pcall(f,...) end

local autoActive = false
local autoConn   = nil

local function finishJob()
    sc(function()
        RS:WaitForChild("Remotes"):WaitForChild("RequestJobComplete"):FireServer(1, 9999999)
    end)
end

local function startAuto()
    if autoConn then return end
    autoConn = task.spawn(function()
        while autoActive do
            finishJob()
            task.wait(1)
        end
    end)
end

local function stopAuto()
    autoActive = false
    autoConn   = nil
end

-- WINDOW
local Window = Library:CreateWindow({
    Title    = 'Carpet Clean | laysox',
    Center   = true,
    AutoShow = true,
    TabPadding  = 8,
    MenuFadeTime = 0.2,
})

local Tabs = {
    Main     = Window:AddTab('Main'),
    Settings = Window:AddTab('Settings'),
}

-- TAB MAIN
local Left  = Tabs.Main:AddLeftGroupbox('Job')
local Right = Tabs.Main:AddRightGroupbox('Auto')

Left:AddLabel('Carpet Cleaning Simulator')
Left:AddDivider()

Left:AddButton({
    Text = 'Finish Job',
    Func = function()
        finishJob()
        Library:Notify('Job complete !', 2)
    end,
})

Right:AddToggle('AutoFinish', {
    Text    = 'Auto Finish Job',
    Default = false,
    Callback = function(v)
        autoActive = v
        if v then
            startAuto()
            Library:Notify('Auto Finish active', 2)
        else
            stopAuto()
            Library:Notify('Auto Finish desactive', 2)
        end
    end,
})

Right:AddDivider()
Right:AddLabel('Credits : laysox')

-- TAB SETTINGS
local SLeft = Tabs.Settings:AddLeftGroupbox('Menu')

SLeft:AddKeybind('MenuKeybind', {
    Text    = 'Toggle Menu',
    Default = 'RightShift',
    NoUI    = true,
    Callback = function() Library:ToggleWindowVisibility() end,
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('LaysoxCarpetClean')
SaveManager:SetFolder('LaysoxCarpetClean/configs')
SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])

Library:Notify('Carpet Clean charge | laysox', 3)
