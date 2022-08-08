local BackgroundFrame = {}
BackgroundFrame.__index = BackgroundFrame

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local GUIFrame = require(GV.FramesDir.GUIFrame)
setmetatable(BackgroundFrame,GUIFrame)


function BackgroundFrame.new(Parent)
    local self = GUIFrame.new(Parent)
    setmetatable(self,BackgroundFrame)
    -- generate background frame
    self.Content = Instance.new("Frame", Parent)
    util.ColorSync(self.Content, "BackgroundColor3", Enum.StudioStyleGuideColor.MainBackground)
    self.Content.Size = UDim2.new(1,0,1,0)
    self.Content.Name = "Background"
    self.Content.ZIndex = 0
    return self
end

return BackgroundFrame