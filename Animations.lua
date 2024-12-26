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
local CurrentSection = "Home"
local ESP = {
    Enabled = false,
    Connections = {}
}

local Animations = {
    astronaut = {
        Idle1 = "rbxassetid://891621366",
        Idle2 = "rbxassetid://891633237",
        Walk = "rbxassetid://891636393",
        Run = "rbxassetid://891636393",
        Fall = "rbxassetid://891617961",
        Jump = "rbxassetid://891627522",
        Climb = "rbxassetid://891609353",
        Swim = "rbxassetid://891639666",
        SwimIdle = "rbxassetid://891663592"
    },
    bold = {
        Idle1 = "rbxassetid://16738333868",
        Idle2 = "rbxassetid://16738334710",
        Walk = "rbxassetid://16738340646", 
        Run = "rbxassetid://16738337225",
        Fall = "rbxassetid://16738333171",
        Jump = "rbxassetid://16738336650",
        Climb = "rbxassetid://16738332169",
        Swim = "rbxassetid://16738339158",
        SwimIdle = "rbxassetid://16738339817"
    },
    bubbly = {
        Idle1 = "rbxassetid://910004836",
        Idle2 = "rbxassetid://910009958",
        Walk = "rbxassetid://910034870",
        Run = "rbxassetid://910025107",
        Fall = "rbxassetid://910001910",
        Jump = "rbxassetid://910016857",
        Climb = "rbxassetid://909997997",
        Swim = "rbxassetid://910028158",
        SwimIdle = "rbxassetid://910030921"
    },
    cartoony = {
        Idle1 = "rbxassetid://742637544",
        Idle2 = "rbxassetid://742638445",
        Walk = "rbxassetid://742640026",
        Run = "rbxassetid://742638842",
        Fall = "rbxassetid://742637151",
        Jump = "rbxassetid://742637942",
        Climb = "rbxassetid://742636889",
        Swim = "rbxassetid://742639220",
        SwimIdle = "rbxassetid://742639812"
    },
    elder = {
        Idle1 = "rbxassetid://845397899",
        Idle2 = "rbxassetid://8454005",
        Walk = "rbxassetid://845403856",
        Run = "rbxassetid://845386501",
        Fall = "rbxassetid://616005863",
        Jump = "rbxassetid://845398858",
        Climb = "rbxassetid://656114359",
        Swim = "rbxassetid://845401742",
        SwimIdle = "rbxassetid://845403127"
    },
    knight = {
        Idle1 = "rbxassetid://657595757",
        Idle2 = "rbxassetid://657568135",
        Walk = "rbxassetid://657552124",
        Run = "rbxassetid://657564596",
        Fall = "rbxassetid://657600338",
        Jump = "rbxassetid://658409194",
        Climb = "rbxassetid://658360781",
        Swim = "rbxassetid://657560551",
        SwimIdle = "rbxassetid://657557095"
    },
    levitation = {
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
    mage = {
        Idle1 = "rbxassetid://707742142",
        Idle2 = "rbxassetid://707855907",
        Walk = "rbxassetid://707897309",
        Run = "rbxassetid://707861613",
        Fall = "rbxassetid://707829716",
        Jump = "rbxassetid://707853694",
        Climb = "rbxassetid://707826056",
        Swim = "rbxassetid://707876443",
        SwimIdle = "rbxassetid://707894699"
    },
    ninja = {
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
    oldschool = {
        Idle1 = "rbxassetid://5319828216",
        Idle2 = "rbxassetid://5319831086",
        Walk = "rbxassetid://5319847204",
        Run = "rbxassetid://5319844329",
        Fall = "rbxassetid://5319839762",
        Jump = "rbxassetid://5319841935",
        Climb = "rbxassetid://5319816685",
        Swim = "rbxassetid://5319850266",
        SwimIdle = "rbxassetid://5319852613"
    },
    pirate = {
        Idle1 = "rbxassetid://750781874",
        Idle2 = "rbxassetid://750782770",
        Walk = "rbxassetid://750785693",
        Run = "rbxassetid://750783738",
        Fall = "rbxassetid://750780242",
        Jump = "rbxassetid://750782230",
        Climb = "rbxassetid://750779899",
        Swim = "rbxassetid://750784579",
        SwimIdle = "rbxassetid://750785176"
    },
    rthro = {
        Idle1 = "rbxassetid://2510196951",
        Idle2 = "rbxassetid://2510197257",
        Walk = "rbxassetid://2510202577",
        Run = "rbxassetid://2510198475",
        Fall = "rbxassetid://656115606",
        Jump = "rbxassetid://656117878",
        Climb = "rbxassetid://2510192778",
        Swim = "rbxassetid://2510199791",
        SwimIdle = "rbxassetid://2510201162"
    },
    stylish = {
        Idle1 = "rbxassetid://616136790",
        Idle2 = "rbxassetid://616138447",
        Walk = "rbxassetid://616146177",
        Run = "rbxassetid://616140816",
        Fall = "rbxassetid://616134815",
        Jump = "rbxassetid://616139451",
        Climb = "rbxassetid://616133594",
        Swim = "rbxassetid://616143378",
        SwimIdle = "rbxassetid://616144772"
    },
    superhero = {
        Idle1 = "rbxassetid://616111295",
        Idle2 = "rbxassetid://616113536",
        Walk = "rbxassetid://616122287",
        Run = "rbxassetid://616117076",
        Fall = "rbxassetid://616108001",
        Jump = "rbxassetid://616115533",
        Climb = "rbxassetid://616104706",
        Swim = "rbxassetid://616119360",
        SwimIdle = "rbxassetid://616120861"
    },
    toy = {
        Idle1 = "rbxassetid://782841498",
        Idle2 = "rbxassetid://782845736",
        Walk = "rbxassetid://782843345",
        Run = "rbxassetid://782842708",
        Fall = "rbxassetid://782846423",
        Jump = "rbxassetid://782847020",
        Climb = "rbxassetid://782843869",
        Swim = "rbxassetid://782844582",
        SwimIdle = "rbxassetid://782845186"
    },
    vampire = {
        Idle1 = "rbxassetid://1083445855",
        Idle2 = "rbxassetid://1083450166",
        Walk = "rbxassetid://1083473930",
        Run = "rbxassetid://1083462077",
        Fall = "rbxassetid://1083443587",
        Jump = "rbxassetid://1083455352",
        Climb = "rbxassetid://1083439238",
        Swim = "rbxassetid://1083464683",
        SwimIdle = "rbxassetid://1083467779"
    },
    werewolf = {
        Idle1 = "rbxassetid://1083195517",
        Idle2 = "rbxassetid://1083214717",
        Walk = "rbxassetid://1083178339",
        Run = "rbxassetid://1083216690",
        Fall = "rbxassetid://1083189019",
        Jump = "rbxassetid://1083218792",
        Climb = "rbxassetid://1083182000",
        Swim = "rbxassetid://1083222527",
        SwimIdle = "rbxassetid://1083222527"
    },
    zombie = {
        Idle1 = "rbxassetid://616158929",
        Idle2 = "rbxassetid://616160636",
        Walk = "rbxassetid://616168032",
        Run = "rbxassetid://616163682",
        Fall = "rbxassetid://616157476",
        Jump = "rbxassetid://616161997",
        Climb = "rbxassetid://18537363391",
        Swim = "rbxassetid://616165109",
        SwimIdle = "rbxassetid://616166655"
    },
    adidas = {
        Idle1 = "rbxassetid://18537376492",
        Idle2 = "rbxassetid://18537371272",
        Walk = "rbxassetid://18537392113",
        Run = "rbxassetid://18537384940",
        Fall = "rbxassetid://18537367238",
        Jump = "rbxassetid://18537380791",
        Climb = "rbxassetid://18537363391",
        Swim = "rbxassetid://18537389531",
        SwimIdle = "rbxassetid://18537387180"
    },
    faker6 = {
        Idle1 = "rbxassetid://12521158637",
        Idle2 = "rbxassetid://12521162526",
        Walk = "rbxassetid://126997486407971",
        Run = "rbxassetid://126997486407971",
        Fall = "rbxassetid://12520972571",
        Jump = "rbxassetid://12520880485",
        Climb = "rbxassetid://12520982150",
        Swim = "rbxassetid://12520993168",
        SwimIdle = "rbxassetid://2510201162"
    },
    girlcombo1 = {
        Idle1 = "rbxassetid://16738333868",
        Idle2 = "rbxassetid://16738334710",
        Walk = "rbxassetid://910034870",
        Run = "rbxassetid://910025107",
        Fall = "rbxassetid://5319839762",
        Jump = "rbxassetid://5319841935",
        Climb = "rbxassetid://5319816685",
        Swim = "rbxassetid://2510199791",
        SwimIdle = "rbxassetid://5319852613"
    },
    girlcombo2 = {
        Idle1 = "rbxassetid://616136790",
        Idle2 = "rbxassetid://616138447",
        Walk = "rbxassetid://910034870",
        Run = "rbxassetid://910025107",
        Fall = "rbxassetid://5319839762",
        Jump = "rbxassetid://5319841935",
        Climb = "rbxassetid://5319816685",
        Swim = "rbxassetid://5319850266",
        SwimIdle = "rbxassetid://5319852613"
    },
    tryhardcombo1 = {
        Idle1 = "rbxassetid://5319828216",
        Idle2 = "rbxassetid://5319831086",
        Walk = "rbxassetid://707897309",
        Run = "rbxassetid://707861613",
        Fall = "rbxassetid://5319839762",
        Jump = "rbxassetid://5319841935",
        Climb = "rbxassetid://5319816685",
        Swim = "rbxassetid://5319850266",
        SwimIdle = "rbxassetid://5319852613"
    },
    tryhardcombo2 = {
        Idle1 = "rbxassetid://782841498",
        Idle2 = "rbxassetid://782845736",
        Walk = "rbxassetid://782843345",
        Run = "rbxassetid://782842708",
        Fall = "rbxassetid://616005863",
        Jump = "rbxassetid://782847020",
        Climb = "rbxassetid://707826056",
        Swim = "rbxassetid://707876443",
        SwimIdle = "rbxassetid://707894699"
    }
}

local orderedAnimations = {
    "Ninja", "Zombie", "Elder", "Levitation",
    "Astronaut", "Bold", "Bubbly", "Cartoony",
    "Knight", "Mage", "Oldschool", "Pirate",
    "Rthro", "Stylish", "Superhero", "Toy",
    "Vampire", "Werewolf", "Adidas", "Faker6",
    "GirlCombo1", "GirlCombo2", "TryhardCombo1", "TryhardCombo2"
}

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
    NotificationSystem:Notify("Animation applied successfully!", 2)
end

local NotificationSystem = {}
local ActiveNotifications = {}


local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ContentFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
ContentFrame.BorderSizePixel = 1
ContentFrame.Position = UDim2.new(0, 152, 0, 40)
ContentFrame.Size = UDim2.new(1, -152, 1, -40)

function NotificationSystem.new()
    local notification = Instance.new("ScreenGui")
    local container = Instance.new("Frame")
    local message = Instance.new("TextLabel")
    
    notification.Name = "Notification"
    notification.Parent = CoreGui
    
    container.Name = "Container"
    container.Parent = notification
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.BorderColor3 = Color3.fromRGB(255, 0, 0)
    container.Position = UDim2.new(0.5, -100, 1, 20)
    container.Size = UDim2.new(0, 200, 0, 50)
    container.AnchorPoint = Vector2.new(0.5, 1)
    
    local cornerRadius = Instance.new("UICorner")
    cornerRadius.CornerRadius = UDim.new(0, 8)
    cornerRadius.Parent = container
    
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
    
    local offset = #ActiveNotifications * 60
    container.Position = UDim2.new(0.5, -100, 1, 20 + offset)
    
    table.insert(ActiveNotifications, notification)
    
    local slideIn = TweenService:Create(container, 
        TweenInfo.new(0.5, Enum.EasingStyle.Quart),
        {Position = UDim2.new(0.5, -100, 1, -60 - offset)}
    )
    
    local slideOut = TweenService:Create(container,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart),
        {Position = UDim2.new(0.5, -100, 1, 20)}
    )
    
    slideIn:Play()
    task.wait(duration)
    slideOut:Play()
    
    for i, notif in ipairs(ActiveNotifications) do
        if notif == notification then
            table.remove(ActiveNotifications, i)
            break
        end
    end
    
    for i, notif in ipairs(ActiveNotifications) do
        TweenService:Create(notif.Container,
            TweenInfo.new(0.5, Enum.EasingStyle.Quart),
            {Position = UDim2.new(0.5, -100, 1, -60 - ((i-1) * 60))}
        ):Play()
    end
    
    slideOut.Completed:Wait()
    notification:Destroy()
end

-- Loading Screen (Updated)
local Loading = Instance.new("ScreenGui")
Loading.Name = "LoadingScreen"
Loading.Parent = CoreGui
Loading.DisplayOrder = 999
Loading.IgnoreGuiInset = true

local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Parent = Loading
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BorderSizePixel = 0
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Position = UDim2.new(0, 0, 0, 0)

-- Decoración superior
local TopDecoration = Instance.new("Frame")
TopDecoration.Name = "TopDecoration"
TopDecoration.Parent = Background
TopDecoration.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TopDecoration.BorderSizePixel = 0
TopDecoration.Position = UDim2.new(0, 0, 0, 0)
TopDecoration.Size = UDim2.new(1, 0, 0, 2)

-- Título actualizado con "Except" en rojo
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Background
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.5, -150, 0.4, -30) -- Adjusted X position
Title.Size = UDim2.new(0, 150, 0, 60) -- Adjusted width
Title.Font = Enum.Font.GothamBold
Title.Text = "Adonis"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 48

