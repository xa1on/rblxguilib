local BackgroundFrame = {}
BackgroundFrame.__index = BackgroundFrame

local util = require(script.Parent.Parent.Util)
local GUIFrame = require(script.Parent.GUIFrame)
setmetatable(BackgroundFrame,GUIFrame)


function BackgroundFrame.new(Parent)
    local self = GUIFrame.new(Parent)
    setmetatable(self,BackgroundFrame)
    -- generate background frame
    self.Frame = Instance.new("Frame", Parent)
    util.ColorSync(self.Frame, "BackgroundColor3", Enum.StudioStyleGuideColor.MainBackground)
    self.Frame.Size = UDim2.new(1,0,1,0)
    self.Frame.Name = "Background"
    self.Frame.ZIndex = 0
    return self
end

return BackgroundFrame