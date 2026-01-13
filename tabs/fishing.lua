--// QU33N – FISHING TAB (FINAL FULL)

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

local layout = Instance.new("UIListLayout", Scroll)
layout.Padding = UDim.new(0,12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", Scroll).PaddingTop = UDim.new(0,8)

--============== UTIL =================--
local function notify(title, state)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = title,
			Text = state and "Actived" or "Deactived",
			Duration = 2
		})
	end)
end

--============== TOGGLE ROW =================--
local function createToggleRow(parent, text, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1,-20,0,36)
	row.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.7,0,1,0)
	label.Position = UDim2.new(0,12,0,0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text

	local toggle = Instance.new("Frame", row)
	toggle.Size = UDim2.new(0,38,0,20)
	toggle.Position = UDim2.new(1,-48,0.5,-10)
	toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
	Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", toggle)
	knob.Size = UDim2.new(0.5,0,1,0)
	knob.BackgroundColor3 = Theme.BG
	Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

	local enabled = false

	toggle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			enabled = not enabled
			if enabled then
				knob:TweenPosition(UDim2.new(0.5,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
				toggle.BackgroundColor3 = Theme.Accent
			else
				knob:TweenPosition(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
				toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
			end
			callback(enabled)
			notify(text, enabled)
		end
	end)

	return row
end

--============== CARD =================--
local Card = Instance.new("Frame", Scroll)
Card.Size = UDim2.new(1,-16,0,44)
Card.BackgroundColor3 = Theme.Panel
Instance.new("UICorner",Card).CornerRadius = UDim.new(0,16)

local header = Instance.new("TextButton", Card)
header.Size = UDim2.new(1,0,0,44)
header.BackgroundTransparency = 1
header.Text = "Fishing Support"
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextColor3 = Theme.Accent

local body = Instance.new("Frame", Card)
body.Position = UDim2.new(0,0,0,44)
body.Size = UDim2.new(1,0,0,0)
body.BackgroundTransparency = 1
body.ClipsDescendants = true

local bodyLayout = Instance.new("UIListLayout", body)
bodyLayout.Padding = UDim.new(0,8)

local open = false
header.MouseButton1Click:Connect(function()
	open = not open
	body:TweenSize(
		open and UDim2.new(1,0,0,140) or UDim2.new(1,0,0,0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.25,true
	)
	Card:TweenSize(
		open and UDim2.new(1,-16,0,190) or UDim2.new(1,-16,0,44),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.25,true
	)
end)

--============== AUTO EQUIP ROD =================--
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local EquipToolFromHotbar = net:WaitForChild("RE/EquipToolFromHotbar")

local autoEquip = false
local equipConn

createToggleRow(body,"Auto Equip Rod",function(state)
	autoEquip = state
	if equipConn then equipConn:Disconnect() equipConn=nil end

	if state then
		equipConn = RunService.Heartbeat:Connect(function()
			local char = LocalPlayer.Character
			if not char then return end
			if char:FindFirstChildOfClass("Tool") then return end
			pcall(function()
				EquipToolFromHotbar:FireServer(1)
			end)
		end)
	end
end)

--============== NO ANIMATION =================--
local noAnim = false
createToggleRow(body,"No Animation Fishing",function(state)
	noAnim = state
	local char = LocalPlayer.Character
	if char then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("Animation") or v:IsA("Animator") then
				pcall(function()
					if state then
						v:Destroy()
					end
				end)
			end
		end
	end
end)

--============== WALK WATER =================--
local walkWater = false
local platform
local waterConn

createToggleRow(body,"Walk Water",function(state)
	walkWater = state

	if not state then
		if waterConn then waterConn:Disconnect() waterConn=nil end
		if platform then platform:Destroy() platform=nil end
		return
	end

	platform = Instance.new("Part",workspace)
	platform.Size = Vector3.new(6,1,6)
	platform.Anchored = true
	platform.Transparency = 1
	platform.CanCollide = true

	waterConn = RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			platform.Position = hrp.Position - Vector3.new(0,3.2,0)
		end
	end)
end)
