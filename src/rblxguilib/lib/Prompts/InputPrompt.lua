local InputPrompt = {}
InputPrompt.__index = InputPrompt

local util = require(_G.LibraryDir.GUIUtil)
local TextPrompt = require(_G.PromptsDir.TextPrompt)
local InputFieldMod = require(_G.ObjectsDir.InputField)

setmetatable(InputPrompt, TextPrompt)


function InputPrompt.new(Title, Textbox, Buttons, InputField)
    local self = TextPrompt.new(Title, Textbox, Buttons)
    setmetatable(self,InputPrompt)
    if type(InputField) == "string" then
        self.InputField = InputFieldMod.new(InputField, nil, nil, UDim.new(1,-30), true)
    else
        self.InputField = InputField
    end
    self.InputField.InputFieldContainer.Size = UDim2.new(1,0,0,25)
    self.ButtonsFrame.Parent = nil
    self.InputField:Move(self.TextPromptContainer, true)
    self.ButtonsFrame.Parent = self.TextPromptContainer
    self.Input = self.InputField.Input
    return self
end

return InputPrompt