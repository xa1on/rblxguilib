local GUIObject = {}
GUIObject.__index = GUIObject
local GUIElement = require(script.Parent.Parent.GUIElement)
local ListFrame = require(script.Parent.Parent.Frames.ListFrame)
setmetatable(GUIObject,GUIElement)

function GUIObject.new(Frame)
    local self = GUIElement.new()
    self.Frame = Frame
    if not Frame then self.Frame = ListFrame.new().Content end
    setmetatable(self,GUIObject)
    self.Object = nil
    self.MainMovable = nil
    return self
end

function GUIObject:Move(NewFrame, WithFrame)
    local PreviousParent = self.Frame
    self.MainMovable.Parent = NewFrame
    self.Frame = NewFrame
    if PreviousParent:IsA("Frame") and WithFrame then
        for _, i in pairs(PreviousParent:GetChildren()) do
            if i:IsA("Frame") then
                return self.Object
            end
        end
        PreviousParent:Destroy()
    end
end



return GUIObject