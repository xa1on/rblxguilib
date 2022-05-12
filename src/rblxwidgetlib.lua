local m = {}

m.name = nil
m.widget = nil
m.bgframe = nil
m.scrollframe = nil

local plugin, listlayout, scrollbg

-- self explanitory
local ScrollbarIMG = {"http://www.roblox.com/asset/?id=9599518795",
"http://www.roblox.com/asset/?id=9599545837",
"http://www.roblox.com/asset/?id=9599519108"}
local StudioColor = Enum.StudioStyleGuideColor

-- dumps the gui into workspace for debugging
function m.DumpGUI()
    local temp = Instance.new("ScreenGui", workspace)
    temp.Name = "Dump " .. os.time()
    for _, i in pairs(m.widget:GetChildren()) do
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
    scrollbg = Instance.new("Frame", m.bgframe)
    scrollbg.Size = UDim2.new(0,15,1,0)
    scrollbg.Position = UDim2.new(1,-15,0,0)
    scrollbg.Name = "ScrollbarBG"
    scrollbg.ZIndex = 1
    ColorSync(scrollbg, "BackgroundColor3", StudioColor.ScrollBarBackground)

    -- scrolling frame
    m.scrollframe = Instance.new("ScrollingFrame", m.bgframe)
    m.scrollframe.BackgroundTransparency = 1
    m.scrollframe.Size = UDim2.new(1,0,1,0)
    m.scrollframe.ScrollBarThickness = 15
    m.scrollframe.BottomImage, m.scrollframe.MidImage, m.scrollframe.TopImage = ScrollbarIMG[1], ScrollbarIMG[2], ScrollbarIMG[3]
    m.scrollframe.ScrollingDirection = Enum.ScrollingDirection.Y
    m.scrollframe.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    m.scrollframe.Name = "ScrollingFrame"
    m.scrollframe.ZIndex = 2
    ColorSync(m.scrollframe, "ScrollBarImageColor3", StudioColor.ScrollBar)
    ColorSync(m.scrollframe, "BorderColor3", StudioColor.Border)

    -- list layout for later elements
    listlayout = Instance.new("UIListLayout", m.scrollframe)
    listlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- updating the scrollingframe whenever things are added or the size of the widow is changed
    listlayout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then UpdateFrameSize() end
    end)
    m.bgframe.Changed:Connect(function(p)
        if p == "AbsoluteSize" then UpdateFrameSize() end
    end)
end

-- updaing the scrolling frame to fit window size based on element size
function UpdateFrameSize()
    local scrollbarvis = m.scrollframe.AbsoluteWindowSize.Y < m.scrollframe.AbsoluteCanvasSize.Y
    m.scrollframe.CanvasSize = UDim2.new(0,0,0,listlayout.AbsoluteContentSize.Y)
    scrollbg.Visible = scrollbarvis
end

-- initalizing the gui into widget
function initFrame()
    m.bgframe = Instance.new("Frame", m.widget)
    ColorSync(m.bgframe, "BackgroundColor3", StudioColor.MainBackground)
    m.bgframe.Size = UDim2.new(1,0,1,0)
    m.bgframe.Name = "bgframe"
    m.bgframe.ZIndex = 0
    initScrollframe()
    UpdateFrameSize()
end

-- initalizing the entire widget along with gui
function m.initWidget(p, n, title)
    plugin = p
    m.name = n
    if not title then title = m.name end
    local WidgetInfo = DockWidgetPluginGuiInfo.new(
        Enum.InitialDockState.Float,
	    false,
	    false,
	    200,
	    200,
	    150,
        150
    )
    m.widget = plugin:CreateDockWidgetPluginGui(m.name, WidgetInfo)
    m.widget.Title = title
    initFrame()
    return m.widget
end

-- creating a frame for elements
function m.NewFrame(height, parent)
    if not parent then parent = m.scrollframe end
    if not height then height = 30 end
    local newFrame = Instance.new("Frame", parent)
    newFrame.BackgroundTransparency = 1
    newFrame.Size = UDim2.new(1,0,0,height)
    local tablelayout = Instance.new("UITableLayout", newFrame)
    tablelayout.FillEmptySpaceColumns, tablelayout.FillEmptySpaceRows = true, true
    tablelayout.FillDirection = Enum.FillDirection.Horizontal
    return newFrame
end

-- creating textboxes
function m.NewTextbox(text, font, alignment, parent)
    if not alignment then alignment = Enum.TextXAlignment.Center end
    if not parent then parent = m.NewFrame() end
    local newTextbox = Instance.new("TextLabel", parent)
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