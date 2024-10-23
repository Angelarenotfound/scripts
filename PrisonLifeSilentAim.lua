local aimbotEnabled = false
local targetPart = "Head"
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera

function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    print("Aimbot toggled:", aimbotEnabled)
end

function setTarget(part)
    targetPart = part
    print("Aimbot target set to:", targetPart)
end

function getClosestPlayerToClick(clickPosition)
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    local ray = camera:ScreenPointToRay(clickPosition.X, clickPosition.Y)
    local rayOrigin = ray.Origin
    local rayDirection = ray.Direction * 500

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (otherPlayer.Character.HumanoidRootPart.Position - rayOrigin).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end

    return closestPlayer
end

function aimAt(enemy)
    local partToAim = enemy.Character:FindFirstChild(targetPart)
    if partToAim then
        camera.CFrame = CFrame.new(camera.CFrame.Position, partToAim.Position)
    end
end

local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if aimbotEnabled and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local clickPosition = input.Position -- Obtener la posición del clic o toque

        local enemy = getClosestPlayerToClick(clickPosition)
        if enemy then
            aimAt(enemy)
        end
    end
end)

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local headButton = Instance.new("TextButton", gui)
headButton.Position = UDim2.new(0, 50, 0, 50)
headButton.Size = UDim2.new(0, 150, 0, 50)
headButton.Text = "Apuntar a la Cabeza"
headButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
headButton.TextScaled = true

headButton.MouseButton1Click:Connect(function()
    setTarget("Head")
end)

local torsoButton = Instance.new("TextButton", gui)
torsoButton.Position = UDim2.new(0, 50, 0, 120)
torsoButton.Size = UDim2.new(0, 150, 0, 50)
torsoButton.Text = "Apuntar al Torso"
torsoButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
torsoButton.TextScaled = true

torsoButton.MouseButton1Click:Connect(function()
    setTarget("Torso")
end)

local toggleButton = Instance.new("TextButton", gui)
toggleButton.Position = UDim2.new(0, 50, 0, 190)
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Text = "Toggle Aimbot"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
toggleButton.TextScaled = true

toggleButton.MouseButton1Click:Connect(toggleAimbot)