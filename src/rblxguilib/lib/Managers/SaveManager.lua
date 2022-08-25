local m = {}
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)

function m.SearchForID(ID, Table)
    for i,v in pairs(Table) do
        if v.ID == ID then return {i,v} end
    end
    return {nil,nil}
end

function m.GetLayout()
    local layout = {Widgets = {}, Menus = {}, Pages = {}}
    for _, Widget in pairs(GV.PluginWidgets) do
        local WidgetDesc = {
            ID = Widget.ID,
            Title = Widget.WidgetObject.Title
        }
        layout.Widgets[#layout.Widgets+1] = WidgetDesc
    end
    for _, Menu in pairs(GV.PluginTitlebarMenus) do
        local MenuDesc = {
            ID = Menu.ID,
            Parent = Menu.Parent
        }
        layout.Menus[#layout.Menus+1] = MenuDesc
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
    layout = layout or m.DefaultLayout
    for _, Widget in pairs(layout.Widgets) do
        local WidgetTable = m.SearchForID(Widget.ID, GV.PluginWidgets)[2]
        if not WidgetTable then
            WidgetTable = require(GV.FramesDir.PluginWidget).new(Widget.ID, Widget.Title, true)
        end
        WidgetTable.WidgetObject.Title = Widget.Title
    end
    --[[
    for _, Menu in pairs(layout.Menus) do
        local MenuTable = m.SearchForID(Menu.ID, GV.PluginTitlebarMenus)[2]
        if MenuTable.Parent ~= Menu.Parent then
            MenuTable.TitlebarMenu.Parent = Menu.Parent
            MenuTable.Parent = Menu.Parent
        end
    end]]
    for _, Page in pairs(layout.Pages) do
        local PageTable = m.SearchForID(Page.ID, GV.PluginPages)[2]
        if PageTable.TitlebarMenu.ID ~= Page.MenuID then
            local NewMenu = m.SearchForID(Page.MenuID, GV.PluginTitlebarMenus)[2]
            PageTable.TitlebarMenu:RemovePage(PageTable)
            NewMenu:RecievePage(PageTable)
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
    GV.PluginObject:SetSetting("guilayout", layout)
end

function m.RecallSave()
    m.DefaultLayout = m.GetLayout()
    m.RecallLayout(GV.PluginObject:GetSetting("guilayout"))
end

function m.ResetLayout()
    m.RecallLayout()
end

GV.PluginObject.Unloading:Connect(function()
    m.SaveLayout()
end)

return m