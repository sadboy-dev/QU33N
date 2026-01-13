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
Scroll.BorderSizePixel = 0

local List = Instance.new("UIListLayout", Scroll)
List.Padding = UDim.new(0,14)
List.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", Scroll).PaddingTop = UDim.new(0,12)

--================ NOTIFY =================--
local function notify(title, state)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = title,
			Text = state and "Activated" or "Deactivated",
			Duration = 2
		})
	end)
end

--================ TOGGLE ROW =================--
local function createToggle(parent, text, callback)
	local Row = Instance.new("Frame", parent)
	Row.Size = UDim2.new(1,-20,0,42)
	Row.BackgroundTransparency = 1

	local Label = Instance.new("TextLabel", Row)
	Label.Size = UDim2.new(1,-80,1,0)
	Label.Position = UDim2.new(0,0,0,0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextColor3 = Theme.Text

	local Toggle = Instance.new("Frame", Row)
	Toggle.Size = UDim2.new(0,42,0,22)
	Toggle.Position = UDim2.new(1,-42,0.5,-11)
	Toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Instance.new("UICorner",Toggle).CornerRadius = UDim.new(1,0)

	local Knob = Instance.new("Frame", Toggle)
	Knob.Size = UDim2.new(0,18,0,18)
	Knob.Position = UDim2.new(0,2,0.5,-9)
	Knob.BackgroundColor3 = Theme.BG
	Instance.new("UICorner",Knob).CornerRadius = UDim.new(1,0)

	local Enabled = false

	local function setState(v)
		Enabled = v
		if v then
			Knob:TweenPosition(UDim2.new(1,-20,0.5,-9),"Out","Quad",0.2,true)
			Toggle.BackgroundColor3 = Theme.Accent
		else
			Knob:TweenPosition(UDim2.new(0,2,0.5,-9),"Out","Quad",0.2,true)
			Toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
		end
		callback(v)
		notify(text, v)
	end

	Toggle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			setState(not Enabled)
		end
	end)
end

--================ CARD =================--
local Card = Instance.new("Frame", Scroll)
Card.Size = UDim2.new(1,-20,0,52)
Card.BackgroundColor3 = Theme.Panel
Card.BorderSizePixel = 0
Instance.new("UICorner",Card).CornerRadius = UDim.new(0,16)

local Header = Instance.new("TextButton", Card)
Header.Size = UDim2.new(1,-24,0,52)
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
Body.AutomaticSize = Enum.AutomaticSize.Y
Body.BackgroundTransparency = 1
Body.Visible = false
Body.ClipsDescendants = true

local BodyList = Instance.new("UIListLayout", Body)
BodyList.Padding = UDim.new(0,10)

local Open = false
Header.MouseButton1Click:Connect(function()
	Open = not Open
	Body.Visible = Open
	task.wait()
	Card:TweenSize(
		Open and UDim2.new(1,-20,0,52 + Body.AbsoluteSize.Y + 12)
		or UDim2.new(1,-20,0,52),
		"Out","Quad",0.25,true
	)
end)

--================ AUTO EQUIP ROD =================--
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local EquipToolFromHotbar = net:WaitForChild("RE/EquipToolFromHotbar")
local equipConn

createToggle(Body,"Auto Equip Rod",function(state)
	if equipConn then equipConn:Disconnect() equipConn=nil end
	if not state then return end

	equipConn = RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		if char and not char:FindFirstChildOfClass("Tool") then
			pcall(function()
				EquipToolFromHotbar:FireServer(1)
			end)
		end
	end)
end)

--================ NO ANIMATION =================--
local stoppedTracks = {}

createToggle(Body,"No Animation Fishing",function(state)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	if state then
		for _,track in ipairs(hum:GetPlayingAnimationTracks()) do
			stoppedTracks[#stoppedTracks+1] = track.Animation
			track:Stop()
		end
	else
		for _,anim in ipairs(stoppedTracks) do
			pcall(function()
				hum:LoadAnimation(anim):Play()
			end)
		end
		table.clear(stoppedTracks)
	end
end)

--================ WALK WATER (SAFE MODE) =================--
createToggle(Body,"Walk Water",function(state)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, not state)
	if state then
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end
end)
