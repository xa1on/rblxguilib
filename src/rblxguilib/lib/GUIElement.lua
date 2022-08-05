local GUIElement = {}
GUIElement.__index = GUIElement

function GUIElement.new(Parent)
    local self = {}
    setmetatable(self,GUIElement)
    self.Parent = Parent
    return self
end

return GUIElement