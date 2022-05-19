local Button = {}
Button.__index = Button

local util = require(script.Parent.Util)
local TextboxMod = require(script.Parent.Textbox)
local ListFrame = require(script.Parent.ListFrame)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(Button,GUIObject)

Button.Images = {
    default = "http://www.roblox.com/asset/?id=9631146921",
    hover = "http://www.roblox.com/asset/?id=9622825658",
    pressed = "http://www.roblox.com/asset/?id=9538564172",
    bg = "http://www.roblox.com/asset/?id=9631095238"
}

local IgnoreChanges = false

function Button.new(textbox, scale, parent)
    if not parent then parent = ListFrame.new().Frame end
    local self = GUIObject.new()
    setmetatable(self,Button)
    self.TextboxTable = nil
    if not scale then scale = 1 end
    -- creating a frame to hold the button
    self.ButtonFrame = Instance.new("Frame", parent)
    self.ButtonFrame.BackgroundTransparency = 1
    self.ButtonFrame.Name = "ButtonFrame"
    self.ButtonFrame.Size = UDim2.new(1,0,1,0)
    -- set up a textbox for the button
    if type(textbox) == "string" then
        self.TextboxTable = TextboxMod.new(textbox, nil, nil, nil, self.ButtonFrame)
    else
        self.TextboxTable = textbox
        textbox:Move(self.ButtonFrame)
    end
    self.Textbox = self.TextboxTable.Textbox
    self.Textbox.ZIndex = 3
    -- button image
    self.Button = Instance.new("ImageButton", self.ButtonFrame)
    self.Button.Size = UDim2.new(scale,0,1,0)
    self.Button.Position = UDim2.new((1-scale)/2, 0, 0, 0)
    self.Button.BackgroundTransparency = 1
    self.Button.Image, self.Button.HoverImage, self.Button.PressedImage = self.Images.default, self.Images.hover, self.Images.pressed
    self.Button.ScaleType = Enum.ScaleType.Slice
    self.Button.SliceCenter = Rect.new(7,7,156,36)
    self.Button.Name = "Button"
    self.Button.ZIndex = 2
    -- dark background for the button
    self.ButtonBackground = Instance.new("ImageLabel", self.ButtonFrame)
    self.ButtonBackground.Size = UDim2.new(scale,0,1,0)
    self.ButtonBackground.Position = UDim2.new((1-scale)/2, 0, 0, 0)
    self.ButtonBackground.BackgroundTransparency = 1
    self.ButtonBackground.ImageTransparency = 0.9
    self.ButtonBackground.ScaleType = Enum.ScaleType.Slice
    self.ButtonBackground.SliceCenter = Rect.new(7,7,156,36)
    self.ButtonBackground.Image = self.Images.bg
    self.ButtonBackground.Name = "ButtonBG"
    self.Object = self.Button
    self.Object.Changed:Connect(function(p)
        if p == "Parent" and not IgnoreChanges then
            self.Object.Visible = false
            self.Textbox.Visible = false
            task.wait(0)
            self.ButtonFrame.Parent = self.Object.Parent
            IgnoreChanges = true
            task.wait(0)
            self.Object.Parent = self.ButtonFrame
            self.Object.Visible = true
            self.Textbox.Visible = true
            IgnoreChanges = false
            self.Frame = self.ButtonFrame.Parent
        end
    end)
    self.Frame = self.ButtonFrame.Parent
    return self
end

return Button