-- Servicios
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- Debug Function
local function debugPrint(...)
    print("[SERVER HOP DEBUG]", ...)
end

-- Configuración
local CONFIG = {
    MAX_RETRIES = 3,
    RETRY_DELAY = 2,
    MAX_SERVERS_PER_PAGE = 100,
    MIN_PLAYERS = 1,
    MAX_PLAYERS = 14,
    NOTIFICATION_DURATION = 5,
    DEBUG_MODE = true,
    COLORS = {
        GUI_BACKGROUND = Color3.fromRGB(25, 25, 25),
        GUI_BORDER = Color3.fromRGB(128, 128, 128),
        BUTTON_BACKGROUND = Color3.fromRGB(40, 40, 40),
        BUTTON_HOVER = Color3.fromRGB(60, 60, 60),
        TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
        TEXT_SECONDARY = Color3.fromRGB(255, 0, 0),
        TEXTBOX_BACKGROUND = Color3.fromRGB(35, 35, 35)
    }
}

-- Variables globales
local LocalPlayer = Players.LocalPlayer
local isProcessing = false
local gui = nil

-- Sistema de notificaciones mejorado
local function showNotification(title, message, duration)
    debugPrint("Mostrando notificación:", title, message)
    
    local notification = Instance.new("ScreenGui")
    notification.Name = "CustomNotification"
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 80)
    frame.Position = UDim2.new(1, -270, 1, -100)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    frame.BorderSizePixel = 1
    frame.Parent = notification
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = frame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 40)
    messageLabel.Position = UDim2.new(0, 10, 0, 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.TextSize = 14
    messageLabel.TextWrapped = true
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.Parent = frame
    
    notification.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Animación de entrada
    frame.Position = UDim2.new(1, 0, 1, -100)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(frame, tweenInfo, {Position = UDim2.new(1, -270, 1, -100)})
    tween:Play()
    
    -- Animación de salida y eliminación
    delay(duration or CONFIG.NOTIFICATION_DURATION, function()
        local fadeOut = TweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(1, 0, 1, -100)})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- Sistema de búsqueda de servidores
local function findBestServer(targetPlayers)
    debugPrint("Buscando servidor para", targetPlayers, "jugadores")
    
    local function fetchServers(cursor)
        local success, result = pcall(function()
            local url = string.format(
                "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=%d%s",
                game.PlaceId,
                CONFIG.MAX_SERVERS_PER_PAGE,
                cursor and ("&cursor=" .. cursor) or ""
            )
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if not success then
            debugPrint("Error al obtener servidores:", result)
            return nil
        end
        return result
    end
    
    local bestServer = nil
    local closestDiff = math.huge
    local serversChecked = 0
    
    showNotification("Buscando", "Analizando servidores disponibles...", 3)
    
    local pageData = fetchServers()
    if not pageData then 
        debugPrint("No se pudieron obtener servidores")
        return nil 
    end
    
    for _, server in pairs(pageData.data) do
        if server.playing and server.id ~= game.JobId then
            local diff = math.abs(server.playing - targetPlayers)
            if diff < closestDiff then
                closestDiff = diff
                bestServer = server
                debugPrint("Nuevo mejor servidor:", server.id, "con", server.playing, "jugadores")
            end
        end
        serversChecked = serversChecked + 1
    end
    
    debugPrint("Servidores revisados:", serversChecked)
    return bestServer
end

-- Función principal de procesamiento
local function processPlayerCount(count)
    debugPrint("Procesando cantidad:", count)
    
    if isProcessing then
        showNotification("Espera", "Ya se está buscando un servidor...", 3)
        return
    end
    
    if not count or count < CONFIG.MIN_PLAYERS or count > CONFIG.MAX_PLAYERS then
        showNotification("Error", string.format("El número debe estar entre %d y %d", CONFIG.MIN_PLAYERS, CONFIG.MAX_PLAYERS), 5)
        return
    end
    
    isProcessing = true
    showNotification("Buscando", "Iniciando búsqueda de servidor...", 3)
    
    local bestServer = findBestServer(count)
    
    if not bestServer then
        showNotification("Error", "No se encontró un servidor adecuado", 5)
        isProcessing = false
        return
    end
    
    showNotification("Servidor Encontrado", string.format("Servidor con %d jugadores", bestServer.playing), 3)
    
    -- Intentar teleportar
    local success = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServer.id)
    end)
    
    if not success then
        showNotification("Error", "No se pudo teleportar al servidor", 5)
    end
    
    isProcessing = false
