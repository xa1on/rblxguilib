local m = {}

local GV = require(script.Parent.PluginGlobalVariables)
local EventManager = require(GV.ManagersDir.EventManager)

-- syncs colors with studio theme
local syncedelements = {}

function m.ColorSync(element, property, enum, enum2)
    syncedelements[#syncedelements + 1] = {element, property, enum, enum2}
    m.MatchColor(element, property, enum, enum2)
end

function m.MatchColor(element, property, enum, enum2)
    element[property] = settings().Studio.Theme:GetColor(enum, enum2)
end

EventManager.AddConnection(settings().Studio.ThemeChanged, function()
    for _, v in pairs(syncedelements) do
        m.MatchColor(v[1], v[2], v[3], v[4])
    end
end)

-- dumps the gui into workspace for debugging
function m.DumpGUI(parent)
    local StarterGUI = game:GetService("StarterGui")
    local temp = Instance.new("ScreenGui", StarterGUI)
    if StarterGUI:FindFirstChild("Dump") then
        StarterGUI.Dump.Parent = nil
    end
    temp.Name = "Dump"
    for _, i in pairs(parent:GetChildren()) do
        i:Clone().Parent = temp
    end
end

function m.AppendTable(table,newtable)
    local fulltable = table
    for i, v in pairs(newtable) do fulltable[i] = v end
    return fulltable
end

function m.DumpTable(Table, Step)
    Step = Step or 1
    if type(Table) == "table"then
        local result = "{\n" .. string.rep(":", Step)
        for i, v in pairs(Table) do
            result = result .. i .." = " .. m.DumpTable(v, Step+1) .. ","
        end
        return result .. "\n".. string.rep(":", Step-1) .. "}"
    else
        return tostring(Table)
    end
end

function m.HoverIcon(element, icon)
    icon = icon or "rbxasset://SystemCursors/PointingHand"
    element.MouseMoved:Connect(function()
        GV.PluginObject:GetMouse().Icon = icon
    end)
    element.MouseLeave:Connect(function()
        task.wait(0)
        GV.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
    end)
end

function m.CopyTable(t)
    local newt = {}
    for i,v in pairs(t) do
        newt[i] = v
    end
    return newt
end

function m.GetScale(Scale)
    if typeof(Scale) == "UDim" then
        return Scale
    elseif typeof(Scale) == "number" then
        return UDim.new(Scale,0)
    else
        return nil
    end
end

function m.RoundNumber(number, factor)
    if factor == 0 then return number else return math.floor(number/factor+0.5)*factor end
end

local UnpauseList = {}
function m.PauseAll()
    for _,v in pairs(GV.ObjectList) do
        if v and v.SetDisabled and not v.Disabled and not v.Arguments.Unpausable then
            v:SetDisabled(true)
            UnpauseList[#UnpauseList+1] = v
        end
    end
end

function m.UnpauseAll()
    for _,v in pairs(UnpauseList) do
        v:SetDisabled(false)
    end
    UnpauseList = {}
end

return m