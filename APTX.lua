local APTX = {}
APTX.__index = APTX

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

function APTX:init(titulo, drag, dev)
	local self = setmetatable({}, APTX)
	
	self.dev = dev or false
	self.drag = drag or false
	self.sections = {}
	self.current = nil
	self.components = {}
	
	if self.dev then
		print("[APTX] Inicializando GUI: " .. titulo)
	end
	
	self.screen = Instance.new("ScreenGui")
	self.screen.Name = "APTX"
	self.screen.Parent = player:WaitForChild("PlayerGui")
	self.screen.ResetOnSpawn = false
	
	self.main = Instance.new("Frame")
	self.main.Size = UDim2.new(0, 600, 0, 400)
	self.main.Position = UDim2.new(0.5, -300, 0.5, -200)
	self.main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	self.main.BorderColor3 = Color3.fromRGB(80, 80, 80)
	self.main.BorderSizePixel = 2
	self.main.Parent = self.screen
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = self.main
	
	self.topbar = Instance.new("Frame")
	self.topbar.Size = UDim2.new(1, 0, 0, 40)
	self.topbar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	self.topbar.BorderSizePixel = 0
	self.topbar.Parent = self.main
	
	local topcorner = Instance.new("UICorner")
	topcorner.CornerRadius = UDim.new(0, 8)
	topcorner.Parent = self.topbar
	
	local fix = Instance.new("Frame")
	fix.Size = UDim2.new(1, 0, 0, 8)
	fix.Position = UDim2.new(0, 0, 1, -8)
	fix.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	fix.BorderSizePixel = 0
	fix.Parent = self.topbar
	
	self.title = Instance.new("TextLabel")
	self.title.Size = UDim2.new(1, -50, 1, 0)
	self.title.Position = UDim2.new(0, 10, 0, 0)
	self.title.BackgroundTransparency = 1
	self.title.Text = titulo
	self.title.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.title.Font = Enum.Font.GothamBold
	self.title.TextSize = 16
	self.title.TextXAlignment = Enum.TextXAlignment.Left
	self.title.Parent = self.topbar
	
	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0, 30, 0, 30)
	close.Position = UDim2.new(1, -35, 0, 5)
	close.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	close.BorderSizePixel = 0
	close.Text = "X"
	close.TextColor3 = Color3.fromRGB(255, 255, 255)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 14
	close.Parent = self.topbar
	
	local closecorner = Instance.new("UICorner")
	closecorner.CornerRadius = UDim.new(0, 6)
	closecorner.Parent = close
	
	close.MouseButton1Click:Connect(function()
		self:destroy()
	end)
	
	self.left = Instance.new("Frame")
	self.left.Size = UDim2.new(0.25, -1, 1, -40)
	self.left.Position = UDim2.new(0, 0, 0, 40)
	self.left.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	self.left.BorderSizePixel = 0
	self.left.Parent = self.main
	
	local leftscroll = Instance.new("ScrollingFrame")
	leftscroll.Size = UDim2.new(1, 0, 1, 0)
	leftscroll.BackgroundTransparency = 1
	leftscroll.BorderSizePixel = 0
	leftscroll.ScrollBarThickness = 4
	leftscroll.Parent = self.left
	
	local leftlayout = Instance.new("UIListLayout")
	leftlayout.Padding = UDim.new(0, 5)
	leftlayout.Parent = leftscroll
	
	self.leftscroll = leftscroll
	
	self.right = Instance.new("Frame")
	self.right.Size = UDim2.new(0.75, 0, 1, -40)
	self.right.Position = UDim2.new(0.25, 0, 0, 40)
	self.right.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	self.right.BorderSizePixel = 0
	self.right.Parent = self.main
	
	local separator = Instance.new("Frame")
	separator.Size = UDim2.new(0, 2, 1, -40)
	separator.Position = UDim2.new(0.25, -1, 0, 40)
	separator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	separator.BorderSizePixel = 0
	separator.Parent = self.main
	
	if self.drag then
		self:makedrag()
	end
	
	return self
end

