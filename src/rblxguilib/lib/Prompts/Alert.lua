local Alert = {}
Alert.__index = Alert

local util = require(_G.LibraryDir.GUIUtil)
local Prompt = require(_G.PromptsDir.Prompt)
local TextboxMod = require(_G.ObjectsDir.Textbox)
local Button = require(_G.ObjectsDir.Button)
setmetatable(Alert, Prompt)

function Alert:Clicked(func)
    self.Action = func
end

function Alert.new(Title, Textbox, Buttons, Action)
    local self = Prompt.new()
    setmetatable(self,Alert)
    self.Action = Action
    self.AlertContainer = Instance.new("Frame")
    self.AlertContainer.BackgroundTransparency = 1
    self.AlertContainer.BorderSizePixel = 0
    self.AlertContainer.Size = UDim2.new(1,0,1,0)
    self.AlertContainer.Name = "AlertContainer"
    self.AlertLayout = Instance.new("UIListLayout", self.AlertContainer)
    self.AlertLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.TextFrame = Instance.new("Frame", self.AlertContainer)
    self.TextFrame.Name = "TextFrame"
    self.TextFrame.Size = UDim2.new(0,0,0,35)
    self.TextFrame.BackgroundTransparency = 1
    self.TextFrame.BorderSizePixel = 0
    if type(Textbox) == "string" then
        self.TextboxTable = TextboxMod.new(Textbox, nil, nil, nil, self.TextFrame)
    else
        self.TextboxTable = Textbox
        Textbox:Move(self.TextFrame, true)
    end
    self.Textbox = self.TextboxTable.Textbox
    self.Textbox.ZIndex = 1
    self.Textbox.AnchorPoint = Vector2.new(0.5,0.5)
    self.Textbox.Position = UDim2.new(0.5,0,0.6,0)
    self.Textbox.Size = UDim2.new(1,-24,0,14)
    self.ButtonsFrame = Instance.new("Frame", self.AlertContainer)
    self.ButtonsFrame.Name = "ButtonsFrame"
    self.ButtonsFrame.Size = UDim2.new(0,0,0,40)
    self.ButtonsFrame.BackgroundTransparency = 1
    self.ButtonsFrame.BorderSizePixel = 0
    local ButtonsFramePadding = Instance.new("UIPadding", self.ButtonsFrame)
    ButtonsFramePadding.PaddingBottom, ButtonsFramePadding.PaddingLeft, ButtonsFramePadding.PaddingRight, ButtonsFramePadding.PaddingTop = UDim.new(0,7), UDim.new(0,7), UDim.new(0,7), UDim.new(0,7)
    self.ButtonsFrameLayout = Instance.new("UIListLayout", self.ButtonsFrame)
    self.ButtonsFrameLayout.FillDirection = Enum.FillDirection.Horizontal
    self.ButtonsFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    self.ButtonsFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    for i = #Buttons, 1, -1 do
        local v = Buttons[i]
        local NewButton = v
        if type(v) == "string" then
            NewButton = Button.new(v, 0.95, false, self.ButtonsFrame)
        end
        NewButton.ButtonFrame.Size = UDim2.new(0,82,1,0)
        NewButton:Clicked(function()
            self.Widget:Destroy()
            if self.Action then self.Action(i) end
        end)
    end
    local function syncTextFrame()
        self.TextFrame.Size = UDim2.new(0,self.Textbox.TextBounds.X+24,0,35)
    end
    self.Textbox.Changed:Connect(function(p)
        if p == "TextBounds" then
            syncTextFrame()
        end
    end)
    local function syncButtonsFrame()
        self.ButtonsFrame.Size = UDim2.new(0,self.ButtonsFrameLayout.X+14,0,40)
    end
    self.ButtonsFrameLayout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then
            syncButtonsFrame()
        end
    end)
    local function syncAlertSize()
        self:Reset(Title, self.AlertLayout.AbsoluteContentSize.X, self.AlertLayout.AbsoluteContentSize.Y)
        self.AlertContainer.Parent = self.Parent
    end
    self.AlertLayout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then
            print(self.AlertLayout.AbsoluteContentSize)
            syncAlertSize()
        end
    end)
    return self
end

return Alert