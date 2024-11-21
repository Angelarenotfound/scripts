-- CONFIGURACIÓN INICIAL
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

-- MENÚ PRINCIPAL
local MainMenu = Instance.new("Frame")
MainMenu.Parent = ScreenGui
MainMenu.Size = UDim2.new(0, 400, 0, 300)
MainMenu.Position = UDim2.new(0.5, -200, 0.5, -150)
MainMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainMenu.BackgroundTransparency = 0.2
MainMenu.BorderSizePixel = 0
MainMenu.Draggable = true
MainMenu.Active = true
MainMenu.ZIndex = 10
MainMenu.AnchorPoint = Vector2.new(0.5, 0.5)

-- BORDES REDONDEADOS
local UICorner = Instance.new("UICorner")
UICorner.Parent = MainMenu
UICorner.CornerRadius = UDim.new(0, 15)

-- TÍTULO DEL MENÚ
local Title = Instance.new("TextLabel")
Title.Parent = MainMenu
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b><font color='white'>Adonis</font> <font color='red'>Except</font></b>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold
Title.RichText = true

-- INPUT DE COMANDOS
local InputBox = Instance.new("TextBox")
InputBox.Parent = MainMenu
InputBox.Size = UDim2.new(0.9, 0, 0.15, 0)
InputBox.Position = UDim2.new(0.05, 0, 0.7, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.Font = Enum.Font.SourceSans
InputBox.TextSize = 18
InputBox.PlaceholderText = "Escribe un comando aquí"
InputBox.ClearTextOnFocus = false

local InputCorner = Instance.new("UICorner")
InputCorner.Parent = InputBox
InputCorner.CornerRadius = UDim.new(0, 8)

-- NOTIFICACIÓN DE ERRORES
local function showNotification(message)
    local Notification = Instance.new("TextLabel")
    Notification.Parent = ScreenGui
    Notification.Size = UDim2.new(0, 300, 0, 50)
    Notification.Position = UDim2.new(0.5, -150, 0.8, -25)
    Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Notification.Text = message
    Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    Notification.TextScaled = true
    Notification.Font = Enum.Font.SourceSans
    Notification.ZIndex = 15

    local NotificationCorner = Instance.new("UICorner")
    NotificationCorner.Parent = Notification
    NotificationCorner.CornerRadius = UDim.new(0, 8)

    game:GetService("TweenService"):Create(
        Notification,
        TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1, TextTransparency = 1}
    ):Play()

    wait(2)
    Notification:Destroy()
end

-- LISTA DE COMANDOS
local commands = {
    {name = "speed", alias = "spd", description = "Aumenta la velocidad del jugador"},
    {name = "jumppower", alias = "jp", description = "Modifica el poder de salto"},
    {name = "fullbright", alias = "fb", description = "Activa la visión nocturna"},
    {name = "xray", alias = "xr", description = "Permite ver a través de las paredes"},
    {name = "esp", alias = "esp", description = "Activa ESP para jugadores"},
    {name = "espMobs", alias = "em", description = "Activa ESP para mobs"}
}

-- VENTANA DE COMANDOS
local function showCommands()
    local CommandFrame = Instance.new("Frame")
    CommandFrame.Parent = ScreenGui
    CommandFrame.Size = UDim2.new(0, 300, 0, 200)
    CommandFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    CommandFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CommandFrame.BackgroundTransparency = 0.5
    CommandFrame.Draggable = true
    CommandFrame.Active = true

    local CommandCorner = Instance.new("UICorner")
    CommandCorner.Parent = CommandFrame
    CommandCorner.CornerRadius = UDim.new(0, 8)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = CommandFrame
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.Text = "X"
    CloseButton.TextScaled = true
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    CloseButton.MouseButton1Click:Connect(function()
        CommandFrame:Destroy()
    end)

    local CommandList = Instance.new("ScrollingFrame")
    CommandList.Parent = CommandFrame
    CommandList.Size = UDim2.new(1, 0, 0.9, -20)
    CommandList.Position = UDim2.new(0, 0, 0.1, 0)
    CommandList.BackgroundTransparency = 1
    CommandList.ScrollBarThickness = 8

    for i, cmd in pairs(commands) do
        local CommandLabel = Instance.new("TextLabel")
        CommandLabel.Parent = CommandList
        CommandLabel.Size = UDim2.new(1, -10, 0, 25)
        CommandLabel.Position = UDim2.new(0, 5, 0, (i - 1) * 30)
        CommandLabel.Text = cmd.name .. " (" .. cmd.alias .. ") - " .. cmd.description
        CommandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        CommandLabel.BackgroundTransparency = 1
        CommandLabel.Font = Enum.Font.SourceSans
        CommandLabel.TextScaled = true
    end
end

-- MANEJO DE COMANDOS
local function handleCommand(command)
    if command == "commands" or command == "cmds" then
        showCommands()
    elseif command == "speed" or command == "spd" then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    elseif command == "jumppower" or command == "jp" then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    elseif command == "fullbright" or command == "fb" then
        game.Lighting.Brightness = 2
    elseif command == "xray" or command == "xr" then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.5
            end
        end
    elseif command == "esp" then
        -- ESP código aquí
    elseif command == "espMobs" or command == "em" then
        -- Código para ESP de mobs
    else
        showNotification("Comando no válido")
    end
end

-- EVENTO DE CHAT
LocalPlayer.Chatted:Connect(function(message)
    if string.sub(message, 1, 1) == ";" then
        local cmd = string.sub(message, 2):lower()
        handleCommand(cmd)
    end
end)

-- BOTÓN DE INPUT
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        handleCommand(InputBox.Text:lower())
        InputBox.Text = ""
    end
end)