_G.LibraryDir = script.Parent.lib
_G.FramesDir = _G.LibraryDir.Frames
_G.ObjectsDir = _G.LibraryDir.Objects
_G.ManagersDir = _G.LibraryDir.Managers
_G.PromptsDir = _G.LibraryDir.Prompts
local function requireall(p)
    _G.PluginObject = p
    local library = {}
    for _, i in pairs(script.Parent.lib:GetDescendants()) do
        if i:IsA("ModuleScript") then
            library[i.Name] = require(i)
        end
    end
    return library
end
return requireall