-- [[
--  Chloe X | Community
--  (c) 2025 Chloe | Chloe X Development
--  Unauthorized redistribution prohibited.
-- ]]


-- Chloe.GlobalService
local HttpService      = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()
local CoreGui          = game:GetService("CoreGui")
local camera           = workspace.CurrentCamera
local viewport         = camera and camera.ViewportSize or Vector2.new(1920, 1080)

-- Chloe.Config.CreateConfig.Folder
if not isfolder("Chloe X") then makefolder("Chloe X") end
if not isfolder("Chloe X/Config") then makefolder("Chloe X/Config") end

-- Chloe.Config.Game
local gameName        = tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
gameName              = gameName:gsub("[^%w_ ]", "")
gameName              = gameName:gsub("%s+", "_")

-- Chloe.Config.GameName
local ConfigFile      = "Chloe X/Config/Chloe_" .. gameName .. ".json"
local ConfigData      = {}
local Elements        = {}
local CURRENT_VERSION = nil

-- Chloe.Config.Save.SaveConfig
function SaveConfig()
    if writefile then
        ConfigData._version = CURRENT_VERSION
        writefile(ConfigFile, HttpService:JSONEncode(ConfigData))
    end
end

-- Chloe.Config.Load.LoadConfigFromFile
function LoadConfigFromFile()
    if not CURRENT_VERSION then
        ConfigData = {}
        return
    end

    if isfile and isfile(ConfigFile) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigFile))
        end)

        if success and type(result) == "table" then
            if result._version == CURRENT_VERSION then
                ConfigData = result
            else
                ConfigData = { _version = CURRENT_VERSION }
            end
        else
            ConfigData = { _version = CURRENT_VERSION }
        end
    else
        ConfigData = { _version = CURRENT_VERSION }
    end
end

-- Chloe.Config.Load.LoadConfigElements
function LoadConfigElements()
    for key, element in pairs(Elements) do
        if ConfigData[key] ~= nil and element.Set then
            element:Set(ConfigData[key], true)
        end
    end
end

-- Chloe.UI.MobileDetected
function isMobileDevice()
    return UserInputService.TouchEnabled
        and not UserInputService.KeyboardEnabled
        and not UserInputService.MouseEnabled
end

local isMobile = isMobileDevice()

-- Chloe.UI.SafeSize
function safeSize(pxWidth, pxHeight)
    local vw, vh = viewport.X, viewport.Y
    if vw <= 0 or vh <= 0 then
        vw, vh = 1920, 1080
    end

    local scaleX = pxWidth / vw
    local scaleY = pxHeight / vh

    if isMobile then
        if scaleX > 0.7 then scaleX = 0.7 end
        if scaleY > 0.5 then scaleY = 0.5 end
    end

    return UDim2.new(scaleX, 0, scaleY, 0)
end

-- Chloe.UI.CircleClick
function CircleClick(Button, X, Y)
    task.spawn(function()
        if not Button then return end
        Button.ClipsDescendants = true

        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
        Circle.ImageTransparency = 0.9
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = Button.ZIndex + 5
        Circle.Name = "Circle"
        Circle.Parent = Button

        local NewX = X - Button.AbsolutePosition.X
        local NewY = Y - Button.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)

        local Size
        if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.X * 1.5
        else
            Size = Button.AbsoluteSize.Y * 1.5
        end

        local Time = 0.4
        Circle:TweenSizeAndPosition(
            UDim2.new(0, Size, 0, Size),
            UDim2.new(0.5, -Size / 2, 0.5, -Size / 2),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            Time,
            false
        )

        for _ = 1, 10 do
            Circle.ImageTransparency = Circle.ImageTransparency + 0.1
            task.wait(Time / 10)
        end

        Circle:Destroy()
    end)
end

-- Chloe.UI.MakeDraggable
function MakeDraggable(topBarObject, dragObject)
    local Dragging = false
    local DragInput, DragStart, StartPosition

    function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )

        TweenService:Create(
            dragObject,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Position = pos }
        ):Play()
    end

    topBarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = dragObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topBarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdatePos(input)
        end
    end)
end

local ChloeX = {}

-- Chloe.MakeNotify.Screen
function Notifier()
    local CHX = {}
    CHX[1] = CoreGui:FindFirstChild("Notify")
    if CHX[1] then return CHX[1] end

    -- Chloe.MakeNotify.ScreenGui
    CHX[1] = Instance.new("ScreenGui")
    CHX[1].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CHX[1].Name = "Notify"
    CHX[1].ResetOnSpawn = false
    CHX[1].Parent = CoreGui

    -- Chloe.MakeNotify.Layout
    CHX[2] = Instance.new("Frame")
    CHX[2].AnchorPoint = Vector2.new(1, 1)
    CHX[2].BackgroundTransparency = 1
    CHX[2].BorderSizePixel = 0
    CHX[2].Position = UDim2.new(1, -30, 1, -30)
    CHX[2].Size = UDim2.new(0, 320, 1, 0)
    CHX[2].Name = "NotifyLayout"
    CHX[2].Parent = CHX[1]

    -- Chloe.MakeNotify.Reorder
    local function Reorder()
        local count = 0
        for _, v in ipairs(CHX[2]:GetChildren()) do
            if v:IsA("Frame") then
                TweenService:Create(
                    v,
                    TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    { Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 8) * count)) }
                ):Play()
                count += 1
            end
        end
    end

    CHX[2].ChildAdded:Connect(Reorder)
    CHX[2].ChildRemoved:Connect(Reorder)

    return CHX[1]
