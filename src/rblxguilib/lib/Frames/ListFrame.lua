local ListFrame = {}
ListFrame.__index = ListFrame
local GUIFrame = require(script.Parent.GUIFrame)
setmetatable(ListFrame,GUIFrame)
local Count = 0

function ListFrame.new(Name, Height, Parent)
    local self = GUIFrame.new(Parent)
    setmetatable(self,ListFrame)
    Count = Count + 1;
    if not Height then Height = 28 end
    self.Content = Instance.new("Frame", self.Parent)
    self.Content.BackgroundTransparency = 1
    self.Content.Size = UDim2.new(1,0,0,Height)
    self.Content.Name = Count
    if Name then self.Content.Name = self.Content.Name .. ": " .. Name end
    -- layout (used for stacking multiple elements in one row)
    self.Layout = Instance.new("UIGridLayout", self.Content)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.FillDirection = Enum.FillDirection.Vertical
    self.Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.Layout.Changed:Connect(function(p)
        if p == "AbsoluteCellCount" and self.Layout.AbsoluteCellCount.X > 0 then
            self.Layout.CellSize = UDim2.new(1/self.Layout.AbsoluteCellCount.X,0,1,0)
        end
    end)
    -- self.Padding for elements in frame
    self.Padding = Instance.new("UIPadding", self.Content)
    self.Padding.PaddingBottom, self.Padding.PaddingLeft, self.Padding.PaddingRight, self.Padding.PaddingTop = UDim.new(0,2), UDim.new(0,2), UDim.new(0,2), UDim.new(0,2)
    return self
end

return ListFrame