local settings = {
	VELOCITY = 15,
	DELIVERY_AT = 3
}

if getconnections then
	for i, v in  getconnections(game:GetService("ScriptContext").Error) do
		v:Disable()
	end
end

local function require(path)
	return loadstring(game:HttpGet(("https://raw.githubusercontent.com/nowkyy/Delivery/main/%s.lua"):format(path)))()
end

local PlayerController = require("Controllers/Player").new(game.Players.LocalPlayer)
local DeliveryController = require("Controllers/Delivery")

local Library = require("Modules/Library")
local window = Library:CreateWindow({
	Name = "Delivery",
	LoadingTitle = "Delivery farm",
	LoadingSubtitle = "By now",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = "DeliveryFarm",
		FileName = "settings"
	},
	KeySystem = false,
})

local tab = window:CreateTab("Main", 4483362458)

if not getgenv().enabled then
	getgenv().enabled = false
end

tab:CreateToggle({
	Name = "Enabled",
	CurrentValue = getgenv().enabled or false,
	Flag = "Enabled",
	Callback = function(state)
		getgenv().enabled = state

		while getgenv().enabled do
			DeliveryController.Init(PlayerController, settings)
			task.wait()
		end
	end
})

tab:CreateSlider({
	Name = "Velocity",
	Range = {15, 50},
	Increment = 1,
	Suffix = "Teleport velocity",
	CurrentValue = 15,
	Flag = "Velocity",
	Callback = function(value)
		settings.VELOCITY = value
	end
})

tab:CreateSlider({
	Name = "Delivery at",
	Range = {1, 20},
	Increment = 1,
	Suffix = "Amount required to deliver",
	CurrentValue = 3,
	Flag = "At",
	Callback = function(value)
		settings.DELIVERY_AT = value
	end
})
