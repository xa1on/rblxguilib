local InstanceInputField = {}
InstanceInputField.__index = InstanceInputField

local util = require(script.Parent.Parent.Util)
local InputField = require(script.Parent.InputField)
local Selection = game:GetService("Selection")
setmetatable(InstanceInputField,InputField)
--{{"bob", workspace.bob}, {"bob", {workspace.bob1, workspace.bob2}}, workspace.bob}

function InstanceInputField.GenerateInstanceList(Instances)
    if type(Instances) == "userdata" then Instances = {Instances} end
    local GeneratedList = Instances[1].Name
    for i, v in pairs(Instances) do
        if i ~= 1 then
            GeneratedList = GeneratedList .. ", " .. v.Name
        end
    end
    return GeneratedList
end

function InstanceInputField:SetSelection(Instances, Name)
    if not Instances then return end
    if type(Instances) ~= "table" then Instances = {Instances} end
    self.Selection = Instances
    Name = Name or self.GenerateInstanceList(Instances)
    self.Input.Text = Name
end

function InstanceInputField:RecallItem(Name)
    if self.ItemTable[Name] then
        if type(self.ItemTable[Name]) == "table" then return self.ItemTable[Name]
        else return {self.ItemTable[Name]} end
    elseif #Name <= 0 then
        self.Selection = {}
    end
    return self.Selection
end

function InstanceInputField:StoreItem(Item)
    local GeneratedList = self.GenerateInstanceList(Item)
    self.ItemTable[GeneratedList] = Item
    return {GeneratedList, Item}
end

function InstanceInputField.new(Textbox, Placeholder, DefaultInstances, LabelSize, Items, Disabled, Parent)
    Placeholder = Placeholder or "Select an object"
    local self = InputField.new(Textbox, Placeholder, nil, LabelSize, nil, true, true, Disabled, Parent)
    setmetatable(self,InstanceInputField)
    if Items then self:AddItems(Items) end
    self.Focusable = true
    self:SetSelection(DefaultInstances)
    self.Input.Focused:Connect(function()
        if self.Disabled then return end
        local CurrentSelection = Selection:Get()
        if #CurrentSelection > 0 then self:SetSelection(CurrentSelection) end
    end)
    Selection.SelectionChanged:Connect(function()
        if self.Disabled then return end
        if self.Input:IsFocused() then
            local CurrentSelection = Selection:Get()
            if #CurrentSelection > 0 then self:SetSelection(CurrentSelection) end
        end
    end)
    return self
end

return InstanceInputField