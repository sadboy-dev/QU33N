-- tabs/info.lua

local UI = _G.QU33N
if not UI then return end

local page = UI.Pages.Info
local Theme = UI.Theme

-- Scroll
local scroll = Instance.new("ScrollingFrame", page)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,600)
scroll.ScrollBarImageTransparency = 1
scroll.BackgroundTransparency = 1

-- Card
local card = Instance.new("Frame", scroll)
card.Size = UDim2.new(1,-10,0,140)
card.Position = UDim2.new(0,5,0,10)
card.BackgroundColor3 = Theme.Panel
Instance.new("UICorner", card).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", card)
title.Text = "Chloe X Information"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Theme.Accent
title.BackgroundTransparency = 1
title.Position = UDim2.new(0,14,0,12)
title.Size = UDim2.new(1,-28,0,24)
title.TextXAlignment = Enum.TextXAlignment.Left
