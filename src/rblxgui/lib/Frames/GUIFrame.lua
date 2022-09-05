local GUIFrame = {}
GUIFrame.__index = GUIFrame
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local GUIElement = require(GV.LibraryDir.GUIElement)
setmetatable(GUIFrame,GUIElement)

GV.MainGUI = nil

function GUIFrame.new(Arguments, Parent)
    local self = GUIElement.new(Arguments, Parent or GV.MainGUI)
    setmetatable(self,GUIFrame)
    self.Content = nil
    return self
end

function GUIFrame:SetMain()
    GV.MainGUI = self.Content
end

return GUIFrame