--[[
	APTX GUI Library v2.0
	Librería GUI profesional con sistema de íconos Lucide integrado
	Uso: local gui = APTX:Config({icons = "default", hidebutton = true})
]]

local APTX = {}
APTX.__index = APTX

-- ==================== ICONOS LUCIDE ====================
local LucideIcons = {
	["home"] = "rbxassetid://10723434711",
	["settings"] = "rbxassetid://10734950309",
	["user"] = "rbxassetid://10734949856",
	["users"] = "rbxassetid://10747373176",
	["info"] = "rbxassetid://10723407389",
	["chevron-right"] = "rbxassetid://10709790948",
	["chevron-left"] = "rbxassetid://10709790644",
	["chevron-up"] = "rbxassetid://10709791437",
	["chevron-down"] = "rbxassetid://10709790644",
	["check"] = "rbxassetid://10709814189",
	["x"] = "rbxassetid://10747384394",
	["menu"] = "rbxassetid://10723407389",
	["search"] = "rbxassetid://10734898355",
	["bell"] = "rbxassetid://10709764411",
	["star"] = "rbxassetid://10734896869",
	["heart"] = "rbxassetid://10723434711",
	["eye"] = "rbxassetid://10723345281",
	["eye-off"] = "rbxassetid://10723345518",
	["lock"] = "rbxassetid://10723407389",
	["unlock"] = "rbxassetid://10747384394",
	["trash"] = "rbxassetid://10734884548",
	["edit"] = "rbxassetid://10734883566",
	["plus"] = "rbxassetid://10734896206",
	["minus"] = "rbxassetid://10723407389",
	["arrow-up"] = "rbxassetid://10709776174",
	["arrow-down"] = "rbxassetid://10709775692",
	["arrow-left"] = "rbxassetid://10709775197",
	["arrow-right"] = "rbxassetid://10709776511",
	["download"] = "rbxassetid://10723346835",
	["upload"] = "rbxassetid://10734949856",
	["file"] = "rbxassetid://10723374238",
	["folder"] = "rbxassetid://10723374389",
	["image"] = "rbxassetid://10723407389",
	["play"] = "rbxassetid://10734896206",
	["pause"] = "rbxassetid://10734895663",
	["stop"] = "rbxassetid://10734898769",
	["skip-forward"] = "rbxassetid://10734898355",
	["skip-back"] = "rbxassetid://10734898088",
	["refresh"] = "rbxassetid://10723407389",
	["shield"] = "rbxassetid://10734950309",
	["database"] = "rbxassetid://10723346835",
	["server"] = "rbxassetid://10734950309",
	["globe"] = "rbxassetid://10723407389",
	["wifi"] = "rbxassetid://10747384394",
	["bluetooth"] = "rbxassetid://10709764411",
	["battery"] = "rbxassetid://10709764197",
	["power"] = "rbxassetid://10734896206",
	["cpu"] = "rbxassetid://10723346835"
}

-- ==================== COLORES DEL TEMA ====================
local Theme = {
	Background = Color3.fromRGB(15, 15, 17),
	Topbar = Color3.fromRGB(22, 22, 25),
	Border = Color3.fromRGB(45, 45, 50),
	SidebarBg = Color3.fromRGB(18, 18, 21),
	ButtonNormal = Color3.fromRGB(25, 25, 28),
	ButtonHover = Color3.fromRGB(35, 35, 40),
	ButtonActive = Color3.fromRGB(55, 120, 220),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 180, 185),
	Accent = Color3.fromRGB(70, 140, 255),
	SliderFill = Color3.fromRGB(70, 140, 255),
	SliderThumb = Color3.fromRGB(255, 255, 255),
	InputBg = Color3.fromRGB(22, 22, 26),
	ToggleOn = Color3.fromRGB(70, 140, 255),
	ToggleOff = Color3.fromRGB(40, 40, 45)
}

-- ==================== UTILIDADES ====================
local function CreateElement(className, properties)
	local element = Instance.new(className)
	for prop, value in pairs(properties) do
		element[prop] = value
	end
	return element
end