end

-- Chloe.MakeNotify
function ChloeX:MakeNotify(Notify)
    Notify             = Notify or {}
    Notify.Title       = Notify.Title or "Chloe X"
    Notify.Description = Notify.Description or "Notification"
    Notify.Content     = Notify.Content or "Content"
    Notify.Color       = Notify.Color or Color3.fromRGB(0, 208, 255)
    Notify.Time        = Notify.Time or 0.25
    Notify.Delay       = Notify.Delay or 4

    -- Chloe.MakeNotify.Screen
    local gui          = Notifier()
    local layout       = gui:FindFirstChild("NotifyLayout")
    if not layout then return end

    local CHX = {}

    -- Chloe.MakeNotify.Frame
    CHX[3] = Instance.new("Frame")
    CHX[3].BackgroundTransparency = 1
    CHX[3].BorderSizePixel = 0
    CHX[3].Size = UDim2.new(1, 0, 0, 80)
    CHX[3].AnchorPoint = Vector2.new(0, 1)
    CHX[3].Position = UDim2.new(0, 0, 1, 0)
    CHX[3].Parent = layout
    CHX[3].Name = "NotifyFrame"

    -- Chloe.MakeNotify.Real
    CHX[4] = Instance.new("Frame")
    CHX[4].BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    CHX[4].BorderSizePixel = 0
    CHX[4].Size = UDim2.new(1, 0, 1, 0)
    CHX[4].Position = UDim2.new(0, 400, 0, 0)
    CHX[4].Parent = CHX[3]
    CHX[4].Name = "Real"

    -- Chloe.MakeNotify.Corner
    CHX[5] = Instance.new("UICorner")
    CHX[5].CornerRadius = UDim.new(0, 8)
    CHX[5].Parent = CHX[4]

    -- Chloe.MakeNotify.DropShadowHolder
    CHX[6] = Instance.new("Frame")
    CHX[6].BackgroundTransparency = 1
    CHX[6].BorderSizePixel = 0
    CHX[6].Size = UDim2.new(1, 0, 1, 0)
    CHX[6].ZIndex = 0
    CHX[6].Name = "DropShadowHolder"
    CHX[6].Parent = CHX[4]

    -- Chloe.MakeNotify.DropShadow
    CHX[7] = Instance.new("ImageLabel")
    CHX[7].Name = "DropShadow"
    CHX[7].Image = "rbxassetid://6015897843"
    CHX[7].ImageColor3 = Color3.fromRGB(0, 0, 0)
    CHX[7].ImageTransparency = 0.4
    CHX[7].ScaleType = Enum.ScaleType.Slice
    CHX[7].SliceCenter = Rect.new(49, 49, 450, 450)
    CHX[7].AnchorPoint = Vector2.new(0.5, 0.5)
    CHX[7].Position = UDim2.new(0.5, 0, 0.5, 4)
    CHX[7].Size = UDim2.new(1, 10, 1, 10)
    CHX[7].BackgroundTransparency = 1
    CHX[7].BorderSizePixel = 0
    CHX[7].ZIndex = -1
    CHX[7].Parent = CHX[6]

    -- Chloe.MakeNotify.Top
    CHX[8] = Instance.new("Frame")
    CHX[8].BackgroundTransparency = 1
    CHX[8].BorderSizePixel = 0
    CHX[8].Size = UDim2.new(1, 0, 0, 28)
    CHX[8].Parent = CHX[4]
    CHX[8].Name = "Top"

    -- Chloe.MakeNotify.Title
    CHX[9] = Instance.new("TextLabel")
    CHX[9].Font = Enum.Font.GothamBold
    CHX[9].Text = Notify.Title
    CHX[9].TextColor3 = Color3.fromRGB(255, 255, 255)
    CHX[9].TextSize = 14
    CHX[9].TextXAlignment = Enum.TextXAlignment.Left
    CHX[9].BackgroundTransparency = 1
    CHX[9].Size = UDim2.new(1, -40, 1, 0)
    CHX[9].Position = UDim2.new(0, 10, 0, 0)
    CHX[9].Parent = CHX[8]

    -- Chloe.MakeNotify.Description
    CHX[10] = Instance.new("TextLabel")
    CHX[10].Font = Enum.Font.Gotham
    CHX[10].Text = Notify.Description
    CHX[10].TextColor3 = Notify.Color
    CHX[10].TextSize = 13
    CHX[10].TextXAlignment = Enum.TextXAlignment.Left
    CHX[10].BackgroundTransparency = 1
    CHX[10].Size = UDim2.new(1, -40, 1, 0)
    CHX[10].Position = UDim2.new(0, CHX[9].TextBounds.X + 14, 0, 0)
    CHX[10].Parent = CHX[8]

    -- Chloe.MakeNotify.CloseButton
    CHX[11] = Instance.new("TextButton")
    CHX[11].BackgroundTransparency = 1
    CHX[11].Size = UDim2.new(0, 24, 0, 24)
    CHX[11].Position = UDim2.new(1, -28, 0.5, -12)
    CHX[11].Text = ""
    CHX[11].Parent = CHX[8]
    CHX[11].Name = "CloseButton"

    -- Chloe.MakeNotify.CloseIcon
    CHX[12] = Instance.new("ImageLabel")
    CHX[12].BackgroundTransparency = 1
    CHX[12].Size = UDim2.new(1, -4, 1, -4)
    CHX[12].Position = UDim2.new(0, 2, 0, 2)
    CHX[12].Image = "rbxassetid://9886659671"
    CHX[12].ImageTransparency = 0.1
    CHX[12].Parent = CHX[11]
    CHX[12].Name = "CloseIcon"

    -- Chloe.MakeNotify.Content
    CHX[13] = Instance.new("TextLabel")
    CHX[13].Font = Enum.Font.Gotham
    CHX[13].Text = Notify.Content
    CHX[13].TextColor3 = Color3.fromRGB(190, 190, 195)
    CHX[13].TextSize = 13
    CHX[13].TextXAlignment = Enum.TextXAlignment.Left
    CHX[13].TextYAlignment = Enum.TextYAlignment.Top
    CHX[13].BackgroundTransparency = 1
    CHX[13].Position = UDim2.new(0, 10, 0, 30)
    CHX[13].Size = UDim2.new(1, -20, 0, 40)
    CHX[13].TextWrapped = true
    CHX[13].Parent = CHX[4]
    CHX[13].Name = "Content"

    -- Chloe.MakeNotify.DynamicHeight
    CHX[13].Size = UDim2.new(1, -20, 0, CHX[13].TextBounds.Y)
    CHX[3].Size = UDim2.new(1, 0, 0, CHX[13].TextBounds.Y + 40)

    -- Chloe.MakeNotify.CloseLogic
    local closing = false
    local NotifyFunction = {}

    function NotifyFunction:Close()
        if closing then return end
        closing = true

        TweenService:Create(
            CHX[4],
            TweenInfo.new(Notify.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
            { Position = UDim2.new(0, 400, 0, 0) }
        ):Play()

        task.wait(Notify.Time * 0.8)
        CHX[3]:Destroy()
    end

    CHX[11].MouseButton1Click:Connect(function()
        NotifyFunction:Close()
    end)

    -- Chloe.MakeNotify.OpenAnimation
    TweenService:Create(
        CHX[4],
        TweenInfo.new(Notify.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
        { Position = UDim2.new(0, 0, 0, 0) }
    ):Play()

    -- Chloe.MakeNotify.AutoClose
    task.delay(Notify.Delay, function()
        NotifyFunction:Close()
    end)

    return NotifyFunction
end

-- Chloe.MakeNotify.Return
function ChloeX:Notify(cfg)
    return ChloeX:MakeNotify(cfg)
end

-- Chloe.MakeNotify.Shortcut
setmetatable(ChloeX, {
    __call = function(_, message)
        return ChloeX:MakeNotify({
            Title = "Chloe X",
            Description = "Notification",
            Content = message,
            Color = Color3.fromRGB(0, 208, 255),
            Time = 0.25,
            Delay = 4
        })
    end
})

-- Chloe.Window.CreateWindow
function ChloeX:Window(Flag)
    -- Chloe.Window.Config
    Flag                   = Flag or {}
    local GuiConfig        = Flag

    GuiConfig.Title        = GuiConfig.Title or "Chloe X"
    GuiConfig.Footer       = GuiConfig.Footer or "Chloee :3"
    GuiConfig.Color        = GuiConfig.Color or Color3.fromRGB(255, 0, 255)
    GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or GuiConfig.TabWidth or 120
    GuiConfig.Version      = GuiConfig.Version or 1
    GuiConfig.ToggleKey    = GuiConfig.ToggleKey or Enum.KeyCode.F3

    CURRENT_VERSION        = GuiConfig.Version
    LoadConfigFromFile()

    local themeColors               = MergeTheme(DefaultThemeColors(), GuiConfig.ThemeColors)

    local self                      = setmetatable({}, WindowClass)
    self.GuiConfig                  = GuiConfig
    self.ThemeColors                = themeColors
    self.Tabs                       = {}
    self.Visible                    = true

    local CHX                       = {}

    -- Chloe.Window.ScreenGui
    CHX[15]                         = Instance.new("ScreenGui")
    CHX[15].ZIndexBehavior          = Enum.ZIndexBehavior.Sibling
    CHX[15].ResetOnSpawn            = false
    CHX[15].Name                    = "ChloeX_MainGui"
    CHX[15].Parent                  = CoreGui

    -- Chloe.Window.DropShadowHolder
    CHX[16]                         = Instance.new("Frame")
    CHX[16].BackgroundTransparency  = 1
    CHX[16].BorderSizePixel         = 0
    CHX[16].AnchorPoint             = Vector2.new(0.5, 0.5)
    CHX[16].Position                = UDim2.new(0.5, 0, 0.5, 0)
    CHX[16].Size                    = safeSize(isMobile and 470 or 640, isMobile and 270 or 400)
    CHX[16].ZIndex                  = 0
    CHX[16].Name                    = "DropShadowHolder"
    CHX[16].Parent                  = CHX[15]

    CHX[200]                        = Instance.new("Frame")
    CHX[200].Size                   = UDim2.new(0, 16, 0, 16)
    CHX[200].Position               = UDim2.new(1, -16, 1, -16)
    CHX[200].AnchorPoint            = Vector2.new(1, 1)
    CHX[200].BackgroundColor3       = themeColors.Accent
    CHX[200].BorderSizePixel        = 0
    CHX[200].ZIndex                 = 999
    CHX[200].BackgroundTransparency = 0
    CHX[200].Parent                 = CHX[16]
    CHX[200].Name                   = "ResizeHandle"

    CHX[16].ClipsDescendants        = false

    local resizing                  = false
    local startSize, startPos

    CHX[200].InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startSize = CHX[16].Size
            startPos = input.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos

            CHX[16].Size = UDim2.new(
                startSize.X.Scale,
                math.clamp(startSize.X.Offset + delta.X, 380, 900),
                startSize.Y.Scale,
                math.clamp(startSize.Y.Offset + delta.Y, 240, 700)
            )
        end
    end)

    -- Chloe.Window.DropShadow
    CHX[17]                        = Instance.new("ImageLabel")
    CHX[17].Image                  = "rbxassetid://6015897843"
    CHX[17].ImageColor3            = Color3.fromRGB(15, 15, 15)
    CHX[17].ImageTransparency      = 0.35
    CHX[17].ScaleType              = Enum.ScaleType.Slice
    CHX[17].SliceCenter            = Rect.new(49, 49, 450, 450)
    CHX[17].AnchorPoint            = Vector2.new(0.5, 0.5)
    CHX[17].BackgroundTransparency = 1
    CHX[17].BorderSizePixel        = 0
    CHX[17].Position               = UDim2.new(0.5, 0, 0.5, 0)
    CHX[17].Size                   = UDim2.new(1, 47, 1, 47)
    CHX[17].ZIndex                 = 0
    CHX[17].Name                   = "DropShadow"
    CHX[17].Parent                 = CHX[16]

    -- Chloe.Window.Main
    if GuiConfig.Theme then
        CHX[18] = Instance.new("ImageLabel")
        CHX[18].Image = "rbxassetid://" .. GuiConfig.Theme
        CHX[18].ScaleType = Enum.ScaleType.Crop
        CHX[18].BackgroundTransparency = 1
        CHX[18].ImageTransparency = GuiConfig.ThemeTransparency or 0.15
    else
        CHX[18] = Instance.new("Frame")
        CHX[18].BackgroundColor3 = themeColors.Background
        CHX[18].BackgroundTransparency = 0
    end
    CHX[18].AnchorPoint = Vector2.new(0.5, 0.5)
    CHX[18].BorderSizePixel = 0
    CHX[18].Position = UDim2.new(0.5, 0, 0.5, 0)
    CHX[18].Size = UDim2.new(1, -47, 1, -47)
    CHX[18].Name = "Main"
    CHX[18].Parent = CHX[17]

    -- Chloe.Window.MainCorner
    CHX[19] = Instance.new("UICorner")
    CHX[19].CornerRadius = UDim.new(0, 8)
    CHX[19].Parent = CHX[18]

    -- Chloe.Window.Topbar
    CHX[20] = Instance.new("Frame")
    CHX[20].BackgroundColor3 = themeColors.Topbar
    CHX[20].BackgroundTransparency = 0.2
    CHX[20].BorderSizePixel = 0
    CHX[20].Size = UDim2.new(1, 0, 0, 36)
    CHX[20].Name = "Top"
    CHX[20].Parent = CHX[18]

    CHX[21] = Instance.new("UICorner")
    CHX[21].CornerRadius = UDim.new(0, 8)
    CHX[21].Parent = CHX[20]

    -- Chloe.Window.Title
    CHX[22] = Instance.new("TextLabel")
    CHX[22].Font = Enum.Font.GothamBold
    CHX[22].Text = GuiConfig.Title
    CHX[22].TextColor3 = GuiConfig.Color
    CHX[22].TextSize = 14
    CHX[22].TextXAlignment = Enum.TextXAlignment.Left
    CHX[22].BackgroundTransparency = 1
    CHX[22].Size = UDim2.new(1, -120, 1, 0)
    CHX[22].Position = UDim2.new(0, 12, 0, 0)
    CHX[22].Name = "Title"
    CHX[22].Parent = CHX[20]

    -- Chloe.Window.Footer
    CHX[23] = Instance.new("TextLabel")
    CHX[23].Font = Enum.Font.GothamBold
    CHX[23].Text = GuiConfig.Footer
    CHX[23].TextColor3 = themeColors.SubText
    CHX[23].TextSize = 14
    CHX[23].TextXAlignment = Enum.TextXAlignment.Left
    CHX[23].BackgroundTransparency = 1
    CHX[23].Size = UDim2.new(1, -(CHX[22].TextBounds.X + 140), 1, 0)
    CHX[23].Position = UDim2.new(0, CHX[22].TextBounds.X + 18, 0, 0)
    CHX[23].Name = "Footer"
    CHX[23].Parent = CHX[20]

    -- Chloe.Window.Close
    CHX[24] = Instance.new("TextButton")
    CHX[24].Font = Enum.Font.SourceSans
    CHX[24].Text = ""
    CHX[24].TextColor3 = Color3.fromRGB(255, 255, 255)
    CHX[24].TextSize = 14
    CHX[24].AnchorPoint = Vector2.new(1, 0.5)
    CHX[24].BackgroundTransparency = 1
    CHX[24].Position = UDim2.new(1, -10, 0.5, 0)
    CHX[24].Size = UDim2.new(0, 24, 0, 24)
    CHX[24].Name = "Close"
    CHX[24].Parent = CHX[20]

    CHX[25] = Instance.new("ImageLabel")
    CHX[25].Image = "rbxassetid://9886659671"
    CHX[25].AnchorPoint = Vector2.new(0.5, 0.5)
    CHX[25].BackgroundTransparency = 1
    CHX[25].Position = UDim2.new(0.5, 0, 0.5, 0)
    CHX[25].Size = UDim2.new(1, -4, 1, -4)
    CHX[25].Parent = CHX[24]

    -- Chloe.Window.Minimize
    CHX[26] = Instance.new("TextButton")
    CHX[26].Font = Enum.Font.SourceSans
    CHX[26].Text = ""
    CHX[26].TextColor3 = Color3.fromRGB(255, 255, 255)
    CHX[26].TextSize = 14
    CHX[26].AnchorPoint = Vector2.new(1, 0.5)
    CHX[26].BackgroundTransparency = 1
    CHX[26].Position = UDim2.new(1, -38, 0.5, 0)
    CHX[26].Size = UDim2.new(0, 24, 0, 24)
    CHX[26].Name = "Min"
    CHX[26].Parent = CHX[20]

    CHX[27] = Instance.new("ImageLabel")
    CHX[27].Image = "rbxassetid://9886659276"
    CHX[27].AnchorPoint = Vector2.new(0.5, 0.5)
    CHX[27].BackgroundTransparency = 1
    CHX[27].ImageTransparency = 0.2
    CHX[27].Position = UDim2.new(0.5, 0, 0.5, 0)
    CHX[27].Size = UDim2.new(1, -4, 1, -4)
    CHX[27].Parent = CHX[26]

    -- Chloe.Window.Divider
    CHX[28] = Instance.new("Frame")
    CHX[28].AnchorPoint = Vector2.new(0.5, 0)
    CHX[28].BackgroundColor3 = themeColors.AccentAlt
    CHX[28].BackgroundTransparency = 0.7
    CHX[28].BorderSizePixel = 0
    CHX[28].Position = UDim2.new(0.5, 0, 0, 36)
    CHX[28].Size = UDim2.new(1, -16, 0, 1)
    CHX[28].Parent = CHX[18]

    -- Chloe.Window.LeftTabs
    CHX[29] = Instance.new("Frame")
    CHX[29].BackgroundTransparency = 1
    CHX[29].BorderSizePixel = 0
    CHX[29].Position = UDim2.new(0, 9, 0, 44)
    CHX[29].Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -53)
    CHX[29].Name = "LayersTab"
    CHX[29].Parent = CHX[18]

    CHX[30] = Instance.new("UICorner")
    CHX[30].CornerRadius = UDim.new(0, 4)
    CHX[30].Parent = CHX[29]

    CHX[31] = Instance.new("UIStroke")
    CHX[31].Color = themeColors.Stroke
    CHX[31].Thickness = 1
    CHX[31].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    CHX[31].Parent = CHX[29]

    CHX[32] = Instance.new("ScrollingFrame")
    CHX[32].CanvasSize = UDim2.new(0, 0, 0, 0)
    CHX[32].ScrollBarImageTransparency = 1
    CHX[32].ScrollBarThickness = 0
    CHX[32].Active = true
    CHX[32].BackgroundTransparency = 0.85
    CHX[32].BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    CHX[32].BorderSizePixel = 0
    CHX[32].Size = UDim2.new(1, 0, 1, 0)
    CHX[32].Name = "ScrollTab"
    CHX[32].Parent = CHX[29]

    CHX[33] = Instance.new("UIListLayout")
    CHX[33].Padding = UDim.new(0, 4)
    CHX[33].SortOrder = Enum.SortOrder.LayoutOrder
    CHX[33].Parent = CHX[32]

    local function UpdateTabsCanvas()
        local y = 0
        for _, child in ipairs(CHX[32]:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                y += child.Size.Y.Offset + 4
            end
        end
        CHX[32].CanvasSize = UDim2.new(0, 0, 0, y + 4)
    end

    CHX[32].ChildAdded:Connect(UpdateTabsCanvas)
    CHX[32].ChildRemoved:Connect(UpdateTabsCanvas)

    -- Chloe.Window.RightPanel
    CHX[34]                         = Instance.new("Frame")
    CHX[34].BackgroundTransparency  = 1
    CHX[34].BorderSizePixel         = 0
    CHX[34].Position                = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 44)
    CHX[34].Size                    = UDim2.new(1, -(GuiConfig["Tab Width"] + 27), 1, -53)
    CHX[34].Name                    = "Layers"
    CHX[34].Parent                  = CHX[18]

    -- Chloe.Window.MakeUICorner
    CHX[35]                         = Instance.new("UICorner")
    CHX[35].CornerRadius            = UDim.new(0, 4)
    CHX[35].Parent                  = CHX[34]

    -- Chloe.Window.MakeStroke
    CHX[36]                         = Instance.new("UIStroke")
    CHX[36].Color                   = themeColors.Stroke
    CHX[36].Thickness               = 1
    CHX[36].ApplyStrokeMode         = Enum.ApplyStrokeMode.Border
    CHX[36].Parent                  = CHX[34]

    -- Chloe.Window.MakeTab
    CHX[37]                         = Instance.new("TextLabel")
    CHX[37].Font                    = Enum.Font.GothamBold
    CHX[37].Text                    = ""
    CHX[37].TextColor3              = themeColors.Text
    CHX[37].TextSize                = 20
    CHX[37].TextWrapped             = true
    CHX[37].TextXAlignment          = Enum.TextXAlignment.Left
    CHX[37].BackgroundTransparency  = 1
    CHX[37].Position                = UDim2.new(0, 10, 0, 4)
    CHX[37].Size                    = UDim2.new(1, -20, 0, 26)
    CHX[37].Name                    = "NameTab"
    CHX[37].Parent                  = CHX[34]

    -- Chloe.Window.LayersReal
    CHX[38]                         = Instance.new("Frame")
    CHX[38].AnchorPoint             = Vector2.new(0, 1)
    CHX[38].BackgroundTransparency  = 1
    CHX[38].BorderSizePixel         = 0
    CHX[38].ClipsDescendants        = true
    CHX[38].Position                = UDim2.new(0, 0, 1, 0)
    CHX[38].Size                    = UDim2.new(1, 0, 1, -30)
    CHX[38].Name                    = "LayersReal"
    CHX[38].Parent                  = CHX[34]

    -- Chloe.Window.LayersFolder
    CHX[39]                         = Instance.new("Folder")
    CHX[39].Name                    = "LayersFolder"
    CHX[39].Parent                  = CHX[38]

    --- Chloe.Window.LayersPageLayout
    CHX[40]                         = Instance.new("UIPageLayout")
    CHX[40].SortOrder               = Enum.SortOrder.LayoutOrder
    CHX[40].Name                    = "LayersPageLayout"
    CHX[40].Parent                  = CHX[39]
    CHX[40].TweenTime               = 0.35
    CHX[40].EasingDirection         = Enum.EasingDirection.InOut
    CHX[40].EasingStyle             = Enum.EasingStyle.Quad
    CHX[40].ScrollWheelInputEnabled = false
    CHX[40].TouchInputEnabled       = false
    CHX[40].GamepadInputEnabled     = false

    -- Chloe.WindowObjectFields
    self.GUI                        = CHX[15]
    self.RootHolder                 = CHX[16]
    self.Main                       = CHX[18]
    self.Top                        = CHX[20]
    self.ScrollTab                  = CHX[32]
    self.Layers                     = CHX[34]
    self.NameTab                    = CHX[37]
    self.LayersFolder               = CHX[39]
    self.PageLayout                 = CHX[40]
    self.ToggleKey                  = GuiConfig.ToggleKey
    self.ToggleButton               = nil

    -- Chloe.Window.Draggable
    MakeDraggable(CHX[20], CHX[16])

    -- Chloe.Window.Minimize
    CHX[26].Activated:Connect(function()
        CircleClick(CHX[26], Mouse.X, Mouse.Y)
        self.Visible = false
        CHX[16].Visible = false
    end)

    -- Chloe.Window.Close.Confirm
    CHX[24].Activated:Connect(function()
        CircleClick(CHX[24], Mouse.X, Mouse.Y)

        -- Chloe.Dialog.Overlay
        CHX[41] = Instance.new("Frame")
        CHX[41].Size = UDim2.new(1, 0, 1, 0)
        CHX[41].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        CHX[41].BackgroundTransparency = 0.3
        CHX[41].ZIndex = 50
        CHX[41].Parent = CHX[16]

        -- Chloe.Dialog.Window
        CHX[42] = Instance.new("ImageLabel")
        CHX[42].Size = UDim2.new(0, 300, 0, 150)
        CHX[42].Position = UDim2.new(0.5, -150, 0.5, -75)
        CHX[42].Image = "rbxassetid://9542022979"
        CHX[42].ImageTransparency = 0
        CHX[42].BorderSizePixel = 0
        CHX[42].ZIndex = 51
        CHX[42].Parent = CHX[41]

        CHX[43] = Instance.new("UICorner")
        CHX[43].CornerRadius = UDim.new(0, 8)
        CHX[43].Parent = CHX[42]

        -- Chloe.Dialog.Glow
        CHX[44] = Instance.new("Frame")
        CHX[44].Size = UDim2.new(0, 310, 0, 160)
        CHX[44].Position = UDim2.new(0.5, -155, 0.5, -80)
        CHX[44].BackgroundColor3 = themeColors.AccentAlt
        CHX[44].BackgroundTransparency = 0.75
        CHX[44].BorderSizePixel = 0
        CHX[44].ZIndex = 50
        CHX[44].Parent = CHX[41]

        CHX[45] = Instance.new("UICorner")
        CHX[45].CornerRadius = UDim.new(0, 10)
        CHX[45].Parent = CHX[44]

        CHX[46] = Instance.new("UIGradient")
        CHX[46].Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, themeColors.AccentAlt),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, themeColors.Accent),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1.0, themeColors.AccentAlt),
        })
        CHX[46].Rotation = 90
        CHX[46].Parent = CHX[44]

        -- Chloe.Dialog.Title
        CHX[47] = Instance.new("TextLabel")
        CHX[47].Size = UDim2.new(1, 0, 0, 30)
        CHX[47].Position = UDim2.new(0, 0, 0, 6)
        CHX[47].BackgroundTransparency = 1
        CHX[47].Font = Enum.Font.GothamBold
        CHX[47].Text = "Chloe X Window"
        CHX[47].TextSize = 20
        CHX[47].TextColor3 = Color3.fromRGB(255, 255, 255)
        CHX[47].ZIndex = 52
        CHX[47].Parent = CHX[42]

        -- Chloe.Dialog.Message
        CHX[48] = Instance.new("TextLabel")
        CHX[48].Size = UDim2.new(1, -20, 0, 60)
        CHX[48].Position = UDim2.new(0, 10, 0, 34)
        CHX[48].BackgroundTransparency = 1
        CHX[48].Font = Enum.Font.Gotham
        CHX[48].Text = "Close this window? You can't reopen it without executing again."
        CHX[48].TextSize = 14
        CHX[48].TextColor3 = Color3.fromRGB(210, 210, 210)
        CHX[48].TextWrapped = true
        CHX[48].ZIndex = 52
        CHX[48].Name = "CHX_Message"
        CHX[48].Parent = CHX[42]

        -- Chloe.Dialog.Yes
        CHX[49] = Instance.new("TextButton")
        CHX[49].Name = "CHX_Yes"
        CHX[49].Size = UDim2.new(0.45, -10, 0, 32)
        CHX[49].Position = UDim2.new(0.05, 0, 1, -44)
        CHX[49].BackgroundColor3 = themeColors.Accent
        CHX[49].Text = "Yes"
        CHX[49].Font = Enum.Font.GothamBold
        CHX[49].TextSize = 15
        CHX[49].TextColor3 = Color3.fromRGB(255, 255, 255)
        CHX[49].ZIndex = 52
        CHX[49].Parent = CHX[42]

        CHX[50] = Instance.new("UICorner")
        CHX[50].CornerRadius = UDim.new(0, 6)
        CHX[50].Parent = CHX[49]

        -- Chloe.Dialog.Cancel
        CHX[51] = Instance.new("TextButton")
        CHX[51].Size = UDim2.new(0.45, -10, 0, 32)
        CHX[51].Position = UDim2.new(0.5, 10, 1, -44)
        CHX[51].BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        CHX[51].Text = "Cancel"
        CHX[51].Font = Enum.Font.GothamBold
        CHX[51].TextSize = 15
        CHX[51].TextColor3 = Color3.fromRGB(240, 240, 240)
        CHX[51].ZIndex = 52
        CHX[51].Name = "Cancel"
        CHX[51].Parent = CHX[42]

        CHX[52] = Instance.new("UICorner")
        CHX[52].CornerRadius = UDim.new(0, 6)
        CHX[52].Parent = CHX[51]

        -- Chloe.Dialog.Yes.Action
        CHX[49].MouseButton1Click:Connect(function()
            CHX[15]:Destroy()
            if CoreGui:FindFirstChild("CHX-Button") then
                CoreGui["CHX-Button"]:Destroy()
            end
        end)

        -- Chloe.Dialog.Cancel.Action
        CHX[51].MouseButton1Click:Connect(function()
            if CHX[41] then
                CHX[41]:Destroy()
            end
        end)
    end)

    -- Chloe.Window.ToggleKey
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == self.ToggleKey then
            self.Visible = not self.Visible
            CHX[16].Visible = self.Visible
        end
    end)

    -- Chloe.Window.FloatingButton
    if GuiConfig.Image then
        CHX[53] = Instance.new("ScreenGui")
        CHX[53].Parent = CoreGui
        CHX[53].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        CHX[53].Name = "CHX-Button"

        CHX[54] = Instance.new("ImageLabel")
        CHX[54].Parent = CHX[53]
        CHX[54].Size = UDim2.new(0, 40, 0, 40)
        CHX[54].Position = UDim2.new(0, 20, 0, 120)
        CHX[54].BackgroundTransparency = 1
        CHX[54].Image = "rbxassetid://" .. GuiConfig.Image
        CHX[54].ScaleType = Enum.ScaleType.Fit

        CHX[55] = Instance.new("UICorner")
        CHX[55].CornerRadius = UDim.new(0, 8)
        CHX[55].Parent = CHX[54]

        CHX[56] = Instance.new("UIStroke")
        CHX[56].Color = themeColors.AccentAlt
        CHX[56].Thickness = 1
        CHX[56].Parent = CHX[54]

        CHX[57] = Instance.new("TextButton")
        CHX[57].Parent = CHX[54]
        CHX[57].Size = UDim2.new(1, 0, 1, 0)
        CHX[57].BackgroundTransparency = 1
        CHX[57].Text = ""

        CHX[57].MouseButton1Click:Connect(function()
            CircleClick(CHX[57], Mouse.X, Mouse.Y)
            self.Visible = not self.Visible
            CHX[16].Visible = self.Visible
        end)

        local dragging = false
        local dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            CHX[54].Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        CHX[57].InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = CHX[54].Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)

        self.ToggleButton = CHX[53]
    end

    -- Chloe.Window.LoadConfigElements
    LoadConfigElements()
    function self:ToggleUI()
        if not self._ToggleMade then
            -- Chloe.Window.UIButton.ScreenGui
            CHX[58] = Instance.new("ScreenGui")
            CHX[58].Parent = CoreGui
            CHX[58].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            CHX[58].Name = "CHX-Button-Extra"

            -- Chloe.Window.UIButton.ImageLabel
            CHX[59] = Instance.new("ImageLabel", CHX[58])
            CHX[59].Size = UDim2.new(0, 40, 0, 40)
            CHX[59].Position = UDim2.new(0, 20, 0, 100)
            CHX[59].BackgroundTransparency = 1
            CHX[59].Image = "rbxassetid://" .. tostring(self.GuiConfig.Image or 97167558235554)
            CHX[59].ScaleType = Enum.ScaleType.Fit

            -- Chloe.Window.UIButton.UICorner
            CHX[60] = Instance.new("UICorner")
            CHX[60].CornerRadius = UDim.new(0, 6)
            CHX[60].Parent = CHX[59]

            -- Chloe.Window.UIButton.TextButton
            CHX[61] = Instance.new("TextButton", CHX[59])
            CHX[61].Size = UDim2.new(1, 0, 1, 0)
            CHX[61].BackgroundTransparency = 1
            CHX[61].Text = ""

            CHX[61].MouseButton1Click:Connect(function()
                self.Visible = not self.Visible
                if self.RootHolder then
                    self.RootHolder.Visible = self.Visible
                end
            end)

            -- Chloe.Window.UIButton.Draggable.State
            CHX[62] = false
            CHX[63] = nil
            CHX[64] = nil

            local function update(input)
                local delta = input.Position - CHX[63]
                CHX[59].Position = UDim2.new(
                    CHX[64].X.Scale,
                    CHX[64].X.Offset + delta.X,
                    CHX[64].Y.Scale,
                    CHX[64].Y.Offset + delta.Y
                )
            end

            CHX[61].InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    CHX[62] = true
                    CHX[63] = input.Position
                    CHX[64] = CHX[59].Position

                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            CHX[62] = false
                        end
                    end)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if CHX[62] and (input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)

            self._ToggleMade = true
            self.ToggleUIButton = CHX[58]
        end

        -- Chloe.Window.UIButton.ShowHide
        self.Visible = not self.Visible
        if self.RootHolder then
            self.RootHolder.Visible = self.Visible
        end
    end

    return self
end

return ChloeX
