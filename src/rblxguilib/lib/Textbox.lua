local Textbox = {}
Textbox.__index = Textbox

local util = require(script.Parent.Util)
local FrameMod = require(script.Parent.Frame)

function Textbox.new(text, font, alignment, parent)
    local self = {}
    setmetatable(self,Textbox)
    
    if not parent then
        parent = FrameMod.new().Frame
        parent.Name = "TextFrame"
    end
    if not alignment then alignment = Enum.TextXAlignment.Center end
    if not font then font = Enum.Font.SourceSans end
    self.Textbox = Instance.new("TextLabel", parent)
    self.Textbox.BackgroundTransparency = 1
    self.Textbox.Size = UDim2.new(1,0,1,0)
    self.Textbox.TextXAlignment = alignment
    self.Textbox.TextSize = 15
    self.Textbox.Font = font
    self.Textbox.Text = text
    self.Frame = parent
    util.ColorSync(self.Textbox, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    return self
end

return Textbox