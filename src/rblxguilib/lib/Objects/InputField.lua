local InputField = {}
InputField.__index = InputField

local util = require(script.Parent.Parent.Util)
local TextboxMod = require(script.Parent.Textbox)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(InputField,GUIObject)

function InputField.new(Textbox, Placeholder, DefaultText, LabelSize, Disabled, Parent)
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
    self.TextInputFrame.BorderSizePixel = 1
    util.ColorSync(self.TextInputFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    util.ColorSync(self.TextInputFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    if LabelSize then
        if type(LabelSize) == "userdata" then
            self.Textbox.Size = UDim2.new(LabelSize.Scale, LabelSize.Offset, 0, 20)
            self.TextInputFrame.Size = UDim2.new(1-LabelSize.Scale, -LabelSize.Offset, 0, 20)
        else
            self.Textbox.Size = UDim2.new(LabelSize, 0, 0, 20)
            self.TextInputFrame.Size = UDim2.new(1-LabelSize, 0, 0, 20)
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
    self.Input = 
    self.Object = self.Input
    self.MainMovable = self.InputFieldFrame
    self.Frame = self.MainMovable.Parent
    return self
end

return InputField