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
local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")

--================================================--
-- LOCALS
--================================================--

local InstantFishingEnabled = false

local function getFishCount()
    local InventoryGui = LocalPlayer:WaitForChild("PlayerGui")
        :WaitForChild("Inventory")
        :WaitForChild("Main")

    local BagSizeLabel = InventoryGui.Top.Options.Fish
        :WaitForChild("Label")
        :WaitForChild("BagSize")

    return tonumber((BagSizeLabel.Text or "0/???"):match("(%d+)/")) or 0
end

--================================================--
-- AUTO EQUIP
--================================================--

local function autoequiprod()
    task.spawn(function()
        pcall(function()
            EquipToolFromHotbar:FireServer(1)
        end)
    end)
end

--================================================--
-- TEST 2 ROD UID
--================================================--

local function getRodUid()
    pcall(function()

        -- FIRST CALL
        local success1, _, rodUID1 = pcall(function()
            return ChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
        end)

        task.wait(0.066)

        -- SECOND CALL
        local success2, _, rodUID2 = pcall(function()
            return ChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
        end)

        print("RodUID1:", rodUID1)
        print("RodUID2:", rodUID2)

        if success1 and success2 then
            if typeof(rodUID1) == "number" and typeof(rodUID2) == "number" then
                
                if rodUID1 ~= rodUID2 then
                    print("✅ SUCCESS: 2 Different RodUID detected")
                else
                    print("⚠️ SAME RodUID returned twice")
                end

            else
                warn("RodUID not number")
            end
        else
            warn("ChargeFishingRod failed")
        end

    end)
end

--================================================--
-- GUI
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

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

--================================================--
-- TOGGLE
--================================================--

button.Activated:Connect(function()
    InstantFishingEnabled = not InstantFishingEnabled
    
    if InstantFishingEnabled then
        print("[FEATURED]: ON")

        autoequiprod()
        task.wait(0.066)
        getRodUid()

    else
        print("[FEATURED]: OFF")
    end
end)

--================================================--
-- DRAG
--================================================--

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
