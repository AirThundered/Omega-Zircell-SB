local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local function SetupGui()
	if player.PlayerGui:FindFirstChild("ZircellGui") then
		player.PlayerGui:FindFirstChild("ZircellGui"):Destroy()
	end

	local gui = Instance.new("ScreenGui", player.PlayerGui)
	gui.Name = "ZircellGui"
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
	title.Font = Enum.Font.SourceSansBold
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

RunService.Heartbeat:Connect(function()
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