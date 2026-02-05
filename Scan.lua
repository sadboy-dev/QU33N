--// DELTA MOBILE - SMART REMOTE SCANNER
--// Auto find sleitnick_net RemoteEvents
--// No hardcoded path | Delta safe

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function log(...)
    print("[DELTA]", ...)
end

log("Scanning RemoteEvents...")

-- ===============================
-- SCAN ALL REMOTES
-- ===============================
local Found = {}

for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        local full = obj:GetFullName()

        -- filter sleitnick_net (sesuai log kamu)
        if full:lower():find("sleitnick") or full:lower():find("net") then
            table.insert(Found, obj)

            log("FOUND REMOTE:", full)

            obj.OnClientEvent:Connect(function(...)
                log("[REMOTE RECEIVE]", obj.Name)

                for i, v in ipairs({...}) do
                    if typeof(v) == "Instance" then
                        log(" Arg", i, v:GetFullName())
                    else
                        log(" Arg", i, v)
                    end
                end
            end)
        end
    end
end

log("Total hooked remotes:", #Found)

-- ===============================
-- FISHING HEURISTIC
-- ===============================
for _, r in ipairs(Found) do
    if r.Name:lower():find("Fishing") then
        r.OnClientEvent:Connect(function(player, bait, pos)
            if player == LocalPlayer then
                log("Fishing detected:", bait, pos)
            end
        end)
    end

    if r.Name:lower():find("fish") then
        r.OnClientEvent:Connect(function(...)
            log("Fish related remote fired:", r.Name)
        end)
    end
end

log("Remote scanner ready")
