local ScrollingFrame = {}
ScrollingFrame.__index = ScrollingFrame

local util = require(script.Parent.Util)

ScrollingFrame.Images = {
    top = "http://www.roblox.com/asset/?id=9599518795",
    center = "http://www.roblox.com/asset/?id=9599545837",
    bottom = "http://www.roblox.com/asset/?id=9599519108"}

-- updaing the scrolling frame to fit window size based on element size
function ScrollingFrame:UpdateFrameSize()
    local ScrollbarVisibility = self.Frame.AbsoluteWindowSize.Y < self.Frame.AbsoluteCanvasSize.Y
    self.Frame.CanvasSize = UDim2.new(0,0,0,self.Layout.AbsoluteContentSize.Y)
    self.ScrollbarBackground.Visible = ScrollbarVisibility
end

function ScrollingFrame.new(parent)
    local self = {}
    setmetatable(self, ScrollingFrame)
    -- scroll bar background
    self.ScrollbarBackground = Instance.new("Frame", parent)
    self.ScrollbarBackground.Size = UDim2.new(0,15,1,0)
    self.ScrollbarBackground.Position = UDim2.new(1,-15,0,0)
    self.ScrollbarBackground.Name = "ScrollbarBackground"
    util.ColorSync(self.ScrollbarBackground, "BackgroundColor3", Enum.StudioStyleGuideColor.ScrollBarBackground)

    -- scrolling frame
    self.Frame = Instance.new("ScrollingFrame", parent)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Size = UDim2.new(1,0,1,0)
    self.Frame.ScrollBarThickness = 15
    self.Frame.BottomImage, self.Frame.MidImage, self.Frame.TopImage = self.Images.top, self.Images.center, self.Images.bottom
    self.Frame.ScrollingDirection = Enum.ScrollingDirection.Y
    self.Frame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    self.Frame.Name = "ScrollingFrame"
    self.Frame.ZIndex = 2
    util.ColorSync(self.Frame, "ScrollBarImageColor3", Enum.StudioStyleGuideColor.ScrollBar)
    util.ColorSync(self.Frame, "BorderColor3", Enum.StudioStyleGuideColor.Border)

    -- list layout for later elements
    self.Layout = Instance.new("UIListLayout", self.Frame)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- updating the scrollingframe whenever things are added or the size of the widow is changed
    self.Layout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then self:UpdateFrameSize() end
    end)
    parent.Changed:Connect(function(p)
        if p == "AbsoluteSize" then self:UpdateFrameSize() end
    end)
    return self
end

return ScrollingFrame