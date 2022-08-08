local Prompt = {}
Prompt.__index = Prompt

local BackgroundFrame = require(_G.FramesDir.BackgroundFrame)

function Prompt:Reset(Title, Width, Height)
    Title = Title or "Prompt"
    if not Width or Width < 1 then Width = 260 end
    if not Height or Height < 1 then Height = 75 end
    local NewWidget = _G.PluginObject:CreateDockWidgetPluginGui(math.random(), DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, Width, Height,1,1))
    if self.Widget then for _,v in pairs(self.Widget:GetChildren())do
        v.Parent = NewWidget
    end end
    NewWidget.Title = Title
    NewWidget.Changed:Connect(function(p)
        if p == "AbsoluteSize" then
            if NewWidget.AbsoluteSize.X ~= Width or NewWidget.AbsoluteSize.Y ~= Height then
                self:Reset(Title, Width, Height)
            end
        end
    end)
    if self.Widget then self.Widget:Destroy() end
    self.Widget = NewWidget
end

function Prompt.new(Title, Width, Height)
    local self = {}
    setmetatable(self,Prompt)
    self:Reset(Title, Width, Height)
    local BackgroundFrame = BackgroundFrame.new(self.Widget)
    self.Parent = BackgroundFrame.Content
    return self
end

return Prompt