--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                  APTX GUI Library v2.0                    ║
    ║         Ultra-Dark Professional GUI Framework             ║
    ║                    for Roblox                             ║
    ╚═══════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════
-- Services
-- ═══════════════════════════════════════════════════════════
local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse  = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- ═══════════════════════════════════════════════════════════
-- Theme
-- ═══════════════════════════════════════════════════════════
local Theme = {
    Background      = Color3.fromRGB(10, 10, 10),
    Sidebar         = Color3.fromRGB(14, 14, 14),
    Topbar          = Color3.fromRGB(16, 16, 16),
    ContentBg       = Color3.fromRGB(10, 10, 10),
    Card            = Color3.fromRGB(18, 18, 18),
    CardHover       = Color3.fromRGB(24, 24, 24),
    Border          = Color3.fromRGB(32, 32, 32),
    BorderLight     = Color3.fromRGB(40, 40, 40),
    Accent          = Color3.fromRGB(255, 255, 255),
    AccentDim       = Color3.fromRGB(180, 180, 180),
    Text            = Color3.fromRGB(245, 245, 245),
    TextSec         = Color3.fromRGB(140, 140, 140),
    TextMuted       = Color3.fromRGB(80, 80, 80),
    ToggleOff       = Color3.fromRGB(30, 30, 30),
    ToggleOn        = Color3.fromRGB(245, 245, 245),
    ToggleKnobOff   = Color3.fromRGB(80, 80, 80),
    ToggleKnobOn    = Color3.fromRGB(10, 10, 10),
    SliderBg        = Color3.fromRGB(28, 28, 28),
    SliderFill      = Color3.fromRGB(245, 245, 245),
    SliderKnob      = Color3.fromRGB(255, 255, 255),
    DropdownBg      = Color3.fromRGB(14, 14, 14),
    InputBg         = Color3.fromRGB(16, 16, 16),
    TabActive       = Color3.fromRGB(22, 22, 22),
    TabInactive     = Color3.fromRGB(14, 14, 14),
    TabIndicator    = Color3.fromRGB(245, 245, 245),
    HideBtn         = Color3.fromRGB(14, 14, 14),
    Separator       = Color3.fromRGB(26, 26, 26),
    Corner          = UDim.new(0, 8),
    CornerSmall     = UDim.new(0, 6),
    CornerTiny      = UDim.new(0, 4),
}

