-- template for classes

local temp = {}
temp.__index = temp


function temp.new()
    local self = {}
    setmetatable(self,temp)
    return self
end

return temp