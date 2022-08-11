local GuiService = game:GetService("GuiService")
local Widget = {}
Widget.__index = Widget

local GV = require(script.Parent.Parent.PluginGlobalVariables)
local plugin = GV.PluginObject
local util = require(GV.LibraryDir.GUIUtil)
local InputManager = require(GV.ManagersDir.InputManager)
local GUIFrame = require(GV.FramesDir.GUIFrame)
local TitlebarMenu = require(GV.FramesDir.TitlebarMenu)
local BackgroundFrame = require(GV.FramesDir.BackgroundFrame)
setmetatable(Widget,GUIFrame)
GV.PluginWidgets = {}
local Unnamed = 0

function Widget:RecievePage(Page, ReplayTask)
    if not ReplayTask then require(GV.ManagersDir.SaveManager).TaskAppend("movepage", Page.ID, self.ID) end
    Page.TabFrame.Parent = self.TitlebarMenu.TabContainer
    Page.Content.Parent = self.TitlebarMenu.ContentContainers
    Page.TitlebarMenu = self.TitlebarMenu
    Page.InsideWidget = true
    Page.Parent = self.TitlebarMenu.TitlebarMenu
    self.TitlebarMenu:AddPage(Page)
end

function Widget.new(ID, title, InitiallyEnabled, NoTitlebarMenu, DockState, OverrideRestore)
    local self = GUIFrame.new()
    setmetatable(self, Widget)
    self.ID = ID or math.random()
    if not title then
        title = ID
        if not title then
            Unnamed += 1
            title = "Unnamed #" .. tostring(Unnamed)
        end
    end
    title = title or ID or "Unnamed"
    DockState = DockState or Enum.InitialDockState.Float
    if InitiallyEnabled then InitiallyEnabled = true else InitiallyEnabled = false end
    if OverrideRestore then OverrideRestore = true else OverrideRestore = false end
    self.WidgetObject = plugin:CreateDockWidgetPluginGui(self.ID, DockWidgetPluginGuiInfo.new(DockState, InitiallyEnabled, OverrideRestore, 300, 500, 50, 50))
    self.WidgetObject.Title = title
    self.BackgroundFrame = BackgroundFrame.new(self.WidgetObject)
    self.InputFrame = Instance.new("Frame", self.WidgetObject)
    self.InputFrame.BackgroundTransparency = 1
    self.InputFrame.Size = UDim2.new(1,0,1,0)
    self.InputFrame.ZIndex = 100
    self.InputFrame.Name = "InputFrame"
    local FixPosition = false
    local FixPage = nil
    self.InputFrame.MouseMoved:Connect(function()
        if not FixPosition then return end
        FixPosition = false
        local MousePos = self.WidgetObject:GetRelativeMousePosition()
        FixPage.TabFrame.Position = UDim2.new(0,MousePos.X + FixPage.InitialX + self.TitlebarMenu.ScrollingMenu.CanvasPosition.X, 0,0)
        self.TitlebarMenu:BeingDragged(FixPage.ID)
        self.TitlebarMenu:FixPageLayout()
    end)
    InputManager.AddInput(self.InputFrame)
    if not NoTitlebarMenu then self.TitlebarMenu = TitlebarMenu.new(self.WidgetObject, self.ID) end
    self.WidgetObject.PluginDragDropped:Connect(function()
        if(GV.SelectedPage and self.TitlebarMenu) then
            self:RecievePage(GV.SelectedPage)
            FixPosition = true
            FixPage = GV.SelectedPage
            self.TitlebarMenu:SetActive(GV.SelectedPage.ID)
            GV.SelectedPage = nil
        end
    end)
    for _, v in pairs(GV.TitleBarButtons) do
        v:CreateCopy(self.TitlebarMenu)
    end
    self.Parent = self.WidgetObject
    self.Content = self.WidgetObject
    GV.PluginWidgets[#GV.PluginWidgets+1] = self
    return self
end

return Widget