-- ═══════════════════════════════════════════════════════════
-- Lucide Icon Mapping (rbxassetid)
-- ═══════════════════════════════════════════════════════════
local LucideIcons = {
    ["home"]             = "rbxassetid://7733960981",
    ["settings"]         = "rbxassetid://7734053495",
    ["search"]           = "rbxassetid://7734052925",
    ["user"]             = "rbxassetid://7743875503",
    ["users"]            = "rbxassetid://7743876054",
    ["eye"]              = "rbxassetid://7733774602",
    ["eye-off"]          = "rbxassetid://7733774495",
    ["star"]             = "rbxassetid://7734068321",
    ["heart"]            = "rbxassetid://7733956134",
    ["info"]             = "rbxassetid://7733964719",
    ["bell"]             = "rbxassetid://7733911828",
    ["lock"]             = "rbxassetid://7733992528",
    ["unlock"]           = "rbxassetid://7743875263",
    ["shield"]           = "rbxassetid://7734056608",
    ["shield-check"]     = "rbxassetid://7734056411",
    ["check"]            = "rbxassetid://7733715400",
    ["x-circle"]         = "rbxassetid://7743878496",
    ["alert-triangle"]   = "rbxassetid://7733658504",
    ["help-circle"]      = "rbxassetid://7733956210",
    ["play"]             = "rbxassetid://7743871480",
    ["pause"]            = "rbxassetid://7734021897",
    ["power"]            = "rbxassetid://7734042493",
    ["power-off"]        = "rbxassetid://7734042423",
    ["download"]         = "rbxassetid://7733770755",
    ["upload"]           = "rbxassetid://7743875428",
    ["refresh-cw"]       = "rbxassetid://7734051052",
    ["trash"]            = "rbxassetid://7743873871",
    ["edit"]             = "rbxassetid://7733771472",
    ["edit-2"]           = "rbxassetid://7733771217",
    ["pencil"]           = "rbxassetid://7734022107",
    ["copy"]             = "rbxassetid://7733764083",
    ["clipboard"]        = "rbxassetid://7733734762",
    ["save"]             = "rbxassetid://7734052335",
    ["file"]             = "rbxassetid://7733793319",
    ["file-text"]        = "rbxassetid://7733789088",
    ["folder"]           = "rbxassetid://7733799092",
    ["mail"]             = "rbxassetid://7733992732",
    ["send"]             = "rbxassetid://7734053039",
    ["link"]             = "rbxassetid://7733978098",
    ["globe"]            = "rbxassetid://7733954760",
    ["map"]              = "rbxassetid://7733992829",
    ["compass"]          = "rbxassetid://7733924216",
    ["navigation"]       = "rbxassetid://7734020989",
    ["command"]          = "rbxassetid://7733924046",
    ["terminal"]         = "rbxassetid://7743872929",
    ["code"]             = "rbxassetid://7733749837",
    ["database"]         = "rbxassetid://7743866778",
    ["server"]           = "rbxassetid://7734053426",
    ["cpu"]              = "rbxassetid://7733765045",
    ["hard-drive"]       = "rbxassetid://7733955793",
    ["monitor"]          = "rbxassetid://7734002839",
    ["smartphone"]       = "rbxassetid://7734058979",
    ["tablet"]           = "rbxassetid://7743872620",
    ["laptop"]           = "rbxassetid://7733965386",
    ["camera"]           = "rbxassetid://7733708692",
    ["image"]            = "rbxassetid://7733964126",
    ["music"]            = "rbxassetid://7734020554",
    ["headphones"]       = "rbxassetid://7733956063",
    ["speaker"]          = "rbxassetid://7734063416",
    ["gamepad"]          = "rbxassetid://7733799901",
    ["gamepad-2"]        = "rbxassetid://7733799795",
    ["crown"]            = "rbxassetid://7733765398",
    ["award"]            = "rbxassetid://7733673987",
    ["gift"]             = "rbxassetid://7733946818",
    ["shopping-cart"]    = "rbxassetid://7734056813",
    ["shopping-bag"]     = "rbxassetid://7734056747",
    ["tag"]              = "rbxassetid://7734075797",
    ["bookmark"]         = "rbxassetid://7733692043",
    ["flag"]             = "rbxassetid://7733798691",
    ["gauge"]            = "rbxassetid://7733799969",
    ["bar-chart"]        = "rbxassetid://7733674319",
    ["pie-chart"]        = "rbxassetid://7734034378",
    ["trending-up"]      = "rbxassetid://7743874262",
    ["trending-down"]    = "rbxassetid://7743874143",
    ["layers"]           = "rbxassetid://7743868936",
    ["layout-dashboard"] = "rbxassetid://7733970318",
    ["layout-grid"]      = "rbxassetid://7733970390",
    ["list"]             = "rbxassetid://7743869612",
    ["filter"]           = "rbxassetid://7733798407",
    ["sliders"]          = "rbxassetid://7734058803",
    ["tool"]             = "rbxassetid://7733955511",
    ["wrench"]           = "rbxassetid://7733955511",
    ["hammer"]           = "rbxassetid://7733955511",
    ["axe"]              = "rbxassetid://7733674079",
    ["sword"]            = "rbxassetid://7733674079",
    ["flame"]            = "rbxassetid://7733798747",
    ["sun"]              = "rbxassetid://7734068495",
    ["moon"]             = "rbxassetid://7743870134",
    ["cloud"]            = "rbxassetid://7733746980",
    ["wifi"]             = "rbxassetid://7743878148",
    ["bluetooth"]        = "rbxassetid://7733687147",
    ["battery"]          = "rbxassetid://7733674820",
    ["clock"]            = "rbxassetid://7733734848",
    ["calendar"]         = "rbxassetid://7733919198",
    ["timer"]            = "rbxassetid://7743873443",
    ["history"]          = "rbxassetid://7733960880",
    ["archive"]          = "rbxassetid://7733911621",
    ["box"]              = "rbxassetid://7733917120",
    ["package"]          = "rbxassetid://7734021469",
    ["truck"]            = "rbxassetid://7743874482",
    ["car"]              = "rbxassetid://7733708835",
    ["plane"]            = "rbxassetid://7734037723",
    ["rocket"]           = "rbxassetid://7734051861",
    ["bike"]             = "rbxassetid://7733678330",
    ["bus"]              = "rbxassetid://7733701715",
    ["lightbulb"]        = "rbxassetid://7733975185",
    ["palette"]          = "rbxassetid://7734021595",
    ["brush"]            = "rbxassetid://7733701455",
    ["feather"]          = "rbxassetid://7733777166",
    ["pen-tool"]         = "rbxassetid://7734022041",
    ["scissors"]         = "rbxassetid://7734052570",
    ["paperclip"]        = "rbxassetid://7734021680",
    ["ruler"]            = "rbxassetid://7734052157",
    ["book"]             = "rbxassetid://7733914390",
    ["book-open"]        = "rbxassetid://7733687281",
    ["graduation-cap"]   = "rbxassetid://7733955058",
    ["briefcase"]        = "rbxassetid://7733919017",
    ["building"]         = "rbxassetid://7733701625",
    ["phone"]            = "rbxassetid://7734032056",
    ["radio"]            = "rbxassetid://7743871662",
    ["podcast"]          = "rbxassetid://7734042234",
    ["video"]            = "rbxassetid://7743876610",
    ["tv"]               = "rbxassetid://7743874674",
    ["smile"]            = "rbxassetid://7734059095",
    ["frown"]            = "rbxassetid://7733799591",
    ["skull"]            = "rbxassetid://7734058599",
    ["ghost"]            = "rbxassetid://7743868000",
    ["bot"]              = "rbxassetid://7733916988",
    ["bug"]              = "rbxassetid://7733701545",
    ["coffee"]           = "rbxassetid://7733752630",
    ["pizza"]            = "rbxassetid://7733752630",
    ["dollar-sign"]      = "rbxassetid://7733770599",
    ["coins"]            = "rbxassetid://7743866529",
    ["gem"]              = "rbxassetid://7733942651",
    ["piggy-bank"]       = "rbxassetid://7734034513",
    ["key"]              = "rbxassetid://7733965029",
    ["fingerprint"]      = "rbxassetid://7733798407",
    ["verified"]         = "rbxassetid://7743876142",
    ["hexagon"]          = "rbxassetid://7743868527",
    ["circle"]           = "rbxassetid://7733919881",
    ["square"]           = "rbxassetid://7743872181",
    ["triangle"]         = "rbxassetid://7743874367",
    ["octagon"]          = "rbxassetid://7734021165",
    ["plus"]             = "rbxassetid://7734040271",
    ["minus"]            = "rbxassetid://7734000129",
    ["x"]                = "rbxassetid://7743878496",
    ["chevron-right"]    = "rbxassetid://7733717755",
    ["chevron-down"]     = "rbxassetid://7733717447",
    ["chevrons-up"]      = "rbxassetid://7733723433",
    ["arrow-right"]      = "rbxassetid://7733673345",
    ["arrow-left"]       = "rbxassetid://7733673136",
    ["arrow-up"]         = "rbxassetid://7733673717",
    ["arrow-down"]       = "rbxassetid://7733672933",
    ["more-horizontal"]  = "rbxassetid://7734006080",
    ["more-vertical"]    = "rbxassetid://7734006187",
    ["menu"]             = "rbxassetid://7733661326",
    ["sidebar"]          = "rbxassetid://7734058260",
    ["maximize"]         = "rbxassetid://7733992982",
    ["minimize"]         = "rbxassetid://7733997870",
    ["move"]             = "rbxassetid://7734016210",
    ["log-in"]           = "rbxassetid://7733992604",
    ["log-out"]          = "rbxassetid://7733992677",
    ["zoom-in"]          = "rbxassetid://7743878977",
    ["zoom-out"]         = "rbxassetid://7743879082",
    ["thumbs-up"]        = "rbxassetid://7743873212",
    ["thumbs-down"]      = "rbxassetid://7734084236",
    ["share"]            = "rbxassetid://7734053697",
    ["github"]           = "rbxassetid://7733954058",
    ["gitlab"]           = "rbxassetid://7733954246",
    ["chrome"]           = "rbxassetid://7733919783",
    ["figma"]            = "rbxassetid://7743867310",
    ["wind"]             = "rbxassetid://7743878264",
    ["snowflake"]        = "rbxassetid://7734059180",
    ["umbrella"]         = "rbxassetid://7743874820",
    ["mountain"]         = "rbxassetid://7734008868",
    ["life-buoy"]        = "rbxassetid://7733973479",
    ["anchor"]           = "rbxassetid://7733911621",
    ["target"]           = "rbxassetid://7743872758",
    ["crosshair"]        = "rbxassetid://7743872758",
    ["zap"]              = "rbxassetid://7733798747",
    ["toggle-left"]      = "rbxassetid://7734091286",
    ["toggle-right"]     = "rbxassetid://7743873539",
    ["network"]          = "rbxassetid://7734021047",
    ["scale"]            = "rbxassetid://7734052454",
    ["wand"]             = "rbxassetid://8997388430",
}

