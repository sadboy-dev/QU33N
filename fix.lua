--------------------------------------------------
-- REMOTE LOGGER FINAL (PARAM AWARE + DROP PAUSE)
--------------------------------------------------

if _G.__REMOTE_LOGGER_RUNNING then return end
_G.__REMOTE_LOGGER_RUNNING = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

--------------------------------------------------
-- STATE
--------------------------------------------------
local paused = false
local MAX_LOGS = 250

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,460,0,240)
frame.Position = UDim2.new(0.5,-230,0.5,-120)
frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

-- Header
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)
header.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "REMOTE LOGGER"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 13
title.TextColor3 = Color3.new(1,1,1)

-- Buttons
local function makeBtn(text, x, cb)
    local b = Instance.new("TextButton", header)
    b.Size = UDim2.new(0,70,0,20)
    b.Position = UDim2.new(0,x,0,5)
    b.Text = text
    b.Font = Enum.Font.SourceSans
    b.TextSize = 11
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(cb)
end

makeBtn("Pause",5,function() paused = true end)
makeBtn("Resume",80,function() paused = false end)

makeBtn("CopyAll",155,function()
    local text = {}
    for _,lbl in ipairs(frame.LogList:GetChildren()) do
        if lbl:IsA("TextLabel") then
            table.insert(text, lbl.Text)
        end
    end
    pcall(function() setclipboard(table.concat(text,"\n")) end)
end)

makeBtn("Clear",240,function()
    for _,c in ipairs(frame.LogList:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    frame.LogList.CanvasPosition = Vector2.zero
end)

--------------------------------------------------
-- LOG VIEW
--------------------------------------------------
local logFrame = Instance.new("ScrollingFrame", frame)
logFrame.Name = "LogList"
logFrame.Position = UDim2.new(0,6,0,34)
logFrame.Size = UDim2.new(1,-12,1,-40)
logFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
logFrame.BorderSizePixel = 0
logFrame.ScrollBarThickness = 6
logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", logFrame)
layout.Padding = UDim.new(0,4)

--------------------------------------------------
-- SAFE STRINGIFY (PARAM AWARE)
--------------------------------------------------
local function safe(v, depth)
    depth = depth or 0
    if depth > 2 then return "..." end

    local t = typeof(v)

    if t == "Instance" then
        return v.ClassName .. ":" .. v.Name

    elseif t == "table" then
        local out = {}
        local n = 0
        for k,val in pairs(v) do
            n += 1
            if n > 8 then
                table.insert(out, "...")
                break
            end
            table.insert(out, tostring(k).."="..safe(val, depth+1))
        end
        return "{"..table.concat(out,", ").."}"

    elseif t == "Vector3" or t == "CFrame" then
        return t

    else
        return tostring(v)
    end
end

local function hasLocal(args)
    for _,v in ipairs(args) do
        if v == LocalPlayer or v == LocalPlayer.UserId then
            return true
        end
    end
    return false
end

--------------------------------------------------
-- ADD LOG
--------------------------------------------------
local function addLine(text, color)
    if paused then return end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-8,0,0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 11
    lbl.TextColor3 = color
    lbl.Text = text
    lbl.Parent = logFrame

    task.wait()

    local visible = logFrame.AbsoluteSize.Y
    local canvas = logFrame.AbsoluteCanvasSize.Y
    if canvas > visible then
        logFrame.CanvasPosition = Vector2.new(0, canvas - visible)
    end

    if #logFrame:GetChildren() > MAX_LOGS then
        for _,c in ipairs(logFrame:GetChildren()) do
            if c:IsA("TextLabel") then
                c:Destroy()
                break
            end
        end
    end
end

--------------------------------------------------
-- HANDLE LOG (DROP MODE)
--------------------------------------------------
local function handleLog(tag, remote, args)
    if paused then return end
    if tag ~= "[Receive]" and not hasLocal(args) then return end

    local out = {}
    for _,v in ipairs(args) do
        if typeof(v) == "table" then
            table.insert(out, "[PARAMS]"..safe(v))
        else
            table.insert(out, safe(v))
        end
    end

    local line = string.format(
        "%s %s | %s",
        tag,
        safe(remote),
        table.concat(out, " | ")
    )

    print(line)

    local color = Color3.new(1,1,1)
    if tag == "[FireServer]" then color = Color3.fromRGB(255,220,0)
    elseif tag == "[InvokeServer]" then color = Color3.fromRGB(0,220,255)
    elseif tag == "[Receive]" then color = Color3.fromRGB(0,255,120) end

    addLine(line, color)
end

--------------------------------------------------
-- HOOKS
--------------------------------------------------
local function hookRemote(r)
    if r:IsA("RemoteEvent") and r.FireServer then
        local old
        old = hookfunction(r.FireServer, function(self,...)
            handleLog("[FireServer]", self, {...})
            return old(self,...)
        end)
    elseif r:IsA("RemoteFunction") and r.InvokeServer then
        local old
        old = hookfunction(r.InvokeServer, function(self,...)
            handleLog("[InvokeServer]", self, {...})
            return old(self,...)
        end)
    end
end

local function hookReceive(r)
    if r:IsA("RemoteEvent") then
        r.OnClientEvent:Connect(function(...)
            handleLog("[Receive]", r, {...})
        end)
    end
end

--------------------------------------------------
-- INIT
--------------------------------------------------
for _,v in ipairs(game:GetDescendants()) do
    hookRemote(v)
    hookReceive(v)
end

game.DescendantAdded:Connect(function(v)
    hookRemote(v)
    hookReceive(v)
end)

print("=== REMOTE LOGGER FINAL READY (PARAM FIX) ===")
