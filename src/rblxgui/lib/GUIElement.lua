local GUIElement = {}
GUIElement.__index = GUIElement

local GV = require(script.Parent.PluginGlobalVariables)

function GUIElement.new(Arguments, Parent)
    local self = {}
    setmetatable(self,GUIElement)
    self.Arguments = Arguments or {}
    self.Parent = Parent
    return self
end

return GUIElement