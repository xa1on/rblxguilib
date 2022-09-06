local InputPrompt = {}
InputPrompt.__index = InputPrompt

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local TextPrompt = require(GV.PromptsDir.TextPrompt)
local InputFieldMod = require(GV.ObjectsDir.InputField)

setmetatable(InputPrompt, TextPrompt)

-- Title, Textbox, Buttons, InputField
function InputPrompt.new(Arguments)
    local self = TextPrompt.new(Arguments)
    setmetatable(self,InputPrompt)
    local InputField = self.Arguments.InputField or self.Arguments.Input
    if type(InputField) == "string" then
        self.InputField = InputFieldMod.new({Placeholder = InputField, InputSize = UDim.new(1,-30), NoDropdown = true, Unpausable = true})
    else
        self.InputField = InputField
    end
    self.InputField.Arguments.Unpausable = true
    self.InputField.InputFieldContainer.Size = UDim2.new(1,0,0,25)
    self.InputField.DropdownMaxY = 30
    self.ButtonsFrame.Parent = nil
    self.InputField:Move(self.TextPromptContainer, true)
    self.ButtonsFrame.Parent = self.TextPromptContainer
    self.Input = self.InputField.Input
    return self
end

return InputPrompt