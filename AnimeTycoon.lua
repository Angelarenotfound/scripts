local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Adonis Except", HidePremium = false, SaveConfig = true, ConfigFolder = "AdonisExcept"})

local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false})

PlayerTab:AddTextbox({
    Name = "Speed",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(Value)
    end    
})

PlayerTab:AddTextbox({
    Name = "Jump Power",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(Value)
    end    
})

PlayerTab:AddButton({
    Name = "Get Coordinates",
    Callback = function()
        local position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        local coords = "X: " .. math.floor(position.X) .. ", Y: " .. math.floor(position.Y) .. ", Z: " .. math.floor(position.Z)
        OrionLib:MakeNotification({
            Name = "Coordinates",
            Content = coords,
            Time = 5
        })
        setclipboard(coords)
    end
})

PlayerTab:AddTextbox({
    Name = "TP to Player",
    Default = "",
    TextDisappear = true,
    Callback = function(input)
        local found = false
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player.Name:lower():find(input:lower()) or player.DisplayName:lower():find(input:lower()) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                OrionLib:MakeNotification({
                    Name = "Teleported",
                    Content = "Teleported to: " .. player.DisplayName,
                    Time = 5
                })
                found = true
                break
            end
        end
        if not found then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Player not found",
                Time = 5
            })
        end
    end
})

local GameTab = Window:MakeTab({Name = "Game", Icon = "rbxassetid://4483345998", PremiumOnly = false})

GameTab:AddButton({
    Name = "TP Home",
    Callback = function()
        local team = game.Players.LocalPlayer.Team.Name
        local locations = {
            ["Goku"] = Vector3.new(-83, 6, -206),
            ["Deku"] = Vector3.new(-185, 6, -125),
            ["Luffy"] = Vector3.new(-224, 6, -2),
            ["Gon"] = Vector3.new(-183, 6, 120),
            ["Sasuke"] = Vector3.new(-72, 6, 201),
            ["Vegeta"] = Vector3.new(66, 6, 199),
            ["Todoroki"] = Vector3.new(169, 6, 120),
            ["Zoro"] = Vector3.new(207, 6, -4),
            ["Gojo"] = Vector3.new(166, 6, -127),
            ["Naruto"] = Vector3.new(55, 6, -207)
        }
        local position = locations[team]
        if position then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
            OrionLib:MakeNotification({
                Name = "Teleported",
                Content = "Teleported to: " .. team .. " Home",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Team not recognized",
                Time = 5
            })
        end
    end
})

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

local timeLeft = 120
local timeLabel = GameTab:AddLabel("Time until next TP: " .. timeLeft .. " seconds")

GameTab:AddButton({
    Name = "Auto Collect",
    Callback = function()
        autoCollect = not autoCollect
        if autoCollect then
            OrionLib:MakeNotification({Name = "Auto Collect", Content = "Enabled", Time = 5})
            spawn(function()
                while autoCollect do
                    timeLeft = 120
                    while timeLeft > 0 do
                        timeLabel:Set("Time until next TP: " .. timeLeft .. " seconds")
                        wait(1)
                        timeLeft = timeLeft - 1
                    end
                    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    for _, location in pairs(collectLocations) do
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(location)
                        wait(1)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
                        wait(120)
                    end
                    timeLeft = 120
                end
            end)
        else
            OrionLib:MakeNotification({Name = "Auto Collect", Content = "Disabled", Time = 5})
            timeLabel:Set("Auto Collect Disabled")
        end
    end
})

local TeleportsTab = Window:MakeTab({Name = "Teleports", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local teleportLocations = {
    ["Naruto"] = Vector3.new(55, 6, -207),
    ["Goku"] = Vector3.new(-83, 6, -206),
    ["Deku"] = Vector3.new(-185, 6, -125),
    ["Sasuke"] = Vector3.new(-72, 6, 201),
    ["Vegeta"] = Vector3.new(66, 6, 199),
    ["Todoroki"] = Vector3.new(169, 6, 120),
    ["Zoro"] = Vector3.new(207, 6, -4),
    ["Gojo"] = Vector3.new(166, 6, -127)
}

for name, position in pairs(teleportLocations) do
    TeleportsTab:AddButton({
        Name = name,
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
            OrionLib:MakeNotification({
                Name = "Teleported",
                Content = "Teleported to: " .. name,
                Time = 5
            })
        end
    })
end

OrionLib:Init()