local ExceptText = Instance.new("TextLabel")
ExceptText.Name = "ExceptText"
ExceptText.Parent = Background
ExceptText.BackgroundTransparency = 1
ExceptText.Position = UDim2.new(0.5, 0, 0.4, -30)
ExceptText.Size = UDim2.new(0, 150, 0, 60)
ExceptText.Font = Enum.Font.GothamBold
ExceptText.Text = "Except"
ExceptText.TextColor3 = Color3.fromRGB(255, 0, 0)
ExceptText.TextSize = 48

local LoadingBar = Instance.new("Frame")
LoadingBar.Name = "LoadingBar"
LoadingBar.Parent = Background
LoadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LoadingBar.BorderSizePixel = 0
LoadingBar.Position = UDim2.new(0.5, -200, 0.5, -10)
LoadingBar.Size = UDim2.new(0, 400, 0, 20)

local LoadingFill = Instance.new("Frame")
LoadingFill.Name = "LoadingFill"
LoadingFill.Parent = LoadingBar
LoadingFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LoadingFill.BorderSizePixel = 0
LoadingFill.Size = UDim2.new(0, 0, 1, 0)

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Parent = Background
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0.5, -200, 0.5, 20)
Status.Size = UDim2.new(0, 400, 0, 30)
Status.Font = Enum.Font.GothamSemibold
Status.Text = "Initializing..."
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.TextSize = 18

