local GUIFrame = {}
GUIFrame.__index = GUIFrame
local GUIElement = require(script.Parent.Parent.GUIElement)
setmetatable(GUIFrame,GUIElement)

_G.MainGUI = nil

function GUIFrame.new(Parent)
    local self = GUIElement.new()
    setmetatable(self,GUIFrame)
    self.Frame = nil
    self.Parent = Parent
    if not Parent then self.Parent = _G.MainGUI end
    return self
end

function GUIFrame:SetMain()
    _G.MainGUI = self.Frame
end

return GUIFrame