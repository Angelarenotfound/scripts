local AE = {}
local internal = {}
internal.sections = {}
internal.currentSection = nil
internal.firstSection = nil
local initialized = false

function internal.selectSection(sectionName)
    if not internal.sections[sectionName] then
        print("Error: Sección '"..sectionName.."' no encontrada")
        return
    end
    
    for name, section in pairs(internal.sections) do
        section.frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        section.frame:FindFirstChild("SectionTitle").TextColor3 = Color3.fromRGB(180, 180, 180)
        section.indicator.Visible = false
    end

    internal.sections[sectionName].frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    internal.sections[sectionName].frame:FindFirstChild("SectionTitle").TextColor3 = Color3.fromRGB(220, 220, 220)
    internal.sections[sectionName].indicator.Visible = true

    for _, child in ipairs(internal.RightContent:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end

    for _, elementData in ipairs(internal.sections[sectionName].elements) do
        local element = elementData.create()
        element.Parent = internal.RightContent
    end

    internal.currentSection = sectionName
end

function AE:Start(title, size, dragg, background)
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

    if background then
        local BackgroundImage = Instance.new("ImageLabel")
        BackgroundImage.Name = "Background"
        BackgroundImage.Parent = MainFrame
        BackgroundImage.BackgroundTransparency = 1
        BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
        BackgroundImage.Image = background
        BackgroundImage.ScaleType = Enum.ScaleType.Stretch
        BackgroundImage.ZIndex = 0
    end

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

    local LeftScroll = Instance.new("ScrollingFrame")
    LeftScroll.Name = "LeftScroll"
    LeftScroll.Parent = LeftContent
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.Size = UDim2.new(1, 0, 1, 0)
    LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftScroll.ScrollBarThickness = 4
    LeftScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    LeftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    LeftScroll.BorderSizePixel = 0

    LeftLayout.Name = "LeftLayout"
    LeftLayout.Parent = LeftScroll
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

    local RightScroll = Instance.new("ScrollingFrame")
    RightScroll.Name = "RightScroll"
    RightScroll.Parent = RightContent
    RightScroll.BackgroundTransparency = 1
    RightScroll.Size = UDim2.new(1, 0, 1, 0)
    RightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    RightScroll.ScrollBarThickness = 4
    RightScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    RightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    RightScroll.BorderSizePixel = 0

    RightLayout.Name = "RightLayout"
    RightLayout.Parent = RightScroll
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

    internal.LeftContent = LeftScroll
    internal.RightContent = RightScroll
    internal.MainFrame = MainFrame
    internal.ScreenGui = ScreenGui

    task.delay(0.1, function()
        if internal.firstSection and not initialized then
            initialized = true
            internal.selectSection(internal.firstSection)
        end
    end)
    
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
    activeIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
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

    if internal.firstSection == nil then
        internal.firstSection = sectionName
    end

    return section
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
                button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                button.TextColor3 = Color3.fromRGB(200, 200, 200)
                button.Font = Enum.Font.Gotham
                button.TextSize = 14
                button.AutoButtonColor = true

                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 4)
                buttonCorner.Parent = button

                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.Color = Color3.fromRGB(40, 40, 40)
                buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                buttonStroke.Parent = button

                button.MouseButton1Click:Connect(callback or function() end)

                return button
            end
        }

        table.insert(internal.sections[section.Name].elements, buttonData)

        if internal.currentSection == section.Name then
            local button = buttonData.create()
            button.Parent = internal.RightContent
        end
    end
end

