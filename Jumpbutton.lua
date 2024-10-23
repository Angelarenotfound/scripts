local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Text = "Salta"
button.Size = UDim2.new(0, 100, 0, 50)  -- Tamaño del botón (100x50 píxeles)
button.Position = UDim2.new(0.5, -50, 0.5, -25)  -- Centrado en la pantalla
button.BackgroundColor3 = Color3.new(1, 0, 0)  -- Color rojo
button.TextScaled = true
button.Draggable = true
button.Selectable = true

local function onButtonClick()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    if humanoid then
        humanoid.Jump = true
    end
end

button.MouseButton1Click:Connect(onButtonClick)
