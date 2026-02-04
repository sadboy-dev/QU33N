--// STEP 1 (FIXED) - FIND BAIT CAST REMOTE
--// Partial match | Delta Mobile safe

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- FILE
--------------------------------------------------
local FOLDER = "DeltaLogs"
local FILE = FOLDER .. "/Step1_BaitCast_FIXED.txt"

if makefolder and not isfolder(FOLDER) then
    makefolder(FOLDER)
end
if writefile and not isfile(FILE) then
    writefile(FILE, "=== STEP 1 BAIT CAST (FIXED) ===\n")
end

local function save(txt)
    if appendfile then
        appendfile(FILE, txt .. "\n")
    end
end

local function log(txt)
    print("[STEP1]", txt)
    save("[STEP1] " .. txt)
end

log("Scanning RemoteEvents (partial match)...")

--------------------------------------------------
-- SCAN ALL REMOTES
--------------------------------------------------
local foundAny = false

for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
    if r:IsA("RemoteEvent") then
        local lname = r.Name:lower()
        local full = r:GetFullName():lower()

        -- PARTIAL MATCH (INI KUNCINYA)
        if lname:find("bait") or lname:find("cast")
        or full:find("baitcast") then

            foundAny = true
            log("FOUND REMOTE: " .. r:GetFullName())

            r.OnClientEvent:Connect(function(...)
                local args = {...}
                if args[1] == LocalPlayer then
                    log("REMOTE FIRED by LocalPlayer -> " .. r.Name)
                else
                    log("REMOTE FIRED -> " .. r.Name)
                end
            end)
        end
    end
end

if not foundAny then
    log("NO BAIT/CAST RELATED REMOTE FOUND")
else
    log("Waiting for cast...")
end
