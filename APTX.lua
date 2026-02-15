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
	["home"] = "rbxassetid://10723407389",
	["settings"] = "rbxassetid://10734950309",
	["user"] = "rbxassetid://10747373176",
	["users"] = "rbxassetid://10747373426",
	["search"] = "rbxassetid://10734943674",
	["x"] = "rbxassetid://10747384394",
	["check"] = "rbxassetid://10709790644",
	["arrow-up"] = "rbxassetid://10709768939",
	["arrow-down"] = "rbxassetid://10709767827",
	["arrow-left"] = "rbxassetid://10709768114",
	["arrow-right"] = "rbxassetid://10709768347",
	["chevron-up"] = "rbxassetid://10709791523",
	["chevron-down"] = "rbxassetid://10709790948",
	["chevron-left"] = "rbxassetid://10709791281",
	["chevron-right"] = "rbxassetid://10709791437",
	["menu"] = "rbxassetid://10734887784",
	["plus"] = "rbxassetid://10734924532",
	["minus"] = "rbxassetid://10734896206",
	["edit"] = "rbxassetid://10734883598",
	["trash"] = "rbxassetid://10747362393",
	["save"] = "rbxassetid://10734941499",
	["download"] = "rbxassetid://10723344270",
	["upload"] = "rbxassetid://10747366434",
	["file"] = "rbxassetid://10723374641",
	["folder"] = "rbxassetid://10723387563",
	["copy"] = "rbxassetid://10709812159",
	["clipboard"] = "rbxassetid://10709799288",
	["link"] = "rbxassetid://10723426722",
	["eye"] = "rbxassetid://10723346959",
	["eye-off"] = "rbxassetid://10723346871",
	["lock"] = "rbxassetid://10723434711",
	["unlock"] = "rbxassetid://10747366027",
	["bell"] = "rbxassetid://10709775704",
	["star"] = "rbxassetid://10734966248",
	["heart"] = "rbxassetid://10723406885",
	["message"] = "rbxassetid://10734888000",
	["mail"] = "rbxassetid://10734885430",
	["phone"] = "rbxassetid://10734921524",
	["calendar"] = "rbxassetid://10709789505",
	["clock"] = "rbxassetid://10709805144",
	["map"] = "rbxassetid://10734886202",
	["image"] = "rbxassetid://10723415040",
	["camera"] = "rbxassetid://10709789686",
	["video"] = "rbxassetid://10747374938",
	["music"] = "rbxassetid://10734905958",
	["mic"] = "rbxassetid://10734888864",
	["volume"] = "rbxassetid://10747376008",
	["play"] = "rbxassetid://10734923549",
	["pause"] = "rbxassetid://10734919336",
	["stop"] = "rbxassetid://10734972621",
	["skip-forward"] = "rbxassetid://10734961809",
	["skip-back"] = "rbxassetid://10734961526",
	["repeat"] = "rbxassetid://10734933966",
	["shuffle"] = "rbxassetid://10734953451",
	["maximize"] = "rbxassetid://10734886735",
	["minimize"] = "rbxassetid://10734895698",
	["refresh"] = "rbxassetid://10734933222",
	["rotate"] = "rbxassetid://10734940654",
	["zoom-in"] = "rbxassetid://10747384552",
	["zoom-out"] = "rbxassetid://10747384679",
	["move"] = "rbxassetid://10734900011",
	["grid"] = "rbxassetid://10723404936",
	["layout"] = "rbxassetid://10723425376",
	["sidebar"] = "rbxassetid://10734954301",
	["columns"] = "rbxassetid://10709811261",
	["rows"] = "rbxassetid://10709811261",
	["list"] = "rbxassetid://10723433811",
	["filter"] = "rbxassetid://10723375128",
	["sliders"] = "rbxassetid://10734963400",
	["toggle-left"] = "rbxassetid://10734984834",
	["toggle-right"] = "rbxassetid://10734985040",
	["code"] = "rbxassetid://10709810463",
	["terminal"] = "rbxassetid://10734982144",
	["command"] = "rbxassetid://10709811365",
	["hash"] = "rbxassetid://10723405975",
	["at-sign"] = "rbxassetid://10709769286",
	["percent"] = "rbxassetid://10734919919",
	["dollar"] = "rbxassetid://10723343958",
	["shopping-cart"] = "rbxassetid://10734952479",
	["shopping-bag"] = "rbxassetid://10734952273",
	["credit-card"] = "rbxassetid://10709765398",
	["wallet"] = "rbxassetid://10747376205",
	["gift"] = "rbxassetid://10723396402",
	["tag"] = "rbxassetid://10734976528",
	["bookmark"] = "rbxassetid://10709782154",
	["flag"] = "rbxassetid://10723375890",
	["award"] = "rbxassetid://10709769406",
	["trophy"] = "rbxassetid://10747363809",
	["target"] = "rbxassetid://10734977012",
	["zap"] = "rbxassetid://10709790202",
	["trending-up"] = "rbxassetid://10747363465",
	["trending-down"] = "rbxassetid://10747363205",
	["bar-chart"] = "rbxassetid://10709773755",
	["pie-chart"] = "rbxassetid://10734921727",
	["activity"] = "rbxassetid://10709752035",
	["package"] = "rbxassetid://10734909540",
	["box"] = "rbxassetid://10709782497",
	["archive"] = "rbxassetid://10709762233",
	["inbox"] = "rbxassetid://10723415335",
	["send"] = "rbxassetid://10734943902",
	["truck"] = "rbxassetid://10747364031",
	["plane"] = "rbxassetid://10734922971",
	["globe"] = "rbxassetid://10723404337",
	["wifi"] = "rbxassetid://10747382504",
	["bluetooth"] = "rbxassetid://10709776655",
	["battery"] = "rbxassetid://10709774640",
	["smartphone"] = "rbxassetid://10734963940",
	["tablet"] = "rbxassetid://10734976394",
	["laptop"] = "rbxassetid://10723423881",
	["monitor"] = "rbxassetid://10734896881",
	["tv"] = "rbxassetid://10747364593",
	["watch"] = "rbxassetid://10747376722",
	["printer"] = "rbxassetid://10734930632",
	["keyboard"] = "rbxassetid://10723416765",
	["mouse"] = "rbxassetid://10734898592",
	["headphones"] = "rbxassetid://10723406165",
	["gamepad"] = "rbxassetid://10723395457",
	["server"] = "rbxassetid://10734949856",
	["database"] = "rbxassetid://10709818996",
	["cloud"] = "rbxassetid://10709806740",
	["hard-drive"] = "rbxassetid://10723405749",
	["cpu"] = "rbxassetid://10709813383",
	["power"] = "rbxassetid://10734930466",
	["sun"] = "rbxassetid://10734974297",
	["moon"] = "rbxassetid://10734897102",
	["cloud-rain"] = "rbxassetid://10709806277",
	["cloud-snow"] = "rbxassetid://10709806374",
	["wind"] = "rbxassetid://10747382750",
	["droplet"] = "rbxassetid://10723344432",
	["thermometer"] = "rbxassetid://10734983134",
	["smile"] = "rbxassetid://10734964441",
	["frown"] = "rbxassetid://10723394681",
	["meh"] = "rbxassetid://10734887603",
	["thumbs-up"] = "rbxassetid://10734983629",
	["thumbs-down"] = "rbxassetid://10734983359",
	["help"] = "rbxassetid://10723406988",
	["info"] = "rbxassetid://10723415903",
	["alert-triangle"] = "rbxassetid://10709753149",
	["alert-circle"] = "rbxassetid://10709752996",
	["alert-octagon"] = "rbxassetid://10709753064",
	["shield"] = "rbxassetid://10734951847",
	["shield-check"] = "rbxassetid://10734951367",
	["bug"] = "rbxassetid://10709782845",
	["key"] = "rbxassetid://10723416652",
	["tool"] = "rbxassetid://10747383470",
	["wrench"] = "rbxassetid://10747383470",
	["hammer"] = "rbxassetid://10723405360",
	["paint"] = "rbxassetid://10734910187",
	["palette"] = "rbxassetid://10734910430",
	["pen"] = "rbxassetid://10734919503",
	["pencil"] = "rbxassetid://10734919691",
	["feather"] = "rbxassetid://10723354671",
	["book"] = "rbxassetid://10709781824",
	["book-open"] = "rbxassetid://10709781717",
	["briefcase"] = "rbxassetid://10709782662",
	["compass"] = "rbxassetid://10709811445",
	["coffee"] = "rbxassetid://10709810814",
	["pizza"] = "rbxassetid://10734922774"
}

