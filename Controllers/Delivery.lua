local Delivery = {}

local function GetTools(parent)
	local tools = {}
	for i, v in parent:GetChildren() do
		if v:IsA("Tool") and v.Name:match("^%u%d$") and v:FindFirstChild("Handle") and v:FindFirstChild("House") and (parent ~= workspace or (v.Handle.Position - Vector3.new(54.45, 4.02, -16.56)).Magnitude < 30) then
			table.insert(tools, v)
		end
	end

	return tools
end

local function GetHouseByAddress(address)
	for i, v in workspace.Houses:GetChildren() do
		if v:FindFirstChild("Address") and v.Address.Value == address and v:FindFirstChild("GivePizza", true) then
			return v:FindFirstChild("GivePizza", true)
		end
	end
end

do
	function PickUpTools(playerController, config)
		local player = playerController:GetPlayer()
		local tools = GetTools(workspace)
		if #tools > 0 or (tools[1] and tools[1].Handle:FindFirstChild("X10")) then
			if (playerController:GetRootPart().Position - Vector3.new(54.45, 4.02, -15)).Magnitude >= 10 then
				playerController:TeleportCharacter(CFrame.new(54.45, 4.02, -15), config.VELOCITY)
				task.wait(0.1)
			end

			for i, v in tools do
				if v.Parent == workspace then
					playerController:TeleportCharacter(( v.Handle and v.Handle.CFrame ), config.VELOCITY * 1.5)
					task.wait(.5)
				end
			end

			task.wait(0.3)
			playerController:TeleportCharacter(CFrame.new(54.45, 4.02, -15), config.VELOCITY)
		end
	end

	function DeliveryTools(playerController, config)
		local player = playerController:GetPlayer()
		local tools = GetTools(player.Backpack)
		if #tools >= (not config.DELIVERY_AT and 3 or config.DELIVERY_AT) then
			table.sort(tools, function(a, b)
				a, b = tostring(a), tostring(b)
				if (a:sub(1, 1) == "B" and b:sub(1, 1) == "B") then
					return a < b
				end

				return a > b
			end)

			local isEncounter = false
			local rootPart = playerController:GetRootPart()
			for i, v in tools do
				local house = GetHouseByAddress(v.Name)
				local housePosition = house and house.Position
				if house then
					if (house.Position - rootPart.Position).Magnitude >= 10 then
						playerController:TeleportCharacter(house.CFrame + Vector3.new(0, 5, 0), config.VELOCITY)

						playerController:MoveTool(v, playerController:GetCharacter())
						task.wait(1.2)
						
						for i, k in GetTools(playerController:GetCharacter()) do
							if k ~= v then
								playerController:MoveTool(k, player.Backpack)
							end
						end

						task.wait(2)
						isEncounter = false
					else
						task.wait(isEncounter and 0.2 or 0.7)

						playerController:MoveTool(v, playerController:GetCharacter())
						isEncounter = true
					end
				end
			end
		end
	end
end

function Delivery.Init(playerController, config)
	PickUpTools(playerController, config)
	DeliveryTools(playerController, config)
end

return Delivery
