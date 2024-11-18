-- Variables principales
local guiVisible = true
local targetPlayer = nil
local following = false

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Botón para mostrar/ocultar GUI
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0.5, -50, 0.8, 0)
toggleButton.Text = "Mostrar GUI"
toggleButton.Parent = ScreenGui

-- Panel principal del GUI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 3
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = ScreenGui

-- Borde superior para mover GUI
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Text = "Adonis Except"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextScaled = true
titleLabel.Parent = titleBar

-- Botón para activar/desactivar seguimiento
local followButton = Instance.new("TextButton")
followButton.Size = UDim2.new(0.8, 0, 0.2, 0)
followButton.Position = UDim2.new(0.1, 0, 0.35, 0)
followButton.Text = "Seguir/Detener"
followButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
followButton.TextColor3 = Color3.fromRGB(255, 255, 255)
followButton.Parent = mainFrame

-- Botón para cambiar de jugador
local changeButton = Instance.new("TextButton")
changeButton.Size = UDim2.new(0.8, 0, 0.2, 0)
changeButton.Position = UDim2.new(0.1, 0, 0.6, 0)
changeButton.Text = "Cambiar Jugador"
changeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
changeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
changeButton.Parent = mainFrame

-- Texto del jugador seguido
local followLabel = Instance.new("TextLabel")
followLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
followLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
followLabel.Text = "Jugador seguido: Ninguno"
followLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
followLabel.BackgroundTransparency = 1
followLabel.Parent = mainFrame

-- Función para obtener el jugador más cercano
local function getNearestPlayer()
    local players = game.Players:GetPlayers()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer

    for _, player in ipairs(players) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestPlayer = player
            end
        end
    end
    return nearestPlayer
end

-- Función de seguimiento de cámara
local function followPlayer()
    if not following or not targetPlayer or not targetPlayer.Character then
        return
    end

    local localPlayer = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

    if targetHRP then
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetHRP.Position)
    end
end

-- Actualizar la cámara para seguir al jugador
game:GetService("RunService").RenderStepped:Connect(function()
    if following then
        followPlayer()
    else
        game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end)

-- Botón para seguir/detener
followButton.MouseButton1Click:Connect(function()
    following = not following
    followButton.Text = following and "Detener" or "Seguir"
    if not following then
        game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        followLabel.Text = "Jugador seguido: Ninguno"
        targetPlayer = nil
    end
end)

-- Botón para cambiar jugador
changeButton.MouseButton1Click:Connect(function()
    targetPlayer = getNearestPlayer()
    if targetPlayer then
        followLabel.Text = "Jugador seguido: " .. targetPlayer.Name
    else
        followLabel.Text = "Jugador seguido: Ninguno"
    end
end)

-- Función para mostrar/ocultar GUI
toggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
    toggleButton.Text = guiVisible and "Ocultar GUI" or "Mostrar GUI"
end)