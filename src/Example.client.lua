--[[
    [RBLXGUILib]
    something#7597
    todo:
        Sections
        Dropdown
        Sliders
        Toggle
        Input windows
        Keybinds
        Alerts
]]--


-- loads the library
local gui = require(script.Parent.RBLXGUILib.initialize)(plugin)

-- plugin toolbar
toolbar = plugin:CreateToolbar("rblxguilib")

-- generate widget
local widget = gui.PluginWidget.new("rblxguilib").WidgetObject

-- toolbar button to toggle the widget
local b_toggle = toolbar:CreateButton("","open widget","")
b_toggle.Click:Connect(function() widget.Enabled = not widget.Enabled end)

-- new scrolling frame(lets you scroll through the gui): usage - (parent)
local mainframe = gui.ScrollingFrame.new(widget)
-- sets mainframe as the main element(everything will go here by default unless you specify parent)
mainframe:SetMain()

-- new textbox: usage - (text, font, alignment, parent)
gui.Textbox.new("Welcome to rblxguilib!", Enum.Font.SourceSansBold, Enum.TextXAlignment.Center)

-- new buttons: usage - (text/textbox, scale)
local button1 = gui.Button.new("hi", 0.5)
button1.Button.MouseButton1Click:Connect(function() print("hi") end)

local fancybuttonlabel = gui.Textbox.new("hello", Enum.Font.Creepster)
local button2 = gui.Button.new(fancybuttonlabel, 1)
button2.Button.MouseButton1Click:Connect(function() print("hello") end)




-- dumps the gui into workspace for debugging
gui.Util.DumpGUI(widget)