local function AddCorner(parent, radius)
	return CreateElement("UICorner", {
		CornerRadius = UDim.new(0, radius or 8),
		Parent = parent
	})
end

local function AddStroke(parent, color, thickness)
	return CreateElement("UIStroke", {
		Color = color or Theme.Border,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent
	})
end

local function CreateIcon(iconName, size)
	local iconId = LucideIcons[iconName] or LucideIcons["home"]
	return CreateElement("ImageLabel", {
		Size = UDim2.new(0, size or 18, 0, size or 18),
		BackgroundTransparency = 1,
		Image = iconId,
		ImageColor3 = Theme.TextPrimary,
		ScaleType = Enum.ScaleType.Fit
	})
end

local function TweenProperty(instance, property, targetValue, duration)
	local TweenService = game:GetService("TweenService")
	local info = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local goal = {[property] = targetValue}
	TweenService:Create(instance, info, goal):Play()
end

-- ==================== CONSTRUCTOR PRINCIPAL ====================
function APTX:Config(config)
	config = config or {}
	local self = setmetatable({}, APTX)
	
	self.IconMode = config.icons or "default"
	self.ShowHideButton = config.hidebutton ~= false
	self.CurrentSection = nil
	self.Sections = {}
	self.CustomIcons = config.customIcons or {}
	
	-- Combinar íconos personalizados con los default
	if self.IconMode == "custom" and self.CustomIcons then
		for name, id in pairs(self.CustomIcons) do
			LucideIcons[name] = id
		end
	end
	
	self:CreateMainUI()
	return self
end

-- ==================== CREACIÓN DE UI PRINCIPAL ====================
function APTX:CreateMainUI()
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- ScreenGui principal
	self.ScreenGui = CreateElement("ScreenGui", {
		Name = "APTXGui",
		Parent = playerGui,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})
	
	-- Botón de toggle externo
	if self.ShowHideButton then
		self:CreateToggleButton()
	end
	
	-- Frame principal
	self.MainFrame = CreateElement("Frame", {
		Name = "MainFrame",
		Size = UDim2.new(0, 650, 0, 420),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Parent = self.ScreenGui
	})
	
	AddCorner(self.MainFrame, 10)
	AddStroke(self.MainFrame, Theme.Border, 1)
	
	-- Topbar
	self:CreateTopbar()
	
	-- Container de contenido
	self.ContentContainer = CreateElement("Frame", {
		Name = "ContentContainer",
		Size = UDim2.new(1, -20, 1, -60),
		Position = UDim2.new(0, 10, 0, 50),
		BackgroundTransparency = 1,
		Parent = self.MainFrame
	})
	
	-- Sidebar (25%)
	self:CreateSidebar()
	
	-- Content Area (75%)
	self:CreateContentArea()
	
	-- Hacer draggable
	self:MakeDraggable()
end

-- ==================== TOGGLE BUTTON ====================
function APTX:CreateToggleButton()
	self.ToggleButton = CreateElement("TextButton", {
		Name = "ToggleButton",
		Size = UDim2.new(0, 50, 0, 50),
		Position = UDim2.new(0, 20, 0.5, -25),
		BackgroundColor3 = Theme.Topbar,
		BorderSizePixel = 0,
		Text = "",
		Parent = self.ScreenGui,
		ZIndex = 10
	})
	
	AddCorner(self.ToggleButton, 10)
	AddStroke(self.ToggleButton, Theme.Border, 1)
	
	local icon = CreateIcon("menu", 24)
	icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Parent = self.ToggleButton
	
	local isVisible = true
	self.ToggleButton.MouseButton1Click:Connect(function()
		isVisible = not isVisible
		self.MainFrame.Visible = isVisible
	end)
	
	-- Hover effect
	self.ToggleButton.MouseEnter:Connect(function()
		TweenProperty(self.ToggleButton, "BackgroundColor3", Theme.ButtonHover)
	end)
	
	self.ToggleButton.MouseLeave:Connect(function()
		TweenProperty(self.ToggleButton, "BackgroundColor3", Theme.Topbar)
	end)
end

