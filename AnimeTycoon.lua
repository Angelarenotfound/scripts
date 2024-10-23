-- Crear GUI en tiempo de ejecución
local ScreenGui = Instance.new("ScreenGui")
local SpeedInput = Instance.new("TextBox")
local ApplySpeedButton = Instance.new("TextButton")
local ToggleSpeedPersistence = Instance.new("TextButton")
local JumpInput = Instance.new("TextBox")
local ApplyJumpButton = Instance.new("TextButton")
local ToggleJumpPersistence = Instance.new("TextButton")
local TeleportSwitch = Instance.new("TextButton")
local CoordinatesButton = Instance.new("TextButton")

-- Configurar propiedades de los elementos GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

SpeedInput.Parent = ScreenGui
SpeedInput.Size = UDim2.new(0, 200, 0, 50)
SpeedInput.Position = UDim2.new(0, 10, 0, 10)
SpeedInput.Text = "Speed"

ApplySpeedButton.Parent = ScreenGui
ApplySpeedButton.Size = UDim2.new(0, 200, 0, 50)
ApplySpeedButton.Position = UDim2.new(0, 10, 0, 70)
ApplySpeedButton.Text = "Apply Speed"

ToggleSpeedPersistence.Parent = ScreenGui
ToggleSpeedPersistence.Size = UDim2.new(0, 200, 0, 50)
ToggleSpeedPersistence.Position = UDim2.new(0, 10, 0, 130)
ToggleSpeedPersistence.Text = "Toggle Speed Persistence"

JumpInput.Parent = ScreenGui
JumpInput.Size = UDim2.new(0, 200, 0, 50)
JumpInput.Position = UDim2.new(0, 10, 0, 190)
JumpInput.Text = "JumpPower"

ApplyJumpButton.Parent = ScreenGui
ApplyJumpButton.Size = UDim2.new(0, 200, 0, 50)
ApplyJumpButton.Position = UDim2.new(0, 10, 0, 250)
ApplyJumpButton.Text = "Apply JumpPower"

ToggleJumpPersistence.Parent = ScreenGui
ToggleJumpPersistence.Size = UDim2.new(0, 200, 0, 50)
ToggleJumpPersistence.Position = UDim2.new(0, 10, 0, 310)
ToggleJumpPersistence.Text = "Toggle Jump Persistence"

TeleportSwitch.Parent = ScreenGui
TeleportSwitch.Size = UDim2.new(0, 200, 0, 50)
TeleportSwitch.Position = UDim2.new(0, 10, 0, 370)
TeleportSwitch.Text = "Toggle Teleport"

CoordinatesButton.Parent = ScreenGui
CoordinatesButton.Size = UDim2.new(0, 200, 0, 50)
CoordinatesButton.Position = UDim2.new(0, 10, 0, 430)
CoordinatesButton.Text = "Show Coordinates"

-- Variables del jugador y humanoide
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables para velocidad y JumpPower
local speedValue = 16
local speedPersistenceEnabled = true
local jumpPowerValue = 50
local jumpPersistenceEnabled = true

-- Variables para teletransporte
local teleportActive = false
local teleportLocations = {
    ["Equipo1"] = Vector3.new(10, 0, 10),
    ["Equipo2"] = Vector3.new(20, 0, 20),
    -- Añade más ubicaciones para los otros equipos
}
local teleportDelay = 60 -- Teletransporte cada minuto

-- Función para aplicar velocidad
local function applySpeed()
    local newSpeed = tonumber(SpeedInput.Text)
    if newSpeed then
        speedValue = newSpeed
        humanoid.WalkSpeed = speedValue
    end
end

-- Función para aplicar JumpPower
local function applyJumpPower()
    local newJumpPower = tonumber(JumpInput.Text)
    if newJumpPower then
        jumpPowerValue = newJumpPower
        humanoid.JumpPower = jumpPowerValue
    end
end

-- Función para activar/desactivar persistencia de velocidad
local function toggleSpeedPersistence()
    speedPersistenceEnabled = not speedPersistenceEnabled
    if not speedPersistenceEnabled then
        humanoid.WalkSpeed = 16 -- Restaurar velocidad predeterminada
    end
end

-- Función para activar/desactivar persistencia de JumpPower
local function toggleJumpPersistence()
    jumpPersistenceEnabled = not jumpPersistenceEnabled
    if not jumpPersistenceEnabled then
        humanoid.JumpPower = 50 -- Restaurar JumpPower predeterminado
    end
end

-- Función para gestionar el teletransporte
local function teleportPlayer()
    local character = player.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local team = player.Team.Name
    local originalPosition = humanoidRootPart.Position
    
    if teleportLocations[team] then
        humanoidRootPart.CFrame = CFrame.new(teleportLocations[team])
        wait(teleportDelay)
        humanoidRootPart.CFrame = CFrame.new(originalPosition)
    end
end

-- Función para activar/desactivar el teletransporte
local function toggleTeleportation()
    teleportActive = not teleportActive
    if teleportActive then
        while teleportActive do
            teleportPlayer()
            wait(teleportDelay)
        end
    end
end

-- Mantener velocidad al reaparecer si la persistencia está activada
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    if speedPersistenceEnabled then
        humanoid.WalkSpeed = speedValue
    end
    if jumpPersistenceEnabled then
        humanoid.JumpPower = jumpPowerValue
    end
end)

-- Función para mostrar las coordenadas en una notificación con botón de copiar
local function showCoordinates()
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local position = humanoidRootPart.Position
        local coordinates = string.format("(%.2f, %.2f, %.2f)", position.X, position.Y, position.Z)
        
        -- Crear notificación
        game.StarterGui:SetCore("SendNotification", {
            Title = "Coordenadas",
            Text = coordinates,
            Duration = 10,
            Button1 = "Copiar",
            Callback = function(buttonClicked)
                if buttonClicked == "Copiar" then
                    -- Copiar las coordenadas al portapapeles
                    setclipboard(coordinates)
                end
            end
        })
    end
end

-- Eventos de los botones
ApplySpeedButton.MouseButton1Click:Connect(applySpeed)
ToggleSpeedPersistence.MouseButton1Click:Connect(toggleSpeedPersistence)

ApplyJumpButton.MouseButton1Click:Connect(applyJumpPower)
ToggleJumpPersistence.MouseButton1Click:Connect(toggleJumpPersistence)

TeleportSwitch.MouseButton1Click:Connect(toggleTeleportation)

CoordinatesButton.MouseButton1Click:Connect(showCoordinates)