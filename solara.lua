--// QU33N UI — v5 ENGINE RESTORED
--// BETA v0.8 — Rollback True v5 + Log Layer (Solara Safe)

repeat task.wait() until game:IsLoaded()
task.wait(0.3)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local VERSION = "BETA v0.8"

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

-- Clean old GUI
if CoreGui:FindFirstChild("QU33N") then
    CoreGui.QU33N:Destroy()
end

-- Theme (v5)
local Theme = {
    BG = Color3.fromRGB(15,17,21),
    Panel = Color3.fromRGB(26,30,36),
    Text = Color3.fromRGB(235,235,235),
    SubText = Color3.fromRGB(155,160,166),
    Accent = Color3.fromRGB(79,139,255)
}

-- Size (v5 feel)
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

-- Drag (v5 behavior)
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

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
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

-- Buttons container
local btnContainer = Instance.new("Frame", Header)
btnContainer.AnchorPoint = Vector2.new(1,0.5)
btnContainer.Position = UDim2.new(1, -6, 0.5, 0)
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
logo.TextColor3=Color3.fromRGB(0,255,255)
logo.Size = UDim2.new(0,44,0,44)
logo.Position = UDim2.new(0,20,0.5,-22)
logo.BackgroundColor3=Color3.fromRGB(15,15,20)
logo.Visible=false
logo.AnchorPoint = Vector2.new(0,0.5)
Instance.new("UICorner",logo).CornerRadius = UDim.new(1,0)

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

-- === TAB BAR (RESTORED v5 ENGINE) ===
local TabBar = Instance.new("Frame", Main)
TabBar.Position = UDim2.new(0,16,0,58)
TabBar.Size = UDim2.new(1,-32,0,36)
TabBar.BackgroundTransparency = 1

local TabsContainer = Instance.new("Frame", TabBar)
TabsContainer.Size = UDim2.new(1,0,1,0)
TabsContainer.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", TabsContainer)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,3)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- === PAGES ===
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.new(0,16,0,104)
Pages.Size = UDim2.new(1,-32,1,-120)
Pages.BackgroundTransparency = 1
Pages.ClipsDescendants = true

local pageList = {}
local tabButtons = {}

-- === LOG BUFFER ===
local Logs = {}

local function pushLog(text, color)
    table.insert(Logs, {text=text, color=color or Theme.Text})
end

-- === TAB ENGINE (v5 math intact) ===
local function setActive(tabName)
    for name,btn in pairs(tabButtons) do
        btn.TextColor3 = (name == tabName) and Theme.Accent or Theme.SubText
        if pageList[name] then
            pageList[name].Visible = (name == tabName)
        end
    end
    pushLog("Open Tab: "..tabName, Color3.fromRGB(160,200,255))
end

local function createTab(name)
    local b = Instance.new("TextButton")
    b.Parent = TabsContainer
    b.Size = UDim2.new(0,70,1,0) -- ORIGINAL v5 SIZE
    b.BackgroundColor3 = Theme.Panel
    b.Text = name
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.TextColor3 = Theme.SubText
    b.BorderSizePixel = 0
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
    p.ClipsDescendants = true
    pageList[name] = p
end

-- Tabs (v5 + Log)
local tabs = {"Info","Fishing","Auto","Teleport","Misc","Webhook","Log"}
for _,name in ipairs(tabs) do
    createTab(name)
    createPage(name)
end

-- === INFO CONTENT (Original feel restored) ===
local function fillInfo()
    local page = pageList.Info
    page:ClearAllChildren()

    local label = Instance.new("TextLabel", page)
    label.Size = UDim2.new(1,0,0,200)
    label.BackgroundTransparency = 1
    label.TextWrapped = true
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Theme.SubText

    label.Text = [[
QU33N UI — Modular System
Inspired by Chloe X

Fast Fishing Support:
• Blatant V1
• Blatant V2
• FishIt / Delta Mobile optimized

Discord Community:
https://discord.gg/chloex

System:
Enum Safe
Modular Tabs
Mobile Friendly
]]
end

-- === LOG TAB UI ===
local function buildLogTab()
    local page = pageList.Log
    page:ClearAllChildren()

    local Card = Instance.new("Frame", page)
    Card.Size = UDim2.new(1,-6,1,-6)
    Card.Position = UDim2.new(0,3,0,3)
    Card.BackgroundColor3 = Theme.Panel
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)

    local Title = Instance.new("TextLabel", Card)
    Title.Text = "Log Console — "..VERSION
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.TextColor3 = Theme.Accent
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1,-20,0,30)
    Title.Position = UDim2.new(0,12,0,8)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local LogLabel = Instance.new("TextLabel", Card)
    LogLabel.Position = UDim2.new(0,12,0,44)
    LogLabel.Size = UDim2.new(1,-24,1,-56)
    LogLabel.BackgroundTransparency = 1
    LogLabel.TextWrapped = true
    LogLabel.TextYAlignment = Enum.TextYAlignment.Top
    LogLabel.Font = Enum.Font.Code
    LogLabel.TextSize = 13

    local function renderLogs()
        local rich = ""
        for _,log in ipairs(Logs) do
            rich ..= string.format('<font color="rgb(%d,%d,%d)">%s</font>\n',
                log.color.R*255, log.color.G*255, log.color.B*255, log.text)
        end
        LogLabel.RichText = true
        LogLabel.Text = rich
    end

    renderLogs()

    RunService.Heartbeat:Connect(renderLogs)
end

-- Init content
fillInfo()
buildLogTab()

-- Activate default tab (v5 behavior)
RunService.Heartbeat:Wait()
setActive("Info")

pushLog("GUI Loaded Successfully", Color3.fromRGB(120,255,160))

-- === GLOBAL BRIDGE ===
_G.QU33N = {
    Main = Main,
    Tabs = tabButtons,
    Pages = pageList,
    Theme = Theme,
    SelectTab = setActive,
    Version = VERSION
}

notify("QU33N Loaded — "..VERSION)
