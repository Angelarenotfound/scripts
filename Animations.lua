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
local ActiveNotifications = {}

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
    local decoration = Instance.new("Frame")
    
    notification.Name = "Notification"
    notification.Parent = CoreGui
    
    container.Name = "Container"
    container.Parent = notification
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.BorderColor3 = Color3.fromRGB(255, 0, 0)
    container.Position = UDim2.new(0.5, -100, 1, 20)
    container.Size = UDim2.new(0, 200, 0, 50)
    container.AnchorPoint = Vector2.new(0.5, 1)
    
    -- Add rounded corners
    local cornerRadius = Instance.new("UICorner")
    cornerRadius.CornerRadius = UDim.new(0, 8)
    cornerRadius.Parent = container
    
    decoration.Name = "Decoration"
    decoration.Parent = container
    decoration.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    decoration.BorderSizePixel = 0
    decoration.Size = UDim2.new(1, 0, 0, 2)
    decoration.Position = UDim2.new(0, 0, 0, 0)
    
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
    
    -- Adjust position based on active notifications
    local offset = #ActiveNotifications * 60
    container.Position = UDim2.new(0.5, -100, 1, 20 + offset)
    
    table.insert(ActiveNotifications, notification)
    
    -- Slide in
    local slideIn = TweenService:Create(container, 
        TweenInfo.new(0.5, Enum.EasingStyle.Quart),
        {Position = UDim2.new(0.5, -100, 1, -60 - offset)}
    )
    
    -- Slide out
    local slideOut = TweenService:Create(container,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart),
        {Position = UDim2.new(0.5, -100, 1, 20)}
    )
    
    slideIn:Play()
    task.wait(duration)
    slideOut:Play()
    
    -- Remove from active notifications
    for i, notif in ipairs(ActiveNotifications) do
        if notif == notification then
            table.remove(ActiveNotifications, i)
            break
        end
    end
    
    -- Adjust positions of remaining notifications
    for i, notif in ipairs(ActiveNotifications) do
        TweenService:Create(notif.Container,
            TweenInfo.new(0.5, Enum.EasingStyle.Quart),
            {Position = UDim2.new(0.5, -100, 1, -60 - ((i-1) * 60))}
        ):Play()
    end
    
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
    local decoration1 = Instance.new("Frame")
    local decoration2 = Instance.new("Frame")
    local decoration3 = Instance.new("Frame")
    local decoration4 = Instance.new("Frame")
    
    loading.Name = "LoadingScreen"
    loading.Parent = CoreGui
    
    background.Name = "Background"
    background.Parent = loading
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.Size = UDim2.new(1, 0, 1, 0)
    
    -- Add rounded corners to decorative elements
    local function addRoundCorners(element)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = element
    end
    
    -- Decorative elements
    decoration1.Name = "Decoration1"
    decoration1.Parent = background
    decoration1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    decoration1.BorderSizePixel = 0
    decoration1.Size = UDim2.new(0, 3, 0, 100)
    decoration1.Position = UDim2.new(0.2, 0, 0.3, 0)
    addRoundCorners(decoration1)
    
    decoration2.Name = "Decoration2"
    decoration2.Parent = background
    decoration2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    decoration2.BorderSizePixel = 0
    decoration2.Size = UDim2.new(0, 3, 0, 100)
    decoration2.Position = UDim2.new(0.8, 0, 0.3, 0)
    addRoundCorners(decoration2)
    
    decoration3.Name = "Decoration3"
    decoration3.Parent = background
    decoration3.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    decoration3.BorderSizePixel = 0
    decoration3.Size = UDim2.new(0, 100, 0, 3)
    decoration3.Position = UDim2.new(0.5, -50, 0.2, 0)
    addRoundCorners(decoration3)
    
    decoration4.Name = "Decoration4"
    decoration4.Parent = background
    decoration4.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    decoration4.BorderSizePixel = 0
    decoration4.Size = UDim2.new(0, 100, 0, 3)
    decoration4.Position = UDim2.new(0.5, -50, 0.8, 0)
    addRoundCorners(decoration4)
    
    title.Name = "Title"
    title.Parent = background
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.5, -150, 0.4, -20)
    title.Size = UDim2.new(0, 300, 0, 40)
    title.Font = Enum.Font.GothamBold
    title.RichText = true
    title.Text = '<font color="rgb(255,255,255)">Adonis</font> <font color="rgb(255,0,0)">Except</font>'
    title.TextSize = 32
    
    loadingBar.Name = "LoadingBar"
    loadingBar.Parent = background
    loadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    loadingBar.BorderSizePixel = 0
    loadingBar.Position = UDim2.new(0.5, -150, 0.5, -10)
    loadingBar.Size = UDim2.new(0, 300, 0, 20)
    addRoundCorners(loadingBar)
    
    loadingFill.Name = "LoadingFill"
    loadingFill.Parent = loadingBar
    loadingFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    loadingFill.BorderSizePixel = 0
    loadingFill.Size = UDim2.new(0, 0, 1, 0)
    addRoundCorners(loadingFill)
    
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
    local dragArea = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local container = Instance.new("Frame")
    local speedInput = Instance.new("TextBox")
    local teleportInput = Instance.new("TextBox")
    local animationsButton = Instance.new("TextButton")
    local animationsFrame = Instance.new("Frame")
    local toggleButton = Instance.new("TextButton")
    local decoration1 = Instance.new("Frame")
    local decoration2 = Instance.new("Frame")
    local decoration3 = Instance.new("Frame")
    local decoration4 = Instance.new("Frame")
    
    -- Add rounded corners function
    local function addRoundCorners(element, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or 8)
        corner.Parent = element
    end
    
    screenGui.Name = "AnimationsGui"
    screenGui.Parent = CoreGui
    
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    mainFrame.Position = UDim2.new(0, 15, 0, 15)
    mainFrame.Size = UDim2.new(0, 250, 0, 300)
    addRoundCorners(mainFrame, 10)
    
    -- Drag Area
    dragArea.Name = "DragArea"
    dragArea.Parent = mainFrame
    dragArea.BackgroundTransparency = 1
    dragArea.Size = UDim2.new(1, 0, 0, 40)
    
    -- Decorative elements
    decoration1.Name = "Decoration1"
    decoration1.Parent = mainFrame
    decoration1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    decoration1.BorderSizePixel = 0
    decoration1.Size = UDim2.new(0, 3, 0, 50)
    decoration1.Position = UDim2.new(0.15, 0, 0, 0)
    addRoundCorners(decoration1)
    
    decoration2.Name = "Decoration2"
    decoration2.Parent = mainFrame
    decoration2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    decoration2.BorderSizePixel = 0
    decoration2.Size = UDim2.new(0, 3, 0, 50)
    decoration2.Position = UDim2.new(0.85, 0, 0, 0)
    addRoundCorners(decoration2)
    
    decoration3.Name = "Decoration3"
    decoration3.Parent = mainFrame
    decoration3.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    decoration3.BorderSizePixel = 0
    decoration3.Size = UDim2.new(0.3, 0, 0, 3)
    decoration3.Position = UDim2.new(0.35, 0, 0.2, 0)
    addRoundCorners(decoration3)
    
    decoration4.Name = "Decoration4"
    decoration4.Parent = mainFrame
    decoration4.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    decoration4.BorderSizePixel = 0
    decoration4.Size = UDim2.new(0.3, 0, 0, 3)
    decoration4.Position = UDim2.new(0.35, 0, 0.8, 0)
    addRoundCorners(decoration4)
    
    title.Name = "Title"
    title.Parent = mainFrame
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Font = Enum.Font.GothamBold
    title.RichText = true
    title.Text = '<font color="rgb(255,255,255)">Adonis</font> <font color="rgb(255,0,0)">Except</font>'
    title.TextSize = 20
    
    container.Name = "Container"
    container.Parent = mainFrame
    container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    container.BorderSizePixel = 0
    container.Position = UDim2.new(0, 0, 0, 40)
    container.Size = UDim2.new(1, 0, 1, -40)
    
    speedInput.Name = "SpeedInput"
    speedInput.Parent = container
    speedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    speedInput.BorderColor3 = Color3.fromRGB(60, 60, 60)
    speedInput.Position = UDim2.new(0.1, 0, 0.1, 0)
    speedInput.Size = UDim2.new(0.8, 0, 0, 40)
    speedInput.Font = Enum.Font.GothamSemibold
    speedInput.PlaceholderText = "Speed (16 default)"
    speedInput.Text = ""
    speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedInput.TextSize = 14
    addRoundCorners(speedInput)
    
    teleportInput.Name = "TeleportInput"
    teleportInput.Parent = container
    teleportInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    teleportInput.BorderColor3 = Color3.fromRGB(60, 60, 60)
    teleportInput.Position = UDim2.new(0.1, 0, 0.35, 0)
    teleportInput.Size = UDim2.new(0.8, 0, 0, 40)
    teleportInput.Font = Enum.Font.GothamSemibold
    teleportInput.PlaceholderText = "Player name to teleport"
    teleportInput.Text = ""
    teleportInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportInput.TextSize = 14
    addRoundCorners(teleportInput)
    
    animationsButton.Name = "AnimationsButton"
    animationsButton.Parent = container
    animationsButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    animationsButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
    animationsButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    animationsButton.Size = UDim2.new(0.8, 0, 0, 40)
    animationsButton.Font = Enum.Font.GothamSemibold
    animationsButton.Text = "Animations"
    animationsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    animationsButton.TextSize = 14
    addRoundCorners(animationsButton)
    
    animationsFrame.Name = "AnimationsFrame"
    animationsFrame.Parent = screenGui
    animationsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    animationsFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    animationsFrame.Position = UDim2.new(0, 280, 0, 15)
    animationsFrame.Size = UDim2.new(0, 220, 0, 300)
    animationsFrame.Visible = false
    addRoundCorners(animationsFrame, 10)
    
    -- Add decorations to animations frame
    local animDec1 = decoration1:Clone()
    local animDec2 = decoration2:Clone()
    local animDec3 = decoration3:Clone()
    local animDec4 = decoration4:Clone()
    
    animDec1.Parent = animationsFrame
    animDec2.Parent = animationsFrame
    animDec3.Parent = animationsFrame
    animDec4.Parent = animationsFrame
    
    toggleButton.Name = "ToggleButton"
    toggleButton.Parent = screenGui
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    toggleButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.Position = UDim2.new(0, 15, 0.5, -20)
    toggleButton.Size = UDim2.new(0, 40, 0, 40)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Text = "≡"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 24
    addRoundCorners(toggleButton)
    
    return {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        DragArea = dragArea,
        SpeedInput = speedInput,
        TeleportInput = teleportInput,
        AnimationsButton = animationsButton,
        AnimationsFrame = animationsFrame,
        ToggleButton = toggleButton
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
    local decorations = {
        loading.Background.Decoration1,
        loading.Background.Decoration2,
        loading.Background.Decoration3,
        loading.Background.Decoration4
    }
    
    -- Enhanced loading sequence with animations
    local loadingSteps = {
        "Initializing system...",
        "Loading animations...",
        "Configuring interface...",
        "Setting up controls...",
        "Preparing components...",
        "Loading resources...",
        "Optimizing performance...",
        "Finalizing setup...",
        "Almost ready...",
        "Launching interface..."
    }
    
    -- Animate decorative elements during loading
    spawn(function()
        while loading.Parent do
            for _, dec in ipairs(decorations) do
                if dec.Name:find("1") or dec.Name:find("2") then
                    TweenService:Create(dec, TweenInfo.new(1), {
                        Position = dec.Position + UDim2.new(0, 0, 0, 10)
                    }):Play()
                else
                    TweenService:Create(dec, TweenInfo.new(1), {
                        Position = dec.Position + UDim2.new(0.1, 0, 0, 0)
                    }):Play()
                end
            end
            wait(1)
            for _, dec in ipairs(decorations) do
                if dec.Name:find("1") or dec.Name:find("2") then
                    TweenService:Create(dec, TweenInfo.new(1), {
                        Position = dec.Position - UDim2.new(0, 0, 0, 10)
                    }):Play()
                else
                    TweenService:Create(dec, TweenInfo.new(1), {
                        Position = dec.Position - UDim2.new(0.1, 0, 0, 0)
                    }):Play()
                end
            end
            wait(1)
        end
    end)
    
    for i, text in ipairs(loadingSteps) do
        TweenService:Create(loadingFill, TweenInfo.new(1), {
            Size = UDim2.new(i/10, 0, 1, 0)
        }):Play()
        status.Text = text
        wait(1)
    end
    
    wait(1)
    loading:Destroy()
    
    -- Create main GUI
    local gui = createMainGui()
    
    -- Create animation buttons
    local buttonSpacing = 0.15
    local buttonPosition = 0.1
    for name, anims in pairs(Animations) do
        local button = Instance.new("TextButton")
        button.Name = name
        button.Parent = gui.AnimationsFrame
        button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        button.BorderColor3 = Color3.fromRGB(60, 60, 60)
        button.Position = UDim2.new(0.1, 0, buttonPosition, 0)
        button.Size = UDim2.new(0.8, 0, 0, 40)
        button.Font = Enum.Font.GothamSemibold
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        
        -- Add rounded corners
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button
        
        -- Button hover effect
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            }):Play()
        end)
        
        button.MouseButton1Click:Connect(function()
            setAnimations(anims)
            NotificationSystem:Notify(name .. " animations applied!", 2)
        end)
        
        buttonPosition = buttonPosition + buttonSpacing
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
                UDim2.new(0, 280, 0, 15) or 
                UDim2.new(0, 500, 0, 15)
        }):Play()
    end)
    
    -- GUI Toggle handling
    local guiVisible = true
    gui.ToggleButton.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        gui.MainFrame.Visible = guiVisible
        gui.AnimationsFrame.Visible = guiVisible and AnimationsVisible
        
        TweenService:Create(gui.ToggleButton, TweenInfo.new(0.3), {
            Rotation = guiVisible and 0 or 180
        }):Play()
    end)
    
    -- Enhanced mobile dragging
    local function handleDragging(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local position = input.Position
            local guiObjects = gui.ScreenGui:GetGuiObjectsAtPosition(position.X, position.Y)
            
            for _, obj in pairs(guiObjects) do
                if obj == gui.DragArea then
                    Dragging = true
                    DragStart = position
                    StartPos = gui.MainFrame.Position
                    LastTouch = input
                    break
                end
            end
        end
    end
    
    UserInputService.InputBegan:Connect(handleDragging)
    
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input == LastTouch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta =input.Position - DragStart
            gui.MainFrame.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input == LastTouch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
            LastTouch = nil
        end
    end)
    
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