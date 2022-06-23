local InputField = {}
InputField.__index = InputField

local util = require(script.Parent.Parent.Util)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(InputField,GUIObject)

function InputField.new(Label, Placeholder, DefaultText, LabelScale, Disabled, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,InputField)
    
    self.Object = nil
    self.Frame = nil
    return self
end

return InputField