-- Enhanced Adonis Except GUI Library
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local AE = {}

-- Utility Functions
local function hexToRGB(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
end

local function createInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- Configuration
AE.config = {
    title = "Adonis Except",
    colors = {
        background = "#1E1E1E", -- Gris oscuro
        accent = "#333333",     -- Gris
        text = "#FFFFFF",       -- Blanco
        border = "#000000",     -- Negro
        success = "#33FF33",    -- Verde
        danger = "#FF3333",     -- Rojo
        neutral = "#999999",    -- Gris neutral
        secondary = "#2D2D2D",  -- Gris secundario
        highlight = "#555555",  -- Gris destacado
        tech = "#FF3333"        -- Rojo tecnológico
    },
    borderRadius = UDim.new(0, 8),
    animationSpeed = 0.2,
    letterAnimSpeed = 0.05,
    font = Enum.Font.SourceSans,
    textSize = 14,
    iconSize = UDim2.new(0, 20, 0, 20),
    toggleKey = Enum.KeyCode.RightShift,
    mobileScale = 0.8,
    guiSize = UDim2.new(0, 550, 0, 350), -- Nuevo tamaño del GUI (más pequeño)
    notificationSound = nil, -- Sonido para las notificaciones (puede ser un SoundId)
    techDecoration = "rbxassetid://1316045217" -- Textura de decoración tecnológica
}

-- Convert HEX colors to RGB colors
for key, hex in pairs(AE.config.colors) do
    AE.config[key .. "Color"] = hexToRGB(hex)
end

-- Variables
local screenGui, mainFrame, toggleButton
local isGuiVisible = true
local notifications = {}
local elements = {}
local activeTooltip
local currentSection

-- Enhanced Animation System
local AnimationSystem = {
    tweens = {},
    new = function(self, object, properties, duration, style, direction)
        local tween = TweenService:Create(object, TweenInfo.new(duration or AE.config.animationSpeed, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), properties)
        table.insert(self.tweens, tween)
        return tween
    end,
    playSequence = function(self, sequence)
        for _, anim in ipairs(sequence) do
            local tween = self:new(table.unpack(anim))
            tween:Play()
            tween.Completed:Wait()
        end
    end
}

-- Enhanced Loading Animation
function AE:showLoadingAnimation()
    local loadingGui = createInstance("ScreenGui", {Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")})

    -- Barra central (del mismo ancho que el GUI y con bordes redondos)
    local bar = createInstance("Frame", {
        Size = UDim2.new(0, AE.config.guiSize.X.Offset, 0, 20), -- Barra más alta (20 píxeles)
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.config.accentColor, -- Color de la barra
        Parent = loadingGui
    })
    createInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = bar}) -- Bordes redondos

    -- Texto animado dentro de la barra
    local textLabel = createInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = self.config.textColor,
        TextSize = 24,
        Font = Enum.Font.SourceSansBold,
        Parent = bar
    })

    -- Animación del texto
    local fullText = "Adonis Except Library"
    for i = 1, #fullText do
        textLabel.Text = fullText:sub(1, i)
        wait(self.config.letterAnimSpeed)
    end

    -- Esperar un momento antes de extender la barra
    wait(0.5)

    -- Extender la barra hacia arriba y abajo
    AnimationSystem:new(bar, {Size = AE.config.guiSize}, 1):Play() -- Extender a tamaño completo del GUI
    wait(1) -- Esperar a que termine la animación

    -- Eliminar la GUI de carga
    loadingGui:Destroy()
end

-- Sistema de instancia única
local function ensureSingleInstance()
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local existingGui = playerGui:FindFirstChild("AdonisExceptGUI")
    if existingGui then
        existingGui:Destroy() -- Eliminar el GUI anterior si existe
    end
end

