local ListFrame = {}
ListFrame.__index = ListFrame
local GUIFrame = require(script.Parent.GUIFrame)
setmetatable(ListFrame,GUIFrame)

function ListFrame.new(name, parent, height)
    if not parent then parent = _G.MainGUI end
    local self = GUIFrame.new(Instance.new("Frame", parent))
    setmetatable(self,ListFrame)
    if not height then height = 28 end
    self.Frame.BackgroundTransparency = 1
    self.Frame.Size = UDim2.new(1,0,0,height)
    if name then self.Frame.Name = name end
    -- layout (used for stacking multiple elements in one row)
    self.Layout = Instance.new("UIGridLayout", self.Frame)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.FillDirection = Enum.FillDirection.Vertical
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