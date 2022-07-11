local InstanceInputField = {}
InstanceInputField.__index = InstanceInputField

local util = require(script.Parent.Parent.Util)
local InputField = require(script.Parent.InputField)
local Selection = game:GetService("Selection")
setmetatable(InstanceInputField,InputField)

function InstanceInputField.GenerateName(Instances)
    local GeneratedName = Instances[1].Name
    for i, v in pairs(Instances) do
        if i ~= 1 then
            GeneratedName = GeneratedName .. ", " .. v.Name
        end
    end
    return GeneratedName
end

function InstanceInputField:SetSelection(Instances)
    self.Selection = Instances
    self.Input.Text = self.GenerateName(Instances)
end

function InstanceInputField:RecallItem(Name)
    if self.ItemTable[Name] then
        if type(self.ItemTable[Name]) == "table" then return self.ItemTable[Name]
        else return {self.ItemTable[Name]} end
    elseif #Name <= 0 then
        self.Selection = nil
    end
    return self.Selection
end

function InstanceInputField.new(Textbox, Placeholder, DefaultInstances, LabelSize, Items, Disabled, Parent)
    Placeholder = Placeholder or "Select an object"
    local self = InputField.new(Textbox, Placeholder, nil, LabelSize, Items, true, Disabled, Parent)
    setmetatable(self,InstanceInputField)
    self.TextEditable = false
    self.Input.TextEditable = false
    if DefaultInstances then self:SetSelection(DefaultInstances) end
    self.Input.Focused:Connect(function()
        local CurrentSelection = Selection:Get()
        if #CurrentSelection > 0 then self:SetSelection(CurrentSelection) end
    end)
    Selection.SelectionChanged:Connect(function()
        if self.Input:IsFocused() then
            local CurrentSelection = Selection:Get()
            if #CurrentSelection > 0 then self:SetSelection(CurrentSelection) end
        end
    end)
    return self
end

return InstanceInputField