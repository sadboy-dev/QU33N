--// QU33N – FISHING TAB (FINAL FIX FULL)

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
layout.Padding = UDim.new(0,12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local pad = Instance.new("UIPadding", Scroll)
pad.PaddingTop = UDim.new(0,10)
pad.PaddingBottom = UDim.new(0,10)

--================ UTIL =================--
local function notify(title, state)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = title,
			Text = state and "Actived" or "Deactived",
			Duration = 2
		})
	end)
end

--================ TOGGLE ROW =================--
local function createToggleRow(parent, text, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1,-24,0,36)
	row.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.7,0,1,0)
	label.Position = UDim2.new(0,8,0,0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text

	local toggle = Instance.new("Frame", row)
	toggle.Size = UDim2.new(0,36,0,18)
	toggle.Position = UDim2.new(1,-44,0.5,-9)
	toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
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
				toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
			end
			callback(enabled)
			notify(text, enabled)
		end
	end)
end

--================ CARD =================--
local Card = Instance.new("Frame", Scroll)
Card.Size = UDim2.new(1,-20,0,44)
Card.BackgroundColor3 = Theme.Panel
Instance.new("UICorner",Card).CornerRadius = UDim.new(0,16)

local Header = Instance.new("TextButton", Card)
Header.Size = UDim2.new(1,0,0,44)
Header.BackgroundTransparency = 1
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Text = "  Fishing Support"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 16
Header.TextColor3 = Theme.Accent

-- Arrow Icon
local Arrow = Instance.new("TextLabel", Header)
Arrow.Size = UDim2.new(0,24,1,0)
Arrow.Position = UDim2.new(1,-30,0,0)
Arrow.BackgroundTransparency = 1
Arrow.Text = "▼"
Arrow.Font = Enum.Font.GothamBold
Arrow.TextSize = 18
Arrow.TextColor3 = Theme.Text

local Body = Instance.new("Frame", Card)
Body.Position = UDim2.new(0,0,0,44)
Body.Size = UDim2.new(1,0,0,0)
Body.BackgroundTransparency = 1
Body.ClipsDescendants = true

local BodyLayout = Instance.new("UIListLayout", Body)
BodyLayout.Padding = UDim.new(0,8)

local BodyPad = Instance.new("UIPadding", Body)
BodyPad.PaddingTop = UDim.new(0,8)
BodyPad.PaddingBottom = UDim.new(0,8)

local open = false
Header.MouseButton1Click:Connect(function()
	open = not open
	Arrow.Text = open and "▲" or "▼"

	Body:TweenSize(
		open and UDim2.new(1,0,0,88) or UDim2.new(1,0,0,0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.25,true
	)

	Card:TweenSize(
		open and UDim2.new(1,-20,0,140) or UDim2.new(1,-20,0,44),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.25,true
	)
end)

--================ AUTO EQUIP ROD =================--
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local EquipToolFromHotbar = net:WaitForChild("RE/EquipToolFromHotbar")

local autoEquip = false
local equipConn

createToggleRow(Body,"Auto Equip Rod",function(state)
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

--================ NO ANIMATION FISHING (FIXED) =================--
local noAnim = false
local animConn

local FishingAnimations = {
	["rbxassetid://96586569072385"] = true,
	["rbxassetid://139622307103608"] = true,
	["rbxassetid://92624107165273"] = true,
	["rbxassetid://134965425664034"] = true,
	["rbxassetid://136614469321844"] = true,
	["rbxassetid://114959536562596"] = true,
	["rbxassetid://117319000848286"] = true,
}

local function hookHumanoid(hum)
	if animConn then animConn:Disconnect() end
	animConn = hum.AnimationPlayed:Connect(function(track)
		if not noAnim then return end
		if track.Animation and FishingAnimations[track.Animation.AnimationId] then
			task.defer(function()
				pcall(function()
					track:Stop(0)
				end)
			end)
		end
	end)
end

createToggleRow(Body,"No Animation Fishing",function(state)
	noAnim = state
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hookHumanoid(hum) end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	if noAnim then
		local hum = char:WaitForChild("Humanoid")
		hookHumanoid(hum)
	end
end)
