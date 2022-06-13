local Section = {}
Section.__index = Section

local util = require(script.Parent.Parent.Util)
local GUIFrame = require(script.Parent.GUIFrame)
local TextboxMod = require(script.Parent.Parent.Objects.Textbox)
setmetatable(Section,GUIFrame)

Section.Images = {
    Open = "http://www.roblox.com/asset/?id=9666389442",
    Closed = "http://www.roblox.com/asset/?id=9666389853"
}

function Section:SetState(State)
    self.Open = State
    self.Frame.Visible = self.Open
    if self.Open then self.CollapseImage.Image = self.Images.Open else self.CollapseImage.Image = self.Images.Closed end
end

function Section:Toggle()
    self:SetState(not self.Open)
end

function Section.new(Name, Text, Open, Parent)
    local self = GUIFrame.new(Parent)
    setmetatable(self, Section)
    if not Text then Text = Name end
    self.Open = Open

    self.Collapse = Instance.new("Frame", self.Parent)
    self.Collapse.BackgroundTransparency = 1
    self.Collapse.Size = UDim2.new(1,0,0,0)
    self.Collapse.AutomaticSize = Enum.AutomaticSize.Y
    self.Collapse.Name = Name .. " Section"

    self.CollapseLayout = Instance.new("UIListLayout", self.Collapse)
    self.CollapseLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.CollapseLayout.FillDirection = Enum.FillDirection.Vertical
    self.CollapseLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    --self.CollapseLayout.Padding = UDim.new(0,5)

    self.Label = Instance.new("TextButton", self.Collapse)
    self.Label.Text = ""
    self.Label.Name = "Section Label"
    self.Label.Size = UDim2.new(1,0,0,30)
    util.ColorSync(self.Label, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar)
    self.Label.BorderSizePixel = 0
    self.Label.MouseButton1Click:Connect(function() self:Toggle() end)

    self.LabelPadding = Instance.new("UIPadding", self.Label)
    self.LabelPadding.PaddingBottom, self.LabelPadding.PaddingLeft, self.LabelPadding.PaddingRight, self.LabelPadding.PaddingTop = UDim.new(0,5), UDim.new(0,5), UDim.new(0,5), UDim.new(0,5)
    
    self.LabelLayout = Instance.new("UIListLayout", self.Label)
    self.LabelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.LabelLayout.FillDirection = Enum.FillDirection.Horizontal
    self.LabelLayout.Padding = UDim.new(0,5)

    self.CollapseImage = Instance.new("ImageLabel", self.Label)
    self.CollapseImage.BackgroundTransparency = 1
    self.CollapseImage.Size = UDim2.new(0,20,0,20)
    util.ColorSync(self.CollapseImage, "ImageColor3", Enum.StudioStyleGuideColor.MainText)

    if type(Text) == "string" then
        self.TextboxTable = TextboxMod.new(Text, Enum.Font.SourceSansBold, Enum.TextXAlignment.Left, 16, self.Label)
    else
        self.TextboxTable = Text
        Text:Move(self.Label)
    end

    self.Frame = Instance.new("Frame", self.Collapse)
    self.Frame.Size = UDim2.new(1,-15,0,0)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Visible = self.Open
    self.Layout = Instance.new("UIListLayout", self.Frame)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self:SetState(Open)

    return self
end

return Section