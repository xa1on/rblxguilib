local m = {}

-- list of services that i use sometimes
m.HistoryService = game:GetService("ChangeHistoryService")
m.Selection = game:GetService("Selection")
m.RepStorage = game:GetService("ReplicatedFirst")
m.coreGui = game:GetService("CoreGui")

m.moduleDir = script.Parent.modules
-- get rblxwidget library
m.widgetlib = require(m.moduleDir.rblxwidgetlib)

return m