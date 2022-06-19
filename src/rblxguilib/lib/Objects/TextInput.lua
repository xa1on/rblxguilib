local TextInput = {}
TextInput.__index = TextInput

local util = require(script.Parent.Parent.Util)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(TextInput,GUIObject)

function TextInput.new(Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,TextInput)
    self.Object = nil
    self.Frame = nil
    return self
end

return TextInput