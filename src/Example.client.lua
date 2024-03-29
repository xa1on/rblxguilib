--[[
    [RBLXGUILib]
    something#7597
    todo:
        
]]--

-- loads the library(plugin object, plugin id)
local gui = require(script.Parent.rblxgui.initialize)(plugin, "rblxgui")

-- plugin toolbar
toolbar = plugin:CreateToolbar("rblxgui")

-- widget
-- ID, Title, Enabled, NoTitlebarMenu, DockState, OverrideRestore
local widget = gui.PluginWidget.new({
    ID = "rblxgui",
    Enabled = true,
    DockState = Enum.InitialDockState.Left
})

-- toolbar button to toggle the widget
local b_toggle = toolbar:CreateButton("","open widget","")
b_toggle.Click:Connect(function() widget.Content.Enabled = not widget.Content.Enabled end)
local b_resetlayout = toolbar:CreateButton("", "reset layout", "")
b_resetlayout.Click:Connect(function() gui.LayoutManager.ResetLayout() end)


-- page:
-- Name, TitlebarMenu, Open, TabSize, ID
local mainpage = gui.Page.new({
    Name = "MAIN",
    TitlebarMenu = widget.TitlebarMenu,
    Open = true
})

-- view button(edit layouts and widgets)
-- 
gui.ViewButton.new()

local randommenu = plugin:CreatePluginMenu(game:GetService("HttpService"):GenerateGUID(false), "Random Menu")
randommenu.Name = "Random Menu"
randommenu:AddNewAction("1", "Option 1", "rbxasset://textures/loading/robloxTiltRed.png")
randommenu:AddNewAction("2", "Option 2", "rbxasset://textures/loading/robloxTilt.png")
local subMenu = plugin:CreatePluginMenu(game:GetService("HttpService"):GenerateGUID(false), "C", "rbxasset://textures/explosion.png")
subMenu.Name = "Sub Menu"
subMenu:AddNewAction("ActionD", "D", "rbxasset://textures/whiteCircle.png")
subMenu:AddNewAction("ActionE", "E", "rbxasset://textures/icon_ROBUX.png")
randommenu:AddMenu(subMenu)

-- title bar button(button on the titlebar of widgets with titlebars)
-- Name, TabSize, Disabled, PluginMenu
local titlebarbutton = gui.TitlebarButton.new({
    Name = "BUTTON",
    PluginMenu = randommenu
})
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


gui.Page.new({Name = "SETTINGS"}, widget)
gui.Page.new({Name = "PAGE1"}, widget)
gui.Page.new({Name = "PAGE2"}, widget)
gui.Page.new({Name = "PAGE3"}, widget)
gui.Page.new({Name = "PAGE4"}, widget)

-- scrolling frame(lets you scroll through the gui):
-- BarSize
local mainframe = gui.ScrollingFrame.new(nil, mainpage.Content)
-- sets mainframe as the main element(everything will go here by default unless you specify a parent)
mainframe:SetMain()

-- textbox:
-- Text, Font, Alignment, TextSize
gui.Textbox.new({
    Text = "Welcome to rblxgui!",
    Font = Enum.Font.SourceSansBold,
    Alignment = Enum.TextXAlignment.Center
})

-- listframe(contains stuff):
-- Name, Height
local acoolframe = gui.ListFrame.new({
    Name = "cool new frame"
})
gui.Textbox.new({
    Text = "welcome to rblxgui!"
}, acoolframe.Content)
gui.Textbox.new({
    Text = "WELCOME TO RBLXGUI!",
    Font = Enum.Font.SourceSansBold
}, acoolframe.Content)

-- buttons:
-- Text/Textbox, ButtonSize, Disabled
local button1 = gui.Button.new({
    Text = "hi"
})
button1:Clicked(function() print("hi") end)
local button2 = gui.Button.new({
    Text = "Hello",
    ButtonSize = 1
}, button1.Parent)
button2:Clicked(function() print("Hello") button1:ToggleDisable() end)



