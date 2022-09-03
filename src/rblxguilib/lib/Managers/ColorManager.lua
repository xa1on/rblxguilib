local m = {}
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local EventManager = require(GV.ManagersDir.EventManager)
local util = require(GV.LibraryDir.GUIUtil)

-- syncs colors with studio theme
local syncedelements = {}

function m.ColorSync(element, property, enum, enum2, accent, accenttheme)
    syncedelements[#syncedelements + 1] = {element, property, enum, enum2, accent, accenttheme}
    m.MatchColor(element, property, enum, enum2, accent, accenttheme)
end

function m.MatchColor(element, property, enum, enum2, accent, accenttheme)
    local Theme = settings().Studio.Theme
    if accent and (((accenttheme) and accenttheme == tostring(Theme)) or not accenttheme) then
        element[property] = m.AccentColor
    else
        element[property] = Theme:GetColor(enum, enum2)
    end
end

function m.ReloadTheme()
    for _, v in pairs(syncedelements) do
        m.MatchColor(v[1], v[2], v[3], v[4], v[5], v[6])
    end
end

function m.UpdateAccentColor(newcolor)
    m.AccentColor = newcolor
    m.ReloadTheme()
    GV.PluginObject:SetSetting("PluginGUIAccent", m.Color3ToText(m.AccentColor))
end

EventManager.AddConnection(settings().Studio.ThemeChanged, function()
    m.ReloadTheme()
end)

function m.Color3ToText(color)
    return "[" .. util.RoundNumber(color.R*255, 1) .. ", " .. util.RoundNumber(color.G*255, 1) .. ", " .. util.RoundNumber(color.B*255, 1) .. "]"
end

function m.TextToColor3(text)
    local numbers = {}
    for i in text:gmatch("[%.%d]+") do
        numbers[#numbers+1] = tonumber(i)
        if #numbers == 3 then break end
    end
    return Color3.fromRGB(numbers[1] or 0, numbers[2] or 0, numbers[3] or 0)
end

m.DefaultAccentColor = Color3.fromRGB(53, 181, 255)
m.AccentColor = m.TextToColor3(GV.PluginObject:GetSetting("PluginGUIAccent") or m.Color3ToText(m.DefaultAccentColor))

return m