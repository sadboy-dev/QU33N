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
_G.DelayBait = 0.5
_G.DelayCast = 1.0
_G.Blatant2Fishing = false

--// FUNCTIONS
local function Blatant2Loop()
    task.spawn(function()
        pcall(EquipToolFromHotbar.FireServer, EquipToolFromHotbar, 1)
        task.wait(0.5)

        while _G.Blatant2Fishing do
            -- Pasang bait
            task.wait(_G.DelayBait)

            -- Charge & cast
            local serverTime = Workspace:GetServerTimeNow()
            pcall(ChargeFishingRod.InvokeServer, ChargeFishingRod, serverTime)
            pcall(RequestFishingMinigame.InvokeServer, RequestFishingMinigame, -1, 0.999)

            -- Tunggu cast selesai
            task.wait(_G.DelayCast)

            -- Selesaikan fishing
            pcall(FishingCompleted.FireServer, FishingCompleted)
        end
    end)
end

local function StartBlatant2()
    _G.Blatant2Fishing = true
    Blatant2Loop()
end

local function StopBlatant2()
    _G.Blatant2Fishing = false
end

local function SetDelayBait(val)
    local n = tonumber(val)
    if n and n >= 0 then _G.DelayBait = n end
end

local function SetDelayCast(val)
    local n = tonumber(val)
    if n and n >= 0 then _G.DelayCast = n end
end

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Blatant2GUI"
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
Title.Text = "Blatant2 Fishing"
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
    _G.Blatant2Fishing = not _G.Blatant2Fishing
    Toggle.Text = _G.Blatant2Fishing and "ON" or "OFF"
    Toggle.BackgroundColor3 = _G.Blatant2Fishing and Color3.fromRGB(0,140,0) or Color3.fromRGB(130,0,0)

    if _G.Blatant2Fishing then
        StartBlatant2()
    else
        StopBlatant2()
    end
end)

-- Delay Bait Input
local BaitInput = Instance.new("TextBox", Frame)
BaitInput.Size = UDim2.new(1,-20,0,20)
BaitInput.Position = UDim2.new(0,10,0,70)
BaitInput.PlaceholderText = "Delay Bait (s)"
BaitInput.Text = tostring(_G.DelayBait)
BaitInput.ClearTextOnFocus = false
BaitInput.TextColor3 = Color3.fromRGB(255,255,255)
BaitInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
BaitInput.Font = Enum.Font.Gotham
BaitInput.TextSize = 14
Instance.new("UICorner", BaitInput).CornerRadius = UDim.new(0,5)

BaitInput.FocusLost:Connect(function(enter)
    if enter then SetDelayBait(BaitInput.Text) end
end)

-- Delay Cast Input
local CastInput = Instance.new("TextBox", Frame)
CastInput.Size = UDim2.new(1,-20,0,20)
CastInput.Position = UDim2.new(0,10,0,95)
CastInput.PlaceholderText = "Delay Cast (s)"
CastInput.Text = tostring(_G.DelayCast)
CastInput.ClearTextOnFocus = false
CastInput.TextColor3 = Color3.fromRGB(255,255,255)
CastInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
CastInput.Font = Enum.Font.Gotham
CastInput.TextSize = 14
Instance.new("UICorner", CastInput).CornerRadius = UDim.new(0,5)

CastInput.FocusLost:Connect(function(enter)
    if enter then SetDelayCast(CastInput.Text) end
end)

print("=== BLATANT2 FISHING READY ===")
