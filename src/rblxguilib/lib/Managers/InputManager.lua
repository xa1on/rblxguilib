local m = {}

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local EventManager = require(GV.ManagersDir.EventManager)

m.InputFieldEvents = {}
m.InputFrames = {}
function m.AddInputEvent(Event, func)
    m.InputFieldEvents[#m.InputFieldEvents+1] = {Event, func}
    for _, v in pairs(m.InputFrames) do
        EventManager.AddConnection(v[Event], func)
    end
end

function m.AddInput(Frame)
    m.InputFrames[#m.InputFrames + 1] = Frame
    for _, v in pairs(m.InputFieldEvents) do
        EventManager.AddConnection(Frame[v[1]], v[2])
    end
end

return m