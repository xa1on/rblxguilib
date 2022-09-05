local Checkbox = {}
Checkbox.__index = Checkbox

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local GUIObject = require(GV.ObjectsDir.GUIObject)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
setmetatable(Checkbox,GUIObject)

Checkbox.Images = {
    check = "http://www.roblox.com/asset/?id=10278675078"
}

function Checkbox:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        self.CursorIcon = "rbxasset://SystemCursors/Forbidden"
        self.Checkbox.Transparency, self.CheckImage.ImageTransparency = 0.5, 0.5
    else
        self.CursorIcon = "rbxasset://SystemCursors/PointingHand"
        self.Checkbox.Transparency, self.CheckImage.ImageTransparency = 0, 0
    end
end

function Checkbox:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function Checkbox:Toggle()
    self:SetValue(not self.Value)
    return self.Value
end

function Checkbox:SetValue(Toggle)
    self.Value = Toggle
    self.CheckImage.Visible = Toggle
    if Toggle then
        ThemeManager.ColorSync(self.Checkbox, "BackgroundColor3", Enum.StudioStyleGuideColor.CheckedFieldBackground, Enum.StudioStyleGuideModifier.Selected, true, "Light")
    else
        ThemeManager.ColorSync(self.Checkbox, "BackgroundColor3", Enum.StudioStyleGuideColor.CheckedFieldBackground)
    end
end

function Checkbox:Clicked(func)
    self.Action = func
end
-- Value, Disabled
function Checkbox.new(Arguments, Parent)
    local self = GUIObject.new(Arguments, Parent)
    setmetatable(self,Checkbox)
    self.Value = self.Arguments.Value
    self.Disabled = self.Arguments.Disabled
    self.CheckboxFrame = Instance.new("Frame", self.Parent)
    self.CheckboxFrame.BackgroundTransparency = 1
    self.CheckboxFrame.Name = "CheckboxFrame"
    self.Checkbox = Instance.new("TextButton", self.CheckboxFrame)
    self.Checkbox.BackgroundTransparency = 1
    self.Checkbox.AnchorPoint = Vector2.new(0.5,0.5)
    self.Checkbox.Position = UDim2.new(0.5,0,0.5,0)
    self.Checkbox.Size = UDim2.new(0,16,0,16)
    self.Checkbox.Name = "Checkbox"
    self.Checkbox.Text = ""
    ThemeManager.ColorSync(self.Checkbox, "BorderColor3", Enum.StudioStyleGuideColor.CheckedFieldBorder)
    ThemeManager.ColorSync(self.Checkbox, "BackgroundColor3", Enum.StudioStyleGuideColor.CheckedFieldBackground)
    self.CheckImage = Instance.new("ImageLabel", self.Checkbox)
    self.CheckImage.AnchorPoint = Vector2.new(0.5,0.5)
    self.CheckImage.Position = UDim2.new(0.5,0,0.5,0)
    self.CheckImage.Size = UDim2.new(0,16,0,16)
    self.CheckImage.Image = self.Images.check
    self.CheckImage.BackgroundTransparency = 1
    self.CheckImage.Name = "CheckIndicator"
    ThemeManager.ColorSync(self.CheckImage, "ImageColor3", Enum.StudioStyleGuideColor.CheckedFieldIndicator, nil, true, "Dark")
    self.Checkbox.MouseMoved:Connect(function()
        GV.PluginObject:GetMouse().Icon = self.CursorIcon
        if not self.Disabled then
            ThemeManager.ColorSync(self.Checkbox, "BorderColor3", Enum.StudioStyleGuideColor.CheckedFieldBorder, Enum.StudioStyleGuideModifier.Hover)
        end
    end)
    self.Checkbox.MouseLeave:Connect(function()
        task.wait(0)
        GV.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
        ThemeManager.ColorSync(self.Checkbox, "BorderColor3", Enum.StudioStyleGuideColor.CheckedFieldBorder)
    end)
    self.Checkbox.MouseButton1Click:Connect(function()
        if not self.Disabled then
            self:Toggle()
            if self.Action then self.Action(self.Value) end
        end
    end)
    self:SetValue(self.Value)
    self:SetDisabled(self.Disabled)
    self.Object = self.Checkbox
    self.MainMovable = self.CheckboxFrame
    return self
end

return Checkbox