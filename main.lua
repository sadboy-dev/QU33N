-- main.lua
local BASE = "https://raw.githubusercontent.com/sadboy-dev/QU33N/main/"

local function load(path)
	return loadstring(game:HttpGet(BASE .. path))()
end

-- 1. LOAD GUI PERTAMA
load("home/gui.lua")

-- 2. LOAD TAB CONTENT
load("tabs/info.lua")
load("tabs/fishing.lua")
load("tabs/auto.lua")
load("tabs/teleport.lua")
load("tabs/misc.lua")
load("tabs/webhook.lua")

-- 3. DEFAULT TAB
task.wait()
if _G.SelectTab then
	_G.SelectTab("Info")
end
