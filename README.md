<h1 align="center">RBLXGUI</h1>

<div align="center">
	GUI Library made for creating plugins in studio
</div>

<div>&nbsp;</div>

## Overview
RBLXGUI hosts a wide variety of GUI Elements made for dockable widgets in order to improve GUI workflow in rblxstudio and provide a uniform look and feel for plugins.

### Please contribute!
This was a solo project and any help improving or keeping the library up to date would be greatly appreciated!

<h2 align="center">Getting Started</h2>

In order to install this library, You can clone the repo and build the project with [rojo](https://rojo.space).

```bash
rojo build --output "C:\Users\[Username]\AppData\Local\Roblox\Plugins\[Plugin Name].rbxmx"
```

Another way to install the library is by using [HttpService](https://www.robloxdev.com/api-reference/class/HttpService) to pull the contents directly from this github project into module scripts. Make sure you have http service from `Game Settings` enabled in order for this to work.

```Lua
local http = game:GetService("HttpService")
local req = http:GetAsync("https://api.github.com/repos/xa1on/rblxguilib/contents/src")
local json = http:JSONDecode(req)

local targetFolder = Instance.new("Folder")
targetFolder.Name = "StudioWidgets"
targetFolder.Parent = game.Workspace

for i = 1, #json do
	local file = json[i]
	if (file.type == "file") then
		local name = file.name:sub(1, #file.name-4)
		local module = targetFolder:FindFirstChild(name) or Instance.new("ModuleScript")
		module.Name = name
		module.Source = http:GetAsync(file.download_url)
		module.Parent = targetFolder
	end
end
```
(Credit to the [StudioWidgets](https://github.com/Roblox/StudioWidgets) repo for the import code)

<h2 align="center">Files</h2>

### Frames
| Element | Description |
| --- | --- |
| [GUIFrame.lua](src/rblxgui/lib/Frames/GUIFrame.lua) | Class for all frame elements |
| [BackgroundFrame.lua](src/rblxgui/lib/Frames/BackgroundFrame.lua) | Creates a frame that syncs its color to the current studio theme |
| [ListFrame.lua](src/rblxgui/lib/Frames/ListFrame.lua) | A uniform frame that goes in ScrollingFrames used to house objects |
| [Page.lua](src/rblxgui/lib/Frames/Page.lua) | Creates a page tab in a widget's TitlebarMenu |
| [PluginWidget.lua](src/rblxgui/lib/Frames/PluginWidget.lua) | Creates a rblxgui widget |
| [ScrollingFrame.lua](src/rblxgui/lib/Frames/ScrollingFrame.lua) | A self-scaling ScrollingFrame |
| [Section.lua](src/rblxgui/lib/Frames/Section.lua) | A collapsible frame used to house objects |
| [TitlebarMenu.lua](src/rblxgui/lib/Frames/TitlebarMenu.lua) | Menu on widgets that contains it's pages and TitlebarButtons |

### Objects
| Element | Description |
| --- | --- |
| [GUIObject.lua](src/rblxgui/lib/Objects/GUIObject.lua) | Class for all object elements |
| [Button.lua](src/rblxgui/lib/Objects/Button.lua) | Creates a Button |
| [Checkbox.lua](src/rblxgui/lib/Objects/Checkbox.lua) | Toggleable checkbox object that returns true and false |
| [ColorInput.lua](src/rblxgui/lib/Objects/ColorInput.lua) | Object used to input colors using RGB values or ColorPropmt |
| [InputField.lua](src/rblxgui/lib/Objects/InputField.lua) | TextBox object with a filtered dropdown menu |
| [InstanceInputFrame.lua](src/rblxgui/lib/Objects/InstanceInputFrame.lua) | InputField for adding selected workspace objects |
| [KeybindInputFrame.lua](src/rblxgui/lib/Objects/KeybindInputFrame.lua) | InputField for keybinds |
| [Labeled.lua](src/rblxgui/lib/Objects/Labeled.lua) | Text object that acts as a label for other objects |
| [ProgressBar.lua](src/rblxgui/lib/Objects/ProgressBar.lua) | Bar that fills up to represent progress |
| [Slider.lua](src/rblxgui/lib/Objects/Slider.lua) | Adjustable slider that returns number values |
| [Textbox.lua](src/rblxgui/lib/Objects/Textbox.lua) | Creates a TextLabel object |
| [TitlebarButton.lua](src/rblxgui/lib/Objects/TitlebarButton.lua) | Creates a TitlebarMenu Tab that acts as a button |
| [ViewButton.lua](src/rblxgui/lib/Objects/ViewButton.lua) | Creates a TitlebarButton that allows users to editing widgets, layouts, and themes |

### Prompts
| Element | Description |
| --- | --- |
| [Prompt.lua](src/rblxgui/lib/Propmts/Prompt.lua) | Creates a widget that acts as a prompt window and class for all prompt elements |
| [ColorPrompt.lua](src/rblxgui/lib/Propmts/ColorPrompt.lua) | TextPrompt window that allows user to edit colors |
| [InputPrompt.lua](src/rblxgui/lib/Propmts/InputPrompt.lua) | TextPrompt window with an InputField |
| [TextPrompt.lua](src/rblxgui/lib/Propmts/TextPrompt.lua) | Prompt with text and buttons |

### Managers
| File | Description |
| --- | --- |
| [EventManager.lua](src/rblxgui/lib/Managers/EventManager.lua) | Manages plugin events |
| [InputManager.lua](src/rblxgui/lib/Managers/InputManager.lua) | Keyyboard/mouse input event manager for rblxgui elements |
| [KeybindManager.lua](src/rblxgui/lib/Managers/KeyindManager.lua) | Keybind Manager for KeybindInputObjects |
| [LayoutManager.lua](src/rblxgui/lib/Managers/LayoutManager.lua) | Layout manager for plugin widget/page layouts in studio |
| [ThemeManager.lua](src/rblxgui/lib/Managers/ThemeManager.lua) | Theme manager for rblxgui element colors |

### Misc
| File | Description |
| --- | --- |
| [GUIElement.lua](src/rblxgui/lib/GUIElement.lua) | Class for all GUI Elements |
| [GUIUtil.lua](src/rblxgui/lib/Misc/GUIUtil.lua) | ModuleScript that contains utility functions that dont fit the other categories |
| [PluginGlobalVariables.lua](src/rblxgui/lib/PluginGlobalVariables.lua) | ModuleScript that consolidates all variables used globally in the library |

## Documentation
No documentation at the moment, but you should be able to see how everything works in the [Example Script](src/Example.client.lua).

If anyone actually plans on using this, DM me on [Twitter](https://twitter.com/xalondzn) or Discord (something#7597) if you have any further questions or if you just want to show off what you made.

## Final Notes
A lot of my code may be a bit messy and unorganized but I hope you can bear with me since this is my first big project with lua and I feel like a grew a lot in the process of making this. In the future, I might plan on using Fusion to help make this library a bit better to work with.

## License
Available under the Apache 2.0 license. See [LICENSE](LICENSE) for details.
