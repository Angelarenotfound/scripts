-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleESPButton = Instance.new("TextButton")
local ToggleAimbotButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

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
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
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

ToggleESPButton.Name = "ToggleESPButton"
ToggleESPButton.Parent = MainFrame
ToggleESPButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleESPButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleESPButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleESPButton.Text = "Activar ESP"
ToggleESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleESPButton.TextSize = 14

ToggleAimbotButton.Name = "ToggleAimbotButton"
ToggleAimbotButton.Parent = MainFrame
ToggleAimbotButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleAimbotButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleAimbotButton.Position = UDim2.new(0.1, 0, 0.6, 0)
ToggleAimbotButton.Text = "Activar Aimbot"
ToggleAimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAimbotButton.TextSize = 14

-- Variables de control
local espEnabled = false
local aimbotEnabled = false
local updateInterval = 1
local lastUpdate = 0

-- Función para crear el marcador ESP
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

-- Aimbot con la pistola en mano
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
        local targetPlayer = getPlayerWithKnife()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
        end
    end
end)

-- Eventos de los botones
ToggleESPButton.MouseButton1Click:Connect(toggleESP)
ToggleAimbotButton.MouseButton1Click:Connect(toggleAimbot)