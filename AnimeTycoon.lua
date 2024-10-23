
-- GUI Code with improved design and functionality

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

-- Speed Button
SpeedButton.Name = "SpeedButton"
SpeedButton.Parent = MainFrame
SpeedButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedButton.Size = UDim2.new(0.7, 0, 0.15, 0)
SpeedButton.Position = UDim2.new(0.3, 0, 0.5, 0)
SpeedButton.Text = "Set Speed"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

-- Jump Power Button
JumpPowerButton.Name = "JumpPowerButton"
JumpPowerButton.Parent = MainFrame
JumpPowerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
JumpPowerButton.Size = UDim2.new(0.7, 0, 0.15, 0)
JumpPowerButton.Position = UDim2.new(0.3, 0, 0.65, 0)
JumpPowerButton.Text = "Set JumpPower"
JumpPowerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpPowerButton.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
end)

-- Reset Button
ResetButton.Name = "ResetButton"
ResetButton.Parent = MainFrame
ResetButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ResetButton.Size = UDim2.new(0.7, 0, 0.15, 0)
ResetButton.Position = UDim2.new(0.3, 0, 0.8, 0)
ResetButton.Text = "Reset"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)

-- Sidebar navigation functionality
PlayerButton.MouseButton1Click:Connect(function()
    MainLabel.Text = "Player Menu"
end)

GameButton.MouseButton1Click:Connect(function()
    MainLabel.Text = "Game Menu"
end)

DiscordButton.MouseButton1Click:Connect(function()
    MainLabel.Text = "Discord Menu"
end)

-- Adding persistence after player respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 100
    humanoid.JumpPower = 150
end)