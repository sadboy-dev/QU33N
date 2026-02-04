--// STEP 2 (FIXED) - PLAY FISHING EFFECT
--// Partial match | Delta Mobile safe

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- FILE
--------------------------------------------------
local FOLDER = "DeltaLogs"
local FILE = FOLDER .. "/Step2_PlayFishingEffect_FIXED.txt"

if makefolder and not isfolder(FOLDER) then
    makefolder(FOLDER)
end
if writefile and not isfile(FILE) then
    writefile(FILE, "=== STEP 2 PLAYFISHINGEFFECT (FIXED) ===\n")
end

local function save(txt)
    if appendfile then
        appendfile(FILE, txt .. "\n")
    end
end

local function log(txt)
    print("[STEP2]", txt)
    save("[STEP2] " .. txt)
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

        -- PARTIAL MATCH (KUNCI)
        if lname:find("fish")
        or lname:find("effect")
        or full:find("playfishing") then

            foundAny = true
            log("FOUND REMOTE: " .. r:GetFullName())

            r.OnClientEvent:Connect(function(...)
                local args = {...}
                log("REMOTE FIRED -> " .. r.Name)

                for i, v in ipairs(args) do
                    if typeof(v) == "Instance" then
                        log(" Arg " .. i .. " = Instance | " .. v:GetFullName())
                    else
                        log(" Arg " .. i .. " = " .. tostring(v))
                    end
                end

                save("--------------------------------")
            end)
        end
    end
end

if not foundAny then
    log("NO FISH/EFFECT REMOTE FOUND")
else
    log("Waiting for fishing effect...")
end
