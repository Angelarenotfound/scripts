-- Variables del GUI
local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ESPButton = Instance.new("TextButton")
local AimButton = Instance.new("TextButton")
local InfoLabel = Instance.new("TextLabel")
local TitleLabel = Instance.new("TextLabel")
local HideButton = Instance.new("TextButton")

-- Estilo del GUI
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Sección Principal (MainFrame)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250) -- Centrado
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Gris oscuro
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui

-- Título del GUI
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 400, 0, 50)
TitleLabel.Position = UDim2.new(0.5, -200, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Adonis"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.TextFont = Enum.Font.GothamBold
TitleLabel.TextSize = 36
TitleLabel.TextStrokeTransparency = 0.5
TitleLabel.TextYAlignment = Enum.TextYAlignment.Top
TitleLabel.Parent = MainFrame

local ExceptLabel = Instance.new("TextLabel")
ExceptLabel.Name = "ExceptLabel"
ExceptLabel.Size = UDim2.new(0, 400, 0, 50)
ExceptLabel.Position = UDim2.new(0.5, -200, 0.1, 50)
ExceptLabel.BackgroundTransparency = 1
ExceptLabel.Text = "Except"
ExceptLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
ExceptLabel.TextScaled = true
ExceptLabel.TextFont = Enum.Font.GothamBold
ExceptLabel.TextSize = 36
ExceptLabel.TextStrokeTransparency = 0.5
ExceptLabel.TextYAlignment = Enum.TextYAlignment.Top
ExceptLabel.Parent = MainFrame

-- Información del usuario
InfoLabel.Name = "InfoLabel"
InfoLabel.Size = UDim2.new(1, 0, 0.3, 0)
InfoLabel.Position = UDim2.new(0, 0, 0.2, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Información del Usuario:\n\nUsername: " .. Player.Name
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.TextScaled = true
InfoLabel.TextFont = Enum.Font.Gotham
InfoLabel.TextSize = 18
InfoLabel.TextStrokeTransparency = 0.5
InfoLabel.Parent = MainFrame

-- Botón para ocultar/mostrar el GUI
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 100, 0, 50)
HideButton.Position = UDim2.new(1, -100, 0, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
HideButton.Text = "Ocultar"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextFont = Enum.Font.Gotham
HideButton.TextSize = 20
HideButton.TextScaled = true
HideButton.BorderRadius = UDim.new(0, 25)
HideButton.Parent = MainFrame

-- Botón de ESP
ESPButton.Name = "ESPButton"
ESPButton.Size = UDim2.new(0, 250, 0, 50)
ESPButton.Position = UDim2.new(0.5, -125, 0.4, 0)
ESPButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ESPButton.Text = "ESP: Desactivado"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextFont = Enum.Font.Gotham
ESPButton.TextSize = 20
ESPButton.TextScaled = true
ESPButton.BorderRadius = UDim.new(0, 25)
ESPButton.Parent = MainFrame

-- Botón de Aim
AimButton.Name = "AimButton"
AimButton.Size = UDim2.new(0, 250, 0, 50)
AimButton.Position = UDim2.new(0.5, -125, 0.6, 0)
AimButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AimButton.Text = "Aim: Desactivado"
AimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimButton.TextFont = Enum.Font.Gotham
AimButton.TextSize = 20
AimButton.TextScaled = true
AimButton.BorderRadius = UDim.new(0, 25)
AimButton.Parent = MainFrame

-- Función para mover el GUI
local dragging = false
local dragInput, dragStart, startPos

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = MainFrame.Position
end

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

local function stopDrag()
    dragging = false
end

-- Conectar eventos de mover el GUI
MainFrame.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag(input)
        end
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        stopDrag()
    end
end)

-- Función para alternar ESP
local espEnabled = false
local aimEnabled = false
local espScript
local aimScript

local function toggleESP(state)
    espEnabled = state
    ESPButton.Text = "ESP: " .. (state and "Activado" or "Desactivado")
    if state then
        espScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/main/mm2/esp.lua"))()
    else
        if espScript then
            espScript:Disconnect()
            espScript = nil
        end
    end
end

-- Función para alternar Aim
local function toggleAim(state)
    aimEnabled = state
    AimButton.Text = "Aim: " .. (state and "Activado" or "Desactivado")
    if state then
        aimScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/main/mm2/aim.lua"))()
    else
        if aimScript then
            aimScript:Disconnect()
            aimScript = nil
        end
    end
end

-- Conectar los botones con las funciones
ESPButton.MouseButton1Click:Connect(function()
    toggleESP(not espEnabled)
end)

AimButton.MouseButton1Click:Connect(function()
    toggleAim(not aimEnabled)
end)

-- Función para ocultar/mostrar el GUI
local function toggleGui()
    if MainFrame.Visible then
        MainFrame.Visible = false
        HideButton.Text = "Mostrar"
    else
        MainFrame.Visible = true
        HideButton.Text = "Ocultar"
    end
end

-- Conectar el botón de ocultar/mostrar
HideButton.MouseButton1Click:Connect(toggleGui)