-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Remotes
local NetFolder = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local ChargeFishingRod = NetFolder:WaitForChild("RF/ChargeFishingRod")
local RequestFishingMinigame = NetFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local FishingCompleted = NetFolder:WaitForChild("RE/FishingCompleted")
local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")
local CancelFishingInputs = NetFolder:WaitForChild("RF/CancelFishingInputs")

-- GUI Library (simple)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InstantFishingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 80)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -10, 0, 40)
ToggleButton.Position = UDim2.new(0, 5, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Text = "Instant Fishing: OFF"
ToggleButton.Parent = Frame

-- Variables
local InstantFishingEnabled = false
local InstantDelayComplete = 0.1
local FishMiniData = {}

-- MiniEvent listener
local MiniEvent = NetFolder:WaitForChild("RE/FishingMinigameChanged")
if MiniEvent then
    MiniEvent.OnClientEvent:Connect(function(param1, param2)
        if param1 and param2 then
            FishMiniData = param2
            print(FishMiniData)
        end
    end)
end

-- Function to get current fish count
local function getFishCount()
    local InventoryGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Inventory"):WaitForChild("Main")
    local BagSizeLabel = InventoryGui.Top.Options.Fish:WaitForChild("Label"):WaitForChild("BagSize")
    return tonumber((BagSizeLabel.Text or "0/???"):match("(%d+)/")) or 0
end

-- Instant Fishing Loop
local function StartInstantFishing()
    task.spawn(function()
        pcall(function() EquipToolFromHotbar:FireServer(1) end)
        task.wait(0.5)
        while InstantFishingEnabled do
            pcall(function()
                local success, _, rodGUID = pcall(function()
                    return ChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
                end)

                if success and typeof(rodGUID) == "number" then
                    local ProgressValue = -1
                    local SuccessRate = 0.999

                    task.wait(0.3)
                    pcall(function()
                        RequestFishingMinigame:InvokeServer(ProgressValue, SuccessRate, rodGUID)
                    end)

                    local WaitStart = tick()
                    repeat task.wait() until FishMiniData.LastShift or tick() - WaitStart > 1
                    task.wait(InstantDelayComplete)

                    pcall(function()
                        FishingCompleted:FireServer()
                    end)

                    local CurrentCount = getFishCount()
                    local CountWaitStart = tick()
                    repeat task.wait() until CurrentCount < getFishCount() or tick() - CountWaitStart > 1

                    pcall(function()
                        CancelFishingInputs:InvokeServer()
                    end)
                end
            end)
            task.wait()
        end
    end)
end

-- Toggle Button
ToggleButton.MouseButton1Click:Connect(function()
    InstantFishingEnabled = not InstantFishingEnabled
    ToggleButton.Text = "Instant Fishing: " .. (InstantFishingEnabled and "ON" or "OFF")
    if InstantFishingEnabled then
        StartInstantFishing()
    end
end)
