--// Net Remote Tester - Side List + Full Path
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

--========================
-- BASE NET PATH
--========================
local NetFolder
local success, err = pcall(function()
    NetFolder = ReplicatedStorage
        :WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net")
end)
if not success then
    warn("[ERROR] Tidak bisa menemukan NetFolder:", err)
end

--========================
-- UI SETUP
--========================
local gui = Instance.new("ScreenGui")
gui.Name = "NetRemoteTester"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = main

--========================
-- HEADER
--========================
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,32)
header.BackgroundColor3 = Color3.fromRGB(45,45,45)
header.BorderSizePixel = 0
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

--========================
-- CONTENT
--========================
local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-32)
content.Position = UDim2.new(0,0,0,32)
content.BackgroundTransparency = 1
content.Parent = main

--========================
-- LEFT PANEL: INPUT + EXECUTE
--========================
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.6,0,1,0)
leftPanel.Position = UDim2.new(0,0,0,0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = content

local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-20,0,36)
input.Position = UDim2.new(0,10,0,10)
input.PlaceholderText = "Masukkan path / klik list"
input.ClearTextOnFocus = false
input.Font = Enum.Font.SourceSans
input.TextSize = 14
input.TextColor3 = Color3.new(1,1,1)
input.BackgroundColor3 = Color3.fromRGB(50,50,50)
input.Parent = leftPanel

local exec = Instance.new("TextButton")
exec.Size = UDim2.new(1,-20,0,32)
exec.Position = UDim2.new(0,10,0,55)
exec.Text = "EXECUTE"
exec.Font = Enum.Font.SourceSansBold
exec.TextSize = 14
exec.TextColor3 = Color3.new(1,1,1)
exec.BackgroundColor3 = Color3.fromRGB(70,140,90)
exec.Parent = leftPanel

--========================
-- LEFT PANEL: LOG
--========================
local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1,-20,0,180)
logFrame.Position = UDim2.new(0,10,0,100)
logFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
logFrame.CanvasSize = UDim2.new(0,0,0,0)
logFrame.ScrollBarThickness = 6
logFrame.Parent = leftPanel

local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1,0,0,0)
logLabel.Position = UDim2.new(0,0,0,0)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = Color3.fromRGB(0,255,0)
logLabel.Font = Enum.Font.Code
logLabel.TextSize = 12
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.TextWrapped = true
logLabel.Text = "[SYSTEM] Ready\n"
logLabel.Parent = logFrame

--========================
-- RIGHT PANEL: LIST REMOTE
--========================
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0.4, -10, 1, -10)
listFrame.Position = UDim2.new(0.6, 5, 0, 5)
listFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
listFrame.CanvasSize = UDim2.new(0,0,0,0)
listFrame.ScrollBarThickness = 6
listFrame.Parent = content

--========================
-- HELPER LOG
--========================
local function addLog(text)
	logLabel.Text ..= text .. "\n"
	RunService.Heartbeat:Wait()
	logLabel.Size = UDim2.new(1,0,0,logLabel.TextBounds.Y)
	logFrame.CanvasSize = UDim2.new(0,0,0,logLabel.TextBounds.Y)
	logFrame.CanvasPosition = Vector2.new(0,logLabel.TextBounds.Y)
	print(text)
end

--========================
-- DRAG SUPPORT
--========================
local dragging = false
local dragStart, startPos
header.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = main.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local delta = i.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--========================
-- SCAN REMOTES
--========================
local remotePaths = {} -- simpan full path
local function scanRemotes(folder, prefix)
	prefix = prefix or ""
	for _, obj in ipairs(folder:GetChildren()) do
		local currentPath = prefix ~= "" and (prefix.."/"..obj.Name) or obj.Name
		if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
			table.insert(remotePaths, currentPath)

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-10,0,24)
			btn.Position = UDim2.new(0,0,0,(#listFrame:GetChildren()-1)*26)
			btn.Text = currentPath.." ["..obj.ClassName.."]"
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 14
			btn.TextColor3 = Color3.new(1,1,1)
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.Parent = listFrame

			btn.MouseButton1Click:Connect(function()
				input.Text = currentPath
			end)
		end
		-- rekursi untuk folder
		if #obj:GetChildren() > 0 then
			scanRemotes(obj, currentPath)
		end
	end
	RunService.Heartbeat:Wait()
	listFrame.CanvasSize = UDim2.new(0,0,0,(#listFrame:GetChildren()-1)*26)
end

if NetFolder then
	addLog("[SYSTEM] Scan RemoteEvents/Functions...")
	scanRemotes(NetFolder)
	addLog("[SYSTEM] Scan selesai!")
end

--========================
-- RESOLVE PATH
--========================
local function resolvePath(folder, fullPath)
	local current = folder
	for part in string.gmatch(fullPath, "[^/]+") do
		current = current:FindFirstChild(part)
		if not current then
			return nil
		end
	end
	return current
end

--========================
-- EXECUTE LOGIC
--========================
exec.MouseButton1Click:Connect(function()
	local raw = input.Text
	if raw == "" then
		addLog("[ERROR] Input kosong")
		return
	end

	local path, arg = raw:match("([^|]+)|?(.*)")
	path = path and path:match("^%s*(.-)%s*$")
	arg = arg and arg:match("^%s*(.-)%s*$")

	if not NetFolder then
		addLog("[ERROR] NetFolder tidak ditemukan")
		return
	end

	local current = resolvePath(NetFolder, path)
	if not current then
		addLog("[ERROR] Path tidak valid: "..path)
		return
	end

	local finalArg
	if arg ~= "" then
		finalArg = tonumber(arg) or arg
	end

	addLog("[REMOTE]: "..path)
	addLog("[PARAMS]: "..tostring(finalArg))
	addLog("-----------------------------------------")

	local status, res = pcall(function()
		if current:IsA("RemoteEvent") then
			current:FireServer(finalArg)
		elseif current:IsA("RemoteFunction") then
			local ret = current:InvokeServer(finalArg)
			addLog("[RECV]: "..tostring(ret))
		else
			addLog("[ERROR]: Target bukan RemoteEvent / RemoteFunction")
		end
	end)
	if not status then
		addLog("[ERROR]: "..tostring(res))
	end
end)
