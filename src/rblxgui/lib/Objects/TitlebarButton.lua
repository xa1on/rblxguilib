local TitlebarButton = {}
TitlebarButton.__index = TitlebarButton

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local GUIObject = require(GV.ObjectsDir.GUIObject)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
setmetatable(TitlebarButton,GUIObject)

GV.TitleBarButtons = {}

function TitlebarButton:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        self.CursorIcon = "rbxasset://SystemCursors/Forbidden"
        for _,v in pairs(self.Buttons) do
            v.Transparency = 0.5
        end
    else
        self.CursorIcon = "rbxasset://SystemCursors/PointingHand"
        for _,v in pairs(self.Buttons) do
            v.Transparency = 0
        end
    end
end

function TitlebarButton:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function TitlebarButton:Clicked(func)
    self.Action = func
end

function TitlebarButton:SelectedAction(func)
    self.TitlebarMenuSelectedAction = func
end

function TitlebarButton:CreateCopy(TitlebarMenu)
    local Button = Instance.new("TextButton", TitlebarMenu.ButtonContainer)
    Button = Instance.new("TextButton", TitlebarMenu.ButtonContainer)
    Button.Name = self.Name
    Button.Position = UDim2.new(0,TitlebarMenu.ButtonContainer.Size.X.Offset,1,0)
    ThemeManager.ColorSync(Button, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar,nil,nil,nil,true)
    Button.ZIndex = 4
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 14
    ThemeManager.ColorSync(Button, "TextColor3", Enum.StudioStyleGuideColor.MainText,nil,nil,nil,true)
    Button.Text = self.Name
    if not self.TabSize then
        local function sync()
            Button.Size = UDim2.new(0,Button.TextBounds.X+1.5*Button.TextSize, 0, 24)
        end
        Button.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
    else
        Button.Size = UDim2.new(0,self.TabSize,1,0)
    end
    Button.MouseMoved:Connect(function()
        GV.PluginObject:GetMouse().Icon = self.CursorIcon
    end)
    Button.MouseLeave:Connect(function()
        task.wait(0)
        GV.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
    end)
    Button.MouseButton1Click:Connect(function()
        if self.Disabled then return end
        if self.Action then self.Action() end
        if self.PluginMenu then
            -- ???? what
            task.wait()
            task.wait()
            -- i have no idea how this works but it does
            local SelectedAction = self.PluginMenu:ShowAsync()
            if self.TitlebarMenuSelectedAction then self.TitlebarMenuSelectedAction(SelectedAction) end
        end
    end)
    self.Buttons[#self.Buttons+1] = Button
end

-- Name, TabSize, Disabled, PluginMenu
function TitlebarButton.new(Arguments)
    local self = GUIObject.new(Arguments)
    setmetatable(self,TitlebarButton)
    self.Buttons = {}
    self.Name = self.Arguments.Name
    self.PluginMenu = self.Arguments.PluginMenu
    self.TabSize = self.Arguments.TabSize
    for _, v in pairs(GV.PluginWidgets) do
        self:CreateCopy(v.TitlebarMenu)
    end
    self:SetDisabled(self.Arguments.Disabled)
    self.Object = self.Buttons
    GV.TitleBarButtons[#GV.TitleBarButtons+1] = self
    return self
end

return TitlebarButton