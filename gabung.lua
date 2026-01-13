-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- REMOTES
local NetFolder = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local ChargeFishingRod = NetFolder:WaitForChild("RF/ChargeFishingRod")
local RequestFishingMinigame = NetFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local FishingCompleted = NetFolder:WaitForChild("RE/FishingCompleted")
local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")
local CancelFishingInputs = NetFolder:WaitForChild("RF/CancelFishingInputs")

-- CONTROLLER
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
local InputControl = require(ReplicatedStorage.Modules.InputControl)
local OldRegister = InputControl.RegisterMouseReleased
local MouseReleaseCallback
function InputControl.RegisterMouseReleased(self, param2, callback)
    MouseReleaseCallback = callback
    return OldRegister(self, param2, callback)
end

-- VARIABLES
local Enabled = false

-- MINI EVENT
local FishMiniData = {}
local MiniEvent = NetFolder:WaitForChild("RE/FishingMinigameChanged")
MiniEvent.OnClientEvent:Connect(function(p1,p2)
    if p1 and p2 then FishMiniData = p2 end
end)

-- PERFECT + INSTANT FISH ONCE
local function AutoFishOnce()
    -- 1️⃣ Equip rod
    pcall(function() EquipToolFromHotbar:FireServer(1) end)
    task.wait(0.3)

    -- 2️⃣ Charge rod & release
    local Camera = workspace.CurrentCamera
    if not Camera then return end
    local Center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FishingController:RequestChargeFishingRod(Center,false)

    local ChargeGui = PlayerGui:FindFirstChild("Charge")
    if ChargeGui then
        local Bar = ChargeGui.Main.CanvasGroup.Bar
        repeat task.wait() until Bar.Size.Y.Scale>0
        local start = tick()
        while Bar:IsDescendantOf(PlayerGui) and Bar.Size.Y.Scale < 0.93 do
            task.wait()
            if tick()-start>2 then break end
        end
        if MouseReleaseCallback then MouseReleaseCallback() end
    end

    task.wait(0.1)

    -- 3️⃣ Server invoke
    local success, _, rodGUID = pcall(function()
        return ChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
    end)
    if success and typeof(rodGUID) == "number" then
        pcall(function()
            RequestFishingMinigame:InvokeServer(-1, 0.999, rodGUID)
        end)
    end

    -- 4️⃣ Mini-game click (client)
    pcall(function()
        FishingController:RequestFishingMinigameClick()
    end)

    task.wait(0.05)

    -- 5️⃣ Complete
    pcall(function()
        FishingCompleted:FireServer()
        CancelFishingInputs:InvokeServer()
    end)
end

-- LOOP AUTO FISH
local function StartAutoFishing(state)
    Enabled = state
    FishingController._autoLoop = state
    FishingController._autoShake = state
    if not state then return end

    task.spawn(function()
        while Enabled do
            AutoFishOnce()
            task.wait(0.15) -- delay antar cast
        end
    end)
end

-- GUI kecil
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoPerfectGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.fromOffset(180,70)
Frame.Position = UDim2.fromScale(0.02,0.45)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,28)
Title.BackgroundTransparency = 1
Title.Text = "Auto Perfect Fishing"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255,255,255)

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
    Enabled = not Enabled
    Toggle.Text = Enabled and "ON" or "OFF"
    Toggle.BackgroundColor3 = Enabled and Color3.fromRGB(0,140,0) or Color3.fromRGB(130,0,0)
    StartAutoFishing(Enabled)
end)

print("=== AUTO PERFECT + INSTANT FISHING READY ===")
