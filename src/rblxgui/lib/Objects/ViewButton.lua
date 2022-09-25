local ChangeHistoryService = game:GetService("ChangeHistoryService")
local GuiService = game:GetService("GuiService")
local ViewButton = {}
ViewButton.__index = ViewButton

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local TitlebarButton = require(GV.ObjectsDir.TitlebarButton)
local InputPrompt = require(GV.PromptsDir.InputPrompt)
local InputField = require(GV.ObjectsDir.InputField)
local ColorInput = require(GV.ObjectsDir.ColorInput)
local Labeled = require(GV.ObjectsDir.Labeled)
local TextPrompt = require(GV.PromptsDir.TextPrompt)
local PluginWidget = require(GV.FramesDir.PluginWidget)
local LayoutManager = require(GV.ManagersDir.LayoutManager)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
setmetatable(ViewButton,TitlebarButton)

local RefreshedMenus = {}

function ViewButton:CreateThemeEditor(func)
    local NewThemePrompt = TextPrompt.new({Title = "Edit Theme", Buttons = {"Save", "Cancel"}, NoPause = true})
    local ThemeColorInput = Labeled.new({
        Object = ColorInput.new({
            Color = ThemeManager.DefaultThemeColor,
            NoPause = true
        }),
        Text = "Theme Color",
        LabelSize = 0.5
    },
    NewThemePrompt.TextPromptContainer)
    ThemeColorInput.Object:SetValue(ThemeManager.ThemeColor)
    ThemeColorInput.Object:Changed(function(p)
        ThemeManager.ReloadTheme(p, ThemeManager.CurrentAccent)
    end)
    ThemeColorInput.MainFrame.Size = UDim2.new(1,0,0,28)
    local AccentColorInput = Labeled.new({
        Object = ColorInput.new({
            Color = ThemeManager.DefaultAccentColor,
            NoPause = true
        }),
        Text = "Accent Color",
        LabelSize = 0.5
    },
    NewThemePrompt.TextPromptContainer)
    AccentColorInput.Object:SetValue(ThemeManager.AccentColor)
    AccentColorInput.Object:Changed(function(p)
        ThemeManager.ReloadTheme(ThemeManager.CurrentTheme, p)
    end)
    AccentColorInput.MainFrame.Size = UDim2.new(1,0,0,28)
    NewThemePrompt.Textbox:Destroy()
    NewThemePrompt.TextFrame.Size = UDim2.new(0,0,0,10)
    NewThemePrompt.ButtonsFrame.Parent = nil
    NewThemePrompt.ButtonsFrame.Parent = NewThemePrompt.TextPromptContainer
    NewThemePrompt:Clicked(function(p) if func then func(p) end end)
end

function ViewButton:LoadWidgetOption(Widget, i)
    local WidgetTitle = Widget.WidgetObject.Title
    local WidgetMenuObject = GV.PluginObject:CreatePluginMenu(game:GetService("HttpService"):GenerateGUID(false), tostring(i) .. ': "' .. WidgetTitle .. '"')
    WidgetMenuObject.Name = '"' .. WidgetTitle .. '" Widget Menu'
    local ToggleAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Toggle", "", nil, false)
    local RenameAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Rename", "", nil, false)
    local DeleteAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Delete", "", nil, false)
    ToggleAction.Triggered:Connect(function()
        Widget.WidgetObject.Enabled = not Widget.WidgetObject.Enabled
    end)
    RenameAction.Triggered:Connect(function()
        Widget:Rename()
    end)
    DeleteAction.Triggered:Connect(function()
        Widget:Delete()
    end)
    WidgetMenuObject:AddAction(ToggleAction)
    WidgetMenuObject:AddAction(RenameAction)
    WidgetMenuObject:AddSeparator()
    WidgetMenuObject:AddAction(DeleteAction)
    ToggleAction.Parent = WidgetMenuObject
    RenameAction.Parent = WidgetMenuObject
    DeleteAction.Parent = WidgetMenuObject
    return WidgetMenuObject
end

