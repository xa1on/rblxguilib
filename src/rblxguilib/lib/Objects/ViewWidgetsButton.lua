local ChangeHistoryService = game:GetService("ChangeHistoryService")
local GuiService = game:GetService("GuiService")
local ViewWidgetsButton = {}
ViewWidgetsButton.__index = ViewWidgetsButton

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local TitlebarButton = require(GV.ObjectsDir.TitlebarButton)
local InputPrompt = require(GV.PromptsDir.InputPrompt)
local InputField = require(GV.ObjectsDir.InputField)
local TextPrompt = require(GV.PromptsDir.TextPrompt)
local PluginWidget = require(GV.FramesDir.PluginWidget)
local LayoutManager = require(GV.ManagersDir.LayoutManager)
setmetatable(ViewWidgetsButton,TitlebarButton)

local RefreshedMenus = {}

function ViewWidgetsButton:LoadWidgetOption(Widget, i)
    local WidgetTitle = Widget.WidgetObject.Title
    local WidgetMenuObject = GV.PluginObject:CreatePluginMenu(math.random(), tostring(i) .. ': "' .. WidgetTitle .. '"')
    WidgetMenuObject.Name = '"' .. WidgetTitle .. '" Widget Menu'
    local ToggleAction = GV.PluginObject:CreatePluginAction(math.random(), "Toggle", "", nil, false)
    local RenameAction = GV.PluginObject:CreatePluginAction(math.random(), "Rename", "", nil, false)
    local DeleteAction = GV.PluginObject:CreatePluginAction(math.random(), "Delete", "", nil, false)
    ToggleAction.Triggered:Connect(function()
        Widget.WidgetObject.Enabled = not Widget.WidgetObject.Enabled
    end)
    RenameAction.Triggered:Connect(function()
        local NewTitlePrompt = InputPrompt.new({Title = "Rename " .. WidgetTitle, Text = "Type in a new name:", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Placeholder = "New name", Text = WidgetTitle, NoDropdown = true})})
        NewTitlePrompt:Clicked(function(p)
            if p == 2 then return end
            Widget.WidgetObject.Title = NewTitlePrompt.Input.Text
        end)
    end)
    DeleteAction.Triggered:Connect(function()
        local DeletePrompt = TextPrompt.new({Title = "Delete " .. WidgetTitle, Text = 'Are you sure you want to delete "' .. WidgetTitle .. '"?', Buttons = {"Yes", "No"}})
        DeletePrompt:Clicked(function(p)
            if p == 2 then return end
            if Widget.TitlebarMenu and #Widget.TitlebarMenu.Pages > 0 then
                local AvailibleWidgets = {}
                for _,v in pairs(GV.PluginWidgets)do
                    if v.TitlebarMenu and v.WidgetObject.Title ~= WidgetTitle then AvailibleWidgets[#AvailibleWidgets+1] = {v.WidgetObject.Title, v} end
                end
                if #AvailibleWidgets < 1 then return end
                local TransferPrompt = InputPrompt.new({Title = "Transfer Pages", Text = "Where would you like to move the pages?", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Value = AvailibleWidgets[1], Items = AvailibleWidgets, DisableEditing = true})})
                TransferPrompt:Clicked(function(p2)
                    if p2 == 2 then return end
                    local NewWidget = TransferPrompt.InputField.Value
                    if NewWidget == "" then return end
                    for _, v in pairs(Widget.TitlebarMenu.Pages) do
                        NewWidget.TitlebarMenu:RecievePage(v)
                    end
                    Widget.WidgetObject:Destroy()
                    Widget = nil
                    table.remove(GV.PluginWidgets, i)
                end)
            else
                Widget.WidgetObject:Destroy()
                Widget = nil
                table.remove(GV.PluginWidgets, i)
            end
        end)
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

