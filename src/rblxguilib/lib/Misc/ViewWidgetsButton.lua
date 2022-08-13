local ChangeHistoryService = game:GetService("ChangeHistoryService")
local GuiService = game:GetService("GuiService")
local ViewWidgetsButton = {}
ViewWidgetsButton.__index = ViewWidgetsButton

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local TitlebarButton = require(GV.MiscDir.TitlebarButton)
local InputPrompt = require(GV.PromptsDir.InputPrompt)
local InputField = require(GV.ObjectsDir.InputField)
local TextPrompt = require(GV.PromptsDir.TextPrompt)
local PluginWidget = require(GV.FramesDir.PluginWidget)
setmetatable(ViewWidgetsButton,TitlebarButton)

local ViewMenu = {}

function ViewWidgetsButton:RefreshList()
    if self.PluginMenu then
        self.PluginMenu:Clear()
        for _, v in pairs(ViewMenu)do
            for _, j in pairs(v) do
                j:Destroy()
            end
        end
    else self.PluginMenu = GV.PluginObject:CreatePluginMenu(math.random(), "View Menu") end
    for i,Widget in pairs(GV.PluginWidgets) do
        local WidgetTitle = Widget.WidgetObject.Title 
        local WidgetMenuObject = GV.PluginObject:CreatePluginMenu(math.random(), tostring(i) .. ': "' .. WidgetTitle .. '"')
        self.PluginMenu:AddMenu(WidgetMenuObject)
        local ToggleAction = GV.PluginObject:CreatePluginAction(math.random(), "Toggle", "", nil, false)
        local RenameAction = GV.PluginObject:CreatePluginAction(math.random(), "Rename", "", nil, false)
        local DeleteAction = GV.PluginObject:CreatePluginAction(math.random(), "Delete", "", nil, false)
        ToggleAction.Triggered:Connect(function()
            Widget.WidgetObject.Enabled = not Widget.WidgetObject.Enabled
        end)
        RenameAction.Triggered:Connect(function()
            local NewTitlePrompt = InputPrompt.new("Rename " .. WidgetTitle, "Type in a new name:", {"OK", "Cancel"}, InputField.new("New name", WidgetTitle, nil, nil, true))
            NewTitlePrompt:Clicked(function(p)
                if p == 2 then return end
                Widget.WidgetObject.Title = NewTitlePrompt.Input.Text
            end)
        end)
        DeleteAction.Triggered:Connect(function()
            local DeletePrompt = TextPrompt.new("Delete " .. WidgetTitle, 'Are you sure you want to delete "' .. WidgetTitle .. '"?', {"OK", "Cancel"})
            DeletePrompt:Clicked(function(p)
                if p == 2 then return end
                if Widget.TitlebarMenu and #Widget.TitlebarMenu.Pages > 0 then
                    local AvailibleWidgets = {}
                    for _,v in pairs(GV.PluginWidgets)do
                        if v.TitlebarMenu and v.WidgetObject.Title ~= WidgetTitle then AvailibleWidgets[#AvailibleWidgets+1] = {v.WidgetObject.Title, v} end
                    end
                    if #AvailibleWidgets < 1 then return end
                    local TransferPrompt = InputPrompt.new("Transfer Pages", "Where would you like to move the pages?", {"OK", "Cancel"}, InputField.new(nil, AvailibleWidgets[1], AvailibleWidgets, nil, false, true, nil, nil, nil))
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
        ViewMenu[#ViewMenu+1] = {WidgetMenuObject, RenameAction, DeleteAction}
    end
    self.PluginMenu:AddSeparator()
    local CreateNewWindowAction = GV.PluginObject:CreatePluginAction(math.random(), "Create New Window", "", nil, false)
    local ResetLayoutAction = GV.PluginObject:CreatePluginAction(math.random(), "Reset Plugin Layout", "", nil, false)
    CreateNewWindowAction.Triggered:Connect(function()
        PluginWidget.new(nil, nil, true)
    end)
    ResetLayoutAction.Triggered:Connect(function()
        require(GV.ManagersDir.SaveManager).ResetLayout()
    end)
    self.PluginMenu:AddAction(CreateNewWindowAction)
    self.PluginMenu:AddAction(ResetLayoutAction)
end

function ViewWidgetsButton.new()
    local self = TitlebarButton.new("VIEW", nil, false)
    setmetatable(self,ViewWidgetsButton)
    self:Clicked(function()
        self:RefreshList()
    end)
    return self
end

return ViewWidgetsButton