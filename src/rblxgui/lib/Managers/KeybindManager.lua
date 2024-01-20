local InputService = game:GetService("UserInputService")
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local InputManager = require(GV.ManagersDir.InputManager)
local EventManager = require(GV.ManagersDir.EventManager)

local m = {}

m.Keys = {
    LeftControl = "Ctrl", LeftAlt = "Alt", LeftShift = "Shift", QuotedDouble = '"', Hash = "#", Dollar = "$" , Percent = "%", Ampersand = "&", Quote = "'", LeftParenthesis = "(", RightParenthesis = ")", Asterisk = "*",Plus = "+", Comma = ",", Minus = "-", Period = ".", Slash = "/", Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Colon = ":", Semicolon = ";", LessThan = "<", Equals = "=", GreaterThan = ">", Question = "?", At = "@", LeftBracket = "[", BackSlash = "\\", RightBracket = "]", Caret = "^", Underscore = "_", Backquote = "`", LeftCurly = "{", Pipe = "|", RightCurly = "}", Tilde = "~", Delete = "Del", Up = "↑", Down = "↓", Right = "→", Left = "←", PageUp = "PgUp", PageDown = "PgDown", Euro = "€"
}

function m.FilterKeyCode(KeycodeName)
    if KeycodeName == "RightControl" then KeycodeName = "LeftControl"
    elseif KeycodeName == "RightAlt" then KeycodeName = "LeftAlt"
    elseif KeycodeName == "RightShift" then KeycodeName = "LeftShift" end
    return KeycodeName
end

function m.RecallKeyName(KeycodeName)
    KeycodeName = m.FilterKeyCode(KeycodeName)
    KeycodeName = KeycodeName:gsub("Keypad", "")
    if m.Keys[KeycodeName] then
        return m.Keys[KeycodeName]
    end
    return KeycodeName
end

function m.GenerateKeybindName(Keybind)
    if type(Keybind) == "string" then Keybind = {Keybind} end
    if #Keybind < 1 then return "" end
    local GeneratedName = m.RecallKeyName(Keybind[1])
    for i, v in pairs(Keybind) do
        if i ~= 1 then
            GeneratedName = GeneratedName .. "+" .. m.RecallKeyName(v)
        end
    end
    return GeneratedName
end

function m.GenerateKeybindList(Keybinds)
    if type(Keybinds) == "string" then Keybinds = {{Keybinds}} end
    if #Keybinds < 1 then return "" end
    local GeneratedList = m.GenerateKeybindName(Keybinds[1])
    for i, v in pairs(Keybinds) do
        if i ~= 1 and #v > 0 then
            GeneratedList = GeneratedList .. ", " .. m.GenerateKeybindName(v)
        end
    end
    return GeneratedList
end



m.Keybinds = {}
m.ActiveKeybinds = {}

function m.UpdateKeybinds(Name, Args)
    m.Keybinds[Name] = Args
end

function m.TableContains(Table, Contains)
    for _, v in pairs(Table) do if v == Contains then return true end end
    return false
end

function m.TableContainsTable(Table1, Table2)
    if #Table1 < #Table2 or #Table2 < 1 then return false end
    for _, v in pairs(Table2) do
        if not m.TableContains(Table1, v) then
            return false
        end
    end
    return true
end

