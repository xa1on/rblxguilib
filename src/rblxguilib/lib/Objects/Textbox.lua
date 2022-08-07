local Textbox = {}
Textbox.__index = Textbox

local util = require(_G.LibraryDir.GUIUtil)
local GUIObject = require(_G.ObjectsDir.GUIObject)
setmetatable(Textbox,GUIObject)

function Textbox:SetDisabled(State)
    self.Disabled = State
    if self.Disabled then
        self.Textbox.TextTransparency = 0.5
    else
        self.Textbox.TextTransparency = 0
    end
end

function Textbox:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function Textbox.new(Text, Font, Alignment, TextSize, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,Textbox)
    Alignment = Alignment or Enum.TextXAlignment.Center
    Font = Font or Enum.Font.SourceSans
    TextSize = TextSize or 15
    self.Textbox = Instance.new("TextLabel", self.Parent)
    self.Textbox.BackgroundTransparency = 1
    self.Textbox.Size = UDim2.new(1,0,1,0)
    self.Textbox.TextXAlignment = Alignment
    self.Textbox.TextSize = TextSize
    self.Textbox.Font = Font
    self.Textbox.Text = Text
    util.ColorSync(self.Textbox, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    self.Object = self.Textbox
    self.MainMovable = self.Textbox
    return self
end

return Textbox