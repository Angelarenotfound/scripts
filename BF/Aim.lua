-- Variables
local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local guiOpen = false
local targetPlayer = nil
local following = false
local dragging = false
local dragInput, mousePos, framePos

-- Creación del GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.IgnoreGuiInset = true

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.5, -60, 0.8, 0)
toggleButton.Text = "Mostrar GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
toggleButton.TextScaled = true
toggleButton.Parent = screenGui

-- Habilitar arrastre del botón "Mostrar GUI"
toggleButton.MouseEnter:Connect(function()
    toggleButton.BorderSizePixel = 2
end)

toggleButton.MouseLeave:Connect(function()
    toggleButton.BorderSizePixel = 0
end)

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

uis.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        toggleButton.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.6, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.new(0, 0, 0)
frame.Visible = false
frame.Parent = screenGui
frame.Draggable = true
frame.Active = true

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Adonis " .. '<font color="rgb(255, 0, 0)">Except</font>'
title.RichText = true
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = frame

-- Botón de seguir/detener
local followButton = Instance.new("TextButton")
followButton.Size = UDim2.new(0.8, 0, 0, 40)
followButton.Position = UDim2.new(0.1, 0, 0.25, 0)
followButton.Text = "Seguir/Detener"
followButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
followButton.TextScaled = true
followButton.Parent = frame

-- Botón de cambiar jugador
local changeButton = Instance.new("TextButton")
changeButton.Size = UDim2.new(0.8, 0, 0, 40)
changeButton.Position = UDim2.new(0.1, 0, 0.55, 0)
changeButton.Text = "Cambiar Jugador"
changeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
changeButton.TextScaled = true
changeButton.Parent = frame

-- Label de jugador seguido
local playerLabel = Instance.new("TextLabel")
playerLabel.Size = UDim2.new(1, 0, 0, 30)
playerLabel.Position = UDim2.new(0, 0, 0.85, 0)
playerLabel.Text = "Jugador seguido: Ninguno"
playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerLabel.BackgroundTransparency = 1
playerLabel.TextScaled = true
playerLabel.Parent = frame

-- Funciones
toggleButton.MouseButton1Click:Connect(function()
    guiOpen = not guiOpen
    frame.Visible = guiOpen
    if guiOpen then
        toggleButton.Text = "Ocultar GUI"
    else
        toggleButton.Text = "Mostrar GUI"
    end
end)

followButton.MouseButton1Click:Connect(function()
    following = not following
    if following then
        followButton.Text = "Detener"
    else
        followButton.Text = "Seguir"
        targetPlayer = nil
        playerLabel.Text = "Jugador seguido: Ninguno"
    end
end)

-- Función para obtener el jugador más cercano
local function getNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = p
                shortestDistance = distance
            end
        end
    end
    return closestPlayer
end

-- Función para cambiar de jugador
changeButton.MouseButton1Click:Connect(function()
    local newTarget = getNearestPlayer()
    if newTarget then
        targetPlayer = newTarget
        playerLabel.Text = "Jugador seguido: " .. newTarget.Name
    end
end)

-- Actualizar cámara
rs.RenderStepped:Connect(function()
    if following and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetPlayer.Character.HumanoidRootPart.Position
        camera.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position, targetPos)
    end
end)