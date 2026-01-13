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
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", Scroll)
layout.Padding = UDim.new(0,14)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local scrollPad = Instance.new("UIPadding", Scroll)
scrollPad.PaddingTop = UDim.new(0,10)
scrollPad.PaddingBottom = UDim.new(0,10)

--================ UTIL =================--
local function notify(title, enabled)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = title,
			Text = enabled and "Actived" or "Deactived",
			Duration = 2
		})
	end)
end

--================ TOGGLE ROW =================--
local function createToggleRow(parent, text, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1,-20,0,36)
	row.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1,-70,1,0)
	label.Position = UDim2.new(0,8,0,0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text

	local toggle = Instance.new("Frame", row)
	toggle.Size = UDim2.new(0,38,0,20)
	toggle.Position = UDim2.new(1,-46,0.5,-10)
	toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
	toggle.BorderSizePixel = 0
	Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", toggle)
	knob.Size = UDim2.new(0,18,0,18)
	knob.Position = UDim2.new(0,1,0.5,-9)
	knob.BackgroundColor3 = Theme.BG
	knob.BorderSizePixel = 0
	Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

	local enabled = false

	local function set(state)
		enabled = state
		if enabled then
			knob:TweenPosition(UDim2.new(1,-19,0.5,-9),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
			toggle.BackgroundColor3 = Theme.Accent
		else
			knob:TweenPosition(UDim2.new(0,1,0.5,-9),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
			toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
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
Card.Size = UDim2.new(1,-16,0,46)
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
header.TextYAlignment = Enum.TextYAlignment.Center
header.AutoButtonColor = false

local body = Instance.new("Frame", Card)
body.Position = UDim2.new(0,0,0,46)
body.Size = UDim2.new(1,0,0,0)
body.BackgroundTransparency = 1
body.ClipsDescendants = true

local bodyLayout = Instance.new("UIListLayout", body)
bodyLayout.Padding = UDim.new(0,10)

local bodyPad = Instance.new("UIPadding", body)
bodyPad.PaddingTop = UDim.new(0,10)
bodyPad.PaddingLeft = UDim.new(0,8)
bodyPad.PaddingRight = UDim.new(0,8)

local open = false
header.MouseButton1Click:Connect(function()
	open = not open
	body:TweenSize(
		open and UDim2.new(1,0,0,150) or UDim2.new(1,0,0,0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.25,true
	)
	Card:TweenSize(
		open and UDim2.new(1,-16,0,210) or UDim2.new(1,-16,0,46),
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

		-- cek sudah pegang tool
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

	for _,track in ipairs(char:GetDescendants()) do
		if track:IsA("AnimationTrack") then
			pcall(function()
				if state then track:Stop() end
			end)
		end
	end
end)

--================ WALK WATER (FIX NO FLOAT) =================--
local waterConn
local platform

createToggleRow(body,"Walk Water",function(state)
	if waterConn then waterConn:Disconnect() waterConn=nil end
	if platform then platform:Destroy() platform=nil end
	if not state then return end

	platform = Instance.new("Part", workspace)
	platform.Size = Vector3.new(7,0.5,7)
	platform.Anchored = true
	platform.CanCollide = true
	platform.Transparency = 1

	waterConn = RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		-- FIX: posisi stabil (tidak naik)
		platform.Position = Vector3.new(
			hrp.Position.X,
			hrp.Position.Y - 3.5,
			hrp.Position.Z
		)
	end)
end)