function AE:Menu(title, section, options, defaultOption)
    if internal.sections[section.Name] then
        options = options or {}
        defaultOption = defaultOption or (options[1] or "")
        
        local menuData = {
            type = "menu",
            title = title,
            options = options,
            selected = defaultOption,
            callback = nil,
            create = function()
                local menuContainer = Instance.new("Frame")
                menuContainer.Name = title.."Menu"
                menuContainer.Size = UDim2.new(0.95, 0, 0, 70)
                menuContainer.Position = UDim2.new(0.025, 0, 0, 0)
                menuContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

                local menuCorner = Instance.new("UICorner")
                menuCorner.CornerRadius = UDim.new(0, 4)
                menuCorner.Parent = menuContainer

                local menuStroke = Instance.new("UIStroke")
                menuStroke.Color = Color3.fromRGB(40, 40, 40)
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

                local selectedOption = defaultOption

                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "DropdownButton"
                dropdownButton.Parent = menuContainer
                dropdownButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                dropdownButton.Position = UDim2.new(0.05, 0, 0.45, 0)
                dropdownButton.Size = UDim2.new(0.9, 0, 0, 30)
                dropdownButton.Font = Enum.Font.Gotham
                dropdownButton.Text = selectedOption
                dropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                dropdownButton.TextSize = 14
                dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                dropdownButton.TextTruncate = Enum.TextTruncate.AtEnd

                local dropdownPadding = Instance.new("UIPadding")
                dropdownPadding.Parent = dropdownButton
                dropdownPadding.PaddingLeft = UDim.new(0, 10)

                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 4)
                buttonCorner.Parent = dropdownButton

                local dropdownList = Instance.new("Frame")
                dropdownList.Name = "DropdownList"
                dropdownList.Parent = menuContainer
                dropdownList.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                dropdownList.Position = UDim2.new(0.05, 0, 0.9, 0)
                dropdownList.Size = UDim2.new(0.9, 0, 0, #options * 30)
                dropdownList.Visible = false
                dropdownList.ZIndex = 10
                dropdownList.ClipsDescendants = true

                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, 4)
                listCorner.Parent = dropdownList

                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = dropdownList
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Padding = UDim.new(0, 0)

                for i, option in ipairs(options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option.."Option"
                    optionButton.Parent = dropdownList
                    optionButton.Size = UDim2.new(1, 0, 0, 30)
                    optionButton.Text = option
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextSize = 14
                    optionButton.TextXAlignment = Enum.TextXAlignment.Left
                    optionButton.LayoutOrder = i
                    optionButton.ZIndex = 10

                    local optionPadding = Instance.new("UIPadding")
                    optionPadding.Parent = optionButton
                    optionPadding.PaddingLeft = UDim.new(0, 10)

                    if option == selectedOption then
                        optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        optionButton.TextColor3 = Color3.fromRGB(255, 0, 0)
                    else
                        optionButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                        optionButton.TextColor3 = Color3.fromRGB(180, 180, 180)
                    end

                    optionButton.MouseButton1Click:Connect(function()
                        for _, child in ipairs(dropdownList:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                                child.TextColor3 = Color3.fromRGB(180, 180, 180)
                            end
                        end

                        optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        optionButton.TextColor3 = Color3.fromRGB(255, 0, 0)

                        dropdownButton.Text = option
                        menuData.selected = option
                        dropdownList.Visible = false

                        if menuData.callback then
                            menuData.callback(option)
                        end
                    end)
                end

                local function closeDropdown()
                    dropdownList.Visible = false
                end

                dropdownButton.MouseButton1Click:Connect(function()
                    if dropdownList.Visible then
                        dropdownList.Visible = false
                    else
                        dropdownList.Visible = true
                        local connection
                        connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                local position = input.Position
                                local guiObjects = game.Players.LocalPlayer:GetGuiObjectsAtPosition(position.X, position.Y)
                                local clickedOnMenu = false

                                for _, obj in ipairs(guiObjects) do
                                    if obj == dropdownButton or obj:IsDescendantOf(dropdownList) then
                                        clickedOnMenu = true
                                        break
                                    end
                                end

                                if not clickedOnMenu then
                                    closeDropdown()
                                    connection:Disconnect()
                                end
                            end
                        end)
                    end
                end)

                return menuContainer
            end,
            setCallback = function(callback)
                menuData.callback = callback
            end
        }

        table.insert(internal.sections[section.Name].elements, menuData)

        if internal.currentSection == section.Name then
            local menu = menuData.create()
            menu.Parent = internal.RightContent
        end

        return {
            setCallback = menuData.setCallback
        }
    end
