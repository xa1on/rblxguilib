local GuiService = game:GetService("GuiService")
local Widget = {}
Widget.__index = Widget

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local plugin = GV.PluginObject
local util = require(GV.LibraryDir.GUIUtil)
local InputManager = require(GV.ManagersDir.InputManager)
local GUIFrame = require(GV.FramesDir.GUIFrame)
local PageMenu = require(GV.FramesDir.PageMenu)
local BackgroundFrame = require(GV.FramesDir.BackgroundFrame)
setmetatable(Widget,GUIFrame)

function Widget.new(name, title, InitiallyEnabled, NoPageMenu, DockState, OverrideRestore)
    local self = GUIFrame.new()
    setmetatable(self, Widget)
    self.Name = name or math.random()
    title = title or name or ""
    DockState = DockState or Enum.InitialDockState.Float
    if InitiallyEnabled then InitiallyEnabled = true else InitiallyEnabled = false end
    if OverrideRestore then OverrideRestore = true else OverrideRestore = false end
    self.WidgetObject = plugin:CreateDockWidgetPluginGui(self.Name, DockWidgetPluginGuiInfo.new(DockState, InitiallyEnabled, OverrideRestore, 300, 500, 50, 50))
    self.WidgetObject.Title = title
    self.BackgroundFrame = BackgroundFrame.new(self.WidgetObject)
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
        FixPage.TabFrame.Position = UDim2.new(0,MousePos.X + FixPage.InitialX + self.Menu.ScrollingMenu.CanvasPosition.X, 0,0)
        self.Menu:BeingDragged(FixPage.ID)
        self.Menu:FixPageLayout()
    end)
    InputManager.AddInput(self.InputFrame)
    if not NoPageMenu then self.Menu = PageMenu.new(self.WidgetObject) end
    self.WidgetObject.PluginDragDropped:Connect(function()
        if(GV.SelectedPage and self.Menu) then
            GV.SelectedPage.TabFrame.Parent = self.Menu.TabContainer
            GV.SelectedPage.Content.Parent = self.Menu.ContentContainers
            GV.SelectedPage.PageMenu = self.Menu
            GV.SelectedPage.InsideWidget = true
            GV.SelectedPage.Parent = self.Menu
            self.Menu:AddPage(GV.SelectedPage)
            FixPosition = true
            FixPage = GV.SelectedPage
            self.Menu:SetActive(GV.SelectedPage.ID)
            GV.SelectedPage = nil
        end
    end)
    self.Parent = self.WidgetObject
    self.Content = self.WidgetObject
    return self
end

return Widget