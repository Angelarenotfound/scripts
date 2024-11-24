-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local defaultWalkSpeed = 16

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleESPButton = Instance.new("TextButton")
local ToggleAimbotButton = Instance.new("TextButton")
local WalkSpeedInput = Instance.new("TextBox")
local Title = Instance.new("TextLabel")
local ToggleVisibilityButton = Instance.new("TextButton")

-- Propiedades GUI
ScreenGui.Name = "AdonisExceptGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 125)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -62)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

-- Título
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Adonis Except"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextStrokeTransparency = 0
Title.TextSize = 20

-- Botón de Toggle ESP
ToggleESPButton.Name = "ToggleESPButton"
ToggleESPButton.Parent = MainFrame
ToggleESPButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleESPButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleESPButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleESPButton.Text = "Activar ESP"
ToggleESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleESPButton.TextSize = 14

-- Botón de Toggle Aimbot
ToggleAimbotButton.Name = "ToggleAimbotButton"
ToggleAimbotButton.Parent = MainFrame
ToggleAimbotButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleAimbotButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleAimbotButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleAimbotButton.Text = "Activar Aimbot"
ToggleAimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAimbotButton.TextSize = 14

-- Input de WalkSpeed
WalkSpeedInput.Name = "WalkSpeedInput"
WalkSpeedInput.Parent = MainFrame
WalkSpeedInput.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
WalkSpeedInput.Size = UDim2.new(0.8, 0, 0, 25)
WalkSpeedInput.Position = UDim2.new(0.1, 0, 0.7, 0)
WalkSpeedInput.PlaceholderText = "Velocidad (default 16)"
WalkSpeedInput.Text = ""
WalkSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedInput.TextSize = 14

-- Botón para ocultar/mostrar GUI (fuera del MainFrame)
ToggleVisibilityButton.Name = "ToggleVisibilityButton"
ToggleVisibilityButton.Parent = ScreenGui
ToggleVisibilityButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleVisibilityButton.Size = UDim2.new(0.2, 0, 0, 25)  -- 20% del ancho de la pantalla
ToggleVisibilityButton.Position = UDim2.new(0.5, 0, 0, 0)  -- Centrado horizontal y pegado arriba
ToggleVisibilityButton.AnchorPoint = Vector2.new(0.5, 0)  -- Ancla el punto medio del botón horizontalmente
ToggleVisibilityButton.Text = "Ocultar/Mostrar GUI"
ToggleVisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleVisibilityButton.TextSize = 14

-- Función para ocultar/mostrar la GUI
local function toggleVisibility()
    MainFrame.Visible = not MainFrame.Visible
    ToggleVisibilityButton.Text = MainFrame.Visible and "Ocultar GUI" or "Mostrar GUI"
end

-- Evento del botón de ocultar/mostrar
ToggleVisibilityButton.MouseButton1Click:Connect(toggleVisibility)

-- Variables de control
local espEnabled = false
local aimbotEnabled = false
local walkSpeedValue = defaultWalkSpeed
local lastUpdate = 0
local updateInterval = 0.1

local function createMarker(player, color)
    if player.Character:FindFirstChild("ESPMarker") then
        player.Character.ESPMarker:Destroy()
    end

    local marker = Instance.new("BillboardGui", player.Character)
    marker.Name = "ESPMarker"
    marker.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
    marker.ExtentsOffset = Vector3.new(0, -0.5, 0)
    marker.Size = UDim2.new(0, 15, 0, 15)
    marker.AlwaysOnTop = true

    local circle = Instance.new("Frame", marker)
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundTransparency = 0.5
    circle.BackgroundColor3 = color
    circle.BorderSizePixel = 0

    local uicorner = Instance.new("UICorner", circle)
    uicorner.CornerRadius = UDim.new(1, 0)
end

-- Función para actualizar el ESP
local function updateESP()
    if not espEnabled then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hasKnife = player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")
            local hasGun = player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun")

            if hasKnife then
                createMarker(player, Color3.fromRGB(255, 0, 0))  -- Rojo
            elseif hasGun then
                createMarker(player, Color3.fromRGB(0, 0, 255))  -- Azul
            else
                createMarker(player, Color3.fromRGB(0, 255, 0))  -- Verde
            end
        end
    end
end

RunService.Stepped:Connect(function(_, dt)
    if espEnabled then
        lastUpdate = lastUpdate + dt
        if lastUpdate >= updateInterval then
            updateESP()
            lastUpdate = 0
        end
    end
end)

-- Función para alternar el estado del ESP
local function toggleESP()
    espEnabled = not espEnabled
    ToggleESPButton.Text = espEnabled and "Desactivar ESP" or "Activar ESP"
    if not espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPMarker") then
                player.Character.ESPMarker:Destroy()
            end
        end
    end
end

-- Función para obtener al jugador con el cuchillo
local function getPlayerWithKnife()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
                return player
            end
        end
    end
    return nil
end

-- Función para activar/desactivar el Aimbot
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    ToggleAimbotButton.Text = aimbotEnabled and "Desactivar Aimbot" or "Activar Aimbot"

    if not aimbotEnabled then
        RunService:UnbindFromRenderStep("Aimbot")
    end
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
        local targetPlayer = getPlayerWithKnife()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
        end
    end
end)

-- Función para cambiar WalkSpeed
local function applyWalkSpeed(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

WalkSpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputSpeed = tonumber(WalkSpeedInput.Text)
        if inputSpeed and inputSpeed > 0 then
            walkSpeedValue = inputSpeed
        else
            walkSpeedValue = defaultWalkSpeed
        end
        applyWalkSpeed(walkSpeedValue)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
        humanoid:GetPropertyChangedSignal("Parent"):Wait()
        applyWalkSpeed(walkSpeedValue)
    end)
end)

ToggleESPButton.MouseButton1Click:Connect(toggleESP)
ToggleAimbotButton.MouseButton1Click:Connect(toggleAimbot)