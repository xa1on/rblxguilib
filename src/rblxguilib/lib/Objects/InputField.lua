local InputField = {}
InputField.__index = InputField

local util = require(script.Parent.Parent.Util)
local TextboxMod = require(script.Parent.Textbox)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(InputField,GUIObject)

function InputField:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        self.Textbox.TextTransparency, self.TextInputFrame.BackgroundTransparency, self.Input.TextTransparency = 0.5,0.5,0.5
    else
        self.Textbox.TextTransparency, self.TextInputFrame.BackgroundTransparency, self.Input.TextTransparency = 0,0,0
    end
    self.Input.TextEditable = not State
end

function InputField:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function InputField:Clicked(func)
    self.Button.MouseButton1Click:Connect(function()
        if not self.Disabled then func() end
    end)
end

function InputField.new(Textbox, Placeholder, DefaultText, LabelSize, ClearText, Disabled, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,InputField)
    self.InputFieldFrame = Instance.new("Frame", self.Frame)
    self.InputFieldFrame.BackgroundTransparency = 1
    self.InputFieldLayout = Instance.new("UIListLayout", self.InputFieldFrame)
    self.InputFieldLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.InputFieldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.InputFieldLayout.FillDirection = Enum.FillDirection.Horizontal
    self.InputFieldPadding = Instance.new("UIPadding", self.InputFieldFrame)
    self.InputFieldPadding.PaddingBottom, self.InputFieldPadding.PaddingLeft, self.InputFieldPadding.PaddingRight, self.InputFieldPadding.PaddingTop = UDim.new(0,2), UDim.new(0,4), UDim.new(0,4), UDim.new(0,2)
    if type(Textbox) == "string" then
        self.TextboxTable = TextboxMod.new(Textbox, nil, Enum.TextXAlignment.Left, 14, self.InputFieldFrame)
    else
        self.TextboxTable = Textbox
        Textbox:Move(self.InputFieldFrame, true)
    end
    self.Textbox = self.TextboxTable.Textbox
    self.TextInputFrame = Instance.new("Frame", self.InputFieldFrame)
    util.ColorSync(self.TextInputFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    util.ColorSync(self.TextInputFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    if LabelSize then
        if type(LabelSize) == "userdata" then
            self.Textbox.Size = UDim2.new(LabelSize.Scale, LabelSize.Offset, 0, 20)
            self.TextInputFrame.Size = UDim2.new(1-LabelSize.Scale, -LabelSize.Offset, 0, 20)
        elseif type(LabelSize) == "number" then
            self.Textbox.Size = UDim2.new(LabelSize, 0, 0, 20)
            self.TextInputFrame.Size = UDim2.new(1-LabelSize, 0, 0, 20)
        else
            self.Textbox.Size = UDim2.new(0.5, 0, 0, 20)
            self.TextInputFrame.Size = UDim2.new(0.5, 0, 0, 20)
        end
    else
        local function sync()
            self.Textbox.Size = UDim2.new(0,self.Textbox.TextBounds.X+self.Textbox.TextSize, 1, 0)
            self.TextInputFrame.Size = UDim2.new(1,-(self.Textbox.TextBounds.X+self.Textbox.TextSize), 0, 20)
        end
        self.Textbox.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
        sync()
    end
    self.Input = Instance.new("TextBox", self.TextInputFrame)
    self.Input.BackgroundTransparency = 1
    self.Input.Size = UDim2.new(1,-10,1,0)
    self.Input.Font = Enum.Font.SourceSans
    if not DefaultText then
        DefaultText = ""
    end
    self.Input.Text = DefaultText
    self.Input.TextSize = 14
    if Placeholder then self.Input.PlaceholderText = Placeholder end
    self.Input.TextXAlignment = Enum.TextXAlignment.Left
    self.Input.AnchorPoint = Vector2.new(0.5,0)
    self.Input.Position = UDim2.new(0.5,0,0,0)
    self.Input.ClearTextOnFocus = ClearText
    util.ColorSync(self.Input, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    util.ColorSync(self.Input, "PlaceholderColor3", Enum.StudioStyleGuideColor.DimmedText)
    self.Input.Focused:Connect(function()
        if not self.Disabled then
            util.ColorSync(self.TextInputFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Selected)
        else
            self.Input:ReleaseFocus()
        end
    end)
    self.Input.FocusLost:Connect(function()
        util.ColorSync(self.TextInputFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    end)
    self:SetDisabled(Disabled)
    self.Object = self.Input
    self.MainMovable = self.InputFieldFrame
    self.Frame = self.MainMovable.Parent
    return self
end

return InputField