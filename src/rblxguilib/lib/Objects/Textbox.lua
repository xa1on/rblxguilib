local Textbox = {}
Textbox.__index = Textbox

local util = require(script.Parent.Parent.Util)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(Textbox,GUIObject)

function Textbox.new(Text, Font, Alignment, Size, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,Textbox)
    Alignment = Alignment or Enum.TextXAlignment.Center
    Font = Font or Enum.Font.SourceSans
    Size = Size or 15
    self.Textbox = Instance.new("TextLabel", self.Frame)
    self.Textbox.BackgroundTransparency = 1
    self.Textbox.Size = UDim2.new(1,0,1,0)
    self.Textbox.TextXAlignment = Alignment
    self.Textbox.TextSize = Size
    self.Textbox.Font = Font
    self.Textbox.Text = Text
    util.ColorSync(self.Textbox, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    self.Object = self.Textbox
    self.Frame = self.Textbox.Parent
    self.MainMovable = self.Textbox
    return self
end

return Textbox