--[[ 
Versi stabil:
1. Log UI terbatas tinggi
2. Log selalu sinkron dengan delta log
3. List RemoteEvents bersih
4. Path resolve lebih aman
--]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

--========================
-- NETFOLDER (lebih aman)
--========================
local NetFolder
pcall(function()
    NetFolder = ReplicatedStorage:WaitForChild("Packages", 5)
    if NetFolder then
        NetFolder = NetFolder:FindFirstChild("_Index")
        if NetFolder then
            NetFolder = NetFolder:FindFirstChild("sleitnick_net@0.2.0")
            if NetFolder then
                NetFolder = NetFolder:FindFirstChild("net")
            end
        end
    end
end)

--========================
-- UI SETUP
--========================
local gui = Instance.new("ScreenGui")
gui.Name = "NetRemoteTester"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 250)
main.Position = UDim2.new(0.5, -200, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Parent = gui

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

local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-32)
content.Position = UDim2.new(0,0,0,32)
content.BackgroundTransparency = 1
content.Parent = main

-- LEFT PANEL (input + execute + log)
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.6,0,1,0)
leftPanel.Position = UDim2.new(0,0,0,0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = content

local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-20,0,36)
input.Position = UDim2.new(0,10,0,10)
input.PlaceholderText = "Masukkan path atau klik list"
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

local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1,-20,1,-95)
logFrame.Position = UDim2.new(0,10,0,95)
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

-- RIGHT PANEL (list remotes)
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0.4, -10, 1, -10)
listFrame.Position = UDim2.new(0.6, 5, 0, 5)
listFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
listFrame.CanvasSize = UDim2.new(0,0,0,0)
listFrame.ScrollBarThickness = 6
listFrame.Parent = content

--========================
-- LOG FUNCTION
--========================
local function addLog(text)
	print(text) -- log delta
	logLabel.Text ..= text .. "\n"
	local maxHeight = 180
	logLabel.Size = UDim2.new(1,0,0, math.min(logLabel.TextBounds.Y, maxHeight))
	logFrame.CanvasSize = UDim2.new(0,0,0,logLabel.TextBounds.Y)
	logFrame.CanvasPosition = Vector2.new(0, logLabel.TextBounds.Y)
end

--========================
-- CLOSE BUTTON
--========================
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--========================
-- RESOLVE PATH
--========================
local function resolvePath(folder, fullPath)
	local current = folder
	for part in string.gmatch(fullPath, "[^/]+") do
		if current then
			current = current:FindFirstChild(part)
		else
			return nil
		end
	end
	return current
end

--========================
-- SCAN REMOTES
--========================
local remotePaths = {}
local function scanRemotes(folder, prefix)
	prefix = prefix or ""
	for _, obj in ipairs(folder:GetChildren()) do
		local currentPath = prefix ~= "" and (prefix.."/"..obj.Name) or obj.Name
		if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
			table.insert(remotePaths, currentPath)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-10,0,24)
			btn.Position = UDim2.new(0,0,0,(#listFrame:GetChildren()-1)*26)
			btn.Text = currentPath
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 14
			btn.TextColor3 = Color3.new(1,1,1)
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.Parent = listFrame
			btn.MouseButton1Click:Connect(function()
				input.Text = currentPath
			end)
		end
		if #obj:GetChildren() > 0 then
			scanRemotes(obj, currentPath)
		end
	end
	listFrame.CanvasSize = UDim2.new(0,0,0,(#listFrame:GetChildren()-1)*26)
end

if NetFolder then
	addLog("[SYSTEM] Scan RemoteEvents/Functions...")
	scanRemotes(NetFolder)
	addLog("[SYSTEM] Scan selesai!")
else
	addLog("[ERROR] NetFolder tidak ditemukan. Delta Mobile mungkin berbeda.")
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

	local target = resolvePath(NetFolder, path)
	if not target then
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
		if target:IsA("RemoteEvent") then
			target:FireServer(finalArg)
		elseif target:IsA("RemoteFunction") then
			local r = target:InvokeServer(finalArg)
			addLog("[RECV]: "..tostring(r))
		else
			addLog("[ERROR]: Target bukan RemoteEvent/Function")
		end
	end)
	if not status then
		addLog("[ERROR]: "..tostring(res))
	end
end)
