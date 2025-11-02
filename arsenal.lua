local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local SEARCH_RADIUS = 200
local FOV_DEGREES = 110
local AIM_SMOOTH = 16
local MAX_ALPHA_PER_FRAME = 0.8
local RAYCAST_PARAMS = RaycastParams.new()
RAYCAST_PARAMS.FilterType = Enum.RaycastFilterType.Blacklist
RAYCAST_PARAMS.IgnoreWater = true

local mode = "FFA"
local targetPartName = "Torso"
local aimEnabled = true
local guiVisible = true
local fovVisible = true

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimAssistUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 220, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 110)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -12, 0, 28)
title.Position = UDim2.new(0, 6, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Aim Assist - Dev"
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local modeBtn = Instance.new("TextButton")
modeBtn.Name = "ModeBtn"
modeBtn.Size = UDim2.new(0.48, -8, 0, 38)
modeBtn.Position = UDim2.new(0, 6, 0, 46)
modeBtn.Text = "Mode: FFA"
modeBtn.Font = Enum.Font.SourceSans
modeBtn.TextSize = 14
modeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
modeBtn.TextColor3 = Color3.fromRGB(225, 225, 225)
modeBtn.Parent = mainFrame

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 8)
modeCorner.Parent = modeBtn

local partBtn = Instance.new("TextButton")
partBtn.Name = "PartBtn"
partBtn.Size = UDim2.new(0.48, -8, 0, 38)
partBtn.Position = UDim2.new(0.5, 2, 0, 46)
partBtn.Text = "Target: Torso"
partBtn.Font = Enum.Font.SourceSans
partBtn.TextSize = 14
partBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
partBtn.TextColor3 = Color3.fromRGB(225, 225, 225)
partBtn.Parent = mainFrame

local partCorner = Instance.new("UICorner")
partCorner.CornerRadius = UDim.new(0, 8)
partCorner.Parent = partBtn

local aimBtn = Instance.new("TextButton")
aimBtn.Name = "AimBtn"
aimBtn.Size = UDim2.new(1, -12, 0, 38)
aimBtn.Position = UDim2.new(0, 6, 0, 92)
aimBtn.Text = "Aim: ON"
aimBtn.Font = Enum.Font.SourceSans
aimBtn.TextSize = 14
aimBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
aimBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
aimBtn.Parent = mainFrame

local aimCorner = Instance.new("UICorner")
aimCorner.CornerRadius = UDim.new(0, 8)
aimCorner.Parent = aimBtn

local fovBtn = Instance.new("TextButton")
fovBtn.Name = "FovBtn"
fovBtn.Size = UDim2.new(0.48, -8, 0, 38)
fovBtn.Position = UDim2.new(0, 6, 0, 138)
fovBtn.Text = "FOV: ON"
fovBtn.Font = Enum.Font.SourceSans
fovBtn.TextSize = 14
fovBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
fovBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
fovBtn.Parent = mainFrame

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 8)
fovCorner.Parent = fovBtn

local fovInput = Instance.new("TextBox")
fovInput.Name = "FovInput"
fovInput.Size = UDim2.new(0.48, -8, 0, 38)
fovInput.Position = UDim2.new(0.5, 2, 0, 138)
fovInput.BackgroundTransparency = 0
fovInput.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
fovInput.TextColor3 = Color3.fromRGB(225, 225, 225)
fovInput.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
fovInput.Text = tostring(FOV_DEGREES)
fovInput.Font = Enum.Font.SourceSans
fovInput.TextSize = 14
fovInput.Parent = mainFrame

local fovInputCorner = Instance.new("UICorner")
fovInputCorner.CornerRadius = UDim.new(0, 8)
fovInputCorner.Parent = fovInput

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -12, 0, 16)
infoLabel.Position = UDim2.new(0, 6, 1, -22)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 12
infoLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
infoLabel.Text = "Solo para tu juego/pruebas."
infoLabel.Parent = mainFrame

local toggleFrame = Instance.new("Frame")
toggleFrame.Name = "ToggleFrame"
toggleFrame.Size = UDim2.new(0, 56, 0, 56)
toggleFrame.Position = UDim2.new(0, 10, 0, 40)
toggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
toggleFrame.BorderSizePixel = 0
toggleFrame.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleFrame

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(1, 0, 1, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "A"
toggleLabel.Font = Enum.Font.SourceSansBold
toggleLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
toggleLabel.TextScaled = true
toggleLabel.Parent = toggleFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 1, 0)
toggleButton.BackgroundTransparency = 1
toggleButton.Text = ""
toggleButton.Parent = toggleFrame

local fovCircle = Instance.new("Frame")
fovCircle.Name = "FovCircle"
fovCircle.Size = UDim2.new(0, 2 * FOV_DEGREES, 0, 2 * FOV_DEGREES)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovCircle.BackgroundTransparency = 0.9
fovCircle.BorderSizePixel = 2
fovCircle.BorderColor3 = Color3.fromRGB(220, 80, 80)
fovCircle.Visible = fovVisible
fovCircle.Parent = screenGui

local fovCircleCorner = Instance.new("UICorner")
fovCircleCorner.CornerRadius = UDim.new(1, 0)
fovCircleCorner.Parent = fovCircle

