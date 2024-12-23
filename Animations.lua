if getgenv().ANIMATIONSEXECUTED then return end
getgenv().ANIMATIONSEXECUTED = true

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Dragging = false
local DragStart = nil
local StartPos = nil
local LastTouch = nil
local SavedSpeed = 16
local AnimationsVisible = false

-- Animation IDs
local Animations = {
    Ninja = {
        Idle1 = "rbxassetid://656117400",
        Idle2 = "rbxassetid://656118341",
        Walk = "rbxassetid://656121766",
        Run = "rbxassetid://656118852",
        Fall = "rbxassetid://656115606",
        Jump = "rbxassetid://656117878",
        Climb = "rbxassetid://656114359",
        Swim = "rbxassetid://656119721",
        SwimIdle = "rbxassetid://656121397"
    },
    Elder = {
        Idle1 = "rbxassetid://845397899",
        Idle2 = "rbxassetid://845398858",
        Walk = "rbxassetid://845403856",
        Run = "rbxassetid://845386501",
        Fall = "rbxassetid://845398858",
        Jump = "rbxassetid://845398858",
        Climb = "rbxassetid://845392038",
        Swim = "rbxassetid://845401742",
        SwimIdle = "rbxassetid://845403127"
    },
    Levitation = {
        Idle1 = "rbxassetid://616006778",
        Idle2 = "rbxassetid://616008087",
        Walk = "rbxassetid://616013216",
        Run = "rbxassetid://616010382",
        Fall = "rbxassetid://616005863",
        Jump = "rbxassetid://616008936",
        Climb = "rbxassetid://616003713",
        Swim = "rbxassetid://616011509",
        SwimIdle = "rbxassetid://616012453"
    },
    Zombie = {
        Idle1 = "rbxassetid://616158929",
        Idle2 = "rbxassetid://616160636",
        Walk = "rbxassetid://616168032",
        Run = "rbxassetid://616163682",
        Fall = "rbxassetid://616157476",
        Jump = "rbxassetid://616161997",
        Climb = "rbxassetid://616156119",
        Swim = "rbxassetid://616165109",
        SwimIdle = "rbxassetid://616166655"
    }
}

-- Notification System
local NotificationSystem = {}

function NotificationSystem.new()
    local notification = Instance.new("ScreenGui")
    local container = Instance.new("Frame")
    local message = Instance.new("TextLabel")
    
    notification.Name = "Notification"
    notification.Parent = CoreGui
    
    container.Name = "Container"
    container.Parent = notification
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.BorderColor3 = Color3.fromRGB(60, 60, 60)
    container.Position = UDim2.new(1, 20, 0.8, 0)
    container.Size = UDim2.new(0, 200, 0, 50)
    
    message.Name = "Message"
    message.Parent = container
    message.BackgroundTransparency = 1
    message.Size = UDim2.new(1, 0, 1, 0)
    message.Font = Enum.Font.GothamSemibold
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.TextSize = 14
    
    return notification
end

function NotificationSystem:Notify(text, duration)
    duration = duration or 3
    local notification = self.new()
    local container = notification.Container
    local message = container.Message
    
    message.Text = text
    
    local slideIn = TweenService:Create(container, 
        TweenInfo.new(0.5, Enum.EasingStyle.Quart),
        {Position = UDim2.new(0.85, 0, 0.8, 0)}
    )
    
    local slideOut = TweenService:Create(container,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart),
        {Position = UDim2.new(1.1, 0, 0.8, 0)}
    )
    
    slideIn:Play()
    task.wait(duration)
    slideOut:Play()
    slideOut.Completed:Wait()
    notification:Destroy()
end

-- Loading Screen
local function createLoadingScreen()
    local loading = Instance.new("ScreenGui")
    local background = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local loadingBar = Instance.new("Frame")
    local loadingFill = Instance.new("Frame")
    local status = Instance.new("TextLabel")
    
    loading.Name = "LoadingScreen"
    loading.Parent = CoreGui
    
    background.Name = "Background"
    background.Parent = loading
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.Size = UDim2.new(1, 0, 1, 0)
    
    title.Name = "Title"
    title.Parent = background
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.5, -150, 0.4, -20)
    title.Size = UDim2.new(0, 300, 0, 40)
    title.Font = Enum.Font.GothamBold
    title.Text = "Adonis"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 32
    
    loadingBar.Name = "LoadingBar"
    loadingBar.Parent = background
    loadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    loadingBar.BorderSizePixel = 0
    loadingBar.Position = UDim2.new(0.5, -150, 0.5, -10)
    loadingBar.Size = UDim2.new(0, 300, 0, 20)
    
    loadingFill.Name = "LoadingFill"
    loadingFill.Parent = loadingBar
    loadingFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    loadingFill.BorderSizePixel = 0
    loadingFill.Size = UDim2.new(0, 0, 1, 0)
    
    status.Name = "Status"
    status.Parent = background
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0.5, -150, 0.5, 20)
    status.Size = UDim2.new(0, 300, 0, 20)
    status.Font = Enum.Font.GothamSemibold
    status.Text = "Initializing..."
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.TextSize = 16
    
    return loading
