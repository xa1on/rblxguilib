local Slider = {}
Slider.__index = Slider

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local GUIObject = require(GV.ObjectsDir.GUIObject)
local InputManager = require(GV.ManagersDir.InputManager)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
setmetatable(Slider,GUIObject)

function Slider:SetDisabled(State)
    self.Disabled = State
    self.SliderSelected = false
    if self.Disabled then
        self.CursorIcon = "rbxasset://SystemCursors/Forbidden"
        self.SlideBar.BackgroundTransparency, self.SlideButton.BackgroundTransparency = 0.5, 0.5
    else
        self.CursorIcon = "rbxasset://SystemCursors/PointingHand"
        self.SlideBar.BackgroundTransparency, self.SlideButton.BackgroundTransparency = 0, 0
    end
end

function Slider:SetValue(Value)
    self.Value = Value
    self:UpdatePosition()
end

function Slider:SetRange(Min, Max)
    self.Min = Min
    self.Max = Max
    self:UpdatePosition()
end

function Slider:UpdatePosition()
    self.SlideButton.Position = UDim2.new((self.Value-self.Min)/(self.Max - self.Min), 0, 0.5, 0)
    if self.Value ~= self.PreviousValue then
        self.PreviousValue = self.Value
        if self.Action then self.Action(self.Value) end
    end
end

function Slider:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function Slider:Changed(func)
    self.Action = func
end

function Slider:Pressed(func)
    self.PressedAction = func
end

function Slider:Released(func)
    self.ReleasedAction = func
end

-- Min, Max, Value, Increment, SliderSize, Disabled
function Slider.new(Arguments, Parent)
    local self = GUIObject.new(Arguments, Parent)
    setmetatable(self,Slider)
    self.Increment = self.Arguments.Increment or 0
    self.Value = self.Arguments.Value or self.Arguments.Min
    self.Min = self.Arguments.Min
    self.Max = self.Arguments.Max
    self.SliderFrame = Instance.new("Frame", self.Parent)
    self.SliderFrame.BackgroundTransparency = 1
    self.SlideBar = Instance.new("Frame", self.SliderFrame)
    self.SlideBar.AnchorPoint = Vector2.new(0.5,0.5)
    self.SlideBar.Position = UDim2.new(0.5,0,0.5,0)
    local Size = util.GetScale(self.Arguments.SliderSize) or UDim.new(1,-12)
    self.SlideBar.Size = UDim2.new(Size.Scale, Size.Offset, 0, 5)
    ThemeManager.ColorSync(self.SlideBar, "BackgroundColor3", Enum.StudioStyleGuideColor.FilterButtonAccent)
    self.SlideButton = Instance.new("TextButton", self.SlideBar)
    self.SlideButton.Text = ""
    self.SlideButton.BorderSizePixel = 1
    self.SlideButton.AnchorPoint = Vector2.new(0.5,0.5)
    self:UpdatePosition()
    self.SlideButton.Size = UDim2.new(0,7,0,18)
    ThemeManager.ColorSync(self.SlideButton, "BackgroundColor3", Enum.StudioStyleGuideColor.InputFieldBackground)
    ThemeManager.ColorSync(self.SlideButton, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    self.SlideBar.BorderSizePixel = 0
    self.SliderSelected = false
    self.InitialX = 0
    self.SlideButton.MouseButton1Down:Connect(function(x)
        if self.PressedAction then self.PressedAction() end
        if self.Disabled then return end
        self.SliderSelected = true
        self.InitialX = self.SlideButton.AbsolutePosition.X - x
    end)
    self.SlideButton.MouseButton1Up:Connect(function()
        if self.ReleasedAction then self.ReleasedAction() end
    end)
    self.PreviousValue = self.Value
    InputManager.AddInputEvent("MouseMoved", function(x)
        if not self.SliderSelected then return end
        self.Value = util.RoundNumber(math.clamp((x + self.InitialX - self.SlideBar.AbsolutePosition.X + self.SlideButton.Size.X.Offset / 2)/self.SlideBar.AbsoluteSize.X, 0, 1) * (self.Max - self.Min) + self.Min, self.Increment)
        self:UpdatePosition()
    end)
    InputManager.AddInputEvent("InputEnded", function(p)
        if self.SliderSelected and p.UserInputType == Enum.UserInputType.MouseButton1 then
            self.SliderSelected = false
            if self.ReleasedAction then self.ReleasedAction() end
        end
    end)
    InputManager.AddInputEvent("MouseLeave", function()
        if self.SliderSelected and self.ReleasedAction then self.ReleasedAction() end
        self.SliderSelected = false
    end)
    self.SlideButton.MouseMoved:Connect(function()
        GV.PluginObject:GetMouse().Icon = self.CursorIcon
    end)
    self.SlideButton.MouseLeave:Connect(function()
        task.wait(0)
        GV.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
    end)
    self:SetDisabled(self.Arguments.Disabled)
    self.Object = self.SlideButton
    self.MainMovable = self.SliderFrame
    return self
end

return Slider