-- Main GUI (Updated size)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdonisExceptGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdonisExceptGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 1
-- Create ContentFrame before other frames
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 152, 0, 40)
ContentFrame.Size = UDim2.new(1, -152, 1, -40)

-- Remove duplicate frame declarations and keep only one set of frames
local HomeFrame = Instance.new("Frame")
HomeFrame.Name = "HomeFrame"
HomeFrame.Parent = ContentFrame
HomeFrame.BackgroundTransparency = 1
HomeFrame.Size = UDim2.new(1, 0, 1, 0)
HomeFrame.Visible = true

local AnimationsFrame = Instance.new("ScrollingFrame")
AnimationsFrame.Name = "AnimationsFrame"
AnimationsFrame.Parent = ContentFrame
AnimationsFrame.BackgroundTransparency = 1
AnimationsFrame.Size = UDim2.new(1, 0, 1, 0)
AnimationsFrame.CanvasSize = UDim2.new(0, 0, 0, (#orderedAnimations * 50) + 40)
AnimationsFrame.ScrollBarThickness = 6
AnimationsFrame.Visible = false

local LocalScrollFrame = Instance.new("ScrollingFrame")
LocalScrollFrame.Name = "LocalScrollFrame"
LocalScrollFrame.Parent = ContentFrame
LocalScrollFrame.BackgroundTransparency = 1
LocalScrollFrame.Size = UDim2.new(1, 0, 1, 0)
LocalScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
LocalScrollFrame.ScrollBarThickness = 6
LocalScrollFrame.Visible = false

local LocalFrame = LocalScrollFrame

local CreditsFrame = Instance.new("Frame")
CreditsFrame.Name = "CreditsFrame"
CreditsFrame.Parent = ContentFrame
CreditsFrame.BackgroundTransparency = 1
CreditsFrame.Size = UDim2.new(1, 0, 1, 0)
CreditsFrame.Visible = false
-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Top bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TopBar.BorderColor3 = Color3.fromRGB(255, 255, 255)
TopBar.BorderSizePixel = 1
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.Active = true

local TopBarCorner = UICorner:Clone()
TopBarCorner.Parent = TopBar

-- Title in top bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "Title"
TitleBar.Parent = TopBar
TitleBar.BackgroundTransparency = 1
TitleBar.Position = UDim2.new(0, 25, 0, 8)
TitleBar.Size = UDim2.new(1, -30, 1, 0)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "Adonis Except"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextSize = 20
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

-- Sections container
local SectionsFrame = Instance.new("Frame")
SectionsFrame.Name = "Sections"
SectionsFrame.Parent = MainFrame
SectionsFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SectionsFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
SectionsFrame.BorderSizePixel = 1
SectionsFrame.Position = UDim2.new(0, 0, 0, 40)
SectionsFrame.Size = UDim2.new(0, 150, 1, -40)

local SectionsCorner = UICorner:Clone()
SectionsCorner.Parent = SectionsFrame

-- Function to update content (Fixed)
function updateContent(section)
    if not HomeFrame or not AnimationsFrame or not LocalFrame or not CreditsFrame then return end
    
    HomeFrame.Visible = false
    AnimationsFrame.Visible = false
    LocalFrame.Visible = false
    CreditsFrame.Visible = false
    
    if section == "Home" then
        HomeFrame.Visible = true
    elseif section == "Animations" then
        AnimationsFrame.Visible = true
    elseif section == "Local" then
        LocalFrame.Visible = true
    elseif section == "Credits" then
        CreditsFrame.Visible = true
    end
end

-- Create section buttons with fixed functionality
local function createSectionButton(name, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = SectionsFrame
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, 10, 0, position)
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Font = Enum.Font.GothamSemibold
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    local buttonCorner = UICorner:Clone()
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        CurrentSection = name
        updateContent(name)
    end)
    
    return button
end

-- Create sections
local sections = {
    {name = "Home", pos = 10},
    {name = "Animations", pos = 60},
    {name = "Local", pos = 110},
    {name = "Credits", pos = 160}
}

for _, section in ipairs(sections) do
    createSectionButton(section.name, section.pos)
end

-- Setup Home content
local UserImage = Instance.new("ImageLabel")
UserImage.Name = "UserImage"
UserImage.Parent = HomeFrame
UserImage.BackgroundTransparency = 1
UserImage.Position = UDim2.new(0, 20, 0, 20)
UserImage.Size = UDim2.new(0, 100, 0, 100)
UserImage.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local UserImageCorner = UICorner:Clone()
UserImageCorner.CornerRadius = UDim.new(1, 0)
UserImageCorner.Parent = UserImage

local UserName = Instance.new("TextLabel")
UserName.Name = "UserName"
UserName.Parent = HomeFrame
UserName.BackgroundTransparency = 1
UserName.Position = UDim2.new(0, 140, 0, 20)
UserName.Size = UDim2.new(0, 200, 0, 30)
UserName.Font = Enum.Font.GothamBold
UserName.Text = Player.Name
UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
UserName.TextSize = 24
UserName.TextXAlignment = Enum.TextXAlignment.Left

local UserDisplayName = Instance.new("TextLabel")
UserDisplayName.Name = "UserDisplayName"
UserDisplayName.Parent = HomeFrame
UserDisplayName.BackgroundTransparency = 1
UserDisplayName.Position = UDim2.new(0, 140, 0, 50)
UserDisplayName.Size = UDim2.new(0, 200, 0, 20)
UserDisplayName.Font = Enum.Font.GothamSemibold
UserDisplayName.Text = "@" .. Player.DisplayName
UserDisplayName.TextColor3 = Color3.fromRGB(200, 200, 200)
UserDisplayName.TextSize = 16
UserDisplayName.TextXAlignment = Enum.TextXAlignment.Left

-- Setup Credits content
local CreditsTitle = Instance.new("TextLabel")
CreditsTitle.Name = "CreditsTitle"
CreditsTitle.Parent = CreditsFrame
CreditsTitle.BackgroundTransparency = 1
CreditsTitle.Position = UDim2.new(0, 20, 0, 20)
CreditsTitle.Size = UDim2.new(1, -40, 0, 40)
CreditsTitle.Font = Enum.Font.GothamBold
CreditsTitle.Text = "Credits"
CreditsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditsTitle.TextSize = 24
CreditsTitle.TextXAlignment = Enum.TextXAlignment.Left

local CreditsText = Instance.new("TextLabel")
CreditsText.Name = "CreditsText"
CreditsText.Parent = CreditsFrame
CreditsText.BackgroundTransparency = 1
CreditsText.Position = UDim2.new(0, 20, 0, 70)
CreditsText.Size = UDim2.new(1, -40, 0, 60)
CreditsText.Font = Enum.Font.GothamSemibold
CreditsText.Text = "Created by:\nAngelarenotfound\n100% Adonis Except"
CreditsText.TextColor3 = Color3.fromRGB(200, 200, 200)
CreditsText.TextSize = 16
CreditsText.TextXAlignment = Enum.TextXAlignment.Left

-- Setup Local content
local SpeedInput = Instance.new("TextBox")
SpeedInput.Name = "SpeedInput"
SpeedInput.Parent = LocalFrame
SpeedInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedInput.Position = UDim2.new(0, 20, 0, 20)
SpeedInput.Size = UDim2.new(0, 200, 0, 40)
SpeedInput.Font = Enum.Font.GothamSemibold
SpeedInput.PlaceholderText = "Speed (Default: 16)"
SpeedInput.Text = ""
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.TextSize = 14

local SpeedInputCorner = UICorner:Clone()
SpeedInputCorner.Parent = SpeedInput

local TeleportInput = Instance.new("TextBox")
TeleportInput.Name = "TeleportInput"
TeleportInput.Parent = LocalFrame
TeleportInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TeleportInput.Position = UDim2.new(0, 20, 0, 80)
TeleportInput.Size = UDim2.new(0, 200, 0, 40)
TeleportInput.Font = Enum.Font.GothamSemibold
TeleportInput.PlaceholderText = "Player name to teleport"
TeleportInput.Text = ""
TeleportInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportInput.TextSize = 14

local TeleportInputCorner = UICorner:Clone()
TeleportInputCorner.Parent = TeleportInput

local function createLocalButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = LocalFrame
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.Position = UDim2.new(0, 20, 0, position)
    button.Size = UDim2.new(0, 200, 0, 40)
    button.Font = Enum.Font.GothamSemibold
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    local buttonCorner = UICorner:Clone()
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- rejoin button
createLocalButton("Rejoin", 140, function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end)

-- Server Hop button
createLocalButton("Server Hop", 190, function()
    local servers = {}
    local req = game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
    local data = game:GetService("HttpService"):JSONDecode(req)
    
    for _, server in ipairs(data.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            table.insert(servers, server.id)
        end
    end
    
    if #servers > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
    else
        NotificationSystem:Notify("No servers found!", 2)
    end
end)

-- Low Server Hop button
createLocalButton("Low Server Hop", 240, function()
    local servers = {}
    local req = game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    local data = game:GetService("HttpService"):JSONDecode(req)
    
    for _, server in ipairs(data.data) do
        if server.playing < server.maxPlayers/2 and server.id ~= game.JobId then
            table.insert(servers, server.id)
        end
    end
    
    if #servers > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
    else
        NotificationSystem:Notify("No low population servers found!", 2)
    end
end)

--esp button
createLocalButton("Toggle ESP", 290, toggleESP)

-- Create animation buttons
local function createAnimationButton(name, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = AnimationsFrame
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, 20, 0, position)
    button.Size = UDim2.new(0, 180, 0, 40)
    button.Font = Enum.Font.GothamSemibold
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    local buttonCorner = UICorner:Clone()
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        setAnimations(Animations[name:lower()])
        NotificationSystem:Notify(name .. " animation applied!", 2)
    end)
    
    return button
end

-- Create animation buttons in order
local buttonPosition = 20
for _, name in ipairs(orderedAnimations) do
    createAnimationButton(name, buttonPosition)
    buttonPosition = buttonPosition + 50
end

-- Function to update content based on section

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 60, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 1
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.AutoButtonColor = false

local AEText = Instance.new("TextLabel")
AEText.Parent = ToggleButton
AEText.BackgroundTransparency = 1
AEText.Size = UDim2.new(1, 0, 1, 0)
AEText.Font = Enum.Font.GothamBold
AEText.Text = "AE"
AEText.TextColor3 = Color3.fromRGB(255, 255, 255)
AEText.TextSize = 14

local function createESP(player)
    if player == Player then return end
    
    local torsoPoint = Instance.new("Part")
    torsoPoint.Name = "ESPPoint"
    torsoPoint.Anchored = true
    torsoPoint.CanCollide = false
    torsoPoint.Size = Vector3.new(0.5, 0.5, 0.5)
    torsoPoint.Shape = Enum.PartType.Ball
    torsoPoint.Material = Enum.Material.Neon
    torsoPoint.BrickColor = BrickColor.new("White")
    
    local nameLabel = Instance.new("BillboardGui")
    nameLabel.Name = "ESPLabel"
    nameLabel.Size = UDim2.new(0, 100, 0, 30)
    nameLabel.StudsOffset = Vector3.new(0, 2, 0)
    nameLabel.AlwaysOnTop = true
    
    local nameText = Instance.new("TextLabel")
    nameText.BackgroundTransparency = 1
    nameText.Size = UDim2.new(1, 0, 0.5, 0)
    nameText.Font = Enum.Font.GothamBold
    nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameText.TextSize = 14
    nameText.Parent = nameLabel
    
    local healthText = Instance.new("TextLabel")
    healthText.BackgroundTransparency = 1
    healthText.Position = UDim2.new(0, 0, 0.5, 0)
    healthText.Size = UDim2.new(1, 0, 0.5, 0)
    healthText.Font = Enum.Font.GothamBold
    healthText.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthText.TextSize = 14
    healthText.Parent = nameLabel

local function updateContent(section)
    HomeFrame.Visible = section == "Home"
    AnimationsFrame.Visible = section == "Animations"
    LocalScrollFrame.Visible = section == "Local"
    CreditsFrame.Visible = section == "Credits"
end

-- Dragging functionality
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

    local function updateESP()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            torsoPoint.Parent = workspace
            nameLabel.Parent = player.Character.Head
            
            torsoPoint.Position = player.Character.HumanoidRootPart.Position
            nameText.Text = player.Name
            
            local health = player.Character:FindFirstChild("Humanoid")
            if health then
                local percentage = math.floor((health.Health / health.MaxHealth) * 100)
                healthText.Text = percentage .. "%"
                healthText.TextColor3 = Color3.fromRGB(
                    255 * (1 - percentage/100),
                    255 * (percentage/100),
                    0
                )
            end
        else
            torsoPoint.Parent = nil
            nameLabel.Parent = nil
        end
    end
    
    local connection = RunService.RenderStepped:Connect(updateESP)
    table.insert(ESP.Connections, connection)
    
    player.CharacterAdded:Connect(updateESP)
    updateESP()
end

local function toggleESP()
    ESP.Enabled = not ESP.Enabled
    
    if ESP.Enabled then
        -- Clear existing connections
        for _, connection in ipairs(ESP.Connections) do
            connection:Disconnect()
        end
        table.clear(ESP.Connections)
        
        -- Create ESP for existing players
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        
        -- Handle new players
        table.insert(ESP.Connections, Players.PlayerAdded:Connect(createESP))
    else
        -- Clean up
        for _, connection in ipairs(ESP.Connections) do
            connection:Disconnect()
        end
        table.clear(ESP.Connections)
        
        -- Remove ESP elements
        for _, v in ipairs(workspace:GetChildren()) do
            if v.Name == "ESPPoint" then
                v:Destroy()
            end
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local label = player.Character:FindFirstChild("ESPLabel", true)
                if label then label:Destroy() end
            end
        end
    end
    
    NotificationSystem:Notify("ESP " .. (ESP.Enabled and "enabled" or "disabled"), 2)
end

TopBar.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or 
        input.UserInputType == Enum.UserInputType.Touch) and Dragging then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + delta.Y
        )
    end
