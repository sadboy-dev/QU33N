--// QU33N UI — FULL SINGLE FILE
--// Version: BETA v0.7 (RESTORE v5 TAB ENGINE)

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- DEVICE DETECT
local IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- ROOT GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QU33N_UI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
Main.BorderSizePixel = 0
Main.Size = IS_MOBILE and UDim2.new(0, 340, 0, 420) or UDim2.new(0, 520, 0, 520)
Main.Position = UDim2.new(0.5, -260, 0.5, -260)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

-- THEME
local Theme = {
	BG = Color3.fromRGB(22,22,22),
	Panel = Color3.fromRGB(30,30,30),
	Accent = Color3.fromRGB(175,120,255),
	Text = Color3.fromRGB(230,230,230),
	SubText = Color3.fromRGB(160,160,160),
}

-- HEADER
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Text = "QU33N UI — BETA v0.7"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Theme.Accent
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- BUTTONS
local function makeBtn(text, posX, callback)
	local Btn = Instance.new("TextButton", Header)
	Btn.Size = UDim2.new(0, 34, 0, 28)
	Btn.Position = UDim2.new(1, posX, 0.5, -14)
	Btn.Text = text
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 14
	Btn.BackgroundColor3 = Theme.Panel
	Btn.TextColor3 = Theme.Text
	Btn.BorderSizePixel = 0
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
	Btn.MouseButton1Click:Connect(callback)
end

makeBtn("-", -80, function()
	Main.Visible = not Main.Visible
end)

makeBtn("X", -40, function()
	ScreenGui:Destroy()
end)

-- TAB BAR (v5 RESTORED)
local TabBar = Instance.new("ScrollingFrame", Main)
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.Size = UDim2.new(1, 0, 0, 46)
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBar.ScrollingDirection = Enum.ScrollingDirection.X
TabBar.ScrollBarThickness = 3
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)

-- CONTENT HOLDER
local Pages = Instance.new("Folder", Main)
Pages.Name = "Pages"

local PageHolder = Instance.new("Frame", Main)
PageHolder.Position = UDim2.new(0, 0, 0, 96)
PageHolder.Size = UDim2.new(1, 0, 1, -96)
PageHolder.BackgroundTransparency = 1

-- LOG BUFFER
local LogBuffer = {}
local LogLabel = nil

local function pushLog(text, color)
	table.insert(LogBuffer, {text, color})
	if LogLabel then
		local out = ""
		for _, entry in ipairs(LogBuffer) do
			out ..= string.format("<font color='rgb(%d,%d,%d)'>%s</font>\n",
				entry[2].R*255, entry[2].G*255, entry[2].B*255, entry[1]
			)
		end
		LogLabel.RichText = true
		LogLabel.Text = out
	end
end

-- PAGE CREATOR
local function createPage(name)
	local Page = Instance.new("Frame", PageHolder)
	Page.Name = name
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.Visible = false
	Page.BackgroundTransparency = 1

	local Scroll = Instance.new("ScrollingFrame", Page)
	Scroll.Size = UDim2.new(1, 0, 1, 0)
	Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Scroll.ScrollBarThickness = 4
	Scroll.BackgroundTransparency = 1

	local Layout = Instance.new("UIListLayout", Scroll)
	Layout.Padding = UDim.new(0, 12)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	Pages[name] = Scroll
	return Scroll
end

-- CARD BUILDER
local function createCard(page, title, desc)
	local Card = Instance.new("Frame", page)
	Card.Size = UDim2.new(1, -12, 0, 120)
	Card.BackgroundColor3 = Theme.Panel
	Card.BorderSizePixel = 0
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

	local Title = Instance.new("TextLabel", Card)
	Title.Text = title
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 16
	Title.TextColor3 = Theme.Accent
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 16, 0, 12)
	Title.Size = UDim2.new(1, -32, 0, 22)
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Desc = Instance.new("TextLabel", Card)
	Desc.Text = desc
	Desc.Font = Enum.Font.Gotham
	Desc.TextSize = 13
	Desc.TextColor3 = Theme.SubText
	Desc.BackgroundTransparency = 1
	Desc.Position = UDim2.new(0, 16, 0, 42)
	Desc.Size = UDim2.new(1, -32, 0, 60)
	Desc.TextWrapped = true
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.TextYAlignment = Enum.TextYAlignment.Top
end

