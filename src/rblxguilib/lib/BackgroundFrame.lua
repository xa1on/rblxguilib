local BackgroundFrame = {}
BackgroundFrame.__index = BackgroundFrame

local util = require(script.Parent.Util)

function BackgroundFrame.new(parent)
    local self = {}
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