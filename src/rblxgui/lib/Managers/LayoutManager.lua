local m = {}
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)

function m.SearchForID(ID, Table)
    for i,v in pairs(Table) do
        if v.ID == ID then return {i,v} end
    end
    return {nil,nil}
end

function m.GetLayout()
    local layout = {Widgets = {}, Pages = {}}
    for _, Widget in pairs(GV.PluginWidgets) do
        local WidgetDesc = {
            ID = Widget.ID,
            Title = Widget.WidgetObject.Title
        }
        layout.Widgets[#layout.Widgets+1] = WidgetDesc
    end
    for _, Page in pairs(GV.PluginPages) do
        local PageDesc = {
            ID = Page.ID,
            MenuID = Page.TitlebarMenu.ID
        }
        layout.Pages[#layout.Pages+1] = PageDesc
    end
    return layout
end

function m.RecallLayout(layout)
    for _, Widget in pairs(layout.Widgets) do
        local WidgetTable = m.SearchForID(Widget.ID, GV.PluginWidgets)[2]
        if not WidgetTable then
            WidgetTable = require(GV.FramesDir.PluginWidget).new({ID = Widget.ID, Title = Widget.Title, Enabled = true})
        end
        WidgetTable.WidgetObject.Title = Widget.Title
    end
    for _, Page in pairs(layout.Pages) do
        local PageTable = m.SearchForID(Page.ID, GV.PluginPages)[2]
        if PageTable then
            if PageTable.TitlebarMenu.ID ~= Page.MenuID then
                local NewMenu = m.SearchForID(Page.MenuID, GV.PluginWidgets)[2]
                if NewMenu then
                    PageTable.TitlebarMenu:RemovePage(PageTable)
                    NewMenu.TitlebarMenu:RecievePage(PageTable)
                end
            end
        end
    end
    for i, Widget in pairs(GV.PluginWidgets) do
        if not m.SearchForID(Widget.ID, layout.Widgets)[2] then
            Widget.WidgetObject:Destroy()
            Widget = nil
            GV.PluginWidgets[i] = nil
        end
    end
end

function m.SaveLayout(layout)
    layout = layout or m.GetLayout()
    GV.PluginObject:SetSetting(GV.PluginID.."PreviousGUIState", layout)
end

function m.RecallSave()
    m.DefaultLayout = m.GetLayout()
    m.RecallLayout(GV.PluginObject:GetSetting(GV.PluginID.."PreviousGUIState"))
end

function m.ResetLayout()
    m.RecallLayout(m.DefaultLayout)
end

GV.PluginObject.Unloading:Connect(function()
    m.SaveLayout()
end)

return m