-- using a list frame to add padding between elements
gui.ListFrame.new({
    Height = 5
})

-- sections:
-- Text, Open, Parent
local buttonsection = gui.Section.new({
    Text = "Buttons"
})
-- setting the section to main (saves time having to type out the section for every button)
buttonsection:SetMain()

-- textbox inside button for custom text
local fancybuttonlabel = gui.Textbox.new({
    Text = "fancier button",
    Font = Enum.Font.Arcade
})
local button2 = gui.Button.new({
    Textbox = fancybuttonlabel
})
button2.Object.MouseButton1Click:Connect(function()
    -- textprompt:
    -- Title, Textbox, Buttons
    local textprompt = gui.TextPrompt.new({
        Title = "The Fancy Button",
        Text = "Hello!",
        Buttons = {"Hi!", "Hello!"}
    })
    textprompt:Clicked(function(p)
        print(p)
    end)
end)

-- using frames to move a button
local frame1 = gui.ListFrame.new({
    Name = "the first frame"
})
local frame2 = gui.ListFrame.new({
    Name = "the second frame"
})

local button3 = gui.Button.new({
    Text = "press to go down"
}, frame1.Content)
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
local newsection = gui.Section.new({
    Text = "section with a section inside it",
    Open = true
})
local sectionwithin = gui.Section.new({
    Text = "another section",
    Open = true
}, newsection.Content)
gui.Textbox.new({
    Text = "test"
}, gui.ListFrame.new(nil, sectionwithin.Content).Content)
local testbutton = gui.Button.new({
    Text = "test"
}, gui.ListFrame.new(nil, sectionwithin.Content).Content)
testbutton:Clicked(function()
    local inputprompt = gui.InputPrompt.new({
        Title = "Input Prompt title",
        Text = "hey, this is an inputprompt",
        Input = "hi"
    })
    inputprompt:Clicked(function(p)
        print("option " .. p .. " chosen")
        print("entered text:" .. inputprompt.InputField.Value)
    end)
end)


-- inputfields
-- Placeholder, CurrentItem/Value, Items, InputSize, NoDropdown, NoFiltering, DisableEditing, ClearText, Disabled
gui.InputField.new({
    CurrentItem = "default text",
    Items = {
        {
            Name = "bob",
            Value = "Bob"
        }, "Steve"
    }
})

-- Labeled objects
-- Textbox, LabelSize, Objects
local inpfield = gui.Labeled.new({
    Text = "another input",
    Objects = gui.InputField.new({
        Placeholder = "placeholder"
    })
})
inpfield.Object:AddItems({
    "1",
    "2",
    "remove",
    {
        Name = "1 thousand",
        Value = 1000
    }
})
inpfield.Object:RemoveItem("remove")
for i=4,100 do
    inpfield.Object:AddItem(i)
end
inpfield.Object:Changed(function(text)
    print(text)
end)

-- toggleable buttons
-- Textbox, ButtonSize, Value, Disabled
local togglebutton1 = gui.ToggleableButton.new({
    Text = "toggle next button"
})
local togglebutton2 = gui.ToggleableButton.new({
    Text = "Untoggle previous button",
    Value = true
})
togglebutton1:Clicked(function(p) if p then togglebutton2:SetValue(false) end end)
togglebutton2:Clicked(function(p) if p then togglebutton1:SetValue(false) end end)

-- instanceinputfield
-- Value/CurrentItem, Items, InputSize, NoDropdown, NoFiltering, DisabledEditing, ClearText, Disabled
local instanceinpfield = gui.InstanceInputField.new({
    Items = {
        {
            Value = {
                game:GetService("Lighting"),
                game:GetService("MaterialService")
            },
            Name = "Lighting/MaterialService combo"
        }, workspace,{
            game:GetService("ReplicatedFirst"),
            game:GetService("ReplicatedStorage")
        }
    }
})
gui.Labeled.new({
    Text = "an instance",
    Object = instanceinpfield
})
instanceinpfield:Changed(function(result)
    for _, v in pairs(result) do
        print(v:GetFullName())
    end
end)
instanceinpfield:DropdownToggled(function(p)
    print("dropdown has beeen toggled")
    print(p)
end)


