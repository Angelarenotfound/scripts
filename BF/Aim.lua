-- Variables
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local rs = game:GetService("RunService")
local camera = game.Workspace.CurrentCamera
local guiVisible = false
local following = false
local targetPlayer = nil

-- Crear botón de Mostrar/Ocultar
local toggleButton = Instance.new("TextButton")
toggleButton.Parent = playerGui:WaitForChild("ScreenGui")
toggleButton.Size = UDim2.new(0, 140, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10) -- Posicionado en la parte superior izquierda
toggleButton.Text = "Mostrar GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.ZIndex = 2

-- Crear frame principal de GUI
local mainFrame = Instance.new("Frame")
mainFrame.Parent = playerGui:WaitForChild("ScreenGui")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5
mainFrame.Visible = guiVisible

-- Crear botón de seguir jugador
local followButton = Instance.new("TextButton")
followButton.Parent = mainFrame
followButton.Size = UDim2.new(0, 200, 0, 50)
followButton.Position = UDim2.new(0.5, -100, 0.2, 0)
followButton.Text = "Seguir Jugador"
followButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
followButton.TextColor3 = Color3.fromRGB(255, 255, 255)
followButton.TextScaled = true

-- Crear botón para dejar de seguir
local stopFollowButton = Instance.new("TextButton")
stopFollowButton.Parent = mainFrame
stopFollowButton.Size = UDim2.new(0, 200, 0, 50)
stopFollowButton.Position = UDim2.new(0.5, -100, 0.6, 0)
stopFollowButton.Text = "Dejar de Seguir"
stopFollowButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
stopFollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopFollowButton.TextScaled = true

-- Funcionalidad del botón de Mostrar/Ocultar
toggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
    toggleButton.Text = guiVisible and "Ocultar GUI" or "Mostrar GUI"
end)

-- Funcionalidad del botón de Seguir Jugador
followButton.MouseButton1Click:Connect(function()
    if following then return end
    following = true
    
    local userInputService = game:GetService("UserInputService")
    userInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = player:GetMouse()
            local target = mouse.Target

            if target and target.Parent:FindFirstChild("Humanoid") then
                targetPlayer = game.Players:GetPlayerFromCharacter(target.Parent)
                if targetPlayer then
                    print("Siguiendo a:", targetPlayer.Name)
                end
            end
        end
    end)
end)

-- Funcionalidad del botón Dejar de Seguir
stopFollowButton.MouseButton1Click:Connect(function()
    following = false
    targetPlayer = nil
    camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
    print("Dejaste de seguir al jugador")
end)

-- Actualizar cámara en tercera persona
rs.RenderStepped:Connect(function()
    if following and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = targetPlayer.Character.HumanoidRootPart
        camera.CameraSubject = rootPart
        camera.CameraType = Enum.CameraType.Custom
    else
        camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
    end
end)