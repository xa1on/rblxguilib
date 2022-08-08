local GV = require(script.Parent.lib.PluginGlobalVariables)
local function requireall(p)
    GV.PluginObject = p
    local library = {}
    for _, i in pairs(script.Parent.lib:GetDescendants()) do
        if i:IsA("ModuleScript") then
            library[i.Name] = require(i)
        end
    end
    return library
end
return requireall