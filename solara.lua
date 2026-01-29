--// QU33N UI — v5 ENGINE HARD LOCK
--// BETA v1.2 — Log Visible + Auto Card Height + Scroll Stable

repeat task.wait() until game:IsLoaded()
task.wait(0.2)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local VERSION = "BETA v1.2"

-- Destroy old
if CoreGui:FindFirstChild("QU33N") then
    CoreGui.QU33N:Destroy()
end

-- Theme (LOCKED v5)
local Theme = {
    BG = Color3.fromRGB(15,17,21),
    Panel = Color3.fromRGB(26,30,36),
    Text = Color3.fromRGB(235,235,235),
    SubText = Color3.fromRGB(155,160,166),
    Accent = Color3.fromRGB(79,139,255)
}

-- Size LOCKED
local GUI_SIZE_PC = UDim2.new(0.30,0,0.72,0)
local GUI_SIZE_MOBILE = UDim2.new(0.62,0,0.78,0)

local function getSize()
    return isMobile and GUI_SIZE_MOBILE or GUI_SIZE_PC
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QU33N"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame", ScreenGui)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.new(0.5,0,0.52,0)
Main.Size = getSize()
Main.BackgroundColor3 = Theme.BG
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

-- Drag (LOCKED v5)
do
    local dragging, dragStart, startPos

    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function()
        dragging = false
    end)
end

-- Header
local Header = Instance.new("Frame", Main)
Header.Position = UDim2.new(0,16,0,6)
Header.Size = UDim2.new(1,-32,0,50)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Text = "QU33N • "..VERSION
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Theme.Text
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons
local BtnWrap = Instance.new("Frame", Header)
BtnWrap.AnchorPoint = Vector2.new(1,0.5)
BtnWrap.Position = UDim2.new(1,-6,0.5,0)
BtnWrap.Size = UDim2.new(0,80,1,0)
BtnWrap.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", BtnWrap)
MinBtn.Size = UDim2.new(0,35,0,28)
MinBtn.Text = "_"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Theme.Text
MinBtn.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

local CloseBtn = Instance.new("TextButton", BtnWrap)
CloseBtn.Size = UDim2.new(0,35,0,28)
CloseBtn.Position = UDim2.new(0.55,0,0.15,0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Theme.Text
CloseBtn.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)

local Bubble = Instance.new("TextButton", ScreenGui)
Bubble.Text = "⚡"
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 22
Bubble.TextColor3 = Color3.fromRGB(0,255,255)
Bubble.Size = UDim2.new(0,44,0,44)
Bubble.Position = UDim2.new(0,20,0.5,-22)
Bubble.BackgroundColor3 = Color3.fromRGB(15,15,20)
Bubble.Visible = false
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1,0)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Bubble.Visible = true
end)

Bubble.MouseButton1Click:Connect(function()
    Main.Visible = true
    Bubble.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main:Destroy()
end)

-- TAB BAR (HORIZONTAL SCROLL LOCKED)
local TabBar = Instance.new("ScrollingFrame", Main)
TabBar.Position = UDim2.new(0,16,0,58)
TabBar.Size = UDim2.new(1,-32,0,36)
TabBar.ScrollingDirection = Enum.ScrollingDirection.X
TabBar.ScrollBarThickness = 3
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0

local TabsHolder = Instance.new("Frame", TabBar)
TabsHolder.BackgroundTransparency = 1
TabsHolder.Size = UDim2.new(0,0,1,0)

local TabLayout = Instance.new("UIListLayout", TabsHolder)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,3)

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabsHolder.Size = UDim2.new(0, TabLayout.AbsoluteContentSize.X, 1, 0)
    TabBar.CanvasSize = UDim2.new(0, TabsHolder.Size.X.Offset, 0, 0)
end)

-- Pages
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.new(0,16,0,104)
Pages.Size = UDim2.new(1,-32,1,-120)
Pages.BackgroundTransparency = 1

local tabButtons = {}
local pageList = {}

-- LOG STORAGE
local Logs = {}

local function pushLog(typeLabel, text, color)
    table.insert(Logs, {
        text = typeLabel..": "..text,
        color = color or Theme.Text
    })
end

-- TAB ENGINE v5
local function setActive(name)
    for tab,btn in pairs(tabButtons) do
        btn.TextColor3 = (tab == name) and Theme.Accent or Theme.SubText
        pageList[tab].Visible = (tab == name)
    end
    pushLog("INFO", "Open "..name, Color3.fromRGB(150,200,255))
end

local function createTab(name)
    local b = Instance.new("TextButton")
    b.Parent = TabsHolder
    b.Size = UDim2.new(0,70,1,0)
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

-- SCROLL PAGE FACTORY (VERTICAL)
local function createScrollPage(name)
    local scroll = Instance.new("ScrollingFrame", Pages)
    scroll.Size = UDim2.new(1,0,1,0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollBarThickness = 4
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.BackgroundTransparency = 1
    scroll.Visible = false

    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingTop = UDim.new(0,8)
    pad.PaddingLeft = UDim.new(0,4)
    pad.PaddingRight = UDim.new(0,4)

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0,14)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    pageList[name] = scroll
end

-- Create Tabs
local tabNames = {"Info","Fishing","Auto","Teleport","Misc","Webhook","Log"}
for _,name in ipairs(tabNames) do
    createTab(name)
    createScrollPage(name)
end

-- CARD BUILDER (AUTO HEIGHT)
local function createCard(parent,title,desc)
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(1,-6,0,10)
    Card.BackgroundColor3 = Theme.Panel
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)

    local Title = Instance.new("TextLabel", Card)
    Title.Text = title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Theme.Accent
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0,16,0,14)
    Title.Size = UDim2.new(1,-32,0,22)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Desc = Instance.new("TextLabel", Card)
    Desc.Text = desc
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 13
    Desc.TextColor3 = Theme.SubText
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0,16,0,44)
    Desc.Size = UDim2.new(1,-32,0,0)
    Desc.TextWrapped = true
    Desc.TextYAlignment = Enum.TextYAlignment.Top
    Desc.AutomaticSize = Enum.AutomaticSize.Y

    RunService.Heartbeat:Wait()
    Card.Size = UDim2.new(1,-6,0, Desc.AbsoluteSize.Y + 70)
end

-- Fill Tabs Content (TEMP SAME)
for name,page in pairs(pageList) do
    if name ~= "Log" then
        createCard(page,"QU33N UI","Temporary content for "..name.." tab.")
        createCard(page,"System","Scroll works. Layout locked.")
        createCard(page,"Ready","Features will be injected.")
    end
end

-- LOG TAB UI (SCROLLABLE)
do
    LogLabel = createCard(
			"System Log",
			VERSION .. "\n\nWaiting for script activity...",
			nil
		)
		pushLog("Log Initialized")
		pushLog("Loaded: " .. VERSION)

	else
		createCard(name .. " Tab","Temporary content\nWaiting for features...",nil)
	end
end

-- INIT
setActive("Info")
pushLog("INFO","GUI Loaded Successfully", Color3.fromRGB(120,255,160))

_G.QU33N = {
    Main = Main,
    Tabs = tabButtons,
    Pages = pageList,
    Theme = Theme,
    SelectTab = setActive,
    Version = VERSION
}
