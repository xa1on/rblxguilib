local m = {}

-- syncing element colors to studio theme colors
function m.ColorSync(element, property, enum)
    local function sync()
        element[property] = settings().Studio.Theme:GetColor(enum)
    end
    settings().Studio.ThemeChanged:Connect(sync)
	sync()
end

-- set instance as the main ui element
function m.SetMain(i)
    _G.MainUI = i
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

return m