end

-- GUI mejorado
local function createGui()
    if gui then gui:Destroy() end
    
    gui = Instance.new("ScreenGui")
    gui.Name = "ServerHopGui"
    gui.ResetOnSpawn = false
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 250, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
    mainFrame.BackgroundColor3 = CONFIG.COLORS.GUI_BACKGROUND
    mainFrame.BorderColor3 = CONFIG.COLORS.GUI_BORDER
    mainFrame.BorderSizePixel = 1
    mainFrame.Parent = gui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Contenedor del título
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(1, 0, 0, 30)
    titleContainer.Position = UDim2.new(0, 0, 0, 5)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = mainFrame
    
    -- Título "Adonis"
    local titleAdonis = Instance.new("TextLabel")
    titleAdonis.Size = UDim2.new(0, 70, 1, 0)
    titleAdonis.Position = UDim2.new(0.5, -70, 0, 0)
    titleAdonis.BackgroundTransparency = 1
    titleAdonis.Text = "Adonis"
    titleAdonis.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    titleAdonis.TextSize = 24
    titleAdonis.Font = Enum.Font.GothamBold
    titleAdonis.Parent = titleContainer
    
    -- Título "Except"
    local titleExcept = Instance.new("TextLabel")
    titleExcept.Size = UDim2.new(0, 70, 1, 0)
    titleExcept.Position = UDim2.new(0.5, 0, 0, 0)
    titleExcept.BackgroundTransparency = 1
    titleExcept.Text = "Except"
    titleExcept.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    titleExcept.TextSize = 24
    titleExcept.Font = Enum.Font.GothamBold
    titleExcept.Parent = titleContainer
    
    -- Campo de texto
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.8, 0, 0, 35)
    textBox.Position = UDim2.new(0.1, 0, 0.4, 0)
    textBox.BackgroundColor3 = CONFIG.COLORS.TEXTBOX_BACKGROUND
    textBox.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    textBox.PlaceholderText = "Número de jugadores (1-14)"
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.Text = ""
    textBox.TextSize = 14
    textBox.Font = Enum.Font.Gotham
    textBox.Parent = mainFrame
    
    -- Esquinas redondeadas para el TextBox
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 6)
    textBoxCorner.Parent = textBox
    
    -- Botón
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 35)
    button.Position = UDim2.new(0.1, 0, 0.7, 0)
    button.BackgroundColor3 = CONFIG.COLORS.BUTTON_BACKGROUND
    button.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    button.Text = "Buscar Servidor"
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.Parent = mainFrame
    
    -- Esquinas redondeadas para el botón
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Hacer el GUI arrastrable
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Conectar eventos
    button.MouseButton1Click:Connect(function()
        debugPrint("Botón clickeado")
        local number = tonumber(textBox.Text)
        if number then
            processPlayerCount(number)
        else
            showNotification("Error", "Por favor ingresa un número válido", 5)
        end
    end)
    
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            debugPrint("Enter presionado en TextBox")
            local number = tonumber(textBox.Text)
            if number then
                processPlayerCount(number)
            else
                showNotification("Error", "Por favor ingresa un número válido", 5)
            end
        end
    end)
    
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Inicialización
local function init()
    debugPrint("Iniciando script")
    createGui()
    showNotification("Server Hop", "Sistema iniciado correctamente", 5)
    
    -- Detectar mensajes del chat
    LocalPlayer.Chatted:Connect(function(message)
        local number = tonumber(message)
        if number then
            processPlayerCount(number)
        end
    end)
end

-- Iniciar con manejo de errores
local success, error = pcall(init)
if not success then
    debugPrint("Error al iniciar:", error)
    showNotification("Error", "Error al iniciar el sistema", 5)
end