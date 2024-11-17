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
local function toggleESP(state)
    espEnabled = state
    if not state then
        -- Limpiar marcadores si se desactiva
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPMarker") then
                player.Character.ESPMarker:Destroy()
            end
        end
    end
end