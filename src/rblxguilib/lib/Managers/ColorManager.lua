local m = {}
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local EventManager = require(GV.ManagersDir.EventManager)
local util = require(GV.LibraryDir.GUIUtil)

-- syncs colors with studio theme
local syncedelements = {}
m.DefaultAccentColor = Color3.fromRGB(53, 181, 255)
m.DefaultThemeColor = Color3.new(0.5,0.5,0.5)

function m.AddColor(c1, c2)
    return Color3.new(c1.R + c2.R, c1.G + c2.G, c1.B + c2.B)
end
function m.SubColor(c1, c2)
    return Color3.new(c1.R - c2.R, c1.G - c2.G, c1.B - c2.B)
end
function m.MulitplyColor(c1,c2)
    return Color3.new(c1.R * c2.R, c1.G * c2.G, c1.B * c2.B)
end

function m.ColorSync(element, property, enum, enum2, accent, accenttheme, ignoretheme)
    syncedelements[#syncedelements + 1] = {element, property, enum, enum2, accent, accenttheme, ignoretheme}
    m.MatchColor(element, property, enum, enum2, accent, accenttheme, ignoretheme)
end

function m.MatchColor(element, property, enum, enum2, accent, accenttheme, ignoretheme)
    local Theme = settings().Studio.Theme
    if accent and (((accenttheme) and accenttheme == tostring(Theme)) or not accenttheme) then
        element[property] = m.AccentColor
    else
        local ThemeColor = Theme:GetColor(enum, enum2)
        if not ignoretheme then
            element[property] = m.AddColor(m.MulitplyColor(m.SubColor(Color3.new(1,1,1), m.MulitplyColor(m.ThemeColor, Color3.new(2,2,2))), m.MulitplyColor(ThemeColor, ThemeColor)), m.MulitplyColor(m.MulitplyColor(ThemeColor, m.ThemeColor), Color3.new(2,2,2)))
        else
            element[property] = ThemeColor
        end
    end
end

function m.ReloadTheme()
    for _, v in pairs(syncedelements) do
        m.MatchColor(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
    end
end

function m.UpdateAccentColor(newcolor)
    m.AccentColor = newcolor
    m.ReloadTheme()
    GV.PluginObject:SetSetting("PluginGUIAccent", m.Color3ToText(m.AccentColor))
end
function m.UpdateThemeColor(newcolor)
    m.ThemeColor = newcolor
    m.ReloadTheme()
    GV.PluginObject:SetSetting("PluginGUITheme", m.Color3ToText(m.ThemeColor))
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

m.AccentColor = m.TextToColor3(GV.PluginObject:GetSetting("PluginGUIAccent") or m.Color3ToText(m.DefaultAccentColor))
m.ThemeColor = m.TextToColor3(GV.PluginObject:GetSetting("PluginGUITheme") or m.Color3ToText(m.DefaultThemeColor))

return m