-- ═══════════════════════════════════════════════════════════
-- Utility Functions
-- ═══════════════════════════════════════════════════════════

--- Create a Roblox Instance with properties and optional children
local function create(className, props, children)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

--- Tween an instance
local function tween(inst, props, duration, style)
    local info = TweenInfo.new(
        duration or 0.25,
        style or Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

--- Add UICorner
local function corner(parent, radius)
    return create("UICorner", {
        CornerRadius = radius or Theme.Corner,
        Parent = parent,
    })
end

--- Add UIStroke
local function stroke(parent, color, thickness)
    return create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = 0.5,
        Parent = parent,
    })
end

--- Add UIPadding
local function padding(parent, t, b, l, r)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        Parent = parent,
    })
end

--- Add UIListLayout
local function listLayout(parent, dir, pad, hAlign, vAlign, sortOrder)
    return create("UIListLayout", {
        FillDirection = dir or Enum.FillDirection.Vertical,
        Padding = pad or UDim.new(0, 4),
        HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left,
        VerticalAlignment = vAlign or Enum.VerticalAlignment.Top,
        SortOrder = sortOrder or Enum.SortOrder.LayoutOrder,
        Parent = parent,
    })
end

--- Get icon URL from name
local function getIcon(name, customIcons)
    if not name then return nil end
    if customIcons and customIcons[name] then
        return customIcons[name]
    end
    return LucideIcons[name]
end

--- Calculate adaptive screen sizing
local function getScreenScale()
    local viewport = Camera.ViewportSize
    local scaleX = viewport.X / 1920
    local scaleY = viewport.Y / 1080
    local scale = math.min(scaleX, scaleY)
    return math.clamp(scale, 0.45, 1.0), viewport
end

--- Create a section label
local function createSectionLabel(parent, text)
    return create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        Text = string.upper(text),
        TextColor3 = Theme.TextMuted,
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = -1,
        Parent = parent,
    })
end

--- Create icon image label
local function createIcon(parent, iconName, size, color, customIcons)
    local url = getIcon(iconName, customIcons)
    if not url then return nil end
    return create("ImageLabel", {
        Size = UDim2.new(0, size or 16, 0, size or 16),
        BackgroundTransparency = 1,
        Image = url,
        ImageColor3 = color or Theme.TextSec,
        ScaleType = Enum.ScaleType.Fit,
        Parent = parent,
    })
end

--- Ripple / hover effect
local function addHover(frame, hoverColor, normalColor)
    frame.MouseEnter:Connect(function()
        tween(frame, {BackgroundColor3 = hoverColor or Theme.CardHover}, 0.15)
    end)
    frame.MouseLeave:Connect(function()
        tween(frame, {BackgroundColor3 = normalColor or Theme.Card}, 0.15)
    end)
end

-- ═══════════════════════════════════════════════════════════
-- Library
-- ═══════════════════════════════════════════════════════════
local APTX = {}

