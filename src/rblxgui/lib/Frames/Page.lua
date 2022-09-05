local Page = {}
Page.__index = Page

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local InputManager = require(GV.ManagersDir.InputManager)
local GUIFrame = require(GV.FramesDir.GUIFrame)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
setmetatable(Page,GUIFrame)
local PageNum = 0
GV.PluginPages = {}

function Page:SetState(State)
    self.Open = State
    self.Content.Visible = State
    local Transparency = 1
    local OppositeTransparency = 0
    if State then Transparency, OppositeTransparency = 0, 1 end
    self.TabFrame.BackgroundTransparency, self.TopBorder.BackgroundTransparency, self.LeftBorder.BackgroundTransparency, self.RightBorder.BackgroundTransparency = Transparency, Transparency, Transparency, Transparency
    self.Tab.BackgroundTransparency = OppositeTransparency
    self.TabFrame.ZIndex, self.Tab.ZIndex, self.TopBorder.ZIndex, self.LeftBorder.ZIndex, self.RightBorder.ZIndex = OppositeTransparency + 2, OppositeTransparency + 2, OppositeTransparency + 2, OppositeTransparency + 2, OppositeTransparency + 2
    if State then
        ThemeManager.ColorSync(self.Tab, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    else
        ThemeManager.ColorSync(self.Tab, "TextColor3", Enum.StudioStyleGuideColor.TitlebarText,nil,nil,nil,true)
    end
end

-- Name, TitlebarMenu, Open, TabSize, ID
function Page.new(Arguments, Parent)
    local self = GUIFrame.new(Arguments, Parent)
    self.TitlebarMenu = self.Arguments.TitlebarMenu or self.Parent.TitlebarMenu
    setmetatable(self,Page)
    PageNum += 1
    self.ID = self.Arguments.ID or self.Arguments.Name
    self.TabFrame = Instance.new("Frame", self.TitlebarMenu.TabContainer)
    self.TabFrame.Name = PageNum
    self.TabFrame.BorderSizePixel = 0
    ThemeManager.ColorSync(self.TabFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.MainBackground)
    self.Tab = Instance.new("TextButton", self.TabFrame)
    self.Tab.Size = UDim2.new(1, 0, 0, 24)
    ThemeManager.ColorSync(self.Tab, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar,nil,nil,nil,true)
    self.Tab.BorderSizePixel = 0
    self.Tab.Font = Enum.Font.SourceSans
    self.Tab.Text = self.Arguments.Name
    self.Tab.TextSize = 14
    self.Tab.Name = "Tab"
    self.InsideWidget = true
    if not self.Arguments.TabSize then
        local function sync()
            self.TabFrame.Size = UDim2.new(0,self.Tab.TextBounds.X+1.5*self.Tab.TextSize, 0, 24)
        end
        self.Tab.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
        sync()
    else
        self.TabFrame.Size = UDim2.new(0,self.Arguments.TabSize,0,30)
    end
    self.Tab.MouseButton1Down:Connect(function(x)
        if self.TabDragging then return end
        GV.SelectedPage = self
        self.TitlebarMenu:SetActive(self.ID)
        self.TabDragging = true
        self.InitialX = self.TabFrame.Position.X.Offset - x - self.TitlebarMenu.ScrollingMenu.CanvasPosition.X
    end)
    InputManager.AddInputEvent("InputEnded", function(p)
        if not self.TabDragging or p.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        GV.SelectedPage = nil
        self.TabDragging = false
        self.TitlebarMenu:FixPageLayout()
    end)
    InputManager.AddInputEvent("MouseEnter", function()
        if not self.TabDragging and self.InsideWidget then return end
        self.TitlebarMenu:AddPage(self)
        self.InsideWidget = true
        GV.SelectedPage = nil
        self.TabDragging = false
        self.TitlebarMenu:FixPageLayout()
    end)
    local PreviousMouseX = 0
    InputManager.AddInputEvent("MouseMoved", function(x)
        PreviousMouseX = x
        if not self.TabDragging then return end
        self.TabFrame.Position = UDim2.new(0,x + self.InitialX + self.TitlebarMenu.ScrollingMenu.CanvasPosition.X,0,0)
        if self.InsideWidget then self.TitlebarMenu:BeingDragged(self.ID) end
    end)
    self.TitlebarMenu.ScrollingMenu.Changed:Connect(function(p)
        if not p == "CanvasPosition" or not self.TabDragging then return end
        self.TabFrame.Position = UDim2.new(0,PreviousMouseX + self.InitialX + self.TitlebarMenu.ScrollingMenu.CanvasPosition.X,0,0)
        if self.InsideWidget then self.TitlebarMenu:BeingDragged(self.ID) end
    end)
    InputManager.AddInputEvent("MouseLeave", function()
        if not self.TabDragging then return end
        self.TabDragging = false
        self.InsideWidget = false
        GV.PluginObject:StartDrag({})
        self.TitlebarMenu:RemovePage(self)
    end)
    ThemeManager.ColorSync(self.Tab, "TextColor3", Enum.StudioStyleGuideColor.TitlebarText,nil,nil,nil,true)
    self.TopBorder = Instance.new("Frame", self.TabFrame)
    self.TopBorder.Size = UDim2.new(1,0,0,1)
    self.TopBorder.BorderSizePixel = 0
    self.TopBorder.Name = "TopBorder"
    ThemeManager.ColorSync(self.TopBorder, "BackgroundColor3", Enum.StudioStyleGuideColor.RibbonTabTopBar, nil, true, nil, true)
    self.LeftBorder = Instance.new("Frame", self.TabFrame)
    self.LeftBorder.Size = UDim2.new(0,1,0,24)
    self.LeftBorder.BorderSizePixel = 0
    self.LeftBorder.Name = "LeftBorder"
    ThemeManager.ColorSync(self.LeftBorder, "BackgroundColor3", Enum.StudioStyleGuideColor.Border)
    self.RightBorder = Instance.new("Frame", self.TabFrame)
    self.RightBorder.Size = UDim2.new(0,1,0,24)
    self.RightBorder.Position = UDim2.new(1,0,0,0)
    self.RightBorder.BorderSizePixel = 0
    self.RightBorder.Name = "RightBorder"
    ThemeManager.ColorSync(self.RightBorder, "BackgroundColor3", Enum.StudioStyleGuideColor.Border)
    self.Content = Instance.new("Frame", self.TitlebarMenu.ContentContainers)
    self.Content.BackgroundTransparency = 1
    self.Content.Size = UDim2.new(1,0,1,0)
    self.Content.Name = self.ID
    self.TitlebarMenu:AddPage(self)
    if self.Arguments.Open then self.TitlebarMenu:SetActive(self.ID) else self:SetState(false) end
    GV.PluginPages[#GV.PluginPages+1] = self
    return self
end

return Page