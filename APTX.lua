local APTX = {}
APTX.__index = APTX

local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local colors = {
	bg = Color3.fromRGB(15, 15, 15),
	topbar = Color3.fromRGB(20, 20, 20),
	panel = Color3.fromRGB(18, 18, 18),
	element = Color3.fromRGB(25, 25, 25),
	hover = Color3.fromRGB(35, 35, 35),
	active = Color3.fromRGB(45, 45, 45),
	accent = Color3.fromRGB(70, 130, 255),
	border = Color3.fromRGB(40, 40, 40),
	text = Color3.fromRGB(255, 255, 255),
	subtext = Color3.fromRGB(180, 180, 180)
}

local icons = {
	default = {
		home = "rbxassetid://7733955740",
		settings = "rbxassetid://7733674079",
		stats = "rbxassetid://7743878857",
		info = "rbxassetid://7733920644",
		close = "rbxassetid://7743878496"
	}
}

local function create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		if k ~= "Parent" then
			obj[k] = v
		end
	end
	if props.Parent then
		obj.Parent = props.Parent
	end
	return obj
end

local function corner(parent, radius)
	return create("UICorner", {
		CornerRadius = UDim.new(0, radius or 8),
		Parent = parent
	})
end

local function tween(obj, props, time)
	ts:Create(obj, TweenInfo.new(time or 0.2), props):Play()
end

function APTX:Config(config)
	local self = setmetatable({}, APTX)
	
	self.title = config.title or "APTX"
	self.drag = config.draggable ~= false
	self.dev = config.devmode or false
	self.iconset = config.icons == "custom" and config.customicons or icons.default
	self.hidebutton = config.hidebutton or false
	self.sections = {}
	self.current = nil
	self.visible = true
	
	if self.dev then print("[APTX] Inicializando") end
	
	self.screen = create("ScreenGui", {
		Name = "APTX",
		ResetOnSpawn = false,
		Parent = player:WaitForChild("PlayerGui")
	})
	
	self.main = create("Frame", {
		Size = UDim2.new(0, 700, 0, 450),
		Position = UDim2.new(0.5, -350, 0.5, -225),
		BackgroundColor3 = colors.bg,
		BorderSizePixel = 0,
		Parent = self.screen
	})
	corner(self.main, 12)
	
	create("UIStroke", {
		Color = colors.border,
		Thickness = 1,
		Parent = self.main
	})
	
	self.topbar = create("Frame", {
		Size = UDim2.new(1, 0, 0, 45),
		BackgroundColor3 = colors.topbar,
		BorderSizePixel = 0,
		Parent = self.main
	})
	corner(self.topbar, 12)
	
	create("Frame", {
		Size = UDim2.new(1, 0, 0, 12),
		Position = UDim2.new(0, 0, 1, -12),
		BackgroundColor3 = colors.topbar,
		BorderSizePixel = 0,
		Parent = self.topbar
	})
	
	self.titlelabel = create("TextLabel", {
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 15, 0, 0),
		BackgroundTransparency = 1,
		Text = self.title,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.topbar
	})
	
	local close = create("ImageButton", {
		Size = UDim2.new(0, 32, 0, 32),
		Position = UDim2.new(1, -40, 0.5, -16),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Image = self.iconset.close or icons.default.close,
		ImageColor3 = colors.text,
		Parent = self.topbar
	})
	corner(close, 8)
	
	close.MouseEnter:Connect(function() tween(close, {BackgroundColor3 = colors.hover}) end)
	close.MouseLeave:Connect(function() tween(close, {BackgroundColor3 = colors.element}) end)
	close.MouseButton1Click:Connect(function() self:destroy() end)
	
	self.sidebar = create("Frame", {
		Size = UDim2.new(0, 180, 1, -45),
		Position = UDim2.new(0, 0, 0, 45),
		BackgroundColor3 = colors.panel,
		BorderSizePixel = 0,
		Parent = self.main
	})
	
	self.sidebarscroll = create("ScrollingFrame", {
		Size = UDim2.new(1, -10, 1, -10),
		Position = UDim2.new(0, 5, 0, 5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = colors.border,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = self.sidebar
	})
	
	create("UIListLayout", {
		Padding = UDim.new(0, 8),
		Parent = self.sidebarscroll
	})
	
	self.content = create("Frame", {
		Size = UDim2.new(1, -180, 1, -45),
		Position = UDim2.new(0, 180, 0, 45),
		BackgroundColor3 = colors.bg,
		BorderSizePixel = 0,
		Parent = self.main
	})
	
	if self.drag then self:makedrag() end
	if self.hidebutton then self:makehide() end
	
	return self
end

function APTX:makedrag()
	local dragging, dragstart, startpos = false, nil, nil
	
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
			self.main.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
		end
	end)
