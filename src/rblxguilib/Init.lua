function requireall(p)
    _G.PluginObject = p
    local library = {}
    for _, i in pairs(script.Parent:GetChildren()) do
        if i.Name ~= "init" and i:IsA("ModuleScript") then
            library[i.Name] = require(i)
        end
    end
    return library
end
return requireall