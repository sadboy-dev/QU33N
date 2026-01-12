--// QU33N – FISHING TAB (ENUM SAFE FINAL)

-- Tunggu GUI bridge siap
repeat task.wait() until _G.QU33N and _G.QU33N.Pages and _G.QU33N.Pages.Fishing

local UI = _G.QU33N
local page = UI.Pages.Fishing
local Theme = UI.Theme
local UserInputService = game:GetService("UserInputService")

-- Bersihkan page (aman untuk reload)
page:ClearAllChildren()

-- === SCROLL FRAME (VERTICAL ONLY) ===
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = page
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
Scroll.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
Scroll.ScrollBarThickness = 6
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
Layout.Padding = UDim.new(0, 12)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- === CARD BUILDER ===
local function createCard(titleText, descText, buttonText, callback)
	local Card = Instance.new("Frame")
	Card.Parent = Scroll
	Card.Size = UDim2.new(1, -6, 0, 120)
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
	Title.Position = UDim2.new(0, 16, 0, 12)
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
	Desc.Position = UDim2.new(0, 16, 0, 40)
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

-- === FISHING FEATURE CARDS ===

-- Auto Cast
createCard(
	"Auto Cast",
	"Tombol untuk otomatis melempar pancing.\nCek interval di bawah.",
	"Toggle",
	function()
		print("Toggle Auto Cast clicked") -- bisa diganti logic auto cast
	end
)

-- Auto Reel
createCard(
	"Auto Reel",
	"Reel otomatis ketika ikan menggigit.",
	"Toggle",
	function()
		print("Toggle Auto Reel clicked") -- bisa diganti logic auto reel
	end
)

-- Cast Interval Slider Card
createCard(
	"Cast Interval",
	"Atur interval lempar pancing (detik).",
	nil
)

-- Slider di dalam card
local lastCard = Scroll:GetChildren()[#Scroll:GetChildren()]
local intervalSlider = Instance.new("Frame", lastCard)
intervalSlider.Size = UDim2.new(1, -32, 0, 30)
intervalSlider.Position = UDim2.new(0,16,0,80)
intervalSlider.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", intervalSlider).CornerRadius = UDim.new(0,6)

local sliderBar = Instance.new("Frame", intervalSlider)
sliderBar.Size = UDim2.new(0.5,0,1,0)
sliderBar.BackgroundColor3 = Theme.Accent
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0,6)

local sliderLabel = Instance.new("TextLabel", intervalSlider)
sliderLabel.Size = UDim2.new(1,0,1,0)
sliderLabel.Text = "1.0 s"
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 14
sliderLabel.TextColor3 = Theme.Text
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Slider drag cross-platform
local dragging = false
sliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
	end
end)
sliderBar.InputEnded:Connect(function(input)
	dragging = false
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local relPos = math.clamp(input.Position.X - intervalSlider.AbsolutePosition.X,0,intervalSlider.AbsoluteSize.X)
		sliderBar.Size = UDim2.new(0, relPos,1,0)
		sliderLabel.Text = string.format("%.1f s", (relPos/intervalSlider.AbsoluteSize.X)*5) -- max 5 detik
	end
end)

-- === AUTO UPDATE CanvasSize ===
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y)
end)
