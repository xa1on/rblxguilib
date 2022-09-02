local ColorInput = {}
ColorInput.__index = ColorInput

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local GUIObject = require(GV.ObjectsDir.GUIObject)
local InputField = require(GV.ObjectsDir.InputField)
local ColorPrompt = require(GV.PromptsDir.ColorPrompt)
setmetatable(ColorInput,GUIObject)

function ColorInput:SetDisabled(State)
    self.Disabled = State
    self.ColorInput:SetDisabled(State)
    if self.Disabled then
        self.CursorIcon = "rbxasset://SystemCursors/Forbidden"
        self.ColorButton.BackgroundTransparency = 0.5
    else
        self.CursorIcon = "rbxasset://SystemCursors/PointingHand"
        self.ColorButton.BackgroundTransparency = 0
    end
end

function ColorInput:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function ColorInput:SetValue(Value, IgnoreText)
    self.Value = Value
    self.ColorButton.BackgroundColor3 = self.Value
    if not IgnoreText then self.ColorInput.Input.Text = util.Color3ToText(self.Value) end
end

-- Color/Value, Disabled
function ColorInput.new(Arguments, Parent)
    local self = GUIObject.new(Arguments, Parent)
    setmetatable(self,ColorInput)
    self.Disabled = self.Arguments.Disabled
    self.ColorInputContainer = Instance.new("Frame", self.Parent)
    self.ColorInputContainer.BackgroundTransparency = 1
    self.ColorInputContainer.Name = "ColorInputContainer"
    self.ColorInputFrame = Instance.new("Frame", self.ColorInputContainer)
    self.ColorInputFrame.Name = "ColorInputFrame"
    self.ColorInputFrame.AnchorPoint = Vector2.new(0.5,0.5)
    self.ColorInputFrame.BackgroundTransparency = 1
    self.ColorInputFrame.Position = UDim2.new(0.5,0,0.5,0)
    self.ColorInputFrame.Size = UDim2.new(0,130,1,0)
    self.ColorInputLayout = Instance.new("UIListLayout", self.ColorInputFrame)
    self.ColorInputLayout.Padding = UDim.new(0,10)
    self.ColorInputLayout.FillDirection = Enum.FillDirection.Horizontal
    self.ColorInputLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.ColorInputLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    self.ColorButton = Instance.new("TextButton", self.ColorInputFrame)
    self.ColorButton.Name = "ColorButton"
    self.ColorButton.Size = UDim2.new(0,18,0,18)
    util.ColorSync(self.ColorButton, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    self.ColorButton.Text = ""
    self.ColorButton.MouseButton1Click:Connect(function()
        if self.Disabled then return end
        local prompt = ColorPrompt.new({Value = self.Value})
        prompt:Done(function(p)
            self:SetValue(p)
        end)
        prompt:Changed(function(p)
            self:SetValue(p)
        end)
    end)
    self.ColorInput = InputField.new({NoDropdown = true}, self.ColorInputFrame)
    self.ColorInput.Name = "ColorInput"
    self.ColorInput.InputFieldContainer.Size = UDim2.new(0,100,0,20)
    self.ColorInput.InputFieldFrame.Size = UDim2.new(1,0,1,0)
    self.ColorInput.Input.TextXAlignment = Enum.TextXAlignment.Center
    self.ColorInput:Changed(function(p)
        self:SetValue(util.TextToColor3(p), true)
    end)
    self.ColorInput:LostFocus(function(p)
        self:SetValue(util.TextToColor3(p))
        self.ColorInput.Input.TextXAlignment = Enum.TextXAlignment.Center
    end)
    self.ColorInput:GainedFocus(function()
        self.ColorInput.Input.TextXAlignment = Enum.TextXAlignment.Left
    end)
    self.ColorButton.MouseMoved:Connect(function()
        GV.PluginObject:GetMouse().Icon = self.CursorIcon
    end)
    self.ColorButton.MouseLeave:Connect(function()
        task.wait(0)
        GV.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
    end)
    self:SetValue(self.Arguments.Color or self.Arguments.Value or Color3.new(1,1,1))
    self:SetDisabled(self.Disabled)
    self.Object = self.ColorButton
    self.MainMovable = self.ColorInputContainer
    return self
end

return ColorInput