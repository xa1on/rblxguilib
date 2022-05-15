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

local button1 = widgetlib.NewButton("hi", 0.5)
button1.MouseButton1Click:Connect(function() print("hi") end)

local fancybuttonlabel = widgetlib.NewTextbox("hello", Enum.Font.Creepster)
local button2 = widgetlib.NewButton(fancybuttonlabel, 1)
button2.MouseButton1Click:Connect(function() print("hello") end)

-- dumps the gui into workspace in case you need to debug (temporary)
widgetlib.DumpGUI()