modeBtn.Activated:Connect(function()
    if mode == "FFA" then
        mode = "Teams"
        modeBtn.Text = "Mode: Teams"
    else
        mode = "FFA"
        modeBtn.Text = "Mode: FFA"
    end
end)

partBtn.Activated:Connect(function()
    if targetPartName == "Torso" then
        targetPartName = "Head"
        partBtn.Text = "Target: Head"
    else
        targetPartName = "Torso"
        partBtn.Text = "Target: Torso"
    end
end)

aimBtn.Activated:Connect(function()
    aimEnabled = not aimEnabled
    aimBtn.Text = aimEnabled and "Aim: ON" or "Aim: OFF"
end)

fovBtn.Activated:Connect(function()
    fovVisible = not fovVisible
    fovBtn.Text = fovVisible and "FOV: ON" or "FOV: OFF"
    fovCircle.Visible = fovVisible
end)

fovInput.FocusLost:Connect(function(enterPressed)
    local newFov = tonumber(fovInput.Text)
    if newFov and newFov >= 1 then
        FOV_DEGREES = math.floor(newFov)
        fovInput.Text = tostring(FOV_DEGREES)
        fovCircle.Size = UDim2.new(0, 2 * FOV_DEGREES, 0, 2 * FOV_DEGREES)
    else
        fovInput.Text = tostring(FOV_DEGREES)
    end
end)

local function toggleGui()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
    toggleLabel.TextColor3 = guiVisible and Color3.fromRGB(220, 80, 80) or Color3.fromRGB(100, 100, 100)
end

toggleButton.Activated:Connect(toggleGui)

mainFrame.Visible = guiVisible
toggleLabel.TextColor3 = guiVisible and Color3.fromRGB(220, 80, 80) or Color3.fromRGB(100, 100, 100)

local function getCandidates()
    local list = {}
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("Humanoid") and pl.Character.Humanoid.Health > 0 then
            table.insert(list, {type="player", player=pl, char=pl.Character})
        end
    end
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model ~= LocalPlayer.Character then
            if not model:FindFirstChild("Player") then
                if model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso") then
                    table.insert(list, {type="npc", char=model})
                end
            end
        end
    end
    return list
end

local function angleToTarget(targetPos)
    local camPos = Camera.CFrame.Position
    local lookVec = Camera.CFrame.LookVector
    local dir = (targetPos - camPos)
    if dir.Magnitude == 0 then return 180 end
    dir = dir.Unit
    local dot = math.clamp(lookVec:Dot(dir), -1, 1)
    return math.deg(math.acos(dot))
end

local function hasLineOfSight(fromPos, targetPart)
    if not targetPart or not targetPart.Position then return false end
    RAYCAST_PARAMS.FilterDescendantsInstances = {LocalPlayer.Character}
    local direction = targetPart.Position - fromPos
    local result = workspace:Raycast(fromPos, direction, RAYCAST_PARAMS)
    if not result then
        return true
    end
    if result.Instance and targetPart and result.Instance:IsDescendantOf(targetPart.Parent) then
        return true
    end
    return false
end

local function findBestTarget()
    local camPos = Camera.CFrame.Position
    local candidates = getCandidates()
    local best = nil
    local bestDist = math.huge
    for _, item in pairs(candidates) do
        local char = item.char
        if char and char.Parent then
            if mode == "Teams" and item.type == "player" then
                if LocalPlayer.Team and item.player.Team and LocalPlayer.Team == item.player.Team then
                    continue
                end
            end
            local part = char:FindFirstChild(targetPartName)
                       or char:FindFirstChild("UpperTorso")
                       or char:FindFirstChild("Torso")
                       or char:FindFirstChild("HumanoidRootPart")
                       or char:FindFirstChild("Head")
            if part and part.Position then
                local dist = (part.Position - camPos).Magnitude
                if dist <= SEARCH_RADIUS then
                    local ang = angleToTarget(part.Position)
                    if ang <= (FOV_DEGREES/2) then
                        if hasLineOfSight(camPos, part) then
                            if dist < bestDist then
                                bestDist = dist
                                best = {char = char, part = part, dist = dist}
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function lookAtPositionSmooth(targetPos, dt)
    if not targetPos then return end
    local cam = Camera
    local camPos = cam.CFrame.Position
    local desired = CFrame.new(camPos, targetPos)
    local alpha = math.clamp(dt * AIM_SMOOTH, 0, MAX_ALPHA_PER_FRAME)
    cam.CFrame = cam.CFrame:Lerp(desired, alpha)
end

local lastTick = tick()
RunService:BindToRenderStep("AimAssistRender", Enum.RenderPriority.Character.Value, function()
    local now = tick()
    local dt = now - lastTick
    lastTick = now

    if not aimEnabled then return end

    local best = findBestTarget()
    if best then
        lookAtPositionSmooth(best.part.Position, dt)
    end
end)

local function cleanup()
    if RunService:IsBoundToRenderStep("AimAssistRender") then
        RunService:UnbindFromRenderStep("AimAssistRender")
    end
end

LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer:IsDescendantOf(game) then
        cleanup()
    end
end)

game:BindToClose(function()
    cleanup()
end)