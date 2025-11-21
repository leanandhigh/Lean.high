local Hooked = {}
local Detected, Kill
local FoundAC = false
if getgenv().AdonisBypassEnabled then
    setthreadidentity(2)
    for i, v in getgc(true) do
        if typeof(v) == "table" then
            local DetectFunc = rawget(v, "Detected")
            local KillFunc = rawget(v, "Kill")

            if typeof(DetectFunc) == "function" and not Detected then
                Detected = DetectFunc
                FoundAC = true

                Library:Notification("Adonis Bypass", "AntiCheat Detected! Bypass Activated.", 5)

                local Old
                Old = hookfunction(Detected, function(Action, Info, NoCrash)
                    return true
                end)
                table.insert(Hooked, Detected)
            end
            if rawget(v, "Variables") and rawget(v, "Process") and typeof(KillFunc) == "function" and not Kill then
                Kill = KillFunc

                local Old
                Old = hookfunction(Kill, function(Info)
                end)
                table.insert(Hooked, Kill)
            end
        end
    end
    if Detected then
        local Old
        Old = hookfunction(getrenv().debug.info, newcclosure(function(...)
            local LevelOrFunc = ...
            if LevelOrFunc == Detected then
                return coroutine.yield(coroutine.running())
            end
            return Old(...)
        end))
    else
        Library:Notification("Adonis Bypass", "No AntiCheat Detected. Nothing to bypass.", 5)
    end
    setthreadidentity(7)
end
