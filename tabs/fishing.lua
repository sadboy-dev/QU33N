--// QU33N – FISHING TAB FINAL (ENUM SAFE)

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

-- CARD BUILDER DENGAN EXPANDABLE CONTENT
local function createFeatureCard(titleText, descText)
	local Card = Instance.new("Frame")
	Card.Size = UDim2.new(1,-6,0,50)
	Card.BackgroundColor3 = Theme.Panel
	Card.BorderSizePixel = 0
	Card.AutomaticSize = Enum.AutomaticSize.Y
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)
	Card.Parent = Scroll

	-- Title Button
	local Title = Instance.new("TextButton")
	Title.Parent = Card
	Title.Size = UDim2.new(1,0,0,50)
	Title.Position = UDim2.new(0,0,0,0)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 16
	Title.TextColor3 = Theme.Accent
	Title.Text = titleText
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextYAlignment = Enum.TextYAlignment.Center
	Title.ClipsDescendants = true

	-- Container untuk isi fitur (hidden by default)
	local Content = Instance.new("Frame")
	Content.Parent = Card
	Content.Size = UDim2.new(1,0,0,0)
	Content.Position = UDim2.new(0,0,0,50)
	Content.BackgroundTransparency = 1
	Content.ClipsDescendants = true
	Content.AutomaticSize = Enum.AutomaticSize.Y

	-- Layout dalam content
	local innerLayout = Instance.new("UIListLayout", Content)
	innerLayout.Padding = UDim.new(0,6)
	innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	innerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Expand/Collapse logic
	local expanded = false
	Title.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			Content.Size = UDim2.new(1,0,0,0) -- AutomaticSize Y akan menyesuaikan inner content
		else
			Content.Size = UDim2.new(1,0,0,0)
		end
	end)

	return Card, Content
end

-- ======= FITUR FISHING =======

-- Auto Cast Toggle
local autoCastCard, autoCastContent = createFeatureCard("Auto Cast", "Otomatis melempar pancing.")
local autoCastBtn = Instance.new("TextButton", autoCastContent)
autoCastBtn.Size = UDim2.new(1,-32,0,40)
autoCastBtn.BackgroundColor3 = Theme.Panel
autoCastBtn.TextColor3 = Theme.Text
autoCastBtn.Font = Enum.Font.Gotham
autoCastBtn.TextSize = 16
autoCastBtn.Text = "OFF"
Instance.new("UICorner", autoCastBtn).CornerRadius = UDim.new(0,6)

local autoCastEnabled = false
autoCastBtn.MouseButton1Click:Connect(function()
	autoCastEnabled = not autoCastEnabled
	autoCastBtn.Text = autoCastEnabled and "ON" or "OFF"
end)

-- Auto Reel Toggle
local autoReelCard, autoReelContent = createFeatureCard("Auto Reel", "Reel otomatis saat ikan menggigit.")
local autoReelBtn = Instance.new("TextButton", autoReelContent)
autoReelBtn.Size = UDim2.new(1,-32,0,40)
autoReelBtn.BackgroundColor3 = Theme.Panel
autoReelBtn.TextColor3 = Theme.Text
autoReelBtn.Font = Enum.Font.Gotham
autoReelBtn.TextSize = 16
autoReelBtn.Text = "OFF"
Instance.new("UICorner", autoReelBtn).CornerRadius = UDim.new(0,6)

local autoReelEnabled = false
autoReelBtn.MouseButton1Click:Connect(function()
	autoReelEnabled = not autoReelEnabled
	autoReelBtn.Text = autoReelEnabled and "ON" or "OFF"
end)

-- Cast Interval Slider
local intervalCard, intervalContent = createFeatureCard("Cast Interval", "Atur interval lempar pancing (detik).")
local intervalSliderFrame = Instance.new("Frame", intervalContent)
intervalSliderFrame.Size = UDim2.new(1,-32,0,30)
intervalSliderFrame.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", intervalSliderFrame).CornerRadius = UDim.new(0,6)

local sliderBar = Instance.new("Frame", intervalSliderFrame)
sliderBar.Size = UDim2.new(0.5,0,1,0)
sliderBar.BackgroundColor3 = Theme.Accent
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0,6)

local sliderLabel = Instance.new("TextLabel", intervalSliderFrame)
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
		local relPos = math.clamp(input.Position.X - intervalSliderFrame.AbsolutePosition.X,0,intervalSliderFrame.AbsoluteSize.X)
		sliderBar.Size = UDim2.new(0, relPos,1,0)
		sliderLabel.Text = string.format("%.1f s", (relPos/intervalSliderFrame.AbsoluteSize.X)*5) -- max 5 detik
	end
end)

-- ===== AUTO UPDATE CanvasSize =====
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y)
end)