-- Crear el GUI automáticamente
function AE:init()
    ensureSingleInstance() -- Asegurar que no haya GUIs duplicados

    self:showLoadingAnimation()

    screenGui = createInstance("ScreenGui", {
        Name = "AdonisExceptGUI",
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    })
    mainFrame = createInstance("Frame", {
        Size = AE.config.guiSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.config.backgroundColor,
        BorderSizePixel = 1, -- Borde de 1px
        BorderColor3 = self.config.borderColor, -- Color del borde
        ClipsDescendants = true,
        Parent = screenGui
    })
    createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = mainFrame})

    -- Sombra para el marco principal
    local shadow = createInstance("ImageLabel", {
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = AE.config.techDecoration, -- Textura de decoración tecnológica
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Parent = mainFrame
    })

    -- Top bar para mover el GUI
    local topBar = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.config.secondaryColor,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    createInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = topBar})

    -- Título en la top bar
    local title = createInstance("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        Text = self.config.title,
        TextColor3 = self.config.textColor,
        TextSize = 18,
        Font = Enum.Font.SourceSansBold,
        BackgroundTransparency = 1,
        Parent = topBar
    })

    -- Botón de cerrar en la top bar
    local closeButton = createInstance("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0.5, -15),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = "×",
        TextColor3 = self.config.textColor,
        TextSize = 20,
        Font = Enum.Font.SourceSansBold,
        BackgroundTransparency = 1,
        Parent = topBar
    })

    closeButton.MouseButton1Click:Connect(function()
        isGuiVisible = false
        mainFrame.Visible = false
        if toggleButton then
            toggleButton.Text = "Show GUI"
        end
    end)

    -- Función para mover el GUI
    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    -- Secciones (lado izquierdo)
    local sectionsFrame = createInstance("Frame", {
        Size = UDim2.new(0, 150, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = self.config.secondaryColor,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    createInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = sectionsFrame})

    -- Barra de separación
    local separator = createInstance("Frame", {
        Size = UDim2.new(0, 2, 1, -40),
        Position = UDim2.new(0, 150, 0, 40),
        BackgroundColor3 = self.config.borderColor,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    -- Contenido (lado derecho)
    local contentFrame = createInstance("ScrollingFrame", {
        Size = UDim2.new(1, -152, 1, -40),
        Position = UDim2.new(0, 152, 0, 40),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.config.accentColor,
        Parent = mainFrame
    })
    createInstance("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = contentFrame})

    -- Variables para las secciones
    local sections = {}
    local currentSection

    -- Función para crear una sección
    function AE:section(name)
        local sectionButton = createInstance("TextButton", {
            Size = UDim2.new(1, -10, 0, 40),
            Position = UDim2.new(0, 5, 0, #sections * 45),
            BackgroundColor3 = self.config.accentColor,
            Text = name,
            TextColor3 = self.config.textColor,
            TextSize = self.config.textSize,
            Font = self.config.font,
            Parent = sectionsFrame
        })
        createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = sectionButton})

        local sectionContent = createInstance("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = contentFrame
        })
        createInstance("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sectionContent})

        sectionButton.MouseButton1Click:Connect(function()
            if currentSection then
                currentSection.Visible = false
            end
            sectionContent.Visible = true
            currentSection = sectionContent
        end)

        table.insert(sections, sectionContent)
        return sectionContent
    end

    -- Buscador con lupa
    local searchButton = createInstance("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 5),
        BackgroundTransparency = 1,
        Text = "🔍",
        TextColor3 = self.config.textColor,
        TextSize = 20,
        Font = Enum.Font.SourceSansBold,
        Parent = topBar
    })

    local searchBar = createInstance("TextBox", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = self.config.secondaryColor,
        TextColor3 = self.config.textColor,
        TextSize = self.config.textSize,
        Font = self.config.font,
        PlaceholderText = "Buscar...",
        Visible = false,
        Parent = mainFrame
    })
    createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = searchBar})

    searchButton.MouseButton1Click:Connect(function()
        searchBar.Visible = not searchBar.Visible
        if searchBar.Visible then
            searchBar:CaptureFocus()
        end
    end)

    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBar.Text:lower()
        if currentSection then
            for _, element in pairs(currentSection:GetChildren()) do
                if element:IsA("TextButton") or element:IsA("TextLabel") then
                    element.Visible = element.Text:lower():find(searchText) ~= nil
                end
            end
        end
    end)

    -- Cargar la primera sección por defecto
    if #sections > 0 then
        sections[1].Visible = true
        currentSection = sections[1]
    end

    -- Toggle Button (cuadrado con bordes redondos y gris oscuro)
    self:toggleButton("gray", "Toggle GUI", true)
    self:toggleKey(self.config.toggleKey)
