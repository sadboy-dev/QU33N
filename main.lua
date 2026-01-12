-- main.lua
-- QU33N main entry
-- GUI SUDAH ADA, STRUKTUR & TAMPILAN TIDAK DIUBAH

local BASE = "https://raw.githubusercontent.com/sadboy-dev/QU33N/main/"

local function load(file)
    return loadstring(game:HttpGet(BASE .. file))()
end

-- =========================
-- LOAD GUI (GUI FINAL PUNYA KAMU)
-- =========================
-- diasumsikan gui dibuat di sini dan expose global / return value
pcall(function()
    load("home/gui.lua")
end)

-- =========================
-- LOAD TABS (CONTENT ONLY)
-- =========================
pcall(function()
    load("tabs/info.lua")
end)

pcall(function()
    load("tabs/blatant.lua")
end)

pcall(function()
    load("tabs/fishing.lua")
end)

pcall(function()
    load("tabs/misc.lua")
end)

-- =========================
-- LOAD ENGINE (LOGIC ONLY)
-- =========================
pcall(function()
    load("engine/blatant_v1.lua")
end)

pcall(function()
    load("engine/recovery.lua")
end)

-- =========================
-- SET DEFAULT TAB = INFO
-- =========================
pcall(function()
    if typeof(_G.SelectTab) == "function" then
        _G.SelectTab("Info")
    elseif typeof(_G.OpenPage) == "function" then
        _G.OpenPage("Info")
    end
end)
