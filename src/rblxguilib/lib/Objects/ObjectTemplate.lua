local temp = {}
temp.__index = temp

local util = require(_G.LibraryDir.GUIUtil)
local GUIObject = require(_G.ObjectsDir.GUIObject)
setmetatable(temp,GUIObject)

function temp.new(Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,temp)
    self.Object = nil
    self.MainMovable = nil
    return self
end

return temp