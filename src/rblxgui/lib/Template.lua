-- template for classes

--inheritance
--local GUIElement = require(GV.LibraryDir.GUIElement)
--setmetatable(,GUIElement)

local temp = {}
temp.__index = temp


function temp.new()
    --self = GUIElement.new()
    local self = {}
    setmetatable(self,temp)
    return self
end

return temp