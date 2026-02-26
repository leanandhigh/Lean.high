local Movement = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

Movement.speedMaster = false
Movement.speedKeyState = false
Movement.speedMode = "CFrame"
Movement.speedValue = 50
Movement.speedConnection = nil
Movement.gyro = nil

Movement.jumpMaster = false
Movement.jumpKeyState = false
Movement.jumpValue = 50

Movement.gravityMaster = false
Movement.gravityKeyState = false
Movement.gravityValue = 196.2

Movement.flyMaster = false
Movement.flyKeyState = false
Movement.flySpeed = 4
Movement.flyConn = nil

Movement.noclipMaster = false
Movement.noclipKeyState = false
Movement.noclipConn = nil

local function getChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
	return getChar():FindFirstChild("HumanoidRootPart")
end

local function getHum()
	return getChar():FindFirstChildWhichIsA("Humanoid")
end

function Movement.stopSpeed()
	if Movement.speedConnection then
		Movement.speedConnection:Disconnect()
		Movement.speedConnection = nil
	end
	if Movement.gyro then
		Movement.gyro:Destroy()
		Movement.gyro = nil
	end
end

function Movement.startSpeed()
	Movement.stopSpeed()
	local hrp = getHRP()
	local hum = getHum()
	if not (hrp and hum) then return end

	if Movement.speedMode == "BodyGyro" then
		Movement.gyro = Instance.new("BodyGyro")
		Movement.gyro.P = 30000
		Movement.gyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
		Movement.gyro.Parent = hrp
	end

	Movement.speedConnection = RunService.Heartbeat:Connect(function(dt)
		if not Movement.speedMaster or not Movement.speedKeyState then return end
		local dir = hum.MoveDirection
		if dir.Magnitude < 0.1 then return end

		if Movement.speedMode == "CFrame" then
			hrp.CFrame = hrp.CFrame + (dir * Movement.speedValue * dt)
		else
			hrp.Velocity = dir * Movement.speedValue
			if Movement.gyro then
				Movement.gyro.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + dir)
			end
		end
	end)
end

function Movement.refreshSpeed()
	if Movement.speedMaster and Movement.speedKeyState then
		Movement.startSpeed()
	else
		Movement.stopSpeed()
	end
end

function Movement.updateJump()
	local hum = getHum()
	if not hum then return end

	if Movement.jumpMaster and Movement.jumpKeyState then
		hum.UseJumpPower = true
		hum.JumpPower = Movement.jumpValue
	else
		hum.JumpPower = 50
	end
end

function Movement.updateGravity()
	workspace.Gravity = (Movement.gravityMaster and Movement.gravityKeyState)
		and Movement.gravityValue or 196.2
end

function Movement.stopFly()
	if Movement.flyConn then
		Movement.flyConn:Disconnect()
		Movement.flyConn = nil
	end
end

function Movement.startFly()
	Movement.stopFly()
	local hrp = getHRP()
	if not hrp then return end

	Movement.flyConn = RunService.Heartbeat:Connect(function()
		if not Movement.flyMaster or not Movement.flyKeyState then return end

		local cam = workspace.CurrentCamera
		local move = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

		hrp.Velocity = move * Movement.flySpeed * 25
	end)
end

function Movement.refreshFly()
	if Movement.flyMaster and Movement.flyKeyState then
		Movement.startFly()
	else
		Movement.stopFly()
	end
end

function Movement.stopNoclip()
	if Movement.noclipConn then
		Movement.noclipConn:Disconnect()
		Movement.noclipConn = nil
	end
end

function Movement.startNoclip()
	Movement.stopNoclip()
	Movement.noclipConn = RunService.Stepped:Connect(function()
		if not Movement.noclipMaster or not Movement.noclipKeyState then return end
		for _, part in pairs(getChar():GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
end

function Movement.refreshNoclip()
	if Movement.noclipMaster and Movement.noclipKeyState then
		Movement.startNoclip()
	else
		Movement.stopNoclip()
	end
end

return Movement
