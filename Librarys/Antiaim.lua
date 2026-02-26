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

return AntiAim
