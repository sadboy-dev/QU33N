--// QU33N UI — TRUE v5 ENGINE LOCKED
--// BETA v1.0 — Text Align Fix + All Tabs Scroll Enabled

repeat task.wait() until game:IsLoaded()
task.wait(0.25)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local VERSION = "BETA v1.4"

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

-- Cleanup
if CoreGui:FindFirstChild("QU33N") then
    CoreGui.QU33N:Destroy()
end

-- Theme v5
local Theme = {
    BG = Color3.fromRGB(15,17,21),
    Panel = Color3.fromRGB(26,30,36),
    Text = Color3.fromRGB(235,235,235),
    SubText = Color3.fromRGB(155,160,166),
    Accent = Color3.fromRGB(79,139,255)
}

-- Responsive size
local function responsiveSize()
    if isMobile then
        return UDim2.new(0.62,0,0.78,0)
    else
        return UDim2.new(0.30,0,0.72,0)
    end
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QU33N"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.new(0.5,0,0.52,0)
Main.Size = responsiveSize()
Main.BackgroundColor3 = Theme.BG
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

-- Drag v5
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
Title.Text = "QU33N  •  "..VERSION
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Theme.Text
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center

-- Buttons
local btnContainer = Instance.new("Frame", Header)
btnContainer.AnchorPoint = Vector2.new(1,0.5)
btnContainer.Position = UDim2.new(1,-6,0.5,0)
btnContainer.Size = UDim2.new(0,80,1,0)
btnContainer.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", btnContainer)
MinBtn.Size = UDim2.new(0,35,0,28)
MinBtn.Position = UDim2.new(0,0,0.15,0)
MinBtn.Text = "_"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Theme.Text
MinBtn.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

local CloseBtn = Instance.new("TextButton", btnContainer)
CloseBtn.Size = UDim2.new(0,35,0,28)
CloseBtn.Position = UDim2.new(0.55,0,0.15,0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Theme.Text
CloseBtn.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)

-- Logo
local logo = Instance.new("TextButton", ScreenGui)
logo.Text="⚡"
logo.Font=Enum.Font.GothamBold
logo.TextSize=22
logo.TextColor3=Color3.fromRGB(0,255,255)
logo.Size = UDim2.new(0,44,0,44)
logo.Position = UDim2.new(0,20,0.5,-22)
logo.BackgroundColor3=Color3.fromRGB(15,15,20)
logo.Visible=false
logo.AnchorPoint = Vector2.new(0,0.5)
Instance.new("UICorner",logo).CornerRadius = UDim.new(1,0)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    logo.Visible = true
end)

logo.MouseButton1Click:Connect(function()
    Main.Visible = true
    logo.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main:Destroy()
end)

-- TAB BAR (horizontal scroll, v5 width)
local TabBar = Instance.new("ScrollingFrame", Main)
TabBar.Position = UDim2.new(0,16,0,58)
TabBar.Size = UDim2.new(1,-32,0,36)
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBar.CanvasSize = UDim2.new(0,0,0,0)
TabBar.ScrollingDirection = Enum.ScrollingDirection.X
TabBar.ScrollBarThickness = 3
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0

local TabsContainer = Instance.new("Frame", TabBar)
TabsContainer.Size = UDim2.new(0,0,1,0)
TabsContainer.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", TabsContainer)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,3)

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabsContainer.Size = UDim2.new(0, TabLayout.AbsoluteContentSize.X, 1, 0)
end)

-- Pages
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.new(0,16,0,104)
Pages.Size = UDim2.new(1,-32,1,-120)
Pages.BackgroundTransparency = 1

local pageList = {}
local tabButtons = {}

-- Log buffer
local Logs = {}
local LogChanged = Instance.new("BindableEvent")


local MAX_LOG = 300
local function pushLog(text, color)
    table.insert(Logs, {
        text = text,
        color = color or Theme.Text
    })
    if #Logs > MAX_LOG then
        table.remove(Logs, 1)
    end
    LogChanged:Fire()
end