function ViewButton:LoadLayoutOption(Layout, i)
    if not Layout.Name then Layout.Name = "Unnamed" end
    local SavedLayouts = GV.PluginObject:GetSetting(GV.PluginID.."SavedGUILayouts") or {}
    local LayoutMenuObject = GV.PluginObject:CreatePluginMenu(game:GetService("HttpService"):GenerateGUID(false), tostring(i) .. ': "' .. Layout.Name .. '"')
    LayoutMenuObject.Name = '"' .. Layout.Name .. '" Layout Menu'
    local UseLayoutAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Use", "", nil, false)
    local SaveAsAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Save As", "", nil, false)
    local RenameAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Rename", "", nil, false)
    local DeleteAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Delete", "", nil, false)
    UseLayoutAction.Triggered:Connect(function()
        local OverridePrompt = TextPrompt.new({Title = "Override Layout", Text = "Are you sure you want to override the current GUI layout?", Buttons = {"Yes", "No"}})
        OverridePrompt:Clicked(function(p)
            if p == 2 or p == 0 then return end
            LayoutManager.RecallLayout(Layout)
        end)
    end)
    SaveAsAction.Triggered:Connect(function()
        local CurrentLayout = LayoutManager.GetLayout()
        CurrentLayout.Name = Layout.Name
        SavedLayouts[i] = CurrentLayout
        GV.PluginObject:SetSetting(GV.PluginID.."SavedGUILayouts", SavedLayouts)
    end)
    RenameAction.Triggered:Connect(function()
        local RenamePrompt = InputPrompt.new({Title = "Rename Layout ", Text = "Type in a new name:", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Placeholder = "New name", Value = Layout.Name, NoDropdown = true, Unpausable = true})})
        RenamePrompt:Clicked(function(p)
            if p == 2 or p == 0 then return end
            Layout.Name = RenamePrompt.Input.Text
            SavedLayouts[i] = Layout
            GV.PluginObject:SetSetting(GV.PluginID.."SavedGUILayouts", SavedLayouts)
        end)
    end)
    DeleteAction.Triggered:Connect(function()
        local DeletePrompt = TextPrompt.new({Title = "Delete " .. Layout.Name, Text = 'Are you sure you want to delete "' .. Layout.Name .. '"?', Buttons = {"Yes", "No"}})
        DeletePrompt:Clicked(function(p)
            if p == 2 or p == 0 then return end
            table.remove(SavedLayouts, i)
            GV.PluginObject:SetSetting(GV.PluginID.."SavedGUILayouts", SavedLayouts)
        end)
    end)
    LayoutMenuObject:AddAction(UseLayoutAction)
    LayoutMenuObject:AddAction(SaveAsAction)
    LayoutMenuObject:AddAction(RenameAction)
    LayoutMenuObject:AddSeparator()
    LayoutMenuObject:AddAction(DeleteAction)
    UseLayoutAction.Parent = LayoutMenuObject
    SaveAsAction.Parent = LayoutMenuObject
    RenameAction.Parent = LayoutMenuObject
    DeleteAction.Parent = LayoutMenuObject
    return LayoutMenuObject
end