-- keybindinputfield
-- PressedAction, ReleasedAction, Holdable, Unrestricted, Bind/CurrentBind, Items/Binds, InputSize, NoDropdown, NoFiltering, DisabledEditing, ClearText, Disabled
gui.Labeled.new({
    Text = "keybind",
    Object = gui.KeybindInputField.new({
        PressedAction = function() print("keybind1 pressed!") end,
        ReleasedAction = function() print("keybind1 released!") end,
        CurrentBind = {
            {"N"},
            {"LeftShift", "T"}
        },
        Binds = {
            {
                Value = {
                    {"U"},
                    {"LeftShift", "L"}
                }
            },{
                Value = {
                    {"N"},
                    {"LeftShift", "K"}
                }
            },{
                Name = "Default",
                Value = {
                    {"N"},
                    {"LeftShift", "T"}
                },
            }
        }
    })
})

local keybindinpfield2 = gui.Labeled.new({
    Text = "another keybind",
    Object = gui.KeybindInputField.new({Holdable = true, Unrestricted = true})
})
keybindinpfield2.Object:Pressed(function()
    print("second keybind pressed!")
end)
keybindinpfield2.Object:Released(function()
    print("second keybind released!")
end)

-- checkbox
-- Value, Disabled
local checkbox = gui.Labeled.new({
    Text = "checkbox",
    LabelSize = 0.5,
    Object = gui.Checkbox.new({
        Value = true
    })
})
checkbox.Object:Clicked(function(p)
    print(p)
    keybindinpfield2:SetDisabled(not p)
end)

local toggle_checkbox = gui.Checkbox.new()
gui.Labeled.new({
    Text = "Disable checkbox",
    LabelSize = 0.5,
    Object = toggle_checkbox
})
toggle_checkbox:Clicked(function(p)
    checkbox:SetDisabled(p)
end)

-- slider
-- Min, Max, Value, Increment, SliderSize, Disabled
local labeledslider = gui.Labeled.new({
    Text = "Labled Slider",
    Objects = {
        {
            Object = gui.InputField.new({
                Value = 50,
                InputSize = 1,
                NoDropdown = true,
                DisableEditing = true
            }),
            Name = "display",
            Size = UDim.new(0,30)
        },{
            Object = gui.Slider.new({
                Min = 0,
                Max = 100,
                Value = 50,
                Increment = 1
            }),
            Name = "slider"
        }
    }
})

-- progressbar
-- BarSize, Value, Disabled
local progressbar = gui.ProgressBar.new({
    Value = 0.5
})

labeledslider.slider:Changed(function(p)
    labeledslider.display:SetValue(p)
    progressbar:SetValue(p/100)
end)

local toggle_checkbox2 = gui.Checkbox.new()
gui.Labeled.new({
    Text = "Disable Slider",
    LabelSize = 0.5,
    Object = toggle_checkbox2
})
toggle_checkbox2:Clicked(function(p)
    labeledslider:SetDisabled(p)
    progressbar:SetDisabled(p)
end)

local colorinput = gui.ColorInput.new({
    Color = gui.ThemeManager.DefaultAccentColor,
    NoPause = true
})
colorinput:SetValue(gui.ThemeManager.AccentColor)
gui.Labeled.new({
    Text = "Color Input",
    LabelSize = 0.5,
    Object = colorinput
})

-- dumps the gui into workspace for debugging
local dumpbutton = gui.Button.new({Text = "Dump GUI into workspace"})
dumpbutton:Clicked(function()
    print("Dumping GUI")
    gui.GUIUtil.DumpGUI(widget.Content)
end)

gui.LayoutManager.RecallSave()