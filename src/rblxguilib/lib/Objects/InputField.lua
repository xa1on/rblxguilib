local InputField = {}
InputField.__index = InputField

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local GUIObject = require(GV.ObjectsDir.GUIObject)
local ScrollingFrame = require(GV.FramesDir.ScrollingFrame)
local KeybindManager = require(GV.ManagersDir.KeybindManager)
local InputManager = require(GV.ManagersDir.InputManager)
setmetatable(InputField,GUIObject)

local RightClickMenu = GV.PluginObject:CreatePluginMenu(math.random(), "RightClickMenu - InputField")
RightClickMenu.Name = "InputField Right-Click Menu"
RightClickMenu:AddNewAction("Edit", "Edit")
RightClickMenu:AddNewAction("Clear", "Clear Input")


InputField.Images = {
    Down = "http://www.roblox.com/asset/?id=10027472547"
}

function InputField:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        if self.DropdownOpen then self:SetDropdown(false) end
        self.InputFieldFrame.BackgroundTransparency, self.Input.TextTransparency, self.DropdownButton.BackgroundTransparency = 0.5,0.5,0.5
    else
        self.InputFieldFrame.BackgroundTransparency, self.Input.TextTransparency, self.DropdownButton.BackgroundTransparency = 0,0,0
    end
    if self.TextboxEditable then
        self.Input.TextEditable = not State
    end
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
        self.Parent.ZIndex = 2
        self.InputFieldFrame.ZIndex = 3
        self.Input.ZIndex = 4
    else
        self.Parent.ZIndex = 0
        self.InputFieldFrame.ZIndex = 0
        self.Input.ZIndex = 0
    end
    if self.DropdownAction then self.DropdownAction(State) end
end

function InputField:RecallItem(Name)
    if self.ItemTable[Name] then return self.ItemTable[Name]
    else return Name end
end

function InputField:StoreItem(Item)
    if type(Item) == "table" then
        self.ItemTable[Item[1]] = Item[2]
        return Item
    end
    return {Item, Item}
end

