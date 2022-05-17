local m = {}

-- syncs colors with studio theme
function m.ColorSync(element, property, enum)
    local function sync()
        element[property] = settings().Studio.Theme:GetColor(enum)
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

return m