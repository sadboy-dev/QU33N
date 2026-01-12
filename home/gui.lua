--// QU33N UI v2 – GUI CORE (ENUM SAFE)
repeat task.wait() until game:IsLoaded()
task.wait(0.5)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

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
local isMobile = UserInputService.TouchEnabled
	and not UserInputService.KeyboardEnabled
	and not UserInputService.MouseEnabled

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