function APTX:makedrag()
	local dragging = false
	local dragstart = nil
	local startpos = nil
	
	self.topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragstart = input.Position
			startpos = self.main.Position
		end
	end)
	
	self.topbar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragstart
			self.main.Position = UDim2.new(
				startpos.X.Scale,
				startpos.X.Offset + delta.X,
				startpos.Y.Scale,
				startpos.Y.Offset + delta.Y
			)
		end
	end)
end

function APTX:Section(texto, icon, default)
	local section = {
		name = texto,
		icon = icon,
		container = nil,
		button = nil
	}
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.BorderColor3 = Color3.fromRGB(80, 80, 80)
	btn.BorderSizePixel = 1
	btn.Text = "  " .. texto
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = self.leftscroll
	
	local btncorner = Instance.new("UICorner")
	btncorner.CornerRadius = UDim.new(0, 6)
	btncorner.Parent = btn
	
	if icon then
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.new(0, 20, 0, 20)
		img.Position = UDim2.new(0, 5, 0.5, -10)
		img.BackgroundTransparency = 1
		img.Image = icon
		img.Parent = btn
		btn.Text = "     " .. texto
	end
	
	section.button = btn
	
	local container = Instance.new("ScrollingFrame")
	container.Size = UDim2.new(1, -10, 1, -10)
	container.Position = UDim2.new(0, 5, 0, 5)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 6
	container.Visible = false
	container.Parent = self.right
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.Parent = container
	
	section.container = container
	
	table.insert(self.sections, section)
	
	btn.MouseButton1Click:Connect(function()
		self:load(section)
	end)
	
	if default or #self.sections == 1 then
		self:load(section)
	end
	
	if self.dev then
		print("[APTX] Sección creada: " .. texto)
	end
	
	return section
end

function APTX:load(section)
	for _, s in ipairs(self.sections) do
		s.container.Visible = false
		s.button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end
	
	section.container.Visible = true
	section.button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	self.current = section
	
	if self.dev then
		print("[APTX] Cargada sección: " .. section.name)
	end
end

function APTX:Button(section, texto, icon, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.BorderColor3 = Color3.fromRGB(80, 80, 80)
	btn.BorderSizePixel = 1
	btn.Text = "  " .. texto
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = section.container
	
	local btncorner = Instance.new("UICorner")
	btncorner.CornerRadius = UDim.new(0, 6)
	btncorner.Parent = btn
	
	if icon then
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.new(0, 24, 0, 24)
		img.Position = UDim2.new(0, 5, 0.5, -12)
		img.BackgroundTransparency = 1
		img.Image = icon
		img.Parent = btn
		btn.Text = "      " .. texto
	end
	
	btn.MouseButton1Click:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		wait(0.1)
		btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		
		if callback then
			callback()
		end
		
		if self.dev then
			print("[APTX] Botón presionado: " .. texto)
		end
	end)
	
	return btn
end

