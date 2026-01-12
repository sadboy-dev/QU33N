-- LocalScript (StarterPlayerScripts)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Ambil Jump Button bawaan Roblox
local touchGui = playerGui:WaitForChild("TouchGui")
local touchFrame = touchGui:WaitForChild("TouchControlFrame")
local jumpButton = touchFrame:WaitForChild("JumpButton")

-- Default posisi & ukuran JumpButton
local sizeX = jumpButton.Size.X.Offset
local sizeY = jumpButton.Size.Y.Offset
local posX = jumpButton.Position.X.Offset
local posY = jumpButton.Position.Y.Offset

-- =============================
-- Fungsi Clamp
-- =============================
local function clamp(value,min,max)
	return math.clamp(value,min,max)
end

-- =============================
-- Fungsi Simpan / Load Setting Local Aman
-- =============================
local function saveSettings()
	local success, err = pcall(function()
		local data = {
			posX = posX,
			posY = posY,
			sizeX = sizeX,
			sizeY = sizeY
		}
		player:SetAttribute("JumpButtonSettings", HttpService:JSONEncode(data))
	end)
	if not success then
		warn("Gagal save setting: "..tostring(err))
	end
end

local function loadSettings()
	local json = player:GetAttribute("JumpButtonSettings")
	if json and json ~= "" then
		local success, data = pcall(function()
			return HttpService:JSONDecode(json)
		end)
		if success and data then
			posX = data.posX or posX
			posY = data.posY or posY
			sizeX = data.sizeX or sizeX
			sizeY = data.sizeY or sizeY
			if jumpButton and jumpButton.Parent then
				jumpButton.Position = UDim2.new(0,posX,0,posY)
				jumpButton.Size = UDim2.new(0,sizeX,0,sizeY)
			end
		end
	end
end

-- Load setting saat spawn
loadSettings()

-- =============================
-- GUI Setting
-- =============================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,350)
frame.Position = UDim2.new(0,20,0.5,-175)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(50,50,50)
header.BorderSizePixel = 0
header.Text = "Jump Button Controller"
header.TextColor3 = Color3.new(1,1,1)
header.TextScaled = true
header.Parent = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

-- Minimize & Close
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,30,0,30)
minimizeBtn.Position = UDim2.new(1,-70,0,0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = frame
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

-- Container tombol
local container = Instance.new("Frame")
container.Size = UDim2.new(1,0,1,-30)
container.Position = UDim2.new(0,0,0,30)
container.BackgroundTransparency = 1
container.Parent = frame

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Tombol GUI
local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-20,0,35)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.BorderSizePixel = 0
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	Instance.new("UICorner", btn)
	btn.Parent = container
	return btn
end

local bigger = createButton("Perbesar Jump")
local smaller = createButton("Perkecil Jump")
local up = createButton("Geser Atas")
local down = createButton("Geser Bawah")
local left = createButton("Geser Kiri")
local right = createButton("Geser Kanan")

-- =============================
-- Toggle minimize
-- =============================
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	container.Visible = not minimized
	if minimized then
		frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset,0,30)
	else
		frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset,0,350)
	end
end)

-- =============================
-- Tombol Close (simpan setting saat close)
-- =============================
closeBtn.MouseButton1Click:Connect(function()
	saveSettings()
	screenGui.Enabled = false
end)

-- =============================
-- Fungsi Geser JumpButton
-- =============================
local function moveJumpButton(dx, dy)
	local currentPos = jumpButton.Position
	posX = currentPos.X.Offset + dx
	posY = currentPos.Y.Offset + dy
	posX = clamp(posX,0,workspace.CurrentCamera.ViewportSize.X - jumpButton.AbsoluteSize.X)
	posY = clamp(posY,0,workspace.CurrentCamera.ViewportSize.Y - jumpButton.AbsoluteSize.Y)
	TweenService:Create(jumpButton,TweenInfo.new(0.1),{Position=UDim2.new(0,posX,0,posY)}):Play()
	saveSettings()
end

up.MouseButton1Click:Connect(function() moveJumpButton(0,-10) end)
down.MouseButton1Click:Connect(function() moveJumpButton(0,10) end)
left.MouseButton1Click:Connect(function() moveJumpButton(-10,0) end)
right.MouseButton1Click:Connect(function() moveJumpButton(10,0) end)

-- Tombol Perbesar / Perkecil
bigger.MouseButton1Click:Connect(function()
	sizeX = clamp(sizeX+10,20,300)
	sizeY = clamp(sizeY+10,20,300)
	jumpButton.Size = UDim2.new(0,sizeX,0,sizeY)
	saveSettings()
end)

smaller.MouseButton1Click:Connect(function()
	sizeX = clamp(sizeX-10,20,300)
	sizeY = clamp(sizeY-10,20,300)
	jumpButton.Size = UDim2.new(0,sizeX,0,sizeY)
	saveSettings()
end)

-- =============================
-- Drag GUI support HP / PC
-- =============================
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
	                           startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- =============================
-- Double Jump (tap tombol 2x, tinggi normal)
-- =============================
local function setupDoubleJump(char)
	local humanoid = char:WaitForChild("Humanoid")
	local rootPart = char:WaitForChild("HumanoidRootPart")
	local canDoubleJump = true

	humanoid.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Landed then
			canDoubleJump = true
		end
	end)

	UserInputService.JumpRequest:Connect(function()
		local state = humanoid:GetState()
		if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
			if canDoubleJump then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				canDoubleJump = false
			end
		end
	end)
end

-- =============================
-- Speed Run otomatis 21
-- =============================
local desiredSpeed = 21
local function setupSpeedRun(char)
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.WalkSpeed = desiredSpeed
	RunService.RenderStepped:Connect(function()
		if humanoid and humanoid.Parent then
			humanoid.WalkSpeed = desiredSpeed
		end
	end)
end

-- =============================
-- Kebal Damage tapi respawn manual tetap bisa
-- =============================
local function setupInvincible(char)
	local humanoid = char:WaitForChild("Humanoid")
	local maxHealth = humanoid.MaxHealth
	humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if humanoid.Health < maxHealth then
			humanoid.Health = maxHealth
		end
	end)
end

-- =============================
-- Setup semua fitur saat karakter spawn
-- =============================
local function setupCharacter(char)
	setupDoubleJump(char)
	setupSpeedRun(char)
	setupInvincible(char)
end

-- Setup untuk karakter sekarang
if player.Character then
	setupCharacter(player.Character)
end

-- Setup saat respawn / character baru
player.CharacterAdded:Connect(function(char)
	setupCharacter(char)
end)
