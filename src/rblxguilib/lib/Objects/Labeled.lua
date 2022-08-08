local LabeledObject = {}
LabeledObject.__index = LabeledObject

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local TextboxMod = require(GV.ObjectsDir.Textbox)
local GUIObject = require(GV.ObjectsDir.GUIObject)
setmetatable(LabeledObject,GUIObject)

function LabeledObject:SetDisabled(State)
    self.Disabled = State
    for _, v in pairs(self.Objects) do v:SetDisabled(State) end
    if self.Disabled then
        self.Label.TextTransparency = 0.5
    else
        self.Label.TextTransparency = 0
    end
end

function LabeledObject:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function LabeledObject:AddObject(Object, Name, Size)
    Object:Move(self.Content, true)
    Size = util.GetScale(Size)
    if not Size then Size = UDim.new(1-self.TotalUsedScale, -self.TotalUsedOffset) end
    Object.MainMovable.Size = UDim2.new(Size.Scale,Size.Offset,1,0)
    Object.MainMovable.Position = UDim2.new(self.TotalUsedScale,self.TotalUsedOffset,0,0)
    self.TotalUsedScale += Size.Scale
    self.TotalUsedOffset += Size.Offset
    self[Name] = Object
    self.Objects[#self.Objects+1] = Object
end

function LabeledObject.new(Textbox, LabelSize, Objects, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,LabeledObject)
    self.Objects = {}
    self.TotalUsedScale = 0
    self.TotalUsedOffset = 0
    self.MainFrame = Instance.new("Frame", self.Parent)
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
    self.Content = Instance.new("Frame", self.MainFrame)
    self.Content.Name = "Content"
    self.Content.BackgroundTransparency = 1
    LabelSize = util.GetScale(LabelSize)
    if LabelSize then
        self.Label.Size = UDim2.new(LabelSize.Scale, LabelSize.Offset, 0, 20)
        self.Content.Size = UDim2.new(1-LabelSize.Scale, -LabelSize.Offset, 0, 20)
    else
        local function sync()
            self.Label.Size = UDim2.new(0,self.Label.TextBounds.X+self.Label.TextSize, 1, 0)
            self.Content.Size = UDim2.new(1,-(self.Label.TextBounds.X+self.Label.TextSize), 0, 20)
        end
        self.Label.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
    end
    self.TotalUsedScale = 0
    if type(Objects) == "table" and Objects[1] and type(Objects[1] == "table") then
        for _, v in pairs(Objects) do
            self:AddObject(v[1], v[2], v[3])
        end
    else
        self:AddObject(Objects, "Object")
    end
    self.MainMovable = self.MainFrame
    return self
end

return LabeledObject