end

-- Main GUI Creation
local function createMainGui()
    local screenGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local title = Instance.new("TextButton")
    local container = Instance.new("Frame")
    local speedInput = Instance.new("TextBox")
    local teleportInput = Instance.new("TextBox")
    local animationsButton = Instance.new("TextButton")
    local animationsFrame = Instance.new("Frame")
    
    screenGui.Name = "AnimationsGui"
    screenGui.Parent = CoreGui
    
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    mainFrame.Position = UDim2.new(0, 15, 0, 15)
    mainFrame.Size = UDim2.new(0, 200, 0, 180)
    
    title.Name = "Title"
    title.Parent = mainFrame
    title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    title.BorderColor3 = Color3.fromRGB(60, 60, 60)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Font = Enum.Font.GothamBold
    title.Text = "Adonis"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    
    container.Name = "Container"
    container.Parent = mainFrame
    container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    container.BorderColor3 = Color3.fromRGB(60, 60, 60)
    container.Position = UDim2.new(0, 0, 0, 30)
    container.Size = UDim2.new(1, 0, 1, -30)
    
    speedInput.Name = "SpeedInput"
    speedInput.Parent = container
    speedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    speedInput.BorderColor3 = Color3.fromRGB(60, 60, 60)
    speedInput.Position = UDim2.new(0.1, 0, 0.1, 0)
    speedInput.Size = UDim2.new(0.8, 0, 0, 30)
    speedInput.Font = Enum.Font.GothamSemibold
    speedInput.PlaceholderText = "Speed (16 default)"
    speedInput.Text = ""
    speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedInput.TextSize = 14
    
    teleportInput.Name = "TeleportInput"
    teleportInput.Parent = container
    teleportInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    teleportInput.BorderColor3 = Color3.fromRGB(60, 60, 60)
    teleportInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    teleportInput.Size = UDim2.new(0.8, 0, 0, 30)
    teleportInput.Font = Enum.Font.GothamSemibold
    teleportInput.PlaceholderText = "Player name to teleport"
    teleportInput.Text = ""
    teleportInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportInput.TextSize = 14
    
    animationsButton.Name = "AnimationsButton"
    animationsButton.Parent = container
    animationsButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    animationsButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
    animationsButton.Position = UDim2.new(0.1, 0, 0.7, 0)
    animationsButton.Size = UDim2.new(0.8, 0, 0, 30)
    animationsButton.Font = Enum.Font.GothamSemibold
    animationsButton.Text = "Animations"
    animationsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    animationsButton.TextSize = 14
    
    animationsFrame.Name = "AnimationsFrame"
    animationsFrame.Parent = screenGui
    animationsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    animationsFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    animationsFrame.Position = UDim2.new(0, 230, 0, 15)
    animationsFrame.Size = UDim2.new(0, 180, 0, 200)
    animationsFrame.Visible = false
    
    return {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        Title = title,
        SpeedInput = speedInput,
        TeleportInput = teleportInput,
        AnimationsButton = animationsButton,
        AnimationsFrame = animationsFrame
    }
end

-- Animation Functions
local function setAnimations(anims)
    local char = Player.Character
    if not char then return end
    
    local animate = char:WaitForChild("Animate")
    animate.Enabled = false
    
    for _, track in pairs(char:WaitForChild("Humanoid"):WaitForChild("Animator"):GetPlayingAnimationTracks()) do
        track:Stop()
    end
    
    local function setAnim(name, id)
        local anim = animate:WaitForChild(name)
        if name == "idle" then
            anim:WaitForChild("Animation1").AnimationId = anims.Idle1
            anim:WaitForChild("Animation2").AnimationId = anims.Idle2
        else
            local animObj = anim:GetChildren()[1]
            if animObj then
                animObj.AnimationId = id
            end
        end
    end
    
    setAnim("idle", anims.Idle1)
    setAnim("walk", anims.Walk)
    setAnim("run", anims.Run)
    setAnim("jump", anims.Jump)
    setAnim("fall", anims.Fall)
    setAnim("climb", anims.Climb)
    setAnim("swim", anims.Swim)
    setAnim("swimidle", anims.SwimIdle)
    
    animate.Enabled = true
