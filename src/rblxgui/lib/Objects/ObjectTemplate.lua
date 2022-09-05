local temp = {}
temp.__index = temp

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local GUIObject = require(GV.ObjectsDir.GUIObject)
setmetatable(temp,GUIObject)

function temp.new(Arguments, Parent)
    local self = GUIObject.new(Arguments, Parent)
    setmetatable(self,temp)
    self.Object = nil
    self.MainMovable = nil
    return self
end

return temp