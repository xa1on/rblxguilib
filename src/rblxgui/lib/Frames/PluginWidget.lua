local GuiService = game:GetService("GuiService")
local Widget = {}
Widget.__index = Widget

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local plugin = GV.PluginObject
local util = require(GV.MiscDir.GUIUtil)
local InputManager = require(GV.ManagersDir.InputManager)
local GUIFrame = require(GV.FramesDir.GUIFrame)
local TitlebarMenu = require(GV.FramesDir.TitlebarMenu)
local InputField = require(GV.ObjectsDir.InputField)
local TextPrompt = require(GV.PromptsDir.TextPrompt)
local InputPrompt = require(GV.PromptsDir.InputPrompt)
local BackgroundFrame = require(GV.FramesDir.BackgroundFrame)
setmetatable(Widget,GUIFrame)
GV.PluginWidgets = {}
local Unnamed = 0

function Widget:Delete()
    local WidgetTitle = self.WidgetObject.Title
    local DeletePrompt = TextPrompt.new({Title = "Delete " .. WidgetTitle, Text = 'Are you sure you want to delete "' .. WidgetTitle .. '"?', Buttons = {"Yes", "No"}})
    DeletePrompt:Clicked(function(p)
        if p == 2 or p == 0 then return end
        if self.TitlebarMenu and #self.TitlebarMenu.Pages > 0 then
            local AvailibleWidgets = {}
            for _,v in pairs(GV.PluginWidgets)do
                if v.TitlebarMenu and v.WidgetObject.Title ~= WidgetTitle then AvailibleWidgets[#AvailibleWidgets+1] = {Name = v.WidgetObject.Title, Value = v} end
            end
            if #AvailibleWidgets < 1 then return end
            local TransferPrompt = InputPrompt.new({Title = "Transfer Pages", Text = "Where would you like to move the pages?", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Value = AvailibleWidgets[1], Items = AvailibleWidgets, DisableEditing = true, NoFiltering = true, Unpausable = true})})
            TransferPrompt:Clicked(function(p2)
                if p2 == 2 then return end
                local NewWidget = TransferPrompt.InputField.Value
                if NewWidget == "" then return end
                for _, v in pairs(self.TitlebarMenu.Pages) do
                    NewWidget.TitlebarMenu:RecievePage(v)
                end
                self.WidgetObject:Destroy()
                table.remove(GV.PluginWidgets, self.Index)
                self = nil
            end)
            util.DumpGUI(TransferPrompt.Widget)
        else
            self.WidgetObject:Destroy()
            table.remove(GV.PluginWidgets, self.Index)
            self = nil
        end
    end)
end

function Widget:Rename()
    local NewTitlePrompt = InputPrompt.new({Title = "Rename " .. self.WidgetObject.Title, Text = "Type in a new name:", Buttons = {"OK", "Cancel"}, InputField = InputField.new({Placeholder = "New name", Text = self.WidgetObject.Title, NoDropdown = true, Unpausable = true})})
    NewTitlePrompt:Clicked(function(p)
        if p == 2 then return end
        self.WidgetObject.Title = NewTitlePrompt.Input.Text
    end)
end

-- ID, Title, Enabled, NoTitlebarMenu, DockState, OverrideRestore
function Widget.new(Arguments)
    local self = GUIFrame.new(Arguments)
    setmetatable(self, Widget)
    self.ID = self.Arguments.ID or game:GetService("HttpService"):GenerateGUID(false)
    local title = self.Arguments.Title
    if not title then
        title = self.Arguments.ID
        if not title then
            Unnamed += 1
            title = "Unnamed #" .. tostring(Unnamed)
        end
    end
    self.Arguments.DockState = self.Arguments.DockState or Enum.InitialDockState.Float
    -- really dumb but its gotta be a boolean
    if not self.Arguments.Enabled then self.Arguments.Enabled = false end
    if not self.Arguments.OverrideRestore then self.Arguments.OverrideRestore = false end
    self.WidgetObject = plugin:CreateDockWidgetPluginGui(self.ID, DockWidgetPluginGuiInfo.new(self.Arguments.DockState, self.Arguments.Enabled, self.Arguments.OverrideRestore, 300, 500, 50, 50))
    self.WidgetObject.Title = title
    self.BackgroundFrame = BackgroundFrame.new(nil, self.WidgetObject)
    self.InputFrame = Instance.new("Frame", self.WidgetObject)
    self.InputFrame.BackgroundTransparency = 1
    self.InputFrame.Size = UDim2.new(1,0,1,0)
    self.InputFrame.ZIndex = 100
    self.InputFrame.Name = "InputFrame"
    local FixPosition = false
    local FixPage = nil
    self.InputFrame.MouseMoved:Connect(function()
        if not FixPosition then return end
        FixPosition = false
        local MousePos = self.WidgetObject:GetRelativeMousePosition()
        FixPage.TabFrame.Position = UDim2.new(0,MousePos.X + FixPage.InitialX + self.TitlebarMenu.ScrollingMenu.CanvasPosition.X, 0,0)
        self.TitlebarMenu:BeingDragged(FixPage.ID)
        self.TitlebarMenu:FixPageLayout()
    end)
    InputManager.AddInput(self.InputFrame)
    if not self.Arguments.NoTitlebarMenu then self.TitlebarMenu = TitlebarMenu.new({ID = self.ID}, self.WidgetObject) end
    self.WidgetObject.PluginDragDropped:Connect(function()
        if(GV.SelectedPage and self.TitlebarMenu) then
            self.TitlebarMenu:RecievePage(GV.SelectedPage)
            FixPosition = true
            FixPage = GV.SelectedPage
            self.TitlebarMenu:SetActive(GV.SelectedPage.ID)
            GV.SelectedPage = nil
        end
    end)
    for _, v in pairs(GV.TitleBarButtons) do
        v:CreateCopy(self.TitlebarMenu)
    end
    self.Parent = self.WidgetObject
    self.Content = self.WidgetObject
    self.Index = #GV.PluginWidgets+1
    GV.PluginWidgets[self.Index] = self
    return self
end

return Widget