local GUIElement = {}
GUIElement.__index = GUIElement

function GUIElement.new()
    local self = {}
    setmetatable(self,GUIElement)
    return self
end

return GUIElement