function InputField:AddItem(Item)
    local StoredItem = self:StoreItem(Item)
    local ItemButton = Instance.new("TextButton", self.DropdownScroll.Content)
    ItemButton.Name = StoredItem[1]
    ItemButton.Size = UDim2.new(1,0,0,18)
    ItemButton.BorderSizePixel = 0
    util.ColorSync(ItemButton, "BackgroundColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    ItemButton.Text = ""
    local ItemLabel = Instance.new("TextLabel", ItemButton)
    ItemLabel.BackgroundTransparency = 1
    util.ColorSync(ItemLabel, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    ItemLabel.Font = Enum.Font.SourceSans
    ItemLabel.TextSize = 14
    ItemLabel.Text = StoredItem[1]
    ItemLabel.AnchorPoint = Vector2.new(0.5,0.5)
    ItemLabel.Position = UDim2.new(0.5,0,0.5,0)
    ItemLabel.Size = UDim2.new(1,-8,0,14)
    ItemButton.ZIndex = 2
    ItemLabel.ZIndex = 2
    ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
    util.HoverIcon(ItemButton)
    self.DropdownButton.MouseButton1Click:Connect(function() if not self.Disabled then ItemButton.Visible = true end end)
    self.Input.Changed:Connect(function(p)
        if p == "Text" and self.Filtering then
            if self.Input.Text == "" or string.sub(StoredItem[1], 1, string.len(self.Input.Text)) == self.Input.Text then
                ItemButton.Visible = true
            else
                ItemButton.Visible = false
            end
        end
    end)
    ItemButton.MouseButton1Click:Connect(function()
        if self.Disabled then return end
        self:SetDropdown(false)
        self.Input.Text = StoredItem[1]
    end)
    ItemButton.MouseEnter:Connect(function()
        task.wait(0)
        if self.Disabled then return end
        if self.ItemEnterAction then self.ItemEnterAction(StoredItem[2]) end
    end)
    ItemButton.MouseLeave:Connect(function()
        if self.Disabled then return end
        if self.ItemLeaveAction then self.ItemLeaveAction(StoredItem[2]) end
    end)
end

function InputField:AddItems(Items)
    for _, v in pairs(Items) do self:AddItem(v) end
end

function InputField:RemoveItem(Item)
    local Target = self.DropdownScroll.Content:FindFirstChild(Item)
    if Target then
        Target:Destroy()
        if self.ItemTable[Item] then self.ItemTable[Item] = nil end
    end
end

function InputField:RemoveItems(Items)
    for _, v in pairs(Items) do self:RemoveItem(v) end
end

function InputField:SetValue(Value, Name)
    local StoredItem = Value
    if Name then StoredItem = {Name, Value} end
    local StoredValue = self:StoreItem(StoredItem)
    self.Input.Text = StoredValue[1]
end

function InputField:Changed(func)
    self.Action = func
end

function InputField:MouseEnterItem(func)
    self.ItemEnterAction = func
end

function InputField:MouseLeaveItem(func)
    self.ItemLeaveAction = func
end

function InputField:DropdownToggled(func)
    self.DropdownAction = func
end

-- Placeholder, Value, Items, Size, NoDropdown, NoFiltering, DisableEditing, ClearText, Disabled
function InputField.new(Arguments, Parent)
    local self = GUIObject.new(Arguments, Parent)
    setmetatable(self,InputField)
    self.ItemTable = {}
    self.Action = nil
    self.Filtering = not self.Arguments.NoFiltering
    self.InputFieldContainer = Instance.new("Frame", self.Parent)
    self.InputFieldContainer.BackgroundTransparency = 1
    self.InputFieldContainer.Name = "InputFieldContainer"
    self.InputFieldFrame = Instance.new("Frame", self.InputFieldContainer)
    self.InputFieldFrame.BackgroundTransparency = 1
    local Size = util.GetScale(self.Arguments.Size) or UDim.new(1,-12)
    self.InputFieldFrame.Size = UDim2.new(Size.Scale,Size.Offset,0,20)
    self.InputFieldFrame.Position = UDim2.new(0.5,0,0.5,0)
    self.InputFieldFrame.AnchorPoint = Vector2.new(0.5,0.5)
    self.InputFieldFrame.Name = "InputFieldFrame"
    util.ColorSync(self.InputFieldFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    util.ColorSync(self.InputFieldFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    self.Input = Instance.new("TextBox", self.InputFieldFrame)
    self.Input.TextTruncate = Enum.TextTruncate.AtEnd
    self.Input.BackgroundTransparency = 1
    if self.Arguments.NoDropdown then self.Input.Size = UDim2.new(1,-10,1,0) else self.Input.Size = UDim2.new(1,-30,1,0) end
    self.Input.Font = Enum.Font.SourceSans
    if not self.Arguments.IgnoreItems then
        local Value = self.Arguments.Value or ""
        if type(Value) == "string" or type(Value) == "number" then
            self:SetValue(Value)
        elseif type(Value) == "table" then
            self:SetValue(Value[2], Value[1])
        end
    end
    self.Value = self:RecallItem(self.Input.Text)
    self.Input.TextSize = 14
    if self.Arguments.Placeholder then self.Input.PlaceholderText = self.Arguments.Placeholder end
    self.Input.TextXAlignment = Enum.TextXAlignment.Left
    self.Input.Position = UDim2.new(0,5,0,0)
    self.Input.ClearTextOnFocus = self.Arguments.ClearText
    self.Input.Name = "Input"
    self.Input.Changed:Connect(function(p)
        if p == "Text" then
            local RecalledItem = self:RecallItem(self.Input.Text)
            if self.RecallItem then
                self.Value = RecalledItem
                if self.Action then self.Action(RecalledItem) end
            end
        end
    end)
    self.Focusable = true
    self.TextEditable = true
    if self.Arguments.DisableEditing then
        self.Input.TextEditable = false
        self.TextboxEditable = false
        self.Focusable = false
        self.TextEditable = false
    end
    util.ColorSync(self.Input, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    util.ColorSync(self.Input, "PlaceholderColor3", Enum.StudioStyleGuideColor.DimmedText)
    self.MouseInInput = false
    self.InputFieldFrame.MouseMoved:Connect(function()
        self.MouseInInput = true
        if not self.Disabled and not self.Input:IsFocused() and not self.Focused then
            util.ColorSync(self.InputFieldFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Hover)
        elseif self.Focusable then
            GV.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Forbidden"
        end
    end)
    self.InputFieldFrame.MouseLeave:Connect(function()
        self.MouseInInput = false
        if not self.Disabled and not self.Input:IsFocused() and not self.Focused then
            util.ColorSync(self.InputFieldFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
        end
        GV.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
    end)
    self.Input.Focused:Connect(function()
        KeybindManager.Unfocus()
        if not self.Disabled and self.Focusable then
            util.ColorSync(self.InputFieldFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Selected)
        else
            self.Input:ReleaseFocus()
        end
    end)
    self.Input.FocusLost:Connect(function()
        if self.Focusable then
            util.ColorSync(self.InputFieldFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
        end
    end)
    self.DropdownButton = Instance.new("TextButton", self.InputFieldFrame)
    if self.Arguments.NoDropdown then self.DropdownButton.Visible = false end
    self.DropdownButton.Text = ""
    util.ColorSync(self.DropdownButton, "BackgroundColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    self.DropdownButton.BorderSizePixel = 0
    self.DropdownButton.Size = UDim2.new(0, 20, 0, 20)
    self.DropdownButton.AnchorPoint = Vector2.new(1,0)
    self.DropdownButton.Position = UDim2.new(1, 0, 0, 0)
    self.DropdownButton.Name = "DropdownButton"
    util.HoverIcon(self.DropdownButton)
    self.DropdownButton.MouseButton1Click:Connect(function() if not self.Disabled then self:ToggleDropdown() end end)
    self.MouseInDropdownButton = false
    self.DropdownButton.MouseEnter:Connect(function() self.MouseInDropdownButton = true end)
    self.DropdownButton.MouseLeave:Connect(function() self.MouseInDropdownButton = false end)
    self.DropdownImage = Instance.new("ImageLabel", self.DropdownButton)
    self.DropdownImage.Name = "Dropdown Image"
    self.DropdownImage.AnchorPoint = Vector2.new(0.5,0.5)
    self.DropdownImage.BackgroundTransparency = 1
    self.DropdownImage.Position = UDim2.new(0.5,0,0.5,0)
    self.DropdownImage.Size = UDim2.new(0,4.5,0,4.5)
    self.DropdownImage.Image = self.Images.Down
    self.DropdownFrame = Instance.new("Frame", self.InputFieldFrame)
    self.DropdownFrame.Size = UDim2.new(1,0,0,0)
    self.DropdownFrame.Position = UDim2.new(0,0,1,0)
    util.ColorSync(self.DropdownFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    util.ColorSync(self.DropdownFrame, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    self.DropdownFrame.Visible = false
    self.DropdownFrame.Name = "DropdownFrame"
    self.MouseInDropdownMenu = false
    self.DropdownFrame.MouseEnter:Connect(function() self.MouseInDropdownMenu = true end)
    self.DropdownFrame.MouseLeave:Connect(function() self.MouseInDropdownMenu = false end)
    self.DropdownFrame.ZIndex = 2
    self.DropdownScroll = ScrollingFrame.new({BarSize = 10}, self.DropdownFrame)
    self:SetDropdown(false)
    self.DropdownMaxY = 100
    local function syncframe()
        if self.DropdownScroll.Layout.AbsoluteContentSize.Y > self.DropdownMaxY then
            self.DropdownFrame.Size = UDim2.new(1,0,0,self.DropdownMaxY)
            return
        end
        self.DropdownFrame.Size = UDim2.new(1,0,0,self.DropdownScroll.Layout.AbsoluteContentSize.Y)
    end
    self.DropdownScroll.Layout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then syncframe() end
    end)
    syncframe()
    InputManager.AddInputEvent("InputBegan", function(p)
        task.wait(0)
        if self.DropdownOpen and p.UserInputType == Enum.UserInputType.MouseButton1 and not self.MouseInDropdownMenu and not self.MouseInDropdownButton then
            self:SetDropdown(false)
        end
        if self.TextEditable and p.UserInputType == Enum.UserInputType.MouseButton2 and self.MouseInInput then
            local Response = RightClickMenu:ShowAsync()
            if Response then 
                if Response.Text == "Clear Input" then self.Input.Text = ""
                elseif Response.Text == "Edit" then self.Input:CaptureFocus() end
            end
        end
    end)
    if self.Arguments.Items and not self.Arguments.IgnoreItems then self:AddItems(self.Arguments.Items) end
    self:SetDisabled(self.Arguments.Disabled)
    self.Object = self.Input
    self.MainMovable = self.InputFieldContainer
    return self
end

return InputField