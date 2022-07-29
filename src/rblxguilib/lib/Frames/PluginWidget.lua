local GuiService = game:GetService("GuiService")
local Widget = {}
Widget.__index = Widget

local plugin = _G.PluginObject
local util = require(script.Parent.Parent.GUIUtil)
local GUIFrame = require(script.Parent.GUIFrame)
local PageMenu = require(script.Parent.PageMenu)
local BackgroundFrame = require(script.Parent.BackgroundFrame)
setmetatable(Widget,GUIFrame)
_G.InputFrames = {}

function Widget.new(name, title, IncludePageMenu, DockState, InitiallyEnabled, OverrideRestore)
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
    util.AddInputFrame(self.InputFrame)
    if IncludePageMenu then self.Menu = PageMenu.new(self.WidgetObject) end
    self.WidgetObject.PluginDragDropped:Connect(function()
        if(_G.SelectedPage and self.Menu) then
            _G.SelectedPage.TabFrame.Parent = self.Menu.TabContainer
            _G.SelectedPage.Content.Parent = self.Menu.ContentContainers
            _G.SelectedPage.PageMenu = self.Menu
            _G.SelectedPage.InsideWidget = true
            self.Menu:AddPage(_G.SelectedPage)
            self.Menu:SetActive(_G.SelectedPage.ID)
            _G.SelectedPage = nil
        end
    end)
    self.Parent = self.WidgetObject
    self.Content = self.WidgetObject
    return self
end

return Widget