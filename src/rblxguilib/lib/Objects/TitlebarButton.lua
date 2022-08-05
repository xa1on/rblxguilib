local TitlebarButton = {}
TitlebarButton.__index = TitlebarButton

local util = require(script.Parent.Parent.GUIUtil)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(TitlebarButton,GUIObject)

function TitlebarButton.new(Name, PageMenu, Size)
    local self = GUIObject.new(PageMenu.PageMenu)
    setmetatable(self,TitlebarButton)
    self.Button = Instance.new("TextButton", PageMenu.ButtonContainer)
    self.Button.Name = Name
    self.Button.Position = UDim2.new(0,PageMenu.ButtonContainer.Size.X.Offset,1,0)
    util.ColorSync(self.Button, "BackgroundColor3", Enum.StudioStyleGuideColor.Titlebar)
    self.Button.ZIndex = 3
    self.Button.BorderSizePixel = 0
    self.Button.Font = Enum.Font.SourceSans
    self.Button.TextSize = 14
    util.ColorSync(self.Button, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    self.Button.Text = Name
    if not Size then
        local function sync()
            self.Button.Size = UDim2.new(0,self.Button.TextBounds.X+1.5*self.Button.TextSize, 0, 24)
        end
        self.Button.Changed:Connect(function(p)
            if p == "TextBounds" then sync() end
        end)
        sync()
    else
        self.Button.Size = UDim2.new(0,Size,1,0)
    end
    self.Object = nil
    self.MainMovable = nil
    return self
end

return TitlebarButton