end

function APTX:makehide()
	local btn = create("TextButton", {
		Size = UDim2.new(0, 120, 0, 40),
		Position = UDim2.new(1, -130, 0, 10),
		BackgroundColor3 = colors.topbar,
		BorderSizePixel = 0,
		Text = "Toggle GUI",
		TextColor3 = colors.text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Parent = self.screen
	})
	corner(btn, 8)
	
	create("UIStroke", {
		Color = colors.border,
		Thickness = 1,
		Parent = btn
	})
	
	btn.MouseButton1Click:Connect(function()
		self.visible = not self.visible
		self.main.Visible = self.visible
		tween(btn, {BackgroundColor3 = self.visible and colors.topbar or colors.element})
	end)
end

function APTX:Section(texto, icon, default)
	local section = {name = texto, container = nil, button = nil}
	
	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Text = "",
		Parent = self.sidebarscroll
	})
	corner(btn, 8)
	
	if icon or self.iconset[texto:lower()] then
		create("ImageLabel", {
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, 10, 0.5, -10),
			BackgroundTransparency = 1,
			Image = icon or self.iconset[texto:lower()] or "",
			ImageColor3 = colors.text,
			Parent = btn
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(1, -45, 1, 0),
		Position = UDim2.new(0, 40, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = btn
	})
	
	section.button = btn
	
	local container = create("ScrollingFrame", {
		Size = UDim2.new(1, -20, 1, -20),
		Position = UDim2.new(0, 10, 0, 10),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = colors.border,
		Visible = false,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = self.content
	})
	
	local layout = create("UIListLayout", {
		Padding = UDim.new(0, 12),
		Parent = container
	})
	
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
	end)
	
	section.container = container
	table.insert(self.sections, section)
	
	btn.MouseEnter:Connect(function()
		if self.current ~= section then
			tween(btn, {BackgroundColor3 = colors.hover})
		end
	end)
	
	btn.MouseLeave:Connect(function()
		if self.current ~= section then
			tween(btn, {BackgroundColor3 = colors.element})
		end
	end)
	
	btn.MouseButton1Click:Connect(function() self:load(section) end)
	
	if default or #self.sections == 1 then self:load(section) end
	if self.dev then print("[APTX] Sección: " .. texto) end
	
	return section
end

function APTX:load(section)
	for _, s in ipairs(self.sections) do
		s.container.Visible = false
		tween(s.button, {BackgroundColor3 = colors.element})
	end
	section.container.Visible = true
	tween(section.button, {BackgroundColor3 = colors.active})
	self.current = section
end

