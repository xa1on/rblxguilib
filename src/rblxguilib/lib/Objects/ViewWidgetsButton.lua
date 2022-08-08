local ViewWidgetsButton = {}
ViewWidgetsButton.__index = ViewWidgetsButton

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local TitlebarButton = require(GV.ObjectsDir.TitlebarButton)
setmetatable(ViewWidgetsButton,TitlebarButton)

function ViewWidgetsButton.new(PageMenu)
    local self = TitlebarButton.new("VIEW", PageMenu, nil, false)
    setmetatable(self,ViewWidgetsButton)
    self.PluginMenu = GV.PluginObject:CreatePluginMenu(math.random(), "View Menu")

    return self
end

return ViewWidgetsButton