-- ==================== TOPBAR ====================
function APTX:CreateTopbar()
	local topbar = CreateElement("Frame", {
		Name = "Topbar",
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = Theme.Topbar,
		BorderSizePixel = 0,
		Parent = self.MainFrame
	})
	
	AddCorner(topbar, 10)
	
	-- Título
	local title = CreateElement("TextLabel", {
		Name = "Title",
		Size = UDim2.new(0, 200, 1, 0),
		Position = UDim2.new(0, 15, 0, 0),
		BackgroundTransparency = 1,
		Text = "APTX GUI",
		TextColor3 = Theme.TextPrimary,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topbar
	})
	
	-- Botón cerrar
	local closeBtn = CreateElement("TextButton", {
		Name = "CloseButton",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -40, 0.5, -15),
		BackgroundColor3 = Theme.ButtonNormal,
		BorderSizePixel = 0,
		Text = "",
		Parent = topbar
	})
	
	AddCorner(closeBtn, 6)
	
	local xIcon = CreateIcon("x", 16)
	xIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	xIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	xIcon.Parent = closeBtn
	
	closeBtn.MouseButton1Click:Connect(function()
		self.ScreenGui:Destroy()
	end)
	
	closeBtn.MouseEnter:Connect(function()
		TweenProperty(closeBtn, "BackgroundColor3", Color3.fromRGB(200, 50, 50))
	end)
	
	closeBtn.MouseLeave:Connect(function()
		TweenProperty(closeBtn, "BackgroundColor3", Theme.ButtonNormal)
	end)
end

-- ==================== SIDEBAR ====================
function APTX:CreateSidebar()
	self.Sidebar = CreateElement("ScrollingFrame", {
		Name = "Sidebar",
		Size = UDim2.new(0.25, -5, 1, 0),
		BackgroundColor3 = Theme.SidebarBg,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = Theme.Border,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = self.ContentContainer
	})
	
	AddCorner(self.Sidebar, 8)
	
	CreateElement("UIListLayout", {
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = self.Sidebar
	})
	
	CreateElement("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		Parent = self.Sidebar
	})
end

-- ==================== CONTENT AREA ====================
function APTX:CreateContentArea()
	self.ContentArea = CreateElement("ScrollingFrame", {
		Name = "ContentArea",
		Size = UDim2.new(0.75, -5, 1, 0),
		Position = UDim2.new(0.25, 5, 0, 0),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Theme.Border,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = self.ContentContainer
	})
	
	AddCorner(self.ContentArea, 8)
	AddStroke(self.ContentArea, Theme.Border, 1)
	
	CreateElement("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = self.ContentArea
	})
	
	CreateElement("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		Parent = self.ContentArea
	})
end

-- ==================== DRAGGABLE ====================
function APTX:MakeDraggable()
	local UserInputService = game:GetService("UserInputService")
	local dragging, dragInput, dragStart, startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		self.MainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
	
	self.MainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = self.MainFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
		
		if dragging and dragInput then
			update(dragInput)
		end
	end)
end

