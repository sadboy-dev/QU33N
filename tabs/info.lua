-- tabs/info.lua

local gui = _G.QU33N_GUI
if not gui then return end

local page = gui.Pages.Info
if not page then return end

local label = Instance.new("TextLabel")
label.Parent = page
label.Text = "Welcome to QU33N"
label.Font = Enum.Font.GothamBold
label.TextSize = 20
label.TextColor3 = Color3.fromRGB(255,255,255)
label.BackgroundTransparency = 1
label.Size = UDim2.new(1,0,0,40)
