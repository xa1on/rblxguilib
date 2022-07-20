local m = {}

-- syncs colors with studio theme
function m.ColorSync(element, property, enum, enum2)
    local function sync()
        element[property] = settings().Studio.Theme:GetColor(enum, enum2)
    end
    settings().Studio.ThemeChanged:Connect(sync)
	sync()
end

-- dumps the gui into workspace for debugging
function m.DumpGUI(parent)
    local temp = Instance.new("ScreenGui", workspace)
    if workspace:FindFirstChild("Dump") then
        workspace.Dump.Parent = nil
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
        _G.PluginObject:GetMouse().Icon = icon
    end)
    element.MouseLeave:Connect(function()
        task.wait(0)
        _G.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
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
    if type(Scale) == "userdata" then
        return Scale
    elseif type(Scale) == "number" then
        return UDim.new(Scale,0)
    else
        return nil
    end
end

function m.RoundNumber(number, factor)
    if factor == 0 then return number else return math.floor(number/factor+0.5)*factor end
end

return m