-- ==================== AÑADIR SECCIÓN ====================
function APTX:AddSection(name, icon)
	icon = icon or "folder"
	
	local sectionButton = CreateElement("TextButton", {
		Name = name,
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = Theme.ButtonNormal,
		BorderSizePixel = 0,
		Text = "",
		Parent = self.Sidebar
	})
	
	AddCorner(sectionButton, 6)
	
	local iconImg = CreateIcon(icon, 16)
	iconImg.Position = UDim2.new(0, 10, 0.5, 0)
	iconImg.AnchorPoint = Vector2.new(0, 0.5)
	iconImg.Parent = sectionButton
	
	local label = CreateElement("TextLabel", {
		Size = UDim2.new(1, -36, 1, 0),
		Position = UDim2.new(0, 32, 0, 0),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = Theme.TextPrimary,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = sectionButton
	})
	
	-- Container de contenido de sección
	local sectionContent = CreateElement("Frame", {
		Name = name .. "Content",
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = self.ContentArea,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	
	CreateElement("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = sectionContent
	})
	
	self.Sections[name] = {
		Button = sectionButton,
		Content = sectionContent,
		Icon = iconImg
	}
	
	-- Evento de click
	sectionButton.MouseButton1Click:Connect(function()
		self:LoadSection(name)
	end)
	
	-- Hover effects
	sectionButton.MouseEnter:Connect(function()
		if self.CurrentSection ~= name then
			TweenProperty(sectionButton, "BackgroundColor3", Theme.ButtonHover)
		end
	end)
	
	sectionButton.MouseLeave:Connect(function()
		if self.CurrentSection ~= name then
			TweenProperty(sectionButton, "BackgroundColor3", Theme.ButtonNormal)
		end
	end)
	
	-- Cargar primera sección automáticamente
	if not self.CurrentSection then
		self:LoadSection(name)
	end
	
	return {
		AddButton = function(_, ...) return self:AddButton(name, ...) end,
		AddToggle = function(_, ...) return self:AddToggle(name, ...) end,
		AddSlider = function(_, ...) return self:AddSlider(name, ...) end,
		AddTextbox = function(_, ...) return self:AddTextbox(name, ...) end,
		AddLabel = function(_, ...) return self:AddLabel(name, ...) end,
		AddDropdown = function(_, ...) return self:AddDropdown(name, ...) end
	}
end

-- ==================== CARGAR SECCIÓN ====================
function APTX:LoadSection(name)
	-- Ocultar todas las secciones
	for sectionName, section in pairs(self.Sections) do
		section.Content.Visible = false
		TweenProperty(section.Button, "BackgroundColor3", Theme.ButtonNormal)
	end
	
	-- Mostrar sección seleccionada
	local section = self.Sections[name]
	if section then
		section.Content.Visible = true
		TweenProperty(section.Button, "BackgroundColor3", Theme.ButtonActive)
		self.CurrentSection = name
	end
end

-- ==================== COMPONENTES ====================

-- BOTÓN
function APTX:AddButton(sectionName, text, icon, callback)
	local section = self.Sections[sectionName]
	if not section then return end
	
	local button = CreateElement("TextButton", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = Theme.ButtonNormal,
		BorderSizePixel = 0,
		Text = "",
		Parent = section.Content
	})
	
	AddCorner(button, 6)
	AddStroke(button, Theme.Border, 1)
	
	if icon then
		local iconImg = CreateIcon(icon, 16)
		iconImg.Position = UDim2.new(0, 12, 0.5, 0)
		iconImg.AnchorPoint = Vector2.new(0, 0.5)
		iconImg.Parent = button
	end
	
	local label = CreateElement("TextLabel", {
		Size = UDim2.new(1, icon and -40 or -20, 1, 0),
		Position = UDim2.new(0, icon and 36 or 12, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.TextPrimary,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = button
	})
	
	button.MouseButton1Click:Connect(function()
		if callback then callback() end
		TweenProperty(button, "BackgroundColor3", Theme.Accent)
		wait(0.1)
		TweenProperty(button, "BackgroundColor3", Theme.ButtonNormal)
	end)
	
	button.MouseEnter:Connect(function()
		TweenProperty(button, "BackgroundColor3", Theme.ButtonHover)
	end)
	
	button.MouseLeave:Connect(function()
		TweenProperty(button, "BackgroundColor3", Theme.ButtonNormal)
	end)
	
	return button
end

-- TOGGLE
function APTX:AddToggle(sectionName, text, default, callback)
	local section = self.Sections[sectionName]
	if not section then return end
	
	local isToggled = default or false
	
	local container = CreateElement("Frame", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = Theme.ButtonNormal,
		BorderSizePixel = 0,
		Parent = section.Content
	})
	
	AddCorner(container, 6)
	AddStroke(container, Theme.Border, 1)
	
	local label = CreateElement("TextLabel", {
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.TextPrimary,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = container
	})
	
	local toggleButton = CreateElement("TextButton", {
		Size = UDim2.new(0, 44, 0, 24),
		Position = UDim2.new(1, -52, 0.5, -12),
		BackgroundColor3 = isToggled and Theme.ToggleOn or Theme.ToggleOff,
		BorderSizePixel = 0,
		Text = "",
		Parent = container
	})
	
	AddCorner(toggleButton, 12)
	
	local thumb = CreateElement("Frame", {
		Size = UDim2.new(0, 18, 0, 18),
		Position = isToggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
		BackgroundColor3 = Theme.SliderThumb,
		BorderSizePixel = 0,
		Parent = toggleButton
	})
	
	AddCorner(thumb, 9)
	
	toggleButton.MouseButton1Click:Connect(function()
		isToggled = not isToggled
		
		TweenProperty(toggleButton, "BackgroundColor3", isToggled and Theme.ToggleOn or Theme.ToggleOff)
		TweenProperty(thumb, "Position", isToggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9))
		
		if callback then callback(isToggled) end
	end)
	
	return {
		Set = function(value)
			isToggled = value
			TweenProperty(toggleButton, "BackgroundColor3", isToggled and Theme.ToggleOn or Theme.ToggleOff)
			TweenProperty(thumb, "Position", isToggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9))
		end
	}