end

-- Player Finding Function
local function findPlayer(name)
    name = name:lower()
    local closest = nil
    local closestLen = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            local playerName = player.Name:lower()
            if playerName:find(name) then
                local len = #playerName - #name
                if len < closestLen then
                    closest = player
                    closestLen = len
                end
            end
        end
    end
    
    return closest
end

-- Initialize
local function init()
    local loading = createLoadingScreen()
    local loadingFill = loading.Background.LoadingBar.LoadingFill
    local status = loading.Background.Status
    
    -- Loading sequence
    local loadingSteps = {
        "Initializing...",
        "Loading animations...",
        "Setting up GUI...",
        "Configuring settings...",
        "Finishing up..."
    }
    
    for i, text in ipairs(loadingSteps) do
        TweenService:Create(loadingFill, TweenInfo.new(0.5), {
            Size = UDim2.new(i/5, 0, 1, 0)
        }):Play()
        status.Text = text
        task.wait(0.5)
    end
    
    task.wait(0.5)
    loading:Destroy()
    
    -- Create main GUI
    local gui = createMainGui()
    
    -- Create animation buttons
    local buttonPosition = 0
    for name, anims in pairs(Animations) do
        local button = Instance.new("TextButton")
        button.Name = name
        button.Parent = gui.AnimationsFrame
        button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        button.BorderColor3 = Color3.fromRGB(60, 60, 60)
        button.Position = UDim2.new(0.1, 0, 0.1 + (buttonPosition * 0.2), 0)
        button.Size = UDim2.new(0.8, 0, 0, 30)
        button.Font = Enum.Font.GothamSemibold
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        
        button.MouseButton1Click:Connect(function()
            setAnimations(anims)
            NotificationSystem:Notify(name .. " animations applied!", 2)
        end)
        
        buttonPosition = buttonPosition + 1
    end
    
    -- Speed input handling
    gui.SpeedInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local speed = tonumber(gui.SpeedInput.Text)
            if speed then
                SavedSpeed = speed
                if Player.Character then
                    Player.Character.Humanoid.WalkSpeed = speed
                end
                NotificationSystem:Notify("Speed set to " .. speed, 2)
            end
        end
    end)
    
    -- Teleport input handling
    gui.TeleportInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local targetPlayer = findPlayer(gui.TeleportInput.Text)
            if targetPlayer then
                Player.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
                NotificationSystem:Notify("Teleported to " .. targetPlayer.Name, 2)
            else
                NotificationSystem:Notify("Player not found!", 2)
            end
        end
    end)
    
    -- Animations button handling
    gui.AnimationsButton.MouseButton1Click:Connect(function()
        AnimationsVisible = not AnimationsVisible
        gui.AnimationsFrame.Visible = AnimationsVisible
        TweenService:Create(gui.AnimationsFrame, TweenInfo.new(0.3), {
            Position = AnimationsVisible and 
                UDim2.new(0, 230, 0, 15) or 
                UDim2.new(0, 430, 0, 15)
        }):Play()
    end)
    
    -- Mobile touch handling
    local function handleTouch(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if input.UserInputState == Enum.UserInputState.Begin then
                local guiObjects = gui.ScreenGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
                for _, obj in pairs(guiObjects) do
                    if obj:IsDescendantOf(gui.MainFrame) then
                        Dragging = true
                        DragStart = input.Position
                        StartPos = gui.MainFrame.Position
                        LastTouch = input
                        break
                    end
                end
            elseif input.UserInputState == Enum.UserInputState.End then
                if input == LastTouch then
                    Dragging = false
                    LastTouch = nil
                end
            elseif input.UserInputState == Enum.UserInputState.Change and Dragging and input == LastTouch then
                local delta = input.Position - DragStart
                gui.MainFrame.Position = UDim2.new(
                    StartPos.X.Scale,
                    StartPos.X.Offset + delta.X,
                    StartPos.Y.Scale,
                    StartPos.Y.Offset + delta.Y
                )
            end
        end
    end
    
    UserInputService.TouchStarted:Connect(handleTouch)
    UserInputService.TouchMoved:Connect(handleTouch)
    UserInputService.TouchEnded:Connect(handleTouch)
    
    -- Character respawn handling
    Player.CharacterAdded:Connect(function(char)
        if SavedSpeed then
            task.wait(0.5)
            char.Humanoid.WalkSpeed = SavedSpeed
        end
    end)
    
    NotificationSystem:Notify("Script loaded successfully!", 3)
end

init()