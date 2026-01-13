--// QU33N – FISHING TAB (FULL FIX FINAL)

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
layout.Padding = UDim.new(0,12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local pad = Instance.new("UIPadding", Scroll)
pad.PaddingTop = UDim.new(0,8)
pad.PaddingLeft = UDim.new(0,6)
pad.PaddingRight = UDim.new(0,6)

--================ NOTIFY =================--
local function notify(title, enabled)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = title,
			Text = enabled and "Activated" or "Deactivated",
			Duration = 2
		})
	end)
end

--================ TOGGLE ROW =================--
local function createToggleRow(parent, text, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1,-24,0,40)
	row.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1,-90,1,0)
	label.Position = UDim2.new(0,12,0,0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Theme.Text
	label.Text = text

	local toggle = Instance.new("Frame", row)
	toggle.Size = UDim2.new(0,44,0,22)
	toggle.Position = UDim2.new(1,-56,0.5,-11)
	toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
	toggle.BorderSizePixel = 0
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", toggle)
	knob.Size = UDim2.new(0,18,0,18)
	knob.Position = UDim2.new(0,2,0.5,-9)
	knob.BackgroundColor3 = Theme.BG
	knob.BorderSizePixel = 0
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	local enabled = false

	local function set(state)
		enabled = state
		if enabled then
			knob:TweenPosition(UDim2.new(1,-20,0.5,-9),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
			toggle.BackgroundColor3 = Theme.Accent
		else
			knob:TweenPosition(UDim2.new(0,2,0.5,-9),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
			toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
		end
		callback(enabled)
		notify(text, enabled)
	end

	toggle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			set(not enabled)
		end
	end)

	return row
end

--================ CARD =================--
local Card = Instance.new("Frame", Scroll)
Card.Size = UDim2.new(1,-12,0,46)
Card.BackgroundColor3 = Theme.Panel
Card.BorderSizePixel = 0
Instance.new("UICorner",Card).CornerRadius = UDim.new(0,16)

local header = Instance.new("TextButton", Card)
header.Size = UDim2.new(1,0,0,46)
header.BackgroundTransparency = 1
header.Text = "Fishing Support"
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextColor3 = Theme.Accent

local body = Instance.new("Frame", Card)
body.Position = UDim2.new(0,0,0,46)
body.Size = UDim2.new(1,0,0,0)
body.BackgroundTransparency = 1
body.ClipsDescendants = true

local bodyPad = Instance.new("UIPadding", body)
bodyPad.PaddingTop = UDim.new(0,8)
bodyPad.PaddingBottom = UDim.new(0,10)

local bodyLayout = Instance.new("UIListLayout", body)
bodyLayout.Padding = UDim.new(0,8)

local open = false
header.MouseButton1Click:Connect(function()
	open = not open
	body:TweenSize(
		open and UDim2.new(1,0,0,160) or UDim2.new(1,0,0,0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.25,true
	)
	Card:TweenSize(
		open and UDim2.new(1,-12,0,206) or UDim2.new(1,-12,0,46),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.25,true
	)
end)

--================ AUTO EQUIP ROD =================--
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local EquipToolFromHotbar = net:WaitForChild("RE/EquipToolFromHotbar")

local equipConn
createToggleRow(body,"Auto Equip Rod",function(state)
	if equipConn then equipConn:Disconnect() equipConn=nil end
	if not state then return end

	equipConn = RunService.Heartbeat:Connect(function()
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

	for _,v in pairs(char:GetDescendants()) do
		if state and v:IsA("Animator") then
			pcall(function() v:Destroy() end)
		end
	end
end)

--================ WALK WATER (REAL FIX) =================--
local walkConn
createToggleRow(body,"Walk Water",function(state)
	if walkConn then walkConn:Disconnect() walkConn=nil end

	local function apply(char)
		local hrp = char:WaitForChild("HumanoidRootPart",5)
		local hum = char:WaitForChild("Humanoid",5)
		if not hrp or not hum then return end

		if state then
			hrp.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
			hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		else
			hrp.CustomPhysicalProperties = PhysicalProperties.new(1,0.3,0.5)
			hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		end
	end

	if LocalPlayer.Character then
		apply(LocalPlayer.Character)
	end

	walkConn = LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(0.4)
		if state then
			apply(char)
		end
	end)
end)
