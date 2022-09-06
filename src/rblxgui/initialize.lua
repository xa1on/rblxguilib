local GV = require(script.Parent.lib.PluginGlobalVariables)
local function requireall(p,id)
    GV.PluginObject = p
    local library = {}
    if id then require(script.Parent.lib.PluginGlobalVariables).PluginID = id end
    for _, i in pairs(script.Parent.lib:GetDescendants()) do
        if i:IsA("ModuleScript") then
            library[i.Name] = require(i)
        end
    end
    return library
end
return requireall