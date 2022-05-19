local Textbox = {}
Textbox.__index = Textbox

local util = require(script.Parent.Parent.Util)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(Textbox,GUIObject)

function Textbox.new(text, font, alignment, size, parent)
    local self = GUIObject.new(parent)
    setmetatable(self,Textbox)
    if not alignment then alignment = Enum.TextXAlignment.Center end
    if not font then font = Enum.Font.SourceSans end
    if not size then size = 15 end
    self.Textbox = Instance.new("TextLabel", self.Frame)
    self.Textbox.BackgroundTransparency = 1
    self.Textbox.Size = UDim2.new(1,0,1,0)
    self.Textbox.TextXAlignment = alignment
    self.Textbox.TextSize = size
    self.Textbox.Font = font
    self.Textbox.Text = text
    util.ColorSync(self.Textbox, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    self.Object = self.Textbox
    self.Object.Changed:Connect(function(p)
        if p == "Parent" then
            task.wait(0)
            self.Frame = self.Textbox.Parent
        end
    end)
    self.Frame = self.Textbox.Parent
    return self
end

return Textbox