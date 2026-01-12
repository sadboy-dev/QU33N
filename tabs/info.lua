-- tabs/info.lua
-- QU33N - Info Tab

return function(page, Theme)
	Theme = Theme or {
		Panel = Color3.fromRGB(26,30,36),
		Text = Color3.fromRGB(235,235,235),
		SubText = Color3.fromRGB(155,160,166),
		Accent = Color3.fromRGB(79,139,255)
	}

	-- ScrollFrame
	local Scroll = Instance.new("ScrollingFrame", page)
	Scroll.Size = UDim2.new(1,0,1,0)
	Scroll.CanvasSize = UDim2.new(0,0,0,0)
	Scroll.ScrollBarImageTransparency = 0.4
	Scroll.ScrollBarThickness = 4
	Scroll.BackgroundTransparency = 1
	Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local Layout = Instance.new("UIListLayout", Scroll)
	Layout.Padding = UDim.new(0,14)

	Instance.new("UIPadding", Scroll).PaddingLeft = UDim.new(0,6)

	-- ===== TITLE =====
	local Title = Instance.new("TextLabel", Scroll)
	Title.Text = "Chloe X Information"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 22
	Title.TextColor3 = Theme.Accent
	Title.BackgroundTransparency = 1
	Title.TextXAlignment = Left
	Title.Size = UDim2.new(1,-10,0,30)

	-- Divider
	local Line = Instance.new("Frame", Scroll)
	Line.Size = UDim2.new(1,-10,0,2)
	Line.BackgroundColor3 = Theme.Accent
	Line.BorderSizePixel = 0

	-- ===== CARD CREATOR =====
	local function createCard(icon, title, desc, buttonText, callback)
		local Card = Instance.new("Frame", Scroll)
		Card.Size = UDim2.new(1,-10,0,110)
		Card.BackgroundColor3 = Theme.Panel
		Card.BorderSizePixel = 0
		Card.AutomaticSize = Enum.AutomaticSize.Y
		Instance.new("UICorner", Card).CornerRadius = UDim.new(0,14)

		local Padding = Instance.new("UIPadding", Card)
		Padding.PaddingLeft = UDim.new(0,14)
		Padding.PaddingTop = UDim.new(0,14)
		Padding.PaddingRight = UDim.new(0,14)
		Padding.PaddingBottom = UDim.new(0,14)

		local Icon = Instance.new("TextLabel", Card)
		Icon.Text = icon
		Icon.Font = Enum.Font.GothamBold
		Icon.TextSize = 20
		Icon.TextColor3 = Theme.Accent
		Icon.BackgroundTransparency = 1
		Icon.Size = UDim2.new(0,26,0,26)

		local Title = Instance.new("TextLabel", Card)
		Title.Text = title
		Title.Font = Enum.Font.GothamBold
		Title.TextSize = 16
		Title.TextColor3 = Theme.Text
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0,34,0,0)
		Title.Size = UDim2.new(1,-34,0,22)
		Title.TextXAlignment = Left

		local Desc = Instance.new("TextLabel", Card)
		Desc.Text = desc
		Desc.Font = Enum.Font.Gotham
		Desc.TextSize = 13
		Desc.TextColor3 = Theme.SubText
		Desc.TextWrapped = true
		Desc.BackgroundTransparency = 1
		Desc.Position = UDim2.new(0,34,0,26)
		Desc.Size = UDim2.new(1,-34,0,36)
		Desc.AutomaticSize = Enum.AutomaticSize.Y
		Desc.TextXAlignment = Left
		Desc.TextYAlignment = Top

		local Btn = Instance.new("TextButton", Card)
		Btn.Text = buttonText
		Btn.Font = Enum.Font.GothamBold
		Btn.TextSize = 13
		Btn.TextColor3 = Theme.Text
		Btn.BackgroundColor3 = Theme.Accent
		Btn.Size = UDim2.new(1,0,0,34)
		Btn.Position = UDim2.new(0,0,1,-34)
		Btn.BorderSizePixel = 0
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,10)

		Btn.MouseButton1Click:Connect(callback)
	end

	-- ===== CONTENT =====
	createCard(
		"⬢",
		"QU33N Discord",
		"Official link discord QU33N (COMING SOON!)",
		"COPY LINK DISCORD",
		function()
			setclipboard("https://discord.gg/")
		end
	)

	createCard(
		"⬢",
		"QU33N TOOLs",
		"Coming Soon!",
		"Copy",
		function()
			setclipboard("https://google.com")
		end
	)
end
