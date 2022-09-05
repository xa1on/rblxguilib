local GUIObject = {}
GUIObject.__index = GUIObject
local GV = require(script.Parent.Parent.PluginGlobalVariables)
local GUIElement = require(GV.LibraryDir.GUIElement)
local ListFrame = require(GV.FramesDir.ListFrame)
setmetatable(GUIObject,GUIElement)
GV.ObjectList = {}

function GUIObject.new(Arguments, Parent)
    local self = GUIElement.new(Arguments, Parent or ListFrame.new().Content)
    setmetatable(self,GUIObject)
    self.Object = nil
    self.MainMovable = nil
    GV.ObjectList[#GV.ObjectList+1] = self
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