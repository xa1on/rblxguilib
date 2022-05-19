local GUIObject = {}
GUIObject.__index = GUIObject
local GUIElement = require(script.Parent.Parent.GUIElement)
local ListFrame = require(script.Parent.Parent.Frames.ListFrame)
setmetatable(GUIObject,GUIElement)

function GUIObject.new(Frame)
    local self = GUIElement.new()
    self.Frame = Frame
    if not Frame then self.Frame = ListFrame.new().Frame end
    setmetatable(self,GUIObject)
    self.Object = nil
    return self
end

function GUIObject:Move(NewFrame)
    local PreviousParent = self.Frame
    self.Object.Parent = NewFrame
    if PreviousParent:IsA("Frame") then
        for _, i in pairs(PreviousParent:GetChildren()) do
            if i:IsA("Frame") then
                return self.Object
            end
        end
        PreviousParent:Destroy()
    end
end

return GUIObject