end

function AE:Input(title, section, defaultValue, placeholder, callback)
    if internal.sections[section.Name] then
        local inputData = {
            type = "input",
            title = title,
            value = defaultValue or "",
            create = function()
                local inputContainer = Instance.new("Frame")
                inputContainer.Name = title.."Input"
                inputContainer.Size = UDim2.new(0.95, 0, 0, 70)
                inputContainer.Position = UDim2.new(0.025, 0, 0, 0)
                inputContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

                local inputCorner = Instance.new("UICorner")
                inputCorner.CornerRadius = UDim.new(0, 4)
                inputCorner.Parent = inputContainer

                local inputStroke = Instance.new("UIStroke")
                inputStroke.Color = Color3.fromRGB(40, 40, 40)
                inputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                inputStroke.Parent = inputContainer

                local inputTitle = Instance.new("TextLabel")
                inputTitle.Name = "InputTitle"
                inputTitle.Parent = inputContainer
                inputTitle.BackgroundTransparency = 1
                inputTitle.Size = UDim2.new(1, 0, 0, 25)
                inputTitle.Font = Enum.Font.GothamMedium
                inputTitle.Text = title
                inputTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                inputTitle.TextSize = 14

                local inputBox = Instance.new("TextBox")
                inputBox.Name = "InputBox"
                inputBox.Parent = inputContainer
                inputBox.Position = UDim2.new(0.05, 0, 0.45, 0)
                inputBox.Size = UDim2.new(0.9, 0, 0, 30)
                inputBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                inputBox.Text = defaultValue or ""
                inputBox.PlaceholderText = placeholder or "Enter text..."
                inputBox.Font = Enum.Font.Gotham
                inputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
                inputBox.TextSize = 14
                inputBox.TextXAlignment = Enum.TextXAlignment.Left
                inputBox.ClipsDescendants = true
                inputBox.ClearTextOnFocus = false

                local boxCorner = Instance.new("UICorner")
                boxCorner.CornerRadius = UDim.new(0, 4)
                boxCorner.Parent = inputBox

                local boxPadding = Instance.new("UIPadding")
                boxPadding.Parent = inputBox
                boxPadding.PaddingLeft = UDim.new(0, 10)

                inputBox.FocusLost:Connect(function(enterPressed)
                    inputData.value = inputBox.Text
                    if callback then
                        callback(inputBox.Text, enterPressed)
                    end
                end)

                return inputContainer
            end,
            setCallback = function(newCallback)
                callback = newCallback
            end,
            getValue = function()
                return inputData.value
            end,
            setValue = function(newValue)
                inputData.value = newValue

                if internal.currentSection == section.Name then
                    local inputContainer = internal.RightContent:FindFirstChild(title.."Input")
                    if inputContainer then
                        local inputBox = inputContainer:FindFirstChild("InputBox")
                        if inputBox then
                            inputBox.Text = newValue
                        end
                    end
                end
            end
        }

        table.insert(internal.sections[section.Name].elements, inputData)

        if internal.currentSection == section.Name then
            local input = inputData.create()
            input.Parent = internal.RightContent
        end

        return {
            setCallback = inputData.setCallback,
            getValue = inputData.getValue,
            setValue = inputData.setValue
        }
    end
end

