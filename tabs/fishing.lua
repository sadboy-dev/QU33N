--// QU33N – FISHING TAB (FULL FINAL CLEAN)

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

Instance.new("UIPadding",Scroll).PaddingTop = UDim.new(0,8)

local layout = Instance.new("UIListLayout",Scroll)
layout.Padding = UDim.new(0,12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--================ NOTIFY =================--
local function notify(name,state)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = name,
			Text = state and "Activated" or "Deactivated",
			Duration = 2
		})
	end)
end

--================ TOGGLE ROW =================--
local function createToggleRow(parent,text,callback)
	local row = Instance.new("Frame",parent)
	row.Size = UDim2.new(1,-24,0,34)
	row.BackgroundTransparency = 1

	local label = Instance.new("TextLabel",row)
	label.Size = UDim2.new(1,-80,1,0)
	label.Position = UDim2.new(0,12,0,0)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Theme.Text
	label.Text = text

	local toggle = Instance.new("Frame",row)
	toggle.Size = UDim2.new(0,40,0,20)
	toggle.Position = UDim2.new(1,-52,0.5,-10)
	toggle.BackgroundColor3 = Color3.fromRGB(90,90,90)
	Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame",toggle)
	knob.Size = UDim2.new(0.5,0,1,0)
	knob.BackgroundColor3 = Theme.BG
	Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

	local enabled = false
	toggle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			enabled = not enabled
			if enabled then
				knob:TweenPosition(UDim2.new(0.5,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.15,true)
				toggle.BackgroundColor3 = Theme.Accent
			else
				knob:TweenPosition(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.15,true)
				toggle.BackgroundColor3 = Color3.fromRGB(90,90,90)
			end
			callback(enabled)
			notify(text,enabled)
		end
	end)
end

--================ CARD =================--
local Card = Instance.new("Frame",Scroll)
Card.Size = UDim2.new(1,-16,0,44)
Card.BackgroundColor3 = Theme.Panel
Instance.new("UICorner",Card).CornerRadius = UDim.new(0,16)

local Header = Instance.new("TextButton",Card)
Header.Size = UDim2.new(1,0,0,44)
Header.BackgroundTransparency = 1
Header.Text = "Fishing Support"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 16
Header.TextColor3 = Theme.Accent

local Body = Instance.new("Frame",Card)
Body.Position = UDim2.new(0,0,0,44)
Body.Size = UDim2.new(1,0,0,0)
Body.BackgroundTransparency = 1
Body.ClipsDescendants = true

local BodyLayout = Instance.new("UIListLayout",Body)
BodyLayout.Padding = UDim.new(0,8)

local open = false
Header.MouseButton1Click:Connect(function()
	open = not open
	Body:TweenSize(open and UDim2.new(1,0,0,120) or UDim2.new(1,0,0,0),
		Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
	Card:TweenSize(open and UDim2.new(1,-16,0,168) or UDim2.new(1,-16,0,44),
		Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
end)

--================ AUTO EQUIP ROD =================--
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local EquipTool = net:WaitForChild("RE/EquipToolFromHotbar")

local equipConn
createToggleRow(Body,"Auto Equip Rod",function(state)
	if equipConn then equipConn:Disconnect() equipConn=nil end
	if not state then return end

	equipConn = RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		if not char then return end
		if char:FindFirstChildOfClass("Tool") then return end
		pcall(function()
			EquipTool:FireServer(1)
		end)
	end)
end)

--================ NO ANIMATION =================--
createToggleRow(Body,"No Animation Fishing",function(state)
	local char = LocalPlayer.Character
	if not char or not state then return end
	for _,v in pairs(char:GetDescendants()) do
		if v:IsA("Animator") or v:IsA("Animation") then
			pcall(function() v:Destroy() end)
		end
	end
end)

--================ WALK WATER (RAYCAST) =================--
local walkConn
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

createToggleRow(Body,"Walk Water",function(state)
	if walkConn then walkConn:Disconnect() walkConn=nil end
	if not state then return end

	walkConn = RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end

		RayParams.FilterDescendantsInstances = {char}
		local result = workspace:Raycast(hrp.Position,Vector3.new(0,-15,0),RayParams)
		if result and result.Instance then
			if result.Instance.Name:lower():find("water")
			or result.Instance.Material == Enum.Material.Water then
				local y = result.Position.Y + 2.9
				if hrp.Position.Y < y then
					hrp.Velocity = Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z)
					hrp.CFrame = CFrame.new(hrp.Position.X,y,hrp.Position.Z)
				end
			end
		end
	end)
end)
