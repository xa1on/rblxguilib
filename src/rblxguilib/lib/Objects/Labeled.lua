local LabeledObject = {}
LabeledObject.__index = LabeledObject

local util = require(script.Parent.Parent.GUIUtil)
local TextboxMod = require(script.Parent.Textbox)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(LabeledObject,GUIObject)

function LabeledObject:SetDisabled(State)
    self.Disabled = State
    self.Object:SetDisabled(State)
    if self.Disabled then
        self.Label.TextTransparency = 0.5
    else
        self.Label.TextTransparency = 0
    end
end

function LabeledObject:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function LabeledObject.new(Textbox, LabelSize, Object, Parent)
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
    self.Label = self.TextboxTable.Textbox
    self.SecondaryFrame = Instance.new("Frame", self.MainFrame)
    self.SecondaryFrame.Name = "SecondaryFrame"
    self.SecondaryFrame.BackgroundTransparency = 1
    LabelSize = util.GetScale(LabelSize)
    if LabelSize then
        self.Label.Size = UDim2.new(LabelSize.Scale, LabelSize.Offset, 0, 20)
        self.SecondaryFrame.Size = UDim2.new(1-LabelSize.Scale, -LabelSize.Offset, 0, 20)
    else
        local function sync()
            self.Label.Size = UDim2.new(0,self.Label.TextBounds.X+self.Label.TextSize, 1, 0)
            self.SecondaryFrame.Size = UDim2.new(1,-(self.Label.TextBounds.X+self.Label.TextSize), 0, 20)
        end
        self.Label.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
        sync()
    end
    Object:Move(self.SecondaryFrame, true)
    Object.MainMovable.Size = UDim2.new(1,0,1,0)
    self.Object = Object
    self.MainMovable = self.MainFrame
    return self
end

return LabeledObject