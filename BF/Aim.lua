-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local FollowButton = Instance.new("TextButton")
local StopFollowButton = Instance.new("TextButton")
local ChangeTargetButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local TargetLabel = Instance.new("TextLabel")
local ShowHideButton = Instance.new("TextButton")

-- Propiedades GUI
ScreenGui.Name = "AdonisExceptGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Adonis Except"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextStrokeTransparency = 0
Title.TextSize = 20

FollowButton.Name = "FollowButton"
FollowButton.Parent = MainFrame
FollowButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
FollowButton.Size = UDim2.new(0.8, 0, 0, 25)
FollowButton.Position = UDim2.new(0.1, 0, 0.2, 0)
FollowButton.Text = "Seguir Jugador"
FollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FollowButton.TextSize = 14

StopFollowButton.Name = "StopFollowButton"
StopFollowButton.Parent = MainFrame
StopFollowButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
StopFollowButton.Size = UDim2.new(0.8, 0, 0, 25)
StopFollowButton.Position = UDim2.new(0.1, 0, 0.4, 0)
StopFollowButton.Text = "Parar de Seguir"
StopFollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopFollowButton.TextSize = 14

ChangeTargetButton.Name = "ChangeTargetButton"
ChangeTargetButton.Parent = MainFrame
ChangeTargetButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ChangeTargetButton.Size = UDim2.new(0.8, 0, 0, 25)
ChangeTargetButton.Position = UDim2.new(0.1, 0, 0.6, 0)
ChangeTargetButton.Text = "Cambiar Jugador"
ChangeTargetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeTargetButton.TextSize = 14

TargetLabel.Name = "TargetLabel"
TargetLabel.Parent = MainFrame
TargetLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TargetLabel.Size = UDim2.new(1, 0, 0, 25)
TargetLabel.Position = UDim2.new(0, 0, 0.8, 0)
TargetLabel.Font = Enum.Font.SourceSans
TargetLabel.Text = "Siguiendo: Ninguno"
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.TextSize = 14

-- Botón de Mostrar/Ocultar GUI
ShowHideButton.Name = "ShowHideButton"
ShowHideButton.Parent = ScreenGui
ShowHideButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ShowHideButton.BorderSizePixel = 3
ShowHideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ShowHideButton.Size = UDim2.new(0, 100, 0, 25)
ShowHideButton.Position = UDim2.new(0.5, -50, 0, 10)
ShowHideButton.Text = "Mostrar/Ocultar GUI"
ShowHideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowHideButton.TextSize = 14

-- Variables de seguimiento
local isFollowing = false
local followTarget = nil
local guiVisible = true

-- Funciones
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

local function followPlayer()
    if followTarget and followTarget.Character and followTarget.Character:FindFirstChild("HumanoidRootPart") then
        RunService:BindToRenderStep("FollowPlayer", Enum.RenderPriority.Camera.Value, function()
            if followTarget.Character and followTarget.Character:FindFirstChild("HumanoidRootPart") then
                -- Centramos la cámara en el torso del jugador seguido
                local targetPosition = followTarget.Character.HumanoidRootPart.Position
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition + Vector3.new(0, -10, 0))
            end
        end)
    end
end

local function stopFollowing()
    isFollowing = false
    followTarget = nil
    TargetLabel.Text = "Siguiendo: Ninguno"
    RunService:UnbindFromRenderStep("FollowPlayer")
end

-- Eventos
FollowButton.MouseButton1Click:Connect(function()
    if not isFollowing then
        followTarget = getClosestPlayer()
        if followTarget then
            isFollowing = true
            TargetLabel.Text = "Siguiendo: " .. followTarget.Name
            followPlayer()
        end
    end
end)

StopFollowButton.MouseButton1Click:Connect(stopFollowing)

ChangeTargetButton.MouseButton1Click:Connect(function()
    if isFollowing then
        followTarget = getClosestPlayer()
        if followTarget then
            TargetLabel.Text = "Siguiendo: " .. followTarget.Name
        end
    end
end)

ShowHideButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    MainFrame.Visible = guiVisible
end)