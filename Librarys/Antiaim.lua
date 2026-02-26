local AntiAim = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Network = game:GetService("NetworkClient")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

AntiAim.Settings = {
    Enabled = false,
    YawBase = "camera",
    YawOffset = 0,
    Modifier = "none",
    ModifierOffset = 0,
    SpinSpeed = 360
}

AntiAim.JitterToggle = false

AntiAim.Fakelag = {
    Enabled = false,
    Method = "static",
    Limit = 6,
    FreezeWorld = false,
    Tick = 0,
    Active = false
}

AntiAim.Visualize = {
    Enabled = false,
    Color = Color3.fromRGB(255,0,255),
    Transparency = 0.65,
    SizeBoost = Vector3.new(0.04,0.04,0.04)
}

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")

    if not (AntiAim.Settings.Enabled and char and root and hum) then
        if hum then hum.AutoRotate = true end
        return
    end

    hum.AutoRotate = false

    local baseAngle

    if AntiAim.Settings.YawBase == "camera" then
        baseAngle = -math.atan2(Camera.CFrame.LookVector.Z,Camera.CFrame.LookVector.X)+math.rad(-90)
    elseif AntiAim.Settings.YawBase == "random" then
        baseAngle = math.rad(math.random(0,360))
    elseif AntiAim.Settings.YawBase == "spin" then
        baseAngle = math.rad((tick()*AntiAim.Settings.SpinSpeed)%360)
    else
        baseAngle = -math.atan2(Camera.CFrame.LookVector.Z,Camera.CFrame.LookVector.X)+math.rad(-90)
    end

    AntiAim.JitterToggle = not AntiAim.JitterToggle

    local modifierOffset = 0
    if AntiAim.JitterToggle then
        if AntiAim.Settings.Modifier == "jitter" or AntiAim.Settings.Modifier == "offset jitter" then
            modifierOffset = math.rad(AntiAim.Settings.ModifierOffset)
        end
    end

    local finalAngle = baseAngle + math.rad(AntiAim.Settings.YawOffset) + modifierOffset
    root.CFrame = CFrame.new(root.Position)*CFrame.Angles(0,finalAngle,0)
end)

task.spawn(function()
    while true do
        task.wait(1/16)

        local char = LocalPlayer.Character
        if not char then
            task.wait(0.3)
            continue
        end

        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum or hum.Health <= 0 then
            local old = char:FindFirstChild("Fakelag")
            if old then old:Destroy() end
            Network:SetOutgoingKBPSLimit(9e9)
            AntiAim.Fakelag.Tick = 0
            continue
        end

        AntiAim.Fakelag.Tick += 1

        local shouldChoke = AntiAim.Fakelag.Active and AntiAim.Fakelag.Enabled
        local maxTick = AntiAim.Fakelag.Method == "static"
            and AntiAim.Fakelag.Limit
            or math.random(1,AntiAim.Fakelag.Limit)

        local isChoking = shouldChoke and AntiAim.Fakelag.Tick < maxTick

        if isChoking then
            Network:SetOutgoingKBPSLimit(1)
        else
            Network:SetOutgoingKBPSLimit(9e9)
            AntiAim.Fakelag.Tick = 0

            if AntiAim.Visualize.Enabled then
                local oldFolder = char:FindFirstChild("Fakelag")
                if oldFolder then oldFolder:Destroy() end

                local folder = Instance.new("Folder")
                folder.Name = "Fakelag"
                folder.Parent = char

                char.Archivable = true
                local clone = char:Clone()

                for _,obj in clone:GetDescendants() do
                    if obj:IsA("Humanoid")
                        or obj:IsA("LocalScript")
                        or obj:IsA("Script")
                        or obj.Name == "HumanoidRootPart" then
                        obj:Destroy()
                    elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
                        if obj.Transparency >= 0.99 then
                            obj:Destroy()
                        else
                            obj.Anchored = true
                            obj.CanCollide = false
                            obj.Material = Enum.Material.ForceField
                            obj.Color = AntiAim.Visualize.Color
                            obj.Transparency = AntiAim.Visualize.Transparency
                            obj.Size += AntiAim.Visualize.SizeBoost
                        end
                    end
                end

                clone.Parent = folder
            end
        end
    end
end)

return AntiAim
