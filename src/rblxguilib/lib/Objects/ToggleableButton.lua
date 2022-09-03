local ToggleableButton = {}
ToggleableButton.__index = ToggleableButton

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local Button = require(GV.ObjectsDir.Button)
local ColorManager = require(GV.ManagersDir.ColorManager)
setmetatable(ToggleableButton,Button)

function ToggleableButton:Toggle()
    self:SetValue(not self.Value)
    return self.Value
end

function ToggleableButton:SetValue(Value)
    self.Value = Value
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
            ColorManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
            ColorManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
        else
            ColorManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
            ColorManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
        end
    end)
    self.Button.MouseLeave:Connect(function()
        if self.Disabled then return end
        Pressed = false
        if not self.Value then
            ColorManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder)
            ColorManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button)
        else
            ColorManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
            ColorManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
        end
    end)
    self.Button.MouseButton1Down:Connect(function()
        if self.Disabled then return end
        Pressed = true
        if not self.Value then
            ColorManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
            ColorManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
        else
            ColorManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
            ColorManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
        end
    end)
    
    self.Button.MouseButton1Up:Connect(function()
        if self.Disabled then return end
        Pressed = false
        if not self.Value then
            ColorManager.ColorSync(self.Button, "ImageColor3", Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
            ColorManager.ColorSync(self.ButtonBackground, "ImageColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
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