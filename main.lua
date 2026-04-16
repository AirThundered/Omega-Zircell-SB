local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local WalkSpeed = 20
local JumpPower = 50
local TeleportToMouseToggle = false
local ESPToggle = false
local TeleportKey = Enum.KeyCode.Z
local OpenCloseButton = Enum.KeyCode.LeftControl

local ZircellFrame = nil
local IsTwenningZircellFrame = false

local rebindConnections = {}

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
	frame.BackgroundTransparency = 0.2
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.2, 0, 0.5, 0)
	
	ZircellFrame = frame
	
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
	
	local uiListLayout = Instance.new("UIListLayout", utilities)
	uiListLayout.Padding = UDim.new(0, 5)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	uiListLayout.FillDirection = Enum.FillDirection.Vertical
	
	local uiPadding = Instance.new("UIPadding", utilities)
	uiPadding.PaddingTop = UDim.new(0, 0)
	uiPadding.PaddingBottom = UDim.new(0, 0)
	
	local closeFrame = Instance.new("Frame", utilities)
	closeFrame.Size = UDim2.new(0.95, 0, 0.1, 0)
	closeFrame.BackgroundTransparency = 1
	closeFrame.LayoutOrder = 0
	
	local closeText = Instance.new("TextLabel", closeFrame)
	closeText.Size = UDim2.new(0.7, 0, 1, 0)
	closeText.Text = "Open/Close Button"
	closeText.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeText.TextScaled = true
	closeText.BackgroundTransparency = 1
	closeText.Font = Enum.Font.FredokaOne
	closeText.FontFace.Weight = Enum.FontWeight.Bold
	
	local closeButton = Instance.new("TextButton", closeFrame)
	closeButton.Size = UDim2.new(0.3, 0, 1, 0)
	closeButton.Position = UDim2.new(0.7, 0, 0, 0)
	closeButton.Text = "LeftControl"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextScaled = true
	closeButton.BackgroundTransparency = 1
	closeButton.Font = Enum.Font.FredokaOne
	closeButton.FontFace.Weight = Enum.FontWeight.Bold

	local function startRebind()
		if rebindConnections["OCB"] then
			rebindConnections["OCB"]:Disconnect()
			rebindConnections["OCB"] = nil
		end
		closeButton.Text = "Press a key..."
		closeButton.TextColor3 = Color3.fromRGB(255, 255, 0)
		rebindConnections["OCB"] = UserInputService.InputBegan:Connect(function(input, gpe)

			if input.UserInputType == Enum.UserInputType.Keyboard then
				OpenCloseButton = input.KeyCode
				closeButton.Text = input.KeyCode.Name
				closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				rebindConnections["OCB"]:Disconnect()
				rebindConnections["OCB"] = nil
			end
		end)
	end

	closeButton.Activated:Connect(startRebind)
	
	local speedFrame = Instance.new("Frame", utilities)
	speedFrame.Size = UDim2.new(0.95, 0, 0.1, 0)
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
	speedButton.Text = "Set Speed"
	speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedButton.TextScaled = true
	speedButton.BackgroundTransparency = 1
	speedButton.Font = Enum.Font.FredokaOne
	speedButton.FontFace.Weight = Enum.FontWeight.Bold
	
	speedButton.Activated:Connect(function()
		WalkSpeed = tonumber(speedTextBox.Text)
	end)
	
	local jumpFrame = Instance.new("Frame", utilities)
	jumpFrame.Size = UDim2.new(0.95, 0, 0.1, 0)
	jumpFrame.BackgroundTransparency = 1
	jumpFrame.LayoutOrder = 2

	local jumpTextBox = Instance.new("TextBox", jumpFrame)
	jumpTextBox.Size = UDim2.new(0.7, 0, 1, 0)
	jumpTextBox.PlaceholderText = "50"
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
	jumpButton.Text = "Set Jump"
	jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	jumpButton.TextScaled = true
	jumpButton.BackgroundTransparency = 1
	jumpButton.Font = Enum.Font.FredokaOne
	jumpButton.FontFace.Weight = Enum.FontWeight.Bold

	jumpButton.Activated:Connect(function()
		JumpPower = tonumber(jumpTextBox.Text)
	end)
	
	local teleportFrame = Instance.new("Frame", utilities)
	teleportFrame.Size = UDim2.new(0.95, 0, 0.1, 0)
	teleportFrame.BackgroundTransparency = 1
	teleportFrame.LayoutOrder = 3
	
	local teleportText = Instance.new("TextLabel", teleportFrame)
	teleportText.Size = UDim2.new(0.7, 0, 1, 0)
	teleportText.Text = "Teleport to Mouse"
	teleportText.TextColor3 = Color3.fromRGB(255, 255, 255)
	teleportText.TextScaled = true
	teleportText.BackgroundTransparency = 1
	teleportText.Font = Enum.Font.FredokaOne
	teleportText.FontFace.Weight = Enum.FontWeight.Bold

	local teleportButton = Instance.new("TextButton", teleportFrame)
	teleportButton.Size = UDim2.new(0.3, 0, 1, 0)
	teleportButton.Position = UDim2.new(0.7, 0, 0, 0)
	teleportButton.Text = "False"
	teleportButton.TextColor3 = Color3.fromRGB(255, 0, 0)
	teleportButton.TextScaled = true
	teleportButton.BackgroundTransparency = 1
	teleportButton.Font = Enum.Font.FredokaOne
	teleportButton.FontFace.Weight = Enum.FontWeight.Bold
	
	teleportButton.Activated:Connect(function()
		if teleportButton.Text == "False" then
			teleportButton.Text = "True"
			teleportButton.TextColor3 = Color3.fromRGB(0, 255, 0)
			TeleportToMouseToggle = true
		else
			teleportButton.Text = "False"
			teleportButton.TextColor3 = Color3.fromRGB(255, 0, 0)
			TeleportToMouseToggle = false
		end
	end)
	
	local teleportFrameRebind = Instance.new("Frame", utilities)
	teleportFrameRebind.Size = UDim2.new(0.95, 0, 0.1, 0)
	teleportFrameRebind.BackgroundTransparency = 1
	teleportFrameRebind.LayoutOrder = 4

	local teleportRebindText = Instance.new("TextLabel", teleportFrameRebind)
	teleportRebindText.Size = UDim2.new(0.7, 0, 1, 0)
	teleportRebindText.Text = "Teleport Button"
	teleportRebindText.TextColor3 = Color3.fromRGB(255, 255, 255)
	teleportRebindText.TextScaled = true
	teleportRebindText.BackgroundTransparency = 1
	teleportRebindText.Font = Enum.Font.FredokaOne
	teleportRebindText.FontFace.Weight = Enum.FontWeight.Bold

	local teleportRebindButton = Instance.new("TextButton", teleportFrameRebind)
	teleportRebindButton.Size = UDim2.new(0.3, 0, 1, 0)
	teleportRebindButton.Position = UDim2.new(0.7, 0, 0, 0)
	teleportRebindButton.Text = "Z"
	teleportRebindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	teleportRebindButton.TextScaled = true
	teleportRebindButton.BackgroundTransparency = 1
	teleportRebindButton.Font = Enum.Font.FredokaOne
	teleportRebindButton.FontFace.Weight = Enum.FontWeight.Bold

	local function startTeleportRebind()
		if rebindConnections["TtMB"] then
			rebindConnections["TtMB"]:Disconnect()
			rebindConnections["TtMB"] = nil
		end
		teleportRebindButton.Text = "Press a key..."
		teleportRebindButton.TextColor3 = Color3.fromRGB(255, 255, 0)
		rebindConnections["TtMB"] = UserInputService.InputBegan:Connect(function(input, gpe)

			if input.UserInputType == Enum.UserInputType.Keyboard then
				TeleportKey = input.KeyCode
				teleportRebindButton.Text = input.KeyCode.Name
				teleportRebindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				rebindConnections["TtMB"]:Disconnect()
				rebindConnections["TtMB"] = nil
			end
		end)
	end

	teleportRebindButton.Activated:Connect(startTeleportRebind)
	
	local getEmotesFrame = Instance.new("Frame", utilities)
	getEmotesFrame.Size = UDim2.new(0.95, 0, 0.1, 0)
	getEmotesFrame.BackgroundTransparency = 1
	getEmotesFrame.LayoutOrder = 5

	local getEmotesText = Instance.new("TextLabel", getEmotesFrame)
	getEmotesText.Size = UDim2.new(0.7, 0, 1, 0)
	getEmotesText.Text = "Animation Pack"
	getEmotesText.TextColor3 = Color3.fromRGB(255, 255, 255)
	getEmotesText.TextScaled = true
	getEmotesText.BackgroundTransparency = 1
	getEmotesText.Font = Enum.Font.FredokaOne
	getEmotesText.FontFace.Weight = Enum.FontWeight.Bold

	local getEmotesButton = Instance.new("TextButton", getEmotesFrame)
	getEmotesButton.Size = UDim2.new(0.3, 0, 1, 0)
	getEmotesButton.Position = UDim2.new(0.7, 0, 0, 0)
	getEmotesButton.Text = "Claim"
	getEmotesButton.TextColor3 = Color3.fromRGB(255, 255, 0)
	getEmotesButton.TextScaled = true
	getEmotesButton.BackgroundTransparency = 1
	getEmotesButton.Font = Enum.Font.FredokaOne
	getEmotesButton.FontFace.Weight = Enum.FontWeight.Bold
	
	getEmotesButton.Activated:Connect(function()
		if game.GameId ~= 6403373529 then
			getEmotesButton.Text = "Error"
			getEmotesButton.TextColor3 = Color3.fromRGB(255, 0, 0)
			return
		end
		
		local emotes = ReplicatedStorage:WaitForChild("AnimationPack"):GetChildren()
		local emotesFolder = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(player.Name):WaitForChild("Emotes")

		for i, emote in pairs(emotes) do
			emotesFolder:FindFirstChild("EquippedSlot"..i).Value = emote.Name
		end

		getEmotesButton.Text = "Claimed"
		getEmotesButton.TextColor3 = Color3.fromRGB(0, 255, 0)
	end)
	
	local espFrame = Instance.new("Frame", utilities)
	espFrame.Size = UDim2.new(0.95, 0, 0.1, 0)
	espFrame.BackgroundTransparency = 1
	espFrame.LayoutOrder = 6

	local espText = Instance.new("TextLabel", espFrame)
	espText.Size = UDim2.new(0.7, 0, 1, 0)
	espText.Text = "ESP"
	espText.TextColor3 = Color3.fromRGB(255, 255, 255)
	espText.TextScaled = true
	espText.BackgroundTransparency = 1
	espText.Font = Enum.Font.FredokaOne
	espText.FontFace.Weight = Enum.FontWeight.Bold

	local espButton = Instance.new("TextButton", espFrame)
	espButton.Size = UDim2.new(0.3, 0, 1, 0)
	espButton.Position = UDim2.new(0.7, 0, 0, 0)
	espButton.Text = "False"
	espButton.TextColor3 = Color3.fromRGB(255, 0, 0)
	espButton.TextScaled = true
	espButton.BackgroundTransparency = 1
	espButton.Font = Enum.Font.FredokaOne
	espButton.FontFace.Weight = Enum.FontWeight.Bold

	espButton.Activated:Connect(function()
		if espButton.Text == "False" then
			espButton.Text = "True"
			espButton.TextColor3 = Color3.fromRGB(0, 255, 0)
			ESPToggle = true
		else
			espButton.Text = "False"
			espButton.TextColor3 = Color3.fromRGB(255, 0, 0)
			ESPToggle = false
		end
	end)
