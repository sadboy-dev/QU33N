--// QU33N UI v5 – GUI CORE (Enum Safe + Logo ⚡)
repeat task.wait() until game:IsLoaded()
task.wait(0.5)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

-- Device detect
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

-- Clean old GUI
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

-- Responsive size
local function responsiveSize()
    if isMobile then
        return UDim2.new(0.62,0,0.82,0)
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

-- Main frame
local Main = Instance.new("Frame", ScreenGui)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.new(0.5,0,0.52,0)
Main.Size = responsiveSize()
Main.BackgroundColor3 = Theme.BG
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

-- Drag (touch)
do
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.Touch then
            local delta = i.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
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
Title.Text = "QU33N"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Theme.Text
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center

-- ==== BUTTONS ====
local btnContainer = Instance.new("Frame", Header)
btnContainer.AnchorPoint = Vector2.new(1,0.5)
btnContainer.Position = UDim2.new(1, -6, 0.5, 0)
btnContainer.Size = UDim2.new(0,80,1,0)
btnContainer.BackgroundTransparency = 1

-- Close Button
local CloseBtn = Instance.new("TextButton", btnContainer)
CloseBtn.Size = UDim2.new(0,35,0,28)
CloseBtn.Position = UDim2.new(0.55,0,0.15,0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Theme.Text
CloseBtn.BackgroundColor3 = Theme.Panel
CloseBtn.AutoButtonColor = true
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)

-- Minimize Button
local MinBtn = Instance.new("TextButton", btnContainer)
MinBtn.Size = UDim2.new(0,35,0,28)
MinBtn.Position = UDim2.new(0,0,0.15,0)
MinBtn.Text = "_"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Theme.Text
MinBtn.BackgroundColor3 = Theme.Panel
MinBtn.AutoButtonColor = true
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

-- Logo kecil ⚡
local function createMiniLogo()
    local logo = Instance.new("TextButton", CoreGui)
    logo.Name = "MiniLogo"
    logo.Text = "⚡"
    logo.Font = Enum.Font.GothamBold
    logo.TextSize = 22
    logo.TextColor3 = Color3.fromRGB(0,255,255)
    logo.Size = UDim2.new(0,44,0,44)
    logo.Position = UDim2.new(0,20,0.5,-22)
    logo.BackgroundColor3 = Color3.fromRGB(15,15,20)
    logo.Visible = true
    logo.ZIndex = 100
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1,0)

    -- Dragging
    local dragging, dragStart, startPos
    logo.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = logo.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            logo.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Klik logo untuk restore GUI
    logo.MouseButton1Click:Connect(function()
        Main.Visible = true
        logo:Destroy()
    end)
end

-- resetSystem()
local function resetSystem()
    -- isi dengan behavior revert default di game kamu
    notify("System reset ke default")
end

-- CloseBtn event
CloseBtn.MouseButton1Click:Connect(function()
    local confirm = Instance.new("Frame", Main)
    confirm.Size = UDim2.new(0,220,0,120)
    confirm.Position = UDim2.new(0.5,-110,0.5,-60)
    confirm.BackgroundColor3 = Theme.Panel
    Instance.new("UICorner", confirm).CornerRadius = UDim.new(0,10)

    local text = Instance.new("TextLabel", confirm)
    text.Text = "Yakin ingin keluar dan reset?"
    text.Font = Enum.Font.Gotham
    text.TextSize = 14
    text.TextColor3 = Theme.Text
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1,0,0.6,0)

    local yes = Instance.new("TextButton", confirm)
    yes.Text = "Iya"
    yes.Size = UDim2.new(0.4,0,0.25,0)
    yes.Position = UDim2.new(0.05,0,0.65,0)
    yes.BackgroundColor3 = Theme.Accent
    yes.TextColor3 = Theme.Text
    Instance.new("UICorner", yes).CornerRadius = UDim.new(0,6)

    local no = Instance.new("TextButton", confirm)
    no.Text = "Tidak"
    no.Size = UDim2.new(0.4,0,0.25,0)
    no.Position = UDim2.new(0.55,0,0.65,0)
    no.BackgroundColor3 = Theme.Panel
    no.TextColor3 = Theme.Text
    Instance.new("UICorner", no).CornerRadius = UDim.new(0,6)

    yes.MouseButton1Click:Connect(function()
        confirm:Destroy()
        resetSystem()
        Main:Destroy()
    end)
    no.MouseButton1Click:Connect(function()
        confirm:Destroy()
    end)
end)

-- MinBtn event
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    createMiniLogo()
end)

-- Tabs bar
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

-- Pages container
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.new(0,16,0,104)
Pages.Size = UDim2.new(1,-32,1,-120)
Pages.BackgroundTransparency = 1
Pages.ClipsDescendants = true

-- Storage
local pageList = {}
local tabButtons = {}

-- Tab switch
local function setActive(tabName)
    for name,btn in pairs(tabButtons) do
        btn.TextColor3 = (name == tabName) and Theme.Accent or Theme.SubText
        if pageList[name] then
            pageList[name].Visible = (name == tabName)
        end
    end
end

-- Create tab
local function createTab(name)
    local b = Instance.new("TextButton")
    b.Parent = TabsContainer
    b.Size = UDim2.new(0,70,1,0)
    b.BackgroundColor3 = Theme.Panel
    b.Text = name
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.TextColor3 = Theme.SubText
    b.BorderSizePixel = 0
    b.AutoButtonColor = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
    b.MouseButton1Click:Connect(function()
        setActive(name)
    end)
    tabButtons[name] = b
end

-- Create page
local function createPage(name)
    local p = Instance.new("Frame", Pages)
    p.Size = UDim2.new(1,0,1,0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ClipsDescendants = true
    pageList[name] = p
end

-- Tabs list
local tabs = {"Info","Fishing","Auto","Teleport","Misc","Webhook"}
for _,name in ipairs(tabs) do
    createTab(name)
    createPage(name)
end
RunService.Heartbeat:Wait()
setActive("Info")

-- === GLOBAL GUI BRIDGE ===
_G.QU33N = {
    Main = Main,
    Tabs = tabButtons,
    Pages = pageList,
    Theme = Theme,
    SelectTab = setActive
}

notify("QU33N GUI Loaded (Enum Safe)")
