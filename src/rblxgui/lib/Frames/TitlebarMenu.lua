local StarterPlayer = game:GetService("StarterPlayer")
local TitlebarMenu = {}
TitlebarMenu.__index = TitlebarMenu
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local GUIFrame = require(GV.FramesDir.GUIFrame)
local util = require(GV.MiscDir.GUIUtil)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
setmetatable(TitlebarMenu,GUIFrame)
GV.PluginTitlebarMenus = {}

function TitlebarMenu:RecievePage(Page)
    Page.TabFrame.Parent = self.TabContainer
    Page.Content.Parent = self.ContentContainers
    Page.TitlebarMenu = self
    Page.InsideWidget = true
    Page.Parent = self.TitlebarMenu
    self:AddPage(Page)
end

function TitlebarMenu:GetIDIndex(ID)
    for i,v in pairs(self.Pages) do if v.ID == ID then return i end end
end

function TitlebarMenu:GetIDTab(ID)
    return self.Pages[self:GetIDIndex(ID)]
end

function TitlebarMenu:AddPage(Page)
    self:FixPageLayout()
    if #self.Pages > 0 then
        local LatestPage = self.Pages[#self.Pages]
        Page.TabFrame.Position = UDim2.new(0,LatestPage.TabFrame.Position.X.Offset + LatestPage.TabFrame.Size.X.Offset,0,0)
    else
        Page.TabFrame.Position = UDim2.new(0,0,0,0)
    end
    self.ScrollingMenu.CanvasSize = UDim2.new(0,Page.TabFrame.Position.X.Offset + Page.TabFrame.Size.X.Offset,0,0)
    self.Pages[#self.Pages+1] = Page
end

function TitlebarMenu:RemovePage(Page)
    table.remove(self.Pages, self:GetIDIndex(Page.ID))
    self.ScrollingMenu.CanvasSize = UDim2.new(0,self.ScrollingMenu.CanvasSize.Width.Offset - Page.TabFrame.Size.X.Offset,0,0)
    self:FixPageLayout()
end

function TitlebarMenu:SetActive(ID)
    for _, v in pairs(self.Pages) do
        v:SetState(v.ID == ID)
    end
end

function TitlebarMenu:FixPageLayout(IgnoreID)
    local PreviousPageSize = 0
    for _, v in pairs(self.Pages) do
        if IgnoreID ~= v.ID then
            v.TabFrame.Position = UDim2.new(0,PreviousPageSize,0,0)
        end
        PreviousPageSize += v.TabFrame.Size.X.Offset
    end
end

function TitlebarMenu:MovePage(ID, Index, IgnoreID)
    local PageIndex = self:GetIDIndex(ID)
    if PageIndex == Index then return end
    local Page = self.Pages[PageIndex]
    table.remove(self.Pages, PageIndex)
    table.insert(self.Pages, Index, Page)
    if IgnoreID then self:FixPageLayout(ID) end
end

function TitlebarMenu:BeingDragged(ID)
    local tab = self:GetIDTab(ID)
    local xpos = tab.TabFrame.Position.X.Offset + tab.TabFrame.Size.X.Offset / 2
    for i, v in pairs(self.Pages) do
        if v.ID ~=ID and xpos >= v.TabFrame.Position.X.Offset and xpos < v.TabFrame.Position.X.Offset + v.TabFrame.Size.X.Offset then
            self:MovePage(ID, i, true)
        end
    end
end
-- ID
function TitlebarMenu.new(Arguments, Parent)
    local self = GUIFrame.new(Arguments, Parent)
    self.ID = self.Arguments.ID or game:GetService("HttpService"):GenerateGUID(false)
    setmetatable(self,TitlebarMenu)
    self.TitlebarMenu = Instance.new("Frame", self.Parent)
    self.TitlebarMenu.Name = "TitlebarMenu"
    self.TitlebarMenu.Size = UDim2.new(1,0,0,24)
    ThemeManager.ColorSync(self.TitlebarMenu, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar,nil,nil,nil,true)
    self.TitlebarMenu.BorderSizePixel = 0
    self.ButtonsFrame = Instance.new("Frame", self.TitlebarMenu)
    self.ButtonsFrame.Size = UDim2.new(0,0,0,24)
    self.ButtonsFrame.ZIndex = 3
    ThemeManager.ColorSync(self.ButtonsFrame, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar,nil,nil,nil,true)
    self.ButtonsFrame.BorderSizePixel = 0
    self.ButtonsFrame.Name = "ButtonsFrame"
    local ButtonsFrameBorder = Instance.new("Frame", self.ButtonsFrame)
    ButtonsFrameBorder.Position = UDim2.new(0,0,1,-1)
    ButtonsFrameBorder.Size = UDim2.new(1,0,0,1)
    ButtonsFrameBorder.BorderSizePixel = 0
    ThemeManager.ColorSync(ButtonsFrameBorder, "BackgroundColor3", Enum.StudioStyleGuideColor.Border,nil,nil,nil,true)
    ButtonsFrameBorder.Name = "Border"
    ButtonsFrameBorder.ZIndex = 5
    self.ButtonContainer = Instance.new("Frame", self.ButtonsFrame)
    self.ButtonContainer.BackgroundTransparency = 1
    self.ButtonContainer.BorderSizePixel = 0
    self.ButtonContainer.Size = UDim2.new(1,0,1,0)
    self.ButtonContainer.Name = "ButtonContainer"
    local ButtonContainerLayout = Instance.new("UIListLayout", self.ButtonContainer)
    ButtonContainerLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.ScrollingMenu = Instance.new("ScrollingFrame", self.TitlebarMenu)
    self.ScrollingMenu.BackgroundTransparency = 1
    self.ScrollingMenu.Position = UDim2.new(1,0,0,0)
    self.ScrollingMenu.AnchorPoint = Vector2.new(1,0)
    self.ScrollingMenu.Size = UDim2.new(1,0,1,0)
    self.ScrollingMenu.CanvasSize = UDim2.new(0,0,0,0)
    self.ScrollingMenu.ScrollBarThickness = 0
    self.ScrollingMenu.ScrollingDirection = Enum.ScrollingDirection.X
    self.ScrollingMenu.ZIndex = 2
    self.ScrollingMenu.ClipsDescendants = false
    ButtonContainerLayout.Changed:Connect(function(p)
        if p ~= "AbsoluteContentSize" then return end
        self.ButtonsFrame.Size = UDim2.new(0,ButtonContainerLayout.AbsoluteContentSize.X, 1,0)
        self.ScrollingMenu.Size = UDim2.new(1,-ButtonContainerLayout.AbsoluteContentSize.X,1,0)
    end)
    self.TabContainer = Instance.new("Frame", self.ScrollingMenu)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Size = UDim2.new(1,0,1,0)
    self.TabContainer.ZIndex = 2
    self.TabContainer.Name = "TabContainer"
    --local TabContainerPadding = Instance.new("UIPadding", self.TabContainer)
    --TabContainerPadding.PaddingLeft, TabContainerPadding.PaddingRight = UDim.new(0,5), UDim.new(0,5)
    local TabContainerBorder = Instance.new("Frame", self.TitlebarMenu)
    TabContainerBorder.Name = "Border"
    TabContainerBorder.Position = UDim2.new(0,0,1,-1)
    TabContainerBorder.Size = UDim2.new(1,0,0,1)
    TabContainerBorder.BorderSizePixel = 0
    TabContainerBorder.ZIndex = 2
    ThemeManager.ColorSync(TabContainerBorder, "BackgroundColor3", Enum.StudioStyleGuideColor.Border)
    self.ContentContainers = Instance.new("Frame", self.Parent)
    self.ContentContainers.Name = "Content"
    self.ContentContainers.BackgroundTransparency = 1
    self.ContentContainers.Position = UDim2.new(0,0,0,24)
    self.ContentContainers.Size = UDim2.new(1,0,1,-24)
    self.Pages = {}
    self.Content = self.Parent
    GV.PluginTitlebarMenus[#GV.PluginTitlebarMenus+1] = self
    return self
end

return TitlebarMenu