local Workspace = game:GetService("Workspace")
--[[
    [RBLXGUILib]
    something#7597
    todo:
        Keybinds
        Checkbox
        Sliders
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

-- scrolling frame(lets you scroll through the gui): usage - (parent)
local mainframe = gui.ScrollingFrame.new(widget)
-- sets mainframe as the main element(everything will go here by default unless you specify a parent)
mainframe:SetMain()

-- textbox: usage - (text, font, alignment, size, frame)
gui.Textbox.new("Welcome to rblxgui!", Enum.Font.SourceSansBold, Enum.TextXAlignment.Center)

-- listframe(contains stuff): usage - (name, height, parent)
local acoolframe = gui.ListFrame.new("cool new frame")
gui.Textbox.new("welcome to rblxgui!", nil, nil, nil, acoolframe.Content)
gui.Textbox.new("WELCOME TO RBLXGUI!", Enum.Font.SourceSansBold, nil, nil, acoolframe.Content)

-- buttons: usage - (text/textbox, size, disabled, frame)
local button1 = gui.Button.new("hi")
button1:Clicked(function() print("hi") end)
local button2 = gui.Button.new("Hello", 1, nil, button1.Frame)
button2:Clicked(function() print("Hello") button1:ToggleDisable() end)



-- using a list frame to add padding between elements
gui.ListFrame.new(nil, 5)

-- sections: usage - (name, text(you can use textboxes), open?(closed by default), parent)
local buttonsection = gui.Section.new("Buttons")
-- setting the section to main (saves time having to type out the section for every button)
buttonsection:SetMain()

-- textbox inside button for custom text
local fancybuttonlabel = gui.Textbox.new("fancier button", Enum.Font.Arcade)
local button2 = gui.Button.new(fancybuttonlabel)
button2.Object.MouseButton1Click:Connect(function() print("fancy") end)

-- using frames to move a button
local frame1 = gui.ListFrame.new("the first frame")
local frame2 = gui.ListFrame.new("the second frame")

local button3 = gui.Button.new("press to go down", nil, nil, frame1.Content)
local buttonup = true
button3:Clicked(function()
    if buttonup then
        button3:Move(frame2.Content)
        button3.Textbox.Text = "press to go up"
    else
        button3:Move(frame1.Content)
        button3.Textbox.Text = "press to go down"
    end
    print("im in "..button3.Frame.Name.."!")
    buttonup = not buttonup
end)

mainframe:SetMain()
local newsection = gui.Section.new("section with a section inside it")
local sectionwithin = gui.Section.new("another section", nil, false, newsection.Content)
gui.Textbox.new("yep", nil, nil, nil, gui.ListFrame.new(nil, nil, sectionwithin.Content).Content)
gui.Button.new("test", nil, nil, gui.ListFrame.new(nil, nil, sectionwithin.Content).Content)

-- inputfields - (Label, placeholder, default, labelscale, dropdownitems, DisableEditing, cleartextonfocus, disabled, frame)
gui.InputField.new("Input:", nil, "default text", UDim.new(0.3,0), {{"bob","Bob"},"Steve"}, true)
local inpfield = gui.InputField.new("another input:", "placeholder")
inpfield:AddItems({"1", "2", "remove", {"1 thousand",1000}})
inpfield:RemoveItem("remove")

inpfield:Changed(function(text)
    print(text)
end)

local disablebutton = gui.Button.new("toggle previous")
disablebutton:Clicked(function() inpfield:ToggleDisable() end)

-- instanceinputfield - (label, placeholder, defaultname, defaultvalue, labelsize, items, disabled, frame)
instanceinpfield = gui.InstanceInputField.new("an instance", nil, nil, nil, {{workspace.Hank}, {workspace.walter}})
instanceinpfield:Changed(function(result)
    for _, v in pairs(result) do
        print(v:GetFullName())
    end
end)
keybindinpfield = gui.KeybindInputField.new("new keybind", function() print("hi") end, nil, {{"N"}, {"LeftShift", "T"}}, nil, {{{"U"}, {"LeftShift", "L"}},{{"N"}, {"LeftShift", "K"}}})
keybindinpfield2 = gui.KeybindInputField.new("second keybind")
keybindinpfield2:Triggered(function()
    print("second keybind triggered!")
end)

-- dumps the gui into workspace for debugging
local dumpbutton = gui.Button.new("Dump GUI into workspace")
dumpbutton:Clicked(function()
    print("Dumping GUI")
    gui.Util.DumpGUI(widget)
end)

