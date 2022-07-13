local KeybindInputField = {}
KeybindInputField.__index = KeybindInputField

local util = require(script.Parent.Parent.Util)
local InputField = require(script.Parent.InputField)
local InputService = game:GetService("UserInputService")
setmetatable(KeybindInputField,InputField)

--[[
    How to make keybinds in code
    Always use Left if its control alt or shift
    ex:
    {{LeftControl, LeftAlt, Zero},{P}}
    {{"Keybind Preset",{{LeftControl, LeftAlt, Zero},{P}}}}
]]--
KeybindInputField.Keys = {
    LeftControl = "Ctrl",
    LeftAlt = "Alt",
    LeftShift = "Shift",
    QuotedDouble = '"',
    Hash = "#",
    Dollar = "$",
    Percent = "%",
    Ampersand = "&",
    Quote = "'",
    LeftParenthesis = "(",
    RightParenthesis = ")",
    Asterisk = "*",
    Plus = "+",
    Comma = ",",
    Minus = "-",
    Period = ".",
    Slash = "/",
    Zero = "0",
    One = "1",
    Two = "2",
    Three = "3",
    Four = "4",
    Five = "5",
    Six = "6",
    Seven = "7",
    Eight = "8",
    Nine = "9",
    Colon = ":",
    Semicolon = ";",
    LessThan = "<",
    Equals = "=",
    GreaterThan = ">",
    Question = "?",
    At = "@",
    LeftBracket = "[",
    BackSlash = "\\",
    RightBracket = "]",
    Caret = "^",
    Underscore = "_",
    Backquote = "`",
    LeftCurly = "{",
    Pipe = "|",
    RightCurly = "}",
    Tilde = "~",
    Delete = "Del",
    Up = "↑",
    Down = "↓",
    Right = "→",
    Left = "←",
    PageUp = "PgUp",
    PageDown = "PgDown",
    Euro = "€",
}

function KeybindInputField.RecallKeyName(KeycodeName)
    if KeycodeName == "RightControl" then KeycodeName = "LeftControl"
    elseif KeycodeName == "RightAlt" then KeycodeName = "LeftAlt"
    elseif KeycodeName == "RightShift" then KeycodeName = "LeftShift" end
    KeycodeName = KeycodeName:gsub("Keypad", "")
    if KeybindInputField.Keys[KeycodeName] then
        return KeybindInputField.Keys[KeycodeName]
    end
    return KeycodeName
end

function KeybindInputField.GenerateGeneratedName(Keybind)
    if type(Keybind) == "string" then Keybind = {Keybind} end
    if #Keybind < 1 then return "" end
    local GeneratedName = KeybindInputField.RecallKeyName(Keybind[1])
    for i, v in pairs(Keybind) do
        if i ~= 1 then
            GeneratedName = GeneratedName .. "+" .. KeybindInputField.RecallKeyName(v)
        end
    end
    return GeneratedName
end

function KeybindInputField.GenerateKeybindList(Keybinds)
    if type(Keybinds) == "string" then Keybinds = {{Keybinds}} end
    if #Keybinds < 1 then return "" end
    local GeneratedList = KeybindInputField.GenerateGeneratedName(Keybinds[1])
    for i, v in pairs(Keybinds) do
        if i ~= 1 and #v > 0 then
            GeneratedList = GeneratedList .. ", " .. KeybindInputField.GenerateGeneratedName(v)
        end
    end
    return GeneratedList
end

function KeybindInputField:SetKeybinds(Keybinds, Name)
    Keybinds = Keybinds or {{}}
    if type(Keybinds) ~= "table" then Keybinds = {{Keybinds}}
    else
        if not Keybinds[1] or type(Keybinds[1]) ~= "table" then Keybinds = {Keybinds} end
    end
    self.Bind = Keybinds
    if #Keybinds[1]>0 then self.Bind[#self.Bind + 1] = {} end
    Name = Name or self.GenerateKeybindList(Keybinds)
    self.Input.Text = Name
end

function KeybindInputField:RecallItem(Name)
    if self.ItemTable[Name] then
        if type(self.ItemTable[Name]) == "table" then return self.ItemTable[Name]
        else return {self.ItemTable[Name]} end
    elseif #Name <= 0 then
        self.Bind = {{}}
    end
    return self.Bind
end

function KeybindInputField:StoreItem(Item)
    local GeneratedList = self.GenerateKeybindList(Item)
    self.ItemTable[GeneratedList] = Item
    return {GeneratedList, Item}
end

function KeybindInputField.new(Textbox, Action, Placeholder, DefaultKeybind, LabelSize, Keybinds, Disabled, Parent)
    Placeholder = Placeholder or "Set Keybind"
    local self = InputField.new(Textbox, Placeholder, nil, LabelSize, nil, true, false, Disabled, Parent)
    setmetatable(self,KeybindInputField)
    self.Focusable = true
    if Keybinds then self:AddItems(Keybinds) end
    self:SetKeybinds(DefaultKeybind)
    self.InputFocused = false
    self.Input.Focused:Connect(function()
        self.InputFocused = true
        util.ColorSync(self.SecondaryFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Selected)
    end)
    local function Unfocus()
        self.InputFocused = false
        util.ColorSync(self.SecondaryFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    end

    self.Input.InputBegan:Connect(function(p)
        print(p)
    end)

    local function InputBegan(p)
        --if not self.InputFocused then return end
        if p.UserInputType == Enum.UserInputType.MouseButton1 and not self.MouseInInput then
            Unfocus()
            return
        end
        if p.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if p.KeyCode.Name == "Return" then
            Unfocus()
            return
        elseif p.KeyCode.Name == "Backspace" then
            table.remove(self.Bind, #self.Bind - 1)
            return
        end
        for _, v in pairs(self.Bind[#self.Bind]) do
            if v == p.KeyCode.Name then return end
        end
        self.Bind[#self.Bind][#self.Bind[#self.Bind]+1] = p.KeyCode.Name
        if self.RecallKeyName(p.KeyCode.Name) ~= "Ctrl" and self.RecallKeyName(p.KeyCode.Name) ~= "Alt" and self.RecallKeyName(p.KeyCode.Name) ~= "Shift" then
            self.Bind[#self.Bind + 1] = {}
        end
        self.Input.Text = self.GenerateKeybindList(self.Bind)
    end
    local function InputEnded(p)
        if not self.InputFocused then return end
        if p.UserInputType ~= Enum.UserInputType.Keyboard then return end
        for i, v in pairs(self.Bind[#self.Bind]) do
            if p.KeyCode.Name == v then
                table.remove(self.Bind[#self.Bind], i)
            end
        end
        self.Input.Text = self.GenerateKeybindList(self.Bind)
    end

    _G.InputFrame.InputBegan:Connect(InputBegan)
    InputService.InputBegan:Connect(InputBegan)
    _G.InputFrame.InputEnded:Connect(InputEnded)
    InputService.InputEnded:Connect(InputEnded)
    self.Input.Changed:Connect(function(p)
        if p =="Text" then
            if #self.Input.Text <= 0 then self.Bind = {{}} end
        end
    end)
    return self
end

return KeybindInputField