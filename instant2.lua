--================================================--
-- SERVICES
--================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--================================================--
-- REMOTES
--================================================--

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

--================================================--
-- INSTANT LOCALS
--================================================--

local InstantFishingEnabled = false
local InstantDelayComplete = 0.0
local FishMiniData = {}
local CurrentRodUID = nil

local function getFishCount()
    local InventoryGui = LocalPlayer:WaitForChild("PlayerGui")
        :WaitForChild("Inventory")
        :WaitForChild("Main")

    local BagSizeLabel = InventoryGui.Top.Options.Fish
        :WaitForChild("Label")
        :WaitForChild("BagSize")

    return tonumber((BagSizeLabel.Text or "0/???"):match("(%d+)/")) or 0
end


local function claimFish()
    local WaitStart = tick()
    repeat task.wait() until FishMiniData.LastShift or tick() - WaitStart > 1
    task.wait(InstantDelayComplete)
    pcall(function()
        FishingCompleted:InvokeServer()
    end)
    print("Success")
end


--================================================--
-- CHECK NOTIFY
--================================================--

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

                -- print("=== Player Info ===")
                -- print("UUID:", args.UUID)
                -- print("Userid:", userId)
                -- print("Container:", characterName)
                warn(string.format("TextColor: R%.2f G%.2f B%.2f", r, g, b))
                -- print("Duration:", args.Duration)
                
                claimFish()
            end
        end
    end)
end

FishHookListener()

--================================================--
-- AUTO EQUIP ROD
--================================================--

local function autoequiprod()
    task.spawn(function()
        pcall(function()
            EquipToolFromHotbar:FireServer(1)
        end)
    end)
end

--================================================--
-- START FISHING FUNCTION
--================================================--

local function StartFishing(ProgressValue, SuccessRate, rodGUID)
    pcall(function()
        RequestFishingMinigame:InvokeServer(ProgressValue, SuccessRate, rodGUID)
    end)
end

--================================================--
-- START FISHING2 FUNCTION
--================================================--

local function StartFishing2(ProgressValue, SuccessRate, rodGUID)
    print("Mulai Panggilan kedua")
    pcall(function()
        RequestFishingMinigame:InvokeServer(ProgressValue, SuccessRate, rodGUID)
    end)
    print(rodGUID)
    print("Panggilan Kedua Success")
end

--================================================--
-- GET ROD UID
--================================================--

local function getRodUid()
    pcall(function()
        local success, _, rodGUID = pcall(function()
            return ChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
        end)

        if not success or typeof(rodGUID) ~= "number" then
            -- warn("Failed to get Rod UID")
            return -- ✅ ganti goto dengan return
        end

        CurrentRodUID = rodGUID

        local ProgressValue = -1
        local SuccessRate = 9999999999999.999

        warn("Rod UID:", CurrentRodUID)

        -- 🔥 Panggil StartFishing setelah semua siap
        StartFishing(ProgressValue, SuccessRate, CurrentRodUID)
        
    end)
end

--================================================--
-- STOP FISHING
--================================================--

local function stopped()
    pcall(function()
        CancelFishingInputs:InvokeServer()
    end)
end

--================================================--
-- GUI SETUP
--================================================--

local parentGui = game.CoreGui
pcall(function()
    if gethui then
        parentGui = gethui()
    end
end)

pcall(function()
    parentGui:FindFirstChild("InstantToggleGui"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "InstantToggleGui"
gui.Parent = parentGui
gui.ResetOnSpawn = false

--------------------------------------------------
-- BUTTON
--------------------------------------------------

local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0, 130, 0, 36)
button.Position = UDim2.new(0.5, -65, 0.6, 0)
button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
button.BorderSizePixel = 0
button.Text = "INSTANT"
button.TextColor3 = Color3.fromRGB(255,255,255)
button.TextSize = 18
button.Font = Enum.Font.GothamBlack
button.AutoButtonColor = false
button.ZIndex = 3

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0,0,0)
stroke.Thickness = 2
stroke.Parent = button

--------------------------------------------------
-- SHADOW
--------------------------------------------------

local shadow = Instance.new("Frame")
shadow.Parent = button
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.Position = UDim2.new(0, 0, 0, 3)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = 1

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 10)
shadowCorner.Parent = shadow

--------------------------------------------------
-- GLOSS
--------------------------------------------------

local glow = Instance.new("Frame")
glow.Parent = button
glow.Size = UDim2.new(1, 0, 0.5, 0)
glow.Position = UDim2.new(0, 0, 0, 0)
glow.BorderSizePixel = 0
glow.ZIndex = 2

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 10)
glowCorner.Parent = glow

--------------------------------------------------
-- UPDATE UI
--------------------------------------------------

local function updateUI()
    if InstantFishingEnabled then
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        glow.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        glow.BackgroundTransparency = 0.6
    else
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        glow.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        glow.BackgroundTransparency = 0.3
    end
end

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

button.Activated:Connect(function()
    InstantFishingEnabled = not InstantFishingEnabled
    
    if InstantFishingEnabled then
        print("[FEATURED]: ON")

        autoequiprod()
        updateUI()
        task.wait(0.03)
        while InstantFishingEnabled do
            getRodUid()
        end
    else
        print("[FEATURED]: OFF")
        stopped()
    end

    updateUI()
end)

updateUI()

--------------------------------------------------
-- DRAG SYSTEM
--------------------------------------------------

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = true
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
