local Prompt = {}
Prompt.__index = Prompt

local BackgroundFrame = require(_G.FramesDir.BackgroundFrame)

function Prompt:Reset(Title, Width, Height, ResetWhenChanged)
    if self.Widget then self.Widget:Destroy() end
    Title = Title or "Prompt"
    Width = Width or 260
    Height = Height or 75
    self.Widget = _G.PluginObject:CreateDockWidgetPluginGui(math.random(), DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, Width, Height, Width, Height))
    self.Widget.Title = Title
    local BackgroundFrame = BackgroundFrame.new(self.Widget)
    BackgroundFrame.Content.Changed:Connect(function(p)
        if p == "AbsoluteSize" and (BackgroundFrame.Content.AbsoluteSize.X ~= Width or BackgroundFrame.Content.AbsoluteSize.Y ~= Height) and ResetWhenChanged then
            self:Reset(Title, Width, Height, true)
        end
    end)
    self.Parent = BackgroundFrame.Content
end

function Prompt.new(Title, Width, Height)
    local self = {}
    setmetatable(self,Prompt)
    self:Reset(Title, Width, Height, true)
    return self
end

return Prompt