local function geticon(name)
	return icons[name] or nil
end

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
	self.iconmode = config.icons or "default"
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
	
	local viewport = workspace.CurrentCamera.ViewportSize
	local basewidth = 600
	local baseheight = 400
	local scale = math.min(viewport.X / 800, viewport.Y / 600, 1)
	local width = math.min(basewidth * 0.85 * scale, viewport.X * 0.9)
	local height = math.min(baseheight * 0.85 * scale, viewport.Y * 0.8)
	
	self.scale = scale
	
	self.main = create("Frame", {
		Size = UDim2.new(0, width, 0, height),
		Position = UDim2.new(0.5, -width/2, 0.5, -height/2),
		BackgroundColor3 = colors.bg,
		BorderSizePixel = 0,
		Parent = self.screen
	})
	corner(self.main, 12 * scale)
	
	create("UIStroke", {
		Color = colors.border,
		Thickness = 1,
		Parent = self.main
	})
	
	local topbarheight = math.max(35, 45 * scale)
	
	self.topbar = create("Frame", {
		Size = UDim2.new(1, 0, 0, topbarheight),
		BackgroundColor3 = colors.topbar,
		BorderSizePixel = 0,
		Parent = self.main
	})
	corner(self.topbar, 12 * scale)
	
	create("Frame", {
		Size = UDim2.new(1, 0, 0, 12 * scale),
		Position = UDim2.new(0, 0, 1, -12 * scale),
		BackgroundColor3 = colors.topbar,
		BorderSizePixel = 0,
		Parent = self.topbar
	})
	
	self.titlelabel = create("TextLabel", {
		Size = UDim2.new(1, -60 * scale, 1, 0),
		Position = UDim2.new(0, 15 * scale, 0, 0),
		BackgroundTransparency = 1,
		Text = self.title,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamBold,
		TextSize = math.max(12, 16 * scale),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.topbar
	})
	
	local closesize = math.max(24, 32 * scale)
	
	local close = create("ImageButton", {
		Size = UDim2.new(0, closesize, 0, closesize),
		Position = UDim2.new(1, -(closesize + 8 * scale), 0.5, -closesize/2),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Image = geticon("x") or "",
		ImageColor3 = colors.text,
		Parent = self.topbar
	})
	corner(close, 8 * scale)
	
	close.MouseEnter:Connect(function() tween(close, {BackgroundColor3 = colors.hover}) end)
	close.MouseLeave:Connect(function() tween(close, {BackgroundColor3 = colors.element}) end)
	close.MouseButton1Click:Connect(function() self:destroy() end)
	
	local sidebarwidth = math.max(120, 160 * scale)
	
	self.sidebar = create("Frame", {
		Size = UDim2.new(0, sidebarwidth, 1, -topbarheight),
		Position = UDim2.new(0, 0, 0, topbarheight),
		BackgroundColor3 = colors.panel,
		BorderSizePixel = 0,
		Parent = self.main
	})
	
	self.sidebarscroll = create("ScrollingFrame", {
		Size = UDim2.new(1, -10 * scale, 1, -10 * scale),
		Position = UDim2.new(0, 5 * scale, 0, 5 * scale),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = math.max(3, 4 * scale),
		ScrollBarImageColor3 = colors.border,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = self.sidebar
	})
	
	local sidelayout = create("UIListLayout", {
		Padding = UDim.new(0, 8 * scale),
		Parent = self.sidebarscroll
	})
	
	sidelayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self.sidebarscroll.CanvasSize = UDim2.new(0, 0, 0, sidelayout.AbsoluteContentSize.Y + 10 * scale)
	end)
	
	self.content = create("Frame", {
		Size = UDim2.new(1, -sidebarwidth, 1, -topbarheight),
		Position = UDim2.new(0, sidebarwidth, 0, topbarheight),
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
		Size = UDim2.new(0, 120 * self.scale, 0, 40 * self.scale),
		Position = UDim2.new(1, -130 * self.scale, 0, 10 * self.scale),
		BackgroundColor3 = colors.topbar,
		BorderSizePixel = 0,
		Text = "Toggle GUI",
		TextColor3 = colors.text,
		Font = Enum.Font.GothamBold,
		TextSize = math.max(10, 14 * self.scale),
		Parent = self.screen
	})
	corner(btn, 8 * self.scale)
	
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
	
	local btnheight = math.max(32, 42 * self.scale)
	
	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 0, btnheight),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Text = "",
		Parent = self.sidebarscroll
	})
	corner(btn, 8 * self.scale)
	
	local iconsize = math.max(16, 20 * self.scale)
	local iconid = geticon(icon or texto:lower())
	if iconid then
		create("ImageLabel", {
			Size = UDim2.new(0, iconsize, 0, iconsize),
			Position = UDim2.new(0, 10 * self.scale, 0.5, -iconsize/2),
			BackgroundTransparency = 1,
			Image = iconid,
			ImageColor3 = colors.text,
			Parent = btn
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(1, -45 * self.scale, 1, 0),
		Position = UDim2.new(0, 40 * self.scale, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = math.max(10, 14 * self.scale),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = btn
	})
	
	section.button = btn
	
	local container = create("ScrollingFrame", {
		Size = UDim2.new(1, -20 * self.scale, 1, -20 * self.scale),
		Position = UDim2.new(0, 10 * self.scale, 0, 10 * self.scale),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = math.max(4, 6 * self.scale),
		ScrollBarImageColor3 = colors.border,
		Visible = false,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = self.content
	})
	
	local layout = create("UIListLayout", {
		Padding = UDim.new(0, 12 * self.scale),
		Parent = container
	})
	
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12 * self.scale)
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
	local btnheight = math.max(35, 45 * self.scale)
	
	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 0, btnheight),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Text = "",
		Parent = section.container
	})
	corner(btn, 8 * self.scale)
	
	local iconsize = math.max(18, 22 * self.scale)
	local iconid = geticon(icon)
	if iconid then
		create("ImageLabel", {
			Size = UDim2.new(0, iconsize, 0, iconsize),
			Position = UDim2.new(0, 12 * self.scale, 0.5, -iconsize/2),
			BackgroundTransparency = 1,
			Image = iconid,
			ImageColor3 = colors.text,
			Parent = btn
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(1, iconid and -50 * self.scale or -20 * self.scale, 1, 0),
		Position = UDim2.new(0, iconid and 45 * self.scale or 15 * self.scale, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = math.max(10, 14 * self.scale),
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
	local frameheight = math.max(55, 70 * self.scale)
	
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, frameheight),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Parent = section.container
	})
	corner(frame, 8 * self.scale)
	
	local headerheight = math.max(22, 30 * self.scale)
	
	local header = create("Frame", {
		Size = UDim2.new(1, 0, 0, headerheight),
		BackgroundTransparency = 1,
		Parent = frame
	})
	
	local iconsize = math.max(16, 20 * self.scale)
	local iconid = geticon(icon)
	if iconid then
		create("ImageLabel", {
			Size = UDim2.new(0, iconsize, 0, iconsize),
			Position = UDim2.new(0, 12 * self.scale, 0.5, -iconsize/2),
			BackgroundTransparency = 1,
			Image = iconid,
			ImageColor3 = colors.text,
			Parent = header
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(1, -100 * self.scale, 1, 0),
		Position = UDim2.new(0, iconid and 40 * self.scale or 15 * self.scale, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = math.max(10, 14 * self.scale),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header
	})
	
	local valuelabel = create("TextLabel", {
		Size = UDim2.new(0, 60 * self.scale, 1, 0),
		Position = UDim2.new(1, -70 * self.scale, 0, 0),
		BackgroundTransparency = 1,
		Text = tostring(default or min),
		TextColor3 = colors.accent,
		Font = Enum.Font.GothamBold,
		TextSize = math.max(10, 14 * self.scale),
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = header
	})
	
	local trackheight = math.max(4, 6 * self.scale)
	
	local track = create("Frame", {
		Size = UDim2.new(1, -30 * self.scale, 0, trackheight),
		Position = UDim2.new(0, 15 * self.scale, 1, -20 * self.scale),
		BackgroundColor3 = colors.bg,
		BorderSizePixel = 0,
		Parent = frame
	})
	corner(track, 3 * self.scale)
	
	local fill = create("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = colors.accent,
		BorderSizePixel = 0,
		Parent = track
	})
	corner(fill, 3 * self.scale)
	
	local thumbsize = math.max(14, 18 * self.scale)
	
	local thumb = create("Frame", {
		Size = UDim2.new(0, thumbsize, 0, thumbsize),
		Position = UDim2.new(1, -thumbsize/2, 0.5, -thumbsize/2),
		BackgroundColor3 = colors.text,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = fill
	})
	corner(thumb, thumbsize/2)
	
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
	local frameheight = math.max(35, 45 * self.scale)
	
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, frameheight),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Parent = section.container
	})
	corner(frame, 8 * self.scale)
	
	local iconsize = math.max(16, 20 * self.scale)
	local iconid = geticon(icon)
	if iconid then
		create("ImageLabel", {
			Size = UDim2.new(0, iconsize, 0, iconsize),
			Position = UDim2.new(0, 12 * self.scale, 0.5, -iconsize/2),
			BackgroundTransparency = 1,
			Image = iconid,
			ImageColor3 = colors.text,
			Parent = frame
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(0, 150 * self.scale, 1, 0),
		Position = UDim2.new(0, iconid and 40 * self.scale or 15 * self.scale, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = math.max(10, 14 * self.scale),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})
	
	local btnwidth = math.max(120, 180 * self.scale)
	local btnheight = math.max(24, 32 * self.scale)
	
	local btn = create("TextButton", {
		Size = UDim2.new(0, btnwidth, 0, btnheight),
		Position = UDim2.new(1, -(btnwidth + 10 * self.scale), 0.5, -btnheight/2),
		BackgroundColor3 = colors.bg,
		BorderSizePixel = 0,
		Text = "  " .. (default or placeholder or "Seleccionar"),
		TextColor3 = colors.subtext,
		Font = Enum.Font.Gotham,
		TextSize = math.max(9, 13 * self.scale),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})
	corner(btn, 6 * self.scale)
	
	local arrow = create("TextLabel", {
		Size = UDim2.new(0, 30 * self.scale, 1, 0),
		Position = UDim2.new(1, -30 * self.scale, 0, 0),
		BackgroundTransparency = 1,
		Text = "▼",
		TextColor3 = colors.subtext,
		Font = Enum.Font.Gotham,
		TextSize = math.max(8, 10 * self.scale),
		Parent = btn
	})
	
	local menucontainer = create("Frame", {
		Size = UDim2.new(0, btnwidth, 0, 0),
		Position = UDim2.new(1, -(btnwidth + 10 * self.scale), 1, 5 * self.scale),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 100,
		ClipsDescendants = false,
		Parent = frame
	})
	
	local menu = create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = colors.panel,
		BorderSizePixel = 0,
		ScrollBarThickness = math.max(3, 4 * self.scale),
		ScrollBarImageColor3 = colors.border,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ZIndex = 100,
		Parent = menucontainer
	})
	corner(menu, 6 * self.scale)
	
	create("UIStroke", {
		Color = colors.border,
		Thickness = 1,
		Parent = menu
	})
	
	local menulist = create("UIListLayout", {
		Padding = UDim.new(0, 2 * self.scale),
		Parent = menu
	})
	
	menulist:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		menu.CanvasSize = UDim2.new(0, 0, 0, menulist.AbsoluteContentSize.Y)
	end)
	
	local open = false
	local selected = default
	
	local optheight = math.max(24, 32 * self.scale)
	
	for _, opt in ipairs(options) do
		local optbtn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, optheight),
			BackgroundColor3 = colors.panel,
			BorderSizePixel = 0,
			Text = "  " .. opt,
			TextColor3 = colors.text,
			Font = Enum.Font.Gotham,
			TextSize = math.max(9, 13 * self.scale),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 100,
			Parent = menu
		})
		
		optbtn.MouseEnter:Connect(function() 
			tween(optbtn, {BackgroundColor3 = colors.hover}) 
		end)
		
		optbtn.MouseLeave:Connect(function() 
			tween(optbtn, {BackgroundColor3 = colors.panel}) 
		end)
		
		optbtn.MouseButton1Click:Connect(function()
			selected = opt
			btn.Text = "  " .. opt
			menucontainer.Visible = false
			open = false
			arrow.Text = "▼"
			if callback then callback(opt) end
			if self.dev then print("[APTX] Selección: " .. opt) end
		end)
	end
	
	btn.MouseButton1Click:Connect(function()
		open = not open
		menucontainer.Visible = open
		arrow.Text = open and "▲" or "▼"
		if open then 
			local maxheight = math.min(#options * (optheight + 2 * self.scale), 180 * self.scale)
			menucontainer.Size = UDim2.new(0, btnwidth, 0, maxheight)
		end
	end)
	
	if self.dev then print("[APTX] Dropdown: " .. texto) end
	
	return {
		get = function() return selected end,
		set = function(val) 
			selected = val 
			btn.Text = "  " .. val 
		end
	}
end

APTX.Menu = APTX.Dropdown

function APTX:Toggle(section, texto, icon, default, callback)
	local frameheight = math.max(35, 45 * self.scale)
	
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, frameheight),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Parent = section.container
	})
	corner(frame, 8 * self.scale)
	
	local iconsize = math.max(16, 20 * self.scale)
	local iconid = geticon(icon)
	if iconid then
		create("ImageLabel", {
			Size = UDim2.new(0, iconsize, 0, iconsize),
			Position = UDim2.new(0, 12 * self.scale, 0.5, -iconsize/2),
			BackgroundTransparency = 1,
			Image = iconid,
			ImageColor3 = colors.text,
			Parent = frame
		})
	end
	
	create("TextLabel", {
		Size = UDim2.new(1, -100 * self.scale, 1, 0),
		Position = UDim2.new(0, iconid and 40 * self.scale or 15 * self.scale, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.GothamMedium,
		TextSize = math.max(10, 14 * self.scale),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})
	
	local togglewidth = math.max(36, 48 * self.scale)
	local toggleheight = math.max(20, 26 * self.scale)
	
	local toggle = create("TextButton", {
		Size = UDim2.new(0, togglewidth, 0, toggleheight),
		Position = UDim2.new(1, -(togglewidth + 12 * self.scale), 0.5, -toggleheight/2),
		BackgroundColor3 = default and colors.accent or colors.bg,
		BorderSizePixel = 0,
		Text = "",
		Parent = frame
	})
	corner(toggle, toggleheight/2)
	
	local knobsize = math.max(16, 20 * self.scale)
	
	local knob = create("Frame", {
		Size = UDim2.new(0, knobsize, 0, knobsize),
		Position = default and UDim2.new(1, -(knobsize + 3 * self.scale), 0.5, -knobsize/2) or UDim2.new(0, 3 * self.scale, 0.5, -knobsize/2),
		BackgroundColor3 = colors.text,
		BorderSizePixel = 0,
		Parent = toggle
	})
	corner(knob, knobsize/2)
	
	local state = default or false
	
	toggle.MouseButton1Click:Connect(function()
		state = not state
		tween(toggle, {BackgroundColor3 = state and colors.accent or colors.bg})
		tween(knob, {Position = state and UDim2.new(1, -(knobsize + 3 * self.scale), 0.5, -knobsize/2) or UDim2.new(0, 3 * self.scale, 0.5, -knobsize/2)})
		if callback then callback(state) end
		if self.dev then print("[APTX] Toggle: " .. texto .. " = " .. tostring(state)) end
	end)
	
	if self.dev then print("[APTX] Toggle: " .. texto) end
	
	return {
		get = function() return state end,
		set = function(val)
			state = val
			toggle.BackgroundColor3 = state and colors.accent or colors.bg
			knob.Position = state and UDim2.new(1, -(knobsize + 3 * self.scale), 0.5, -knobsize/2) or UDim2.new(0, 3 * self.scale, 0.5, -knobsize/2)
		end
	}
end

function APTX:Label(section, texto, icon)
	local frameheight = math.max(28, 35 * self.scale)
	
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, frameheight),
		BackgroundColor3 = colors.element,
		BorderSizePixel = 0,
		Parent = section.container
	})
	corner(frame, 8 * self.scale)
	
	local iconsize = math.max(16, 20 * self.scale)
	local iconid = geticon(icon)
	if iconid then
		create("ImageLabel", {
			Size = UDim2.new(0, iconsize, 0, iconsize),
			Position = UDim2.new(0, 12 * self.scale, 0.5, -iconsize/2),
			BackgroundTransparency = 1,
			Image = iconid,
			ImageColor3 = colors.text,
			Parent = frame
		})
	end
	
	local label = create("TextLabel", {
		Size = UDim2.new(1, iconid and -45 * self.scale or -20 * self.scale, 1, 0),
		Position = UDim2.new(0, iconid and 40 * self.scale or 15 * self.scale, 0, 0),
		BackgroundTransparency = 1,
		Text = texto,
		TextColor3 = colors.text,
		Font = Enum.Font.Gotham,
		TextSize = math.max(10, 14 * self.scale),
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
