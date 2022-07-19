local LabeledObject = {}
LabeledObject.__index = LabeledObject

local util = require(script.Parent.Parent.GUIUtil)
local TextboxMod = require(script.Parent.Textbox)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(LabeledObject,GUIObject)

function LabeledObject.new(Textbox, LabelSize, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,LabeledObject)
    self.MainFrame = Instance.new("Frame", self.Frame)
    self.MainFrame.BackgroundTransparency = 1
    self.MainFrame.Name = "MainFrame"
    self.MainLayout = Instance.new("UIListLayout", self.MainFrame)
    self.MainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.MainLayout.FillDirection = Enum.FillDirection.Horizontal
    self.MainPadding = Instance.new("UIPadding", self.MainFrame)
    self.MainPadding.PaddingBottom, self.MainPadding.PaddingLeft, self.MainPadding.PaddingRight, self.MainPadding.PaddingTop = UDim.new(0,2), UDim.new(0,6), UDim.new(0,6), UDim.new(0,2)
    if type(Textbox) == "string" then
        self.TextboxTable = TextboxMod.new(Textbox, nil, Enum.TextXAlignment.Left, 14, self.MainFrame)
    else
        self.TextboxTable = Textbox
        Textbox:Move(self.MainFrame, true)
    end
    self.Textbox = self.TextboxTable.Textbox
    self.SecondaryFrame = Instance.new("Frame", self.MainFrame)
    self.SecondaryFrame.Name = "SecondaryFrame"
    if LabelSize then
        if type(LabelSize) == "userdata" then
            self.Textbox.Size = UDim2.new(LabelSize.Scale, LabelSize.Offset, 0, 20)
            self.SecondaryFrame.Size = UDim2.new(1-LabelSize.Scale, -LabelSize.Offset, 0, 20)
        elseif type(LabelSize) == "number" then
            self.Textbox.Size = UDim2.new(LabelSize, 0, 0, 20)
            self.SecondaryFrame.Size = UDim2.new(1-LabelSize, 0, 0, 20)
        else
            self.Textbox.Size = UDim2.new(0.5, 0, 0, 20)
            self.SecondaryFrame.Size = UDim2.new(0.5, 0, 0, 20)
        end
    else
        local function sync()
            self.Textbox.Size = UDim2.new(0,self.Textbox.TextBounds.X+self.Textbox.TextSize, 1, 0)
            self.SecondaryFrame.Size = UDim2.new(1,-(self.Textbox.TextBounds.X+self.Textbox.TextSize), 0, 20)
        end
        self.Textbox.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
        sync()
    end
    self.MainMovable = self.MainFrame
    return self
end

return LabeledObject