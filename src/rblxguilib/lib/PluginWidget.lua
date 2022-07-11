local Widget = {}
Widget.__index = Widget

local plugin = _G.PluginObject
local util = require(script.Parent.Util)
local BackgroundFrame = require(script.Parent.Frames.BackgroundFrame)

Widget.Info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 200, 150, 150)

function Widget.new(name, title)
    local self = {}
    setmetatable(self, Widget)
    self.Name = name
    title = title or self.Name
    self.WidgetObject = plugin:CreateDockWidgetPluginGui(self.Name, self.Info)
    self.WidgetObject.Title = title
    self.BackgroundFrame = BackgroundFrame.new(self.WidgetObject)
    self.InputFrame = Instance.new("Frame", self.WidgetObject)
    self.InputFrame.Size = UDim2.new(1,0,1,0)
    self.InputFrame.ZIndex = 100
    self.InputFrame.BackgroundTransparency = 1
    self.InputFrame.Name = "InputFrame"
    _G.InputFrame = self.InputFrame
    return self
end

return Widget