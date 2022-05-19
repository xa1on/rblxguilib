local GUIFrame = {}
GUIFrame.__index = GUIFrame
local GUIElement = require(script.Parent.Parent.GUIElement)
setmetatable(GUIFrame,GUIElement)

_G.MainGUI = nil

function GUIFrame.new(Frame)
    local self = GUIElement.new(Frame)
    setmetatable(self,GUIFrame)
    self.Frame = Frame
    return self
end

function GUIFrame:SetMain()
    _G.MainGUI = self.Frame
end

return GUIFrame