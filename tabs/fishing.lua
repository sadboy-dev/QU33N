--// QU33N – FISHING TAB (ENUM SAFE EXPANDABLE)

repeat task.wait() until _G.QU33N and _G.QU33N.Pages and _G.QU33N.Pages.Fishing

local UI = _G.QU33N
local page = UI.Pages.Fishing
local Theme = UI.Theme
local UserInputService = game:GetService("UserInputService")

-- Bersihkan page
page:ClearAllChildren()

-- SCROLL FRAME
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = page
Scroll.Size = UDim2.new(1,0,1,0)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
Scroll.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0

local Padding = Instance.new("UIPadding", Scroll)
Padding.PaddingTop = UDim.new(0,8)
Padding.PaddingLeft = UDim.new(0,4)
Padding.PaddingRight = UDim.new(0,4)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,12)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- CARD BUILDER DENGAN TOGGLE
local function createToggleCard(titleText, descText)
	local Card = Instance.new("Frame")
	Card.Size = UDim2.new(1,-6,0,50) -- tinggi default
	Card.BackgroundColor3 = Theme.Panel
	Card.BorderSizePixel = 0
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)
	Card.Parent = Scroll

	-- Title
	local Title = Instance.new("TextButton")
	Title.Parent = Card
	Title.Size = UDim2.new(1,0,0,50)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 16
	Title.TextColor3 = Theme.Accent
	Title.Text = titleText
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextYAlignment = Enum.TextYAlignment.Center
	Title.Position = UDim2.new(0,16,0,0)

	-- Desc (hidden by default)
	local Desc = Instance.new("TextLabel")
	Desc.Parent = Card
	Desc.Size = UDim2.new(1,-32,0,0)
	Desc.Position = UDim2.new(0,16,0,50)
	Desc.Text = descText
	Desc.Font = Enum.Font.Gotham
	Desc.TextSize = 13
	Desc.TextColor3 = Theme.SubText
	Desc.TextWrapped = true
	Desc.BackgroundTransparency = 1
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.TextYAlignment = Enum.TextYAlignment.Top

	-- Toggle logic
	local expanded = false
	Title.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			local textHeight = 40 -- atau hitung otomatis
			Desc.Size = UDim2.new(1,-32,0,textHeight)
			Card.Size = UDim2.new(1,-6,0,50 + textHeight + 8)
		else
			Desc.Size = UDim2.new(1,-32,0,0)
			Card.Size = UDim2.new(1,-6,0,50)
		end
	end)
end

-- CONTOH FISHING FEATURES
createToggleCard("Auto Cast", "Otomatis melempar pancing sesuai interval.")
createToggleCard("Auto Reel", "Reel otomatis saat ikan menggigit.")
createToggleCard("Cast Interval", "Atur interval lempar pancing (detik).")

-- UPDATE CanvasSize otomatis
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y)
end)
