local ToggleableButton = {}
ToggleableButton.__index = ToggleableButton

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local Button = require(GV.ObjectsDir.Button)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
setmetatable(ToggleableButton,Button)

function ToggleableButton:Update()
    if not self.Value then
        ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder)
        ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button)
    else
        ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
        ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
    end
end

function ToggleableButton:Toggle()
    self:SetValue(not self.Value)
    return self.Value
end

function ToggleableButton:SetValue(Value)
    self.Value = Value
    self:Update()
end

-- Textbox, Size, Value, Disabled
function ToggleableButton.new(Arguments, Parent)
    local self = Button.new(Arguments, Parent)
    setmetatable(self,ToggleableButton)
    self.Toggleable = true
    local Pressed = false
    self.Button.MouseMoved:Connect(function()
        if self.Disabled or Pressed then return end
        if not self.Value then
            ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
            ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
        else
            ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
            ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
        end
    end)
    self.Button.MouseLeave:Connect(function()
        if self.Disabled then return end
        Pressed = false
        self:Update()
    end)
    self.Button.MouseButton1Down:Connect(function()
        if self.Disabled then return end
        Pressed = true
        if not self.Value then
            ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
            ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
        else
            ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
            ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
        end
    end)
    
    self.Button.MouseButton1Up:Connect(function()
        if self.Disabled then return end
        Pressed = false
        if not self.Value then
            ThemeManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
            ThemeManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
        end
    end)

    self.Button.MouseButton1Click:Connect(function()
        if not self.Disabled then
            self:Toggle()
        end
    end)

    self:SetValue(self.Arguments.Value)
    return self
end

return ToggleableButton