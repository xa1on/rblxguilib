local ViewWidgetsButton = {}
ViewWidgetsButton.__index = ViewWidgetsButton

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local TitlebarButton = require(GV.ObjectsDir.TitlebarButton)
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
        local RenameAction = GV.PluginObject:CreatePluginAction(math.random(), "Rename", "", nil, false)
        local DeleteAction = GV.PluginObject:CreatePluginAction(math.random(), "Delete", "", nil, false)
        RenameAction.Triggered:Connect(function()
            local NewTitlePrompt = InputPrompt.new("Rename " .. WidgetTitle, "Type in a new title:", {"OK", "Cancel"}, "New Title")
            NewTitlePrompt:Clicked(function(p)
                if p == 2 then return end
                Widget.WidgetObject.Title = InputPrompt.Input.Text
            end)
        end)
        DeleteAction.Triggered:Connect(function()
            local DeletePrompt = TextPrompt.new("Delete " .. WidgetTitle, 'Are you sure you want to delete "' .. WidgetTitle .. '"?', {"OK", "Cancel"})
            DeletePrompt:Clicked(function(p)
                if p == 2 then return end
                if Widget.Menu and #Widget.Menu.Pages > 0 then
                    local AvailibleWidgets = {}
                    for _,v in pairs(GV.PluginWidgets)do
                        if v.Menu and v.WidgetObject.Title ~= WidgetTitle then AvailibleWidgets[#AvailibleWidgets+1] = {v.WidgetObject.Title, v} end
                    end
                    if #AvailibleWidgets < 1 then return end
                    local AvailibleWidgetsInputField = InputField.new(nil, AvailibleWidgets[1], AvailibleWidgets, nil, false, true, nil, nil, nil)
                    local TransferPrompt = InputPrompt.new("Transfer Pages", "Where would you like to move the pages?", {"OK", "Cancel"}, AvailibleWidgetsInputField)
                    TransferPrompt:Clicked(function(p2)
                        if p2 == 2 then return end
                        local TranferWidget = TransferPrompt.InputField.Value
                        if TranferWidget == "" then return end
                        for _, v in pairs(Widget.Menu.Pages) do
                            v.TabFrame.Parent = TranferWidget.Menu.TabContainer
                            v.Content.Parent = TranferWidget.Menu.ContentContainers
                            v.PageMenu = TranferWidget.Menu
                            v.InsideWidget = true
                            v.Parent = TranferWidget.Menu
                            TranferWidget.Menu:AddPage(v)
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
        WidgetMenuObject:AddAction(RenameAction)
        WidgetMenuObject:AddAction(DeleteAction)
        ViewMenu[#ViewMenu+1] = {WidgetMenuObject, RenameAction, DeleteAction}
    end
    self.PluginMenu:AddSeparator()
    local CreateNewWindowAction = GV.PluginObject:CreatePluginAction(math.random(), "Create New Window", "", nil, false)
    CreateNewWindowAction.Triggered:Connect(function()
        self.new(PluginWidget.new(nil, nil, true).Menu)
    end)
    self.PluginMenu:AddAction(CreateNewWindowAction)
end

function ViewWidgetsButton.new(PageMenu)
    local self = TitlebarButton.new("VIEW", PageMenu, nil, false)
    setmetatable(self,ViewWidgetsButton)
    self.Button.MouseButton1Click:Connect(function()
        if self.Disabled then return end
        self:RefreshList()
    end)
    return self
end

return ViewWidgetsButton