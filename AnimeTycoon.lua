-- GUI Code with improved design and functionality for Mobile compatibility

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local Sidebar = Instance.new("Frame")
local PlayerButton = Instance.new("TextButton")
local GameButton = Instance.new("TextButton")
local DiscordButton = Instance.new("TextButton")
local MainLabel = Instance.new("TextLabel")
local AutoCollectButton = Instance.new("TextButton")
local GetCoordsButton = Instance.new("TextButton")
local TPButton = Instance.new("TextButton")
local PlayerInput = Instance.new("TextBox")
local NotificationLabel = Instance.new("TextLabel")

-- Setting up the ScreenGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame (Responsive for Mobile)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Size = UDim2.new(0.4, 0, 0.5, 0) -- Adjusted for better mobile display
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
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

-- Sidebar (responsive positioning)
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

-- Navigation functionality
PlayerButton.MouseButton1Click:Connect(function()
    MainLabel.Text = "Player Menu"
end)

GameButton.MouseButton1Click:Connect(function()
    MainLabel.Text = "Game Menu"
end)

DiscordButton.MouseButton1Click:Connect(function()
    MainLabel.Text = "Join us on Discord!"
end)
-- Auto Collect functionality (Teams with coordinates and quick teleport)
AutoCollectButton.Name = "AutoCollectButton"
AutoCollectButton.Parent = MainFrame
AutoCollectButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoCollectButton.Size = UDim2.new(0.7, 0, 0.15, 0)
AutoCollectButton.Position = UDim2.new(0.3, 0, 0.5, 0)
AutoCollectButton.Text = "Auto Collect OFF"
AutoCollectButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local autoCollect = false
local collectLocations = {
    Todoroki = Vector3.new(186, 6, 104),
    Vegeta = Vector3.new(88, 6, 197),
    Sasuke = Vector3.new(-53, 6, 214),
    Gon = Vector3.new(176, 6, 142),
    Luffy = Vector3.new(-229, 6, 19),
    Deku = Vector3.new(-202, 6, -111),
    Goku = Vector3.new(-105, 6, -202),
    Naruto = Vector3.new(36, 6, -220),
    Gojo = Vector3.new(159, 6, -148),
    Zoro = Vector3.new(212, 6, -26)
}

AutoCollectButton.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    if autoCollect then
        AutoCollectButton.Text = "Auto Collect ON"
        while autoCollect do
            local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            for _, location in pairs(collectLocations) do
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(location)
                wait(1) -- Quick teleport
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
                wait(300) -- 5 minutes (300 seconds)
            end
        end
    else
        AutoCollectButton.Text = "Auto Collect OFF"
    end
end)
-- Get Coordinates and copy to clipboard
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
    setclipboard(coords) -- Copy to clipboard
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