end

-- Enhanced Button
function AE:button(section, text, callback, options)
    options = options or {}
    local button = createInstance("TextButton", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = self.config.accentColor,
        Text = text,
        TextColor3 = self.config.textColor,
        TextSize = self.config.textSize,
        Font = self.config.font,
        Parent = section,
        ClipsDescendants = true
    })
    createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = button})

    button.MouseEnter:Connect(function()
        AnimationSystem:new(button, {BackgroundColor3 = self.config.highlightColor}, 0.2):Play()
    end)
    button.MouseLeave:Connect(function()
        AnimationSystem:new(button, {BackgroundColor3 = self.config.accentColor}, 0.2):Play()
    end)

    button.MouseButton1Click:Connect(function()
        if typeof(callback) == "function" then
            callback()
        end
    end)

    -- Función para editar el botón
    function button:edit(newText, newCallback)
        self.Text = newText or self.Text
        if newCallback then
            self.MouseButton1Click:Connect(newCallback)
        end
    end

    return button
end

-- Enhanced Slider
function AE:slider(section, options)
    options = options or {}
    local min, max, default, callback = options.min or 0, options.max or 100, options.default or min, options.callback or function() end
    local sliderFrame = createInstance("Frame", {Size = UDim2.new(1, -20, 0, 50), BackgroundTransparency = 1, Parent = section})
    local title = createInstance("TextLabel", {Size = UDim2.new(1, 0, 0, 20), Text = options.title or "Slider", TextColor3 = self.config.textColor, TextSize = self.config.textSize, Font = self.config.font, BackgroundTransparency = 1, Parent = sliderFrame})
    local sliderBar = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = self.config.borderColor, BorderSizePixel = 0, Parent = sliderFrame})
    createInstance("UICorner", {CornerRadius = UDim.new(0, 2), Parent = sliderBar})
    local sliderFill = createInstance("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = self.config.accentColor, BorderSizePixel = 0, Parent = sliderBar})
    createInstance("UICorner", {CornerRadius = UDim.new(0, 2), Parent = sliderFill})
    local sliderButton = createInstance("TextButton", {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, -8, 0.5, -8), BackgroundColor3 = self.config.accentColor, Text = "", Parent = sliderBar})
    createInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderButton})
    local valueLabel = createInstance("TextLabel", {Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(1, -50, 0, 0), Text = tostring(default), TextColor3 = self.config.textColor, TextSize = self.config.textSize, Font = self.config.font, BackgroundTransparency = 1, Parent = sliderFrame})

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        AnimationSystem:new(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1):Play()
        AnimationSystem:new(sliderButton, {Position = UDim2.new(pos, -8, 0.5, -8)}, 0.1):Play()
        local value = math.floor(min + (max - min) * pos)
        valueLabel.Text = tostring(value)
        callback(value)
    end

    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    local initialPos = (default - min) / (max - min)
    sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
    sliderButton.Position = UDim2.new(initialPos, -8, 0.5, -8)

    -- Función para editar el slider
    function sliderFrame:edit(newOptions)
        if newOptions.min then min = newOptions.min end
        if newOptions.max then max = newOptions.max end
        if newOptions.default then
            default = newOptions.default
            local pos = (default - min) / (max - min)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            sliderButton.Position = UDim2.new(pos, -8, 0.5, -8)
            valueLabel.Text = tostring(default)
        end
        if newOptions.callback then callback = newOptions.callback end
    end

    return sliderFrame
end

