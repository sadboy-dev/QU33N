--// QU33N – INFO TAB (ENUM SAFE FINAL)

-- Tunggu GUI bridge siap
repeat task.wait() until _G.QU33N and _G.QU33N.Pages and _G.QU33N.Pages.Info

local UI = _G.QU33N
local page = UI.Pages.Info
local Theme = UI.Theme

-- Bersihkan page (aman untuk reload)
page:ClearAllChildren()

-- === SCROLL FRAME ===
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = page
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageTransparency = 0.6
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0

-- Padding
local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 4)
Padding.PaddingRight = UDim.new(0, 4)
Padding.Parent = Scroll

-- Layout
local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 14)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- === CARD BUILDER ===
local function createCard(titleText, descText, buttonText, callback)
	local Card = Instance.new("Frame")
	Card.Parent = Scroll
	Card.Size = UDim2.new(1, -6, 0, 130)
	Card.BackgroundColor3 = Theme.Panel
	Card.BorderSizePixel = 0
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

	-- Title
	local Title = Instance.new("TextLabel")
	Title.Parent = Card
	Title.Text = titleText
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 16
	Title.TextColor3 = Theme.Accent
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 16, 0, 14)
	Title.Size = UDim2.new(1, -32, 0, 22)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextYAlignment = Enum.TextYAlignment.Center

	-- Description
	local Desc = Instance.new("TextLabel")
	Desc.Parent = Card
	Desc.Text = descText
	Desc.Font = Enum.Font.Gotham
	Desc.TextSize = 13
	Desc.TextColor3 = Theme.SubText
	Desc.BackgroundTransparency = 1
	Desc.Position = UDim2.new(0, 16, 0, 44)
	Desc.Size = UDim2.new(1, -32, 0, 44)
	Desc.TextWrapped = true
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.TextYAlignment = Enum.TextYAlignment.Top

	-- Button (optional)
	if buttonText then
		local Btn = Instance.new("TextButton")
		Btn.Parent = Card
		Btn.Size = UDim2.new(1, -32, 0, 34)
		Btn.Position = UDim2.new(0, 16, 1, -46)
		Btn.BackgroundColor3 = Theme.BG
		Btn.BorderSizePixel = 0
		Btn.Text = buttonText
		Btn.Font = Enum.Font.GothamBold
		Btn.TextSize = 13
		Btn.TextColor3 = Theme.Text
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)

		if callback then
			Btn.MouseButton1Click:Connect(callback)
		end
	end
end

-- === CONTENT ===

createCard(
	"QU33N UI",
	"QU33N adalah UI modular terinspirasi Chloe X.\nMenggunakan sistem loader → main → gui → tabs.",
	nil
)

createCard(
	"Fast Fishing",
	"Support Blatant V1 dan Blatant V2.\nOptimized untuk FishIt & Delta Mobile.",
	nil
)

createCard(
	"Discord Community",
	"Gabung Discord untuk update dan support.",
	"COPY DISCORD",
	function()
		if setclipboard then
			setclipboard("https://discord.gg/chloex")
		end
	end
)

createCard(
	"System Info",
	"GUI Bridge Global\nEnum Safe\nModular Tab System\nMobile Friendly",
	nil
)
