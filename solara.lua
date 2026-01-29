--// QU33N FULL SINGLE FILE (MOBILE SIZE FIX + SINGLE LOG CARD + SCROLL TABS)

repeat task.wait() until game:IsLoaded()
task.wait(0.2)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Detect Mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Notify
local function notify(text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "QU33N",
			Text = text,
			Duration = 3
		})
	end)
end

-- Cleanup old GUI
if CoreGui:FindFirstChild("QU33N") then
	CoreGui.QU33N:Destroy()
end

-- Theme
local Theme = {
	BG = Color3.fromRGB(15,17,21),
	Panel = Color3.fromRGB(26,30,36),
	Text = Color3.fromRGB(235,235,235),
	SubText = Color3.fromRGB(155,160,166),
	Accent = Color3.fromRGB(79,139,255)
}

-- Responsive Size
local function responsiveSize()
	if isMobile then
		return UDim2.new(0.80,0,0.78,0) -- MOBILE smaller
	else
		return UDim2.new(0.38,0,0.72,0) -- PC same
	end
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QU33N"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = CoreGui

-- Main frame
local Main = Instance.new("Frame", ScreenGui)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.new(0.5,0,0.52,0)
Main.Size = responsiveSize()
Main.BackgroundColor3 = Theme.BG
Main.ClipsDescendants = true
Main.ZIndex = 20
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

-- Drag main window
do
	local dragging, dragStart, startPos
	Main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = Main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			Main.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function()
		dragging = false
	end)
end

-- Header
local Header = Instance.new("Frame", Main)
Header.Position = UDim2.new(0,16,0,6)
Header.Size = UDim2.new(1,-32,0,50)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Text = "QU33N"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Theme.Text
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons container
local btnContainer = Instance.new("Frame", Header)
btnContainer.AnchorPoint = Vector2.new(1,0.5)
btnContainer.Position = UDim2.new(1,-6,0.5,0)
btnContainer.Size = UDim2.new(0,80,1,0)
btnContainer.BackgroundTransparency = 1

-- Close
local CloseBtn = Instance.new("TextButton", btnContainer)
CloseBtn.Size = UDim2.new(0,35,0,28)
CloseBtn.Position = UDim2.new(0.55,0,0.15,0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Theme.Text
CloseBtn.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)

-- Minimize
local MinBtn = Instance.new("TextButton", btnContainer)
MinBtn.Size = UDim2.new(0,35,0,28)
MinBtn.Position = UDim2.new(0,0,0.15,0)
MinBtn.Text = "_"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Theme.Text
MinBtn.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

-- Floating logo
local logo = Instance.new("TextButton", ScreenGui)
logo.Text="⚡"
logo.Font=Enum.Font.GothamBold
logo.TextSize=22
logo.TextColor3=Theme.Accent
logo.Size = UDim2.new(0,44,0,44)
logo.Position = UDim2.new(0,20,0.5,-22)
logo.BackgroundColor3=Theme.Panel
logo.Visible=false
logo.AnchorPoint = Vector2.new(0,0.5)
Instance.new("UICorner",logo).CornerRadius = UDim.new(1,0)

-- Drag logo
do
	local dragging, dragStart, startPos
	logo.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = logo.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			logo.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function()
		dragging = false
	end)
end

logo.MouseButton1Click:Connect(function()
	Main.Visible = true
	logo.Visible = false
end)

MinBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
	logo.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
	Main:Destroy()
end)

-- Tabs bar
local TabBar = Instance.new("Frame", Main)
TabBar.Position = UDim2.new(0,16,0,58)
TabBar.Size = UDim2.new(1,-32,0,40)
TabBar.BackgroundTransparency = 1

-- Scrollable Tabs
local TabsContainer = Instance.new("ScrollingFrame", TabBar)
TabsContainer.Size = UDim2.new(1,0,1,0)
TabsContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
TabsContainer.ScrollingDirection = Enum.ScrollingDirection.X
TabsContainer.ScrollBarThickness = 0
TabsContainer.BackgroundTransparency = 1
TabsContainer.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout", TabsContainer)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,6)

-- Pages
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.new(0,16,0,104)
Pages.Size = UDim2.new(1,-32,1,-120)
Pages.BackgroundTransparency = 1

local pageList = {}
local tabButtons = {}

-- LOG STORAGE
local LogMessages = {}
local LogTextLabel

