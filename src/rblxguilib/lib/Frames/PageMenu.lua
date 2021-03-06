local PageMenu = {}
PageMenu.__index = PageMenu
local GUIFrame = require(script.Parent.GUIFrame)
local util = require(script.Parent.Parent.GUIUtil)
setmetatable(PageMenu,GUIFrame)

function PageMenu:GetIDIndex(ID)
    for i,v in pairs(self.Pages) do if v.ID == ID then return i end end
end

function PageMenu:GetIDTab(ID)
    return self.Pages[self:GetIDIndex(ID)]
end

function PageMenu:AddPage(Page)
    if #self.Pages > 0 then
        local LatestPage = self.Pages[#self.Pages]
        Page.TabFrame.Position = UDim2.new(0,LatestPage.TabFrame.Position.X.Offset + LatestPage.TabFrame.Size.X.Offset,0,0)
    end
    self.ScrollingMenu.CanvasSize = UDim2.new(0,Page.TabFrame.Position.X.Offset + Page.TabFrame.Size.X.Offset,0,0)
    self.Pages[#self.Pages+1] = Page
end

function PageMenu:SetActive(ID)
    for _, v in pairs(self.Pages) do
        v:SetState(v.ID == ID)
    end
end

function PageMenu:FixPageLayout(IgnoreID)
    local PreviousPageSize = 0
    for _, v in pairs(self.Pages) do
        if IgnoreID ~= v.ID then
            v.TabFrame.Position = UDim2.new(0,PreviousPageSize,0,0)
        end
        PreviousPageSize += v.TabFrame.Size.X.Offset
    end
end

function PageMenu:MovePage(ID, Index, IgnoreID)
    local PageIndex = self:GetIDIndex(ID)
    if PageIndex == Index then return end
    local Page = self.Pages[PageIndex]
    table.remove(self.Pages, PageIndex)
    table.insert(self.Pages, Index, Page)
    if IgnoreID then self:FixPageLayout(ID) end
end

function PageMenu:BeingDragged(ID)
    local tab = self:GetIDTab(ID)
    local xpos = tab.TabFrame.Position.X.Offset + tab.TabFrame.Size.X.Offset / 2
    for i, v in pairs(self.Pages) do
        if v.ID ~=ID and xpos >= v.TabFrame.Position.X.Offset and xpos < v.TabFrame.Position.X.Offset + v.TabFrame.Size.X.Offset then
            self:MovePage(ID, i, true)
        end
    end
end

function PageMenu.new(Parent)
    local self = GUIFrame.new(Parent)
    setmetatable(self,PageMenu)
    self.PageMenu = Instance.new("Frame", self.Parent)
    self.PageMenu.Name = "PageMenu"
    self.PageMenu.Size = UDim2.new(1,0,0,24)
    util.ColorSync(self.PageMenu, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar)
    self.PageMenu.BorderSizePixel = 0
    self.ScrollingMenu = Instance.new("ScrollingFrame", self.PageMenu)
    self.ScrollingMenu.BackgroundTransparency = 1
    self.ScrollingMenu.Size = UDim2.new(1,0,1,0)
    self.ScrollingMenu.CanvasSize = UDim2.new(0,0,0,0)
    self.ScrollingMenu.ScrollBarThickness = 0
    self.ScrollingMenu.ScrollingDirection = Enum.ScrollingDirection.X
    self.ScrollingMenu.ZIndex = 2
    self.TabContainer = Instance.new("Frame", self.ScrollingMenu)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Size = UDim2.new(1,0,1,0)
    self.TabContainer.ZIndex = 2
    self.TabContainer.Name = "TabContainer"
    local TabContainerPadding = Instance.new("UIPadding", self.TabContainer)
    TabContainerPadding.PaddingLeft, TabContainerPadding.PaddingRight = UDim.new(0,5), UDim.new(0,5)
    local TabContainerBorder = Instance.new("Frame", self.PageMenu)
    TabContainerBorder.Name = "Border"
    TabContainerBorder.Position = UDim2.new(0,0,1,-1)
    TabContainerBorder.Size = UDim2.new(1,0,0,1)
    TabContainerBorder.BorderSizePixel = 0
    util.ColorSync(TabContainerBorder, "BackgroundColor3", Enum.StudioStyleGuideColor.Border)
    self.ContentContainers = Instance.new("Frame", self.Parent)
    self.ContentContainers.Name = "Content"
    self.ContentContainers.BackgroundTransparency = 1
    self.ContentContainers.Position = UDim2.new(0,0,0,24)
    self.ContentContainers.Size = UDim2.new(1,0,1,-24)
    self.Pages = {}
    self.Content = self.Parent
    return self
end

return PageMenu