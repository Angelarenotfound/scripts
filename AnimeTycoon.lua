-- Obtener referencias a los elementos del GUI
local SpeedInput = script.Parent.SpeedInput -- Input para velocidad
local ApplySpeedButton = script.Parent.ApplySpeedButton -- Botón para aplicar velocidad
local ToggleSpeedPersistence = script.Parent.ToggleSpeedPersistence -- Botón para persistencia de velocidad

local JumpInput = script.Parent.JumpInput -- Input para JumpPower
local ApplyJumpButton = script.Parent.ApplyJumpButton -- Botón para aplicar JumpPower
local ToggleJumpPersistence = script.Parent.ToggleJumpPersistence -- Botón para persistencia de JumpPower

local TeleportSwitch = script.Parent.TeleportSwitch -- Interruptor de teletransporte

local CoordinatesLabel = script.Parent.CoordinatesLabel -- Label para mostrar las coordenadas

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

-- Función para actualizar y mostrar las coordenadas
local function updateCoordinates()
    while true do
        local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local position = humanoidRootPart.Position
            CoordinatesLabel.Text = string.format("X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z)
        end
        wait(0.1) -- Actualizar cada 0.1 segundos
    end
end

-- Eventos de los botones
ApplySpeedButton.MouseButton1Click:Connect(applySpeed)
ToggleSpeedPersistence.MouseButton1Click:Connect(toggleSpeedPersistence)

ApplyJumpButton.MouseButton1Click:Connect(applyJumpPower)
ToggleJumpPersistence.MouseButton1Click:Connect(toggleJumpPersistence)

TeleportSwitch.MouseButton1Click:Connect(toggleTeleportation)

-- Iniciar la actualización de las coordenadas
spawn(updateCoordinates)