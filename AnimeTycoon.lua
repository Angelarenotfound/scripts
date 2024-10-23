local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local teams = {"Team1", "Team2", "Team3", "Team4", "Team5", "Team6", "Team7", "Team8", "Team9", "Team10"}
local isAutoCollectEnabled = false
local currentTab = "Player"
local isGuiVisible = true

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.1
frame.ClipsDescendants = true
frame.BorderSizePixel = 2
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.BorderRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Text = "Angelarenotfound's GUI"
title.Size = UDim2.new(1, -30, 0, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.BackgroundTransparency = 1
title.BorderRadius = UDim.new(0, 10)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Parent = frame
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = frame
closeButton.BorderRadius = UDim.new(0, 5)
closeButton.Active = true
closeButton.Draggable = true

closeButton.MouseButton1Click:Connect(function()
    isGuiVisible = not isGuiVisible
    frame.Visible = isGuiVisible
end)

local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 100, 1, 0)
sideBar.Position = UDim2.new(0, 0, 0, 50)
sideBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sideBar.BorderSizePixel = 2
sideBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
sideBar.Parent = frame
sideBar.BorderRadius = UDim.new(0, 10)

local tabs = {"Player", "Game", "Discord"}
local buttons = {}

for i, tab in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Text = tab
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i - 1) * 50)
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = sideBar
    table.insert(buttons, button)
    button.BorderRadius = UDim.new(0, 10)
    
    button.MouseButton1Click:Connect(function()
        currentTab = tab
        updateTabContent()
    end)
end
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -100, 1, -50)
contentArea.Position = UDim2.new(0, 100, 0, 50)
contentArea.BackgroundTransparency = 1
contentArea.Parent = frame

local function updateTabContent()
    contentArea:ClearAllChildren()

    if currentTab == "Player" then
        local speedInput = Instance.new("TextBox")
        speedInput.PlaceholderText = "Speed"
        speedInput.Size = UDim2.new(0, 200, 0, 50)
        speedInput.Position = UDim2.new(0, 50, 0, 0)
        speedInput.Parent = contentArea

        local jumpPowerInput = Instance.new("TextBox")
        jumpPowerInput.PlaceholderText = "JumpPower"
        jumpPowerInput.Size = UDim2.new(0, 200, 0, 50)
        jumpPowerInput.Position = UDim2.new(0, 50, 0, 60)
        jumpPowerInput.Parent = contentArea

        local resetSpeed = Instance.new("TextButton")
        resetSpeed.Text = "Reset Speed"
        resetSpeed.Size = UDim2.new(0, 200, 0, 50)
        resetSpeed.Position = UDim2.new(0, 50, 0, 120)
        resetSpeed.Parent = contentArea

        resetSpeed.MouseButton1Click:Connect(function()
            humanoid.WalkSpeed = 16
        end)

        local resetJumpPower = Instance.new("TextButton")
        resetJumpPower.Text = "Reset JumpPower"
        resetJumpPower.Size = UDim2.new(0, 200, 0, 50)
        resetJumpPower.Position = UDim2.new(0, 50, 0, 180)
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
        local autoCollectToggle = Instance.new("TextButton")
        autoCollectToggle.Text = "Auto Collect: OFF"
        autoCollectToggle.Size = UDim2.new(0, 200, 0, 50)
        autoCollectToggle.Position = UDim2.new(0, 50, 0, 0)
        autoCollectToggle.Parent = contentArea

        autoCollectToggle.MouseButton1Click:Connect(function()
            isAutoCollectEnabled = not isAutoCollectEnabled
            autoCollectToggle.Text = isAutoCollectEnabled and "Auto Collect: ON" or "Auto Collect: OFF"
        end)

        local getCoordinatesButton = Instance.new("TextButton")
        getCoordinatesButton.Text = "Obtener Coordenadas"
        getCoordinatesButton.Size = UDim2.new(0, 200, 0, 50)
        getCoordinatesButton.Position = UDim2.new(0, 50, 0, 60)
        getCoordinatesButton.Parent = contentArea

        getCoordinatesButton.MouseButton1Click:Connect(function()
            local pos = character.HumanoidRootPart.Position
            local notification = Instance.new("TextLabel")
            notification.Text = "Coordenadas: (" .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z) .. ")"
            notification.Size = UDim2.new(0, 300, 0, 50)
            notification.Position = UDim2.new(0, 50, 0, 120)
            notification.Parent = contentArea
local copyButton = Instance.new("TextButton")
            copyButton.Text = "Copiar"
            copyButton.Size = UDim2.new(0, 100, 0, 50)
            copyButton.Position = UDim2.new(0, 360, 0, 120)
            copyButton.Parent = contentArea

            copyButton.MouseButton1Click:Connect(function()
                setclipboard("(" .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z) .. ")")
            end)
        end)

    elseif currentTab == "Discord" then
        -- Discord Tab (Empty)
        local label = Instance.new("TextLabel")
        label.Text = "Por el momento está vacío"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 24
        label.BackgroundTransparency = 1
        label.Parent = contentArea
    end
end
updateTabContent()