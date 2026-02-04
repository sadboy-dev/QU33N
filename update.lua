--// Simple Mobile Draggable RemoteEvent Tester UI
--// For Roblox Studio testing/debugging purposes

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

--========================
-- UI CREATION
--========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RemoteTesterUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 200)
Main.Position = UDim2.new(0.5, -130, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 10)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Remote Tester"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.Gotham
Title.BackgroundTransparency = 1
Title.TextXAlignment = Left
Title.Parent = Header

-- Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -55, 0, 2)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Parent = Header

-- Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -28, 0, 2)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = Header

-- Input
local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -20, 0, 35)
Input.Position = UDim2.new(0, 10, 0, 40)
Input.PlaceholderText = "ReplicatedStorage.RemoteName"
Input.Text = ""
Input.ClearTextOnFocus = false
Input.TextSize = 13
Input.Font = Enum.Font.Gotham
Input.BackgroundColor3 = Color3.fromRGB(40,40,40)
Input.TextColor3 = Color3.new(1,1,1)
Input.Parent = Main

-- Execute
local Execute = Instance.new("TextButton")
Execute.Size = UDim2.new(1, -20, 0, 30)
Execute.Position = UDim2.new(0, 10, 0, 80)
Execute.Text = "EXECUTE"
Execute.Font = Enum.Font.GothamBold
Execute.TextSize = 13
Execute.BackgroundColor3 = Color3.fromRGB(70,120,70)
Execute.TextColor3 = Color3.new(1,1,1)
Execute.Parent = Main

-- Log Box
local Log = Instance.new("TextLabel")
Log.Size = UDim2.new(1, -20, 0, 60)
Log.Position = UDim2.new(0, 10, 0, 120)
Log.TextWrapped = true
Log.TextYAlignment = Top
Log.TextXAlignment = Left
Log.TextSize = 11
Log.Font = Enum.Font.Code
Log.BackgroundColor3 = Color3.fromRGB(20,20,20)
Log.TextColor3 = Color3.fromRGB(0,255,0)
Log.Text = "[SYSTEM] Ready\n"
Log.Parent = Main

--========================
-- DRAG SYSTEM (MOBILE + PC)
--========================
local dragging, dragStart, startPos

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

--========================
-- BUTTON LOGIC
--========================
local minimized = false

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _,v in ipairs(Main:GetChildren()) do
		if v ~= Header then
			v.Visible = not minimized
		end
	end
	Main.Size = minimized and UDim2.new(0,260,0,30) or UDim2.new(0,260,0,200)
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

--========================
-- EXECUTE FIRE SERVER
--========================
Execute.MouseButton1Click:Connect(function()
	local path = Input.Text
	if path == "" then
		Log.Text ..= "[ERROR] Path kosong\n"
		return
	end

	local success, remote = pcall(function()
		return loadstring("return game."..path)()
	end)

	if not success or not remote then
		Log.Text ..= "[ERROR] Remote tidak ditemukan\n"
		return
	end

	if remote:IsA("RemoteEvent") then
		remote:FireServer()
		Log.Text ..= "[SEND] FireServer() -> "..path.."\n"
	elseif remote:IsA("RemoteFunction") then
		local res = remote:InvokeServer()
		Log.Text ..= "[RECV] "..tostring(res).."\n"
	else
		Log.Text ..= "[ERROR] Bukan RemoteEvent / RemoteFunction\n"
	end
end)

--========================
-- OPTIONAL SERVER RESPONSE LISTENER
--========================
for _,v in ipairs(RS:GetChildren()) do
	if v:IsA("RemoteEvent") then
		v.OnClientEvent:Connect(function(...)
			Log.Text ..= "[SERVER] "..v.Name.." | "..table.concat({...}, ", ").."\n"
		end)
	end
end
