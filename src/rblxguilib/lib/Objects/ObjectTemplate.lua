local temp = {}
temp.__index = temp

local util = require(script.Parent.Parent.Util)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(temp,GUIObject)

function temp.new(Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,temp)
    self.Object = nil
    self.Frame = nil
    return self
end

return temp