local GUIElement = {}
GUIElement.__index = GUIElement

local GV = require(script.Parent.PluginGlobalVariables)

function GUIElement.new(Parent)
    local self = {}
    setmetatable(self,GUIElement)
    self.Parent = Parent
    return self
end

return GUIElement