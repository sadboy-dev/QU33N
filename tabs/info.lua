-- tabs/info.lua
-- Info Tab (static)

return function(gui)

    -- ambil tab / page Info yang sudah kamu buat di GUI utama
    local page = gui.Pages and gui.Pages:FindFirstChild("Info")
    if not page then
        warn("[INFO] Page not found")
        return
    end

    local function addLabel(text, y)
        local lbl = Instance.new("TextLabel")
        lbl.Parent = page
        lbl.Size = UDim2.new(1, -20, 0, 24)
        lbl.Position = UDim2.new(0, 10, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.TextWrapped = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.Text = text
        return lbl
    end

    local y = 20

    addLabel("QU33N Script", y); y += 30
    addLabel("Version : v1.0.0", y); y += 24
    addLabel("Status  : Development", y); y += 24
    addLabel("Game    : FishIt", y); y += 30

    addLabel("Features:", y); y += 24
    addLabel("- Modular Tabs", y); y += 22
    addLabel("- Blatant V1 (Stable)", y); y += 22
    addLabel("- GUI Separated From Engine", y); y += 22

    y += 20
    addLabel("Author  : sadboy-dev", y); y += 24
    addLabel("UI Name : QU33N", y); y += 24

end

