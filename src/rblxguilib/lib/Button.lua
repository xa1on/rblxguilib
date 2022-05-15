local Button = {}
Button.__index = Button
local util = require(script.Parent.Util)
local TextboxMod = require(script.Parent.Textbox)
local FrameMod = require(script.Parent.Frame)

Button.Images = {
    default = "http://www.roblox.com/asset/?id=9631146921",
    hover = "http://www.roblox.com/asset/?id=9622825658",
    pressed = "http://www.roblox.com/asset/?id=9538564172",
    bg = "http://www.roblox.com/asset/?id=9631095238"
}

function Button.new(textbox, scale, parent)
    local self = {}
    setmetatable(self,Button)
    self.Text = nil
    if not parent then parent = FrameMod.new().Frame end
    if not scale then scale = 1 end
    -- creating a frame to hold the button
    self.ButtonFrame = Instance.new("Frame", parent)
    self.ButtonFrame.BackgroundTransparency = 1
    self.ButtonFrame.Name = "ButtonFrame"
    self.ButtonFrame.Size = UDim2.new(1,0,1,0)
    -- set up a textbox for the button
    if type(textbox) == "string" then
        self.Text = TextboxMod.new(textbox, nil, nil, self.ButtonFrame)
    else
        self.Text = textbox.Textbox
        local previousframe = textbox.Frame
        textbox.Frame = self.ButtonFrame
        textbox.Textbox.Parent = self.ButtonFrame
        if previousframe.Name == "TextFrame" then previousframe:Destroy() end
    end
    self.Text.ZIndex = 3
    -- button image
    self.Button = Instance.new("ImageButton", self.ButtonFrame)
    self.Button.Size = UDim2.new(scale,0,1,0)
    self.Button.Position = UDim2.new((1-scale)/2, 0, 0, 0)
    self.Button.BackgroundTransparency = 1
    self.Button.Image, self.Button.HoverImage, self.Button.PressedImage = Button.Images.default, Button.Images.hover, Button.Images.pressed
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
    self.ButtonBackground.Image = Button.Images.bg
    self.ButtonBackground.Name = "ButtonBG"

    self.Frame = parent
    return self
end

return Button