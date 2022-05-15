local m = {}

function m.ColorSync(element, property, enum)
    local function sync()
        element[property] = settings().Studio.Theme:GetColor(enum)
    end
    settings().Studio.ThemeChanged:Connect(sync)
	sync()
end

return m