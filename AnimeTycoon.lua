local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Crear ventana principal
local Window = OrionLib:MakeWindow({Name = "Adonis Except", HidePremium = false, SaveConfig = true, ConfigFolder = "AdonisConfig", IntroEnabled = true, IntroText = "Adonis Except"})

-- Tab Player
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998"})

-- Speed y Jumppower con input y persistencia
PlayerTab:AddSlider({
	Name = "Speed",
	Min = 0,
	Max = 200,
	Default = 16,
	Color = Color3.fromRGB(255, 0, 0),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		local char = game.Players.LocalPlayer.Character
		char.Humanoid.WalkSpeed = Value
		-- Persistencia
		char.Humanoid.Died:Connect(function()
			char.Humanoid.WalkSpeed = Value
		end)
	end
})

PlayerTab:AddSlider({
	Name = "Jumppower",
	Min = 0,
	Max = 200,
	Default = 50,
	Color = Color3.fromRGB(255, 255, 0),
	Increment = 1,
	ValueName = "Jumppower",
	Callback = function(Value)
		local char = game.Players.LocalPlayer.Character
		char.Humanoid.JumpPower = Value
		-- Persistencia
		char.Humanoid.Died:Connect(function()
			char.Humanoid.JumpPower = Value
		end)
	end
})

-- Botón para coordenadas
PlayerTab:AddButton({
	Name = "Get Coordinates",
	Callback = function()
		local position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
		local coords = "X: " .. math.floor(position.X) .. ", Y: " .. math.floor(position.Y) .. ", Z: " .. math.floor(position.Z)
		OrionLib:MakeNotification({Name = "Coordinates", Content = coords, Time = 5})
		setclipboard(coords)
	end
})

-- Tab Game
local GameTab = Window:MakeTab({Name = "Game", Icon = "rbxassetid://4483345998"})

-- Teleport a otro jugador
GameTab:AddTextbox({
	Name = "TP to Player",
	Default = "",
	TextDisappear = true,
	Callback = function(PlayerName)
		local found = false
		for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
			if player.Name:lower():find(PlayerName:lower()) then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
				OrionLib:MakeNotification({Name = "Teleported", Content = "Teleported to: " .. player.DisplayName, Time = 5})
				found = true
				break
			end
		end
		if not found then
			OrionLib:MakeNotification({Name = "Error", Content = "Player not found", Time = 5})
		end
	end
})

-- Auto collect con teletransporte cada 5 minutos
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

local teamNames = {"Todoroki", "Vegeta", "Sasuke", "Gon", "Luffy", "Deku", "Goku", "Naruto", "Gojo", "Zoro"}

GameTab:AddToggle({
	Name = "Auto Collect",
	Default = false,
	Callback = function(Value)
		autoCollect = Value
		if autoCollect then
			while autoCollect do
				local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
				local playerTeam = tostring(game.Players.LocalPlayer.Team)

				for _, team in ipairs(teamNames) do
					if playerTeam == team then
						local location = collectLocations[team]
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(location)
						wait(1)
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
						wait(300) -- Esperar 5 minutos
						break
					end
				end
			end
		end
	end
})

-- Tab Discord (Vacío)
Window:MakeTab({Name = "Discord", Icon = "rbxassetid://4483345998"})

-- Inicializar Orion
OrionLib:Init()