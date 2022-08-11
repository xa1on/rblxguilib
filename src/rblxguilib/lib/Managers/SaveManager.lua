local m = {}
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local tasklist = GV.PluginObject:GetSetting("rblxguilib Task List") or {}
local util = require(GV.LibraryDir.GUIUtil)

function m.FindWidgetIndex(id)
    for i,v in pairs(GV.PluginWidgets) do
        if v.ID == id then return i end
    end
end

function m.FindWidget(id)
    for _,v in pairs(GV.PluginWidgets) do
        if v.ID == id then return v end
    end
end

function m.FindPage(id)
    for _,v in pairs(GV.PluginPages) do
        if v.ID == id then return v end
    end
end

function m.RecallSave()
    for _,task in pairs(tasklist) do
        local PluginWidget = require(GV.FramesDir.PluginWidget)
        local taskname = task[1]
        local taskargs = task[2]
        if taskname == "newwidget" then
            -- taskargs[1] = id
            -- taskargs[2] = title
            PluginWidget.new(taskargs[1], taskargs[2], true)
        elseif taskname == "movepage" then
            -- taskargs[1] = page ID
            -- taskargs[2] = NewMenuWidget ID
            local Page = m.FindPage(taskargs[1])
            local NewWidget = m.FindWidget(taskargs[2])
            Page.TitlebarMenu:RemovePage(Page)
            NewWidget:RecievePage(Page, true)
        elseif taskname == "renamewidget" then
            -- taskargs[1] = Widget ID
            -- taskargs[2] = new title
            local Widget = m.FindWidget(taskargs[1])
            Widget.WidgetObject.Title = taskargs[2]
        elseif taskname == "deletewidget" then
            -- taskargs[1] = Widget ID
            local Widget = m.FindWidget(taskargs[1])
            Widget.WidgetObject:Destroy()
            Widget = nil
            table.remove(GV.PluginWidgets, m.FindWidgetIndex(taskargs[1]))
        end
        PluginWidget = nil
    end
end

function m.TaskAppend(task, ...)
    tasklist[#tasklist+1] = {task, {...}}
    GV.PluginObject:SetSetting("rblxguilib Task List", tasklist)
end

function m.ResetSave()
    tasklist = {}
    GV.PluginObject:SetSetting("rblxguilib Task List", tasklist)
end

return m