-- TAB SYSTEM (RESTORED v5)
local Tabs = {}
local ActiveTab = nil

local function setActive(name)
	for _, pg in pairs(PageHolder:GetChildren()) do
		pg.Visible = false
	end
	if PageHolder:FindFirstChild(name) then
		PageHolder[name].Visible = true
	end
	pushLog("Open Tab: "..name, Color3.fromRGB(150,200,255))
end

local function createTab(name)
	local Btn = Instance.new("TextButton", TabBar)
	Btn.Text = name
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 14
	Btn.Size = UDim2.new(0, 120, 0, 34)
	Btn.BackgroundColor3 = Theme.Panel
	Btn.TextColor3 = Theme.Text
	Btn.BorderSizePixel = 0
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)

	Btn.MouseButton1Click:Connect(function()
		setActive(name)
	end)

	createPage(name)
end

-- CREATE TABS
createTab("Info")
createTab("Fishing")
createTab("Auto")
createTab("Teleport")
createTab("Misc")
createTab("Webhook")
createTab("Log")

-- INFO CONTENT (REAL QU33N STYLE)
createCard(Pages.Info, "QU33N UI", "Modular Roblox UI inspired by Chloe X.\nLoader → Main → GUI → Tabs.")
createCard(Pages.Info, "Fast Fishing", "Optimized for FishIt & Delta Mobile.\nSupports Blatant V1 / V2.")
createCard(Pages.Info, "Discord Community", "discord.gg/chloex\nTap button in official release.")
createCard(Pages.Info, "System Info", "Enum Safe\nMobile Friendly\nModular Tabs")

-- FILL OTHER TABS SAME (TEMP)
for _, name in ipairs({"Fishing","Auto","Teleport","Misc","Webhook"}) do
	createCard(Pages[name], name.." Module", "Feature placeholder.\nReady for future expansion.")
end

-- LOG TAB CARD
local LogCard = Instance.new("Frame", Pages.Log)
LogCard.Size = UDim2.new(1, -12, 0, 200)
LogCard.BackgroundColor3 = Theme.Panel
LogCard.BorderSizePixel = 0
Instance.new("UICorner", LogCard).CornerRadius = UDim.new(0, 16)

local LogTitle = Instance.new("TextLabel", LogCard)
LogTitle.Text = "Log — BETA v0.7"
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 16
LogTitle.TextColor3 = Theme.Accent
LogTitle.BackgroundTransparency = 1
LogTitle.Position = UDim2.new(0, 16, 0, 12)
LogTitle.Size = UDim2.new(1, -32, 0, 22)
LogTitle.TextXAlignment = Enum.TextXAlignment.Left

LogLabel = Instance.new("TextLabel", LogCard)
LogLabel.Position = UDim2.new(0, 16, 0, 42)
LogLabel.Size = UDim2.new(1, -32, 1, -54)
LogLabel.BackgroundTransparency = 1
LogLabel.TextWrapped = true
LogLabel.TextXAlignment = Enum.TextXAlignment.Left
LogLabel.TextYAlignment = Enum.TextYAlignment.Top
LogLabel.Font = Enum.Font.Code
LogLabel.TextSize = 13
LogLabel.RichText = true
LogLabel.Text = ""

-- INIT LOGS
pushLog("GUI Loaded Successfully", Color3.fromRGB(120,255,120))
pushLog("System Ready", Color3.fromRGB(200,200,255))

-- DEFAULT TAB
setActive("Info")

-- GLOBAL BRIDGE
_G.QU33N = {
	Pages = Pages,
	Theme = Theme
}