local function pushLog(text)
	local msg = os.date("[%H:%M:%S] ") .. tostring(text)
	table.insert(LogMessages, msg)

	if LogTextLabel then
		LogTextLabel.Text = table.concat(LogMessages, "\n")
	end
end

local function setActive(tabName)
	pushLog("Open Tab: " .. tabName)

	for name,btn in pairs(tabButtons) do
		btn.TextColor3 = (name == tabName) and Theme.Accent or Theme.SubText
		if pageList[name] then
			pageList[name].Visible = (name == tabName)
		end
	end
end

local function createTab(name)
	local b = Instance.new("TextButton")
	b.Parent = TabsContainer
	b.Size = UDim2.new(0,110,1,0)
	b.BackgroundColor3 = Theme.Panel
	b.Text = name
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.TextColor3 = Theme.SubText
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	b.MouseButton1Click:Connect(function()
		setActive(name)
	end)
	tabButtons[name] = b
end

local function createPage(name)
	local p = Instance.new("Frame", Pages)
	p.Size = UDim2.new(1,0,1,0)
	p.BackgroundTransparency = 1
	p.Visible = false
	pageList[name] = p

	local Scroll = Instance.new("ScrollingFrame", p)
	Scroll.Size = UDim2.new(1,0,1,0)
	Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	Scroll.ScrollBarThickness = 5
	Scroll.BackgroundTransparency = 1
	Scroll.BorderSizePixel = 0

	local Layout = Instance.new("UIListLayout", Scroll)
	Layout.Padding = UDim.new(0,14)

	-- LOG TAB
	if name == "Log" then
		local Card = Instance.new("Frame", Scroll)
		Card.Size = UDim2.new(1, -6, 0, 300)
		Card.BackgroundColor3 = Theme.Panel
		Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

		LogTextLabel = Instance.new("TextLabel", Card)
		LogTextLabel.Size = UDim2.new(1, -20, 1, -20)
		LogTextLabel.Position = UDim2.new(0,10,0,10)
		LogTextLabel.BackgroundTransparency = 1
		LogTextLabel.TextWrapped = true
		LogTextLabel.TextXAlignment = Enum.TextXAlignment.Left
		LogTextLabel.TextYAlignment = Enum.TextYAlignment.Top
		LogTextLabel.Font = Enum.Font.Gotham
		LogTextLabel.TextSize = 12
		LogTextLabel.TextColor3 = Theme.SubText
		LogTextLabel.Text = "Log Initialized..."

		pushLog("Log system ready")
		return
	end

	local function createCard(titleText, descText, buttonText, callback)
		local Card = Instance.new("Frame", Scroll)
		Card.Size = UDim2.new(1, -6, 0, 130)
		Card.BackgroundColor3 = Theme.Panel
		Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

		local Title = Instance.new("TextLabel", Card)
		Title.Text = titleText
		Title.Font = Enum.Font.GothamBold
		Title.TextSize = 16
		Title.TextColor3 = Theme.Accent
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0, 16, 0, 14)
		Title.Size = UDim2.new(1, -32, 0, 22)
		Title.TextXAlignment = Enum.TextXAlignment.Left

		local Desc = Instance.new("TextLabel", Card)
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

			if callback then Btn.MouseButton1Click:Connect(callback) end
		end
	end

	if name == "Info" then
		createCard("QU33N UI","QU33N adalah UI modular terinspirasi Chloe X.\nMenggunakan sistem loader → main → gui → tabs.",nil)
		createCard("Fast Fishing","Support Blatant V1 dan Blatant V2.\nOptimized untuk FishIt & Delta Mobile.",nil)
		createCard("Discord Community","Gabung Discord untuk update dan support.","COPY DISCORD",function()
			if setclipboard then
				setclipboard("https://discord.gg/chloex")
				pushLog("Copied Discord Invite")
			end
		end)
		createCard("System Info","GUI Bridge Global\nEnum Safe\nModular Tab System\nMobile Friendly",nil)
	else
		createCard(name .. " Tab","Temporary content\nWaiting for features...",nil)
	end
end

-- Tabs list
local tabs = {"Info","Fishing","Auto","Teleport","Misc","Webhook","Log"}
for _,name in ipairs(tabs) do
	createTab(name)
	createPage(name)
end

setActive("Info")

-- WARN LOGGER
local oldWarn = warn
warn = function(...)
	local msg = table.concat({...}, " ")
	pushLog("WARN: " .. msg)
	oldWarn(...)
end

pushLog("GUI Loaded Successfully")
notify("QU33N Loaded — Mobile Optimized")
