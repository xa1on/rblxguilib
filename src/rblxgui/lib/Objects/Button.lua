local Button = {}
Button.__index = Button

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
local TextboxMod = require(GV.ObjectsDir.Textbox)
local GUIObject = require(GV.ObjectsDir.GUIObject)
setmetatable(Button,GUIObject)

Button.Images = {
    border = "http://www.roblox.com/asset/?id=10460485555",
    bg = "http://www.roblox.com/asset/?id=10460051857",
    selected = "http://www.roblox.com/asset/?id=10460676787"
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
    self.Action = func
end

-- Text/Textbox, ButtonSize, Disabled
function Button.new(Arguments, Parent)
    local self = GUIObject.new(Arguments, Parent)
    setmetatable(self,Button)
    self.TextboxTable = nil
    -- creating a frame to hold the button
    self.ButtonFrame = Instance.new("Frame", self.Parent)
    self.ButtonFrame.BackgroundTransparency = 1
    self.ButtonFrame.Name = "ButtonFrame"
    self.ButtonFrame.Size = UDim2.new(1,0,1,0)

    self.Button = Instance.new("ImageButton", self.ButtonFrame)

    -- set up a textbox for the button
    local Textbox = self.Arguments.Textbox or self.Arguments.Text
    if type(Textbox) == "string" then
        self.TextboxTable = TextboxMod.new({Text = Textbox}, self.Button)
    else
        self.TextboxTable = Textbox
        Textbox:Move(self.Button, true)
    end
    self.Textbox = self.TextboxTable.Textbox
    self.Textbox.ZIndex = 1

    local Size = util.GetScale(self.Arguments.ButtonSize)
    if Size then self.Button.Size = UDim2.new(Size.Scale,Size.Offset,1,0)
    else
        local function sync()
            self.Button.Size = UDim2.new(0,self.Textbox.TextBounds.X+1.5*self.Textbox.TextSize, 1, 0)
        end
        self.Textbox.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
    end
    self.Button.Position = UDim2.new(0.5, 0, 0, 0)
    self.Button.AnchorPoint = Vector2.new(0.5,0)
    self.Button.BackgroundTransparency = 1
    self.Button.Image = self.Images.border
    ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.DialogButtonBorder)
    self.Button.ScaleType = Enum.ScaleType.Slice
    self.Button.SliceCenter = Rect.new(7,7,156,36)
    self.Button.Name = "Button"

    self.ButtonBackground = Instance.new("ImageLabel", self.Button)
    self.ButtonBackground.Name = "ButtonBackground"
    self.ButtonBackground.BackgroundTransparency = 1
    self.ButtonBackground.Size = UDim2.new(1,0,1,0)
    self.ButtonBackground.Image = self.Images.bg
    ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button)
    self.ButtonBackground.ScaleType = Enum.ScaleType.Slice
    self.ButtonBackground.SliceCenter = Rect.new(7,7,156,36)
    self.ButtonBackground.ZIndex = 0

    self.Toggleable = false
    local Pressed = false
    self.Button.MouseMoved:Connect(function()
        GV.PluginObject:GetMouse().Icon = self.CursorIcon
        if self.Disabled or Pressed or self.Toggleable then return end
        ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
        ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
    end)
    self.Button.MouseLeave:Connect(function()
        task.wait(0)
        GV.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
        if self.Disabled or self.Toggleable then return end
        Pressed = false
        ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder)
        ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button)
    end)

    self.Button.MouseButton1Down:Connect(function()
        if self.Disabled or self.Toggleable then return end
        Pressed = true
        ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
        ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
    end)

    self.Button.MouseButton1Up:Connect(function()
        if self.Disabled or self.Toggleable then return end
        Pressed = false
        ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder)
        ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button)
    end)

    self.Button.MouseButton1Click:Connect(function()
        if not self.Disabled then
            if self.Action then self.Action(self.Value) end
        end
    end)

    self:SetDisabled(self.Arguments.Disabled)
    self.Object = self.Button
    self.MainMovable = self.ButtonFrame
    return self
end

return Button