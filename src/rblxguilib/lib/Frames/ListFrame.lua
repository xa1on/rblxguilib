local ListFrame = {}
ListFrame.__index = ListFrame
local GUIFrame = require(script.Parent.GUIFrame)
setmetatable(ListFrame,GUIFrame)

function ListFrame.new(Name, Height, Parent)
    local self = GUIFrame.new(Parent)
    setmetatable(self,ListFrame)
    if not Height then Height = 28 end
    self.Frame = Instance.new("Frame", self.Parent)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Size = UDim2.new(1,0,0,Height)
    if Name then self.Frame.Name = Name end
    -- layout (used for stacking multiple elements in one row)
    self.Layout = Instance.new("UIGridLayout", self.Frame)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.FillDirection = Enum.FillDirection.Vertical
    self.Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.Layout.Changed:Connect(function(p)
        if p == "AbsoluteCellCount" then
            self.Layout.CellSize = UDim2.new(1/self.Layout.AbsoluteCellCount.X,0,1,0)
        end
    end)
    -- self.Padding for elements in frame
    self.Padding = Instance.new("UIPadding", self.Frame)
    self.Padding.PaddingBottom, self.Padding.PaddingLeft, self.Padding.PaddingRight, self.Padding.PaddingTop = UDim.new(0,2), UDim.new(0,2), UDim.new(0,2), UDim.new(0,2)
    return self
end

return ListFrame