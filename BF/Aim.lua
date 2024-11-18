-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local following = false
local targetPlayer = nil

-- Creación de GUI
local ScreenGui = Instance.new("ScreenGui")
local TitleLabel = Instance.new("TextLabel")
local FollowButton = Instance.new("TextButton")
local ChangeButton = Instance.new("TextButton")
local PlayerLabel = Instance.new("TextLabel")

-- Configuración de ScreenGui
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "AdonisExceptGui"

-- Configuración del título "Adonis Except"
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = ScreenGui
TitleLabel.Text = "<font color=\"rgb(255, 255, 255)\">Adonis</font> <font color=\"rgb(255, 85, 85)\">Except</font>"
TitleLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
TitleLabel.Position = UDim2.new(0.25, 0, 0.1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.RichText = true
TitleLabel.Font = Enum.Font.SourceSansBold

-- Configuración del botón "Seguir"
FollowButton.Name = "FollowButton"
FollowButton.Parent = ScreenGui
FollowButton.Text = "Seguir/Detener"
FollowButton.Size = UDim2.new(0.4, 0, 0.1, 0)
FollowButton.Position = UDim2.new(0.05, 0, 0.3, 0)
FollowButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
FollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FollowButton.Font = Enum.Font.SourceSansBold
FollowButton.TextSize = 20

-- Configuración del botón "Cambiar"
ChangeButton.Name = "ChangeButton"
ChangeButton.Parent = ScreenGui
ChangeButton.Text = "Cambiar Jugador"
ChangeButton.Size = UDim2.new(0.4, 0, 0.1, 0)
ChangeButton.Position = UDim2.new(0.55, 0, 0.3, 0)
ChangeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
ChangeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeButton.Font = Enum.Font.SourceSansBold
ChangeButton.TextSize = 20

-- Configuración del Label para mostrar el jugador seguido
PlayerLabel.Name = "PlayerLabel"
PlayerLabel.Parent = ScreenGui
PlayerLabel.Text = "Jugador seguido: Ninguno"
PlayerLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
PlayerLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
PlayerLabel.BackgroundTransparency = 1
PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerLabel.Font = Enum.Font.SourceSansBold
PlayerLabel.TextSize = 18
PlayerLabel.TextScaled = true

-- Función para encontrar al jugador más cercano
local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = player.Character.HumanoidRootPart.Position
            local distance = (localPlayer.Character.HumanoidRootPart.Position - playerPosition).magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

-- Función para seguir al jugador objetivo
local function followPlayer()
    if following and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        camera.CameraType = Enum.CameraType.Scriptable
        RunService.RenderStepped:Connect(function()
            if following and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPart = targetPlayer.Character.HumanoidRootPart
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
            end
        end)
    end
end

-- Actualizar la etiqueta del jugador seguido
local function updatePlayerLabel()
    if targetPlayer then
        PlayerLabel.Text = "Jugador seguido: " .. targetPlayer.Name
    else
        PlayerLabel.Text = "Jugador seguido: Ninguno"
    end
end

-- Evento para activar/desactivar el seguimiento
FollowButton.MouseButton1Click:Connect(function()
    if not following then
        targetPlayer = getClosestPlayer()
        if targetPlayer then
            following = true
            updatePlayerLabel()
            followPlayer()
        end
    else
        following = false
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = localPlayer.Character:FindFirstChild("Humanoid")
        targetPlayer = nil
        updatePlayerLabel()
    end
end)

-- Evento para cambiar de jugador
ChangeButton.MouseButton1Click:Connect(function()
    if following then
        targetPlayer = getClosestPlayer()
        if targetPlayer then
            updatePlayerLabel()
            followPlayer()
        end
    end
end)