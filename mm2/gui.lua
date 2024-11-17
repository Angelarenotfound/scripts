-- Variables del GUI
local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local HomeFrame = Instance.new("Frame")
local MainFrame = Instance.new("Frame")
local ESPButton = Instance.new("TextButton")
local AimButton = Instance.new("TextButton")
local InfoLabel = Instance.new("TextLabel")
local TitleLabel = Instance.new("TextLabel")

-- Estilo de la interfaz
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Sección Home
HomeFrame.Name = "HomeFrame"
HomeFrame.Size = UDim2.new(0, 400, 0, 200)
HomeFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
HomeFrame.BackgroundColor3 = Color3.fromRGB(169, 169, 169)
HomeFrame.BackgroundTransparency = 0.2
HomeFrame.BorderSizePixel = 0
HomeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
HomeFrame.Parent = ScreenGui

-- Información del usuario
InfoLabel.Name = "InfoLabel"
InfoLabel.Size = UDim2.new(1, 0, 0.6, 0)
InfoLabel.Position = UDim2.new(0, 0, 0.2, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Información del Usuario:\n\nUsername: " .. Player.Name
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.TextScaled = true
InfoLabel.TextFont = Enum.Font.Gotham
InfoLabel.TextSize = 18
InfoLabel.TextStrokeTransparency = 0.5
InfoLabel.Parent = HomeFrame

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
TitleLabel.Parent = ScreenGui

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
ExceptLabel.Parent = ScreenGui

-- Sección Main
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(169, 169, 169)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui

-- Botón de ESP
ESPButton.Name = "ESPButton"
ESPButton.Size = UDim2.new(0, 250, 0, 50)
ESPButton.Position = UDim2.new(0.5, -125, 0.3, 0)
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

-- Scripts de ESP y Aim
local espEnabled = false
local aimEnabled = false
local espScript
local aimScript

-- Función para alternar ESP
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