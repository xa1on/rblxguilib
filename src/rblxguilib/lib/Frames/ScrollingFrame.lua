local ScrollingFrame = {}
ScrollingFrame.__index = ScrollingFrame

local util = require(script.Parent.Parent.GUIUtil)
local GUIFrame = require(script.Parent.GUIFrame)
setmetatable(ScrollingFrame,GUIFrame)

ScrollingFrame.Images = {
    bottom = "http://www.roblox.com/asset/?id=9599518795",
    mid = "http://www.roblox.com/asset/?id=9599545837",
    top = "http://www.roblox.com/asset/?id=9599519108"
}

-- updaing the scrolling frame to fit window size based on element size
function ScrollingFrame:UpdateFrameSize()
    local ScrollbarVisibility = self.Content.AbsoluteWindowSize.Y < self.Content.AbsoluteCanvasSize.Y
    self.Content.CanvasSize = UDim2.new(0,0,0,self.Layout.AbsoluteContentSize.Y)
    self.ScrollbarBackground.Visible = ScrollbarVisibility
end

function ScrollingFrame.new(BarSize, Parent)
    local self = GUIFrame.new(Parent)
    setmetatable(self, ScrollingFrame)
    -- scroll bar background
    self.ScrollbarBackground = Instance.new("Frame", self.Parent)
    self.ScrollbarBackground.Size = UDim2.new(0,BarSize or 15,1,0)
    self.ScrollbarBackground.Position = UDim2.new(1,-(BarSize or 15),0,0)
    self.ScrollbarBackground.Name = "ScrollbarBackground"
    util.ColorSync(self.ScrollbarBackground, "BackgroundColor3", Enum.StudioStyleGuideColor.ScrollBarBackground)

    -- scrolling frame
    self.Content = Instance.new("ScrollingFrame", self.Parent)
    self.Content.BackgroundTransparency = 1
    self.Content.Size = UDim2.new(1,0,1,0)
    self.Content.ScrollBarThickness = BarSize or 15
    self.Content.BottomImage, self.Content.MidImage, self.Content.TopImage = self.Images.bottom, self.Images.mid, self.Images.top
    self.Content.ScrollingDirection = Enum.ScrollingDirection.Y
    self.Content.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    self.Content.Name = "ScrollingFrame"
    self.Content.ZIndex = 2
    util.ColorSync(self.Content, "ScrollBarImageColor3", Enum.StudioStyleGuideColor.ScrollBar)
    util.ColorSync(self.Content, "BorderColor3", Enum.StudioStyleGuideColor.Border)

    -- list layout for later elements
    self.Layout = Instance.new("UIListLayout", self.Content)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- updating the scrollingframe whenever things are added or the size of the widow is changed
    self.Layout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then self:UpdateFrameSize() end
    end)
    self.Parent.Changed:Connect(function(p)
        if p == "AbsoluteSize" then self:UpdateFrameSize() end
    end)
    return self
end

return ScrollingFrame