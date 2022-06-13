--[[
    [RBLXGUILib]
    something#7597
    todo:
        Text Inputs
        Instance Selector
        Toggle Checkboxes
        Sliders
        Dropdown
        Keybinds
]]--


-- loads the library
local gui = require(script.Parent.RBLXGUILib.initialize)(plugin)

-- plugin toolbar
toolbar = plugin:CreateToolbar("rblxgui")

-- generate widget
local widget = gui.PluginWidget.new("rblxgui").WidgetObject

-- toolbar button to toggle the widget
local b_toggle = toolbar:CreateButton("","open widget","")
b_toggle.Click:Connect(function() widget.Enabled = not widget.Enabled end)

-- new scrolling frame(lets you scroll through the gui): usage - (parent)
local mainframe = gui.ScrollingFrame.new(widget)
-- sets mainframe as the main element(everything will go here by default unless you specify a parent)
mainframe:SetMain()

-- new textbox: usage - (text, font, alignment, size, frame)
gui.Textbox.new("Welcome to rblxgui!", Enum.Font.SourceSansBold, Enum.TextXAlignment.Center)

-- new listframe(they contain stuff): usage - (name, height, parent)
local acoolframe = gui.ListFrame.new("cool new frame")
gui.Textbox.new("welcome to rblxgui!", nil, nil, nil, acoolframe.Frame)
gui.Textbox.new("WELCOME TO RBLXGUI!", Enum.Font.SourceSansBold, nil, nil, acoolframe.Frame)

-- new buttons: usage - (text/textbox, scale, frame)
local button1 = gui.Button.new("hi", 0.5)
button1.Button.MouseButton1Click:Connect(function() print("hi") end)

-- using a list frame to add padding between elements
gui.ListFrame.new(nil, 5)

-- new button: usage - (name, text(you can use textboxes), open?(closed by default), parent)
local buttonsection = gui.Section.new("Buttons")
-- setting the section to main (saves time having to type out the section for every button)
buttonsection:SetMain()

-- textbox inside button for custom text
local fancybuttonlabel = gui.Textbox.new("fancier button", Enum.Font.Arcade)
local button2 = gui.Button.new(fancybuttonlabel)
button2.Object.MouseButton1Click:Connect(function() print("hello") end)

-- using frames to move a button
local frame1 = gui.ListFrame.new("the first frame")
local frame2 = gui.ListFrame.new("the second frame")

local button3 = gui.Button.new("press to go down", nil, frame1.Frame)
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

mainframe:SetMain()
local newsection = gui.Section.new("section with a section inside it")
local sectionwithin = gui.Section.new("another section", nil, false, newsection.Frame)
gui.Textbox.new("yep", nil, nil, nil, gui.ListFrame.new(nil, nil, sectionwithin.Frame).Frame)
gui.Button.new("test", nil, gui.ListFrame.new(nil, nil, sectionwithin.Frame).Frame)

-- dumps the gui into workspace for debugging
local dumpbutton = gui.Button.new("Dump GUI into workspace")
dumpbutton.Button.MouseButton1Click:Connect(function()
    print("Dumping GUI")
    gui.Util.DumpGUI(widget)
end)