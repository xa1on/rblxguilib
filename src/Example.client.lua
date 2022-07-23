local Workspace = game:GetService("Workspace")
--[[
    [RBLXGUILib]
    something#7597
]]--


-- loads the library
local gui = require(script.Parent.RBLXGUILib.initialize)(plugin)

-- plugin toolbar
toolbar = plugin:CreateToolbar("rblxgui")

-- generate widget
local widget = gui.PluginWidget.new("rblxgui").Content

-- toolbar button to toggle the widget
local b_toggle = toolbar:CreateButton("","open widget","")
b_toggle.Click:Connect(function() widget.Enabled = not widget.Enabled end)

local mainmenu = gui.PageMenu.new(widget)
local mainpage = gui.Page.new("MAIN", mainmenu, true)

local settingspage = gui.Page.new("SETTINGS", mainmenu)

-- scrolling frame(lets you scroll through the gui): usage - (parent)
local mainframe = gui.ScrollingFrame.new(nil, mainpage.Content)
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
local button2 = gui.Button.new("Hello", 1, nil, button1.Parent)
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
    print("im in "..button3.Parent.Name.."!")
    buttonup = not buttonup
end)

mainframe:SetMain()
local newsection = gui.Section.new("section with a section inside it")
local sectionwithin = gui.Section.new("another section", nil, false, newsection.Content)
gui.Textbox.new("yep", nil, nil, nil, gui.ListFrame.new(nil, nil, sectionwithin.Content).Content)
gui.Button.new("test", nil, nil, gui.ListFrame.new(nil, nil, sectionwithin.Content).Content)

-- inputfields - (placeholder, default, dropdownitems, scale, nodropdown, DisableEditing, cleartextonfocus, disabled, frame)
gui.Labeled.new("input", 0.3, gui.InputField.new(nil, "default text", {{"bob","Bob"},"Steve"}, true))
local inpfield = gui.Labeled.new("another input", nil, gui.InputField.new("placeholder"))
inpfield.Object:AddItems({"1", "2", "remove", {"1 thousand",1000}})
inpfield.Object:RemoveItem("remove")
for i=4,100 do
    inpfield.Object:AddItem(i)
end


inpfield.Object:Changed(function(text)
    print(text)
end)

local disablebutton = gui.Button.new("toggle previous")
disablebutton:Clicked(function() inpfield:ToggleDisable() end)

-- instanceinputfield - (defaultname, defaultvalue, items, scale, disabled, frame)
local instanceinpfield = gui.InstanceInputField.new(nil, nil, {{game:GetService("Lighting")}, {Workspace}})
gui.Labeled.new("an instance", nil, instanceinpfield)
instanceinpfield:Changed(function(result)
    for _, v in pairs(result) do
        print(v:GetFullName())
    end
end)

gui.Labeled.new("keybind", nil, gui.KeybindInputField.new(function() print("hi") end, nil, {{"N"}, {"LeftShift", "T"}}, {{{"U"}, {"LeftShift", "L"}},{{"N"}, {"LeftShift", "K"}}}))

local keybindinpfield2 = gui.Labeled.new("another keybind", nil, gui.KeybindInputField.new())

keybindinpfield2.Object:Triggered(function()
    print("second keybind triggered!")
end)

local checkbox = gui.Labeled.new("checkbox", 0.5, gui.Checkbox.new(true))
checkbox.Object:Clicked(function(p)
    print(p)
    keybindinpfield2:SetDisabled(not p)
end)
local toggle_checkbox = gui.Checkbox.new()
gui.Labeled.new("Disable checkbox", 0.5, toggle_checkbox)
toggle_checkbox:Clicked(function(p)
    checkbox:SetDisabled(p)
end)

local slider = gui.Labeled.new("Labled Slider", nil, {{gui.InputField.new(nil, 50, nil, 1, true, true), "display", 0.12},{gui.Slider.new(0,100,50,1), "slider"}})
slider.slider:Changed(function(p)
    slider.display:SetValue(p)
end)

local toggle_checkbox2 = gui.Checkbox.new()
gui.Labeled.new("Disable Slider", 0.5, toggle_checkbox2)
toggle_checkbox2:Clicked(function(p)
    slider:SetDisabled(p)
end)

-- dumps the gui into workspace for debugging
local dumpbutton = gui.Button.new("Dump GUI into workspace")
dumpbutton:Clicked(function()
    print("Dumping GUI")
    gui.GUIUtil.DumpGUI(widget)
end)