function APTX:Slider(section, texto, icon, min, max, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 60)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderColor3 = Color3.fromRGB(80, 80, 80)
	frame.BorderSizePixel = 1
	frame.Parent = section.container
	
	local framecorner = Instance.new("UICorner")
	framecorner.CornerRadius = UDim.new(0, 6)
	framecorner.Parent = frame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Position = UDim2.new(0, 5, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = texto
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	
	if icon then
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.new(0, 20, 0, 20)
		img.Position = UDim2.new(0, 5, 0, 5)
		img.BackgroundTransparency = 1
		img.Image = icon
		img.Parent = frame
		label.Position = UDim2.new(0, 30, 0, 5)
	end
	
	local value = Instance.new("TextLabel")
	value.Size = UDim2.new(0, 50, 0, 20)
	value.Position = UDim2.new(1, -55, 0, 5)
	value.BackgroundTransparency = 1
	value.Text = tostring(default or min)
	value.TextColor3 = Color3.fromRGB(200, 200, 200)
	value.Font = Enum.Font.GothamBold
	value.TextSize = 14
	value.TextXAlignment = Enum.TextXAlignment.Right
	value.Parent = frame
	
	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -20, 0, 4)
	track.Position = UDim2.new(0, 10, 1, -20)
	track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	track.BorderSizePixel = 0
	track.Parent = frame
	
	local trackcorner = Instance.new("UICorner")
	trackcorner.CornerRadius = UDim.new(1, 0)
	trackcorner.Parent = track
	
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
	fill.BorderSizePixel = 0
	fill.Parent = track
	
	local fillcorner = Instance.new("UICorner")
	fillcorner.CornerRadius = UDim.new(1, 0)
	fillcorner.Parent = fill
	
	local thumb = Instance.new("Frame")
	thumb.Size = UDim2.new(0, 16, 0, 16)
	thumb.Position = UDim2.new(0, -8, 0.5, -8)
	thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	thumb.BorderSizePixel = 0
	thumb.Parent = fill
	
	local thumbcorner = Instance.new("UICorner")
	thumbcorner.CornerRadius = UDim.new(1, 0)
	thumbcorner.Parent = thumb
	
	local dragging = false
	local current = default or min
	
	local function update(input)
		local pos = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
		pos = math.clamp(pos, 0, 1)
		
		current = math.floor(min + (max - min) * pos)
		value.Text = tostring(current)
		
		fill.Size = UDim2.new(pos, 0, 1, 0)
		
		if callback then
			callback(current)
		end
	end
	
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			update(input)
		end
	end)
	
	track.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
	
	local initpos = ((default or min) - min) / (max - min)
	fill.Size = UDim2.new(initpos, 0, 1, 0)
	
	if self.dev then
		print("[APTX] Slider creado: " .. texto)
	end
	
	return {
		get = function()
			return current
		end,
		set = function(val)
			current = math.clamp(val, min, max)
			value.Text = tostring(current)
			local pos = (current - min) / (max - min)
			fill.Size = UDim2.new(pos, 0, 1, 0)
		end
	}
end

