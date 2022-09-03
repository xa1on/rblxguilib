local Prompt = {}
Prompt.__index = Prompt

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.LibraryDir.GUIUtil)
local BackgroundFrame = require(GV.FramesDir.BackgroundFrame)
local GUIElement = require(GV.LibraryDir.GUIElement)
setmetatable(Prompt,GUIElement)

function Prompt:Destroy()
    if not self.Arguments.NoPause then util.UnpauseAll() end
    self.Widget:Destroy()
end

function Prompt:OnWindowClose(func)
    self.CloseAction = func
end

function Prompt:Reset(Title, Width, Height)
    Title = Title or "Prompt"
    if not Width or Width < 1 then Width = 260 end
    if not Height or Height < 1 then Height = 75 end
    local NewWidget = GV.PluginObject:CreateDockWidgetPluginGui(math.random(), DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, Width, Height,1,1))
    if self.Widget then for _,v in pairs(self.Widget:GetChildren())do
        v.Parent = NewWidget
    end end
    NewWidget.Title = Title
    NewWidget.Changed:Connect(function(p)
        if p == "AbsoluteSize" then
            if NewWidget.AbsoluteSize.X ~= Width or NewWidget.AbsoluteSize.Y ~= Height then
                self:Reset(Title, Width, Height)
            end
        elseif p == "Enabled" then
            if self.CloseAction then self.CloseAction() end
            NewWidget.Enabled = true
        end
    end)
    if self.Widget then self.Widget:Destroy() end
    self.Widget = NewWidget
end

-- Title, Width, Height, NoPause
function Prompt.new(Arguments)
    local self = GUIElement.new(Arguments)
    setmetatable(self,Prompt)
    self:Reset(self.Arguments.Title, self.Arguments.Width, self.Arguments.Height)
    if not self.Arguments.NoPause then util.PauseAll() end
    local BackgroundFrame = BackgroundFrame.new(nil, self.Widget)
    self.Parent = BackgroundFrame.Content
    return self
end

return Prompt