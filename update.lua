--// Net Remote Tester - DELTA MOBILE STABLE
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

--========================
-- SAFE WAIT FUNCTION
--========================
local function safeWait(parent, childName, timeout)
    local start = tick()
    while not parent:FindFirstChild(childName) do
        if tick() - start > (timeout or 5) then
            warn("[SAFEWAIT] "..childName.." not found in "..parent:GetFullName())
            return nil
        end
        task.wait(0.1)
    end
    return parent[childName]
end

--========================
-- NET PATH (SAFE)
--========================
local IndexFolder = safeWait(ReplicatedStorage, "_Index")
if not IndexFolder then
    warn("_Index folder not found! Exiting script.")
    return
end

local NetPackage = safeWait(IndexFolder, "sleitnick_net@0.2.0")
if not NetPackage then
    warn("sleitnick_net@0.2.0 package not found! Exiting script.")
    return
end

local NetFolder = safeWait(NetPackage, "net")
if not NetFolder then
    warn("net folder not found! Exiting script.")
    return
end

--========================
-- LOGGING SETUP
--========================
local FOLDER = "DeltaLogs"
local FILE = FOLDER .. "/BaitCastLog.txt"

if makefolder and not isfolder(FOLDER) then
    makefolder(FOLDER)
end
if writefile and not isfile(FILE) then
    writefile(FILE, "=== BAIT CAST LOG ===\n")
end

local function save(txt)
    if appendfile then
        appendfile(FILE, txt .. "\n")
    end
end

--========================
-- GUI SETUP
--========================
local gui = Instance.new("ScreenGui")
gui.Name = "NetRemoteTester"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 200)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = main

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,32)
header.BackgroundColor3 = Color3.fromRGB(45,45,45)
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-70,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "Net Remote Tester"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,26,0,26)
minBtn.Position = UDim2.new(1,-58,0,3)
minBtn.Text = "_"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
minBtn.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,26,0,26)
closeBtn.Position = UDim2.new(1,-30,0,3)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(170,60,60)
closeBtn.Parent = header

-- CONTENT
local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-32)
content.Position = UDim2.new(0,0,0,32)
content.BackgroundTransparency = 1
content.Parent = main

-- INPUT
local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-20,0,36)
input.Position = UDim2.new(0,10,0,10)
input.PlaceholderText = "RE/EquipToolFromHotbar | 1"
input.ClearTextOnFocus = false
input.Font = Enum.Font.SourceSans
input.TextSize = 14
input.TextColor3 = Color3.new(1,1,1)
input.BackgroundColor3 = Color3.fromRGB(50,50,50)
input.Parent = content

-- EXECUTE BUTTON
local exec = Instance.new("TextButton")
exec.Size = UDim2.new(1,-20,0,32)
exec.Position = UDim2.new(0,10,0,55)
exec.Text = "EXECUTE"
exec.Font = Enum.Font.SourceSansBold
exec.TextSize = 14
exec.TextColor3 = Color3.new(1,1,1)
exec.BackgroundColor3 = Color3.fromRGB(70,140,90)
exec.Parent = content

-- LOG FRAME
local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1,-20,0,60)
logFrame.Position = UDim2.new(0,10,0,95)
logFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
logFrame.CanvasSize = UDim2.new(0,0,0,0)
logFrame.ScrollBarThickness = 6
logFrame.Parent = content

local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1,0,0,0)
logLabel.Position = UDim2.new(0,0,0,0)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = Color3.fromRGB(0,255,0)
logLabel.Font = Enum.Font.Code
logLabel.TextSize = 12
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.TextWrapped = true
logLabel.Text = "[SYSTEM] Ready\n"
logLabel.Parent = logFrame

local function addLog(text)
    logLabel.Text ..= text .. "\n"
    logLabel.Size = UDim2.new(1,0,0,logLabel.TextBounds.Y)
    logFrame.CanvasSize = UDim2.new(0,0,0,logLabel.TextBounds.Y)
    logFrame.CanvasPosition = Vector2.new(0,logLabel.TextBounds.Y)
    save(text)
end

--========================
-- DRAG SUPPORT
--========================
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = main.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
	or i.UserInputType == Enum.UserInputType.Touch) then
		local delta = i.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- MINIMIZE / CLOSE BUTTONS
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	content.Visible = not minimized
	main.Size = minimized
		and UDim2.new(0,260,0,32)
		or UDim2.new(0,260,0,200)
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--========================
-- REMOTE SCAN & LISTENER
--========================
addLog("Scanning RemoteEvents (partial match)...")
local foundAny = false

for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
	if r:IsA("RemoteEvent") then
		local lname = r.Name:lower()
		local full = r:GetFullName():lower()

		if lname:find("bait") or lname:find("cast") or full:find("baitcast") then
			foundAny = true
			addLog("FOUND REMOTE: "..r:GetFullName())

			r.OnClientEvent:Connect(function(...)
				local args = {...}
				if args[1] == Player then
					addLog("REMOTE FIRED by LocalPlayer -> "..r.Name)
				else
					addLog("REMOTE FIRED -> "..r.Name)
				end
			end)
		end
	end
end

if not foundAny then
	addLog("NO BAIT/CAST RELATED REMOTE FOUND")
else
	addLog("Waiting for cast...")
end

--========================
-- EXECUTE BUTTON LOGIC
--========================
exec.MouseButton1Click:Connect(function()
	local raw = input.Text
	if raw == "" then
		addLog("[ERROR] Input kosong")
		return
	end

	local path, arg = raw:match("([^|]+)|?(.*)")
	path = path and path:match("^%s*(.-)%s*$")
	arg = arg and arg:match("^%s*(.-)%s*$")

	-- RESOLVE NESTED PATH
	local current = NetFolder
	for part in string.gmatch(path, "[^/]+") do
		current = current:FindFirstChild(part)
		if not current then
			addLog("[ERROR] Path tidak valid: "..path)
			return
		end
	end

	local finalArg
	if arg ~= "" then
		finalArg = tonumber(arg) or arg
	end

	if current:IsA("RemoteEvent") then
		current:FireServer(finalArg)
		addLog("[SEND] FireServer -> "..path.." ("..tostring(finalArg)..")")
	elseif current:IsA("RemoteFunction") then
		local res = current:InvokeServer(finalArg)
		addLog("[RECV] "..tostring(res))
	else
		addLog("[ERROR] Target bukan RemoteEvent / RemoteFunction")
	end
end)