end

-- SLIDER
function APTX:AddSlider(sectionName, text, min, max, default, callback)
	local section = self.Sections[sectionName]
	if not section then return end
	
	local currentValue = default or min
	
	local container = CreateElement("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = Theme.ButtonNormal,
		BorderSizePixel = 0,
		Parent = section.Content
	})
	
	AddCorner(container, 6)
	AddStroke(container, Theme.Border, 1)
	
	local label = CreateElement("TextLabel", {
		Size = UDim2.new(1, -60, 0, 20),
		Position = UDim2.new(0, 12, 0, 6),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.TextPrimary,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = container
	})
	
	local valueLabel = CreateElement("TextLabel", {
		Size = UDim2.new(0, 50, 0, 20),
		Position = UDim2.new(1, -58, 0, 6),
		BackgroundTransparency = 1,
		Text = tostring(currentValue),
		TextColor3 = Theme.Accent,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = container
	})
	
	local sliderBg = CreateElement("Frame", {
		Size = UDim2.new(1, -24, 0, 6),
		Position = UDim2.new(0, 12, 1, -16),
		BackgroundColor3 = Theme.InputBg,
		BorderSizePixel = 0,
		Parent = container
	})
	
	AddCorner(sliderBg, 3)
	
	local sliderFill = CreateElement("Frame", {
		Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = Theme.SliderFill,
		BorderSizePixel = 0,
		Parent = sliderBg
	})
	
	AddCorner(sliderFill, 3)
	
	local thumb = CreateElement("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new((currentValue - min) / (max - min), -7, 0.5, -7),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Theme.SliderThumb,
		BorderSizePixel = 0,
		Parent = sliderBg,
		ZIndex = 2
	})
	
	AddCorner(thumb, 7)
	AddStroke(thumb, Theme.Border, 2)
	
	local dragging = false
	
	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
		currentValue = math.floor(min + (max - min) * pos)
		
		valueLabel.Text = tostring(currentValue)
		sliderFill.Size = UDim2.new(pos, 0, 1, 0)
		thumb.Position = UDim2.new(pos, -7, 0.5, -7)
		
		if callback then callback(currentValue) end
	end
	
	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(input)
		end
	end)
	
	sliderBg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input)
		end
	end)
	
	return {
		Set = function(value)
			currentValue = math.clamp(value, min, max)
			local pos = (currentValue - min) / (max - min)
			valueLabel.Text = tostring(currentValue)
			sliderFill.Size = UDim2.new(pos, 0, 1, 0)
			thumb.Position = UDim2.new(pos, -7, 0.5, -7)
		end
	}
end

