local KeybindInputField = {}
KeybindInputField.__index = KeybindInputField

local util = require(script.Parent.Parent.GUIUtil)
local KeybindManager = require(script.Parent.Parent.KeybindManager)
local InputField = require(script.Parent.InputField)
local GuiService = game:GetService("GuiService")
local InputService = game:GetService("UserInputService")
local KeybindNum = 0
setmetatable(KeybindInputField,InputField)

--[[
    How to make keybinds in code
    Always use Left if its control alt or shift
    ex:
    {{LeftControl, LeftAlt, Zero},{P}}
    {{"Keybind Preset",{{LeftControl, LeftAlt, Zero},{P}}}}
]]--

function KeybindInputField:SetKeybinds(Keybinds, Name)
    Keybinds = Keybinds or {{}}
    if type(Keybinds) ~= "table" then Keybinds = {{Keybinds}}
    else
        if not Keybinds[1] or type(Keybinds[1]) ~= "table" then Keybinds = {Keybinds} end
    end
    self.Binds = Keybinds
    if #Keybinds[1]>0 then self.Binds[#self.Binds + 1] = {} end
    Name = Name or KeybindManager.GenerateKeybindList(self.Binds)
    KeybindManager.UpdateKeybinds(self.ID, self.Binds, self.TriggeredAction)
    self.Input.Text = Name
end

function KeybindInputField:EditKeybind(Keybind, Complete)
    self.Binds[#self.Binds] = Keybind
    if Complete then
        self.Binds[#self.Binds+1] = {}
    end
    local GeneratedList = KeybindManager.GenerateKeybindList(self.Binds)
    KeybindManager.UpdateKeybinds(self.ID, self.Binds, self.TriggeredAction)
    self.Input.Text = GeneratedList
end

function KeybindInputField:RemoveKeybind(Index)
    Index = Index or #self.Binds - 1
    table.remove(self.Binds, Index)
    local GeneratedList = KeybindManager.GenerateKeybindList(self.Binds)
    self.Input.Text = GeneratedList
end

function KeybindInputField:RecallItem(Name)
    if self.ItemTable[Name] then
        self:SetKeybinds(self.ItemTable[Name])
        return self.ItemTable[Name]
    elseif #Name <= 0 then
        self:SetKeybinds({{}})
    end
    return self.Binds
end

function KeybindInputField:UnfocusInputField(ForceUnfocus)
    if not ForceUnfocus and self.MouseInInput then return false
    else
        util.ColorSync(self.InputFieldFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
        self.Focused = false
    end
    return true
end

function KeybindInputField:StoreItem(Item)
    local GeneratedList = KeybindManager.GenerateKeybindList(Item)
    local StoredItem = Item
    if type(Item) ~= "table" then
        StoredItem = {Item}
    end
    self.ItemTable[GeneratedList] = StoredItem
    return {GeneratedList, Item}
end

function KeybindInputField:Triggered(func)
    function self.TriggeredAction()
        if not self.Disabled then func() end
    end
    KeybindManager.UpdateKeybinds(self.ID, self.Binds, self.TriggeredAction)
end

function KeybindInputField.new(Action, Placeholder, DefaultKeybind, Keybinds, Disabled, Parent)
    KeybindNum += 1
    Placeholder = Placeholder or "Set Keybind"
    local self = InputField.new(Placeholder, nil, nil, true, false, Disabled, Parent)
    setmetatable(self,KeybindInputField)
    self.ID = KeybindNum
    self:Triggered(Action)
    self.Binds = {{}}
    if Keybinds then self:AddItems(Keybinds) end
    self:SetKeybinds(DefaultKeybind)
    self.Input.Focused:Connect(function()
        if self.Disabled then return end
        self.Focused = true
        util.ColorSync(self.InputFieldFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Selected)
        KeybindManager.FocusInputField(self.ID, self, self.EditKeybind, self.RemoveKeybind, self.UnfocusInputField)
    end)
    return self
end

return KeybindInputField