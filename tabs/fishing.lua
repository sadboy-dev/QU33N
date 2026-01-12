-- tabs/fishing.lua (FINAL V2 — Fishing Support + Cast Interval)
repeat task.wait() until _G.QU33N and _G.QU33N.Pages and _G.QU33N.Pages.Fishing

local UI = _G.QU33N
local page = UI.Pages.Fishing
local Theme = UI.Theme

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
Padding.PaddingLeft = UDim.new(0,4)
Padding.PaddingRight = UDim.new(0,4)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,14)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Card helper
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

-- ===== Fishing Support Card =====
local cardFishing, bodyFishing = createToggleCard(Scroll, "Fishing Support")

-- Row container
local row = Instance.new("Frame")
row.Size = UDim2.new(1,0,0,36)
row.BackgroundTransparency = 1
row.Parent = bodyFishing

-- Label
local label = Instance.new("TextLabel")
label.Parent = row
label.Size = UDim2.new(0.6,0,1,0)
label.Position = UDim2.new(0,16,0,0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextColor3 = Theme.Text
label.Text = "Auto Equip Rod"
label.TextXAlignment = Enum.TextXAlignment.Left

-- Switch
local switchFrame = Instance.new("Frame", row)
switchFrame.Size = UDim2.new(0.25,0,0.6,0)
switchFrame.Position = UDim2.new(0.65,0,0.2,0)
switchFrame.BackgroundColor3 = Color3.fromRGB(90,90,90)
Instance.new("UICorner", switchFrame).CornerRadius = UDim.new(1,0)

local knob = Instance.new("Frame", switchFrame)
knob.Size = UDim2.new(0.5,0,1,0)
knob.Position = UDim2.new(0,0,0,0)
knob.BackgroundColor3 = Theme.BG
Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

local autoEquipEnabled = false
switchFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		autoEquipEnabled = not autoEquipEnabled
		if autoEquipEnabled then
			knob:TweenPosition(UDim2.new(0.5,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			switchFrame.BackgroundColor3 = Theme.Accent
		else
			knob:TweenPosition(UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			switchFrame.BackgroundColor3 = Color3.fromRGB(90,90,90)
		end
		print("Auto Equip Rod:", autoEquipEnabled)
		-- TODO: implement actual equip logic
	end
end)

-- ===== Cast Interval Card =====
local cardInterval, bodyInterval = createToggleCard(Scroll, "Cast Interval")

local sliderBtn = Instance.new("TextButton", bodyInterval)
sliderBtn.Size = UDim2.new(1,-32,0,30)
sliderBtn.Position = UDim2.new(0,16,0,0)
sliderBtn.BackgroundColor3 = Theme.BG
sliderBtn.TextColor3 = Theme.Text
sliderBtn.Font = Enum.Font.Gotham
sliderBtn.TextSize = 14
sliderBtn.Text = "Interval: 1.0s"
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(0,8)

local intervalValue = 1
sliderBtn.MouseButton1Click:Connect(function()
	intervalValue = intervalValue + 0.5
	if intervalValue > 5 then
		intervalValue = 0.5
	end
	sliderBtn.Text = ("Interval: %.1fs"):format(intervalValue)
	print("Cast interval:", intervalValue)
end)

-- Set tab active
if _G.SelectTab then
	_G.SelectTab("Fishing")
end
