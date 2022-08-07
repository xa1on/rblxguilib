local InputService = game:GetService("UserInputService")
local util = require(_G.LibraryDir.GUIUtil)
local InputManager = require(_G.ManagersDir.InputManager)
local EventManager = require(_G.ManagersDir.EventManager)

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

function m.UpdateKeybinds(Name, Keybind, Action)
    if not m.Keybinds[Name] then m.Keybinds[Name] = {} end
    if Action then m.Keybinds[Name].Action = Action end
    m.Keybinds[Name].Keybinds = Keybind
end

function m.TableContains(Table, Contains)
    for _, v in pairs(Table) do if v == Contains then return true end end
    return false
end

function m.TableContainsTable(Table, Contains)
    if #Contains < #Table then return false end
    for _, v in pairs(Contains) do
        if not m.TableContains(Table, v) then
            return false
        end
    end
    return true
end

function m.CheckKeybinds(Keys)
    for _, Input in pairs(m.Keybinds) do
        for _, Keybind in pairs(Input.Keybinds) do
            if m.TableContainsTable(Keybind, Keys) then
                if Input.Action then Input.Action() end
                return
            end
        end
    end
end



m.FocusFunction = {}

m.FocusedInputField = {}

function m.FocusInputField(Name, selfobj, EditBind, RemoveBind, Unfocus)
    if m.FocusedInputField.Name and m.FocusedInputField.Name ~= Name then m.Unfocus() end
    m.FocusedInputField = {Name = Name, EditBind = EditBind, RemoveBind = RemoveBind, Unfocus = Unfocus}
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
    if p.UserInputType == Enum.UserInputType.MouseButton1 then m.Unfocus() return end
    if p.UserInputType ~= Enum.UserInputType.Keyboard then return end
    for _, v in pairs(CurrentKeys) do
        if v == p.KeyCode.Name then return end
    end
    local KeyName = m.RecallKeyName(p.KeyCode.Name)
    if KeyName == "Backspace" and m.FocusFunction.RemoveBind then m.FocusFunction.RemoveBind() return end
    if KeyName == "Escape" and m.FocusFunction.Unfocus then m.Unfocus() return end
    CurrentKeys[#CurrentKeys+1] = m.FilterKeyCode(p.KeyCode.Name)
    if CompleteBind then return end
    if KeyName ~= "Ctrl" and KeyName ~= "Alt" and KeyName ~= "Shift" then
        CompleteBind = true
        if m.FocusFunction.EditBind then
            m.FocusFunction.EditBind(util.CopyTable(CurrentKeys), true)
            return
        end
        m.CheckKeybinds(CurrentKeys)
    end
    if m.FocusFunction.EditBind then m.FocusFunction.EditBind(util.CopyTable(CurrentKeys)) end
end

local function InputEnded(p)
    if p.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local KeycodeName = m.FilterKeyCode(p.KeyCode.Name)
    local KeyName = m.RecallKeyName(KeycodeName)
    for i, v in pairs(CurrentKeys) do
        if v == KeycodeName then
            table.remove(CurrentKeys, i)
            if KeyName ~= "Ctrl" and KeyName ~= "Alt" and KeyName ~= "Shift" then
                CompleteBind = false
            end
        end
    end
    if m.FocusFunction.EditBind and not CompleteBind then m.FocusFunction.EditBind(util.CopyTable(CurrentKeys)) end
end


InputManager.AddInputEvent("InputBegan", InputBegan)
InputManager.AddInputEvent("InputEnded", InputEnded)
EventManager.AddConnection(InputService.InputBegan, InputBegan)
EventManager.AddConnection(InputService.InputEnded, InputEnded)

return m