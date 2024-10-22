local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 60)
button.Position = UDim2.new(0, 10, 0.5, -30)
button.AnchorPoint = Vector2.new(0, 0.5)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Lock On"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = button

local originalColor = button.BackgroundColor3
button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
end)
button.MouseLeave:Connect(function()
    button.BackgroundColor3 = originalColor
end)

local isLocked = false
local lockedPlayer = nil

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character
    if not localCharacter then return end
    local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = workspace.Characters:FindFirstChild(player.Name)
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    local distance = (root.Position - localRoot.Position).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function aimAtPlayer(player)
    local character = workspace.Characters:FindFirstChild(player.Name)
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
        end
    end
end

button.MouseButton1Click:Connect(function()
    if not isLocked then
        lockedPlayer = getClosestPlayer()
        if lockedPlayer then
            isLocked = true
            button.Text = "Lock Off"
            print("Locked onto " .. lockedPlayer.Name)
        end
    else
        isLocked = false
        lockedPlayer = nil
        button.Text = "Lock On"
        print("Lock disabled")
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if isLocked and lockedPlayer then
        aimAtPlayer(lockedPlayer)
    end
end)
