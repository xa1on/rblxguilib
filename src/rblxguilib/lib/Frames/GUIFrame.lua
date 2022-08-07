local GUIFrame = {}
GUIFrame.__index = GUIFrame
local GUIElement = require(_G.LibraryDir.GUIElement)
setmetatable(GUIFrame,GUIElement)

_G.MainGUI = nil

function GUIFrame.new(Parent)
    local self = GUIElement.new(Parent)
    setmetatable(self,GUIFrame)
    self.Content = nil
    Parent = Parent or _G.MainGUI
    self.Parent = Parent
    return self
end

function GUIFrame:SetMain()
    _G.MainGUI = self.Content
end

return GUIFrame