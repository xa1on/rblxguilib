local Checkbox = {}
Checkbox.__index = Checkbox

local util = require(script.Parent.Parent.GUIUtil)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(Checkbox,GUIObject)

Checkbox.Images = {
    check = "http://www.roblox.com/asset/?id=10278675078",
    Dark = {
        Box = "http://www.roblox.com/asset/?id=10278156816",
        Hover = "http://www.roblox.com/asset/?id=10278155250"
    },
    Light = {
        Box = "http://www.roblox.com/asset/?id=10278156413",
        Hover = "http://www.roblox.com/asset/?id=10278155707"
    }
}

function Checkbox:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        self.CursorIcon = "rbxasset://SystemCursors/Forbidden"
        self.Checkbox.ImageTransparency, self.CheckImage.ImageTransparency = 0.5, 0.5
        self.Checkbox.HoverImage = self.Checkbox.Image
    else
        self.CursorIcon = "rbxasset://SystemCursors/PointingHand"
        self.Checkbox.ImageTransparency, self.CheckImage.ImageTransparency = 0, 0
        self:UpdateColors()
    end
end

function Checkbox:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function Checkbox:UpdateColors()
    local theme = settings().Studio.Theme
    self.Checkbox.Image = self.Images[tostring(theme)].Box
    self.Checkbox.HoverImage = self.Images[tostring(theme)].Hover
    if tostring(theme) == "Dark" then
        self.CheckImage.ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldIndicator)
        self.Checkbox.ImageColor3 = Color3.new(1,1,1)
    else
        self.CheckImage.ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldIndicator)
        if self.Toggled then
            self.Checkbox.ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldBackground, Enum.StudioStyleGuideModifier.Selected)
        else
            self.Checkbox.ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldBackground)
        end
    end
end

function Checkbox:Toggle()
    self:SetToggle(not self.Toggled)
end

function Checkbox:SetToggle(Toggle)
    self.Toggled = Toggle
    self.CheckImage.Visible = Toggle
    self:UpdateColors()
end

function Checkbox:Clicked(func)
    self.Action = func
end

function Checkbox.new(DefaultValue, Disabled, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,Checkbox)
    if type(DefaultValue) ~= "boolean" then DefaultValue = false end
    self.Toggled = DefaultValue
    self.Disabled = Disabled
    self.CheckboxFrame = Instance.new("Frame", self.Frame)
    self.CheckboxFrame.BackgroundTransparency = 1
    self.CheckboxFrame.Name = "CheckboxFrame"
    self.Checkbox = Instance.new("ImageButton", self.CheckboxFrame)
    self.Checkbox.BackgroundTransparency = 1
    self.Checkbox.AnchorPoint = Vector2.new(0.5,0.5)
    self.Checkbox.Position = UDim2.new(0.5,0,0.5,0)
    self.Checkbox.Size = UDim2.new(0,16,0,16)
    self.Checkbox.Name = "Checkbox"
    self.CheckImage = Instance.new("ImageLabel", self.Checkbox)
    self.CheckImage.AnchorPoint = Vector2.new(0.5,0.5)
    self.CheckImage.Position = UDim2.new(0.5,0,0.5,0)
    self.CheckImage.Size = UDim2.new(0,16,0,16)
    self.CheckImage.Image = self.Images.check
    self.CheckImage.BackgroundTransparency = 1
    self.CheckImage.Name = "CheckIndicator"
    settings().Studio.ThemeChanged:Connect(function() self:UpdateColors() end)
    self.Checkbox.MouseMoved:Connect(function()
        _G.PluginObject:GetMouse().Icon = self.CursorIcon
    end)
    self.Checkbox.MouseLeave:Connect(function()
        task.wait(0)
        _G.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
    end)
    self.Checkbox.MouseButton1Click:Connect(function()
        if not self.Disabled then
            self:Toggle()
            if self.Action then self.Action(self.Toggled) end
        end
    end)
    self:SetToggle(self.Toggled)
    self:SetDisabled(self.Disabled)
    self.Object = self.Checkbox
    self.MainMovable = self.CheckboxFrame
    return self
end

return Checkbox