function m.CheckKeybinds(Keys, Holdable, KeycodeName)
    local ContainsKeybind = false
    for _, Input in pairs(m.Keybinds) do
        ContainsKeybind = false
        for _, Keybind in pairs(Input.Keybinds) do
            if not Holdable and not Input.Holdable then
                if #Keys > 0 and #Keys == #Keybind and m.TableContainsTable(Keys, Keybind) then
                    ContainsKeybind = true
                    break
                end
            end
            if Holdable and Input.Holdable and m.TableContainsTable(Keys, Keybind) and KeycodeName and m.TableContains(Keybind, KeycodeName) then
                ContainsKeybind = true
            end
        end
        if not ContainsKeybind then continue end
        m.ActiveKeybinds[#m.ActiveKeybinds+1] = Input
        if Input.PressedAction then Input.PressedAction() end
    end
end

function m.CheckActive(KeycodeName)
    local IndexShift = 0
    local ContainsRemoved = false
    for Index, Input in pairs(m.ActiveKeybinds) do
        if Input.Holdable and KeycodeName then
            ContainsRemoved = false
            for _, Keybind in pairs(Input.Keybinds) do
                if m.TableContains(Keybind, KeycodeName) then
                    ContainsRemoved = true
                    break
                end
            end
            if not ContainsRemoved then
                continue
            end
        end
        if Input.ReleasedAction then Input.ReleasedAction() end
        table.remove(m.ActiveKeybinds, Index - IndexShift)
        IndexShift += 1
    end

end


m.FocusFunction = {}
m.FocusedInputField = {}

function m.FocusInputField(Name, selfobj, EditBind, RemoveBind, Unfocus)
    if m.FocusedInputField.Name and m.FocusedInputField.Name ~= Name then m.Unfocus() end
    m.FocusedInputField = {Name = Name, Unrestricted = selfobj.Unrestricted, EditBind = EditBind, RemoveBind = RemoveBind, Unfocus = Unfocus}
    for i, v in pairs(m.FocusedInputField) do
        if type(v) == "function" then
            m.FocusFunction[i] = function(...)
                return v(selfobj, ...)
            end
        end
    end
end

function m.Unfocus(ForceClose)
    if m.FocusFunction.Unfocus and m.FocusFunction.Unfocus(ForceClose) then
        m.FocusFunction = {}
    end
end


--Keys being pressed down
local CurrentKeys = {}
local CompleteBind = false

local function InputBegan(p)
    if p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.MouseButton2 then m.Unfocus() return end
    if p.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local KeycodeName = m.FilterKeyCode(p.KeyCode.Name)
    local KeyName = m.RecallKeyName(p.KeyCode.Name)
    for _, v in pairs(CurrentKeys) do
        if v == KeycodeName then return end
    end
    m.CheckActive(KeycodeName)
    if KeyName == "Backspace" and m.FocusFunction.RemoveBind then m.FocusFunction.RemoveBind() return end
    if KeyName == "Escape" and m.FocusFunction.Unfocus then m.Unfocus() return end
    CurrentKeys[#CurrentKeys+1] = KeycodeName
    m.CheckKeybinds(CurrentKeys, true, KeycodeName)
    if not m.FocusFunction.EditBind or not m.FocusedInputField.Unrestricted then
        if CompleteBind then return end
        if KeyName ~= "Ctrl" and KeyName ~= "Alt" and KeyName ~= "Shift" then
            CompleteBind = true
            if m.FocusFunction.EditBind then
                m.FocusFunction.EditBind(util.CopyTable(CurrentKeys), true)
                return
            end
        end
    end
    m.CheckKeybinds(CurrentKeys)
    if m.FocusFunction.EditBind then m.FocusFunction.EditBind(util.CopyTable(CurrentKeys), false) end
end

local function InputEnded(p)
    if p.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local KeycodeName = m.FilterKeyCode(p.KeyCode.Name)
    local KeyName = m.RecallKeyName(KeycodeName)
    local IndexShift = 0;
    m.CheckActive(KeycodeName)
    for i, v in pairs(CurrentKeys) do
        if v == KeycodeName then
            if not m.FocusedInputField.Unrestricted then
                if KeyName ~= "Ctrl" and KeyName ~= "Alt" and KeyName ~= "Shift" then
                    CompleteBind = false
                end
            elseif (not CompleteBind) or #CurrentKeys ~= 1 then
                if m.FocusFunction.EditBind and not CompleteBind then m.FocusFunction.EditBind(util.CopyTable(CurrentKeys), true)end
                CompleteBind = true
                table.remove(CurrentKeys, i - IndexShift)
                if #CurrentKeys == 0 then CompleteBind = false end
                return
            else
                CompleteBind = false
            end
            table.remove(CurrentKeys, i - IndexShift)
            IndexShift += 1
        end
    end
    if m.FocusFunction.EditBind and not CompleteBind then m.FocusFunction.EditBind(util.CopyTable(CurrentKeys), false) end
end


InputManager.AddInputEvent("InputBegan", InputBegan)
InputManager.AddInputEvent("InputEnded", InputEnded)
InputManager.AddInputEvent("MouseLeave", m.Unfocus)
EventManager.AddConnection(InputService.InputBegan, InputBegan)
EventManager.AddConnection(InputService.InputEnded, InputEnded)

return m