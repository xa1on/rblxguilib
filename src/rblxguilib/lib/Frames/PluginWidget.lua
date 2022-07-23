local GuiService = game:GetService("GuiService")
local Widget = {}
Widget.__index = Widget

local plugin = _G.PluginObject
local util = require(script.Parent.Parent.GUIUtil)
local GUIFrame = require(script.Parent.GUIFrame)
local KeybindManager = require(script.Parent.Parent.KeybindManager)
local BackgroundFrame = require(script.Parent.BackgroundFrame)
setmetatable(Widget,GUIFrame)
_G.InputFrames = {}

Widget.Info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 200, 150, 150)

function Widget.new(name, title)
    local self = GUIFrame.new()
    setmetatable(self, Widget)
    self.Name = name
    title = title or self.Name
    self.WidgetObject = plugin:CreateDockWidgetPluginGui(self.Name, self.Info)
    self.WidgetObject.Title = title
    self.BackgroundFrame = BackgroundFrame.new(self.WidgetObject)
    self.InputFrame = Instance.new("Frame", self.WidgetObject)
    self.InputFrame.BackgroundTransparency = 1
    self.InputFrame.Size = UDim2.new(1,0,1,0)
    self.InputFrame.ZIndex = 100
    self.InputFrame.Name = "InputFrame"
    _G.InputFrames[#_G.InputFrames + 1] = self.InputFrame
    KeybindManager.AddInputFields(self.InputFrame)
    self.Parent = self.WidgetObject
    self.Content = self.WidgetObject
    return self
end

return Widget