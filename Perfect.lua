print("=== LEGIT AUTO PERFECT START ===")

--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// NET
local NetFolder = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")
-- local FishingCompleted = NetFolder:WaitForChild("RE/FishingCompleted") -- komentar dulu
local ReplicateTextEffect = NetFolder:WaitForChild("RE/ReplicateTextEffect")

--// CONTROLLER
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
print("[OK] FishingController loaded")

--// INPUT HOOK (RELEASE CHARGE)
local InputControl = require(ReplicatedStorage.Modules.InputControl)
local OldRegister = InputControl.RegisterMouseReleased
local MouseReleaseCallback

function InputControl.RegisterMouseReleased(self, param2, callback)
    MouseReleaseCallback = callback
    return OldRegister(self, param2, callback)
end

print("[OK] Input hook installed")

--// STATE
local Enabled = false
local Casting = false
local WaitingForHook = false
local FishHooked = false
local LegitShakeDelay = 0.05 -- interval klik LEGIT

--==================================================
-- UTILITY: GET FISH COUNT
--==================================================
local function getFishCount()
    local InventoryGui = PlayerGui:WaitForChild("Inventory"):WaitForChild("Main")
    local BagSizeLabel = InventoryGui.Top.Options.Fish:WaitForChild("Label"):WaitForChild("BagSize")
    return tonumber((BagSizeLabel.Text or "0/???"):match("(%d+)/")) or 0
end

--==================================================
-- PERFECT CAST (CHARGE + RELEASE)
--==================================================
local function PerfectCast()
    local Camera = workspace.CurrentCamera
    if not Camera then return end

    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    print("[STEP] Requesting Charge Fishing Rod")
    FishingController:RequestChargeFishingRod(Center, false)

    local ChargeGui = PlayerGui:WaitForChild("Charge", 3)
    if not ChargeGui then 
        print("[ERROR] Charge GUI not found") 
        return 
    end

    local Bar = ChargeGui.Main.CanvasGroup.Bar
    repeat task.wait() until Bar.Size.Y.Scale > 0

    local start = tick()
    while Bar:IsDescendantOf(PlayerGui) and Bar.Size.Y.Scale < 0.93 do
        task.wait()
        if tick() - start > 2 then break end
    end

    if MouseReleaseCallback then
        MouseReleaseCallback()
        print("[STEP] Charge Release (Perfect Cast)")
    end
end

--==================================================
-- DETEKSI IKAN NYANGKUT
--==================================================
local function WaitFishHooked(timeout)
    timeout = timeout or 5
    local startTime = tick()
    FishHooked = false

    local conn
    conn = ReplicateTextEffect.OnClientEvent:Connect(function(args)
        if type(args.TextData) == "table" and args.TextData.Text == "!" then
            local attach = args.TextData.AttachTo
            if attach and attach:IsDescendantOf(LocalPlayer.Character) then
                FishHooked = true
                print("[INFO] Fish hooked detected!")
            end
        end
    end)

    repeat task.wait(0.03)
    until FishHooked or (tick() - startTime) > timeout

    conn:Disconnect()
    if not FishHooked then
        print("[WARN] Fish hooked NOT detected within timeout")
    end
    return FishHooked
end

--==================================================
-- MAIN LOOP
--==================================================
local function StartLegitFishing(state)
    Enabled = state
    FishingController._autoLoop = state
    FishingController._autoShake = state

    if not state then
        print("[AUTO PERFECT] DISABLED")
        return
    end

    print("[AUTO PERFECT] ENABLED")

    -- EQUIP ROD
    task.spawn(function()
        pcall(function()
            print("[STEP] Equipping rod")
            EquipToolFromHotbar:FireServer(1)
        end)
    end)

    -- CAST & HOOK LOOP
    task.spawn(function()
        local UserId = tostring(LocalPlayer.UserId)
        local CosmeticFolder = Workspace:WaitForChild("CosmeticFolder")

        while Enabled do
            -- Lempar umpan hanya jika tidak sedang cast dan tidak menunggu hook
            if not Casting and not WaitingForHook and not CosmeticFolder:FindFirstChild(UserId) then
                Casting = true
                print("[STEP] Casting rod (Perfect)")
                PerfectCast()
                Casting = false

                -- mulai menunggu hook
                WaitingForHook = true
                print("[INFO] Waiting for fish hooked...")
                WaitFishHooked(5)
                WaitingForHook = false
            end

            -- LEGIT shake & inventory check
            if FishHooked then
                local prevCount = getFishCount()
                print("[STEP] Start LEGIT shake")
                repeat
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
                    task.wait(LegitShakeDelay)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
                    task.wait(LegitShakeDelay)
                until getFishCount() > prevCount

                print("[INFO] Fish obtained, ready for next cast")
                FishHooked = false
            end

            task.wait(0.03)
        end
    end)
end

--==================================================
-- GUI
--==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoPerfectGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.fromOffset(180, 70)
Frame.Position = UDim2.fromScale(0.02, 0.45)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,28)
Title.BackgroundTransparency = 1
Title.Text = "Legit Auto Perfect"
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
    Toggle.BackgroundColor3 = Enabled
        and Color3.fromRGB(0,140,0)
        or Color3.fromRGB(130,0,0)

    StartLegitFishing(Enabled)
end)

print("=== SCRIPT READY ===")
