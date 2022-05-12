--[[
    [RBLXWidgetLib]
    something#7597
    todo:
        Textbox
        Sections
        Button
        Dropdown
        Sliders
        Toggle
        Input windows
        Keybinds
        Alerts
]]--

-- dependencies
local dep = require(script.Parent.dependencies)

-- get userID(unnessecary)
local playerId = game:GetService("StudioService"):GetUserId()

-- generate widget
local widget = dep.widgetlib.initWidget(plugin, "rblxwidgetlib", "rblxwidgetlib - " .. game:GetService("Players"):GetNameFromUserIdAsync(playerId))

-- plugin toolbar
toolbar = plugin:CreateToolbar("rblxwidgetlib")

-- toggle toolbar button
local b_toggle = toolbar:CreateButton("","open widget","")


-- toggle widget
b_toggle.Click:Connect(function() widget.Enabled = not widget.Enabled end)

dep.widgetlib.NewTextbox("Welcome to rblxwidgetlib!", Enum.Font.SourceSansBold, Enum.TextXAlignment.Center)




dep.widgetlib.DumpGUI()