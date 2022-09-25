local TextPrompt = {}
TextPrompt.__index = TextPrompt

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local Prompt = require(GV.PromptsDir.Prompt)
local TextboxMod = require(GV.ObjectsDir.Textbox)
local Button = require(GV.ObjectsDir.Button)
setmetatable(TextPrompt, Prompt)

function TextPrompt:Clicked(func)
    self.Action = func
end

-- Title, Textbox/Text, Buttons
function TextPrompt.new(Arguments)
    local self = Prompt.new(Arguments)
    setmetatable(self,TextPrompt)
    local Buttons = self.Arguments.Buttons or {"OK"}
    self.TextPromptContainer = Instance.new("Frame", self.Parent)
    self.TextPromptContainer.BackgroundTransparency = 1
    self.TextPromptContainer.BorderSizePixel = 0
    self.TextPromptContainer.Size = UDim2.new(0,self.Parent.AbsoluteSize.X,0,self.Parent.AbsoluteSize.Y)
    self.TextPromptContainer.Name = "TextPromptContainer"
    self.TextPromptLayout = Instance.new("UIListLayout", self.TextPromptContainer)
    self.TextPromptLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.TextFrame = Instance.new("Frame", self.TextPromptContainer)
    self.TextFrame.Name = "TextFrame"
    self.TextFrame.Size = UDim2.new(0,0,0,35)
    self.TextFrame.BackgroundTransparency = 1
    self.TextFrame.BorderSizePixel = 0
    self.TextboxTable = self.Arguments.Textbox or self.Arguments.Text
    if type(self.TextboxTable) == "string" or not self.TextboxTable then
        self.TextboxTable = TextboxMod.new({Text = self.TextboxTable or ""}, self.TextFrame)
    else
        self.TextboxTable:Move(self.TextFrame, true)
    end
    self.TextboxTable.Arguments.Unpausable = true
    self.Textbox = self.TextboxTable.Textbox
    self.Textbox.ZIndex = 1
    self.Textbox.TextXAlignment = Enum.TextXAlignment.Left
    self.Textbox.AnchorPoint = Vector2.new(0.5,0.5)
    self.Textbox.Position = UDim2.new(0.5,0,0.6,0)
    self.Textbox.Size = UDim2.new(1,-24,0,14)
    self.ButtonsFrame = Instance.new("Frame", self.TextPromptContainer)
    self.ButtonsFrame.Name = "ButtonsFrame"
    self.ButtonsFrame.Size = UDim2.new(1,0,0,40)
    self.ButtonsFrame.BackgroundTransparency = 1
    self.ButtonsFrame.BorderSizePixel = 0
    local ButtonsFramePadding = Instance.new("UIPadding", self.ButtonsFrame)
    ButtonsFramePadding.PaddingBottom, ButtonsFramePadding.PaddingLeft, ButtonsFramePadding.PaddingRight, ButtonsFramePadding.PaddingTop = UDim.new(0,7), UDim.new(0,7), UDim.new(0,7), UDim.new(0,7)
    self.ButtonsFrameLayout = Instance.new("UIListLayout", self.ButtonsFrame)
    self.ButtonsFrameLayout.FillDirection = Enum.FillDirection.Horizontal
    self.ButtonsFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    self.ButtonsFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self:OnWindowClose(function()
        self:Destroy()
        if self.Action then self.Action(0) end
    end)
    if (#Buttons*82)+14 > 260 then
        self.ButtonsFrame.Size = UDim2.new(0,(#Buttons*82)+14,0,40)
    end
    for i,v in pairs(Buttons) do
        local NewButton = v
        if type(v) == "string" then
            NewButton = Button.new({Text = v, ButtonSize = 0.95}, self.ButtonsFrame)
        else
            NewButton:Move(self.ButtonsFrame, true)
        end
        NewButton.Arguments.Unpausable = true
        NewButton.ButtonFrame.Size = UDim2.new(0,82,1,0)
        NewButton:Clicked(function()
            self:Destroy()
            if self.Action then self.Action(i) end
        end)
    end
    local function syncTextFrame()
        self.TextFrame.Size = UDim2.new(0,self.Textbox.TextBounds.X+24,0,self.Textbox.TextBounds.Y+21)
    end
    syncTextFrame()
    self.Textbox.Changed:Connect(function(p)
        if p == "TextBounds" then
            syncTextFrame()
        end
    end)
    local function syncTextPromptSize()
        self:Reset(self.Arguments.Title, self.TextPromptLayout.AbsoluteContentSize.X, self.TextPromptLayout.AbsoluteContentSize.Y)
        self.TextPromptContainer.Size = UDim2.fromOffset(self.TextPromptLayout.AbsoluteContentSize.X, self.TextPromptLayout.AbsoluteContentSize.Y)
        self.TextPromptContainer.Parent = self.Parent
    end
    syncTextPromptSize()
    self.TextPromptLayout.Changed:Connect(function(p)
        if p == "AbsoluteContentSize" then
            syncTextPromptSize()
        end
    end)
    return self
end

return TextPrompt