function AE:Slider(title, section, min, max, defaultValue, callback)
    if internal.sections[section.Name] then
        min = min or 0
        max = max or 100
        defaultValue = math.clamp(defaultValue or min, min, max)

        local sliderData = {
            type = "slider",
            title = title,
            min = min,
            max = max,
            value = defaultValue,
            callback = callback,
            create = function()
                local sliderContainer = Instance.new("Frame")
                sliderContainer.Name = title.."Slider"
                sliderContainer.Size = UDim2.new(0.95, 0, 0, 70)
                sliderContainer.Position = UDim2.new(0.025, 0, 0, 0)
                sliderContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 4)
                sliderCorner.Parent = sliderContainer

                local sliderStroke = Instance.new("UIStroke")
                sliderStroke.Color = Color3.fromRGB(40, 40, 40)
                sliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                sliderStroke.Parent = sliderContainer

                local sliderTitle = Instance.new("TextLabel")
                sliderTitle.Name = "SliderTitle"
                sliderTitle.Parent = sliderContainer
                sliderTitle.BackgroundTransparency = 1
                sliderTitle.Size = UDim2.new(0.7, 0, 0, 25)
                sliderTitle.Font = Enum.Font.GothamMedium
                sliderTitle.Text = title
                sliderTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                sliderTitle.TextSize = 14
                sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                sliderTitle.Position = UDim2.new(0.05, 0, 0, 0)

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Name = "ValueLabel"
                valueLabel.Parent = sliderContainer
                valueLabel.BackgroundTransparency = 1
                valueLabel.Size = UDim2.new(0.2, 0, 0, 25)
                valueLabel.Position = UDim2.new(0.75, 0, 0, 0)
                valueLabel.Font = Enum.Font.GothamMedium
                valueLabel.Text = tostring(sliderData.value)
                valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                valueLabel.TextSize = 14
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right

                local sliderTrack = Instance.new("Frame")
                sliderTrack.Name = "SliderTrack"
                sliderTrack.Parent = sliderContainer
                sliderTrack.Position = UDim2.new(0.05, 0, 0.6, 0)
                sliderTrack.Size = UDim2.new(0.9, 0, 0, 6)
                sliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(0, 3)
                trackCorner.Parent = sliderTrack

                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "SliderFill"
                sliderFill.Parent = sliderTrack
                sliderFill.Position = UDim2.new(0, 0, 0, 0)
                sliderFill.Size = UDim2.new((sliderData.value - min) / (max - min), 0, 1, 0)
                sliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0, 3)
                fillCorner.Parent = sliderFill

                local sliderThumb = Instance.new("Frame")
                sliderThumb.Name = "SliderThumb"
                sliderThumb.Parent = sliderTrack
                sliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
                sliderThumb.Position = UDim2.new((sliderData.value - min) / (max - min), 0, 0.5, 0)
                sliderThumb.Size = UDim2.new(0, 12, 0, 12)
                sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

                local thumbCorner = Instance.new("UICorner")
                thumbCorner.CornerRadius = UDim.new(1, 0)
                thumbCorner.Parent = sliderThumb

                local dragging = false

                local function updateSlider(input)
                    local trackPos = sliderTrack.AbsolutePosition.X
                    local trackWidth = sliderTrack.AbsoluteSize.X
                    local mousePos = input.Position.X

                    local relativePos = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
                    local newValue = min + (relativePos * (max - min))
                    newValue = math.floor(newValue + 0.5)

                    sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                    sliderThumb.Position = UDim2.new(relativePos, 0, 0.5, 0)
                    valueLabel.Text = tostring(newValue)

                    sliderData.value = newValue

                    if sliderData.callback then
                        sliderData.callback(newValue)
                    end
                end

                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateSlider(input)
                    end
                end)

                sliderTrack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                sliderTrack.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)

                return sliderContainer
            end,
            setCallback = function(newCallback)
                sliderData.callback = newCallback
            end,
            getValue = function()
                return sliderData.value
            end,
            setValue = function(newValue)
                newValue = math.clamp(newValue, min, max)
                sliderData.value = newValue

                if internal.currentSection == section.Name then
                    local sliderContainer = internal.RightContent:FindFirstChild(title.."Slider")
                    if sliderContainer then
                        local valueLabel = sliderContainer:FindFirstChild("ValueLabel")
                        local sliderTrack = sliderContainer:FindFirstChild("SliderTrack")
                        
                        if valueLabel then
                            valueLabel.Text = tostring(newValue)
                        end
                        
                        if sliderTrack then
                            local sliderFill = sliderTrack:FindFirstChild("SliderFill")
                            local sliderThumb = sliderTrack:FindFirstChild("SliderThumb")
                            
                            if sliderFill then
                                sliderFill.Size = UDim2.new((newValue - min) / (max - min), 0, 1, 0)
                            end
                            
                            if sliderThumb then
                                sliderThumb.Position = UDim2.new((newValue - min) / (max - min), 0, 0.5, 0)
                            end
                        end
                    end
                end

                if sliderData.callback then
                    sliderData.callback(newValue)
                end
            end
        }

        table.insert(internal.sections[section.Name].elements, sliderData)

        if internal.currentSection == section.Name then
            local slider = sliderData.create()
            slider.Parent = internal.RightContent
        end

        return {
            setCallback = sliderData.setCallback,
            getValue = sliderData.getValue,
            setValue = sliderData.setValue
        }
    end
