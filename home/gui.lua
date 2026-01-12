--// QU33N GUI Final – Logo ⚡
repeat task.wait() until game:IsLoaded()
task.wait(0.5)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

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

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "QU33N"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0.3,0,0.7,0)
main.Position = UDim2.new(0.35,0,0.15,0)
main.BackgroundColor3 = Theme.BG
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

-- TitleBar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundTransparency = 1

local titleText = Instance.new("TextLabel", titleBar)
titleText.Text = "QU33N"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextColor3 = Theme.Text
titleText.BackgroundTransparency = 1
titleText.Size = UDim2.new(1,0,1,0)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextYAlignment = Enum.TextYAlignment.Center
titleText.Position = UDim2.new(0,10,0,0)

-- Minimize Button
local minimize = Instance.new("TextButton", titleBar)
minimize.Text="—"
minimize.Font=Enum.Font.GothamBold
minimize.TextSize=18
minimize.TextColor3=Color3.fromRGB(0,255,255)
minimize.Size = UDim2.new(0,26,0,26)
minimize.Position = UDim2.new(1,-60,0.5,-13)
minimize.BackgroundTransparency=1

-- Close Button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Theme.Text
closeBtn.Size = UDim2.new(0,26,0,26)
closeBtn.Position = UDim2.new(1,-28,0.5,-13)
closeBtn.BackgroundTransparency = 0
closeBtn.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", closeBtn).CornerRadius=UDim.new(0,6)

-- Holder for content
local holder = Instance.new("Frame", main)
holder.Position = UDim2.new(0,0,0,36)
holder.Size = UDim2.new(1,0,1,-36)
holder.BackgroundTransparency = 1

-- LOGO ⚡
local logo = Instance.new("TextButton", gui)
logo.Text="⚡"
logo.Font=Enum.Font.GothamBold
logo.TextSize=22
logo.TextColor3=Color3.fromRGB(0,255,255)
logo.Size = UDim2.new(0,44,0,44)
logo.Position = UDim2.new(0,20,0.5,-22)
logo.BackgroundColor3=Color3.fromRGB(15,15,20)
logo.Visible=false
Instance.new("UICorner",logo).CornerRadius=UDim.new(1,0)

-- Dragging function for logo
local function enableDrag(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
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
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

enableDrag(logo)

logo.MouseButton1Click:Connect(function()
    main.Visible = true
    logo.Visible = false
end)

-- Minimize behavior
minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    logo.Visible = true
end)

-- Close behavior
closeBtn.MouseButton1Click:Connect(function()
    local confirm = Instance.new("Frame", main)
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
    text.Position = UDim2.new(0,0,0,10)

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
        main:Destroy()
        notify("System reset ke default")
    end)
    no.MouseButton1Click:Connect(function()
        confirm:Destroy()
    end)
end)

-- === GLOBAL GUI BRIDGE ===
_G.QU33N = {
    Main = main,
    GUI = gui,
    Logo = logo
}

notify("QU33N GUI Loaded – Logo ⚡")
