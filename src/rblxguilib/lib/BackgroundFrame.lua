local BackgroundFrame = {}
BackgroundFrame.__index = BackgroundFrame

local util = require(script.Parent.Util)
local GUIFrame = require(script.Parent.GUIElement)
setmetatable(BackgroundFrame,GUIFrame)


function BackgroundFrame.new(parent)
    if not parent then parent = _G.MainGUI end
    local self = GUIFrame.new()
    setmetatable(self,BackgroundFrame)
    -- generate background frame
    self.Frame = Instance.new("Frame", parent)
    util.ColorSync(self.Frame, "BackgroundColor3", Enum.StudioStyleGuideColor.MainBackground)
    self.Frame.Size = UDim2.new(1,0,1,0)
    self.Frame.Name = "Background"
    self.Frame.ZIndex = 0
    return self
end

return BackgroundFrame