local GUIObject = {}
GUIObject.__index = GUIObject
local GUIElement = require(script.Parent.Parent.GUIElement)
local ListFrame = require(script.Parent.Parent.Frames.ListFrame)
setmetatable(GUIObject,GUIElement)

function GUIObject.new(Frame)
    local self = GUIElement.new()
    Frame = Frame or ListFrame.new().Content
    self.Parent = Frame
    setmetatable(self,GUIObject)
    self.Object = nil
    self.MainMovable = nil
    return self
end

function GUIObject:Move(NewFrame, WithFrame)
    local PreviousParent = self.Parent
    self.MainMovable.Parent = NewFrame
    self.Parent = NewFrame
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