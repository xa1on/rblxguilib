local Widget = {}
Widget.__index = Widget

local plugin = _G.PluginObject
local util = require(script.Parent.Util)
local BackgroundFrame = require(script.Parent.BackgroundFrame)

Widget.Info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 200, 150, 150)

function Widget.new(name, title)
    local self = {}
    setmetatable(self, Widget)
    self.Name = name
    if not title then title = self.Name end
    self.WidgetObject = plugin:CreateDockWidgetPluginGui(self.Name, self.Info)
    self.WidgetObject.Title = title
    self.BackgroundFrame = BackgroundFrame.new(self.WidgetObject)
    return self
end

return Widget