-- Enhanced Dropdown (corregido)
function AE:dropdown(section, options)
    options = options or {}
    local items, callback, default = options.items or {}, options.callback or function() end, options.default or items[1]
    local dropdownFrame = createInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = self.config.secondaryColor,
        Parent = section
    })
    createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = dropdownFrame})
    local selectedLabel = createInstance("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = default or "Select...",
        TextColor3 = self.config.textColor,
        TextSize = self.config.textSize,
        Font = self.config.font,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropdownFrame
    })
    local arrow = createInstance("TextLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        Text = "▼",
        TextColor3 = self.config.textColor,
        TextSize = 14,
        Font = self.config.font,
        BackgroundTransparency = 1,
        Parent = dropdownFrame
    })
    local optionsFrame = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, #items * 30),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = self.config.secondaryColor,
        Visible = false,
        ZIndex = 2,
        Parent = dropdownFrame
    })
    createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = optionsFrame})

    for i, item in ipairs(items) do
        local option = createInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, (i-1) * 30),
            BackgroundColor3 = self.config.secondaryColor,
            Text = item,
            TextColor3 = self.config.textColor,
            TextSize = self.config.textSize,
            Font = self.config.font,
            ZIndex = 2,
            Parent = optionsFrame
        })
        createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = option})
        option.MouseEnter:Connect(function()
            AnimationSystem:new(option, {BackgroundColor3 = self.config.highlightColor}, 0.2):Play()
        end)
        option.MouseLeave:Connect(function()
            AnimationSystem:new(option, {BackgroundColor3 = self.config.secondaryColor}, 0.2):Play()
        end)
        option.MouseButton1Click:Connect(function()
            selectedLabel.Text = item
            optionsFrame.Visible = false
            arrow.Text = "▼"
            callback(item)
        end)
    end

    local isOpen = false
    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isOpen = not isOpen
            optionsFrame.Visible = isOpen
            arrow.Text = isOpen and "▲" or "▼"
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local position = input.Position
            local inDropdown = position.X >= dropdownFrame.AbsolutePosition.X and position.X <= dropdownFrame.AbsolutePosition.X + dropdownFrame.AbsoluteSize.X and position.Y >= dropdownFrame.AbsolutePosition.Y and position.Y <= dropdownFrame.AbsolutePosition.Y + dropdownFrame.AbsoluteSize.Y
            if not inDropdown and isOpen then
                isOpen = false
                optionsFrame.Visible = false
                arrow.Text = "▼"
            end
        end
    end)

    -- Función para editar el dropdown
    function dropdownFrame:edit(newOptions)
        if newOptions.items then
            items = newOptions.items
            for i, option in ipairs(optionsFrame:GetChildren()) do
                if option:IsA("TextButton") then
                    option:Destroy()
                end
            end
            for i, item in ipairs(items) do
                local option = createInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    Position = UDim2.new(0, 0, 0, (i-1) * 30),
                    BackgroundColor3 = self.config.secondaryColor,
                    Text = item,
                    TextColor3 = self.config.textColor,
                    TextSize = self.config.textSize,
                    Font = self.config.font,
                    ZIndex = 2,
                    Parent = optionsFrame
                })
                createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = option})
                option.MouseEnter:Connect(function()
                    AnimationSystem:new(option, {BackgroundColor3 = self.config.highlightColor}, 0.2):Play()
                end)
                option.MouseLeave:Connect(function()
                    AnimationSystem:new(option, {BackgroundColor3 = self.config.secondaryColor}, 0.2):Play()
                end)
                option.MouseButton1Click:Connect(function()
                    selectedLabel.Text = item
                    optionsFrame.Visible = false
                    arrow.Text = "▼"
                    callback(item)
                end)
            end
        end
        if newOptions.default then
            selectedLabel.Text = newOptions.default
        end
        if newOptions.callback then
            callback = newOptions.callback
        end
    end

    return dropdownFrame
end

-- Enhanced Input
function AE:input(section, placeholder, callback)
    local inputFrame = createInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = self.config.secondaryColor,
        Parent = section
    })
    createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = inputFrame})

    local textBox = createInstance("TextBox", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        TextColor3 = self.config.textColor,
        TextSize = self.config.textSize,
        Font = self.config.font,
        PlaceholderText = placeholder or "Ingrese texto...",
        Parent = inputFrame
    })

    textBox.FocusLost:Connect(function()
        if typeof(callback) == "function" then
            callback(textBox.Text)
        end
    end)

    return textBox
