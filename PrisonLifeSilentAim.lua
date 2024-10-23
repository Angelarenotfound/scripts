-- Variables del aimbot
local aimbotEnabled = false
local targetPart = "Head" -- Por defecto apunta a la cabeza
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera

-- Función para habilitar o deshabilitar el aimbot
function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    print("Aimbot toggled:", aimbotEnabled)
end

-- Función para cambiar la parte objetivo
function setTarget(part)
    targetPart = part
    print("Aimbot target set to:", targetPart)
end

-- Función para obtener el enemigo más cercano a la posición del clic
function getClosestEnemyToClick(clickPosition)
    local closestEnemy = nil
    local shortestDistance = math.huge
    
    -- Hacer un rayo desde la cámara hacia el punto donde se hizo clic
    local ray = camera:ScreenPointToRay(clickPosition.X, clickPosition.Y)
    local rayOrigin = ray.Origin
    local rayDirection = ray.Direction * 500 -- Prolonga el rayo en la dirección del clic

    for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
            -- Obtener la distancia entre la posición de clic (prolongada por el rayo) y la posición del enemigo
            local distance = (enemy.HumanoidRootPart.Position - rayOrigin).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestEnemy = enemy
            end
        end
    end

    return closestEnemy
end

-- Función para ajustar la dirección del disparo
function aimAt(enemy)
    local partToAim = enemy:FindFirstChild(targetPart)
    if partToAim then
        -- Apunta la cámara o la bala hacia el enemigo más cercano
        camera.CFrame = CFrame.new(camera.CFrame.Position, partToAim.Position)
    end
end

-- Detección del disparo, tanto en PC como en móvil
local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Detectar si se disparó con el ratón o toque en pantalla
    if aimbotEnabled and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local clickPosition = input.Position -- Obtener la posición del clic o toque

        -- Encontrar el enemigo más cercano al clic
        local enemy = getClosestEnemyToClick(clickPosition)
        if enemy then
            aimAt(enemy)
        end
    end
end)

-- Creación del menú para PC y móvil
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local headButton = Instance.new("TextButton", gui)
headButton.Position = UDim2.new(0, 50, 0, 50)
headButton.Size = UDim2.new(0, 150, 0, 50)
headButton.Text = "Apuntar a la Cabeza"
headButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
headButton.TextScaled = true

headButton.MouseButton1Click:Connect(function()
    setTarget("Head")
end)

local torsoButton = Instance.new("TextButton", gui)
torsoButton.Position = UDim2.new(0, 50, 0, 120)
torsoButton.Size = UDim2.new(0, 150, 0, 50)
torsoButton.Text = "Apuntar al Torso"
torsoButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
torsoButton.TextScaled = true

torsoButton.MouseButton1Click:Connect(function()
    setTarget("Torso")
end)

local toggleButton = Instance.new("TextButton", gui)
toggleButton.Position = UDim2.new(0, 50, 0, 190)
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Text = "Toggle Aimbot"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
toggleButton.TextScaled = true

toggleButton.MouseButton1Click:Connect(toggleAimbot)