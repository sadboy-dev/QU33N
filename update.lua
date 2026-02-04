local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

-- NET FOLDER (Delta Mobile)
local NetFolder = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

-- SIMPAN REFERENCE REMOTE
local RemoteRefs = {}

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "NetRemoteTester"
gui.Parent = Player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 220)
main.Position = UDim2.new(0.5, -210, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Parent = gui

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,32)
header.BackgroundColor3 = Color3.fromRGB(45,45,45)
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-30,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "Net Remote Tester"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,26,0,26)
closeBtn.Position = UDim2.new(1,-30,0,3)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(170,60,60)
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- CONTENT LEFT (input + execute + log)
local content = Instance.new("Frame")
content.Size = UDim2.new(1,-130,1,-32) -- sisakan 130px untuk list
content.Position = UDim2.new(0,0,0,32)
content.BackgroundTransparency = 1
content.Parent = main

local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-20,0,36)
input.Position = UDim2.new(0,10,0,10)
input.PlaceholderText = "Masukkan argumen (contoh: 1)"
input.ClearTextOnFocus = false
input.Font = Enum.Font.SourceSans
input.TextSize = 14
input.TextColor3 = Color3.new(1,1,1)
input.BackgroundColor3 = Color3.fromRGB(50,50,50)
input.Parent = content

local exec = Instance.new("TextButton")
exec.Size = UDim2.new(1,-20,0,32)
exec.Position = UDim2.new(0,10,0,55)
exec.Text = "EXECUTE"
exec.Font = Enum.Font.SourceSansBold
exec.TextSize = 14
exec.TextColor3 = Color3.new(1,1,1)
exec.BackgroundColor3 = Color3.fromRGB(70,140,90)
exec.Parent = content

-- LOG
local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1,-20,0,110)
logFrame.Position = UDim2.new(0,10,0,95)
logFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
logFrame.ScrollBarThickness = 6
logFrame.CanvasSize = UDim2.new(0,0,0,0)
logFrame.Parent = content

local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1,0,0,0)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = Color3.fromRGB(0,255,0)
logLabel.Font = Enum.Font.Code
logLabel.TextSize = 12
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.TextWrapped = true
logLabel.Text = "[SYSTEM] Ready\n"
logLabel.Parent = logFrame

local function addLog(text)
	print(text)
	logLabel.Text ..= text .. "\n"
	logLabel.Size = UDim2.new(1,0,0, math.min(logLabel.TextBounds.Y, 150))
	logFrame.CanvasSize = UDim2.new(0,0,0,logLabel.TextBounds.Y)
	logFrame.CanvasPosition = Vector2.new(0,logLabel.TextBounds.Y)
end

-- LIST REMOTE DI KANAN
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0,120,1,-10)
listFrame.Position = UDim2.new(1,-125,0,5)
listFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
listFrame.ScrollBarThickness = 6
listFrame.CanvasSize = UDim2.new(0,0,0,0)
listFrame.Parent = main

local function scanRemotes(folder)
	local y = 0
	for _, obj in ipairs(folder:GetChildren()) do
		if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-4,0,24)
			btn.Position = UDim2.new(0,2,0,y)
			btn.Text = obj.Name
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 14
			btn.TextColor3 = Color3.new(1,1,1)
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.Parent = listFrame

			RemoteRefs[obj.Name] = obj -- simpan reference di table

			btn.MouseButton1Click:Connect(function()
				input.Text = obj.Name
			end)
			y = y + 26
		end
		if #obj:GetChildren() > 0 then
			scanRemotes(obj)
		end
	end
	listFrame.CanvasSize = UDim2.new(0,0,y)
end

scanRemotes(NetFolder)
addLog("[SYSTEM] Remote list siap")

-- EXECUTE
exec.MouseButton1Click:Connect(function()
	local name = input.Text
	local target = RemoteRefs[name]
	if not target then
		addLog("[ERROR] Remote tidak valid: "..tostring(name))
		return
	end
	local arg = 1 -- default
	addLog("[REMOTE]: "..target.Name)
	addLog("[PARAMS]: "..tostring(arg))
	addLog("-----------------------------------------")
	pcall(function()
		if target:IsA("RemoteEvent") then
			target:FireServer(arg)
		elseif target:IsA("RemoteFunction") then
			local res = target:InvokeServer(arg)
			addLog("[RECV]: "..tostring(res))
		end
	end)
end)

-- DRAG
local dragging = false
local dragStart, startPos
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
