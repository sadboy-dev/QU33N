-- tabs/fishing.lua — Fishing Support (Auto Equip Rod + Dynamic Notify)
repeat task.wait() until _G.QU33N and _G.QU33N.Pages and _G.QU33N.Pages.Fishing

local UI = _G.QU33N
local page = UI.Pages.Fishing
local Theme = UI.Theme
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Bersihkan page
page:ClearAllChildren()

-- Scroll Frame
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = page
Scroll.Size = UDim2.new(1,0,1,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4

local Padding = Instance.new("UIPadding", Scroll)
Padding.PaddingTop = UDim.new(0,8)
Padding.PaddingLeft = UDim.new(0,8)
Padding.PaddingRight = UDim.new(0,8)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,14)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- CARD HELPER (Buka/Tutup)
local function createToggleCard(parent, title)
	local Card = Instance.new("Frame", parent)
	Card.Size = UDim2.new(1,-6,0,50)
	Card.BackgroundColor3 = Theme.Panel
	Card.ClipsDescendants = true
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)

	local TitleBtn = Instance.new("TextButton", Card)
	TitleBtn.Size = UDim2.new(1,0,0,50)
	TitleBtn.BackgroundTransparency = 1
	TitleBtn.Text = title
	TitleBtn.Font = Enum.Font.GothamBold
	TitleBtn.TextSize = 16
	TitleBtn.TextColor3 = Theme.Accent
	TitleBtn.TextXAlignment = Enum.TextXAlignment.Left
	TitleBtn.Position = UDim2.new(0,16,0,0)

	local Body = Instance.new("Frame", Card)
	Body.Size = UDim2.new(1,0,0,0)
	Body.Position = UDim2.new(0,0,0,50)
	Body.BackgroundTransparency = 1
	Body.ClipsDescendants = true

	local LayoutIn = Instance.new("UIListLayout", Body)
	LayoutIn.SortOrder = Enum.SortOrder.LayoutOrder
	LayoutIn.Padding = UDim.new(0,6)

	local expanded = false
	TitleBtn.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			local h = 0
			for _,v in ipairs(Body:GetChildren()) do
				if v:IsA("GuiObject") then
					h += v.AbsoluteSize.Y
				end
			end
			Body:TweenSize(UDim2.new(1,0,0,h), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			Card:TweenSize(UDim2.new(1,-6,0,50+h+12), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		else
			Body:TweenSize(UDim2.new(1,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			Card:TweenSize(UDim2.new(1,-6,0,50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		end
	end)

	return Card, Body
end

-- ===== FISHING SUPPORT CARD =====
local cardFishing, bodyFishing = createToggleCard(Scroll, "Fishing Support")

-- Row: Auto Equip Rod
local row = Instance.new("Frame")
row.Size = UDim2.new(1,0,0,36)
row.BackgroundTransparency = 1
row.Parent = bodyFishing

local label = Instance.new("TextLabel")
label.Parent = row
label.Size = UDim2.new(0.65,0,1,0)
label.Position = UDim2.new(0,16,0,0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextColor3 = Theme.Text
label.Text = "Auto Equip Rod"
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Center

-- Toggle kecil kanan
local toggleBG = Instance.new("Frame")
toggleBG.Parent = row
toggleBG.Size = UDim2.new(0,36,0,20)
toggleBG.Position = UDim2.new(0.8,0,0.5,-10)
toggleBG.BackgroundColor3 = Color3.fromRGB(90,90,90)
Instance.new("UICorner", toggleBG).CornerRadius = UDim.new(1,0)

local knob = Instance.new("Frame")
knob.Parent = toggleBG
knob.Size = UDim2.new(0.5,0,1,0)
knob.Position = UDim2.new(0,0,0,0)
knob.BackgroundColor3 = Theme.BG
Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

-- Toggle logic dengan notify dinamis
local autoEquipEnabled = false
toggleBG.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		autoEquipEnabled = not autoEquipEnabled
		if autoEquipEnabled then
			knob:TweenPosition(UDim2.new(0.5,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.2,true)
			toggleBG.BackgroundColor3 = Theme.Accent
			-- Notify ON dengan nama fitur
			pcall(function()
				StarterGui:SetCore("SendNotification", {
					Title = label.Text,
					Text = "Actived",
					Duration = 2
				})
			end)
		else
			knob:TweenPosition(UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.2,true)
			toggleBG.BackgroundColor3 = Color3.fromRGB(90,90,90)
			-- Notify OFF dengan nama fitur
			pcall(function()
				StarterGui:SetCore("SendNotification", {
					Title = label.Text,
					Text = "Deactived",
					Duration = 2
				})
			end)
		end
	end
end)

-- ===== AUTO EQUIP ROD LOGIC =====
local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local EquipToolFromHotbar = netFolder:WaitForChild("RE/EquipToolFromHotbar")

RunService.Heartbeat:Connect(function()
	if autoEquipEnabled and LocalPlayer.Character then
		pcall(function()
			EquipToolFromHotbar:FireServer(1) -- slot 1, pastikan rod ada di slot pertama
		end)
	end
end)

-- Set tab aktif
if _G.SelectTab then
	_G.SelectTab("Fishing")
end