end


local function CreateHL(char)
	if char and char:FindFirstChild("Zircell_Highlight") or char == player.Character then
		return
	end

	local hl = Instance.new("Highlight")
	hl.Name = "Zircell_Highlight"
	hl.FillColor = Color3.fromRGB(255, 0, 0)
	hl.OutlineColor = Color3.fromRGB(150, 0, 0)
	hl.FillTransparency = 0.5
	hl.Parent = char
end

local function RemoveHL(char)
	if char and char == player.Character then
		return
	end
	if char and char:FindFirstChild("Zircell_Highlight") then
		char.Zircell_Highlight:Destroy()
	end
end

local function CloseZircellFrame()
	if IsTwenningZircellFrame then return end

	local tween1 = TweenService:Create(ZircellFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 0)})
	local tween2 = TweenService:Create(ZircellFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0.2, 0, 0.5, 0)})
	if ZircellFrame.Visible then
		IsTwenningZircellFrame = true
		tween1:Play()
		tween1.Completed:Connect(function()
			ZircellFrame.Visible = false
			IsTwenningZircellFrame = false
		end)
	else
		IsTwenningZircellFrame = true
		ZircellFrame.Visible = true
		tween2:Play()
		tween2.Completed:Connect(function()
			IsTwenningZircellFrame = false
		end)
	end
end

SetupGui()

RunService.Heartbeat:Connect(function()
	local char = player.Character
	local hum = char and char:FindFirstChild("Humanoid")
	
	if char and hum and hum.Health > 0 then
		hum.UseJumpPower = true
		hum.WalkSpeed = WalkSpeed or 20
		hum.JumpPower = JumpPower or 50
	end
	
	if ESPToggle then
		for i, plr in pairs(Players:GetPlayers()) do
			CreateHL(plr.Character)
		end
	else
		for i, plr in pairs(Players:GetPlayers()) do
			RemoveHL(plr.Character)
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == OpenCloseButton then
		CloseZircellFrame()
	elseif input.KeyCode == TeleportKey and TeleportToMouseToggle then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(player:GetMouse().Hit.Position)
		else
	end
end)