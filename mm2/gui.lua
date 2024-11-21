-- Variables globales
local player = game.Players.LocalPlayer
local infiniteJumpPower = 100
local defaultJumpPower = 50
local infiniteJumpEnabled = false
local walkSpeedValue = 16
local walkSpeedInput = script.Parent:WaitForChild("WalkSpeedInput")
local ToggleInfiniteJumpButton = script.Parent:WaitForChild("ToggleInfiniteJumpButton")
local ToggleESPButton = script.Parent:WaitForChild("ToggleESPButton")
local ToggleAimbotButton = script.Parent:WaitForChild("ToggleAimbotButton")
local UserInputService = game:GetService("UserInputService")

-- Función para cambiar la velocidad de caminar
local function applyWalkSpeed(speed)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

-- Lógica para el cambio de velocidad de caminar
walkSpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputSpeed = tonumber(walkSpeedInput.Text)
        if inputSpeed and inputSpeed > 0 then
            walkSpeedValue = inputSpeed
            -- Aplicar la nueva velocidad de caminar
            applyWalkSpeed(walkSpeedValue)
        else
            walkSpeedInput.Text = tostring(walkSpeedValue) -- Volver al valor anterior si la entrada no es válida
        end
    end
end)

-- Función para manejar el salto infinito
local function handleJump()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        humanoid.JumpPower = infiniteJumpPower
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Función para activar el salto infinito
local function turnOnInfiniteJump()
    handleJump()
end

-- Conectar el botón de salto infinito
ToggleInfiniteJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    ToggleInfiniteJumpButton.Text = infiniteJumpEnabled and "Desactivar Salto Infinito" or "Activar Salto Infinito"

    if infiniteJumpEnabled then
        -- Si el salto infinito está activado, también saltar cada vez que se presiona la tecla espacio
        UserInputService.InputBegan:Connect(function(input, isProcessed)
            if not isProcessed and input.KeyCode == Enum.KeyCode.Space then
                turnOnInfiniteJump()
            end
        end)
    else
        -- Detener el salto infinito
        UserInputService.InputBegan:Disconnect()
    end
end)

-- --- ESP Script ---
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local updateInterval = 1
local espEnabled = false  -- Inicialmente deshabilitado
local lastUpdate = 0  -- Para controlar el intervalo de actualización

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

local function updateESP()
    if not espEnabled then return end  -- No actualizar si está deshabilitado
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
        -- Limpiar marcadores si se desactiva
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPMarker") then
                player.Character.ESPMarker:Destroy()
            end
        end
    end
end

-- --- Aimbot Script ---
local aimbotEnabled = false
local targetPlayer = nil

local function aimAtPlayer(player)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local camera = game.Workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.Position, character.HumanoidRootPart.Position)
    end
end

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    ToggleAimbotButton.Text = aimbotEnabled and "Desactivar Aimbot" or "Activar Aimbot"
end

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and aimbotEnabled then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        local hasGun = player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun")
        
        if hasGun then
            -- Aimbot solo cuando el jugador tiene la pistola
            local closestPlayer = nil
            local closestDistance = math.huge

            for _, target in pairs(Players:GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = target
                    end
                end
            end

            if closestPlayer then
                aimAtPlayer(closestPlayer)
            end
        end
    end
end)

-- Conectar los botones para alternar ESP, Aimbot y Salto Infinito
ToggleESPButton.MouseButton1Click:Connect(toggleESP)
ToggleAimbotButton.MouseButton1Click:Connect(toggleAimbot)

-- Aplicar la velocidad de caminar cuando el personaje reaparece
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = walkSpeedValue
end)