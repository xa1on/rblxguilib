local TitlebarButton = {}
TitlebarButton.__index = TitlebarButton

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local GUIObject = require(GV.ObjectsDir.GUIObject)
setmetatable(TitlebarButton,GUIObject)

function TitlebarButton:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        self.CursorIcon = "rbxasset://SystemCursors/Forbidden"
        self.Button.Transparency = 0.5
    else
        self.CursorIcon = "rbxasset://SystemCursors/PointingHand"
        self.Button.Transparency = 0
    end
end

function TitlebarButton:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function TitlebarButton:Clicked(func)
    self.Action = func
end

function TitlebarButton:SelectedAction(func)
    self.MenuSelectedAction = func
end

function TitlebarButton.new(Name, PageMenu, Size, Disabled, PluginMenu)
    local self = GUIObject.new(PageMenu.ButtonContainer)
    setmetatable(self,TitlebarButton)
    self.Button = Instance.new("TextButton", self.Parent)
    self.Button.Name = Name
    self.Button.Position = UDim2.new(0,self.Parent.Size.X.Offset,1,0)
    util.ColorSync(self.Button, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar)
    self.Button.ZIndex = 3
    self.Button.BorderSizePixel = 0
    self.Button.Font = Enum.Font.SourceSans
    self.Button.TextSize = 14
    util.ColorSync(self.Button, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    self.Button.Text = Name
    self.PluginMenu = PluginMenu
    if not Size then
        local function sync()
            self.Button.Size = UDim2.new(0,self.Button.TextBounds.X+1.5*self.Button.TextSize, 0, 24)
        end
        self.Button.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
    else
        self.Button.Size = UDim2.new(0,Size,1,0)
    end
    self.Button.MouseMoved:Connect(function()
        GV.PluginObject:GetMouse().Icon = self.CursorIcon
    end)
    self.Button.MouseLeave:Connect(function()
        task.wait(0)
        GV.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
    end)
    self.Button.MouseButton1Click:Connect(function()
        if self.Disabled then return end
        if self.Action then self.Action() end
        if self.PluginMenu then
            local SelectedAction = self.PluginMenu:ShowAsync()
            if self.MenuSelectedAction then self.MenuSelectedAction(SelectedAction) end
        end
    end)
    self:SetDisabled(Disabled)
    self.Object = self.Button
    self.MainMovable = self.Button
    return self
end

return TitlebarButton