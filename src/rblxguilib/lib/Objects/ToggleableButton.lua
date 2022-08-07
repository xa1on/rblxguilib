local ToggleableButton = {}
ToggleableButton.__index = ToggleableButton

local util = require(_G.LibraryDir.GUIUtil)
local Button = require(_G.ObjectsDir.Button)
setmetatable(ToggleableButton,Button)

function ToggleableButton:Toggle()
    self:SetValue(not self.Value)
    return self.Value
end

function ToggleableButton:SetValue(Value)
    self.Value = Value
end

function ToggleableButton.new(Textbox, Size, DefaultValue, Disabled, Parent)
    local self = Button.new(Textbox, Size, Disabled, Parent)
    setmetatable(self,ToggleableButton)
    self.Toggleable = true
    local Pressed = false
    self.Button.MouseMoved:Connect(function()
        if self.Disabled or Pressed then return end
        if not self.Value then
            util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
            util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
        else
            util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
            util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
        end
    end)
    self.Button.MouseLeave:Connect(function()
        if self.Disabled then return end
        Pressed = false
        if not self.Value then
            util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder)
            util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button)
        else
            util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
            util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
        end
    end)
    self.Button.MouseButton1Down:Connect(function()
        if self.Disabled then return end
        Pressed = true
        if not self.Value then
            util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
            util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
        else
            util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
            util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
        end
    end)
    
    self.Button.MouseButton1Up:Connect(function()
        if self.Disabled then return end
        Pressed = false
        if not self.Value then
            util.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
            util.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
        end
    end)

    self.Button.MouseButton1Click:Connect(function()
        if not self.Disabled then
            self:Toggle()
        end
    end)

    self:SetValue(DefaultValue)
    return self
end

return ToggleableButton