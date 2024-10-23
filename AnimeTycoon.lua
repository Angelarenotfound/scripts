local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local currentTab = "Player"
local isGuiVisible = true

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

-- Frame principal con estilo visual mejorado
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Fondo oscuro similar a la imagen
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 0.2 -- Le damos algo de transparencia

-- TÃ­tulo con diseÃ±o mejorado
local title = Instance.new("TextLabel")
title.Text = "Angelarenotfound's GUI"
title.Size = UDim2.new(1, -30, 0, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold -- CambiÃ© la fuente para un estilo mÃ¡s moderno
title.TextSize = 24
title.BackgroundTransparency = 1
title.Parent = frame

-- BotÃ³n "X" flotante y desplazable
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.95, 10, 0, 0) -- PosiciÃ³n ajustada para que estÃ© separado
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- BotÃ³n rojo destacado
closeButton.BorderSizePixel = 0
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = screenGui -- Se agrega fuera del frame para ser independiente
closeButton.Active = true
closeButton.Draggable = true -- BotÃ³n puede moverse

closeButton.MouseButton1Click:Connect(function()
    isGuiVisible = not isGuiVisible
    frame.Visible = isGuiVisible
end)

-- Barra lateral con tabs
local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 100, 1, 0)
sideBar.Position = UDim2.new(0, 0, 0, 50)
sideBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Fondo ligeramente mÃ¡s claro
sideBar.BorderSizePixel = 0
sideBar.Parent = frame

-- Lista de tabs con nuevo estilo
local tabs = {"Player", "Game", "Discord"}
local buttons = {}

for i, tab in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Text = tab
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i - 1) * 50)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Estilo mÃ¡s oscuro
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham -- Fuente moderna
    button.TextSize = 18
    button.Parent = sideBar
    table.insert(buttons, button)

    button.MouseButton1Click:Connect(function()
        currentTab = tab
        updateTabContent()
    end)
end

-- Ãrea de contenido
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -100, 1, -50)
contentArea.Position = UDim2.new(0, 100, 0, 50)
contentArea.BackgroundTransparency = 0.2 -- Transparente, similar al estilo de la imagen proporcionada
contentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Fondo oscuro
contentArea.BorderSizePixel = 0
contentArea.Parent = frame

-- Actualizar contenido de tabs
local function updateTabContent()
    contentArea:ClearAllChildren()

    if currentTab == "Player" then
        -- Contenido para la pestaÃ±a de Player
        local speedInput = Instance.new("TextBox")
        speedInput.PlaceholderText = "Speed"
        speedInput.Size = UDim2.new(0, 200, 0, 50)
        speedInput.Position = UDim2.new(0, 50, 0, 0)
        speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedInput.Font = Enum.Font.Gotham
        speedInput.TextSize = 18
        speedInput.Parent = contentArea

        local jumpPowerInput = Instance.new("TextBox")
        jumpPowerInput.PlaceholderText = "JumpPower"
        jumpPowerInput.Size = UDim2.new(0, 200, 0, 50)
        jumpPowerInput.Position = UDim2.new(0, 50, 0, 60)
        jumpPowerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        jumpPowerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpPowerInput.Font = Enum.Font.Gotham
        jumpPowerInput.TextSize = 18
        jumpPowerInput.Parent = contentArea

        local resetSpeed = Instance.new("TextButton")
        resetSpeed.Text = "Reset Speed"
        resetSpeed.Size = UDim2.new(0, 200, 0, 50)
        resetSpeed.Position = UDim2.new(0, 50, 0, 120)
        resetSpeed.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- BotÃ³n oscuro
        resetSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
        resetSpeed.Font = Enum.Font.Gotham
        resetSpeed.TextSize = 18
        resetSpeed.Parent = contentArea

        resetSpeed.MouseButton1Click:Connect(function()
            humanoid.WalkSpeed = 16
        end)

        local resetJumpPower = Instance.new("TextButton")
        resetJumpPower.Text = "Reset JumpPower"
        resetJumpPower.Size = UDim2.new(0, 200, 0, 50)
        resetJumpPower.Position = UDim2.new(0, 50, 0, 180)
        resetJumpPower.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- BotÃ³n oscuro
        resetJumpPower.TextColor3 = Color3.fromRGB(255, 255, 255)
        resetJumpPower.Font = Enum.Font.Gotham
        resetJumpPower.TextSize = 18
        resetJumpPower.Parent = contentArea

        resetJumpPower.MouseButton1Click:Connect(function()
            humanoid.JumpPower = 50
        end)

        speedInput.FocusLost:Connect(function()
            local newSpeed = tonumber(speedInput.Text)
            if newSpeed then
                humanoid.WalkSpeed = newSpeed
            end
        end)

        jumpPowerInput.FocusLost:Connect(function()
            local newJumpPower = tonumber(jumpPowerInput.Text)
            if newJumpPower then
                humanoid.JumpPower = newJumpPower
            end
        end)

    elseif currentTab == "Game" then
        -- Contenido para la pestaÃ±a de Game
        local autoCollectToggle = Instance.new("TextButton")
        autoCollectToggle.Text = "Auto Collect: OFF"
        autoCollectToggle.Size = UDim2.new(0, 200, 0, 50)
        autoCollectToggle.Position = UDim2.new(0, 50, 0, 0)
        autoCollectToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        autoCollectToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoCollectToggle.Font = Enum.Font.Gotham
        autoCollectToggle.TextSize = 18
        autoCollectToggle.Parent = contentArea

        autoCollectToggle.MouseButton1Click:Connect(function()
            -- Cambia el estado del auto collect
        end)

    elseif currentTab == "Discord" then
        -- Contenido para la pestaÃ±a de Discord
        local label = Instance.new("TextLabel")
        label.Text = "Por el momento estÃ¡ vacÃ­o"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 18
        label.Parent = contentArea
    end
end

-- Inicializar la pestaÃ±a de Player
updateTabContent()