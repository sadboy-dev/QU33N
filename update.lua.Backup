--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

--// STATE
local RemoteMap = {}
local LastRemoteName = nil

--// GUI ROOT
local gui = Instance.new("ScreenGui")
gui.Name = "NetRemoteTester"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

--// MAIN FRAME (HP FRIENDLY)
local main = Instance.new("Frame", gui)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.Position = UDim2.fromScale(0.5,0.5)
main.Size = UDim2.fromScale(0.66,0.68)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

--// TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,-50,0,42)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "Net Remote Tester"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(235,235,235)
title.TextXAlignment = Enum.TextXAlignment.Left

--// CLOSE BUTTON
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,32,0,32)
close.Position = UDim2.new(1,-38,0,5)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255,255,255)
close.BackgroundColor3 = Color3.fromRGB(160,60,60)
Instance.new("UICorner", close).CornerRadius = UDim.new(0,8)
close.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

--// BODY
local body = Instance.new("Frame", main)
body.Position = UDim2.new(0,10,0,48)
body.Size = UDim2.new(1,-20,1,-58)
body.BackgroundTransparency = 1

--// LEFT PANEL
local left = Instance.new("Frame", body)
left.Size = UDim2.new(0.5,-5,1,0)
left.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", left).CornerRadius = UDim.new(0,10)

--// RIGHT PANEL
local right = Instance.new("Frame", body)
right.Position = UDim2.new(0.5,5,0,0)
right.Size = UDim2.new(0.5,-5,1,0)
right.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", right).CornerRadius = UDim.new(0,10)

--// INPUT
local input = Instance.new("TextBox", left)
input.PlaceholderText = "RemoteName | arg1 | arg2"
input.Size = UDim2.new(1,-20,0,40)
input.Position = UDim2.new(0,10,0,10)
input.BackgroundColor3 = Color3.fromRGB(40,40,40)
input.TextColor3 = Color3.fromRGB(235,235,235)
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.TextXAlignment = Enum.TextXAlignment.Left
input.ClearTextOnFocus = false
Instance.new("UICorner", input).CornerRadius = UDim.new(0,8)

--// EXECUTE BUTTON
local exec = Instance.new("TextButton", left)
exec.Size = UDim2.new(1,-20,0,42)
exec.Position = UDim2.new(0,10,0,60)
exec.Text = "EXECUTE"
exec.Font = Enum.Font.GothamBold
exec.TextSize = 14
exec.TextColor3 = Color3.fromRGB(255,255,255)
exec.BackgroundColor3 = Color3.fromRGB(70,150,90)
Instance.new("UICorner", exec).CornerRadius = UDim.new(0,8)

--// LOG FRAME
local logFrame = Instance.new("ScrollingFrame", left)
logFrame.Position = UDim2.new(0,10,0,110)
logFrame.Size = UDim2.new(1,-20,1,-120)
logFrame.ScrollBarThickness = 4
logFrame.CanvasSize = UDim2.new(0,0,0,0)
logFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner", logFrame).CornerRadius = UDim.new(0,8)

local logLabel = Instance.new("TextLabel", logFrame)
logLabel.Position = UDim2.new(0,5,0,5)
logLabel.Size = UDim2.new(1,-10,0,0)
logLabel.TextWrapped = true
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.Font = Enum.Font.Code
logLabel.TextSize = 13
logLabel.TextColor3 = Color3.fromRGB(0,255,0)
logLabel.BackgroundTransparency = 1
logLabel.Text = "[SYSTEM] Ready"

--// LOG FUNCTION (AUTO SCROLL)
local function logPrint(msg)
	logLabel.Text = logLabel.Text .. "\n" .. msg
	logLabel.Size = UDim2.new(1,-10,0,logLabel.TextBounds.Y + 8)
	logFrame.CanvasSize = UDim2.new(0,0,0,logLabel.AbsoluteSize.Y + 10)
	logFrame.CanvasPosition = Vector2.new(
		0,
		math.max(0,logFrame.CanvasSize.Y.Offset - logFrame.AbsoluteWindowSize.Y)
	)
end

--// REMOTE LIST
local list = Instance.new("ScrollingFrame", right)
list.Size = UDim2.new(1,-10,1,-10)
list.Position = UDim2.new(0,5,0,5)
list.ScrollBarThickness = 4
list.BackgroundTransparency = 1
list.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,6)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

--// ADD REMOTE BUTTON
local function addRemote(remote)
	RemoteMap[remote.Name] = remote

	local btn = Instance.new("TextButton", list)
	btn.Size = UDim2.new(1,0,0,36)
	btn.Text = remote.Name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.TextColor3 = Color3.fromRGB(230,230,230)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

	btn.MouseButton1Click:Connect(function()
		if LastRemoteName ~= remote.Name then
			input.Text = remote.Name
			LastRemoteName = remote.Name
		end
		logPrint("[SELECTED] RE/"..remote.Name)
	end)
end

--// LOAD REMOTES
for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
	if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
		addRemote(v)
	end
end
logPrint("[SYSTEM] Remotes loaded")

--// EXECUTE LOGIC
exec.MouseButton1Click:Connect(function()
	if input.Text == "" then
		logPrint("[ERROR] Input kosong")
		return
	end

	local parts = {}
	for p in string.gmatch(input.Text,"[^|]+") do
		p = p:gsub("^%s+",""):gsub("%s+$","")
		table.insert(parts,p)
	end

	local name = parts[1]
	local remote = RemoteMap[name]
	if not remote then
		logPrint("[ERROR] Remote not found: "..name)
		return
	end

	local args = {}
	for i=2,#parts do
		local v = parts[i]
		if v=="true" then v=true
		elseif v=="false" then v=false
		else
			local n = tonumber(v)
			if n~=nil then v=n end
		end
		table.insert(args,v)
	end

	local prefix = remote:IsA("RemoteEvent") and "[Fire]" or "[Invoke]"
	logPrint(prefix..": RE/"..name)

	if #args > 0 then
		for i,v in ipairs(args) do
			logPrint("[args"..i.."]: "..tostring(v))
		end
	end

	logPrint("-----------------------------------")

	if remote:IsA("RemoteEvent") then
		remote:FireServer(unpack(args))
	else
		local res = remote:InvokeServer(unpack(args))
		logPrint("[return]: "..tostring(res))
		logPrint("-----------------------------------")
	end
end)

--// DRAG SUPPORT (MOBILE + PC)
do
	local dragging, startPos, startInput
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startInput = i.Position
			startPos = main.Position
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
		or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - startInput
			main.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)

	UIS.InputEnded:Connect(function()
		dragging = false
	end)
end
