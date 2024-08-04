local Player = {}
Player.__index = Player

function Player.new(v: Player)
	local self = setmetatable({}, Player)

	self.player = v
	self.character = (v.Character or v.CharacterAdded:Wait())
	v.CharacterAdded:Connect(function(Character)
		self.character = Character
	end)

	return self
end

function Player:GetPlayer(): Player
	return self.player
end

function Player:GetCharacter(): Model
	return self.character
end

function Player:GetRootPart(): Part
	return self:GetCharacter():WaitForChild("HumanoidRootPart", 95)
end

function Player:GetHumanoid(): Humanoid
	return self:GetCharacter():WaitForChild("Humanoid", 95)
end

function Player:TeleportCharacter(Cf: CFrame, velocity: number)
	local rootPart = self:GetRootPart()
	local initial = (Cf - Cf.Position) + rootPart.Position + Vector3.new(0, 4, 0)

	local lastGravity = workspace.Gravity
	workspace.Gravity = 0

	local difference = (Cf.Position - rootPart.Position)
	for i = 0, difference.Magnitude, (not velocity and 10 or velocity) do
		self:GetHumanoid().Sit = false
		rootPart.CFrame = initial + difference.Unit * i
		rootPart.Velocity, rootPart.RotVelocity = Vector3.new(), Vector3.new()
		task.wait()
	end

	rootPart.CFrame = Cf
	workspace.Gravity = lastGravity
end

function Player:MoveTool(tool: Tool, path: Instance): boolean & string
	local s,e = pcall(function()
		tool.Parent = path
	end)

	return s and true or false, s and nil or e
end

function Player:ChangeHumanoidProperty(name: string, value): boolean & string
	local humanoid = self:GetHumanoid()
	if not humanoid then return end

	local s,e = pcall(function()
		humanoid[name] = value
	end)

	return s and true or false, s and nil or e
end

function Player:ChangeHumanoidState(v: Enum.HumanoidStateType): boolean & string
	local humanoid = self:GetHumanoid()
	if not humanoid then return end

	local s,e = pcall(function()
		humanoid:ChangeState(v)
	end)

	return s and true or false, s and nil or e
end

return Player