-- v5 Tab Engine
local function setActive(tabName)
    for name,btn in pairs(tabButtons) do
        btn.TextColor3 = (name == tabName) and Theme.Accent or Theme.SubText
        pageList[name].Visible = (name == tabName)
    end
    pushLog("Open Tab: "..tabName, Color3.fromRGB(160,200,255))
end

local function createTab(name)
    local b = Instance.new("TextButton")
    b.Parent = TabsContainer
    b.Size = UDim2.new(0,70,1,0) -- v5 locked
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

-- Scroll Page Factory
local function createScrollPage(name)
    local scroll = Instance.new("ScrollingFrame", Pages)
    scroll.Size = UDim2.new(1,0,1,0)
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollBarThickness = 4
    scroll.BackgroundTransparency = 1
    scroll.Visible = false
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y

    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingLeft = UDim.new(0,4)
    padding.PaddingRight = UDim.new(0,4)

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0,14)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    pageList[name] = scroll
end

-- Tabs list
local tabs = {"Info","Fishing","Auto","Teleport","Misc","Webhook","Log"}
for _,name in ipairs(tabs) do
    createTab(name)
    createScrollPage(name)
end

-- Card Builder
local function createCard(parent,title,desc)
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(1,-6,0,130)
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
    Title.TextYAlignment = Enum.TextYAlignment.Center

    local Desc = Instance.new("TextLabel", Card)
    Desc.Text = desc
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 13
    Desc.TextColor3 = Theme.SubText
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0,16,0,44)
    Desc.Size = UDim2.new(1,-32,0,60)
    Desc.TextWrapped = true
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextYAlignment = Enum.TextYAlignment.Top
end

-- Fill ALL tabs like Info (temp)
for name,page in pairs(pageList) do
    if name ~= "Log" then
        createCard(page,"QU33N UI","Temporary content placeholder for "..name.." tab.")
        createCard(page,"Fast Fishing","Feature system will be added later.")
        createCard(page,"System","Tab active & scroll working.")
    end
end

-- LOG TAB UI (PAGE SCROLL, STABLE)
do
    local page = pageList.Log   -- ScrollingFrame (IMPORTANT)

    local Card = Instance.new("Frame", page)
    Card.Size = UDim2.new(1,-6,0,120)
    Card.BackgroundColor3 = Theme.Panel
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)

    local Title = Instance.new("TextLabel", Card)
    Title.Text = "Log Console — "..VERSION
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.TextColor3 = Theme.Accent
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0,12,0,8)
    Title.Size = UDim2.new(1,-24,0,28)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center

    local Content = Instance.new("Frame", Card)
    Content.Position = UDim2.new(0,12,0,42)
    Content.Size = UDim2.new(1,-24,0,0)
    Content.BackgroundTransparency = 1
    Content.AutomaticSize = Enum.AutomaticSize.Y

    local Layout = Instance.new("UIListLayout", Content)
    Layout.Padding = UDim.new(0,2)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

    -- BUILD LOG UI
    local function rebuild()
        Content:ClearAllChildren()
        Layout.Parent = Content

        for _,log in ipairs(Logs) do
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1,0,0,16)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.TextWrapped = true
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Top
            lbl.Font = Enum.Font.Code
            lbl.TextSize = 13
            lbl.TextColor3 = log.color
            lbl.Text = log.text
            lbl.Parent = Content
        end
    end

    -- AUTO RESIZE + AUTO SCROLL
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Card.Size = UDim2.new(
            1,-6,
            0,
            Layout.AbsoluteContentSize.Y + 60
        )

        task.wait()
        page.CanvasPosition = Vector2.new(
            0,
            math.max(0, page.CanvasSize.Y.Offset - page.AbsoluteWindowSize.Y)
        )
    end)

    -- LISTEN LOG CHANGE
    LogChanged.Event:Connect(rebuild)

    -- FIRST BUILD
    rebuild()
end


-- Init
setActive("Info")
pushLog("GUI Loaded Successfully", Color3.fromRGB(120,255,160))
notify("QU33N Loaded — "..VERSION)

-- Bridge
_G.QU33N = {
    Main = Main,
    Tabs = tabButtons,
    Pages = pageList,
    Theme = Theme,
    SelectTab = setActive,
    Version = VERSION
}
