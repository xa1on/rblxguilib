--[[
    [RBLXWidgetLib]
    something#7597
    todo:
        Sections
        Button
        Dropdown
        Sliders
        Toggle
        Input windows
        Keybinds
        Alerts
]]--

-- adding widgetlib
local widgetlib = require(script.Parent.rblxwidgetlib)

-- plugin toolbar
toolbar = plugin:CreateToolbar("rblxwidgetlib")

-- toggle toolbar button
local b_toggle = toolbar:CreateButton("","open widget","")

-- generate widget: usage - (plugin, widgetname)
local widget = widgetlib.initWidget(plugin, "rblxwidgetlib")

-- toggle widget button
b_toggle.Click:Connect(function() widget.Enabled = not widget.Enabled end)

-- new textbox: usage - (text, font, alignment, Parent)
widgetlib.NewTextbox("Welcome to rblxwidgetlib!", Enum.Font.SourceSansBold, Enum.TextXAlignment.Center)

widgetlib.NewButton("hi")
-- dumps the gui into workspace in case you need to debug (temporary)
widgetlib.DumpGUI()