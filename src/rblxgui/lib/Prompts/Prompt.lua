local Prompt = {}
Prompt.__index = Prompt

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local util = require(GV.MiscDir.GUIUtil)
local BackgroundFrame = require(GV.FramesDir.BackgroundFrame)
local GUIElement = require(GV.LibraryDir.GUIElement)
local ResetThreshold = 5
setmetatable(Prompt,GUIElement)

function Prompt:Destroy()
    if not self.Arguments.NoPause then util.UnpauseAll() end
    self.Widget:Destroy()
end

function Prompt:OnWindowClose(func)
    self.CloseAction = func
end

function Prompt:Reset(Title, Width, Height)
    if self.Resetting then return end
    self.Resetting = true
    Title = Title or "Prompt"
    if not Width or Width < 1 then Width = 260 end
    if not Height or Height < 1 then Height = 75 end
    local NewWidget = GV.PluginObject:CreateDockWidgetPluginGui(game:GetService("HttpService"):GenerateGUID(false), DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, Width+2, Height+24,1,1))
    if self.Widget then for _,v in pairs(self.Widget:GetChildren())do
        v.Parent = NewWidget
    end self.Widget:Destroy() end
    NewWidget.Title = Title
    NewWidget.Changed:Connect(function(p)
        if p == "AbsoluteSize" then
            if NewWidget.AbsoluteSize.X ~= Width or NewWidget.AbsoluteSize.Y ~= Height then
                if not self.ResetCounter or self.ResetCounter < ResetThreshold then
                    self.ResetCounter = (self.ResetCounter or 0) + 1
                    self:Reset(Title, Width, Height)
                end
            end
        elseif p == "Enabled" then
            NewWidget.Enabled = true
            if self.CloseAction then self.CloseAction() end
        end
    end)
    self.Widget = NewWidget
    self.Resetting = false
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