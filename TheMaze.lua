local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local defaultWalkSpeed = 16

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleAxeButton = Instance.new("TextButton")
local ToggleVisibilityButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local ToggleESPButton = Instance.new("TextButton")  -- Botón para activar/desactivar ESP
local LoadingScreen = Instance.new("Frame")  -- Pantalla de carga
local LoadingText = Instance.new("TextLabel")  -- Texto de la pantalla de carga

-- Propiedades GUI
ScreenGui.Name = "AdonisExceptGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Fondo oscuro
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 200)  -- Aumentamos el tamaño
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

-- Título con colores animados
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Adonis Except"
Title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Blanco
Title.TextStrokeTransparency = 0.5
Title.TextSize = 20

-- Pantalla de carga
LoadingScreen.Name = "LoadingScreen"
LoadingScreen.Parent = ScreenGui
LoadingScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingScreen.BackgroundTransparency = 0.5
LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
LoadingScreen.Visible = false  -- Inicialmente oculta

LoadingText.Name = "LoadingText"
LoadingText.Parent = LoadingScreen
LoadingText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.BackgroundTransparency = 1
LoadingText.Size = UDim2.new(1, 0, 0, 50)
LoadingText.Font = Enum.Font.SourceSans
LoadingText.Text = "Cargando..."
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 30
LoadingText.TextScaled = true
LoadingText.TextStrokeTransparency = 0.5
LoadingText.TextAlign = Enum.TextAnchor.MiddleCenter

-- Botón de Activar/Desactivar Axe
ToggleAxeButton.Name = "ToggleAxeButton"
ToggleAxeButton.Parent = MainFrame
ToggleAxeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleAxeButton.Size = UDim2.new(0.8, 0, 0, 35)
ToggleAxeButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleAxeButton.Text = "Activate"
ToggleAxeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAxeButton.TextSize = 14
ToggleAxeButton.TextStrokeTransparency = 0.6
ToggleAxeButton.BorderRadius = UDim.new(0, 15)
ToggleAxeButton.AutoButtonColor = false

-- Efecto de brillo en el borde del botón
ToggleAxeButton.MouseEnter:Connect(function()
    ToggleAxeButton.TextColor3 = Color3.fromRGB(100, 255, 255)  -- Azul brillante al pasar el ratón
    ToggleAxeButton.BorderColor3 = Color3.fromRGB(0, 200, 255)  -- Brillo en el borde
end)

ToggleAxeButton.MouseLeave:Connect(function()
    ToggleAxeButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Blanco por defecto
    ToggleAxeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)  -- Borde normal
end)

-- Variable para activar/desactivar el script del Axe
local axeEnabled = false

-- Función para alternar el texto del botón de Activar/Desactivar Axe
ToggleAxeButton.MouseButton1Click:Connect(function()
    axeEnabled = not axeEnabled
    ToggleAxeButton.Text = axeEnabled and "Deactivate" or "Activate"
    if axeEnabled then
        -- Mostrar pantalla de carga mientras se ejecuta la animación
        LoadingScreen.Visible = true
        wait(5)  -- Pantalla de carga por 5 segundos
        LoadingScreen.Visible = false

        -- Activar el script del Axe
        while true do
            wait(0.00001)
            if axeEnabled then
                for _, a in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if a.Name == "ClickDetector" and a.Parent.Parent.Name == "Axe" then
                        fireclickdetector(a) -- Activa el click en el detector
                    end
                end
                for _, a in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if a.Name == "Axe" and not game.Players.LocalPlayer.Character:FindFirstChild("Axe") then
                        a.Parent = game.Players.LocalPlayer.Character -- Equipa el hacha al jugador
                    end
                end
            else
                break -- Si se desactiva, salir del bucle
            end
        end
    end
end)

-- Crear un botón fuera del MainFrame para ocultar/mostrar el GUI
ToggleVisibilityButton.Name = "ToggleVisibilityButton"
ToggleVisibilityButton.Parent = ScreenGui -- Ahora está en ScreenGui, no en MainFrame
ToggleVisibilityButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleVisibilityButton.Size = UDim2.new(0.8, 0, 0, 35)
ToggleVisibilityButton.Position = UDim2.new(0.5, -100, 0.9, 0) -- Reubicado para fuera del MainFrame
ToggleVisibilityButton.Text = "Ocultar/Mostrar GUI"
ToggleVisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleVisibilityButton.TextSize = 14
ToggleVisibilityButton.TextStrokeTransparency = 0.6
ToggleVisibilityButton.BorderRadius = UDim.new(0, 15)
ToggleVisibilityButton.AutoButtonColor = false

