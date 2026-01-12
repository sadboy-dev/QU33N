--// QU33N – INFO TAB (FINAL FIX)
--// Requires GLOBAL GUI BRIDGE

repeat task.wait() until _G.QU33N and _G.QU33N.Pages end

local page = _G.QU33N.Pages.Info
local Theme = _G.QU33N.Theme

-- Clear page (aman untuk reload)
page:ClearAllChildren()

-- ScrollFrame
local Scroll = Instance.new("ScrollingFrame", page)
Scroll.Size = UDim2.new(1,0,1,0)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarImageTransparency = 0.7
Scroll.ScrollBarThickness = 4
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0

-- Layout
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,14)
Layout.HorizontalAlignment = Center

Instance.new("UIPadding", Scroll).PaddingTop = UDim.new(0,6)

-- === CARD CREATOR ===
local function createCard(title, desc, buttonText, callback)
	local Card = Instance.new("Frame")
	Card.Size = UDim2.new(1,-6,0,120)
	Card.BackgroundColor3 = Theme.Panel
	Card.Parent = Scroll
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)

	-- Title
	local T = Instance.new("TextLabel", Card)
	T.Text = title
	T.Font = Enum.Font.GothamBold
	T.TextSize = 16
	T.TextColor3 = Theme.Accent
	T.BackgroundTransparency = 1
	T.Position = UDim2.new(0,16,0,14)
	T.Size = UDim2.new(1,-32,0,22)
	T.TextXAlignment = Left

	-- Desc
	local D = Instance.new("TextLabel", Card)
	D.Text = desc
	D.Font = Enum.Font.Gotham
	D.TextSize = 13
	D.TextColor3 = Theme.SubText
	D.BackgroundTransparency = 1
	D.Position = UDim2.new(0,16,0,40)
	D.Size = UDim2.new(1,-32,0,36)
	D.TextWrapped = true
	D.TextXAlignment = Left
	D.TextYAlignment = Top

	-- Button
	if buttonText then
		local B = Instance.new("TextButton", Card)
		B.Size = UDim2.new(1,-32,0,34)
		B.Position = UDim2.new(0,16,1,-46)
		B.BackgroundColor3 = Theme.BG
		B.Text = buttonText
		B.Font = Enum.Font.GothamBold
		B.TextSize = 13
		B.TextColor3 = Theme.Text
		B.BorderSizePixel = 0
		Instance.new("UICorner", B).CornerRadius = UDim.new(0,12)

		if callback then
			B.MouseButton1Click:Connect(callback)
		end
	end
end

-- === CONTENT ===

createCard(
	"Chloe X Information",
	"QU33N adalah UI modular terinspirasi Chloe X.\nFast Fishing • Blatant • Modular System",
	nil
)

createCard(
	"CHLOE X Discord",
	"Join Discord resmi Chloe X untuk update & support.",
	"COPY LINK DISCORD",
	function()
		setclipboard("https://discord.gg/chloex")
	end
)

createCard(
	"RGD Top Up",
	"Top up Robux termurah hanya di RGD.GG!",
	"COPY LINK RGD",
	function()
		setclipboard("https://rgd.gg")
	end
)

createCard(
	"QU33N System",
	"Loader → Main → GUI → Tabs\nStruktur modular aman untuk update tanpa rusak.",
	nil
)
