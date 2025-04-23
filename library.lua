local AE = {}
local internal = {}
internal.sections = {}
internal.currentSection = nil
internal.firstSection = nil

function AE:Start(title, size, dragg)
    size = size or 1
    dragg = dragg or false
    
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local LeftPanel = Instance.new("Frame")
    local RightPanel = Instance.new("Frame")
    local Divider = Instance.new("Frame")
    local LeftContent = Instance.new("Frame")
    local LeftLayout = Instance.new("UIListLayout")
    local RightContent = Instance.new("Frame")
    local RightLayout = Instance.new("UIListLayout")

    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Position = UDim2.new(0.15, 0, 0.1, 0)
    MainFrame.Size = UDim2.new(0.7 * size, 0, 0.85 * size, 0)
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0.08, 0)
    MainCorner.Parent = MainFrame

    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.ZIndex = 2

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0.08, 0)
    TopBarCorner.Parent = TopBar

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title or "ADONIS EXCEPT"
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextSize = 18
    Title.ZIndex = 3

    LeftPanel.Name = "LeftPanel"
    LeftPanel.Parent = MainFrame
    LeftPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    LeftPanel.BorderSizePixel = 0
    LeftPanel.Position = UDim2.new(0, 0, 0, TopBar.Size.Y.Offset)
    LeftPanel.Size = UDim2.new(0.25, -2, 1, -TopBar.Size.Y.Offset)

    LeftContent.Name = "LeftContent"
    LeftContent.Parent = LeftPanel
    LeftContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    LeftContent.BackgroundTransparency = 1
    LeftContent.Size = UDim2.new(1, 0, 1, 0)

    LeftLayout.Name = "LeftLayout"
    LeftLayout.Parent = LeftContent
    LeftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.Padding = UDim.new(0, 5)

    Divider.Name = "Divider"
    Divider.Parent = MainFrame
    Divider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Divider.BorderSizePixel = 0
    Divider.Position = UDim2.new(0.25, 0, 0, TopBar.Size.Y.Offset)
    Divider.Size = UDim2.new(0, 3, 1, -TopBar.Size.Y.Offset)

    RightPanel.Name = "RightPanel"
    RightPanel.Parent = MainFrame
    RightPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    RightPanel.BorderSizePixel = 0
    RightPanel.Position = UDim2.new(0.25, 3, 0, TopBar.Size.Y.Offset)
    RightPanel.Size = UDim2.new(0.75, -3, 1, -TopBar.Size.Y.Offset)

    RightContent.Name = "RightContent"
    RightContent.Parent = RightPanel
    RightContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    RightContent.BackgroundTransparency = 1
    RightContent.Size = UDim2.new(1, 0, 1, 0)

    RightLayout.Name = "RightLayout"
    RightLayout.Parent = RightContent
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Padding = UDim.new(0, 5)

    local LeftCorner = Instance.new("UICorner")
    LeftCorner.CornerRadius = UDim.new(0, 8)
    LeftCorner.Parent = LeftPanel

    local RightCorner = Instance.new("UICorner")
    RightCorner.CornerRadius = UDim.new(0, 8)
    RightCorner.Parent = RightPanel

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = MainFrame
    Shadow.BackgroundTransparency = 1
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.85
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.ZIndex = -1

    if dragg then
        local UserInputService = game:GetService("UserInputService")
        local dragging
        local dragInput
        local dragStart
        local startPos

        local function update(input)
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        TopBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    internal.LeftContent = LeftContent
    internal.RightContent = RightContent
    internal.MainFrame = MainFrame
    internal.ScreenGui = ScreenGui
    
    return self
end

function AE:Section(sectionName)
    local sectionFrame = Instance.new("TextButton")
    local sectionTitle = Instance.new("TextLabel")
    local sectionCorner = Instance.new("UICorner")
    local sectionStroke = Instance.new("UIStroke")
    local activeIndicator = Instance.new("Frame")
    local indicatorCorner = Instance.new("UICorner")
    
    sectionFrame.Name = sectionName.."Section"
    sectionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    sectionFrame.Size = UDim2.new(0.9, 0, 0, 35)
    sectionFrame.AutoButtonColor = false
    sectionFrame.LayoutOrder = #internal.LeftContent:GetChildren()
    sectionFrame.Text = ""
    
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = sectionFrame
    
    sectionStroke.Color = Color3.fromRGB(60, 60, 60)
    sectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    sectionStroke.Parent = sectionFrame
    
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Parent = sectionFrame
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Size = UDim2.new(1, 0, 1, 0)
    sectionTitle.Font = Enum.Font.GothamMedium
    sectionTitle.Text = "    "..string.upper(sectionName)
    sectionTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    sectionTitle.TextSize = 14
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    activeIndicator.Name = "ActiveIndicator"
    activeIndicator.Parent = sectionFrame
    activeIndicator.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    activeIndicator.Size = UDim2.new(0.05, 0, 0.7, 0)
    activeIndicator.Position = UDim2.new(0.025, 0, 0.15, 0)
    activeIndicator.Visible = false
    
    indicatorCorner.CornerRadius = UDim.new(0, 4)
    indicatorCorner.Parent = activeIndicator
    
    internal.sections[sectionName] = {
        frame = sectionFrame,
        elements = {},
        indicator = activeIndicator
    }

    local section = {
        Name = sectionName,
        Frame = sectionFrame
    }
    
    sectionFrame.MouseButton1Click:Connect(function()
        internal.selectSection(sectionName)
    end)
    
    sectionFrame.Parent = internal.LeftContent
    
    -- Si es la primera sección, la guardamos para seleccionarla después
    if internal.firstSection == nil then
        internal.firstSection = sectionName
    end
    
    return section