function APTX:Config(config)
    config = config or {}

    local title        = config.Title or "APTX"
    local iconMode     = config.icons or "default"
    local hideButton   = config.hidebutton
    local customIcons  = (iconMode == "custom") and config.customIcons or nil

    if hideButton == nil then hideButton = true end

    -- ─── Screen Adaptation ─────────────────────────────
    local scale, viewport = getScreenScale()

    local guiWidth  = math.floor(math.clamp(520 * scale, 340, 560))
    local guiHeight = math.floor(math.clamp(340 * scale, 240, 380))
    local topbarH   = math.floor(36 * scale)
    local sidebarW  = 0.25
    local fontSize   = math.floor(math.clamp(12 * scale, 10, 13))
    local fontSizeS  = math.floor(math.clamp(10 * scale, 9, 11))
    local iconSize   = math.floor(math.clamp(16 * scale, 12, 16))
    local compHeight = math.floor(math.clamp(34 * scale, 28, 36))

    -- ─── ScreenGui ─────────────────────────────────────
    local screenGui = create("ScreenGui", {
        Name = "APTX_GUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        Parent = Player:WaitForChild("PlayerGui"),
    })

    -- ─── Main Frame ────────────────────────────────────
    local mainFrame = create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, guiWidth, 0, guiHeight),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = screenGui,
    })
    corner(mainFrame, Theme.Corner)
    stroke(mainFrame, Theme.Border, 1)

    -- Drag functionality
    local dragging, dragStart, startPos = false, nil, nil
    local topbarFrame -- forward declaration

    local function onDragStart(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end

    local function onDragUpdate(input)
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end

    local function onDragEnd(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end

    -- ─── Topbar ────────────────────────────────────────
    topbarFrame = create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, topbarH),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Topbar,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })
    create("UICorner", {
        CornerRadius = Theme.Corner,
        Parent = topbarFrame,
    })
    -- Cover bottom corners of topbar
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.Topbar,
        BorderSizePixel = 0,
        Parent = topbarFrame,
    })

    -- Topbar separator line
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        BackgroundTransparency = 0.5,
        Parent = topbarFrame,
    })

    -- Title (left side)
    local titleIcon = createIcon(topbarFrame, "hexagon", math.floor(14 * scale), Theme.Accent)
    if titleIcon then
        titleIcon.Position = UDim2.new(0, math.floor(12 * scale), 0.5, 0)
        titleIcon.AnchorPoint = Vector2.new(0, 0.5)
    end

    local titleLabel = create("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, titleIcon and math.floor(32 * scale) or math.floor(12 * scale), 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = math.floor(13 * scale),
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topbarFrame,
    })

    -- Version badge
    create("TextLabel", {
        Size = UDim2.new(0, 30, 0, 14),
        Position = UDim2.new(0, titleLabel.Position.X.Offset + titleLabel.TextBounds.X + 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.5,
        Text = "v2",
        TextColor3 = Theme.TextMuted,
        TextSize = math.floor(9 * scale),
        Font = Enum.Font.GothamMedium,
        Parent = topbarFrame,
    }):FindFirstChildOfClass("UICorner") or corner(
        topbarFrame:FindFirstChild("TextLabel") -- fallback
    )

    -- Close button
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, topbarH - 12, 0, topbarH - 12),
        Position = UDim2.new(1, -(topbarH - 4), 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.Topbar,
        BackgroundTransparency = 1,
        Text = "",
        Parent = topbarFrame,
    })
    corner(closeBtn, UDim.new(0, 4))
    create("ImageLabel", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = LucideIcons["x"] or "",
        ImageColor3 = Theme.TextMuted,
        Parent = closeBtn,
    })
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 1}, 0.15)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(mainFrame, {Size = UDim2.new(0, guiWidth, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        task.wait(0.35)
        mainFrame.Visible = false
        mainFrame.Size = UDim2.new(0, guiWidth, 0, guiHeight)
    end)

    -- Drag connections
    topbarFrame.InputBegan:Connect(onDragStart)
    UserInputService.InputChanged:Connect(onDragUpdate)
    UserInputService.InputEnded:Connect(onDragEnd)

    -- ─── Body Container (below topbar) ─────────────────
    local bodyFrame = create("Frame", {
        Name = "Body",
        Size = UDim2.new(1, 0, 1, -topbarH),
        Position = UDim2.new(0, 0, 0, topbarH),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })

    -- ─── Sidebar (25%) ────────────────────────────────
    local sidebarFrame = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(sidebarW, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = bodyFrame,
    })

    -- Sidebar separator line
    create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = sidebarFrame,
    })

    local tabContainer = create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebarFrame,
    })
    listLayout(tabContainer, Enum.FillDirection.Vertical, UDim.new(0, 2))

    -- ─── Content Area (75%) ───────────────────────────
    local contentFrame = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1 - sidebarW, 0, 1, 0),
        Position = UDim2.new(sidebarW, 0, 0, 0),
        BackgroundColor3 = Theme.ContentBg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = bodyFrame,
    })

    -- ─── Hide / Show Button ───────────────────────────
    local hideBtnFrame
    if hideButton then
        hideBtnFrame = create("TextButton", {
            Name = "HideButton",
            Size = UDim2.new(0, math.floor(32 * scale), 0, math.floor(32 * scale)),
            Position = UDim2.new(0, math.floor(10 * scale), 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme.HideBtn,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = screenGui,
        })
        corner(hideBtnFrame, UDim.new(0, 6))
        stroke(hideBtnFrame, Theme.Border, 1)

        local hideIcon = create("ImageLabel", {
            Size = UDim2.new(0, math.floor(16 * scale), 0, math.floor(16 * scale)),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = LucideIcons["sidebar"] or "",
            ImageColor3 = Theme.TextSec,
            Parent = hideBtnFrame,
        })

        hideBtnFrame.MouseEnter:Connect(function()
            tween(hideBtnFrame, {BackgroundColor3 = Theme.CardHover}, 0.15)
            tween(hideIcon, {ImageColor3 = Theme.Text}, 0.15)
        end)
        hideBtnFrame.MouseLeave:Connect(function()
            tween(hideBtnFrame, {BackgroundColor3 = Theme.HideBtn}, 0.15)
            tween(hideIcon, {ImageColor3 = Theme.TextSec}, 0.15)
        end)

        local guiVisible = true
        hideBtnFrame.MouseButton1Click:Connect(function()
            guiVisible = not guiVisible
            if guiVisible then
                mainFrame.Visible = true
                mainFrame.Size = UDim2.new(0, 0, 0, guiHeight)
                tween(mainFrame, {Size = UDim2.new(0, guiWidth, 0, guiHeight)}, 0.35, Enum.EasingStyle.Back)
            else
                tween(mainFrame, {Size = UDim2.new(0, 0, 0, guiHeight)}, 0.3, Enum.EasingStyle.Back)
                task.wait(0.35)
                mainFrame.Visible = false
            end
        end)
    end

    -- Open animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Visible = true
    task.defer(function()
        tween(mainFrame, {Size = UDim2.new(0, guiWidth, 0, guiHeight)}, 0.45, Enum.EasingStyle.Back)
    end)

    -- ═══════════════════════════════════════════════════
    -- Window Object
    -- ═══════════════════════════════════════════════════
    local Window = {}
    Window._tabs = {}
    Window._activeTab = nil
    Window._contentPages = {}
    Window._scale = scale
    Window._compHeight = compHeight
    Window._fontSize = fontSize
    Window._fontSizeS = fontSizeS
    Window._iconSize = iconSize
    Window._customIcons = customIcons

    -- ─── Tab Creation ──────────────────────────────────
    function Window:Tab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon
        local tabOrder = #self._tabs + 1

        -- Tab button in sidebar
        local tabBtnHeight = math.floor(28 * scale)
        local tabBtn = create("TextButton", {
            Name = "Tab_" .. tabName,
            Size = UDim2.new(1, -4, 0, tabBtnHeight),
            BackgroundColor3 = Theme.TabInactive,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = tabOrder,
            Parent = tabContainer,
        })
        corner(tabBtn, Theme.CornerSmall)

        -- Active indicator (left bar)
        local indicator = create("Frame", {
            Name = "Indicator",
            Size = UDim2.new(0, 2, 0.5, 0),
            Position = UDim2.new(0, 0, 0.25, 0),
            BackgroundColor3 = Theme.TabIndicator,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Parent = tabBtn,
        })
        corner(indicator, UDim.new(0, 1))

        -- Tab icon
        local tabIconLabel
        local textOffset = math.floor(10 * scale)
        if tabIcon then
            local url = getIcon(tabIcon, customIcons)
            if url then
                tabIconLabel = create("ImageLabel", {
                    Size = UDim2.new(0, math.floor(14 * scale), 0, math.floor(14 * scale)),
                    Position = UDim2.new(0, math.floor(10 * scale), 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Image = url,
                    ImageColor3 = Theme.TextMuted,
                    ScaleType = Enum.ScaleType.Fit,
                    Parent = tabBtn,
                })
                textOffset = math.floor(28 * scale)
            end
        end

        -- Tab label
        local tabLabel = create("TextLabel", {
            Size = UDim2.new(1, -textOffset - 4, 1, 0),
            Position = UDim2.new(0, textOffset, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Theme.TextMuted,
            TextSize = math.floor(11 * scale),
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = tabBtn,
        })

        -- Content page (scrollable)
        local contentPage = create("ScrollingFrame", {
            Name = "Page_" .. tabName,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.BorderLight,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentFrame,
        })
        padding(contentPage, math.floor(8 * scale), math.floor(8 * scale), math.floor(10 * scale), math.floor(10 * scale))
        listLayout(contentPage, Enum.FillDirection.Vertical, UDim.new(0, math.floor(4 * scale)))

        -- Tab switch logic
        local function activateTab()
            -- Deactivate all
            for _, t in ipairs(self._tabs) do
                t.page.Visible = false
                tween(t.btn, {BackgroundTransparency = 1}, 0.15)
                tween(t.indicator, {BackgroundTransparency = 1}, 0.15)
                tween(t.label, {TextColor3 = Theme.TextMuted}, 0.15)
                if t.iconLabel then
                    tween(t.iconLabel, {ImageColor3 = Theme.TextMuted}, 0.15)
                end
            end
            -- Activate this
            contentPage.Visible = true
            tween(tabBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.TabActive}, 0.2)
            tween(indicator, {BackgroundTransparency = 0}, 0.2)
            tween(tabLabel, {TextColor3 = Theme.Text}, 0.2)
            if tabIconLabel then
                tween(tabIconLabel, {ImageColor3 = Theme.Text}, 0.2)
            end
            self._activeTab = tabName
        end

        tabBtn.MouseButton1Click:Connect(activateTab)

        -- Hover
        tabBtn.MouseEnter:Connect(function()
            if self._activeTab ~= tabName then
                tween(tabBtn, {BackgroundTransparency = 0.5, BackgroundColor3 = Theme.TabActive}, 0.12)
                tween(tabLabel, {TextColor3 = Theme.TextSec}, 0.12)
                if tabIconLabel then
                    tween(tabIconLabel, {ImageColor3 = Theme.TextSec}, 0.12)
                end
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self._activeTab ~= tabName then
                tween(tabBtn, {BackgroundTransparency = 1}, 0.12)
                tween(tabLabel, {TextColor3 = Theme.TextMuted}, 0.12)
                if tabIconLabel then
                    tween(tabIconLabel, {ImageColor3 = Theme.TextMuted}, 0.12)
                end
            end
        end)

        -- Store tab data
        local tabData = {
            btn = tabBtn,
            page = contentPage,
            label = tabLabel,
            iconLabel = tabIconLabel,
            indicator = indicator,
            name = tabName,
        }
        table.insert(self._tabs, tabData)

        -- Auto activate first tab
        if #self._tabs == 1 then
            activateTab()
        end

        -- ═══════════════════════════════════════════════
        -- Tab Component Methods
        -- ═══════════════════════════════════════════════
        local Tab = {}
        Tab._page = contentPage
        Tab._order = 0

        local function nextOrder()
            Tab._order = Tab._order + 1
            return Tab._order
        end

        -- ─── Button ────────────────────────────────────
        function Tab:Button(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Button"
            local icon = cfg.Icon
            local callback = cfg.Callback or function() end

            local btn = create("TextButton", {
                Size = UDim2.new(1, 0, 0, compHeight),
                BackgroundColor3 = Theme.Card,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })
            corner(btn, Theme.CornerSmall)
            stroke(btn, Theme.Border, 1)

            local contentLayout = create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Parent = btn,
            })
            padding(contentLayout, 0, 0, math.floor(10 * scale), math.floor(10 * scale))

            local iconOffset = 0
            if icon then
                local ic = createIcon(contentLayout, icon, iconSize, Theme.TextSec, customIcons)
                if ic then
                    ic.Position = UDim2.new(0, 0, 0.5, 0)
                    ic.AnchorPoint = Vector2.new(0, 0.5)
                    iconOffset = iconSize + math.floor(8 * scale)
                end
            end

            create("TextLabel", {
                Size = UDim2.new(1, -iconOffset - math.floor(20 * scale), 1, 0),
                Position = UDim2.new(0, iconOffset, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = fontSize,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = contentLayout,
            })

            -- Arrow indicator on right
            local arrowIcon = createIcon(contentLayout, "chevron-right", math.floor(12 * scale), Theme.TextMuted)
            if arrowIcon then
                arrowIcon.Position = UDim2.new(1, 0, 0.5, 0)
                arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
            end

            addHover(btn, Theme.CardHover, Theme.Card)
            btn.MouseButton1Click:Connect(function()
                -- Click feedback
                tween(btn, {BackgroundColor3 = Theme.BorderLight}, 0.05)
                task.wait(0.08)
                tween(btn, {BackgroundColor3 = Theme.Card}, 0.15)
                callback()
            end)

            return btn
        end

        -- ─── Toggle ───────────────────────────────────
        function Tab:Toggle(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Toggle"
            local icon = cfg.Icon
            local default = cfg.Default or false
            local callback = cfg.Callback or function() end
            local state = default

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, compHeight),
                BackgroundColor3 = Theme.Card,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })
            corner(frame, Theme.CornerSmall)
            stroke(frame, Theme.Border, 1)
            padding(frame, 0, 0, math.floor(10 * scale), math.floor(10 * scale))

            local iconOffset = 0
            if icon then
                local ic = createIcon(frame, icon, iconSize, Theme.TextSec, customIcons)
                if ic then
                    ic.Position = UDim2.new(0, 0, 0.5, 0)
                    ic.AnchorPoint = Vector2.new(0, 0.5)
                    iconOffset = iconSize + math.floor(8 * scale)
                end
            end

            create("TextLabel", {
                Size = UDim2.new(1, -iconOffset - math.floor(50 * scale), 1, 0),
                Position = UDim2.new(0, iconOffset, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = fontSize,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame,
            })

            -- Toggle track
            local trackW = math.floor(34 * scale)
            local trackH = math.floor(18 * scale)
            local knobSize = trackH - 4

            local track = create("TextButton", {
                Size = UDim2.new(0, trackW, 0, trackH),
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = frame,
            })
            corner(track, UDim.new(0.5, 0))

            local knob = create("Frame", {
                Size = UDim2.new(0, knobSize, 0, knobSize),
                Position = state and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
                BackgroundColor3 = state and Theme.ToggleKnobOn or Theme.ToggleKnobOff,
                BorderSizePixel = 0,
                Parent = track,
            })
            corner(knob, UDim.new(0.5, 0))

            local function updateToggle()
                state = not state
                if state then
                    tween(track, {BackgroundColor3 = Theme.ToggleOn}, 0.2)
                    tween(knob, {
                        Position = UDim2.new(1, -2, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Theme.ToggleKnobOn,
                    }, 0.2, Enum.EasingStyle.Back)
                else
                    tween(track, {BackgroundColor3 = Theme.ToggleOff}, 0.2)
                    tween(knob, {
                        Position = UDim2.new(0, 2, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Theme.ToggleKnobOff,
                    }, 0.2, Enum.EasingStyle.Back)
                end
                callback(state)
            end

            track.MouseButton1Click:Connect(updateToggle)
            return {frame = frame, setState = function(_, v) state = not v; updateToggle() end}
        end

        -- ─── Slider ───────────────────────────────────
        function Tab:Slider(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Slider"
            local icon = cfg.Icon
            local min = cfg.Min or 0
            local max = cfg.Max or 100
            local default = math.clamp(cfg.Default or min, min, max)
            local callback = cfg.Callback or function() end

            local sliderH = math.floor(compHeight * 1.45)

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, sliderH),
                BackgroundColor3 = Theme.Card,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })
            corner(frame, Theme.CornerSmall)
            stroke(frame, Theme.Border, 1)
            padding(frame, 0, 0, math.floor(10 * scale), math.floor(10 * scale))

            -- Top row: icon + name + value
            local iconOffset = 0
            if icon then
                local ic = createIcon(frame, icon, iconSize, Theme.TextSec, customIcons)
                if ic then
                    ic.Position = UDim2.new(0, 0, 0, math.floor(sliderH * 0.22))
                    ic.AnchorPoint = Vector2.new(0, 0.5)
                    iconOffset = iconSize + math.floor(8 * scale)
                end
            end

            create("TextLabel", {
                Size = UDim2.new(0.6, -iconOffset, 0, math.floor(sliderH * 0.45)),
                Position = UDim2.new(0, iconOffset, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = fontSize,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame,
            })

            local valueLabel = create("TextLabel", {
                Size = UDim2.new(0.35, 0, 0, math.floor(sliderH * 0.45)),
                Position = UDim2.new(1, 0, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = tostring(default),
                TextColor3 = Theme.AccentDim,
                TextSize = fontSizeS,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = frame,
            })

            -- Slider bar
            local barHeight = math.floor(4 * scale)
            local barY = math.floor(sliderH * 0.65)
            local knobRadius = math.floor(6 * scale)

            local sliderBar = create("Frame", {
                Name = "SliderBar",
                Size = UDim2.new(1, 0, 0, barHeight),
                Position = UDim2.new(0, 0, 0, barY),
                BackgroundColor3 = Theme.SliderBg,
                BorderSizePixel = 0,
                Parent = frame,
            })
            corner(sliderBar, UDim.new(0.5, 0))

            local defaultPercent = (default - min) / math.max(max - min, 1)

            local sliderFill = create("Frame", {
                Name = "SliderFill",
                Size = UDim2.new(defaultPercent, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = Theme.SliderFill,
                BorderSizePixel = 0,
                Parent = sliderBar,
            })
            corner(sliderFill, UDim.new(0.5, 0))

            local sliderKnob = create("Frame", {
                Name = "SliderKnob",
                Size = UDim2.new(0, knobRadius * 2, 0, knobRadius * 2),
                Position = UDim2.new(defaultPercent, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Theme.SliderKnob,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = sliderBar,
            })
            corner(sliderKnob, UDim.new(0.5, 0))

            -- Knob shadow
            create("UIStroke", {
                Color = Color3.fromRGB(0, 0, 0),
                Thickness = 1,
                Transparency = 0.7,
                Parent = sliderKnob,
            })

            -- Slider interaction
            local sliderDragging = false

            local function updateSliderFromInput(inputX)
                local barAbsPos = sliderBar.AbsolutePosition.X
                local barAbsSize = sliderBar.AbsoluteSize.X
                if barAbsSize <= 0 then return end

                local percent = math.clamp((inputX - barAbsPos) / barAbsSize, 0, 1)
                local value = math.floor(min + (max - min) * percent + 0.5)
                local exactPercent = (value - min) / math.max(max - min, 1)

                -- Update fill width
                sliderFill.Size = UDim2.new(exactPercent, 0, 1, 0)
                -- Update knob position
                sliderKnob.Position = UDim2.new(exactPercent, 0, 0.5, 0)
                -- Update value text
                valueLabel.Text = tostring(value)

                callback(value)
            end

            -- Click on bar to set value
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    sliderDragging = true
                    updateSliderFromInput(input.Position.X)
                end
            end)

            -- Click on knob to start drag
            sliderKnob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    sliderDragging = true
                end
            end)

            -- Track mouse/touch movement
            UserInputService.InputChanged:Connect(function(input)
                if sliderDragging then
                    if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                        updateSliderFromInput(input.Position.X)
                    end
                end
            end)

            -- Release
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    if sliderDragging then
                        sliderDragging = false
                        -- Subtle knob scale feedback
                        tween(sliderKnob, {Size = UDim2.new(0, knobRadius * 2, 0, knobRadius * 2)}, 0.15)
                    end
                end
            end)

            return {
                frame = frame,
                setValue = function(_, v)
                    v = math.clamp(v, min, max)
                    local p = (v - min) / math.max(max - min, 1)
                    sliderFill.Size = UDim2.new(p, 0, 1, 0)
                    sliderKnob.Position = UDim2.new(p, 0, 0.5, 0)
                    valueLabel.Text = tostring(v)
                end,
            }
        end

        -- ─── Dropdown ─────────────────────────────────
        function Tab:Dropdown(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Dropdown"
            local icon = cfg.Icon
            local options = cfg.Options or {}
            local callback = cfg.Callback or function() end
            local selected = cfg.Default or (options[1] or "Select...")

            local dropdownH = compHeight
            local isOpen = false

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, dropdownH),
                BackgroundColor3 = Theme.Card,
                BorderSizePixel = 0,
                ClipsDescendants = false,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })
            corner(frame, Theme.CornerSmall)
            stroke(frame, Theme.Border, 1)
            padding(frame, 0, 0, math.floor(10 * scale), math.floor(10 * scale))

            local iconOffset = 0
            if icon then
                local ic = createIcon(frame, icon, iconSize, Theme.TextSec, customIcons)
                if ic then
                    ic.Position = UDim2.new(0, 0, 0, dropdownH / 2)
                    ic.AnchorPoint = Vector2.new(0, 0.5)
                    iconOffset = iconSize + math.floor(8 * scale)
                end
            end

            create("TextLabel", {
                Size = UDim2.new(0.45, -iconOffset, 0, dropdownH),
                Position = UDim2.new(0, iconOffset, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = fontSize,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame,
            })

            -- Selected value button
            local selectBtn = create("TextButton", {
                Size = UDim2.new(0.5, 0, 0, math.floor(compHeight * 0.7)),
                Position = UDim2.new(1, 0, 0, dropdownH / 2),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Theme.InputBg,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = frame,
            })
            corner(selectBtn, Theme.CornerTiny)
            stroke(selectBtn, Theme.Border, 1)

            local selectedLabel = create("TextLabel", {
                Size = UDim2.new(1, -math.floor(24 * scale), 1, 0),
                Position = UDim2.new(0, math.floor(8 * scale), 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(selected),
                TextColor3 = Theme.TextSec,
                TextSize = fontSizeS,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = selectBtn,
            })

            local chevron = createIcon(selectBtn, "chevron-down", math.floor(10 * scale), Theme.TextMuted)
            if chevron then
                chevron.Position = UDim2.new(1, -math.floor(6 * scale), 0.5, 0)
                chevron.AnchorPoint = Vector2.new(1, 0.5)
            end

            -- Dropdown list (rendered in ScreenGui for z-index)
            local dropList = create("Frame", {
                Name = "DropList_" .. name,
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = Theme.DropdownBg,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 100,
                ClipsDescendants = true,
                Parent = screenGui,
            })
            corner(dropList, Theme.CornerSmall)
            stroke(dropList, Theme.Border, 1)

            local dropScroll = create("ScrollingFrame", {
                Size = UDim2.new(1, -4, 1, -4),
                Position = UDim2.new(0, 2, 0, 2),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Theme.BorderLight,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 101,
                Parent = dropList,
            })
            listLayout(dropScroll, Enum.FillDirection.Vertical, UDim.new(0, 1))

            local optionHeight = math.floor(26 * scale)
            for i, opt in ipairs(options) do
                local optBtn = create("TextButton", {
                    Size = UDim2.new(1, 0, 0, optionHeight),
                    BackgroundColor3 = Theme.DropdownBg,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    LayoutOrder = i,
                    ZIndex = 102,
                    Parent = dropScroll,
                })

                create("TextLabel", {
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(opt),
                    TextColor3 = Theme.TextSec,
                    TextSize = fontSizeS,
                    Font = Enum.Font.GothamMedium,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 102,
                    Parent = optBtn,
                })

                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.CardHover}, 0.1)
                end)
                optBtn.MouseLeave:Connect(function()
                    tween(optBtn, {BackgroundTransparency = 1}, 0.1)
                end)
                optBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    selectedLabel.Text = tostring(opt)
                    selectedLabel.TextColor3 = Theme.Text
                    callback(opt)
                    -- Close
                    isOpen = false
                    tween(dropList, {Size = UDim2.new(0, dropList.Size.X.Offset, 0, 0)}, 0.15)
                    task.wait(0.15)
                    dropList.Visible = false
                end)
            end

            -- Toggle dropdown
            selectBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    -- Position dropdown below button
                    local absPos = selectBtn.AbsolutePosition
                    local absSize = selectBtn.AbsoluteSize
                    local listH = math.min(#options * optionHeight + 4, math.floor(150 * scale))
                    dropList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
                    dropList.Size = UDim2.new(0, absSize.X, 0, 0)
                    dropList.Visible = true
                    tween(dropList, {Size = UDim2.new(0, absSize.X, 0, listH)}, 0.2, Enum.EasingStyle.Back)
                    if chevron then
                        tween(chevron, {Rotation = 180}, 0.2)
                    end
                else
                    tween(dropList, {Size = UDim2.new(0, dropList.Size.X.Offset, 0, 0)}, 0.15)
                    task.wait(0.15)
                    dropList.Visible = false
                    if chevron then
                        tween(chevron, {Rotation = 0}, 0.2)
                    end
                end
            end)

            return {
                frame = frame,
                setSelected = function(_, v)
                    selected = v
                    selectedLabel.Text = tostring(v)
                    selectedLabel.TextColor3 = Theme.Text
                end,
            }
        end

        -- ─── Input / TextBox ──────────────────────────
        function Tab:Input(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Input"
            local icon = cfg.Icon
            local placeholder = cfg.Placeholder or "Type..."
            local callback = cfg.Callback or function() end

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, compHeight),
                BackgroundColor3 = Theme.Card,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })
            corner(frame, Theme.CornerSmall)
            stroke(frame, Theme.Border, 1)
            padding(frame, 0, 0, math.floor(10 * scale), math.floor(10 * scale))

            local iconOffset = 0
            if icon then
                local ic = createIcon(frame, icon, iconSize, Theme.TextSec, customIcons)
                if ic then
                    ic.Position = UDim2.new(0, 0, 0.5, 0)
                    ic.AnchorPoint = Vector2.new(0, 0.5)
                    iconOffset = iconSize + math.floor(8 * scale)
                end
            end

            create("TextLabel", {
                Size = UDim2.new(0.35, -iconOffset, 1, 0),
                Position = UDim2.new(0, iconOffset, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = fontSize,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame,
            })

            local inputBox = create("TextBox", {
                Size = UDim2.new(0.55, 0, 0, math.floor(compHeight * 0.7)),
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Theme.InputBg,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = placeholder,
                PlaceholderColor3 = Theme.TextMuted,
                TextColor3 = Theme.Text,
                TextSize = fontSizeS,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = frame,
            })
            corner(inputBox, Theme.CornerTiny)
            stroke(inputBox, Theme.Border, 1)
            padding(inputBox, 0, 0, math.floor(8 * scale), math.floor(8 * scale))

            inputBox.Focused:Connect(function()
                tween(inputBox, {BackgroundColor3 = Theme.CardHover}, 0.15)
            end)
            inputBox.FocusLost:Connect(function(enterPressed)
                tween(inputBox, {BackgroundColor3 = Theme.InputBg}, 0.15)
                if enterPressed then
                    callback(inputBox.Text)
                end
            end)

            return {frame = frame, getText = function() return inputBox.Text end}
        end

        -- ─── Label ────────────────────────────────────
        function Tab:Label(cfg)
            cfg = cfg or {}
            local text = cfg.Text or "Label"
            local icon = cfg.Icon

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, math.floor(compHeight * 0.8)),
                BackgroundColor3 = Theme.Card,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })
            corner(frame, Theme.CornerSmall)
            padding(frame, 0, 0, math.floor(10 * scale), math.floor(10 * scale))

            local iconOffset = 0
            if icon then
                local ic = createIcon(frame, icon, math.floor(iconSize * 0.9), Theme.TextMuted, customIcons)
                if ic then
                    ic.Position = UDim2.new(0, 0, 0.5, 0)
                    ic.AnchorPoint = Vector2.new(0, 0.5)
                    iconOffset = iconSize + math.floor(6 * scale)
                end
            end

            local label = create("TextLabel", {
                Size = UDim2.new(1, -iconOffset, 1, 0),
                Position = UDim2.new(0, iconOffset, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.TextSec,
                TextSize = fontSizeS,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = frame,
            })

            return {
                frame = frame,
                setText = function(_, v) label.Text = v end,
            }
        end

        -- ─── Separator ────────────────────────────────
        function Tab:Separator()
            local sep = create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Theme.Separator,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })
            -- Add top/bottom margin with invisible frames
            create("Frame", {
                Size = UDim2.new(1, 0, 0, math.floor(4 * scale)),
                BackgroundTransparency = 1,
                LayoutOrder = Tab._order,
                Parent = contentPage,
            })
            return sep
        end

        -- ─── Keybind ──────────────────────────────────
        function Tab:Keybind(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Keybind"
            local icon = cfg.Icon
            local default = cfg.Default or Enum.KeyCode.Unknown
            local callback = cfg.Callback or function() end
            local currentKey = default
            local listening = false

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, compHeight),
                BackgroundColor3 = Theme.Card,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })
            corner(frame, Theme.CornerSmall)
            stroke(frame, Theme.Border, 1)
            padding(frame, 0, 0, math.floor(10 * scale), math.floor(10 * scale))

            local iconOffset = 0
            if icon then
                local ic = createIcon(frame, icon, iconSize, Theme.TextSec, customIcons)
                if ic then
                    ic.Position = UDim2.new(0, 0, 0.5, 0)
                    ic.AnchorPoint = Vector2.new(0, 0.5)
                    iconOffset = iconSize + math.floor(8 * scale)
                end
            end

            create("TextLabel", {
                Size = UDim2.new(0.55, -iconOffset, 1, 0),
                Position = UDim2.new(0, iconOffset, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = fontSize,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame,
            })

            local keyBtn = create("TextButton", {
                Size = UDim2.new(0, math.floor(70 * scale), 0, math.floor(compHeight * 0.65)),
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Theme.InputBg,
                BorderSizePixel = 0,
                Text = tostring(default.Name),
                TextColor3 = Theme.TextSec,
                TextSize = fontSizeS,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
                Parent = frame,
            })
            corner(keyBtn, Theme.CornerTiny)
            stroke(keyBtn, Theme.Border, 1)

            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                tween(keyBtn, {BackgroundColor3 = Theme.CardHover}, 0.15)
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    keyBtn.Text = input.KeyCode.Name
                    tween(keyBtn, {BackgroundColor3 = Theme.InputBg}, 0.15)
                    callback(currentKey)
                end
            end)

            return {
                frame = frame,
                getKey = function() return currentKey end,
            }
        end

        -- ─── Section Header ───────────────────────────
        function Tab:Section(cfg)
            cfg = cfg or {}
            local text = cfg.Name or "Section"

            create("Frame", {
                Size = UDim2.new(1, 0, 0, math.floor(2 * scale)),
                BackgroundTransparency = 1,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })

            local label = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, math.floor(16 * scale)),
                BackgroundTransparency = 1,
                Text = string.upper(text),
                TextColor3 = Theme.TextMuted,
                TextSize = math.floor(9 * scale),
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })

            return label
        end

        -- ─── Color Picker (Simplified) ────────────────
        function Tab:ColorPicker(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Color"
            local icon = cfg.Icon
            local default = cfg.Default or Color3.fromRGB(255, 255, 255)
            local callback = cfg.Callback or function() end

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, compHeight),
                BackgroundColor3 = Theme.Card,
                BorderSizePixel = 0,
                LayoutOrder = nextOrder(),
                Parent = contentPage,
            })
            corner(frame, Theme.CornerSmall)
            stroke(frame, Theme.Border, 1)
            padding(frame, 0, 0, math.floor(10 * scale), math.floor(10 * scale))

            local iconOffset = 0
            if icon then
                local ic = createIcon(frame, icon, iconSize, Theme.TextSec, customIcons)
                if ic then
                    ic.Position = UDim2.new(0, 0, 0.5, 0)
                    ic.AnchorPoint = Vector2.new(0, 0.5)
                    iconOffset = iconSize + math.floor(8 * scale)
                end
            end

            create("TextLabel", {
                Size = UDim2.new(0.6, -iconOffset, 1, 0),
                Position = UDim2.new(0, iconOffset, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = fontSize,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame,
            })

            local colorPreview = create("Frame", {
                Size = UDim2.new(0, math.floor(compHeight * 0.55), 0, math.floor(compHeight * 0.55)),
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                Parent = frame,
            })
            corner(colorPreview, UDim.new(0.5, 0))
            stroke(colorPreview, Theme.Border, 1)

            return {
                frame = frame,
                setColor = function(_, c)
                    colorPreview.BackgroundColor3 = c
                    callback(c)
                end,
            }
        end

        return Tab
    end

    -- ─── Window Methods ────────────────────────────────
    function Window:SetTitle(newTitle)
        titleLabel.Text = newTitle
    end

    function Window:Show()
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        tween(mainFrame, {Size = UDim2.new(0, guiWidth, 0, guiHeight)}, 0.4, Enum.EasingStyle.Back)
    end

    function Window:Hide()
        tween(mainFrame, {Size = UDim2.new(0, guiWidth, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        task.wait(0.35)
        mainFrame.Visible = false
        mainFrame.Size = UDim2.new(0, guiWidth, 0, guiHeight)
    end

    function Window:Destroy()
        screenGui:Destroy()
    end

    function Window:Notify(cfg)
        cfg = cfg or {}
        local text = cfg.Text or "Notification"
        local duration = cfg.Duration or 3

        local notif = create("Frame", {
            Size = UDim2.new(0, math.floor(220 * scale), 0, math.floor(36 * scale)),
            Position = UDim2.new(1, -math.floor(10 * scale), 1, -math.floor(10 * scale)),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = Theme.Card,
            BorderSizePixel = 0,
            Parent = screenGui,
        })
        corner(notif, Theme.CornerSmall)
        stroke(notif, Theme.Border, 1)

        create("TextLabel", {
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = fontSizeS,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = notif,
        })

        -- Animate in
        notif.Position = UDim2.new(1, math.floor(230 * scale), 1, -math.floor(10 * scale))
        tween(notif, {Position = UDim2.new(1, -math.floor(10 * scale), 1, -math.floor(10 * scale))}, 0.35, Enum.EasingStyle.Back)

        task.delay(duration, function()
            tween(notif, {Position = UDim2.new(1, math.floor(230 * scale), 1, -math.floor(10 * scale))}, 0.3)
            task.wait(0.35)
            notif:Destroy()
        end)
    end

    return Window
end

return APTX
