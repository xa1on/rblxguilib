local Frame = {}
Frame.__index = Frame


function Frame.new(parent, height)
    local self = {}
    setmetatable(self,Frame)
    if not height then height = 28 end
    if not parent then parent = _G.MainUI end
    self.Frame = Instance.new("Frame", parent)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Size = UDim2.new(1,0,0,height)
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

return Frame