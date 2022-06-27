local InputField = {}
InputField.__index = InputField

local util = require(script.Parent.Parent.Util)
local TextboxMod = require(script.Parent.Textbox)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(InputField,GUIObject)

InputField.Images = {
    Down = "http://www.roblox.com/asset/?id=10027472547"
}

function InputField:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        self:SetDropdown(false)
        self.Textbox.TextTransparency, self.TextInputFrame.BackgroundTransparency, self.Input.TextTransparency, self.DropdownButton.BackgroundTransparency = 0.5,0.5,0.5,0.5
    else
        self.Textbox.TextTransparency, self.TextInputFrame.BackgroundTransparency, self.Input.TextTransparency, self.DropdownButton.BackgroundTransparency = 0,0,0,0
    end
    self.Input.TextEditable = not State
end

function InputField:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function InputField:ToggleDropdown()
    self:SetDropdown(not self.DropdownOpen)
end

function InputField:SetDropdown(State)
    self.DropdownOpen = State
    self.DropdownFrame.Visible = State
    if State then
        self.Frame.ZIndex = 2
        self.DropdownFrame.ZIndex = 2
    else
        self.Frame.ZIndex = 0
        self.DropdownFrame.ZIndex = 2
    end
end

function InputField:AddItem(Item)
    local ItemButton = Instance.new("TextButton", self.DropdownFrame)
    ItemButton.Name = Item
    ItemButton.Size = UDim2.new(1,0,0,18)
    ItemButton.BorderSizePixel = 0
    util.ColorSync(ItemButton, "BackgroundColor3", Enum.StudioStyleGuideColor.MainBackground)
    ItemButton.Text = ""
    local ItemLabel = Instance.new("TextLabel", ItemButton)
    ItemLabel.BackgroundTransparency = 1
    util.ColorSync(ItemLabel, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    ItemLabel.Font = Enum.Font.SourceSans
    ItemLabel.TextSize = 14
    ItemLabel.Text = Item
    ItemLabel.AnchorPoint = Vector2.new(0.5,0.5)
    ItemLabel.Position = UDim2.new(0.5,0,0.5,0)
    ItemLabel.Size = UDim2.new(1,-8,0,14)
    ItemButton.ZIndex = 2
    ItemLabel.ZIndex = 2
    ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
    ItemButton.MouseButton1Click:Connect(function()
        self:SetDropdown(false)
        self.Input.Text = Item
    end)
end

function InputField:AddItems(Items)
    for _, v in pairs(Items) do
        self:AddItem(v)
    end
end

function InputField:RemoveItem(Item)
    local Target = self.DropdownFrame:FindFirstChild(Item)
    if Target then Target:Destroy() end
end

function InputField:RemoveItems(Items)
    for _, v in pairs(Items) do
        self:RemoveItem(v)
    end
end

function InputField:Changed(func)
    self.Input.Changed:Connect(function(p)
        if p =="Text" then func() end
    end)
end

function InputField.new(Textbox, Placeholder, DefaultText, LabelSize, Items, ClearText, Disabled, Parent)
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
    self.Input.Size = UDim2.new(1,-30,1,0)
    self.Input.Font = Enum.Font.SourceSans
    if not DefaultText then
        DefaultText = ""
    end
    self.Input.Text = DefaultText
    self.Input.TextSize = 14
    if Placeholder then self.Input.PlaceholderText = Placeholder end
    self.Input.TextXAlignment = Enum.TextXAlignment.Left
    self.Input.Position = UDim2.new(0,5,0,0)
    self.Input.ClearTextOnFocus = ClearText
    util.ColorSync(self.Input, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    util.ColorSync(self.Input, "PlaceholderColor3", Enum.StudioStyleGuideColor.DimmedText)
    self.TextInputFrame.MouseEnter:Connect(function()
        if not self.Disabled and not self.Input:IsFocused() then
            util.ColorSync(self.TextInputFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Hover)
        end
    end)
    self.TextInputFrame.MouseLeave:Connect(function()
        if not self.Disabled and not self.Input:IsFocused() then
            util.ColorSync(self.TextInputFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
        end
    end)
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
    self.DropdownButton = Instance.new("TextButton", self.TextInputFrame)
    self.DropdownButton.Text = ""
    util.ColorSync(self.DropdownButton, "BackgroundColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    self.DropdownButton.BorderSizePixel = 0
    self.DropdownButton.Size = UDim2.new(0, 20, 0, 20)
    self.DropdownButton.AnchorPoint = Vector2.new(1,0)
    self.DropdownButton.Position = UDim2.new(1, 0, 0, 0)
    self.DropdownButton.MouseButton1Click:Connect(function() self:ToggleDropdown() end)
    local MouseInsideButton = false
    self.DropdownButton.MouseEnter:Connect(function() MouseInsideButton = true end)
    self.DropdownButton.MouseLeave:Connect(function() MouseInsideButton = false end)
    self.DropdownImage = Instance.new("ImageLabel", self.DropdownButton)
    self.DropdownImage.AnchorPoint = Vector2.new(0.5,0.5)
    self.DropdownImage.BackgroundTransparency = 1
    self.DropdownImage.Position = UDim2.new(0.5,0,0.5,0)
    self.DropdownImage.Size = UDim2.new(0,5,0,5)
    self.DropdownImage.Image = self.Images.Down
    self.DropdownFrame = Instance.new("Frame", self.TextInputFrame)
    self.DropdownFrame.Size = UDim2.new(1,0,0,0)
    self.DropdownFrame.Position = UDim2.new(0,0,1,0)
    util.ColorSync(self.DropdownFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.MainBackground)
    util.ColorSync(self.DropdownFrame, "BorderColor3", Enum.StudioStyleGuideColor.Border)
    self.DropdownFrame.Visible = false
    local MouseInsideDropdown = false
    self.DropdownFrame.MouseEnter:Connect(function() MouseInsideDropdown = true end)
    self.DropdownFrame.MouseLeave:Connect(function() MouseInsideDropdown = false end)
    self.DropdownLayout = Instance.new("UIListLayout", self.DropdownFrame)
    self.DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self:SetDropdown(false)
    local function syncframe()
        self.DropdownFrame.Size = UDim2.new(1,0,0,self.DropdownLayout.AbsoluteContentSize.Y)
    end
    self.DropdownLayout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then syncframe() end
    end)
    syncframe()
    _G.InputFrame.InputBegan:Connect(function(p)
        task.wait(0)
        if self.DropdownOpen and p.UserInputType == Enum.UserInputType.MouseButton1 and not MouseInsideDropdown and not MouseInsideButton then
            self:SetDropdown(false)
        end
    end)
    if Items then self:AddItems(Items) end
    self:SetDisabled(Disabled)
    self.Object = self.Input
    self.MainMovable = self.InputFieldFrame
    self.Frame = self.MainMovable.Parent
    return self
end

return InputField