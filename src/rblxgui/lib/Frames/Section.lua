local Section = {}
Section.__index = Section

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local GUIFrame = require(GV.FramesDir.GUIFrame)
local TextboxMod = require(GV.ObjectsDir.Textbox)
local ThemeManager = require(GV.ManagersDir.ThemeManager)
setmetatable(Section,GUIFrame)

Section.Images = {
    Open = "http://www.roblox.com/asset/?id=9666389442",
    Closed = "http://www.roblox.com/asset/?id=9666389853"
}

function Section:SetState(State)
    self.Open = State
    self.Content.Visible = self.Open
    if self.Open then self.CollapseImage.Image = self.Images.Open else self.CollapseImage.Image = self.Images.Closed end
end

function Section:Toggle()
    self:SetState(not self.Open)
end

-- Text, Open
function Section.new(Arguments, Parent)
    local self = GUIFrame.new(Arguments, Parent)
    setmetatable(self, Section)
    self.Open = self.Arguments.Open

    self.Collapse = Instance.new("Frame", self.Parent)
    self.Collapse.BackgroundTransparency = 1
    self.Collapse.Size = UDim2.new(1,0,0,0)
    self.Collapse.AutomaticSize = Enum.AutomaticSize.Y

    self.CollapseLayout = Instance.new("UIListLayout", self.Collapse)
    self.CollapseLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.CollapseLayout.FillDirection = Enum.FillDirection.Vertical
    self.CollapseLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    --self.CollapseLayout.Padding = UDim.new(0,5)

    self.Label = Instance.new("TextButton", self.Collapse)
    self.Label.Text = ""
    self.Label.Name = "Section Label"
    self.Label.Size = UDim2.new(2,0,0,25)
    self.Label.BorderSizePixel = 0
    ThemeManager.ColorSync(self.Label, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar)
    self.Label.MouseButton1Click:Connect(function() self:Toggle() end)
    util.HoverIcon(self.Label, "rbxasset://SystemCursors/PointingHand")

    self.LabelFrame = Instance.new("Frame", self.Label)
    self.LabelFrame.AnchorPoint = Vector2.new(0.5,0)
    self.LabelFrame.Position = UDim2.new(0.5,0,0,0)
    self.LabelFrame.Size = UDim2.new(0.5,0,0,25)
    self.LabelFrame.BackgroundTransparency = 1
    
    self.LabelLayout = Instance.new("UIListLayout", self.LabelFrame)
    self.LabelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.LabelLayout.FillDirection = Enum.FillDirection.Horizontal

    self.CollapseImageFrame = Instance.new("Frame", self.LabelFrame)
    self.CollapseImageFrame.Size = UDim2.new(0,25,0,25)
    self.CollapseImageFrame.BackgroundTransparency = 1

    self.CollapseTextboxFrame = Instance.new("Frame", self.LabelFrame)
    self.CollapseTextboxFrame.Size = UDim2.new(1,-25,0,25)
    self.CollapseTextboxFrame.BackgroundTransparency = 1

    self.CollapseImage = Instance.new("ImageLabel", self.CollapseImageFrame)
    self.CollapseImage.BackgroundTransparency = 1
    self.CollapseImage.AnchorPoint = Vector2.new(0.5,0.5)
    self.CollapseImage.Position = UDim2.new(0.5,0,0.5,0)
    self.CollapseImage.Size = UDim2.new(0,15,0,15)
    ThemeManager.ColorSync(self.CollapseImage, "ImageColor3", Enum.StudioStyleGuideColor.MainText)

    local Textbox = self.Arguments.Textbox or self.Arguments.Text
    if type(Textbox) == "string" then
        self.TextboxTable = TextboxMod.new({Text = Textbox, Font = Enum.Font.SourceSansBold, Alignment = Enum.TextXAlignment.Left, TextSize = 15}, self.CollapseTextboxFrame)
    else
        self.TextboxTable = Textbox
        Textbox:Move(self.CollapseTextboxFrame, true)
    end
    self.TextboxTable.Arguments.Unpausable = true
    self.Textbox = self.TextboxTable.Textbox
    self.Collapse.Name = "Section - " .. self.Textbox.Text
    self.Textbox.AnchorPoint = Vector2.new(0,0.5)
    self.Textbox.Position = UDim2.new(0,0,0.5,0)

    self.Content = Instance.new("Frame", self.Collapse)
    self.Content.Size = UDim2.new(1,-15,0,0)
    self.Content.BackgroundTransparency = 1
    self.Content.Visible = self.Open
    self.Content.Name = "Contents"

    self.Layout = Instance.new("UIListLayout", self.Content)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self:SetState(self.Arguments.Open)

    local function syncContentSize()
        self.Content.Size = UDim2.new(1, -15, 0, self.Layout.AbsoluteContentSize.Y);
    end
    syncContentSize()
    self.Layout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then
            syncContentSize()
        end
    end)

    return self
end

return Section