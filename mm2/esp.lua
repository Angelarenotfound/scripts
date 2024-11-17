local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local updateInterval = 1
local espEnabled = true  -- Variable para controlar el estado del ESP
local lastUpdate = 0  -- Para controlar el intervalo de actualización

local function createMarker(player, color)
    -- Eliminar marcador anterior si existe
    if player.Character:FindFirstChild("ESPMarker") then
        player.Character.ESPMarker:Destroy()
    end

    -- Crear un nuevo marcador
    local marker = Instance.new("BillboardGui", player.Character)
    marker.Name = "ESPMarker"
    marker.Adornee = player.Character:FindFirstChild("HumanoidRootPart")  -- Centrado en el torso
    marker.ExtentsOffset = Vector3.new(0, -0.5, 0)  -- Ajustado para el torso
    marker.Size = UDim2.new(0, 15, 0, 15)  -- Círculo más pequeño
    marker.AlwaysOnTop = true

    -- Crear el círculo
    local circle = Instance.new("Frame", marker)
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundTransparency = 0.5
    circle.BackgroundColor3 = color
    circle.BorderSizePixel = 0

    -- Hacer el círculo redondo
    local uicorner = Instance.new("UICorner", circle)
    uicorner.CornerRadius = UDim.new(1, 0)  -- Forma circular
end

local function updateESP()
    if not espEnabled then return end  -- Si el ESP está desactivado, no actualizar

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hasKnife = player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")
            local hasGun = player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun")

            -- Cambiar el color dependiendo del ítem que tiene el jugador
            if hasKnife then
                createMarker(player, Color3.fromRGB(255, 0, 0))  -- Rojo si tiene cuchillo
            elseif hasGun then
                createMarker(player, Color3.fromRGB(0, 0, 255))  -- Azul si tiene pistola
            else
                createMarker(player, Color3.fromRGB(0, 255, 0))  -- Verde si no tiene armas
            end
        end
    end
end

-- Loop para actualizar el ESP
RunService.Stepped:Connect(function(_, dt)
    lastUpdate = lastUpdate + dt
    if lastUpdate >= updateInterval then
        updateESP()
        lastUpdate = 0
    end
end)