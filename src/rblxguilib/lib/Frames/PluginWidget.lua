local GuiService = game:GetService("GuiService")
local Widget = {}
Widget.__index = Widget

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local plugin = GV.PluginObject
local util = require(GV.LibraryDir.GUIUtil)
local InputManager = require(GV.ManagersDir.InputManager)
local GUIFrame = require(GV.FramesDir.GUIFrame)
local TitlebarMenu = require(GV.FramesDir.TitlebarMenu)
local BackgroundFrame = require(GV.FramesDir.BackgroundFrame)
setmetatable(Widget,GUIFrame)
GV.PluginWidgets = {}
local Unnamed = 0

-- ID, Title, Enabled, NoTitlebarMenu, DockState, OverrideRestore
function Widget.new(Arguments)
    local self = GUIFrame.new(Arguments)
    setmetatable(self, Widget)
    self.ID = self.Arguments.ID or math.random()
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
    GV.PluginWidgets[#GV.PluginWidgets+1] = self
    return self
end

return Widget