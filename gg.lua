-- LocalScript

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Ambil Jump Button bawaan Roblox
local touchGui = playerGui:WaitForChild("TouchGui")
local touchFrame = touchGui:WaitForChild("TouchControlFrame")
local jumpButton = touchFrame:WaitForChild("JumpButton")

-- GUI Setting
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 220)
frame.Position = UDim2.new(0, 20, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Fungsi bikin tombol
local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn)
	return btn
end

-- Tombol
local bigger = createButton("Perbesar Jump", 10)
local smaller = createButton("Perkecil Jump", 55)
local up = createButton("Geser Atas", 100)
local down = createButton("Geser Bawah", 145)
local left = createButton("Geser Kiri", 190)
local right = createButton("Geser Kanan", 235)

-- Aksi
bigger.MouseButton1Click:Connect(function()
	jumpButton.Size += UDim2.new(0, 10, 0, 10)
end)

smaller.MouseButton1Click:Connect(function()
	jumpButton.Size -= UDim2.new(0, 10, 0, 10)
end)

up.MouseButton1Click:Connect(function()
	jumpButton.Position -= UDim2.new(0, 0, 0, 10)
end)

down.MouseButton1Click:Connect(function()
	jumpButton.Position += UDim2.new(0, 0, 0, 10)
end)

left.MouseButton1Click:Connect(function()
	jumpButton.Position -= UDim2.new(0, 10, 0, 0)
end)

right.MouseButton1Click:Connect(function()
	jumpButton.Position += UDim2.new(0, 10, 0, 0)
end)