-- Efecto de brillo en el borde del botón
ToggleVisibilityButton.MouseEnter:Connect(function()
    ToggleVisibilityButton.TextColor3 = Color3.fromRGB(100, 255, 255)  -- Azul brillante al pasar el ratón
    ToggleVisibilityButton.BorderColor3 = Color3.fromRGB(0, 200, 255)  -- Brillo en el borde
end)

ToggleVisibilityButton.MouseLeave:Connect(function()
    ToggleVisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Blanco por defecto
    ToggleVisibilityButton.BorderColor3 = Color3.fromRGB(0, 0, 0)  -- Borde normal
end)

-- Función para ocultar/mostrar la GUI
local function toggleVisibility()
    MainFrame.Visible = not MainFrame.Visible
    ToggleVisibilityButton.Text = MainFrame.Visible and "Ocultar GUI" or "Mostrar GUI"
end

-- Evento del botón de ocultar/mostrar
ToggleVisibilityButton.MouseButton1Click:Connect(toggleVisibility)

-- Función para crear el ESP para cualquier entidad
local function createESP(item, text, color)
    if not item or not item:FindFirstChild("HumanoidRootPart") then
        return
    end

    -- Crear el BillboardGui para mostrar el texto
    local BillboardGui = Instance.new("BillboardGui")
    local TextLabel = Instance.new("TextLabel")

    BillboardGui.Parent = item.HumanoidRootPart
    BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BillboardGui.Active = true
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 1
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)

    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(0, 200, 0, 50)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.Text = text
    TextLabel.TextColor3 = color
    TextLabel.TextScaled = true
    TextLabel.TextStrokeTransparency = 0.5  -- Agrega un borde alrededor del texto
    TextLabel.TextAlign = Enum.TextAnchor.MiddleCenter
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center
end

-- Crear ESP en todos los objetos
local function enableESP()
    for _, obj in pairs(game:GetService("Workspace"):GetChildren()) do
        if obj:FindFirstChild("HumanoidRootPart") then
            createESP(obj, "ESP", Color3.fromRGB(0, 255, 255))  -- Usar un color de ESP predeterminado (cian)
        end
    end
end

-- Botón para activar o desactivar ESP
ToggleESPButton.Name = "ToggleESPButton"
ToggleESPButton.Parent = MainFrame
ToggleESPButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleESPButton.Size = UDim2.new(0.8, 0, 0, 35)
ToggleESPButton.Position = UDim2.new(0.1, 0, 0.7, 0)  -- Colocado debajo del primer botón
ToggleESPButton.Text = "Toggle ESP"
ToggleESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleESPButton.TextSize = 14
ToggleESPButton.TextStrokeTransparency = 0.6
ToggleESPButton.BorderRadius = UDim.new(0, 15)
ToggleESPButton.AutoButtonColor = false

-- Efecto de brillo en el borde del botón de ESP
ToggleESPButton.MouseEnter:Connect(function()
    ToggleESPButton.TextColor3 = Color3.fromRGB(100, 255, 255)  -- Azul brillante al pasar el ratón
    ToggleESPButton.BorderColor3 = Color3.fromRGB(0, 200, 255)  -- Brillo en el borde
end)

ToggleESPButton.MouseLeave:Connect(function()
    ToggleESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Blanco por defecto
    ToggleESPButton.BorderColor3 = Color3.fromRGB(0, 0, 0)  -- Borde normal
end)

-- Función para alternar el ESP
local espEnabled = false
ToggleESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ToggleESPButton.Text = espEnabled and "Disable ESP" or "Enable ESP"
    if espEnabled then
        enableESP()  -- Llamar la función para activar ESP
    else
        -- Eliminar los ESP existentes
        for _, billboard in pairs(game:GetService("Workspace"):GetDescendants()) do
            if billboard:IsA("BillboardGui") then
                billboard:Destroy()
            end
        end
    end
end)

-- Controlar la visibilidad de la GUI desde el ToggleVisibilityButton
ToggleVisibilityButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleVisibilityButton.Text = MainFrame.Visible and "Ocultar GUI" or "Mostrar GUI"
end)