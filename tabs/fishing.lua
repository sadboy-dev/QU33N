-- tabs/fishing.lua (FINAL COMPLETE)
-- Tunggu GUI bridge siap
repeat task.wait() until _G.QU33N and _G.QU33N.Pages and _G.QU33N.Pages.Fishing

local UI = _G.QU33N
local page = UI.Pages.Fishing
local Theme = UI.Theme

-- Bersihkan page
page:ClearAllChildren()

-- === SCROLL FRAME ===
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = page
Scroll.Size = UDim2.new(1,0,1,0)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
Scroll.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageTransparency = 0.6
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0

-- Padding
local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0,8)
Padding.PaddingLeft = UDim.new(0,4)
Padding.PaddingRight = UDim.new(0,4)
Padding.Parent = Scroll

-- Layout
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,14)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ===== EXPANDABLE CARD FUNCTION =====
local function createToggleCard(parent, title, description)
	local Card = Instance.new("Frame")
	Card.Parent = parent
	Card.Size = UDim2.new(1,-6,0,50)
	Card.BackgroundColor3 = Theme.Panel
	Card.BorderSizePixel = 0
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)

	-- Judul button
	local TitleBtn = Instance.new("TextButton", Card)
	TitleBtn.Size = UDim2.new(1,0,0,50)
	TitleBtn.BackgroundTransparency = 1
	TitleBtn.Font = Enum.Font.GothamBold
	TitleBtn.TextSize = 16
	TitleBtn.TextColor3 = Theme.Accent
	TitleBtn.Text = title
	TitleBtn.TextXAlignment = Enum.TextXAlignment.Left
	TitleBtn.TextYAlignment = Enum.TextYAlignment.Center
	TitleBtn.Position = UDim2.new(0,16,0,0)

	-- Body (hidden awal)
	local Body = Instance.new("Frame", Card)
	Body.Size = UDim2.new(1,0,0,0)
	Body.Position = UDim2.new(0,0,0,50)
	Body.BackgroundTransparency = 1
	Body.ClipsDescendants = true

	local BodyLayout = Instance.new("UIListLayout", Body)
	BodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
	BodyLayout.Padding = UDim.new(0,6)

	local expanded = false

	local function updateCardSize()
		if expanded then
			local bodyHeight = 0
			for _,v in pairs(Body:GetChildren()) do
				if v:IsA("GuiObject") then
					bodyHeight += v.AbsoluteSize.Y
				end
			end
			Card.Size = UDim2.new(1,-6,0,50 + bodyHeight + 12)
			Body:TweenSize(UDim2.new(1,0,0,bodyHeight), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.2,true)
		else
			Body:TweenSize(UDim2.new(1,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.2,true)
			Card.Size = UDim2.new(1,-6,0,50)
		end
	end

	TitleBtn.MouseButton1Click:Connect(function()
		expanded = not expanded
		updateCardSize()
	end)

	return Card, Body
end

-- ===== FISHING SUPPORT CARD =====
local cardFishing, bodyFishing = createToggleCard(Scroll, "Fishing Support", "")

-- Row Auto Equip Rod (toggle bulatan)
local row = Instance.new("Frame")
row.Size = UDim2.new(1,0,0,30)
row.Position = UDim2.new(0,0,0,0)
row.BackgroundTransparency = 1
row.Parent = bodyFishing

-- Label
local label = Instance.new("TextLabel")
label.Parent = row
label.Size = UDim2.new(0.6,0,1,0)
label.Position = UDim2.new(0,16,0,0)
label.BackgroundTransparency = 1
label.Text = "Auto Equip Rod"
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextColor3 = Theme.Text
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Center

-- Toggle Frame
local toggleFrame = Instance.new("Frame")
toggleFrame.Parent = row
toggleFrame.Size = UDim2.new(0.3,0,0.5,0)
toggleFrame.Position = UDim2.new(0.65,0,0.25,0)
toggleFrame.BackgroundColor3 = Color3.fromRGB(80,80,80)
Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0.5,0)

-- Toggle Knob
local knob = Instance.new("Frame")
knob.Parent = toggleFrame
knob.Size = UDim2.new(0.5,0,1,0)
knob.Position = UDim2.new(0,0,0,0)
knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", knob).CornerRadius = UDim.new(0.5,0)

-- Toggle logic
local enabled = false
toggleFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		enabled = not enabled
		if enabled then
			knob:TweenPosition(UDim2.new(0.5,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			toggleFrame.BackgroundColor3 = Theme.Accent
		else
			knob:TweenPosition(UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			toggleFrame.BackgroundColor3 = Color3.fromRGB(80,80,80)
		end
		print("Auto Equip Rod:", enabled)
	end
end)

-- ===== CAST INTERVAL CARD =====
local cardInterval, bodyInterval = createToggleCard(Scroll, "Cast Interval", "Atur interval lempar pancing.")

local slider = Instance.new("TextButton", bodyInterval)
slider.Size = UDim2.new(1,-32,0,30)
slider.Position = UDim2.new(0,16,0,0)
slider.BackgroundColor3 = Theme.BG
slider.TextColor3 = Theme.Text
slider.Text = "Interval: 1s"
Instance.new("UICorner", slider).CornerRadius = UDim.new(0,8)

local value = 1
slider.MouseButton1Click:Connect(function()
	value += 1
	if value > 5 then value = 1 end
	slider.Text = "Interval: "..value.."s"
	print("Cast interval:",value)
end)

-- Set default active tab Fishing
if _G.SelectTab then
	_G.SelectTab("Fishing")
end
