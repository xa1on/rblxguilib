local KeybindInputField = {}
KeybindInputField.__index = KeybindInputField

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local KeybindManager = require(GV.ManagersDir.KeybindManager)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
local InputField = require(GV.ObjectsDir.InputField)
local KeybindNum = 0
setmetatable(KeybindInputField,InputField)

--[[
    How to make keybinds in code
    Always use Left if its control alt or shift
    ex:
    {{LeftControl, LeftAlt, Zero},{P}}
    {{"Keybind Preset",{{LeftControl, LeftAlt, Zero},{P}}}}
]]--

function KeybindInputField:UpdateValues(Value)
    Value = Value or self.Value
    KeybindManager.UpdateKeybinds(self.ID, {Keybinds = Value, Holdable = self.Holdable, PressedAction = self.PressedAction, ReleasedAction = self.ReleasedAction})
end

function KeybindInputField:UpdateBind(Value)
    if not Value then return end
    if #Value[1]>0 and #Value[#Value]>0 then Value[#Value + 1] = {} end
    self:UpdateValues(Value)
end

function KeybindInputField:SetBind(Bind)
    Bind = Bind or {Value = {{}}}
    local BindInfo = self.GetItemInfo(Bind)
    local Value = BindInfo.Value
    self:UpdateBind(Value)
    self:SetValue({Name = BindInfo.Name or KeybindManager.GenerateKeybindList(Value), ["Value"] = Value})
end

function KeybindInputField:AddBind(Bind)
    local BindInfo = self.GetItemInfo(Bind)
    if #BindInfo.Value[1]>0 and #BindInfo.Value[#BindInfo.Value]>0 then BindInfo.Value[#BindInfo.Value+1] = {} end
    self:AddItem({Name = BindInfo.Name or KeybindManager.GenerateKeybindList(BindInfo.Value), Value = BindInfo.Value}, function() self:UpdateBind(BindInfo.Value) end)
end

function KeybindInputField:AddBinds(Binds)
    for _, Bind in pairs(Binds) do
        self:AddBind(Bind)
    end
end

function KeybindInputField:EditKeybind(Keybind, Complete)
    local Value = util.CopyTable(self.Value)
    Value[#Value] = Keybind
    if Complete then
        Value[#Value+1] = {}
    end
    self:UpdateValues(Value)
    self:SetValue({Name = KeybindManager.GenerateKeybindList(Value), ["Value"] = Value})
end

function KeybindInputField:RemoveKeybind(Index)
    local Value = util.CopyTable(self.Value)
    Index = Index or #Value - 1
    table.remove(Value, Index)
    self:SetValue({Name = KeybindManager.GenerateKeybindList(Value), ["Value"] = Value})
end

function KeybindInputField:UnfocusInputField(ForceUnfocus)
    if not ForceUnfocus and self.MouseInInput then return false
    else
        ThemeManager.ColorSync(self.InputFieldFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
        self.Focused = false
    end
    return true
end

function KeybindInputField:Pressed(func)
    function self.PressedAction()
        if not self.Disabled and func then func() end
    end
    self:UpdateValues()
end

function KeybindInputField:Released(func)
    function self.ReleasedAction()
        if not self.Disabled and func then func() end
    end
    self:UpdateValues()
end

-- PressedAction, ReleasedAction, Holdable, Unrestricted, Bind/CurrentBind, Items/Binds
function KeybindInputField.new(Arguments, Parent)
    Arguments = Arguments or {}
    KeybindNum += 1
    Arguments.Placeholder = Arguments.Placeholder or "Set Keybind"
    Arguments.DisableEditing = true
    local self = InputField.new(Arguments, Parent)
    setmetatable(self,KeybindInputField)
    self.IgnoreText = true
    self.Holdable = self.Arguments.Holdable
    self.Unrestricted = self.Arguments.Unrestricted
    if not self.Holdable then self.Holdable = false end
    if not self.Unrestricted then self.Unrestricted = false end
    self.DefaultEmpty = {{}}
    self.TextEditable = true
    self.ID = KeybindNum
    self:Pressed(self.Arguments.PressedAction)
    self:Released(self.Arguments.ReleasedAction)
    self.Value = {{}}
    self.Arguments.Binds = self.Arguments.Items or self.Arguments.Binds
    self.Input.Focused:Connect(function()
        if self.Disabled then return end
        self.Focused = true
        ThemeManager.ColorSync(self.InputFieldFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Selected, true)
        task.wait()
        KeybindManager.FocusInputField(self.ID, self, self.EditKeybind, self.RemoveKeybind, self.UnfocusInputField)
    end)
    if self.Arguments.Binds then self:AddBinds(self.Arguments.Binds) end
    self:SetBind(self.Arguments.Bind or self.Arguments.CurrentBind)
    return self
end

return KeybindInputField