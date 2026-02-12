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
local FishingCompleted = NetFolder:WaitForChild("RF/CatchFishCompleted")
local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")
local CancelFishingInputs = NetFolder:WaitForChild("RF/CancelFishingInputs")
local ReplicateTextEffect = NetFolder:FindFirstChild("RE/ReplicateTextEffect")

-- GUI
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
local InstantDelayComplete = 0.0
local FishMiniData = {}

-- MiniEvent listener
local MiniEvent = NetFolder:WaitForChild("RE/FishingMinigameChanged")
if MiniEvent then
    MiniEvent.OnClientEvent:Connect(function(param1, param2)
        if param1 and param2 then
            FishMiniData = param2
        end
    end)
end

-- Function to get current fish count
local function getFishCount()
    local InventoryGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Inventory"):WaitForChild("Main")
    local BagSizeLabel = InventoryGui.Top.Options.Fish:WaitForChild("Label"):WaitForChild("BagSize")
    return tonumber((BagSizeLabel.Text or "0/???"):match("(%d+)/")) or 0
end

-- Function detect fish hooked (print RGB saja, hanya player sendiri)
local function FishHookListener()
    if not ReplicateTextEffect then return end
    local userId = tostring(LocalPlayer.UserId)

    ReplicateTextEffect.OnClientEvent:Connect(function(args)
        if args.TextData and args.TextData.Text == "!" then
            local container = args.Container
            if container and container:IsDescendantOf(LocalPlayer.Character) then
                -- Ambil nama karakter
                local characterName = container.Parent and container.Parent.Name or "Unknown"

                -- Ambil TextColor aman
                local r, g, b = 0, 0, 0
                if typeof(args.TextData.TextColor) == "Color3" then
                    r, g, b = args.TextData.TextColor.R, args.TextData.TextColor.G, args.TextData.TextColor.B
                elseif typeof(args.TextData.TextColor) == "ColorSequence" then
                    if #args.TextData.TextColor.Keypoints > 0 then
                        local kp = args.TextData.TextColor.Keypoints[1].Value
                        r, g, b = kp.R, kp.G, kp.B
                    end
                elseif type(args.TextData.TextColor) == "table" then
                    r, g, b = args.TextData.TextColor[1] or 0, args.TextData.TextColor[2] or 0, args.TextData.TextColor[3] or 0
                end

                print("=== Player Info ===")
                print("UUID:", args.UUID)
                print("Userid:", userId)
                print("Container:", characterName)
                print(string.format("TextColor: R%.2f G%.2f B%.2f", r, g, b))
                print("Duration:", args.Duration)
            end
        end
    end)
end

FishHookListener()

-- Instant Fishing Loop
local function StartInstantFishing()
    task.spawn(function()
        pcall(function() EquipToolFromHotbar:FireServer(1) end)
        task.wait(0.5)
        pcall(function()
            local success, _, rodGUID = pcall(function()
                return ChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
            end)

            if success and typeof(rodGUID) == "number" then
                local ProgressValue = -1
                local SuccessRate = 0.999

                    
                pcall(function()
                    RequestFishingMinigame:InvokeServer(ProgressValue, SuccessRate, rodGUID)
                end)

                local WaitStart = tick()
                repeat task.wait() until FishMiniData.LastShift or tick() - WaitStart > 1
                task.wait(InstantDelayComplete)

                pcall(function()
                    -- FishingCompleted:FireServer()
                    FishingCompleted:InvokeServer()
                end)

                local CurrentCount = getFishCount()
                local CountWaitStart = tick()
                repeat task.wait() until CurrentCount < getFishCount() or tick() - CountWaitStart > 1

                pcall(function()
                    CancelFishingInputs:InvokeServer()
                end)
            end
        end)
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
