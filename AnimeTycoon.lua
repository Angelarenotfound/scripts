-- GUI Code with improved design and functionality for Mobile compatibility

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local Sidebar = Instance.new("Frame")
local PlayerButton = Instance.new("TextButton")
local GameButton = Instance.new("TextButton")
local DiscordButton = Instance.new("TextButton")
local MainLabel = Instance.new("TextLabel")
local SpeedButton = Instance.new("TextButton")
local JumpPowerButton = Instance.new("TextButton")
local ResetButton = Instance.new("TextButton")
local AutoCollectButton = Instance.new("TextButton")
local GetCoordsButton = Instance.new("TextButton")
local TPButton = Instance.new("TextButton")
local PlayerInput = Instance.new("TextBox")
local NotificationLabel = Instance.new("TextLabel")

-- Setting up the ScreenGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Active = true
MainFrame.Draggable = true
-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = ScreenGui
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -60, 0, 40)
CloseButton.Text = "X"
CloseButton.Draggable = true

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Sidebar
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.Size = UDim2.new(0, 100, 1, 0)

-- Player Button
PlayerButton.Name = "PlayerButton"
PlayerButton.Parent = Sidebar
PlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerButton.Size = UDim2.new(1, 0, 0, 50)
PlayerButton.Text = "Player"
PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Game Button
GameButton.Name = "GameButton"
GameButton.Parent = Sidebar
GameButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GameButton.Size = UDim2.new(1, 0, 0, 50)
GameButton.Position = UDim2.new(0, 0, 0, 50)
GameButton.Text = "Game"
GameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
-- Discord Button
DiscordButton.Name = "DiscordButton"
DiscordButton.Parent = Sidebar
DiscordButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DiscordButton.Size = UDim2.new(1, 0, 0, 50)
DiscordButton.Position = UDim2.new(0, 0, 0, 100)
DiscordButton.Text = "Discord"
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Main Label (shows content based on the sidebar)
MainLabel.Name = "MainLabel"
MainLabel.Parent = MainFrame
MainLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainLabel.Size = UDim2.new(0.7, 0, 0.3, 0)
MainLabel.Position = UDim2.new(0.3, 0, 0.1, 0)
MainLabel.Text = "Angelarenotfound's GUI"
MainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MainLabel.Font = Enum.Font.SourceSans
MainLabel.TextSize = 24

-- Game Section Functions
GameButton.MouseButton1Click:Connect(function()
    MainLabel.Text = "Game Menu"
end)
-- Auto Collect Functionality
AutoCollectButton.Name = "AutoCollectButton"
AutoCollectButton.Parent = MainFrame
AutoCollectButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoCollectButton.Size = UDim2.new(0.7, 0, 0.15, 0)
AutoCollectButton.Position = UDim2.new(0.3, 0, 0.5, 0)
AutoCollectButton.Text = "Auto Collect OFF"
AutoCollectButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local autoCollect = false
AutoCollectButton.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    if autoCollect then
        AutoCollectButton.Text = "Auto Collect ON"
        while autoCollect do
            local team = game.Players.LocalPlayer.Team.Name
            if team == "Team1" then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100, 10, 100)
            elseif team == "Team2" then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(200, 10, 200)
            end
            wait(300)
        end
    else
        AutoCollectButton.Text = "Auto Collect OFF"
    end
end)
-- Get Coordinates Functionality
GetCoordsButton.Name = "GetCoordsButton"
GetCoordsButton.Parent = MainFrame
GetCoordsButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
GetCoordsButton.Size = UDim2.new(0.7, 0, 0.15, 0)
GetCoordsButton.Position = UDim2.new(0.3, 0, 0.65, 0)
GetCoordsButton.Text = "Show Coordinates"
GetCoordsButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local function getCoordinates()
    local position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    return "X: " .. math.floor(position.X) .. ", Y: " .. math.floor(position.Y) .. ", Z: " .. math.floor(position.Z)
end

GetCoordsButton.MouseButton1Click:Connect(function()
    local coords = getCoordinates()
    NotificationLabel.Text = coords
end)

-- Teleport Functionality
TPButton.Name = "TPButton"
TPButton.Parent = MainFrame
TPButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TPButton.Size = UDim2.new(0.7, 0, 0.15, 0)
TPButton.Position = UDim2.new(0.3, 0, 0.8, 0)
TPButton.Text = "Teleport"
TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)

PlayerInput.Parent = MainFrame
PlayerInput.PlaceholderText = "Enter player name"
PlayerInput.Size = UDim2.new(0.7, 0, 0.15, 0)
PlayerInput.Position = UDim2.new(0.3, 0, 0.7, 0)

TPButton.MouseButton1Click:Connect(function()
    local input = PlayerInput.Text:lower()
    local found = false
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player.Name:lower():find(input) or player.DisplayName:lower():find(input) then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
            NotificationLabel.Text = "Teleported to: " .. player.DisplayName
            found = true
            break
        end
    end
    if not found then
        NotificationLabel.Text = "Player not found"
    end
end)

-- Notification Label
NotificationLabel.Parent = MainFrame
NotificationLabel.Size = UDim2.new(0.7, 0, 0.15, 0)
NotificationLabel.Position = UDim2.new(0.3, 0, 0.9, 0)
NotificationLabel.Text = "Waiting for action..."
NotificationLabel.TextWrapped = true