local m = {}

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local EventManager = require(GV.ManagersDir.EventManager)
local util = require(GV.MiscDir.GUIUtil)

-- syncs colors with studio theme
local syncedelements = {}
m.DefaultAccentColor = Color3.fromRGB(53, 181, 255)
m.DefaultThemeColor = Color3.new(0.5,0.5,0.5)

m.PreinstalledThemes = {{Name = "Default Theme", Theme = util.Color3ToTable(m.DefaultThemeColor), Accent = util.Color3ToTable(m.DefaultAccentColor)}}

function m.ColorSync(element, property, enum, enum2, accent, accenttheme, ignoretheme)
    syncedelements[#syncedelements + 1] = {element, property, enum, enum2, accent, accenttheme, ignoretheme}
    m.MatchColor(element, property, enum, enum2, accent, accenttheme, ignoretheme)
end

function m.MatchColor(element, property, enum, enum2, useaccent, accenttheme, ignoretheme)
    local Theme = settings().Studio.Theme
    if useaccent and (((accenttheme) and accenttheme == tostring(Theme)) or not accenttheme) then
        element[property] = m.CurrentAccent
    else
        local ThemeColor = Theme:GetColor(enum, enum2)
        if not ignoretheme then
            element[property] = util.AddColor(util.MulitplyColor(util.SubColor(Color3.new(1,1,1), util.MulitplyColor(m.CurrentTheme, Color3.new(2,2,2))), util.MulitplyColor(ThemeColor, ThemeColor)), util.MulitplyColor(util.MulitplyColor(ThemeColor, m.CurrentTheme), Color3.new(2,2,2)))
        else
            element[property] = ThemeColor
        end
    end
end

function m.ReloadTheme(theme, accent)
    m.CurrentTheme = theme or m.CurrentTheme
    m.CurrentAccent = accent or m.CurrentAccent
    for _, v in pairs(syncedelements) do
        m.MatchColor(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
    end
end

function m.UpdateTheme(theme,accent)
    m.ThemeColor = theme or m.CurrentTheme
    m.AccentColor = accent or m.CurrentAccent
    m.ReloadTheme(m.ThemeColor, m.AccentColor)
end

EventManager.AddConnection(settings().Studio.ThemeChanged, function()
    m.ReloadTheme(m.CurrentTheme, m.CurrentAccent)
end)

local LatestThemeSave = GV.PluginObject:GetSetting(GV.PluginID.."PreviousPluginGUITheme") or {Theme = util.Color3ToTable(m.DefaultThemeColor), Accent = util.Color3ToTable(m.DefaultAccentColor)}
m.AccentColor = util.TableToColor3(LatestThemeSave.Accent)
m.ThemeColor = util.TableToColor3(LatestThemeSave.Theme)
m.CurrentTheme = m.ThemeColor
m.CurrentAccent = m.AccentColor

GV.PluginObject.Unloading:Connect(function()
    GV.PluginObject:SetSetting(GV.PluginID.."PreviousPluginGUITheme", {Theme = util.Color3ToTable(m.ThemeColor), Accent = util.Color3ToTable(m.AccentColor)})
end)

return m