function ViewWidgetsButton:LoadLayoutOption(Layout, i)
    if not Layout.Name then Layout.Name = "Unnamed" end
    local SavedLayouts = GV.PluginObject:GetSetting("SavedGUILayouts") or {}
    local LayoutMenuObject = GV.PluginObject:CreatePluginMenu(math.random(), tostring(i) .. ': "' .. Layout.Name .. '"')
    LayoutMenuObject.Name = '"' .. Layout.Name .. '" Layout Menu'
    local UseLayoutAction = GV.PluginObject:CreatePluginAction(math.random(), "Use", "", nil, false)
    local SaveAsAction = GV.PluginObject:CreatePluginAction(math.random(), "Save As", "", nil, false)
    local RenameAction = GV.PluginObject:CreatePluginAction(math.random(), "Rename", "", nil, false)
    local DeleteAction = GV.PluginObject:CreatePluginAction(math.random(), "Delete", "", nil, false)
    UseLayoutAction.Triggered:Connect(function()
        local OverridePrompt = TextPrompt.new({Title = "Override Layout", Text = "Are you sure you want to override the current GUI layout?", Buttons = {"Yes", "No"}})
        OverridePrompt:Clicked(function(p)
            if p == 2 then return end
            LayoutManager.RecallLayout(Layout)
        end)
    end)
    SaveAsAction.Triggered:Connect(function()
        local CurrentLayout = LayoutManager.GetLayout()
        CurrentLayout.Name = Layout.Name
        SavedLayouts[i] = CurrentLayout
        GV.PluginObject:SetSetting("SavedGUILayouts", SavedLayouts)
    end)
    RenameAction.Triggered:Connect(function()
        local RenamePrompt = InputPrompt.new({Title = "Rename Layout ", Text = "Type in a new name:", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Placeholder = "New name", Value = Layout.Name, NoDropdown = true})})
        RenamePrompt:Clicked(function(p)
            if p == 2 then return end
            Layout.Name = RenamePrompt.Input.Text
            SavedLayouts[i] = Layout
            GV.PluginObject:SetSetting("SavedGUILayouts", SavedLayouts)
        end)
    end)
    DeleteAction.Triggered:Connect(function()
        local DeletePrompt = TextPrompt.new({Title = "Delete " .. Layout.Name, Text = 'Are you sure you want to delete "' .. Layout.Name .. '"?', Buttons = {"Yes", "No"}})
        DeletePrompt:Clicked(function(p)
            if p == 2 then return end
            table.remove(SavedLayouts, i)
            GV.PluginObject:SetSetting("SavedGUILayouts", SavedLayouts)
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

function ViewWidgetsButton:CreateMenu()
    self.PluginMenu = GV.PluginObject:CreatePluginMenu(math.random(), "View Menu")
    self.PluginMenu.Name = "View Menu"
    -- Widgets Menu
    self.WidgetsMenu = GV.PluginObject:CreatePluginMenu(math.random(), "Widgets")
    self.WidgetsMenu.Name = "Widget Menu"
    local CreateNewWindowAction = GV.PluginObject:CreatePluginAction(math.random(), "Create New Window", "", nil, false)
    CreateNewWindowAction.Triggered:Connect(function()
        PluginWidget.new({Enabled = true})
    end)
    self.WidgetsMenu:AddAction(CreateNewWindowAction)
    self.WidgetsMenu:AddSeparator()
    CreateNewWindowAction.Parent = self.WidgetsMenu

    -- Saved Layouts Menu
    self.LayoutsMenu = GV.PluginObject:CreatePluginMenu(math.random(), "Layouts")
    self.LayoutsMenu.Name = "Layout Menu"
    local SaveCurrentLayout = GV.PluginObject:CreatePluginAction(math.random(), "Save Layout", "", nil, false)
    SaveCurrentLayout.Triggered:Connect(function()
        local SavedLayouts = GV.PluginObject:GetSetting("SavedGUILayouts") or {}
        local NamePrompt = InputPrompt.new({Title = "Name Layout ", Text = "Type in a name for this layout:", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Placeholder = "New name", NoDropdown = true})})
        NamePrompt:Clicked(function(p)
            if p == 2 then return end
            local NewLayout = LayoutManager.GetLayout()
            NewLayout.Name = NamePrompt.Input.Text
            SavedLayouts[#SavedLayouts+1] = NewLayout
            GV.PluginObject:SetSetting("SavedGUILayouts", SavedLayouts)
        end)
    end)
    local ResetLayoutAction = GV.PluginObject:CreatePluginAction(math.random(), "Reset Layout", "", nil, false)
    ResetLayoutAction.Triggered:Connect(function()
        LayoutManager.ResetLayout()
    end)
    self.LayoutsMenu:AddAction(SaveCurrentLayout)
    self.LayoutsMenu:AddAction(ResetLayoutAction)
    self.LayoutsMenu:AddSeparator()
    SaveCurrentLayout.Parent = self.LayoutsMenu
    ResetLayoutAction.Parent = self.LayoutsMenu

    self.PluginMenu:AddMenu(self.WidgetsMenu)
    self.PluginMenu:AddMenu(self.LayoutsMenu)
end

function ViewWidgetsButton:RefreshMenu()
    for _, v in pairs(RefreshedMenus) do
        v:Destroy()
    end
    RefreshedMenus = {}
    for i,Widget in pairs(GV.PluginWidgets) do
        local LoadedOption = self:LoadWidgetOption(Widget, i)
        RefreshedMenus[#RefreshedMenus+1] = LoadedOption
        self.WidgetsMenu:AddMenu(LoadedOption)
    end
    local SavedLayouts = GV.PluginObject:GetSetting("SavedGUILayouts") or {}
    for i,Layout in pairs(SavedLayouts) do
        local LoadedOption = self:LoadLayoutOption(Layout, i)
        RefreshedMenus[#RefreshedMenus+1] = LoadedOption
        self.LayoutsMenu:AddMenu(LoadedOption)
    end
end

function ViewWidgetsButton.new()
    local self = TitlebarButton.new({Name = "VIEW"})
    setmetatable(self,ViewWidgetsButton)
    self:CreateMenu()
    self:Clicked(function()
        self:RefreshMenu()
    end)
    return self
end

return ViewWidgetsButton