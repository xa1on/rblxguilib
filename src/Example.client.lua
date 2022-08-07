--[[
    [RBLXGUILib]
    something#7597
]]--

-- loads the library
local gui = require(script.Parent.RBLXGUILib.initialize)(plugin)

-- plugin toolbar
toolbar = plugin:CreateToolbar("rblxgui")

-- generate widget
-- name, title, InitiallyEnabled, NoPageMenu, DockState, OverrideRestore
local widget = gui.PluginWidget.new("rblxgui", nil, true, nil, Enum.InitialDockState.Left)

-- toolbar button to toggle the widget
local b_toggle = toolbar:CreateButton("","open widget","")
b_toggle.Click:Connect(function() widget.Content.Enabled = not widget.Content.Enabled end)

local mainpage = gui.Page.new("MAIN", widget.Menu, true)

local randommenu = plugin:CreatePluginMenu(math.random(), "Random Menu")
randommenu:AddNewAction("1", "Option 1", "rbxasset://textures/loading/robloxTiltRed.png")
randommenu:AddNewAction("2", "Option 2", "rbxasset://textures/loading/robloxTilt.png")
local subMenu = plugin:CreatePluginMenu(math.random(), "C", "rbxasset://textures/explosion.png")
subMenu.Name = "Sub Menu"
subMenu:AddNewAction("ActionD", "D", "rbxasset://textures/whiteCircle.png")
subMenu:AddNewAction("ActionE", "E", "rbxasset://textures/icon_ROBUX.png")
 
randommenu:AddMenu(subMenu)

gui.Alert.new("yo mama", "", {"Sup noob", "fuc u!!!!"})

local titlebarbutton = gui.TitlebarButton.new("BUTTON", widget.Menu, nil, nil, randommenu)
titlebarbutton:Clicked(function()
    print("Titlebar button pressed!")
end)
titlebarbutton:SelectedAction(function(SelectedAction)
    if SelectedAction then
        print("Selected Action:", SelectedAction.Text, "with ActionId:", SelectedAction.ActionId)
    else
        print("User did not select an action!")
    end
end)


gui.Page.new("SETTINGS", widget.Menu)
gui.Page.new("PAGE1", widget.Menu)
gui.Page.new("PAGE2", widget.Menu)
gui.Page.new("PAGE3", widget.Menu)
gui.Page.new("PAGE4", widget.Menu)
gui.Page.new("PAGE5", widget.Menu)

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
local newsection = gui.Section.new("section with a section inside it", true)
local sectionwithin = gui.Section.new("another section", true, newsection.Content)
gui.Textbox.new("test", nil, nil, nil, gui.ListFrame.new(nil, nil, sectionwithin.Content).Content)
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

local disablebutton = gui.ToggleableButton.new("toggle previous")
disablebutton:Clicked(function(p) inpfield:SetDisabled(p) end)

-- instanceinputfield - (defaultname, defaultvalue, items, scale, disabled, frame)
local instanceinpfield = gui.InstanceInputField.new(nil, nil, {{game:GetService("Lighting")}, {workspace}})
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

local slider = gui.Labeled.new("Labled Slider", nil, {{gui.InputField.new(nil, 50, nil, 1, true, true), "display", UDim.new(0,30)},{gui.Slider.new(0,100,50,1), "slider"}})
slider.slider:Changed(function(p)
    slider.display:SetValue(p)
end)

local toggle_checkbox2 = gui.Checkbox.new()
gui.Labeled.new("Disable Slider", 0.5, toggle_checkbox2)
toggle_checkbox2:Clicked(function(p)
    slider:SetDisabled(p)
end)

local newwindow = gui.Button.new("Create a new window")
newwindow:Clicked(function()
    gui.PluginWidget.new(nil, nil, true)
end)

-- dumps the gui into workspace for debugging
local dumpbutton = gui.Button.new("Dump GUI into workspace")
dumpbutton:Clicked(function()
    print("Dumping GUI")
    gui.GUIUtil.DumpGUI(widget.Content)
end)