-- TEXTBOX
function APTX:AddTextbox(sectionName, text, placeholder, callback)
	local section = self.Sections[sectionName]
	if not section then return end
	
	local container = CreateElement("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = Theme.ButtonNormal,
		BorderSizePixel = 0,
		Parent = section.Content
	})
	
	AddCorner(container, 6)
	AddStroke(container, Theme.Border, 1)
	
	local label = CreateElement("TextLabel", {
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 12, 0, 6),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.TextPrimary,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = container
	})
	
	local textbox = CreateElement("TextBox", {
		Size = UDim2.new(1, -24, 0, 24),
		Position = UDim2.new(0, 12, 1, -30),
		BackgroundColor3 = Theme.InputBg,
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = placeholder or "Escribe aquí...",
		PlaceholderColor3 = Theme.TextSecondary,
		TextColor3 = Theme.TextPrimary,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Parent = container
	})
	
	AddCorner(textbox, 4)
	AddStroke(textbox, Theme.Border, 1)
	
	CreateElement("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		Parent = textbox
	})
	
	textbox.FocusLost:Connect(function(enterPressed)
		if callback then callback(textbox.Text, enterPressed) end
	end)
	
	return {
		Set = function(value)
			textbox.Text = value
		end,
		Get = function()
			return textbox.Text
		end
	}
end

-- LABEL
function APTX:AddLabel(sectionName, text)
	local section = self.Sections[sectionName]
	if not section then return end
	
	local label = CreateElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.TextSecondary,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = section.Content,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	
	CreateElement("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		Parent = label
	})
	
	return {
		Set = function(newText)
			label.Text = newText
		end
	}
end

-- DROPDOWN
function APTX:AddDropdown(sectionName, text, options, callback)
	local section = self.Sections[sectionName]
	if not section then return end
	
	local isOpen = false
	local selectedOption = options[1] or "Ninguno"
	
	local container = CreateElement("Frame", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = Theme.ButtonNormal,
		BorderSizePixel = 0,
		Parent = section.Content,
		ClipsDescendants = true
	})
	
	AddCorner(container, 6)
	AddStroke(container, Theme.Border, 1)
	
	local header = CreateElement("TextButton", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		Text = "",
		Parent = container
	})
	
	local label = CreateElement("TextLabel", {
		Size = UDim2.new(0.6, 0, 1, 0),
		Position = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.TextPrimary,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header
	})
	
	local selected = CreateElement("TextLabel", {
		Size = UDim2.new(0.4, -40, 1, 0),
		Position = UDim2.new(0.6, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = selectedOption,
		TextColor3 = Theme.Accent,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = header
	})
	
	local arrow = CreateIcon("chevron-down", 14)
	arrow.Position = UDim2.new(1, -24, 0.5, 0)
	arrow.AnchorPoint = Vector2.new(0.5, 0.5)
	arrow.Parent = header
	
	local optionsList = CreateElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, 38),
		BackgroundTransparency = 1,
		Parent = container,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	
	CreateElement("UIListLayout", {
		Padding = UDim.new(0, 2),
		Parent = optionsList
	})
	
	for _, option in ipairs(options) do
		local optionBtn = CreateElement("TextButton", {
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = Theme.InputBg,
			BorderSizePixel = 0,
			Text = option,
			TextColor3 = Theme.TextPrimary,
			TextSize = 12,
			Font = Enum.Font.Gotham,
			Parent = optionsList
		})
		
		optionBtn.MouseButton1Click:Connect(function()
			selectedOption = option
			selected.Text = option
			if callback then callback(option) end
			
			isOpen = false
			TweenProperty(container, "Size", UDim2.new(1, 0, 0, 38))
			TweenProperty(arrow.Parent, "Rotation", 0)
		end)
		
		optionBtn.MouseEnter:Connect(function()
			TweenProperty(optionBtn, "BackgroundColor3", Theme.ButtonHover)
		end)
		
		optionBtn.MouseLeave:Connect(function()
			TweenProperty(optionBtn, "BackgroundColor3", Theme.InputBg)
		end)
	end
	
	header.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		
		if isOpen then
			local totalHeight = 38 + (#options * 34)
			TweenProperty(container, "Size", UDim2.new(1, 0, 0, totalHeight))
			TweenProperty(arrow.Parent, "Rotation", 180)
		else
			TweenProperty(container, "Size", UDim2.new(1, 0, 0, 38))
			TweenProperty(arrow.Parent, "Rotation", 0)
		end
	end)
	
	return {
		Set = function(option)
			selectedOption = option
			selected.Text = option
		end
	}
end

return APTX