function ViewButton:LoadThemeOption(Theme, i)
    local SavedThemes = GV.PluginObject:GetSetting("SavedGUIThemes") or ThemeManager.PreinstalledThemes
    local ThemeMenuObject = GV.PluginObject:CreatePluginMenu(game:GetService("HttpService"):GenerateGUID(false), tostring(i) .. ': "' .. Theme.Name .. '"')
    ThemeMenuObject.Name = '"' .. Theme.Name .. '" Theme Menu'
    local UseThemeAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Use", "", nil, false)
    local EditAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Edit", "", nil, false)
    local RenameAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Rename", "", nil, false)
    local DeleteAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Delete", "", nil, false)
    UseThemeAction.Triggered:Connect(function()
        local OverridePrompt = TextPrompt.new({Title = "Override Theme", Text = "Are you sure you want to override the current GUI theme?", Buttons = {"Yes", "No"}})
        OverridePrompt:Clicked(function(p)
            if p == 2 or p == 0 then return end
            ThemeManager.UpdateTheme(util.TableToColor3(Theme.Theme), util.TableToColor3(Theme.Accent))
        end)
    end)
    EditAction.Triggered:Connect(function()
        self:CreateThemeEditor(function(p)
            if p == 2 or p == 0 then ThemeManager.ReloadTheme(ThemeManager.ThemeColor, ThemeManager.AccentColor)  return end
            ThemeManager.UpdateTheme()
            SavedThemes[i] = {["Name"] = Theme.Name, ["Theme"] = util.Color3ToTable(ThemeManager.ThemeColor), ["Accent"] = util.Color3ToTable(ThemeManager.AccentColor)}
            GV.PluginObject:SetSetting("SavedGUIThemes", SavedThemes)
        end)
    end)
    RenameAction.Triggered:Connect(function()
        local RenamePrompt = InputPrompt.new({Title = "Rename Theme", Text = "Type in a new name:", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Placeholder = "New name", Value = Theme.Name, NoDropdown = true, Unpausable = true})})
        RenamePrompt:Clicked(function(p)
            if p == 2 or p == 0 then return end
            Theme.Name = RenamePrompt.Input.Text
            SavedThemes[i] = Theme
            GV.PluginObject:SetSetting("SavedGUIThemes", SavedThemes)
        end)
    end)
    DeleteAction.Triggered:Connect(function()
        local DeletePrompt = TextPrompt.new({Title = "Delete " .. Theme.Name, Text = 'Are you sure you want to delete "' .. Theme.Name .. '"?', Buttons = {"Yes", "No"}})
        DeletePrompt:Clicked(function(p)
            if p == 2 or p == 0 then return end
            table.remove(SavedThemes, i)
            GV.PluginObject:SetSetting("SavedGUIThemes", SavedThemes)
        end)
    end)
    ThemeMenuObject:AddAction(UseThemeAction)
    ThemeMenuObject:AddAction(EditAction)
    ThemeMenuObject:AddAction(RenameAction)
    ThemeMenuObject:AddSeparator()
    ThemeMenuObject:AddAction(DeleteAction)
    UseThemeAction.Parent = ThemeMenuObject
    EditAction.Parent = ThemeMenuObject
    RenameAction.Parent = ThemeMenuObject
    DeleteAction.Parent = ThemeMenuObject
    return ThemeMenuObject
end

