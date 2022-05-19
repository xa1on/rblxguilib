--[[
    [RBLXGUILib]
    something#7597
    todo:
        Collapsible Sections
        Dropdown
        Sliders
        Toggle
        Text Input
        Instance Selection
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
-- sets mainframe as the main element(everything will go here by default unless you specify a parent)
mainframe:SetMain()

-- new textbox: usage - (text, font, alignment, size, parent)
gui.Textbox.new("Welcome to rblxguilib!", Enum.Font.SourceSansBold, Enum.TextXAlignment.Center)

-- new listframe(they contain stuff): usage - (name, height, parent)
local acoolframe = gui.ListFrame.new("cool new frame")
gui.Textbox.new("welcome to rblxguilib!", nil, nil, nil, acoolframe.Frame)
gui.Textbox.new("WELCOME TO RBLXGUILIB!", Enum.Font.SourceSansBold, nil, nil, acoolframe.Frame)

-- new buttons: usage - (text/textbox, scale, parent)
local button1 = gui.Button.new("hi", 0.5)
button1.Button.MouseButton1Click:Connect(function() print("hi") end)

-- textbox inside button for custom text
local fancybuttonlabel = gui.Textbox.new("fancier button", Enum.Font.Arcade)
local button2 = gui.Button.new(fancybuttonlabel, 1)
button2.Object.MouseButton1Click:Connect(function() print("hello") end)

-- using frames to move a button
local frame1 = gui.ListFrame.new("the first frame")
local frame2 = gui.ListFrame.new("the second frame")

local button3 = gui.Button.new("press to go down", 1/3, frame1.Frame)
local buttonup = true
button3.Button.MouseButton1Click:Connect(function()
    print("im was in "..button3.Frame.Name.."!")
    if buttonup then
        button3.Object.Parent = frame2.Frame
        button3.Textbox.Text = "press to go up"
    else
        button3.Object.Parent = frame1.Frame
        button3.Textbox.Text = "press to go down"
    end
    buttonup = not buttonup
end)



-- using a list frame to add padding between elements
gui.ListFrame.new(nil, 5)

-- dumps the gui into workspace for debugging
local dumpbutton = gui.Button.new("Dump GUI into workspace")
dumpbutton.Button.MouseButton1Click:Connect(function()
    print("Dumping GUI")
    gui.Util.DumpGUI(widget)
end)