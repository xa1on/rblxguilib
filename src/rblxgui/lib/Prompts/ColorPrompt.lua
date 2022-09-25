local ColorPrompt = {}
ColorPrompt.__index = ColorPrompt

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local Prompt = require(GV.PromptsDir.Prompt)
local InputField = require(GV.ObjectsDir.InputField)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
local Button = require(GV.ObjectsDir.Button)

setmetatable(ColorPrompt, Prompt)

ColorPrompt.Images = {
    PalateIndicator = "http://www.roblox.com/asset/?id=10773265480",
    HueIndicator = "http://www.roblox.com/asset/?id=9666389442"
}

function ColorPrompt:UpdatePreview()
    self.ColorGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1,Color3.fromHSV(self.HSVValue.H,1,1))
    }
    self.ColorPreview.BackgroundColor3 = self.Value
end

function ColorPrompt:SetPalatePos(X,Y)
    self.PalateIndicator.Position = UDim2.fromScale(X,Y)
    self.HSVValue.S = X
    self.HSVValue.V = 1-Y
    self:SetValue(Color3.fromHSV(self.HSVValue.H, self.HSVValue.S, self.HSVValue.V),false,true)
    self:UpdatePreview()
end

function ColorPrompt:SetHuePos(Y)
    self.LeftHueIndicator.Position = UDim2.fromScale(0,Y)
    self.RightHueIndicator.Position = UDim2.fromScale(1,Y)
    self.HSVValue.H = 1-Y
    self:SetValue(Color3.fromHSV(self.HSVValue.H, self.HSVValue.S, self.HSVValue.V),false,true)
    self:UpdatePreview()
end

function ColorPrompt:SetValue(Value, IgnoreText, IgnoreHSV)
    self.Value = Value or self.Value
    local hue, sat, val = self.Value:ToHSV()
    if not IgnoreHSV then
        self.HSVValue = {H = hue, S = sat, V = val}
    end
    self.PalateIndicator.Position = UDim2.fromScale(self.HSVValue.S, 1-self.HSVValue.V)
    self.LeftHueIndicator.Position = UDim2.fromScale(0,1-self.HSVValue.H)
    self.RightHueIndicator.Position = UDim2.fromScale(1,1-self.HSVValue.H)
    if not IgnoreText then
        self.RGBInput.Input.Text = util.Color3ToText(self.Value)
        self.HexInput.Input.Text = "#"..self.Value:ToHex()
    end
    if self.ChangedAction then self.ChangedAction(self.Value) end
    self:UpdatePreview()
end

function ColorPrompt:Changed(func)
    self.ChangedAction = func
end

function ColorPrompt:Done(func)
    self.DoneAction = func
end

