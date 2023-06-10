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
function KeybindInputField:UpdateBind(Value)
    if not Value then return end
    if #Value[1]>0 and #Value[#Value]>0 then Value[#Value + 1] = {} end
    KeybindManager.UpdateKeybinds(self.ID, Value, self.TriggeredAction)
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
    print(util.DumpTable(BindInfo.Value))
    self:AddItem({Name = BindInfo.Name or KeybindManager.GenerateKeybindList(BindInfo.Value), Value = BindInfo.Value})
end

function KeybindInputField:AddBinds(Binds)
    for _, Bind in pairs(Binds) do
        self:AddBind(Bind)
    end
end

function KeybindInputField:EditKeybind(Keybind, Complete)
    local Value = util.CopyTable(self.Value)
    print(util.DumpTable(Value))
    Value[#Value] = Keybind
    if Complete then
        print("NewBind")
        Value[#Value+1] = {}
    end
    print(util.DumpTable(Value))
    KeybindManager.UpdateKeybinds(self.ID, Value, self.TriggeredAction)
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

function KeybindInputField:Triggered(func)
    function self.TriggeredAction()
        if not self.Disabled then func() end
    end
    KeybindManager.UpdateKeybinds(self.ID, self.Value, self.TriggeredAction)
end

-- Action
function KeybindInputField.new(Arguments, Parent)
    Arguments = Arguments or {}
    KeybindNum += 1
    Arguments.Placeholder = Arguments.Placeholder or "Set Keybind"
    Arguments.DisableEditing = true
    local self = InputField.new(Arguments, Parent)
    setmetatable(self,KeybindInputField)
    self.DefaultEmpty = {{}}
    self.TextEditable = true
    self.ID = KeybindNum
    self:Triggered(self.Arguments.Action)
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
    self.Input.Changed:Connect(function(p)
        if p == "Text" then
            task.wait(0)
            --self:UpdateBind(self.Value)
        end
    end)
    return self
end

return KeybindInputField