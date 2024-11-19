-- Crear la pantalla principal del GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Crear el marco principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Size = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.BorderSizePixel = 0

-- Hacer que el GUI sea movible
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Crear el título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "Adonis Except"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.TextAlignment = Enum.TextAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center

-- Cambiar "Except" a rojo
local titleText = Title.Text
local exceptStart = string.find(titleText, "Except")
local firstPart = titleText:sub(1, exceptStart-1)
local secondPart = titleText:sub(exceptStart)

Title.Text = firstPart .. " " .. secondPart
Title.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Rojo para Except

-- Botón para activar/desactivar ESP
local ToggleESPButton = Instance.new("TextButton")
ToggleESPButton.Name = "ToggleESPButton"
ToggleESPButton.Parent = MainFrame
ToggleESPButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleESPButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleESPButton.Position = UDim2.new(0.1, 0, 0.6, 0)
ToggleESPButton.Text = "Activar/Desactivar ESP"
ToggleESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleESPButton.TextSize = 14

-- Botón para activar/desactivar Aim
local ToggleAimButton = Instance.new("TextButton")
ToggleAimButton.Name = "ToggleAimButton"
ToggleAimButton.Parent = MainFrame
ToggleAimButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleAimButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleAimButton.Position = UDim2.new(0.1, 0, 0.8, 0)
ToggleAimButton.Text = "Activar/Desactivar Aim"
ToggleAimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAimButton.TextSize = 14

-- Botón para ocultar/mostrar el GUI
local ToggleVisibilityButton = Instance.new("TextButton")
ToggleVisibilityButton.Name = "ToggleVisibilityButton"
ToggleVisibilityButton.Parent = MainFrame
ToggleVisibilityButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Rojo
ToggleVisibilityButton.Size = UDim2.new(0.2, 0, 0.2, 0)
ToggleVisibilityButton.Position = UDim2.new(0.8, 0, 0, 0)
ToggleVisibilityButton.Text = "Ocultar"
ToggleVisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleVisibilityButton.TextSize = 14

-- Funcionalidad para ocultar/mostrar el GUI
ToggleVisibilityButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        ToggleVisibilityButton.Text = "Mostrar"
    else
        MainFrame.Visible = true
        ToggleVisibilityButton.Text = "Ocultar"
    end
end)

-- Activar/Desactivar ESP
ToggleESPButton.MouseButton1Click:Connect(function()
    local espScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/refs/heads/main/mm2/esp.lua"))
    espScript()
end)

-- Activar/Desactivar Aim
ToggleAimButton.MouseButton1Click:Connect(function()
    local aimScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/refs/heads/main/mm2/Aim.lua"))
    aimScript()
end)