end

function AE:Toggle(title, section, defaultValue, callback)
    if internal.sections[section.Name] then
        local toggleData = {
            type = "toggle",
            title = title,
            value = defaultValue or false,
            create = function()
                local toggleContainer = Instance.new("Frame")
                toggleContainer.Name = title.."Toggle"
                toggleContainer.Size = UDim2.new(0.95, 0, 0, 40)
                toggleContainer.Position = UDim2.new(0.025, 0, 0, 0)
                toggleContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 4)
                toggleCorner.Parent = toggleContainer

                local toggleStroke = Instance.new("UIStroke")
                toggleStroke.Color = Color3.fromRGB(40, 40, 40)
                toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                toggleStroke.Parent = toggleContainer

                local toggleTitle = Instance.new("TextLabel")
                toggleTitle.Name = "ToggleTitle"
                toggleTitle.Parent = toggleContainer
                toggleTitle.BackgroundTransparency = 1
                toggleTitle.Size = UDim2.new(0.8, 0, 1, 0)
                toggleTitle.Position = UDim2.new(0.05, 0, 0, 0)
                toggleTitle.Font = Enum.Font.GothamMedium
                toggleTitle.Text = title
                toggleTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                toggleTitle.TextSize = 14
                toggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                local toggleButton = Instance.new("Frame")
                toggleButton.Name = "ToggleButton"
                toggleButton.Parent = toggleContainer
                toggleButton.AnchorPoint = Vector2.new(0, 0.5)
                toggleButton.Position = UDim2.new(0.85, 0, 0.5, 0)
                toggleButton.Size = UDim2.new(0, 36, 0, 20)
                toggleButton.BackgroundColor3 = toggleData.value and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 40, 40)

                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(1, 0)
                buttonCorner.Parent = toggleButton

                local toggleIndicator = Instance.new("Frame")
                toggleIndicator.Name = "ToggleIndicator"
                toggleIndicator.Parent = toggleButton
                toggleIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
                toggleIndicator.Position = toggleData.value and UDim2.new(0.7, 0, 0.5, 0) or UDim2.new(0.3, 0, 0.5, 0)
                toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
                toggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(1, 0)
                indicatorCorner.Parent = toggleIndicator

                local clickArea = Instance.new("TextButton")
                clickArea.Name = "ClickArea"
                clickArea.Parent = toggleContainer
                clickArea.BackgroundTransparency = 1
                clickArea.Size = UDim2.new(1, 0, 1, 0)
                clickArea.Text = ""

                clickArea.MouseButton1Click:Connect(function()
                    toggleData.value = not toggleData.value
                    toggleButton.BackgroundColor3 = toggleData.value and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 40, 40)
                    toggleIndicator:TweenPosition(
                        toggleData.value and UDim2.new(0.7, 0, 0.5, 0) or UDim2.new(0.3, 0, 0.5, 0),
                        Enum.EasingDirection.InOut,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )

                    if callback then
                        callback(toggleData.value)
                    end
                end)

                return toggleContainer
            end,
            setCallback = function(newCallback)
                callback = newCallback
            end,
            getValue = function()
                return toggleData.value
            end,
            setValue = function(newValue)
                toggleData.value = newValue

                if internal.currentSection == section.Name then
                    local toggleContainer = internal.RightContent:FindFirstChild(title.."Toggle")
                    if toggleContainer then
                        local toggleButton = toggleContainer:FindFirstChild("ToggleButton")
                        local toggleIndicator = toggleButton and toggleButton:FindFirstChild("ToggleIndicator")

                        if toggleButton then
                            toggleButton.BackgroundColor3 = toggleData.value and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 40, 40)
                        end

                        if toggleIndicator then
                            toggleIndicator:TweenPosition(
                                toggleData.value and UDim2.new(0.7, 0, 0.5, 0) or UDim2.new(0.3, 0, 0.5, 0),
                                Enum.EasingDirection.InOut,
                                Enum.EasingStyle.Quad,
                                0.2,
                                true
                            )
                        end
                    end
                end

                if callback then
                    callback(toggleData.value)
                end
            end
        }

        table.insert(internal.sections[section.Name].elements, toggleData)

        if internal.currentSection == section.Name then
            local toggle = toggleData.create()
            toggle.Parent = internal.RightContent
        end

        return {
            setCallback = toggleData.setCallback,
            getValue = toggleData.getValue,
            setValue = toggleData.setValue
        }
    end
