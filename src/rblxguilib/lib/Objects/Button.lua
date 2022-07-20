local Button = {}
Button.__index = Button

local util = require(script.Parent.Parent.GUIUtil)
local TextboxMod = require(script.Parent.Textbox)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(Button,GUIObject)

Button.Images = {
    default = "http://www.roblox.com/asset/?id=9631146921",
    hover = "http://www.roblox.com/asset/?id=9622825658",
    pressed = "http://www.roblox.com/asset/?id=9538564172",
    bg = "http://www.roblox.com/asset/?id=9666283489"
}

function Button:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        self.CursorIcon = "rbxasset://SystemCursors/Forbidden"
        self.Button.ImageTransparency, self.Textbox.TextTransparency = 0.5, 0.5
        self.Button.HoverImage, self.Button.PressedImage = self.Images.default, self.Images.default
    else
        self.CursorIcon = "rbxasset://SystemCursors/PointingHand"
        self.Button.ImageTransparency, self.Textbox.TextTransparency = 0, 0
        self.Button.HoverImage, self.Button.PressedImage = self.Images.hover, self.Images.pressed
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
    self.ButtonFrame = Instance.new("Frame", self.Frame)
    self.ButtonFrame.BackgroundTransparency = 1
    self.ButtonFrame.Name = "ButtonFrame"
    self.ButtonFrame.Size = UDim2.new(1,0,1,0)
    -- set up a textbox for the button
    if type(Textbox) == "string" then
        self.TextboxTable = TextboxMod.new(Textbox, nil, nil, nil, self.ButtonFrame)
    else
        self.TextboxTable = Textbox
        Textbox:Move(self.ButtonFrame, true)
    end
    self.Textbox = self.TextboxTable.Textbox
    self.Textbox.ZIndex = 1
    -- button image
    self.Button = Instance.new("ImageButton", self.ButtonFrame)
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
    self.Button.Image, self.Button.HoverImage, self.Button.PressedImage = self.Images.default, self.Images.hover, self.Images.pressed
    self.Button.ScaleType = Enum.ScaleType.Slice
    self.Button.SliceCenter = Rect.new(7,7,156,36)
    self.Button.Name = "Button"
    self.Button.ZIndex = 0

    self.Button.MouseMoved:Connect(function()
        _G.PluginObject:GetMouse().Icon = self.CursorIcon
    end)
    self.Button.MouseLeave:Connect(function()
        task.wait(0)
        _G.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
    end)

    self:SetDisabled(Disabled)
    self.Object = self.Button
    self.MainMovable = self.ButtonFrame
    return self
end

return Button