function APTX:Dropdown(section, texto, placeholder, icon, options, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderColor3 = Color3.fromRGB(80, 80, 80)
	frame.BorderSizePixel = 1
	frame.Parent = section.container
	
	local framecorner = Instance.new("UICorner")
	framecorner.CornerRadius = UDim.new(0, 6)
	framecorner.Parent = frame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 150, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = "  " .. texto
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	
	if icon then
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.new(0, 20, 0, 20)
		img.Position = UDim2.new(0, 5, 0.5, -10)
		img.BackgroundTransparency = 1
		img.Image = icon
		img.Parent = frame
		label.Text = "     " .. texto
	end
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -160, 1, -10)
	btn.Position = UDim2.new(0, 155, 0, 5)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.BorderColor3 = Color3.fromRGB(80, 80, 80)
	btn.BorderSizePixel = 1
	btn.Text = default or placeholder or "Seleccionar"
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.Parent = frame
	
	local btncorner = Instance.new("UICorner")
	btncorner.CornerRadius = UDim.new(0, 4)
	btncorner.Parent = btn
	
	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 20, 1, 0)
	arrow.Position = UDim2.new(1, -20, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
	arrow.Font = Enum.Font.Gotham
	arrow.TextSize = 10
	arrow.Parent = btn
	
	local menu = Instance.new("Frame")
	menu.Size = UDim2.new(1, -160, 0, 0)
	menu.Position = UDim2.new(0, 155, 1, 5)
	menu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	menu.BorderColor3 = Color3.fromRGB(80, 80, 80)
	menu.BorderSizePixel = 1
	menu.Visible = false
	menu.ZIndex = 10
	menu.Parent = frame
	
	local menucorner = Instance.new("UICorner")
	menucorner.CornerRadius = UDim.new(0, 4)
	menucorner.Parent = menu
	
	local menulist = Instance.new("UIListLayout")
	menulist.Padding = UDim.new(0, 2)
	menulist.Parent = menu
	
	local open = false
	local selected = default
	
	for _, opt in ipairs(options) do
		local optbtn = Instance.new("TextButton")
		optbtn.Size = UDim2.new(1, 0, 0, 30)
		optbtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		optbtn.BorderSizePixel = 0
		optbtn.Text = opt
		optbtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		optbtn.Font = Enum.Font.Gotham
		optbtn.TextSize = 13
		optbtn.Parent = menu
		
		optbtn.MouseButton1Click:Connect(function()
			selected = opt
			btn.Text = opt
			menu.Visible = false
			open = false
			arrow.Text = "▼"
			
			if callback then
				callback(opt)
			end
			
			if self.dev then
				print("[APTX] Opción seleccionada: " .. opt)
			end
		end)
		
		optbtn.MouseEnter:Connect(function()
			optbtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end)
		
		optbtn.MouseLeave:Connect(function()
			optbtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end)
	end
	
	btn.MouseButton1Click:Connect(function()
		open = not open
		menu.Visible = open
		arrow.Text = open and "▲" or "▼"
		
		if open then
			menu.Size = UDim2.new(1, -160, 0, math.min(#options * 32, 150))
		end
	end)
	
	if self.dev then
		print("[APTX] Dropdown creado: " .. texto)
	end
	
	return {
		get = function()
			return selected
		end,
		set = function(val)
			selected = val
			btn.Text = val
		end
	}
end

function APTX:Toggle(section, texto, icon, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderColor3 = Color3.fromRGB(80, 80, 80)
	frame.BorderSizePixel = 1
	frame.Parent = section.container
	
	local framecorner = Instance.new("UICorner")
	framecorner.CornerRadius = UDim.new(0, 6)
	framecorner.Parent = frame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = "  " .. texto
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	
	if icon then
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.new(0, 20, 0, 20)
		img.Position = UDim2.new(0, 5, 0.5, -10)
		img.BackgroundTransparency = 1
		img.Image = icon
		img.Parent = frame
		label.Text = "     " .. texto
	end
	
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 44, 0, 24)
	toggle.Position = UDim2.new(1, -50, 0.5, -12)
	toggle.BackgroundColor3 = default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 60)
	toggle.BorderSizePixel = 0
	toggle.Text = ""
	toggle.Parent = frame
	
	local togglecorner = Instance.new("UICorner")
	togglecorner.CornerRadius = UDim.new(1, 0)
	togglecorner.Parent = toggle
	
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = toggle
	
	local knobcorner = Instance.new("UICorner")
	knobcorner.CornerRadius = UDim.new(1, 0)
	knobcorner.Parent = knob
	
	local state = default or false
	
	toggle.MouseButton1Click:Connect(function()
		state = not state
		
		local color = state and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 60)
		local pos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		
		ts:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
		ts:Create(knob, TweenInfo.new(0.2), {Position = pos}):Play()
		
		if callback then
			callback(state)
		end
		
		if self.dev then
			print("[APTX] Toggle: " .. texto .. " = " .. tostring(state))
		end
	end)
	
	if self.dev then
		print("[APTX] Toggle creado: " .. texto)
	end
	
	return {
		get = function()
			return state
		end,
		set = function(val)
			state = val
			local color = state and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 60)
			local pos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
			toggle.BackgroundColor3 = color
			knob.Position = pos
		end
	}
end

function APTX:Label(section, texto, icon)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 30)
	label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	label.BorderColor3 = Color3.fromRGB(80, 80, 80)
	label.BorderSizePixel = 1
	label.Text = "  " .. texto
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = section.container
	
	local labelcorner = Instance.new("UICorner")
	labelcorner.CornerRadius = UDim.new(0, 6)
	labelcorner.Parent = label
	
	if icon then
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.new(0, 20, 0, 20)
		img.Position = UDim2.new(0, 5, 0.5, -10)
		img.BackgroundTransparency = 1
		img.Image = icon
		img.Parent = label
		label.Text = "     " .. texto
	end
	
	return {
		set = function(val)
			label.Text = icon and ("     " .. val) or ("  " .. val)
		end
	}
end

function APTX:destroy()
	if self.dev then
		print("[APTX] GUI destruida")
	end
	
	self.screen:Destroy()
end

return APTX
