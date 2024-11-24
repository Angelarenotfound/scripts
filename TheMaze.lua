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
ToggleAxeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleAxeButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleAxeButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleAxeButton.Text = "Activate"
ToggleAxeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAxeButton.TextSize = 14

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
ToggleVisibilityButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleVisibilityButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleVisibilityButton.Position = UDim2.new(0.5, -100, 0.9, 0) -- Reubicado para fuera del MainFrame
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
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true
end

-- Variable para activar/desactivar el ESP
local espEnabled = false

-- Botón para activar/desactivar ESP
ToggleESPButton.Name = "ToggleESPButton"
ToggleESPButton.Parent = MainFrame
ToggleESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleESPButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleESPButton.Position = UDim2.new(0.1, 0, 0.6, 0)
ToggleESPButton.Text = "Activate ESP"
ToggleESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleESPButton.TextSize = 14

-- Función para alternar el estado del ESP
ToggleESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ToggleESPButton.Text = espEnabled and "Deactivate ESP" or "Activate ESP"
    if espEnabled then
        -- Crear ESP para las entidades
        createESP(game:GetService("Workspace").TheOrotund, "Skeleton", Color3.new(1, 0, 0))  -- Esqueleto
        createESP(game:GetService("Workspace").TheCajoler, "Short", Color3.new(1, 1, 1))  -- Criatura enmascarada
    else
        -- Eliminar los ESPs cuando se desactiva
        for _, a in pairs(game:GetService("Workspace"):GetDescendants()) do
            if a:IsA("BillboardGui") then
                a:Destroy()  -- Eliminar los ESPs creados
            end
        end
    end
end)

-- Fin de la función de activación/desactivación del ESP

-- Aseguramos que el GUI se muestre correctamente
ScreenGui.Enabled = true