-- Color/Value
function ColorPrompt.new(Arguments)
    Arguments.Title = "Pick a Color"
    Arguments.Width = 430
    Arguments.Height = 315
    local self = Prompt.new(Arguments)
    setmetatable(self,ColorPrompt)
    self.ColorComponents = Instance.new("Frame", self.Parent)
    self.ColorComponents.Name = "ColorComponents"
    self.ColorComponents.BackgroundTransparency = 1
    self.ColorComponents.Position = UDim2.fromOffset(15,30)
    self.ColorComponents.Size = UDim2.fromOffset(285,255)
    self.ColorPalate = Instance.new("Frame", self.ColorComponents)
    self.ColorPalate.Name = "ColorPalate"
    self.ColorPalate.Size = UDim2.fromOffset(255,255)
    self.ColorPalate.BackgroundTransparency = 1
    self.ColorGraidentFrame = Instance.new("Frame", self.ColorComponents)
    self.ColorGraidentFrame.Size = UDim2.fromOffset(255,255)
    self.ColorGraidentFrame.BackgroundColor3 = Color3.new(1,1,1)
    self.ColorGraidentFrame.BorderSizePixel = 0
    self.ColorGradient = Instance.new("UIGradient", self.ColorGraidentFrame)
    self.LightnessGradientFrame = Instance.new("Frame", self.ColorComponents)
    self.LightnessGradientFrame.Size = UDim2.fromOffset(255,255)
    self.LightnessGradientFrame.BackgroundColor3 = Color3.new(1,1,1)
    self.LightnessGradientFrame.BackgroundTransparency = 0
    self.LightnessGradientFrame.BorderSizePixel = 0
    self.LightnessGradient = Instance.new("UIGradient", self.LightnessGradientFrame)
    self.LightnessGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0)),
        ColorSequenceKeypoint.new(1, Color3.new(0)),
    })
    self.LightnessGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    self.LightnessGradient.Rotation = -90
    self.PalateIndicator = Instance.new("ImageLabel", self.ColorPalate)
    self.PalateIndicator.Name = "PalateIndicator"
    self.PalateIndicator.Image = self.Images.PalateIndicator
    self.PalateIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
    self.PalateIndicator.BackgroundTransparency = 1
    self.PalateIndicator.Size = UDim2.fromOffset(15,15)
    self.PalateIndicator.ZIndex = 2
    local MouseDownPalate = false
    self.ColorPalate.InputBegan:Connect(function(p)
        if p.UserInputType == Enum.UserInputType.MouseButton1 then
            self:SetPalatePos((p.Position.X-self.ColorPalate.AbsolutePosition.X)/self.ColorPalate.AbsoluteSize.X, (p.Position.Y-self.ColorPalate.AbsolutePosition.Y)/self.ColorPalate.AbsoluteSize.Y)
            MouseDownPalate = true
        end
    end)
    self.ColorPalate.InputEnded:Connect(function(p)
        if p.UserInputType == Enum.UserInputType.MouseButton1 then
            MouseDownPalate = false
        end
    end)
    self.HueGradientFrame = Instance.new("Frame", self.ColorComponents)
    self.HueGradientFrame.Name = "HueGradient"
    self.HueGradientFrame.AnchorPoint = Vector2.new(1, 0)
    self.HueGradientFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.HueGradientFrame.BorderSizePixel = 0
    self.HueGradientFrame.Position = UDim2.fromScale(1, 0)
    self.HueGradientFrame.Size = UDim2.new(0, 20, 1, 0)

    self.HueGradient = Instance.new("UIGradient", self.HueGradientFrame)
    self.HueGradient.Name = "UIGradient"
    self.HueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1/3, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(2/3, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    })
    self.HueGradient.Rotation = 90

    self.LeftHueIndicator = Instance.new("ImageLabel", self.HueGradientFrame)
    self.LeftHueIndicator.Name = "LeftIndicator"
    self.LeftHueIndicator.Image = self.Images.HueIndicator
    ThemeManager.ColorSync(self.LeftHueIndicator, "ImageColor3", Enum.StudioStyleGuideColor.MainText)
    self.LeftHueIndicator.AnchorPoint = Vector2.new(1, 0.5)
    self.LeftHueIndicator.BackgroundTransparency = 1
    self.LeftHueIndicator.Rotation = -90
    self.LeftHueIndicator.Size = UDim2.fromOffset(10, 10)

    self.RightHueIndicator = Instance.new("ImageLabel", self.HueGradientFrame)
    self.RightHueIndicator.Name = "RightIndicator"
    self.RightHueIndicator.Image = self.Images.HueIndicator
    ThemeManager.ColorSync(self.RightHueIndicator, "ImageColor3", Enum.StudioStyleGuideColor.MainText)
    self.RightHueIndicator.AnchorPoint = Vector2.new(0, 0.5)
    self.RightHueIndicator.BackgroundTransparency = 1
    self.RightHueIndicator.Rotation = 90
    self.RightHueIndicator.Size = UDim2.fromOffset(10, 10)

    local MouseDownHueGradient = false
    self.HueGradientFrame.InputBegan:Connect(function(p)
        if p.UserInputType == Enum.UserInputType.MouseButton1 then
            self:SetHuePos(math.clamp((p.Position.Y-self.HueGradientFrame.AbsolutePosition.Y)/self.HueGradientFrame.AbsoluteSize.Y,0,1))
            MouseDownHueGradient = true
        end
    end)
    self.HueGradientFrame.InputEnded:Connect(function(p)
        if p.UserInputType == Enum.UserInputType.MouseButton1 then
            MouseDownHueGradient = false
        end
    end)

    self.Parent.MouseMoved:Connect(function(x,y)
        if MouseDownPalate then
            self:SetPalatePos(math.clamp((x-self.ColorPalate.AbsolutePosition.X)/self.ColorPalate.AbsoluteSize.X, 0, 1), math.clamp((y-self.ColorPalate.AbsolutePosition.Y)/self.ColorPalate.AbsoluteSize.Y, 0, 1))
        elseif MouseDownHueGradient then
            self:SetHuePos(math.clamp((y-self.HueGradientFrame.AbsolutePosition.Y)/self.HueGradientFrame.AbsoluteSize.Y, 0, 1))
        end
    end)

    self.ColorPickerOptions = Instance.new("Frame", self.Parent)
    self.ColorPickerOptions.Name = "Color PIcker Options"
    self.ColorPickerOptions.BackgroundTransparency = 1
    self.ColorPickerOptions.Position = UDim2.fromOffset(315, 30)
    self.ColorPickerOptions.Size = UDim2.fromOffset(100, 250)

    self.ColorPreview = Instance.new("Frame", self.ColorPickerOptions)
    self.ColorPreview.Name = "ColorPreview"
    self.ColorPreview.AnchorPoint = Vector2.new(0.5, 0.5)
    ThemeManager.ColorSync(self.ColorPreview, "BorderColor3", Enum.StudioStyleGuideColor.Border)
    self.ColorPreview.Position = UDim2.fromOffset(50, 42)
    self.ColorPreview.Size = UDim2.fromOffset(75, 75)

    self.RGBInput = InputField.new({NoDropdown = true, ClearBackground = true, Unpausable = true}, self.ColorPickerOptions)
    self.RGBInput.Name = "RGBInput"
    self.RGBInput.InputFieldContainer.AnchorPoint = Vector2.new(0.5,0.5)
    self.RGBInput.InputFieldContainer.Position = UDim2.fromOffset(50,97)
    self.RGBInput.InputFieldContainer.Size = UDim2.new(0,100,0,20)
    self.RGBInput.InputFieldFrame.Size = UDim2.new(1,0,1,0)
    self.RGBInput.Input.TextXAlignment = Enum.TextXAlignment.Center
    self.RGBInput:Changed(function(p)
        self:SetValue(util.TextToColor3(p), true)
    end)
    self.RGBInput:LostFocus(function(p)
        self:SetValue(util.TextToColor3(p))
        self.RGBInput.Input.TextXAlignment = Enum.TextXAlignment.Center
    end)
    self.RGBInput:GainedFocus(function()
        self.RGBInput.Input.TextXAlignment = Enum.TextXAlignment.Left
        ThemeManager.ColorSync(self.RGBInput.InputFieldFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    end)

    self.HexInput = InputField.new({NoDropdown = true, ClearBackground = true, Unpausable = true}, self.ColorPickerOptions)
    self.HexInput.Name = "HexInput"
    self.HexInput.InputFieldContainer.AnchorPoint = Vector2.new(0.5,0.5)
    self.HexInput.InputFieldContainer.Position = UDim2.fromOffset(50,122)
    self.HexInput.InputFieldContainer.Size = UDim2.new(0,100,0,20)
    self.HexInput.InputFieldFrame.Size = UDim2.new(1,0,1,0)
    self.HexInput.Input.TextXAlignment = Enum.TextXAlignment.Center
    self.HexInput:Changed(function(p)
        local newhex = string.match(p:gsub('#',''), "^%x%x%x%x%x%x$")
        if newhex then self:SetValue(Color3.fromHex(newhex), true) end
    end)
    self.HexInput:LostFocus(function(p)
        local newhex = string.match(p:gsub('#',''), "^%x%x%x%x%x%x$")
        if newhex then self:SetValue(Color3.fromHex(newhex))
        else self:SetValue() end
        self.HexInput.Input.TextXAlignment = Enum.TextXAlignment.Center
    end)
    self.HexInput:GainedFocus(function()
        self.HexInput.Input.TextXAlignment = Enum.TextXAlignment.Left
    end)

    self.OKButton = Button.new({Text = "OK", ButtonSize = 1, Unpausable = true}, self.ColorPickerOptions)
    self.OKButton.ButtonFrame.AnchorPoint = Vector2.new(0.5,0.5)
    self.OKButton.ButtonFrame.Size = UDim2.fromOffset(100,25)
    self.OKButton.ButtonFrame.Position = UDim2.fromOffset(50,210)

    self.OKButton:Clicked(function()
        self:Destroy()
        if self.DoneAction then self.DoneAction(self.Value) end
    end)

    self.CancelButton = Button.new({Text = "Cancel", ButtonSize = 1, Unpausable = true}, self.ColorPickerOptions)
    self.CancelButton.ButtonFrame.AnchorPoint = Vector2.new(0.5,0.5)
    self.CancelButton.ButtonFrame.Size = UDim2.fromOffset(100,25)
    self.CancelButton.ButtonFrame.Position = UDim2.fromOffset(50,235)

    self.CancelButton:Clicked(function()
        self:Destroy()
        if self.DoneAction then self.DoneAction(self.OriginalValue) end
    end)
    self:OnWindowClose(function()
        self:Destroy()
        if self.DoneAction then self.DoneAction(self.OriginalValue) end
    end)

    self:SetValue(self.Arguments.Value or self.Arguments.Color or Color3.new(1,1,1))
    self.OriginalValue = self.Value
    return self
end

return ColorPrompt