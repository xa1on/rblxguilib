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

-- adding widgetlib
local widgetlib = require(script.Parent.rblxwidgetlib)

-- plugin toolbar
toolbar = plugin:CreateToolbar("rblxwidgetlib")

-- toggle toolbar button
local b_toggle = toolbar:CreateButton("","open widget","")

-- generate widget: usage - (plugin, widgetid, widget title(the thing that actually shows up on the widget bar))
local widget = widgetlib.initWidget(plugin, "rblxwidgetlib", "rblxwidgetlib")

-- toggle widget button
b_toggle.Click:Connect(function() widget.Enabled = not widget.Enabled end)

-- new textbox: usage - (text, font, X Alignment)
widgetlib.NewTextbox("Welcome to rblxwidgetlib!", Enum.Font.SourceSansBold, Enum.TextXAlignment.Center)



-- dumps the gui into workspace in case you need to debug (temporary)
widgetlib.DumpGUI()