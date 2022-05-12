local m = {}

local plugin, name, widget, bgframe, scrollframe, scrollbg, listlayout

-- self explanitory
local ScrollbarIMG = {"http://www.roblox.com/asset/?id=9599518795",
"http://www.roblox.com/asset/?id=9599545837",
"http://www.roblox.com/asset/?id=9599519108"}
local StudioColor = Enum.StudioStyleGuideColor

-- dumps the gui into workspace for debugging
function m.DumpGUI()
    local temp = Instance.new("ScreenGui", workspace)
    temp.Name = "Dump " .. os.time()
    for _, i in pairs(widget:GetChildren()) do
        i:Clone().Parent = temp
    end
end

-- syncing element colors to studio theme colors
function ColorSync(element, property, enum)
    local function sync()
        element[property] = settings().Studio.Theme:GetColor(enum)
    end
    settings().Studio.ThemeChanged:Connect(sync)
	sync()
end

-- initalizing an automatically scaling scrolling frame in widget
function initScrollframe()
    -- scroll bar background
    scrollbg = Instance.new("Frame", bgframe)
    scrollbg.Size = UDim2.new(0,15,1,0)
    scrollbg.Position = UDim2.new(1,-15,0,0)
    scrollbg.Name = "ScrollbarBG"
    scrollbg.ZIndex = 1
    ColorSync(scrollbg, "BackgroundColor3", StudioColor.ScrollBarBackground)

    -- scrolling frame
    scrollframe = Instance.new("ScrollingFrame", bgframe)
    scrollframe.BackgroundTransparency = 1
    scrollframe.Size = UDim2.new(1,0,1,0)
    scrollframe.ScrollBarThickness = 15
    scrollframe.BottomImage, scrollframe.MidImage, scrollframe.TopImage = ScrollbarIMG[1], ScrollbarIMG[2], ScrollbarIMG[3]
    scrollframe.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollframe.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    scrollframe.Name = "ScrollingFrame"
    scrollframe.ZIndex = 2
    ColorSync(scrollframe, "ScrollBarImageColor3", StudioColor.ScrollBar)
    ColorSync(scrollframe, "BorderColor3", StudioColor.Border)

    -- list layout for later elements
    listlayout = Instance.new("UIListLayout", scrollframe)
    listlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- updating the scrollingframe whenever things are added or the size of the widow is changed
    listlayout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then UpdateFrameSize() end
    end)
    bgframe.Changed:Connect(function(p)
        if p == "AbsoluteSize" then UpdateFrameSize() end
    end)
end

-- updaing the scrolling frame to fit window size based on element size
function UpdateFrameSize()
    local scrollbarvis = scrollframe.AbsoluteWindowSize.Y < scrollframe.AbsoluteCanvasSize.Y
    scrollframe.CanvasSize = UDim2.new(0,0,0,listlayout.AbsoluteContentSize.Y)
    scrollbg.Visible = scrollbarvis
end

-- initalizing the gui into widget
function initFrame()
    bgframe = Instance.new("Frame", widget)
    ColorSync(bgframe, "BackgroundColor3", StudioColor.MainBackground)
    bgframe.Size = UDim2.new(1,0,1,0)
    bgframe.Name = "BGFrame"
    bgframe.ZIndex = 0
    initScrollframe()
    UpdateFrameSize()
end

-- initalizing the entire widget along with gui
function m.initWidget(p, n, title)
    plugin = p
    name = n
    if not title then title = name end
    local WidgetInfo = DockWidgetPluginGuiInfo.new(
        Enum.InitialDockState.Float,
	    false,
	    false,
	    200,
	    200,
	    150,
        150
    )
    widget = plugin:CreateDockWidgetPluginGui(name, WidgetInfo)
    widget.Title = title
    initFrame()
    return widget
end

-- creating a frame for elements
function NewFrame()
    local newFrame = Instance.new("Frame", scrollframe)
    newFrame.BackgroundTransparency = 1
    newFrame.Size = UDim2.new(1,0,0,30)
    return newFrame
end

-- creating textboxes
function m.NewTextbox(text, font, alignment)
    if not alignment then alignment = Enum.TextXAlignment.Center end
    local frame = NewFrame()
    local newTextbox = Instance.new("TextLabel", frame)
    newTextbox.BackgroundTransparency = 1
    newTextbox.Size = UDim2.new(1,-20,1,0)
    newTextbox.Position = UDim2.new(0,10,0,0)
    newTextbox.TextXAlignment = alignment
    newTextbox.TextSize = 15
    newTextbox.Font = font
    newTextbox.Text = text
    ColorSync(newTextbox, "TextColor3", StudioColor.MainText)
end


return m