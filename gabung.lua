--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// NET
local NetFolder = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local ChargeFishingRod = NetFolder:WaitForChild("RF/ChargeFishingRod")
local RequestFishingMinigame = NetFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local FishingCompleted = NetFolder:WaitForChild("RE/FishingCompleted")
local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")
local CancelFishingInputs = NetFolder:WaitForChild("RF/CancelFishingInputs")

--// VARIABLES
_G.FishingDelay = 1.1
_G.ReelDelay = 1.9
_G.BlatantFishing = false

--// BLATANT FUNCTIONS
local function FastestFishing()
    task.spawn(function()
        pcall(CancelFishingInputs.InvokeServer, CancelFishingInputs)
        local serverTime = Workspace:GetServerTimeNow()
        pcall(ChargeFishingRod.InvokeServer, ChargeFishingRod, serverTime)
        pcall(RequestFishingMinigame.InvokeServer, RequestFishingMinigame, -1, 0.999)
        task.wait(_G.FishingDelay)
        pcall(FishingCompleted.FireServer, FishingCompleted)
    end)
end

local function StartBlatantFishing()
    _G.BlatantFishing = true
    pcall(EquipToolFromHotbar.FireServer, EquipToolFromHotbar, 1)
    task.spawn(function()
        task.wait(0.5)
        while _G.BlatantFishing do
            FastestFishing()
            task.wait(_G.ReelDelay)
        end
    end)
end

local function StopBlatantFishing()
    _G.BlatantFishing = false
end

local function SetFishingDelay(delay)
    local num = tonumber(delay)
    if num and num > 0 then _G.FishingDelay = num end
end

local function SetReelDelay(delay)
    local num = tonumber(delay)
    if num and num > 0 then _G.ReelDelay = num end
end

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlatantFishingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.fromOffset(200, 120)
Frame.Position = UDim2.fromScale(0.02, 0.3)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,28)
Title.BackgroundTransparency = 1
Title.Text = "Blatant Fishing"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255,255,255)

-- Toggle Button
local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(1,-20,0,30)
Toggle.Position = UDim2.new(0,10,0,35)
Toggle.Text = "OFF"
Toggle.Font = Enum.Font.Gotham
Toggle.TextSize = 14
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.BackgroundColor3 = Color3.fromRGB(130,0,0)
Toggle.AutoButtonColor = false
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,8)

Toggle.MouseButton1Click:Connect(function()
    _G.BlatantFishing = not _G.BlatantFishing
    Toggle.Text = _G.BlatantFishing and "ON" or "OFF"
    Toggle.BackgroundColor3 = _G.BlatantFishing and Color3.fromRGB(0,140,0) or Color3.fromRGB(130,0,0)

    if _G.BlatantFishing then
        StartBlatantFishing()
    else
        StopBlatantFishing()
    end
end)

-- Fishing Delay Input
local FishingDelayInput = Instance.new("TextBox", Frame)
FishingDelayInput.Size = UDim2.new(1,-20,0,20)
FishingDelayInput.Position = UDim2.new(0,10,0,70)
FishingDelayInput.PlaceholderText = "Fishing Delay (s)"
FishingDelayInput.Text = tostring(_G.FishingDelay)
FishingDelayInput.ClearTextOnFocus = false
FishingDelayInput.TextColor3 = Color3.fromRGB(255,255,255)
FishingDelayInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
FishingDelayInput.Font = Enum.Font.Gotham
FishingDelayInput.TextSize = 14
Instance.new("UICorner", FishingDelayInput).CornerRadius = UDim.new(0,5)

FishingDelayInput.FocusLost:Connect(function(enter)
    if enter then SetFishingDelay(FishingDelayInput.Text) end
end)

-- Reel Delay Input
local ReelDelayInput = Instance.new("TextBox", Frame)
ReelDelayInput.Size = UDim2.new(1,-20,0,20)
ReelDelayInput.Position = UDim2.new(0,10,0,95)
ReelDelayInput.PlaceholderText = "Reel Delay (s)"
ReelDelayInput.Text = tostring(_G.ReelDelay)
ReelDelayInput.ClearTextOnFocus = false
ReelDelayInput.TextColor3 = Color3.fromRGB(255,255,255)
ReelDelayInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
ReelDelayInput.Font = Enum.Font.Gotham
ReelDelayInput.TextSize = 14
Instance.new("UICorner", ReelDelayInput).CornerRadius = UDim.new(0,5)

ReelDelayInput.FocusLost:Connect(function(enter)
    if enter then SetReelDelay(ReelDelayInput.Text) end
end)

print("=== BLATANT FISHING READY ===")
