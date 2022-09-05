local m = {}
local GV = require(script.Parent.Parent.PluginGlobalVariables)

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
    if #UnpauseList > 0 then return end
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

function m.AddColor(c1, c2)
    return Color3.new(c1.R + c2.R, c1.G + c2.G, c1.B + c2.B)
end
function m.SubColor(c1, c2)
    return Color3.new(c1.R - c2.R, c1.G - c2.G, c1.B - c2.B)
end
function m.MulitplyColor(c1,c2)
    return Color3.new(c1.R * c2.R, c1.G * c2.G, c1.B * c2.B)
end

function m.Color3ToText(color)
    return "[" .. m.RoundNumber(color.R*255, 1) .. ", " .. m.RoundNumber(color.G*255, 1) .. ", " .. m.RoundNumber(color.B*255, 1) .. "]"
end

function m.TextToColor3(text)
    local numbers = {}
    for i in text:gmatch("[%.%d]+") do
        numbers[#numbers+1] = tonumber(i)
        if #numbers == 3 then break end
    end
    return Color3.fromRGB(numbers[1] or 0, numbers[2] or 0, numbers[3] or 0)
end

function m.Color3ToTable(color)
    return {R = color.R, G = color.G, B = color.B}
end

function m.TableToColor3(table)
    return Color3.new(table.R, table.G, table.B)
end

return m