--// QU33N – FISHING TAB (FINAL FIX)

repeat task.wait() until _G.QU33N and _G.QU33N.Pages and _G.QU33N.Pages.Fishing

local UI = _G.QU33N
local page = UI.Pages.Fishing
local Theme = UI.Theme

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

page:ClearAllChildren()

-- ================= NOTIFY =================
local function notify(txt)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = "Fishing Support",
			Text = txt,
			Duration = 3
		})
	end)
end

-- ================= SCROLL =================
local Scroll = Instance.new("ScrollingFrame",page)
Scroll.Size = UDim2.new(1,0,1,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y

local Padding = Instance.new("UIPadding",Scroll)
Padding.PaddingTop = UDim.new(0,8)
Padding.PaddingLeft = UDim.new(0,6)
Padding.PaddingRight = UDim.new(0,6)

local Layout = Instance.new("UIListLayout",Scroll)
Layout.Padding = UDim.new(0,12)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ================= TOGGLE UI =================
local function createToggle(parent, default, callback)
	local btn = Instance.new("TextButton",parent)
	btn.Size = UDim2.new(0,42,0,22)
	btn.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(60,60,60)
	btn.Text = ""
	btn.AutoButtonColor = false

	Instance.new("UICorner",btn).CornerRadius = UDim.new(1,0)

	local dot = Instance.new("Frame",btn)
	dot.Size = UDim2.new(0,18,0,18)
	dot.Position = default and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
	dot.BackgroundColor3 = Color3.fromRGB(240,240,240)
	Instance.new("UICorner",dot).CornerRadius = UDim.new(1,0)

	local state = default

	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60,60,60)
		dot:TweenPosition(
			state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9),
			"Out","Quad",0.15,true
		)
		callback(state)
	end)

	return function(v)
		state = v
	end
end

-- ================= CARD =================
local function createCard(title)
	local Card = Instance.new("Frame",Scroll)
	Card.Size = UDim2.new(1,-4,0,54)
	Card.BackgroundColor3 = Theme.Panel
	Card.ClipsDescendants = true
	Instance.new("UICorner",Card).CornerRadius = UDim.new(0,14)

	local Header = Instance.new("TextButton",Card)
	Header.Size = UDim2.new(1,0,0,54)
	Header.BackgroundTransparency = 1
	Header.Text = "  "..title
	Header.Font = Enum.Font.GothamBold
	Header.TextSize = 14
	Header.TextColor3 = Theme.Text
	Header.TextXAlignment = Enum.TextXAlignment.Left

	local Body = Instance.new("Frame",Card)
	Body.Position = UDim2.new(0,0,0,54)
	Body.Size = UDim2.new(1,0,0,0)
	Body.BackgroundTransparency = 1
	Body.Visible = false

	local open = false
	Header.MouseButton1Click:Connect(function()
		open = not open
		Body.Visible = true
		Card:TweenSize(
			open and UDim2.new(1,-4,0,54 + Body.UIListLayout.AbsoluteContentSize.Y + 10)
			or UDim2.new(1,-4,0,54),
			"Out","Quad",0.25,true
		)
		if not open then
			task.delay(0.25,function()
				Body.Visible = false
			end)
		end
	end)

	local layout = Instance.new("UIListLayout",Body)
	layout.Padding = UDim.new(0,10)

	return Body
end

-- ================= ROW =================
local function createRow(parent,text,callback)
	local Row = Instance.new("Frame",parent)
	Row.Size = UDim2.new(1,-20,0,34)
	Row.BackgroundTransparency = 1

	local Label = Instance.new("TextLabel",Row)
	Label.Size = UDim2.new(1,-60,1,0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 13
	Label.TextColor3 = Theme.Text
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local toggle = createToggle(Row,false,callback)
	toggle.Parent = Row
	toggle.Position = UDim2.new(1,-48,0.5,-11)
end

-- =================================================
-- ================= FISHING SUPPORT =================
-- =================================================

local body = createCard("Fishing Support")

-- ========= AUTO EQUIP ROD (SAFE, NON LOOP) =========
local equipEnabled = false
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local EquipTool = net:WaitForChild("RE/EquipToolFromHotbar")

RunService.Heartbeat:Connect(function()
	if not equipEnabled then return end
	local char = LocalPlayer.Character
	if not char then return end

	local tool = char:FindFirstChildOfClass("Tool")
	if not tool or not tool.Name:lower():find("rod") then
		pcall(function()
			EquipTool:FireServer(1)
		end)
	end
end)

createRow(body,"Auto Equip Rod",function(v)
	equipEnabled = v
	notify("Auto Equip Rod "..(v and "Activated" or "Disabled"))
end)

-- ========= NO ANIMATION =========
local noAnim = false

createRow(body,"No Animation Fishing",function(v)
	noAnim = v
	notify("No Animation Fishing "..(v and "Activated" or "Disabled"))

	if LocalPlayer.Character then
		for _,track in pairs(
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks()
		) do
			if v then track:Stop() end
		end
	end
end)

-- ========= WALK WATER (FIXED) =========
local walkWater = false
local platform
local waterY

RunService.Heartbeat:Connect(function()
	if not walkWater or not platform then return end
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		platform.Position = Vector3.new(hrp.Position.X,waterY,hrp.Position.Z)
	end
end)

createRow(body,"Walk Water",function(v)
	walkWater = v
	notify("Walk Water "..(v and "Activated" or "Disabled"))

	if not v then
		if platform then platform:Destroy() platform=nil end
		return
	end

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	waterY = hrp.Position.Y - 3.2

	platform = Instance.new("Part",workspace)
	platform.Size = Vector3.new(8,1,8)
	platform.Anchored = true
	platform.Transparency = 1
	platform.CanCollide = true
end)