end

-- Enhanced Notification System
function AE:notify(type, duration, title, description, sound)
    if sound then
        local notificationSound = Instance.new("Sound")
        notificationSound.SoundId = sound
        notificationSound.Parent = SoundService
        notificationSound:Play()
        notificationSound.Ended:Connect(function()
            notificationSound:Destroy()
        end)
    end

    local notifyFrame = createInstance("Frame", {
        Size = UDim2.new(0, 250, 0, 80),
        Position = UDim2.new(1, 0, 1, -90),
        BackgroundColor3 = self.config.backgroundColor,
        BorderSizePixel = 0,
        Parent = screenGui
    })
    createInstance("UIStroke", {Color = self.config[type .. "Color"] or self.config.neutralColor, Thickness = 2, Parent = notifyFrame})
    createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = notifyFrame})
    local titleLabel = createInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        Text = title,
        TextColor3 = self.config[type .. "Color"] or self.config.neutralColor,
        TextSize = self.config.textSize + 2,
        Font = Enum.Font.SourceSansBold,
        BackgroundTransparency = 1,
        Parent = notifyFrame
    })
    local descriptionLabel = createInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 35),
        Text = description or "",
        TextColor3 = self.config.textColor,
        TextSize = self.config.textSize,
        Font = self.config.font,
        BackgroundTransparency = 1,
        TextWrapped = true,
        Parent = notifyFrame
    })
    local progressBar = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = self.config[type .. "Color"] or self.config.neutralColor,
        BorderSizePixel = 0,
        Parent = notifyFrame
    })

    table.insert(notifications, notifyFrame)
    AnimationSystem:new(notifyFrame, {Position = UDim2.new(1, -260, 1, -90 - (#notifications - 1) * 90)}, 0.3):Play()
    AnimationSystem:new(progressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration):Play()

    task.delay(duration, function()
        local index = table.find(notifications, notifyFrame)
        if index then
            table.remove(notifications, index)
            local slideOut = AnimationSystem:new(notifyFrame, {Position = UDim2.new(1, 0, notifyFrame.Position.Y.Scale, notifyFrame.Position.Y.Offset)}, 0.3)
            slideOut:Play()
            slideOut.Completed:Wait()
            notifyFrame:Destroy()
            for i, notification in ipairs(notifications) do
                AnimationSystem:new(notification, {Position = UDim2.new(1, -260, 1, -90 - (i - 1) * 90)}, 0.3):Play()
            end
        end
    end)
end

-- Toggle Button (cuadrado con bordes redondos y gris oscuro)
function AE:toggleButton(color, text, drag)
    local colors = {gray = Color3.fromRGB(50, 50, 50)} -- Gris oscuro
    toggleButton = createInstance("TextButton", {
        Size = UDim2.new(0, 100, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = colors[color] or colors.gray,
        Text = text or "Toggle GUI",
        TextColor3 = self.config.textColor,
        TextSize = self.config.textSize,
        Font = self.config.font,
        Parent = screenGui
    })
    createInstance("UICorner", {CornerRadius = self.config.borderRadius, Parent = toggleButton})

    if drag then
        local dragInput, dragStart, startPos
        toggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragStart = input.Position
                startPos = toggleButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragStart = nil
                    end
                end)
            end
        end)
        toggleButton.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStart then
                local delta = input.Position - dragStart
                toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    toggleButton.MouseButton1Click:Connect(function()
        isGuiVisible = not isGuiVisible
        mainFrame.Visible = isGuiVisible
        toggleButton.Text = isGuiVisible and "Hide GUI" or "Show GUI"
    end)
end

-- Toggle Key
function AE:toggleKey(key)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == (key or self.config.toggleKey) then
            isGuiVisible = not isGuiVisible
            mainFrame.Visible = isGuiVisible
            if toggleButton then
                toggleButton.Text = isGuiVisible and "Hide GUI" or "Show GUI"
            end
        end
    end)
end

-- Inicializar el GUI automáticamente
AE:init()

return AE
