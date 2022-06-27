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
    if not title then title = self.Name end
    self.WidgetObject = plugin:CreateDockWidgetPluginGui(self.Name, self.Info)
    self.WidgetObject.Title = title
    self.BackgroundFrame = BackgroundFrame.new(self.WidgetObject)
    _G.InputFrame = Instance.new("Frame", self.WidgetObject)
    _G.InputFrame.Size = UDim2.new(1,0,1,0)
    _G.InputFrame.ZIndex = 100
    _G.InputFrame.BackgroundTransparency = 1
    return self
end

return Widget