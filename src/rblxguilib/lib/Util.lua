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
    if not Step then Step = 1; end
    --[[
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. m.DumpTable(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end]]
    if type(Table) == "table"then
        local result = "{\n" .. string.rep(":", Step)
        for i, v in pairs(Table) do
            if type(i) == "number" then
                result = result .. m.DumpTable(v, Step+1) .. ","
            else
                result = result .. i .." = " .. m.DumpTable(v, Step+1) .. ","
            end
        end
        return result .. "\n".. string.rep(":", Step-1) .. "}"
    else
        return tostring(Table)
    end
end

return m