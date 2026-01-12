-- tabs/fishing.lua
-- Tunggu GUI bridge siap
repeat task.wait() until _G.QU33N and _G.QU33N.Pages and _G.QU33N.Pages.Fishing

local UI = _G.QU33N
local page = UI.Pages.Fishing
local Theme = UI.Theme

-- Bersihkan page (aman untuk reload)
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

	local DescLabel = Instance.new("TextLabel", Body)
	DescLabel.Size = UDim2.new(1,-32,0,40)
	DescLabel.Position = UDim2.new(0,16,0,0)
	DescLabel.Text = description
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.TextSize = 13
	DescLabel.TextColor3 = Theme.SubText
	DescLabel.BackgroundTransparency = 1
	DescLabel.TextWrapped = true
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.TextYAlignment = Enum.TextYAlignment.Top

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

-- ===== DROPDOWN FUNCTION =====
local function createDropdown(parent, labelText, options, default, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,-20,0,36)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Parent = container
	label.Size = UDim2.new(1,-10,1,0)
	label.Position = UDim2.new(0,10,0,0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Theme.Text
	label.Text = labelText .. ": " .. (default or "")

	local dropdownBtn = Instance.new("TextButton")
	dropdownBtn.Parent = container
	dropdownBtn.Size = UDim2.new(1,-10,1,0)
	dropdownBtn.Position = UDim2.new(0,10,0,0)
	dropdownBtn.Text = ""
	dropdownBtn.BackgroundTransparency = 1

	local listFrame = Instance.new("Frame")
	listFrame.Parent = container
	listFrame.Size = UDim2.new(1,0,0,0)
	listFrame.Position = UDim2.new(0,0,1,0)
	listFrame.BackgroundColor3 = Theme.Panel
	listFrame.BorderSizePixel = 0
	listFrame.ClipsDescendants = true
	Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0,6)

	local layout = Instance.new("UIListLayout", listFrame)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,4)

	local expanded = false
	local function closeDropdown()
		expanded = false
		listFrame:TweenSize(UDim2.new(1,0,0,0),"Out","Quad",0.2,true)
	end
	local function openDropdown()
		expanded = true
		listFrame:TweenSize(UDim2.new(1,0,0,#options*30),"Out","Quad",0.2,true)
	end

	dropdownBtn.MouseButton1Click:Connect(function()
		if expanded then
			closeDropdown()
		else
			openDropdown()
		end
	end)

	for _,opt in ipairs(options) do
		local btn = Instance.new("TextButton")
		btn.Parent = listFrame
		btn.Size = UDim2.new(1,0,0,30)
		btn.BackgroundColor3 = Theme.BG
		btn.TextColor3 = Theme.Text
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.Text = opt
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

		btn.MouseButton1Click:Connect(function()
			label.Text = labelText .. ": " .. opt
			if callback then callback(opt) end
			closeDropdown()
		end)
	end

	return container
end

-- ===== CONTENT =====
-- Card: Auto Cast
local cardAutoCast, bodyAuto = createToggleCard(Scroll,"Auto Cast","Nyalakan atau matikan auto cast pancing.")
local toggleBtn = Instance.new("TextButton", bodyAuto)
toggleBtn.Size = UDim2.new(1,-32,0,30)
toggleBtn.Position = UDim2.new(0,16,0,0)
toggleBtn.BackgroundColor3 = Theme.BG
toggleBtn.TextColor3 = Theme.Text
toggleBtn.Text = "Toggle Auto Cast"
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,8)
toggleBtn.MouseButton1Click:Connect(function()
	print("Auto Cast Toggled")
end)

-- Card: Fishing Mode
createDropdown(Scroll,"Fishing Mode",{"Manual","Auto","Fast"},"Manual",function(val)
	print("Mode dipilih:",val)
end)

-- Card: Cast Interval
local cardInterval, bodyInterval = createToggleCard(Scroll,"Cast Interval","Atur interval lempar pancing.")
local slider = Instance.new("TextButton", bodyInterval)
slider.Size = UDim2.new(1,-32,0,30)
slider.Position = UDim2.new(0,16,0,0)
slider.BackgroundColor3 = Theme.BG
slider.TextColor3 = Theme.Text
slider.Text = "Interval: 1s"
Instance.new("UICorner", slider).CornerRadius = UDim.new(0,8)
-- Contoh simple slider logic
local value = 1
slider.MouseButton1Click:Connect(function()
	value += 1
	if value>5 then value=1 end
	slider.Text = "Interval: "..value.."s"
	print("Cast interval:",value)
end)

-- Set default active tab Fishing
if _G.SelectTab then
	_G.SelectTab("Fishing")
end
