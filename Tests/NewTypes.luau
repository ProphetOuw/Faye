local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Faye = require(ReplicatedStorage.CAM.Faye)

local thread = Faye.new();

thread:Create("Frame")

thread:Create("UIAspectRatioConstraint")

thread:Create("BillboardGui")

thread:Create("UIShadow")