function APTX:Button(section, texto, icon, callback)
	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 45),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Text = "",
		Parent = section.container
	})
	corner(btn, 8)
	
	if icon then
		create("ImageLabel", {
			Size = UDim2.new(0, 22, 0, 22),
			Position = UDim2.new(0, 12, 0.5, -11),
			BackgroundTransparency = 1,
			Image = icon,
			ImageColor3 = colors.text,
			Parent = btn
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(1, icon and -50 or -20, 1, 0),
		Position = UDim2.new(0, icon and 45 or 15, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = btn
	})
	
	btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = colors.hover}) end)
	btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = colors.element}) end)
	
	btn.MouseButton1Click:Connect(function()
		tween(btn, {BackgroundColor3 = colors.active})
		wait(0.1)
		tween(btn, {BackgroundColor3 = colors.element})
		if callback then callback() end
		if self.dev then print("[APTX] Botón: " .. texto) end
	end)
	
	return btn
end

function APTX:Slider(section, texto, icon, min, max, default, callback)
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 70),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Parent = section.container
	})
	corner(frame, 8)
	
	local header = create("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Parent = frame
	})
	
	if icon then
		create("ImageLabel", {
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, 12, 0.5, -10),
			BackgroundTransparency = 1,
			Image = icon,
			ImageColor3 = colors.text,
			Parent = header
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(1, -100, 1, 0),
		Position = UDim2.new(0, icon and 40 or 15, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header
	})
	
	local valuelabel = create("TextLabel", {
		Size = UDim2.new(0, 60, 1, 0),
		Position = UDim2.new(1, -70, 0, 0),
		BackgroundTransparency = 1,
		Text = tostring(default or min),
		TextColor3 = colors.accent,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = header
	})
	
	local track = create("Frame", {
		Size = UDim2.new(1, -30, 0, 6),
		Position = UDim2.new(0, 15, 1, -25),
		BackgroundColor3 = colors.bg,
		BorderSizePixel = 0,
		Parent = frame
	})
	corner(track, 3)
	
	local fill = create("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = colors.accent,
		BorderSizePixel = 0,
		Parent = track
	})
	corner(fill, 3)
	
	local thumb = create("Frame", {
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(1, -9, 0.5, -9),
		BackgroundColor3 = colors.text,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = fill
	})
	corner(thumb, 9)
	
	local dragging = false
	local current = default or min
	
	local function update(input)
		local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		current = math.floor(min + (max - min) * pos)
		valuelabel.Text = tostring(current)
		fill.Size = UDim2.new(pos, 0, 1, 0)
		if callback then callback(current) end
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
	
	if self.dev then print("[APTX] Slider: " .. texto) end
	
	return {
		get = function() return current end,
		set = function(val)
			current = math.clamp(val, min, max)
			valuelabel.Text = tostring(current)
			local pos = (current - min) / (max - min)
			fill.Size = UDim2.new(pos, 0, 1, 0)
		end
	}
end