function ViewButton:CreateMenu()
    self.PluginMenu = GV.PluginObject:CreatePluginMenu(game:GetService("HttpService"):GenerateGUID(false), "View Menu")
    self.PluginMenu.Name = "View Menu"

    -- Saved Layouts Menu
    self.LayoutsMenu = GV.PluginObject:CreatePluginMenu(game:GetService("HttpService"):GenerateGUID(false), "Layouts")
    self.LayoutsMenu.Name = "Layout Menu"
    local SaveCurrentLayout = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Save Layout", "", nil, false)
    SaveCurrentLayout.Triggered:Connect(function()
        local SavedLayouts = GV.PluginObject:GetSetting(GV.PluginID.."SavedGUILayouts") or {}
        local NamePrompt = InputPrompt.new({Title = "Name Layout ", Text = "Type in a name for this layout:", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Placeholder = "New name", NoDropdown = true, Unpausable = true})})
        NamePrompt:Clicked(function(p)
            if p == 2 or p == 0 then return end
            local NewLayout = LayoutManager.GetLayout()
            NewLayout.Name = NamePrompt.Input.Text
            SavedLayouts[#SavedLayouts+1] = NewLayout
            GV.PluginObject:SetSetting(GV.PluginID.."SavedGUILayouts", SavedLayouts)
        end)
    end)
    local ResetLayoutAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Reset Layout", "", nil, false)
    ResetLayoutAction.Triggered:Connect(function()
        local OverridePrompt = TextPrompt.new({Title = "Override Layout", Text = "Are you sure you want to override the current GUI layout?", Buttons = {"Yes", "No"}})
        OverridePrompt:Clicked(function(p)
            if p == 2 or p == 0 then return end
            LayoutManager.ResetLayout()
        end)
    end)
    self.LayoutsMenu:AddAction(SaveCurrentLayout)
    self.LayoutsMenu:AddAction(ResetLayoutAction)
    self.LayoutsMenu:AddSeparator()
    SaveCurrentLayout.Parent = self.LayoutsMenu
    ResetLayoutAction.Parent = self.LayoutsMenu
    self.PluginMenu:AddMenu(self.LayoutsMenu)

    -- Widgets Menu
    self.WidgetsMenu = GV.PluginObject:CreatePluginMenu(game:GetService("HttpService"):GenerateGUID(false), "Widgets")
    self.WidgetsMenu.Name = "Widget Menu"
    local CreateNewWindowAction = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "Create New Window", "", nil, false)
    CreateNewWindowAction.Triggered:Connect(function()
        PluginWidget.new({Enabled = true})
    end)
    self.WidgetsMenu:AddAction(CreateNewWindowAction)
    self.WidgetsMenu:AddSeparator()
    CreateNewWindowAction.Parent = self.WidgetsMenu
    self.LayoutsMenu:AddMenu(self.WidgetsMenu)
    self.LayoutsMenu:AddSeparator()

    -- Appearance/Themes
    self.ThemesMenu = GV.PluginObject:CreatePluginMenu(game:GetService("HttpService"):GenerateGUID(false), "Themes")
    self.ThemesMenu.Name = "Themes Menu"
    local NewTheme = GV.PluginObject:CreatePluginAction(game:GetService("HttpService"):GenerateGUID(false), "New Theme", "", nil, false)
    NewTheme.Triggered:Connect(function()
        self:CreateThemeEditor(function(p)
            if p == 2 or p == 0 then ThemeManager.ReloadTheme(ThemeManager.ThemeColor, ThemeManager.AccentColor) return end
            ThemeManager.UpdateTheme()
            local NamePrompt = InputPrompt.new({Title = "Name Layout ", Text = "Type in a name for this theme:", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Placeholder = "New name", NoDropdown = true, Unpausable = true})})
            NamePrompt:Clicked(function(p)
                if p == 2 or p == 0 then return end
                local SavedThemes = GV.PluginObject:GetSetting("SavedGUIThemes") or ThemeManager.PreinstalledThemes
                SavedThemes[#SavedThemes+1] = {Name = NamePrompt.Input.Text, Theme = util.Color3ToTable(ThemeManager.CurrentTheme), Accent = util.Color3ToTable(ThemeManager.CurrentAccent)}
                GV.PluginObject:SetSetting("SavedGUIThemes", SavedThemes)
            end)
        end)
    end)
    self.ThemesMenu:AddAction(NewTheme)
    self.ThemesMenu:AddSeparator()
    self.PluginMenu:AddMenu(self.ThemesMenu)
    
end

function ViewButton:RefreshMenu()
    for _, v in pairs(RefreshedMenus) do
        v:Destroy()
    end
    RefreshedMenus = {}
    for i,Widget in pairs(GV.PluginWidgets) do
        local LoadedOption = self:LoadWidgetOption(Widget, i)
        RefreshedMenus[#RefreshedMenus+1] = LoadedOption
        self.WidgetsMenu:AddMenu(LoadedOption)
    end
    local SavedLayouts = GV.PluginObject:GetSetting(GV.PluginID.."SavedGUILayouts") or {}
    for i,Layout in pairs(SavedLayouts) do
        local LoadedOption = self:LoadLayoutOption(Layout, i)
        RefreshedMenus[#RefreshedMenus+1] = LoadedOption
        self.LayoutsMenu:AddMenu(LoadedOption)
    end
    local SavedThemes = GV.PluginObject:GetSetting("SavedGUIThemes") or ThemeManager.PreinstalledThemes
    for i,Theme in pairs(SavedThemes) do
        local LoadedTheme = self:LoadThemeOption(Theme, i)
        RefreshedMenus[#RefreshedMenus+1] = LoadedTheme
        self.ThemesMenu:AddMenu(LoadedTheme)
    end
end

function ViewButton.new()
    local self = TitlebarButton.new({Name = "VIEW"})
    setmetatable(self,ViewButton)
    self:CreateMenu()
    self:Clicked(function()
        self:RefreshMenu()
    end)
    return self
end

return ViewButton