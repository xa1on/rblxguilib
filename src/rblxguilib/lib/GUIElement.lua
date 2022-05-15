local GUIElement = {}
GUIElement.__index = GUIElement

function GUIElement.new(Element)
    local self = {}
    setmetatable(self,GUIElement)
    self.Element = Element
    return self
end

return GUIElement