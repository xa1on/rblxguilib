local GUIFrame = {}
GUIFrame.__index = GUIFrame
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local GUIElement = require(GV.LibraryDir.GUIElement)
setmetatable(GUIFrame,GUIElement)

GV.MainGUI = nil

function GUIFrame.new(Parent)
    local self = GUIElement.new(Parent)
    setmetatable(self,GUIFrame)
    self.Content = nil
    Parent = Parent or GV.MainGUI
    self.Parent = Parent
    return self
end

function GUIFrame:SetMain()
    GV.MainGUI = self.Content
end

return GUIFrame