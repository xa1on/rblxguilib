local Button = {}
Button.__index = Button

local util = require(script.Parent.Parent.GUIUtil)
local TextboxMod = require(script.Parent.Textbox)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(Button,GUIObject)

Button.Images = {
    border = "http://www.roblox.com/asset/?id=10460485555",
    bg = "http://www.roblox.com/asset/?id=10460051857"
}

function Button:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        self.CursorIcon = "rbxasset://SystemCursors/Forbidden"
        self.Button.ImageTransparency, self.Textbox.TextTransparency = 0.5, 0.5
    else
        self.CursorIcon = "rbxasset://SystemCursors/PointingHand"
        self.Button.ImageTransparency, self.Textbox.TextTransparency = 0, 0
    end
end

function Button:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function Button:Clicked(func)
    self.Button.MouseButton1Click:Connect(function()
        if not self.Disabled then func() end
    end)
end

function Button.new(Textbox, Size, Disabled, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,Button)
    self.TextboxTable = nil
    -- creating a frame to hold the button
    self.ButtonFrame = Instance.new("Frame", self.Parent)
    self.ButtonFrame.BackgroundTransparency = 1
    self.ButtonFrame.Name = "ButtonFrame"
    self.ButtonFrame.Size = UDim2.new(1,0,1,0)
    -- set up a textbox for the button
    self.Button = Instance.new("ImageButton", self.ButtonFrame)

    self.ButtonBackground = Instance.new("ImageLabel", self.Button)
    self.ButtonBackground.Name = "ButtonBackground"
    self.ButtonBackground.BackgroundTransparency = 1
    self.ButtonBackground.Size = UDim2.new(1,0,1,0)
    self.ButtonBackground.Image = self.Images.bg
    util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    self.ButtonBackground.ScaleType = Enum.ScaleType.Slice
    self.ButtonBackground.SliceCenter = Rect.new(7,7,156,36)

    if type(Textbox) == "string" then
        self.TextboxTable = TextboxMod.new(Textbox, nil, nil, nil, self.Button)
    else
        self.TextboxTable = Textbox
        Textbox:Move(self.Button, true)
    end
    self.Textbox = self.TextboxTable.Textbox
    self.Textbox.ZIndex = 1
    Size = util.GetScale(Size)
    if Size then self.Button.Size = UDim2.new(Size.Scale,Size.Offset,1,0)
    else
        local function sync()
            self.Button.Size = UDim2.new(0,self.Textbox.TextBounds.X+2*self.Textbox.TextSize, 1, 0)
        end
        self.Textbox.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
        sync()
    end
    self.Button.Position = UDim2.new(0.5, 0, 0, 0)
    self.Button.AnchorPoint = Vector2.new(0.5,0)
    self.Button.BackgroundTransparency = 1
    self.Button.Image = self.Images.border
    util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    self.Button.ScaleType = Enum.ScaleType.Slice
    self.Button.SliceCenter = Rect.new(7,7,156,36)
    self.Button.Name = "Button"
    self.Button.ZIndex = 0

    self.Button.MouseMoved:Connect(function()
        _G.PluginObject:GetMouse().Icon = self.CursorIcon
        if self.Disabled then return end
        util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Selected)
    end)
    self.Button.MouseLeave:Connect(function()
        task.wait(0)
        _G.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
        if self.Disabled then return end
        util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
        util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    end)

    
    self.Button.MouseButton1Down:Connect(function()
        if self.Disabled then return end
        util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Selected)
    end)
    self.Button.MouseButton1Up:Connect(function()
        if self.Disabled then return end
        util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    end)

    self:SetDisabled(Disabled)
    self.Object = self.Button
    self.MainMovable = self.ButtonFrame
    return self
end

return Button