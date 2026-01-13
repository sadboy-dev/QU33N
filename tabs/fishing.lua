--// QU33N – FISHING TAB (FULL FINAL FLOAT FIX)

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

local list = Instance.new("UIListLayout", Scroll)
list.Padding = UDim.new(0,14)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local pad = Instance.new("UIPadding", Scroll)
pad.PaddingTop = UDim.new(0,12)
pad.PaddingBottom = UDim.new(0,12)

--================ NOTIFY =================--
local function notify(name, state)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = name,
			Text = state and "Activated" or "Deactivated",
			Duration = 2
		})
	end)
end

--================ TOGGLE =================--
local function createToggleRow(parent, text, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1,-32,0,42)
	row.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1,-90,1,0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text

	local toggle = Instance.new("Frame", row)
	toggle.Size = UDim2.new(0,46,0,22)
	toggle.Position = UDim2.new(1,-46,0.5,-11)
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
end

--================ CARD =================--
local Card = Instance.new("Frame", Scroll)
Card.Size = UDim2.new(1,-28,0,50)
Card.BackgroundColor3 = Theme.Panel
Instance.new("UICorner",Card).CornerRadius = UDim.new(0,16)

local Header = Instance.new("TextButton", Card)
Header.Size = UDim2.new(1,-24,0,50)
Header.Position = UDim2.new(0,12,0,0)
Header.BackgroundTransparency = 1
Header.Text = "Fishing Support"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 16
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.TextColor3 = Theme.Accent

local Body = Instance.new("Frame", Card)
Body.Position = UDim2.new(0,12,0,56)
Body.Size = UDim2.new(1,-24,0,0)
Body.BackgroundTransparency = 1
Body.ClipsDescendants = true

local bodyList = Instance.new("UIListLayout", Body)
bodyList.Padding = UDim.new(0,10)

local opened = false
Header.MouseButton1Click:Connect(function()
	opened = not opened
	Body:TweenSize(
		opened and UDim2.new(1,-24,0,150) or UDim2.new(1,-24,0,0),
		"Out","Quad",0.25,true
	)
	Card:TweenSize(
		opened and UDim2.new(1,-28,0,220) or UDim2.new(1,-28,0,50),
		"Out","Quad",0.25,true
	)
end)

--================ AUTO EQUIP ROD =================--
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local EquipToolFromHotbar = net:WaitForChild("RE/EquipToolFromHotbar")

local equipConn
createToggleRow(Body,"Auto Equip Rod",function(state)
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
createToggleRow(Body,"No Animation Fishing",function(state)
	local char = LocalPlayer.Character
	if not char then return end
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("Animator") or v:IsA("Animation") then
			if state then pcall(function() v:Destroy() end) end
		end
	end
end)

--================ WALK WATER (FLOAT SURFACE) =================--
local WATER_Y = 0 -- sesuaikan jika map beda
local floatConn
local floatForce

createToggleRow(Body,"Walk Water",function(state)
	if floatConn then floatConn:Disconnect() floatConn=nil end
	if floatForce then floatForce:Destroy() floatForce=nil end
	if not state then return end

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)

	floatForce = Instance.new("BodyVelocity")
	floatForce.MaxForce = Vector3.new(0,1e5,0)
	floatForce.Velocity = Vector3.zero
	floatForce.Parent = hrp

	floatConn = RunService.Heartbeat:Connect(function()
		if not hrp or not hum then return end

		local targetY = WATER_Y + 2.8
		local diff = targetY - hrp.Position.Y

		if hrp.Position.Y < WATER_Y + 1 then
			floatForce.Velocity = Vector3.new(
				0,
				math.clamp(diff * 8, -25, 25),
				0
			)
		else
			floatForce.Velocity = Vector3.zero
		end
	end)
end)
