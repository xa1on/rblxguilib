local m = {}

local GV = require(script.Parent.Parent.PluginGlobalVariables)
m.EventList = {}

function m.AddConnection(Connection, func)
    m.EventList[#m.EventList+1] = Connection:Connect(func)
end

GV.PluginObject.Unloading:Connect(function()
    for _, v in pairs(m.EventList) do
        v:Disconnect()
    end
end)

return m