function APTX:Dropdown(section, texto, placeholder, icon, options, default, callback)
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 45),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Parent = section.container
	})
	corner(frame, 8)
	
	if icon then
		create("ImageLabel", {
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, 12, 0.5, -10),
			BackgroundTransparency = 1,
			Image = icon,
			ImageColor3 = colors.text,
			Parent = frame
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(0, 200, 1, 0),
		Position = UDim2.new(0, icon and 40 or 15, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})
	
	local btn = create("TextButton", {
		Size = UDim2.new(0, 200, 0, 32),
		Position = UDim2.new(1, -210, 0.5, -16),
		BackgroundColor3 = colors.bg,
		BorderSizePixel = 0,
		Text = default or placeholder or "Seleccionar",
		TextColor3 = colors.subtext,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})
	corner(btn, 6)
	
	create("UIPadding", {
		PaddingLeft = UDim.new(0, 10),
		Parent = btn
	})
	
	create("TextLabel", {
		Size = UDim2.new(0, 30, 1, 0),
		Position = UDim2.new(1, -30, 0, 0),
		BackgroundTransparency = 1,
		Text = "▼",
		TextColor3 = colors.subtext,
		Font = Enum.Font.Gotham,
		TextSize = 10,
		Parent = btn
	})
	
	local menu = create("Frame", {
		Size = UDim2.new(0, 200, 0, 0),
		Position = UDim2.new(1, -210, 1, 5),
		BackgroundColor3 = colors.panel,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 10,
		Parent = frame
	})
	corner(menu, 6)
	
	create("UIStroke", {
		Color = colors.border,
		Thickness = 1,
		Parent = menu
	})
	
	create("UIListLayout", {
		Padding = UDim.new(0, 2),
		Parent = menu
	})
	
	local open = false
	local selected = default
	
	for _, opt in ipairs(options) do
		local optbtn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = colors.panel,
			BorderSizePixel = 0,
			Text = opt,
			TextColor3 = colors.text,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = menu
		})
		
		create("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			Parent = optbtn
		})
		
		optbtn.MouseEnter:Connect(function() tween(optbtn, {BackgroundColor3 = colors.hover}) end)
		optbtn.MouseLeave:Connect(function() tween(optbtn, {BackgroundColor3 = colors.panel}) end)
		
		optbtn.MouseButton1Click:Connect(function()
			selected = opt
			btn.Text = opt
			menu.Visible = false
			open = false
			if callback then callback(opt) end
			if self.dev then print("[APTX] Selección: " .. opt) end
		end)
	end
	
	btn.MouseButton1Click:Connect(function()
		open = not open
		menu.Visible = open
		if open then menu.Size = UDim2.new(0, 200, 0, math.min(#options * 34, 200)) end
	end)
	
	if self.dev then print("[APTX] Dropdown: " .. texto) end
	
	return {
		get = function() return selected end,
		set = function(val) selected = val btn.Text = val end
	}
end

function APTX:Toggle(section, texto, icon, default, callback)
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 45),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Parent = section.container
	})
	corner(frame, 8)
	
	if icon then
		create("ImageLabel", {
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, 12, 0.5, -10),
			BackgroundTransparency = 1,
			Image = icon,
			ImageColor3 = colors.text,
			Parent = frame
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(1, -100, 1, 0),
		Position = UDim2.new(0, icon and 40 or 15, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})
	
	local toggle = create("TextButton", {
		Size = UDim2.new(0, 48, 0, 26),
		Position = UDim2.new(1, -60, 0.5, -13),
		BackgroundColor3 = default and colors.accent or colors.bg,
		BorderSizePixel = 0,
		Text = "",
		Parent = frame
	})
	corner(toggle, 13)
	
	local knob = create("Frame", {
		Size = UDim2.new(0, 20, 0, 20),
		Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
		BackgroundColor3 = colors.text,
		BorderSizePixel = 0,
		Parent = toggle
	})
	corner(knob, 10)
	
	local state = default or false
	
	toggle.MouseButton1Click:Connect(function()
		state = not state
		tween(toggle, {BackgroundColor3 = state and colors.accent or colors.bg})
		tween(knob, {Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)})
		if callback then callback(state) end
		if self.dev then print("[APTX] Toggle: " .. texto .. " = " .. tostring(state)) end
	end)
	
	if self.dev then print("[APTX] Toggle: " .. texto) end
	
	return {
		get = function() return state end,
		set = function(val)
			state = val
			toggle.BackgroundColor3 = state and colors.accent or colors.bg
			knob.Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
		end
	}
end

function APTX:Label(section, texto, icon)
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Parent = section.container
	})
	corner(frame, 8)
	
	if icon then
		create("ImageLabel", {
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, 12, 0.5, -10),
			BackgroundTransparency = 1,
			Image = icon,
			ImageColor3 = colors.text,
			Parent = frame
		})
	end
	
	local label = create("TextLabel", {
		Size = UDim2.new(1, icon and -45 or -20, 1, 0),
		Position = UDim2.new(0, icon and 40 or 15, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})
	
	return {
		set = function(val) label.Text = val end
	}
end

function APTX:destroy()
	if self.dev then print("[APTX] Destruido") end
	self.screen:Destroy()
end

return APTX
