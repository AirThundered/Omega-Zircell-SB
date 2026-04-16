local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

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

local function CreateHL(char)
    if char and char:FindFirstChild("ZIRCELL_HL") then
        return
    end

    local hl = Instance.new("Highlight")
    hl.Name = "ZIRCELL_HL"
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



