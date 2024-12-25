-- Crear GUI
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local button1 = Instance.new("TextButton")
local button2 = Instance.new("TextButton")
local toggleButton = Instance.new("TextButton")
local uiCorner = Instance.new("UICorner")

-- Propiedades del GUI
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
screenGui.Name = "CustomGUI"

-- Propiedades del Frame (fondo negro con bordes redondeados)
frame.Parent = screenGui
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Fondo negro
frame.Position = UDim2.new(0.3, 0, 0.3, 0) -- Posicionarlo en la pantalla
frame.Size = UDim2.new(0.4, 0, 0.4, 0) -- Tamaño del Frame
frame.BorderSizePixel = 0 -- Sin borde externo
frame.Active = true
frame.Draggable = true -- Permite mover el GUI

-- Bordes redondeados para el frame
uiCorner.Parent = frame
uiCorner.CornerRadius = UDim.new(0, 15) -- Bordes redondeados grises

-- Botón 1 (Netless V7)
button1.Parent = frame
button1.Text = "Netless V7"
button1.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rojo
button1.Position = UDim2.new(0.1, 0, 0.3, 0) -- Posición en el Frame
button1.Size = UDim2.new(0.8, 0, 0.2, 0) -- Tamaño del botón
button1.TextScaled = true -- Ajusta el texto al tamaño del botón
button1.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco
button1.Active = true
button1.Draggable = true -- Permite mover el botón

-- Botón 2 (Fe VR)
button2.Parent = frame
button2.Text = "Fe VR"
button2.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rojo
button2.Position = UDim2.new(0.1, 0, 0.6, 0) -- Posición en el Frame
button2.Size = UDim2.new(0.8, 0, 0.2, 0) -- Tamaño del botón
button2.TextScaled = true -- Ajusta el texto al tamaño del botón
button2.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco
button2.Active = true
button2.Draggable = true -- Permite mover el botón

-- Bordes redondeados para los botones
local buttonCorner1 = Instance.new("UICorner", button1)
buttonCorner1.CornerRadius = UDim.new(0, 10)

local buttonCorner2 = Instance.new("UICorner", button2)
buttonCorner2.CornerRadius = UDim.new(0, 10)

-- Botón para ocultar/mostrar el GUI
toggleButton.Parent = screenGui
toggleButton.Text = "Mostrar/Ocultar GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris
toggleButton.Position = UDim2.new(0.8, 0, 0.05, 0) -- Posición en la pantalla
toggleButton.Size = UDim2.new(0.15, 0, 0.05, 0) -- Tamaño del botón
toggleButton.TextScaled = true -- Ajusta el texto al tamaño del botón
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco
toggleButton.Active = true
toggleButton.Draggable = true -- Permite mover el botón

-- Bordes redondeados para el botón exterior
local toggleButtonCorner = Instance.new("UICorner", toggleButton)
toggleButtonCorner.CornerRadius = UDim.new(0, 10)

-- Función para ocultar/mostrar el GUI
local guiVisible = true
toggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    frame.Visible = guiVisible
end)

-- Función para el primer botón (Netless V7)
button1.MouseButton1Click:Connect(function()
    for i, v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            game:GetService("RunService").Heartbeat:connect(function()
                v.Velocity = Vector3.new(-30, 0, 0)
            end)
        end
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Notification";
        Text = "Netless V7 Activated";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
        Duration = 16;
    })
end)

-- Función para el segundo botón (Fe VR)
button2.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/AstralHub/main/Main.lua", true))()
end)