end

-- Función interna para seleccionar una sección
function internal.selectSection(sectionName)
    for name, section in pairs(internal.sections) do
        section.frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        section.frame:FindFirstChild("SectionTitle").TextColor3 = Color3.fromRGB(180, 180, 180)
        section.indicator.Visible = false
    end
    
    internal.sections[sectionName].frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    internal.sections[sectionName].frame:FindFirstChild("SectionTitle").TextColor3 = Color3.fromRGB(220, 220, 220)
    internal.sections[sectionName].indicator.Visible = true
    
    -- Limpiar el panel derecho
    for _, child in ipairs(internal.RightContent:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    
    -- Añadir los elementos de la sección seleccionada
    for _, elementData in ipairs(internal.sections[sectionName].elements) do
        local element = elementData.create()
        element.Parent = internal.RightContent
    end
    
    internal.currentSection = sectionName
end

function AE:button(buttonText, section, callback)
    if internal.sections[section.Name] then
        local buttonData = {
            type = "button",
            text = buttonText,
            callback = callback or function() end,
            create = function()
                local button = Instance.new("TextButton")
                button.Name = buttonText.."Button"
                button.Text = buttonText
                button.Size = UDim2.new(0.95, 0, 0, 35)
                button.Position = UDim2.new(0.025, 0, 0, 0)
                button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                button.TextColor3 = Color3.fromRGB(200, 200, 200)
                button.Font = Enum.Font.Gotham
                button.TextSize = 14
                button.AutoButtonColor = true
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 4)
                buttonCorner.Parent = button
                
                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.Color = Color3.fromRGB(80, 80, 80)
                buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                buttonStroke.Parent = button
                
                button.MouseButton1Click:Connect(callback or function() end)
                
                return button
            end
        }
        
        table.insert(internal.sections[section.Name].elements, buttonData)
        
        -- Si esta sección es la actual, crear y mostrar el botón ahora
        if internal.currentSection == section.Name then
            local button = buttonData.create()
            button.Parent = internal.RightContent
        end
    end
end

function AE:Menu(title, section, options, defaultOption)
    if internal.sections[section.Name] then
        local menuData = {
            type = "menu",
            title = title,
            options = options or {},
            selected = defaultOption or (options and options[1] or ""),
            create = function()
                local menuContainer = Instance.new("Frame")
                menuContainer.Name = title.."Menu"
                menuContainer.Size = UDim2.new(0.95, 0, 0, 70)
                menuContainer.Position = UDim2.new(0.025, 0, 0, 0)
                menuContainer.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                
                local menuCorner = Instance.new("UICorner")
                menuCorner.CornerRadius = UDim.new(0, 4)
                menuCorner.Parent = menuContainer
                
                local menuStroke = Instance.new("UIStroke")
                menuStroke.Color = Color3.fromRGB(80, 80, 80)
                menuStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                menuStroke.Parent = menuContainer
                
                local menuTitle = Instance.new("TextLabel")
                menuTitle.Name = "MenuTitle"
                menuTitle.Parent = menuContainer
                menuTitle.BackgroundTransparency = 1
                menuTitle.Size = UDim2.new(1, 0, 0, 25)
                menuTitle.Font = Enum.Font.GothamMedium
                menuTitle.Text = title
                menuTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                menuTitle.TextSize = 14
                
                local optionsContainer = Instance.new("Frame")
                optionsContainer.Name = "OptionsContainer"
                optionsContainer.Parent = menuContainer
                optionsContainer.BackgroundTransparency = 1
                optionsContainer.Position = UDim2.new(0, 0, 0, 25)
                optionsContainer.Size = UDim2.new(1, 0, 0, 35)
                
                local optionsLayout = Instance.new("UIListLayout")
                optionsLayout.Parent = optionsContainer
                optionsLayout.FillDirection = Enum.FillDirection.Horizontal
                optionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                optionsLayout.Padding = UDim.new(0, 5)
                
                local selectedOption = defaultOption or (options and options[1] or "")
                
                for i, option in ipairs(options or {}) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option.."Option"
                    optionButton.Parent = optionsContainer
                    optionButton.Size = UDim2.new(1/#options, -5, 1, -10)
                    optionButton.Text = option
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextSize = 12
                    
                    if option == selectedOption then
                        optionButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        optionButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                        optionButton.TextColor3 = Color3.fromRGB(180, 180, 180)
                    end
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionButton
                    
                    optionButton.MouseButton1Click:Connect(function()
                        for _, child in ipairs(optionsContainer:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                                child.TextColor3 = Color3.fromRGB(180, 180, 180)
                            end
                        end
                        
                        optionButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        
                        menuData.selected = option
                        
                        -- Llamar al callback con la opción seleccionada si existe
                        if menuData.callback then
                            menuData.callback(option)
                        end
                    end)
                end
                
                return menuContainer
            end,
            setCallback = function(callback)
                menuData.callback = callback
            end
        }
        
        table.insert(internal.sections[section.Name].elements, menuData)
        
        -- Si esta sección es la actual, crear y mostrar el menú ahora
        if internal.currentSection == section.Name then
            local menu = menuData.create()
            menu.Parent = internal.RightContent
        end
        
        -- Retornar una interfaz para configurar el callback después
        return {
            setCallback = menuData.setCallback
        }
    end
end

-- Un task.defer para seleccionar la primera sección después de la creación
task.defer(function()
    if internal.firstSection then
        internal.selectSection(internal.firstSection)
    end
end)

return AE