--[[
    [RBLXGUILib]
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


-- loading the library
local gui = require(script.Parent.RBLXGUILib.initialize)(plugin)

-- plugin toolbar
toolbar = plugin:CreateToolbar("rblxwidgetlib")

-- toggle toolbar button
local b_toggle = toolbar:CreateButton("","open widget","")

-- generate widget
local widget = gui.PluginWidget.new("rblxwidgetlib").WidgetObject

-- toggle widget button
b_toggle.Click:Connect(function() widget.Enabled = not widget.Enabled end)

-- generate scrolling frame
local scrollframe = gui.ScrollingFrame.new(widget)