end

function AE:Label(text, section)
    if internal.sections[section.Name] then
        local labelData = {
            type = "label",
            text = text,
            create = function()
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(0.95, 0, 0, 30)
                label.Position = UDim2.new(0.025, 0, 0, 0)
                label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(200, 200, 200)
                label.Font = Enum.Font.Gotham
                label.TextSize = 14

                local labelCorner = Instance.new("UICorner")
                labelCorner.CornerRadius = UDim.new(0, 4)
                labelCorner.Parent = label

                local labelStroke = Instance.new("UIStroke")
                labelStroke.Color = Color3.fromRGB(40, 40, 40)
                labelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                labelStroke.Parent = label

                return label
            end,
            setText = function(newText)
                labelData.text = newText

                if internal.currentSection == section.Name then
                    local label = internal.RightContent:FindFirstChild("Label")
                    if label then
                        label.Text = newText
                    end
                end
            end
        }

        table.insert(internal.sections[section.Name].elements, labelData)

        if internal.currentSection == section.Name then
            local label = labelData.create()
            label.Parent = internal.RightContent
        end

        return {
            setText = labelData.setText
        }
    end
end

function AE:Separator(section)
    if internal.sections[section.Name] then
        local separatorData = {
            type = "separator",
            create = function()
                local separator = Instance.new("Frame")
                separator.Name = "Separator"
                separator.Size = UDim2.new(0.95, 0, 0, 2)
                separator.Position = UDim2.new(0.025, 0, 0, 0)
                separator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

                local separatorCorner = Instance.new("UICorner")
                separatorCorner.CornerRadius = UDim.new(0, 1)
                separatorCorner.Parent = separator

                return separator
            end
        }

        table.insert(internal.sections[section.Name].elements, separatorData)

        if internal.currentSection == section.Name then
            local separator = separatorData.create()
            separator.Parent = internal.RightContent
        end
    end
end

game.Players.LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(child)
    if child == internal.ScreenGui and internal.firstSection and not initialized then
        wait(0.1)
        initialized = true
        internal.selectSection(internal.firstSection)
    end
end)

return AE