end)

-- Speed and Teleport functionality
SpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local speed = tonumber(SpeedInput.Text)
        if speed then
            SavedSpeed = speed
            if Player.Character then
                Player.Character.Humanoid.WalkSpeed = speed
            end
            NotificationSystem:Notify("Speed set to " .. speed, 2)
        end
    end
end)

TeleportInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local targetPlayer = findPlayer(TeleportInput.Text)
        if targetPlayer then
            Player.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
            NotificationSystem:Notify("Teleported to " .. targetPlayer.Name, 2)
        else
            NotificationSystem:Notify("Player not found!", 2)
        end
    end
end)

-- Character respawn handling
Player.CharacterAdded:Connect(function(char)
    if SavedSpeed then
        task.wait(0.5)
        char.Humanoid.WalkSpeed = SavedSpeed
    end
end)

if updateContent then
    updateContent("Home")
else
    print("La función updateContent no está definida")
end

-- Loading sequence
local function runLoadingSequence()
    if not Status or not LoadingFill or not Loading then return end
    
    local loadingSteps = {
        "Initializing...",
        "Loading animations...",
        "Setting up interface...",
        "Configuring settings...",
        "Almost ready...",
        "Launching..."
    }

    for i, step in ipairs(loadingSteps) do
        Status.Text = step
        local tween = TweenService:Create(LoadingFill, 
            TweenInfo.new(0.3, Enum.EasingStyle.Linear), 
            {Size = UDim2.new(i/#loadingSteps, 0, 1, 0)}
        )
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.2)
    end
    
    task.wait(0.5)
    Loading:Destroy()
    NotificationSystem:Notify("Script loaded successfully!", 3)
end

local function findPlayer(name)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower() == name:lower() then
            return player
        end
    end
    return nil
end

for _, button in ipairs(SectionsFrame:GetChildren()) do
    if button:IsA("TextButton") then
        button.Size = UDim2.new(1, -16, 0, 32)
        button.BorderColor3 = Color3.fromRGB(255, 255, 255)
        button.BorderSizePixel = 1
    end
end

local function updateAEText()
    local text = AEText.Text
    local firstLetter = text:sub(1,1)
    local secondLetter = text:sub(2,2)
    AEText.RichText = true
    AEText.Text = string.format('<font color="rgb(255,255,255)">%s</font><font color="rgb(255,0,0)">%s</font>', firstLetter, secondLetter)
end

local function beginDrag(input)
    local inputPosition = input.Position
    if input.UserInputType == Enum.UserInputType.Touch then
        inputPosition = Vector2.new(input.Position.X, input.Position.Y)
        LastTouch = input -- Guardamos la referencia del toque
    end
    
    Dragging = true
    DragStart = inputPosition
    StartPos = MainFrame.Position
end

local function doDrag(input)
    if not Dragging then return end
    
    local inputPosition = input.Position
    if input.UserInputType == Enum.UserInputType.Touch then
        inputPosition = Vector2.new(input.Position.X, input.Position.Y)
    end
    
    local delta = inputPosition - DragStart
    local targetPosition = UDim2.new(
        StartPos.X.Scale,
        StartPos.X.Offset + delta.X,
        StartPos.Y.Scale,
        StartPos.Y.Offset + delta.Y
    )
    
    -- Asegurarse de que el frame no se salga de la pantalla
    local minX = 0
    local minY = 0
    local maxX = workspace.CurrentCamera.ViewportSize.X - MainFrame.AbsoluteSize.X
    local maxY = workspace.CurrentCamera.ViewportSize.Y - MainFrame.AbsoluteSize.Y
    
    targetPosition = UDim2.new(
        0,
        math.clamp(targetPosition.X.Offset, minX, maxX),
        0,
        math.clamp(targetPosition.Y.Offset, minY, maxY)
    )
    
    MainFrame.Position = targetPosition
end

local function endDrag()
    Dragging = false
    DragStart = nil
    StartPos = nil
    LastTouch = nil
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or 
       (input.UserInputType == Enum.UserInputType.Touch and LastTouch and input == LastTouch) then
        doDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       (input.UserInputType == Enum.UserInputType.Touch and LastTouch and input == LastTouch) then
        endDrag()
    end
end)

UserInputService.TouchEnded:Connect(function(touch)
    if LastTouch and touch == LastTouch then
        endDrag()
    end
end)

MainFrame.AncestryChanged:Connect(function()
    if not MainFrame:IsDescendantOf(game) then
        endDrag()
    end
end)

updateAEText()

spawn(function()
    updateContent("Home")
    runLoadingSequence()
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)