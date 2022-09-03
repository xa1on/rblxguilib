local Textbox = {}
Textbox.__index = Textbox

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local GUIObject = require(GV.ObjectsDir.GUIObject)
local ColorManager = require(GV.ManagersDir.ColorManager)
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

-- Text, Font, Alignment, TextSize
function Textbox.new(Arguments, Parent)
    local self = GUIObject.new(Arguments, Parent)
    setmetatable(self,Textbox)
    local Alignment = self.Arguments.Alignment or Enum.TextXAlignment.Center
    local Font = self.Arguments.Font or Enum.Font.SourceSans
    local TextSize = self.Arguments.TextSize or self.Arguments.FontSize or 15
    self.Textbox = Instance.new("TextLabel", self.Parent)
    self.Textbox.BackgroundTransparency = 1
    self.Textbox.Size = UDim2.new(1,0,1,0)
    self.Textbox.TextXAlignment = Alignment
    self.Textbox.TextSize = TextSize
    self.Textbox.Font = Font
    self.Textbox.Text = self.Arguments.Text
    ColorManager.ColorSync(self.Textbox, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    self.Object = self.Textbox
    self.MainMovable = self.Textbox
    return self
end

return Textbox