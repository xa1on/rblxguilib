local function requireall(p)
    _G.PluginObject = p
    local library = {}
    for _, i in pairs(script.Parent.lib:GetChildren()) do
        if i:IsA("ModuleScript") then
            library[i.Name] = require(i)
        end
    end
    return library
end
return requireall