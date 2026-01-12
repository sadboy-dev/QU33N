-- loader.lua
-- Version check + error handler + cache

local HttpService = game:GetService("HttpService")

local MAIN_URL    = "https://raw.githubusercontent.com/sadboy-dev/QU33N/main/main.lua"
local VERSION_URL = "https://raw.githubusercontent.com/sadboy-dev/QU33N/main/version.txt"

local CURRENT_VERSION = "1.0.0"
local CACHE_KEY = "QU33N_MAIN_CACHE"

-- =========================
-- UTIL
-- =========================

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function safeGet(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if ok then
        return res
    end
end

-- =========================
-- VERSION CHECK
-- =========================

do
    local remote = safeGet(VERSION_URL)
    if remote then
        remote = trim(remote)
        if remote ~= "" and remote ~= CURRENT_VERSION then
            warn("[QU33N] New version available:", remote, "(current:", CURRENT_VERSION .. ")")
        end
    end
end

-- =========================
-- LOAD WITH CACHE
-- =========================

local source

-- try cache
local ok, cached = pcall(function()
    return HttpService:GetAsync(CACHE_KEY)
end)

if ok and cached and cached ~= "" then
    source = cached
else
    -- fetch remote
    source = safeGet(MAIN_URL)
    if source then
        pcall(function()
            HttpService:SetAsync(CACHE_KEY, source)
        end)
    else
        error("[QU33N] Failed to load main.lua (no cache, no remote)")
    end
end

-- =========================
-- EXECUTE SAFELY
-- =========================

local success, err = pcall(function()
    loadstring(source)()
end)

if not success then
    warn("[QU33N] Runtime error in main.lua")
    warn(err)
end
