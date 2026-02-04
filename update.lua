--// Net Remote Tester - FIXED 100%
--// LocalScript

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

--========================
-- BASE NET PATH
--========================
local NetFolder = ReplicatedStorage
	:WaitForChild("Packages")
	:WaitForChild("_Index")
	:WaitForChild("sleitnick_net@0.2.0")
	:WaitForChild("net")

--========================
-- UI SETUP
--========================
local gui = Instance.new("ScreenGui")
gui.Name = "NetRemoteTester"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 200)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

--========================
-- HEADER
--========================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 32)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Net Remote Tester"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -58, 0, 3)
minBtn.Text = "_"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minBtn.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -30, 0, 3)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 60, 60)
closeBtn.Parent = header

--========================
-- INPUT
--========================
local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 36)
input.Position = UDim2.new(0, 10, 0, 45)
input.PlaceholderText = "RE/EquipToolFromHotbar | 1"
input.ClearTextOnFocus = false
input.Font = Enum.Font.SourceSans
input.TextSize = 14
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.Parent = main

--========================
-- EXECUTE BUTTON
--========================
local exec = Instance.new("TextButton")
exec.Size = UDim2.new(1, -20, 0, 32)
exec.Position = UDim2.new(0, 10, 0, 90)
exec.Text = "EXECUTE"
exec.Font = Enum.Font.SourceSansBold
exec.TextSize = 14
exec.TextColor3 = Color3.new(1, 1, 1)
exec.BackgroundColor3 = Color3.fromRGB(70, 140, 90)
exec.Parent = main

--========================
-- LOG
--========================
local log = Instance.new("TextLabel")
log.Size = UDim2.new(1, -20, 0, 60)
log.Position = UDim2.new(0, 10, 0, 130)
log.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
log.TextColor3 = Color3.fromRGB(0, 255, 0)
log.Font = Enum.Font.Code
log.TextSize = 12
log.TextWrapped = true
log.TextXAlignment = Enum.TextXAlignment.Left
log.TextYAlignment = Enum.TextYAlignment.Top
log.Text = "[SYSTEM] Ready\n"
log.Parent = main

--========================
-- DRAG SUPPORT
--========================
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(inputObj)
	if inputObj.UserInputType == Enum.UserInputType.MouseButton1
	or inputObj.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = inputObj.Position
		startPos = main.Position
	end
end)

UIS.InputChanged:Connect(function(inputObj)
	if dragging and (inputObj.UserInputType == Enum.UserInputType.MouseMovement
	or inputObj.UserInputType == Enum.UserInputType.Touch) then
		local delta = inputObj.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(inputObj)
	if inputObj.UserInputType == Enum.UserInputType.MouseButton1
	or inputObj.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

--========================
-- BUTTON LOGIC
--========================
local minimized = false

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, v in ipairs(main:GetChildren()) do
		if v ~= header then
			v.Visible = not minimized
		end
	end
	main.Size = minimized and UDim2.new(0, 260, 0, 32)
		or UDim2.new(0, 260, 0, 200)
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--========================
-- EXECUTE LOGIC
--========================
exec.MouseButton1Click:Connect(function()
	local raw = input.Text
	if raw == "" then
		log.Text ..= "[ERROR] Input kosong\n"
		return
	end

	local path, arg = raw:match("([^|]+)|?(.*)")
	path = path and path:match("^%s*(.-)%s*$")
	arg = arg and arg:match("^%s*(.-)%s*$")

	local current = NetFolder
	for part in string.gmatch(path, "[^/]+") do
		current = current:FindFirstChild(part)
		if not current then
			log.Text ..= "[ERROR] Path tidak valid: "..path.."\n"
			return
		end
	end

	local finalArg = nil
	if arg ~= "" then
		finalArg = tonumber(arg) or arg
	end

	if current:IsA("RemoteEvent") then
		current:FireServer(finalArg)
		log.Text ..= "[SEND] FireServer -> "..path.." ("..tostring(finalArg)..")\n"

	elseif current:IsA("RemoteFunction") then
		local res = current:InvokeServer(finalArg)
		log.Text ..= "[RECV] "..tostring(res).."\n"

	else
		log.Text ..= "[ERROR] Target bukan RemoteEvent / RemoteFunction\n"
	end
end)
