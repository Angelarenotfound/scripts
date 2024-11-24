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
MainFrame.Size = UDim2.new(0, 200, 0, 125)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -62)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

-- Título con colores animados
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Adonis Except"
Title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Adonis color (blanco)
Title.TextStrokeTransparency = 0
Title.TextSize = 20

-- Animación de entrada para el título
Title.Text = "Adonis Except" -- Set the title text
Title.TextColor3 = Color3.fromRGB(255, 255, 255) -- White for Adonis

Title.TextStrokeTransparency = 0
Title.TextSize = 20
Title.TextScaled = true

-- Crear animación de entrada
local tweenService = game:GetService("TweenService")
local titleTween = tweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -100, 0.5, -62), 
    TextTransparency = 0
})
titleTween:Play()

-- Función para alternar el color de "Except" a rojo
local function changeTitleColor()
    -- Espera breve y luego cambia a color rojo para Except
    wait(0.5)
    Title.Text = "Adonis Except"
    Title.TextColor3 = Color3.fromRGB(255, 0, 0) -- "Except" en rojo
end

-- Llamar a la función para cambiar el color después de la animación
changeTitleColor()

-- Botón de Activar/Desactivar Axe
ToggleAxeButton.Name = "ToggleAxeButton"
ToggleAxeButton.Parent = MainFrame
ToggleAxeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleAxeButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleAxeButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleAxeButton.Text = "Activar/Desactivar Axe"
ToggleAxeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAxeButton.TextSize = 14

-- Botón para ocultar/mostrar GUI
ToggleVisibilityButton.Name = "ToggleVisibilityButton"
ToggleVisibilityButton.Parent = MainFrame
ToggleVisibilityButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleVisibilityButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleVisibilityButton.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleVisibilityButton.Text = "Ocultar/Mostrar GUI"
ToggleVisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleVisibilityButton.TextSize = 14

-- Variable para activar/desactivar el script del Axe
local axeEnabled = false

-- Función para activar o desactivar el script del Axe
ToggleAxeButton.MouseButton1Click:Connect(function()
    axeEnabled = not axeEnabled
    if axeEnabled then
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

-- Función para ocultar o mostrar la GUI
ToggleVisibilityButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)