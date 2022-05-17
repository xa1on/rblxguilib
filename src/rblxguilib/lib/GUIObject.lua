local GUIObject = {}
GUIObject.__index = GUIObject
local GUIElement = require(script.Parent.GUIElement)
setmetatable(GUIObject,GUIElement)

function GUIObject.new(Object, Frame)
    local self = GUIElement.new(Object)
    setmetatable(self,GUIObject)
    self.Object = Object
    self.Frame = Frame
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