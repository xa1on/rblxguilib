local Widget = {}

local plugin = _G.PluginObject
local util = require(script.Parent.Util)
Widget.__index = Widget
Widget.Info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 200, 150, 150)

function Widget.new(name, title)
    local self = {}
    setmetatable(self, Widget)
    self.Name = name
    if not title then title = self.Name end
    self.WidgetObj = plugin:CreateDockWidgetPluginGui(self.Name, self.Info)
    self.WidgetObj.Title = title

    -- generate background frame
    self.BGFrame = Instance.new("Frame", self.WidgetObj)
    util.ColorSync(self.BGFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.MainBackground)
    self.BGFrame.Size = UDim2.new(1,0,1,0)
    self.BGFrame.Name = "Background"
    self.BGFrame.ZIndex = 0

    return self
end

return Widget