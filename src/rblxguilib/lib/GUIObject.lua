local GUIObject = {}
GUIObject.__index = GUIObject
local GUIElement = require(script.Parent.GUIElement)
setmetatable(GUIObject,GUIElement)

function GUIObject.new(Object)
    local self = GUIElement.new(Object)
    setmetatable(self,GUIObject)
    self.Object = Object
    return self
end

function GUIObject:Move(newparent)

end

return GUIObject