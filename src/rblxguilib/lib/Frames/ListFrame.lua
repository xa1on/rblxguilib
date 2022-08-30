local ListFrame = {}
ListFrame.__index = ListFrame
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local GUIFrame = require(GV.FramesDir.GUIFrame)
setmetatable(ListFrame,GUIFrame)
local Count = 0


-- Name, Height
function ListFrame.new(Arguments, Parent)
    local self = GUIFrame.new(Arguments, Parent)
    setmetatable(self,ListFrame)
    Count = Count + 1;
    self.Arguments.Height = self.Arguments.Height or 28
    self.Content = Instance.new("Frame", self.Parent)
    self.Content.BackgroundTransparency = 1
    self.Content.Size = UDim2.new(1,0,0,self.Arguments.Height)
    self.Content.Name = Count
    if self.Arguments.Name then self.Content.Name = self.Content.Name .. ": " .. self.Arguments.Name end
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