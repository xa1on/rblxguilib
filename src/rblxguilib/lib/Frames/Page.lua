local Page = {}
Page.__index = Page

local util = require(script.Parent.Parent.GUIUtil)
local InputManager = require(script.Parent.Parent.InputManager)
local GUIFrame = require(script.Parent.GUIFrame)
setmetatable(Page,GUIFrame)
local PageNum = 0

function Page:SetState(State)
    self.Open = State
    self.Content.Visible = State
    local Transparency = 1
    local OppositeTransparency = 0
    if State then Transparency, OppositeTransparency = 0, 1 end
    self.TabFrame.BackgroundTransparency, self.TopBorder.BackgroundTransparency, self.LeftBorder.BackgroundTransparency, self.RightBorder.BackgroundTransparency = Transparency, Transparency, Transparency, Transparency
    self.Tab.BackgroundTransparency = OppositeTransparency
    self.TabFrame.ZIndex, self.Tab.ZIndex, self.TopBorder.ZIndex, self.LeftBorder.ZIndex, self.RightBorder.ZIndex = OppositeTransparency + 1, OppositeTransparency + 1, OppositeTransparency + 1, OppositeTransparency + 1, OppositeTransparency + 1
end

function Page.new(PageName, PageMenu, OpenByDefault, TabSize)
    local self = GUIFrame.new(PageMenu.Content)
    setmetatable(self,Page)
    PageNum += 1
    self.ID = PageNum
    self.PageMenu = PageMenu
    self.TabFrame = Instance.new("Frame", self.PageMenu.TabContainer)
    self.TabFrame.Name = self.ID
    self.TabFrame.Size = UDim2.new(0,TabSize, 0, 30)
    self.TabFrame.BorderSizePixel = 0
    util.ColorSync(self.TabFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.MainBackground)
    self.Tab = Instance.new("TextButton", self.TabFrame)
    self.Tab.Size = UDim2.new(1, 0, 0, 24)
    util.ColorSync(self.Tab, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar)
    self.Tab.BorderSizePixel = 0
    self.Tab.Font = Enum.Font.SourceSans
    self.Tab.Text = PageName
    self.Tab.TextSize = 14
    self.Tab.Name = "Tab"
    self.InsideWidget = true
    if not TabSize then
        local function sync()
            self.TabFrame.Size = UDim2.new(0,self.Tab.TextBounds.X+2*self.Tab.TextSize, 0, 24)
        end
        self.Tab.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
        sync()
    end
    self.Tab.MouseButton1Down:Connect(function(x)
        if self.TabDragging then return end
        _G.SelectedPage = self
        self.PageMenu:SetActive(self.ID)
        self.TabDragging = true
        self.InitialX = self.TabFrame.Position.X.Offset - x - self.PageMenu.ScrollingMenu.CanvasPosition.X
    end)
    InputManager.AddInputEvent("InputEnded", function(p)
        if not self.TabDragging or p.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        _G.SelectedPage = nil
        self.TabDragging = false
        self.PageMenu:FixPageLayout()
    end)
    InputManager.AddInputEvent("MouseEnter", function()
        if not self.TabDragging and self.InsideWidget then return end
        self.PageMenu:AddPage(self)
        self.InsideWidget = true
        _G.SelectedPage = nil
        self.TabDragging = false
        self.PageMenu:FixPageLayout()
    end)
    local PreviousMouseX = 0
    InputManager.AddInputEvent("MouseMoved", function(x)
        PreviousMouseX = x
        if not self.TabDragging then return end
        self.TabFrame.Position = UDim2.new(0,x + self.InitialX + self.PageMenu.ScrollingMenu.CanvasPosition.X,0,0)
        if self.InsideWidget then self.PageMenu:BeingDragged(self.ID) end
    end)
    self.PageMenu.ScrollingMenu.Changed:Connect(function(p)
        if not p == "CanvasPosition" or not self.TabDragging then return end
        self.TabFrame.Position = UDim2.new(0,PreviousMouseX + self.InitialX + self.PageMenu.ScrollingMenu.CanvasPosition.X,0,0)
        if self.InsideWidget then self.PageMenu:BeingDragged(self.ID) end
    end)
    InputManager.AddInputEvent("MouseLeave", function()
        if not self.TabDragging then return end
        self.TabDragging = false
        self.InsideWidget = false
        _G.PluginObject:StartDrag({})
        self.PageMenu:RemovePage(self)
    end)
    util.ColorSync(self.Tab, "TextColor3", Enum.StudioStyleGuideColor.TitlebarText)
    self.TopBorder = Instance.new("Frame", self.TabFrame)
    self.TopBorder.Size = UDim2.new(1,0,0,1)
    self.TopBorder.BorderSizePixel = 0
    self.TopBorder.Name = "TopBorder"
    util.ColorSync(self.TopBorder, "BackgroundColor3", Enum.StudioStyleGuideColor.RibbonTabTopBar)
    self.LeftBorder = Instance.new("Frame", self.TabFrame)
    self.LeftBorder.Size = UDim2.new(0,1,0,24)
    self.LeftBorder.BorderSizePixel = 0
    self.LeftBorder.Name = "LeftBorder"
    util.ColorSync(self.LeftBorder, "BackgroundColor3", Enum.StudioStyleGuideColor.Border)
    self.RightBorder = Instance.new("Frame", self.TabFrame)
    self.RightBorder.Size = UDim2.new(0,1,0,24)
    self.RightBorder.Position = UDim2.new(1,0,0,0)
    self.RightBorder.BorderSizePixel = 0
    self.RightBorder.Name = "RightBorder"
    util.ColorSync(self.RightBorder, "BackgroundColor3", Enum.StudioStyleGuideColor.Border)
    self.Content = Instance.new("Frame", self.PageMenu.ContentContainers)
    self.Content.BackgroundTransparency = 1
    self.Content.Size = UDim2.new(1,0,1,0)
    self.Content.Name = self.ID
    self.PageMenu:AddPage(self)
    if OpenByDefault then self.PageMenu:SetActive(self.ID) else self:SetState(false) end
    return self
end

return Page