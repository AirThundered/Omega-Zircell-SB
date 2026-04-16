local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local WalkSpeed = 20
local JumpPower = 50

local function SetupGui()
	if player.PlayerGui:FindFirstChild("ZircellGui") then
		player.PlayerGui:FindFirstChild("ZircellGui"):Destroy()
	end

	local gui = Instance.new("ScreenGui", player.PlayerGui)
	gui.Name = "ZircellGui"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 1000
	
	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0.2, 0, 0.5, 0)
	frame.Transparency = 0
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.2, 0, 0.5, 0)
	
	local UICorner = Instance.new("UICorner", frame)
	UICorner.CornerRadius = UDim.new(0.1, 0)
	
	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0.1, 0)
	title.Text = "Omega Zircell"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.FredokaOne
	title.FontFace.Weight = Enum.FontWeight.Bold
	
	local utilities = Instance.new("ScrollingFrame", frame)
	utilities.Size = UDim2.new(1, 0, 0.9, 0)
	utilities.Position = UDim2.new(0, 0, 0.1, 0)
	utilities.CanvasSize = UDim2.new(0, 0, 0, 0)
	utilities.ScrollBarThickness = 10
	utilities.BackgroundTransparency = 1
	utilities.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	utilities.ScrollBarImageTransparency = 0.5
	utilities.Active = true
	utilities.Selectable = true
	utilities.ScrollingDirection = Enum.ScrollingDirection.Y
	utilities.AutomaticCanvasSize = Enum.AutomaticSize.Y
	
	local speedFrame = Instance.new("Frame", utilities)
	speedFrame.Size = UDim2.new(1, 0, 0.1, 0)
	speedFrame.BackgroundTransparency = 1
	speedFrame.LayoutOrder = 1
	
	local speedTextBox = Instance.new("TextBox", speedFrame)
	speedTextBox.Size = UDim2.new(0.7, 0, 1, 0)
	speedTextBox.PlaceholderText = "20"
	speedTextBox.Text = ""
	speedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedTextBox.TextScaled = true
	speedTextBox.BackgroundTransparency = 1
	speedTextBox.Font = Enum.Font.FredokaOne
	speedTextBox.FontFace.Weight = Enum.FontWeight.Bold
	speedTextBox.ClearTextOnFocus = false
	
	local speedButton = Instance.new("TextButton", speedFrame)
	speedButton.Size = UDim2.new(0.3, 0, 1, 0)
	speedButton.Position = UDim2.new(0.7, 0, 0, 0)
	speedButton.Text = "Set speed"
	speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedButton.TextScaled = true
	speedButton.BackgroundTransparency = 1
	speedButton.Font = Enum.Font.FredokaOne
	speedButton.FontFace.Weight = Enum.FontWeight.Bold
	
	speedButton.MouseButton1Click:Connect(function()
		WalkSpeed = tonumber(speedTextBox.Text)
	end)
	
	local jumpFrame = Instance.new("Frame", utilities)
	jumpFrame.Size = UDim2.new(1, 0, 0.1, 0)
	jumpFrame.BackgroundTransparency = 1
	jumpFrame.LayoutOrder = 2

	local jumpTextBox = Instance.new("TextBox", jumpFrame)
	jumpTextBox.Size = UDim2.new(0.7, 0, 1, 0)
	jumpTextBox.PlaceholderText = "20"
	jumpTextBox.Text = ""
	jumpTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	jumpTextBox.TextScaled = true
	jumpTextBox.BackgroundTransparency = 1
	jumpTextBox.Font = Enum.Font.FredokaOne
	jumpTextBox.FontFace.Weight = Enum.FontWeight.Bold
	jumpTextBox.ClearTextOnFocus = false

	local jumpButton = Instance.new("TextButton", jumpFrame)
	jumpButton.Size = UDim2.new(0.3, 0, 1, 0)
	jumpButton.Position = UDim2.new(0.7, 0, 0, 0)
	jumpButton.Text = "Set jump"
	jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	jumpButton.TextScaled = true
	jumpButton.BackgroundTransparency = 1
	jumpButton.Font = Enum.Font.FredokaOne
	jumpButton.FontFace.Weight = Enum.FontWeight.Bold

	jumpButton.MouseButton1Click:Connect(function()
		JumpPower = tonumber(jumpTextBox.Text)
	end)
end


local function CreateHL(char)
	if char and char:FindFirstChild("ZIRCELL_HL") then
		return
	end

	local hl = Instance.new("Highlight")
	hl.Name = "Zircell_Highlight"
	hl.FillColor = Color3.fromRGB(200, 200, 255)
	hl.OutlineColor = Color3.fromRGB(0, 0, 255)
	hl.FillTransparency = 0.5
	hl.Parent = char
end

SetupGui()

RunService.Heartbeat:Connect(function()
	local char = player.Character
	local hum = char and char:FindFirstChild("Humanoid")
	
	if char and hum and hum.Health > 0 then
		hum.WalkSpeed = WalkSpeed
		hum.JumpPower = JumpPower
	end
	
	for i, plr in pairs(Players:GetPlayers()) do
		CreateHL(plr.Character)
	end
end)

local SpeedBoost = false

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.R then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(player:GetMouse().Hit.p)
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		if SpeedBoost then
			player.Character.Humanoid.WalkSpeed = 50
			SpeedBoost = false
		else 
			player.Character.Humanoid.WalkSpeed = 20
			SpeedBoost = true
		end
	end
end)



