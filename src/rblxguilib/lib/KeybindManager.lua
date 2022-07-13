local InputService = game:GetService("UserInputService")

local m = {}

m.Keybinds = {}

function m.AddKeybind(Name, Keybind)
    m.Keybinds[Name][#m.Keybinds[Name] + 1] = Keybind
end

function m.ClearKeybind(Name)
    m.Keybinds[Name] = {}
end

local function InputBegan(p)

end

local function InputEnded(p)

end

_G.InputFrame.InputBegan:Connect(InputBegan)
InputService.InputBegan:Connect(InputBegan)
_G.InputFrame.InputEnded:Connect(InputEnded)
InputService.InputEnded:Connect(InputEnded)


return m