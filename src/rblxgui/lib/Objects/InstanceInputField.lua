local InstanceInputField = {}
InstanceInputField.__index = InstanceInputField

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local InputField = require(GV.ObjectsDir.InputField)
local Selection = game:GetService("Selection")
setmetatable(InstanceInputField,InputField)

function InstanceInputField.new(Arguments, Parent)
    Arguments = Arguments or {}
    Arguments.Placeholder = Arguments.Placeholder or "Select object(s)"
    Arguments.DisableEditing = true
    local self = InputField.new(Arguments, Parent)
    setmetatable(self,InstanceInputField)
    self.IgnoreText = true
    self.DefaultEmpty = {}
    self.Focusable = true
    self.TextEditable = true
    self.Input.Focused:Connect(function()
        if self.Disabled then return end
        local CurrentSelection = Selection:Get()
        if #CurrentSelection > 0 then self:SetValue(CurrentSelection) end
    end)
    Selection.SelectionChanged:Connect(function()
        if self.Disabled then return end
        if self.Input:IsFocused() then
            local CurrentSelection = Selection:Get()
            if #CurrentSelection > 0 then self:SetValue(CurrentSelection) end
        end
    end)
    return self
end

return InstanceInputField