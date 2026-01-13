--// QU33N – FISHING TAB (FULL FINAL FIX)

repeat task.wait() until _G.QU33N and _G.QU33N.Pages and _G.QU33N.Pages.Fishing

local UI = _G.QU33N
local page = UI.Pages.Fishing
local Theme = UI.Theme

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
page:ClearAllChildren()

--================ SCROLL =================--
local Scroll = Instance.new("ScrollingFrame", page)
Scroll.Size = UDim2.new(1,0,1,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", Scroll)
layout.Padding = UDim.new(0,14)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local pad = Instance.new("UIPadding", Scroll)
pad.PaddingTop = UDim.new(0,10)
pad.PaddingBottom = UDim.new(0,10)

--================ NOTIFY =================--
local function notify(feature, state)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = feature,
			Text = state and "Activated" or "Deactivated",
			Duration = 2
		})
	end)
end

--================ TOGGLE ROW =================--
local function createToggleRow(parent, text, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1,-32,0,40)
	row.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1,-90,1,0)
	label.Position = UDim2.new(0,0,0,0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text

	local toggle = Instance.new("Frame", row)
	toggle.Size = UDim2.new(0,44,0,22)
	toggle.Position = UDim2.new(1,-44,0.5,-11)
	toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", toggle)
	knob.Size = UDim2.new(0,18,0,18)
	knob.Position = UDim2.new(0,2,0.5,-9)
	knob.BackgroundColor3 = Theme.BG
	Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

	local enabled = false

	local function set(state)
		enabled = state
		if enabled then
			knob:TweenPosition(UDim2.new(1,-20,0.5,-9),"Out","Quad",0.2,true)
			toggle.BackgroundColor3 = Theme.Accent
		else
			knob:TweenPosition(UDim2.new(0,2,0.5,-9),"Out","Quad",0.2,true)
			toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
		end
		callback(enabled)
		notify(text, enabled)
	end

	toggle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			set(not enabled)
		end
	end)

	return set
end

--================ CARD =================--
local Card = Instance.new("Frame", Scroll)
Card.Size = UDim2.new(1,-24,0,48)
Card.BackgroundColor3 = Theme.Panel
Instance.new("UICorner",Card).CornerRadius = UDim.new(0,16)

local header = Instance.new("TextButton", Card)
header.Size = UDim2.new(1,-24,0,48)
header.Position = UDim2.new(0,12,0,0)
header.BackgroundTransparency = 1
header.Text = "Fishing Support"
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextXAlignment = Enum.TextXAlignment.Left
header.TextColor3 = Theme.Accent

local body = Instance.new("Frame", Card)
body.Position = UDim2.new(0,12,0,52)
body.Size = UDim2.new(1,-24,0,0)
body.BackgroundTransparency = 1
body.ClipsDescendants = true

local bodyLayout = Instance.new("UIListLayout", body)
bodyLayout.Padding = UDim.new(0,10)

local open = false
header.MouseButton1Click:Connect(function()
	open = not open
	body:TweenSize(
		open and UDim2.new(1,-24,0,140) or UDim2.new(1,-24,0,0),
		"Out","Quad",0.25,true
	)
	Card:TweenSize(
		open and UDim2.new(1,-24,0,210) or UDim2.new(1,-24,0,48),
		"Out","Quad",0.25,true
	)
end)

--================ AUTO EQUIP ROD =================--
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local EquipToolFromHotbar = net:WaitForChild("RE/EquipToolFromHotbar")

local autoEquipConn
createToggleRow(body,"Auto Equip Rod",function(state)
	if autoEquipConn then autoEquipConn:Disconnect() autoEquipConn=nil end
	if not state then return end

	autoEquipConn = RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		if not char then return end
		if char:FindFirstChildOfClass("Tool") then return end
		pcall(function()
			EquipToolFromHotbar:FireServer(1)
		end)
	end)
end)

--================ NO ANIMATION =================--
createToggleRow(body,"No Animation Fishing",function(state)
	local char = LocalPlayer.Character
	if not char then return end
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("Animator") or v:IsA("Animation") then
			pcall(function()
				if state then v:Destroy() end
			end)
		end
	end
end)

--================ WALK WATER (REAL FIX) =================--
local WATER_Y = 0 -- sesuaikan jika map beda
local walkConn

createToggleRow(body,"Walk Water",function(state)
	if walkConn then walkConn:Disconnect() walkConn=nil end
	if not state then return end

	walkConn = RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChild("Humanoid")
		if not hrp or not hum then return end

		if hrp.Position.Y < WATER_Y then
			hrp.Velocity = Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z)
			hrp.CFrame = CFrame.new(
				hrp.Position.X,
				WATER_Y + 2.8,
				hrp.Position.Z
			)
		end
	end)
end)
