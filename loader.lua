-- loader.lua
-- Loader dengan version check sederhana

local MAIN_URL    = "https://raw.githubusercontent.com/sadboy-dev/QU33N/main/main.lua"
local VERSION_URL = "https://raw.githubusercontent.com/sadboy-dev/QU33N/main/version.txt"

local CURRENT_VERSION = "1.0.0"

local function fetch(url)
    return game:HttpGet(url)
end

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- cek versi
local ok, remoteVersion = pcall(function()
    return trim(fetch(VERSION_URL))
end)

if ok and remoteVersion ~= "" and remoteVersion ~= CURRENT_VERSION then
    warn("[QU33N] New version available:", remoteVersion, "(current:", CURRENT_VERSION .. ")")
end

-- load main
local source = fetch(MAIN_URL)
loadstring(source)()

