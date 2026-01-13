--==================================================
-- LEGIT AUTO PERFECT (1 CLICK PRESISI)
--==================================================

print("=== LEGIT AUTO PERFECT START ===")

--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// NET
local NetFolder = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")

--// CONTROLLER
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
print("[OK] FishingController loaded")

--// INPUT HOOK (UNTUK RELEASE PERFECT)
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

--==================================================
-- PERFECT CAST (CHARGE + RELEASE)
--==================================================
local function PerfectCast()
    local Camera = workspace.CurrentCamera
    if not Camera then return end

    local Center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    FishingController:RequestChargeFishingRod(Center, false)

    local ChargeGui = PlayerGui:WaitForChild("Charge", 3)
    if not ChargeGui then return end

    local Bar = ChargeGui.Main.CanvasGroup.Bar

    repeat task.wait() until Bar.Size.Y.Scale > 0

    local start = tick()
    while Bar:IsDescendantOf(PlayerGui) and Bar.Size.Y.Scale < 0.93 do
        task.wait()
        if tick() - start > 2 then break end
    end

    if MouseReleaseCallback then
        MouseReleaseCallback()
        print("[AUTO PERFECT] Charge Release")
    end
end

--==================================================
-- MAIN LOOP (COSMETIC BASED)
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
            EquipToolFromHotbar:FireServer(1)
        end)
    end)

    -- CAST LOOP
    task.spawn(function()
        local UserId = tostring(LocalPlayer.UserId)
        local CosmeticFolder = Workspace:WaitForChild("CosmeticFolder")

        while Enabled do
            if not CosmeticFolder:FindFirstChild(UserId) then
                PerfectCast()
                task.wait(0.25)
            end

            while CosmeticFolder:FindFirstChild(UserId) and Enabled do
                task.wait(0.15)
            end

            task.wait(0.15)
        end
    end)

    -- 🔥 1 CLICK PRESISI (MINIGAME)
    task.spawn(function()
        local UserId = tostring(LocalPlayer.UserId)
        local CosmeticFolder = Workspace:WaitForChild("CosmeticFolder")

        while Enabled do
            if CosmeticFolder:FindFirstChild(UserId) then
                local fishingGui = PlayerGui:FindFirstChild("Fishing")
                local mainGui = fishingGui and fishingGui:FindFirstChild("Main")
                local bar = mainGui
                    and mainGui:FindFirstChild("CanvasGroup")
                    and mainGui.CanvasGroup:FindFirstChild("Bar")

                if bar and bar.Size.Y.Scale >= 0.88 then
                    FishingController:RequestFishingMinigameClick()
                    print("[AUTO PERFECT] Minigame Click")

                    -- tunggu selesai → cegah spam
                    repeat
                        task.wait(0.05)
                    until not CosmeticFolder:FindFirstChild(UserId)
                end
            end

            task.wait(0.03)
        end
    end)
end

--==================================================
-- GUI KECIL (ON / OFF)
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
