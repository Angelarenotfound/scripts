local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local AE = {}
local internal = {sections = {}, currentSection = nil, firstSection = nil}
local initialized = false
local notificationQueue = {}
local maxNotificationsVisible = 5
local activeNotifications = {}

AE.config = {
    notificationPosition = "topright",
    cornerRadius = UDim.new(0, 8),
    font = Enum.Font.GothamBold,
    notificationSound = nil,
    notificationVolume = 0.5,
    theme = {
        primary = Color3.fromRGB(50, 50, 50),
        secondary = Color3.fromRGB(30, 30, 30),
        accent = Color3.fromRGB(67, 160, 71),
        success = Color3.fromRGB(67, 160, 71),
        warning = Color3.fromRGB(251, 140, 0),
        error = Color3.fromRGB(229, 57, 53),
        highlight = Color3.fromRGB(70, 70, 70),
        text = Color3.fromRGB(255, 255, 255),
        subtext = Color3.fromRGB(180, 180, 180)
    }
}

local function createTween(i,p,d,s,di)
    return TweenService:Create(i,TweenInfo.new(d or 0.3,s or Enum.EasingStyle.Quint,di or Enum.EasingDirection.Out),p)
end

local function createRippleEffect(b,c)
    local r = Instance.new("Frame")
    r.BackgroundColor3 = c or Color3.fromRGB(255,255,255)
    r.BackgroundTransparency = 0.8
    r.BorderSizePixel = 0
    r.AnchorPoint = Vector2.new(0.5,0.5)
    r.Size = UDim2.new(0,0,0,0)
    r.Parent = b
    local co = Instance.new("UICorner")
    co.CornerRadius = UDim.new(1,0)
    co.Parent = r
    local m = UserInputService.TouchEnabled and not UserInputService.MouseEnabled and Vector2.new(b.AbsoluteSize.X/2,b.AbsoluteSize.Y/2) or UserInputService:GetMouseLocation()-Vector2.new(b.AbsolutePosition.X,b.AbsolutePosition.Y)
    r.Position = UDim2.new(0,m.X,0,m.Y)
    local ms = math.max(b.AbsoluteSize.X,b.AbsoluteSize.Y)*2
    local at = createTween(r,{Size=UDim2.new(0,ms,0,ms),BackgroundTransparency=1},0.5)
    at:Play()
    at.Completed:Connect(function() r:Destroy() end)
end

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
end

local function createContainer(m,p)
    local pos,ali
    if p.notificationPosition == "topright" then pos,ali=UDim2.new(1,-20,0,20),Enum.VerticalAlignment.Top
    elseif p.notificationPosition == "topleft" then pos,ali=UDim2.new(0,20,0,20),Enum.VerticalAlignment.Top
    elseif p.notificationPosition == "bottomright" then pos,ali=UDim2.new(1,-20,1,-20),Enum.VerticalAlignment.Bottom
    elseif p.notificationPosition == "bottomleft" then pos,ali=UDim2.new(0,20,1,-20),Enum.VerticalAlignment.Bottom
    else pos,ali=UDim2.new(1,-20,0,20),Enum.VerticalAlignment.Top end
    m.NotificationsContainer = Instance.new("Frame")
    m.NotificationsContainer.Name = "NotificationsContainer"
    m.NotificationsContainer.Size = UDim2.new(0,isMobile() and 250 or 300,1,-40)
    m.NotificationsContainer.Position = pos
    m.NotificationsContainer.BackgroundTransparency = 1
    m.NotificationsContainer.Parent = m.ScreenGui
    local ll = Instance.new("UIListLayout")
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0,10)
    ll.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ll.VerticalAlignment = ali
    ll.Parent = m.NotificationsContainer
end

local function processQueue()
    if #notificationQueue > 0 and #activeNotifications < maxNotificationsVisible then
        local n = table.remove(notificationQueue,1)
        table.insert(activeNotifications,n)
        n:Show()
    end
end

local function AE_Notify(m,t,d,nt,o)
    o = o or {}
    local n = {
        mainGui = m,
        title = t,
        description = d,
        notificationType = nt,
        options = o,
        config = AE.config,
        frame = nil,
        isVisible = false,
        isDestroyed = false
    }
    function n:Show()
        if self.isDestroyed then return end
        local c = self.notificationType == "success" and self.config.theme.success or self.notificationType == "warning" and self.config.theme.warning or self.notificationType == "error" and self.config.theme.error or self.config.theme.accent
        local h = self.options.height or (self.options.buttons and 120 or 80)
        if isMobile() then h = h * 1.2 end
        self.frame = Instance.new("Frame")
        self.frame.Size = UDim2.new(1,0,0,h)
        self.frame.BackgroundColor3 = self.config.theme.secondary
        self.frame.BorderSizePixel = 0
        self.frame.Position = UDim2.new(1,300,0,0)
        self.frame.AnchorPoint = Vector2.new(0,0)
        self.frame.Parent = self.mainGui.NotificationsContainer
        local s = Instance.new("ImageLabel")
        s.Size = UDim2.new(1,40,1,40)
        s.Position = UDim2.new(0.5,0,0.5,0)
        s.AnchorPoint = Vector2.new(0.5,0.5)
        s.BackgroundTransparency = 1
        s.Image = "rbxassetid://6014261993"
        s.ImageColor3 = Color3.new(0,0,0)
        s.ImageTransparency = 0.5
        s.ScaleType = Enum.ScaleType.Slice
        s.SliceCenter = Rect.new(49,49,450,450)
        s.ZIndex = self.frame.ZIndex-1
        s.Parent = self.frame
        local co = Instance.new("UICorner")
        co.CornerRadius = self.config.cornerRadius
        co.Parent = self.frame
        local tb = Instance.new("Frame")
        tb.Size = UDim2.new(1,0,0,6)
        tb.BackgroundColor3 = c
        tb.BorderSizePixel = 0
        tb.Parent = self.frame
        local tc = Instance.new("UICorner")
        tc.CornerRadius = UDim.new(0,4)
        tc.Parent = tb
        local ts,ds = isMobile() and 18 or 16,isMobile() and 16 or 14
        if self.options.icon then
            local is = isMobile() and 28 or 24
            local ic = Instance.new("ImageLabel")
            ic.Size = UDim2.new(0,is,0,is)
            ic.Position = UDim2.new(0,10,0,15)
            ic.BackgroundTransparency = 1
            ic.Image = self.options.icon
            ic.ImageColor3 = c
            ic.Parent = self.frame
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1,-80,0,24)
            tl.Position = UDim2.new(0,is+20,0,15)
            tl.BackgroundTransparency = 1
            tl.Font = self.config.font
            tl.TextSize = ts
            tl.TextColor3 = self.config.theme.text
            tl.TextXAlignment = Enum.TextXAlignment.Left
            tl.Text = self.title
            tl.Parent = self.frame
            local dl = Instance.new("TextLabel")
            dl.Size = UDim2.new(1,-60,0,40)
            dl.Position = UDim2.new(0,is+20,0,39)
            dl.BackgroundTransparency = 1
            dl.Font = self.config.font
            dl.TextSize = ds
            dl.TextColor3 = self.config.theme.subtext
            dl.TextXAlignment = Enum.TextXAlignment.Left
            dl.TextYAlignment = Enum.TextYAlignment.Top
            dl.TextWrapped = true
            dl.Text = self.description
            dl.Parent = self.frame
        else
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1,-60,0,24)
            tl.Position = UDim2.new(0,15,0,15)
            tl.BackgroundTransparency = 1
            tl.Font = self.config.font
            tl.TextSize = ts
            tl.TextColor3 = self.config.theme.text
            tl.TextXAlignment = Enum.TextXAlignment.Left
            tl.Text = self.title
            tl.Parent = self.frame
            local dl = Instance.new("TextLabel")
            dl.Size = UDim2.new(1,-30,0,40)
            dl.Position = UDim2.new(0,15,0,39)
            dl.BackgroundTransparency = 1
            dl.Font = self.config.font
            dl.TextSize = ds
            dl.TextColor3 = self.config.theme.subtext
            dl.TextXAlignment = Enum.TextXAlignment.Left
            dl.TextYAlignment = Enum.TextYAlignment.Top
            dl.TextWrapped = true
            dl.Text = self.description
            dl.Parent = self.frame
        end
        if self.options.buttons then
            local bs,bf = isMobile() and 36 or 30,isMobile() and 16 or 14
            local bc = Instance.new("Frame")
            bc.Size = UDim2.new(1,-30,0,bs)
            bc.Position = UDim2.new(0,15,1,-(bs+10))
            bc.BackgroundTransparency = 1
            bc.Parent = self.frame
            local bl = Instance.new("UIListLayout")
            bl.FillDirection = Enum.FillDirection.Horizontal
            bl.HorizontalAlignment = Enum.HorizontalAlignment.Right
            bl.SortOrder = Enum.SortOrder.LayoutOrder
            bl.Padding = UDim.new(0,10)
            bl.Parent = bc
            for i,bi in ipairs(self.options.buttons) do
                local bw = isMobile() and 90 or 80
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(0,bw,1,0)
                b.BackgroundColor3 = i==1 and c or self.config.theme.primary
                b.BorderSizePixel = 0
                b.Font = self.config.font
                b.TextSize = bf
                b.TextColor3 = self.config.theme.text
                b.Text = bi.text
                b.LayoutOrder = i
                b.ClipsDescendants = true
                b.AutoButtonColor = false
                b.Parent = bc
                local bc = Instance.new("UICorner")
                bc.CornerRadius = UDim.new(0,4)
                bc.Parent = b
                local bs = Instance.new("ImageLabel")
                bs.Size = UDim2.new(1,6,1,6)
                bs.Position = UDim2.new(0.5,0,0.5,0)
                bs.AnchorPoint = Vector2.new(0.5,0.5)
                bs.BackgroundTransparency = 1
                bs.Image = "rbxassetid://6014261993"
                bs.ImageColor3 = Color3.new(0,0,0)
                bs.ImageTransparency = 0.8
                bs.ScaleType = Enum.ScaleType.Slice
                bs.SliceCenter = Rect.new(49,49,450,450)
                bs.ZIndex = b.ZIndex-1
                bs.Parent = b
                b.MouseEnter:Connect(function()
                    createTween(b,{
                        BackgroundColor3 = i==1 and Color3.new(
                            math.min(c.R+0.1,1),
                            math.min(c.G+0.1,1),
                            math.min(c.B+0.1,1)
                        ) or self.config.theme.highlight
                    }):Play()
                end)
                b.MouseLeave:Connect(function()
                    createTween(b,{
                        BackgroundColor3 = i==1 and c or self.config.theme.primary
                    }):Play()
                end)
                b.MouseButton1Click:Connect(function()
                    createRippleEffect(b,Color3.fromRGB(255,255,255))
                    if bi.callback then bi.callback() end
                    self:Destroy()
                end)
            end
        end
        local cbs = isMobile() and 28 or 24
        local cb = Instance.new("TextButton")
        cb.Size = UDim2.new(0,cbs,0,cbs)
        cb.Position = UDim2.new(1,-30,0,15)
        cb.BackgroundTransparency = 1
        cb.Font = self.config.font
        cb.TextSize = isMobile() and 18 or 16
        cb.TextColor3 = self.config.theme.text
        cb.Text = "✕"
        cb.Parent = self.frame
        cb.MouseEnter:Connect(function()
            createTween(cb,{TextColor3=self.config.theme.error}):Play()
        end)
        cb.MouseLeave:Connect(function()
            createTween(cb,{TextColor3=self.config.theme.text}):Play()
        end)
        cb.MouseButton1Click:Connect(function()
            createRippleEffect(cb,self.config.theme.error)
            self:Destroy()
        end)
        if self.options.sound or self.config.notificationSound then
            local s = Instance.new("Sound")
            s.SoundId = self.options.sound or self.config.notificationSound
            s.Volume = self.options.volume or self.config.notificationVolume or 0.5
            s.Parent = self.frame
            s:Play()
        end
        self.isVisible = true
        createTween(self.frame,{Position=UDim2.new(0,0,0,0)},0.3,Enum.EasingStyle.Back):Play()
        local du = self.options.duration or 5
        if du > 0 then
            task.delay(du,function()
                if self.isVisible and not self.isDestroyed then self:Destroy() end
            end)
        end
    end
    function n:Destroy()
        if self.isDestroyed then return end
        self.isDestroyed = true
        if self.frame then
            createTween(self.frame,{Position=UDim2.new(1,300,0,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In):Play()
            for i,v in ipairs(activeNotifications) do
                if v == self then table.remove(activeNotifications,i) break end
            end
            task.delay(0.1,processQueue)
            task.delay(0.3,function()
                if self.frame and self.frame.Parent then
                    self.frame:Destroy()
                    self.frame = nil
                end
            end)
        end
    end
    if #activeNotifications < maxNotificationsVisible then
        table.insert(activeNotifications,n)
        n:Show()
    else
        table.insert(notificationQueue,n)
    end
    return n
end

function internal.selectSection(s)
    if not internal.sections[s] then print("Error: Sección '"..s.."' no encontrada") return end
    for n,se in pairs(internal.sections) do
        se.frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
        se.frame:FindFirstChild("SectionTitle").TextColor3 = Color3.fromRGB(180,180,180)
        se.indicator.Visible = false
    end
    internal.sections[s].frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    internal.sections[s].frame:FindFirstChild("SectionTitle").TextColor3 = Color3.fromRGB(220,220,220)
    internal.sections[s].indicator.Visible = true
    
    -- Primero limpiamos el contenido actual
    if internal.RightContent:IsA("ScrollingFrame") then
        for _,c in ipairs(internal.RightContent:GetChildren()) do
            if c:IsA("GuiObject") and not c:IsA("UIListLayout") then c:Destroy() end
        end
    else
        for _,c in ipairs(internal.RightContent:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
    end
    
    -- Después agregamos los nuevos elementos
    for _,e in ipairs(internal.sections[s].elements) do
        local el = e.create()
        el.Parent = internal.RightContent
    end
    
    internal.currentSection = s
end

function AE:Start(t,s,d,b)
    s = s or 1
    d = d or false
    local sg = Instance.new("ScreenGui")
    local mf = Instance.new("Frame")
    local tb = Instance.new("Frame")
    local ti = Instance.new("TextLabel")
    local lp = Instance.new("Frame")
    local rp = Instance.new("Frame")
    local di = Instance.new("Frame")
    local lc = Instance.new("Frame")
    local ll = Instance.new("UIListLayout")
    local rc = Instance.new("Frame")
    local rl = Instance.new("UIListLayout")
    sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.ResetOnSpawn = false
    mf.Name = "MainFrame"
    mf.Parent = sg
    mf.BackgroundColor3 = Color3.fromRGB(40,40,40)
    mf.BorderColor3 = Color3.fromRGB(30,30,30)
    mf.Position = UDim2.new(0.15,0,0.1,0)
    mf.Size = UDim2.new(0.7*s,0,0.85*s,0)
    mf.ClipsDescendants = true
    if b then
        local bi = Instance.new("ImageLabel")
        bi.Name = "Background"
        bi.Parent = mf
        bi.BackgroundTransparency = 1
        bi.Size = UDim2.new(1,0,1,0)
        bi.Image = b
        bi.ScaleType = Enum.ScaleType.Stretch
        bi.ZIndex = 0
    end
    local mc = Instance.new("UICorner")
    mc.CornerRadius = UDim.new(0.08,0)
    mc.Parent = mf
    tb.Name = "TopBar"
    tb.Parent = mf
    tb.BackgroundColor3 = Color3.fromRGB(25,25,25)
    tb.BorderSizePixel = 0
    tb.Size = UDim2.new(1,0,0,30)
    tb.ZIndex = 2
    local tbc = Instance.new("UICorner")
    tbc.CornerRadius = UDim.new(0.08,0)
    tbc.Parent = tb
    ti.Name = "Title"
    ti.Parent = tb
    ti.BackgroundColor3 = Color3.fromRGB(255,255,255)
    ti.BackgroundTransparency = 1
    ti.Size = UDim2.new(1,0,1,0)
    ti.Font = Enum.Font.GothamBold
    ti.Text = t or "ADONIS EXCEPT"
    ti.TextColor3 = Color3.fromRGB(200,200,200)
    ti.TextSize = 18
    ti.ZIndex = 3
    lp.Name = "LeftPanel"
    lp.Parent = mf
    lp.BackgroundColor3 = Color3.fromRGB(35,35,35)
    lp.BorderSizePixel = 0
    lp.Position = UDim2.new(0,0,0,tb.Size.Y.Offset)
    lp.Size = UDim2.new(0.25,-2,1,-tb.Size.Y.Offset)
    lc.Name = "LeftContent"
    lc.Parent = lp
    lc.BackgroundColor3 = Color3.fromRGB(35,35,35)
    lc.BackgroundTransparency = 1
    lc.Size = UDim2.new(1,0,1,0)
    local ls = Instance.new("ScrollingFrame")
    ls.Name = "LeftScroll"
    ls.Parent = lc
    ls.BackgroundTransparency = 1
    ls.Size = UDim2.new(1,0,1,0)
    ls.CanvasSize = UDim2.new(0,0,0,0)
    ls.ScrollBarThickness = 4
    ls.ScrollingDirection = Enum.ScrollingDirection.Y
    ls.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ls.BorderSizePixel = 0
    ll.Name = "LeftLayout"
    ll.Parent = ls
    ll.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0,5)
    di.Name = "Divider"
    di.Parent = mf
    di.BackgroundColor3 = Color3.fromRGB(30,30,30)
    di.BorderSizePixel = 0
    di.Position = UDim2.new(0.25,0,0,tb.Size.Y.Offset)
    di.Size = UDim2.new(0,3,1,-tb.Size.Y.Offset)
    rp.Name = "RightPanel"
    rp.Parent = mf
    rp.BackgroundColor3 = Color3.fromRGB(35,35,35)
    rp.BorderSizePixel = 0
    rp.Position = UDim2.new(0.25,3,0,tb.Size.Y.Offset)
    rp.Size = UDim2.new(0.75,-3,1,-tb.Size.Y.Offset)
    rc.Name = "RightContent"
    rc.Parent = rp
    rc.BackgroundColor3 = Color3.fromRGB(35,35,35)
    rc.BackgroundTransparency = 1
    rc.Size = UDim2.new(1,0,1,0)
    local rs = Instance.new("ScrollingFrame")
    rs.Name = "RightScroll"
    rs.Parent = rc
    rs.BackgroundTransparency = 1
    rs.Size = UDim2.new(1,0,1,0)
    rs.CanvasSize = UDim2.new(0,0,0,0)
    rs.ScrollBarThickness = 4
    rs.ScrollingDirection = Enum.ScrollingDirection.Y
    rs.AutomaticCanvasSize = Enum.AutomaticSize.Y
    rs.BorderSizePixel = 0
    rl.Name = "RightLayout"
    rl.Parent = rs
    rl.SortOrder = Enum.SortOrder.LayoutOrder
    rl.Padding = UDim.new(0,5)
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0,8)
    lc.Parent = lp
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0,8)
    rc.Parent = rp
    local sh = Instance.new("ImageLabel")
    sh.Name = "Shadow"
    sh.Parent = mf
    sh.BackgroundTransparency = 1
    sh.Size = UDim2.new(1,10,1,10)
    sh.Position = UDim2.new(0,-5,0,-5)
    sh.Image = "rbxassetid://1316045217"
    sh.ImageColor3 = Color3.fromRGB(0,0,0)
    sh.ImageTransparency = 0.85
    sh.ScaleType = Enum.ScaleType.Slice
    sh.SliceCenter = Rect.new(10,10,118,118)
    sh.ZIndex = -1
    if d then
        local uis = game:GetService("UserInputService")
        local dr,di,ds,sp
        local function up(i)
            local de = i.Position-ds
            mf.Position = UDim2.new(sp.X.Scale,sp.X.Offset+de.X,sp.Y.Scale,sp.Y.Offset+de.Y)
        end
        tb.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dr,ds,sp = true,i.Position,mf.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dr = false end
                end)
            end
        end)
        tb.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
        end)
        uis.InputChanged:Connect(function(i)
            if i == di and dr then up(i) end
        end)
    end
    internal.LeftContent = ls
    internal.RightContent = rs
    internal.MainFrame = mf
    internal.ScreenGui = sg
    task.delay(0.1,function()
        if internal.firstSection and not initialized then
            initialized = true
            internal.selectSection(internal.firstSection)
        end
    end)
    return self
end

function AE:Section(s)
    local sf = Instance.new("TextButton")
    local st = Instance.new("TextLabel")
    local sc = Instance.new("UICorner")
    local ss = Instance.new("UIStroke")
    local ai = Instance.new("Frame")
    local ic = Instance.new("UICorner")
    sf.Name = s.."Section"
    sf.BackgroundColor3 = Color3.fromRGB(45,45,45)
    sf.Size = UDim2.new(0.9,0,0,35)
    sf.AutoButtonColor = false
    sf.LayoutOrder = #internal.LeftContent:GetChildren()
    sf.Text = ""
    sc.CornerRadius = UDim.new(0,6)
    sc.Parent = sf
    ss.Color = Color3.fromRGB(60,60,60)
    ss.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ss.Parent = sf
    st.Name = "SectionTitle"
    st.Parent = sf
    st.BackgroundTransparency = 1
    st.Size = UDim2.new(1,0,1,0)
    st.Font = Enum.Font.GothamMedium
    st.Text = "    "..string.upper(s)
    st.TextColor3 = Color3.fromRGB(180,180,180)
    st.TextSize = 14
    st.TextXAlignment = Enum.TextXAlignment.Left
    ai.Name = "ActiveIndicator"
    ai.Parent = sf
    ai.BackgroundColor3 = Color3.fromRGB(255,0,0)
    ai.Size = UDim2.new(0.05,0,0.7,0)
    ai.Position = UDim2.new(0.025,0,0.15,0)
    ai.Visible = false
    ic.CornerRadius = UDim.new(0,4)
    ic.Parent = ai
    internal.sections[s] = {frame = sf, elements = {}, indicator = ai}
    local se = {Name = s, Frame = sf}
    sf.MouseButton1Click:Connect(function() internal.selectSection(s) end)
    sf.Parent = internal.LeftContent
    if internal.firstSection == nil then internal.firstSection = s end
    return se
end

function AE:button(b,s,c)
    if internal.sections[s.Name] then
        local bd = {
            type = "button",
            text = b,
            callback = c or function() end,
            create = function()
                local bt = Instance.new("TextButton")
                bt.Name = b.."Button"
                bt.Text = b
                bt.Size = UDim2.new(0.95,0,0,35)
                bt.Position = UDim2.new(0.025,0,0,0)
                bt.BackgroundColor3 = Color3.fromRGB(20,20,20)
                bt.TextColor3 = Color3.fromRGB(200,200,200)
                bt.Font = Enum.Font.Gotham
                bt.TextSize = 14
                bt.AutoButtonColor = true
                local bc = Instance.new("UICorner")
                bc.CornerRadius = UDim.new(0,4)
                bc.Parent = bt
                local bs = Instance.new("UIStroke")
                bs.Color = Color3.fromRGB(40,40,40)
                bs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                bs.Parent = bt
                bt.MouseButton1Click:Connect(c or function() end)
                return bt
            end
        }
        table.insert(internal.sections[s.Name].elements,bd)
        if internal.currentSection == s.Name then
            local bt = bd.create()
            bt.Parent = internal.RightContent
        end
    end
end

function AE:Menu(t,s,o,d)
    if internal.sections[s.Name] then
        o = o or {}
        d = d or (o[1] or "")
        local md = {
            type = "menu",
            title = t,
            options = o,
            selected = d,
            callback = nil,
            create = function()
                local mc = Instance.new("Frame")
                mc.Name = t.."Menu"
                mc.Size = UDim2.new(0.95,0,0,70)
                mc.Position = UDim2.new(0.025,0,0,0)
                mc.BackgroundColor3 = Color3.fromRGB(20,20,20)
                local mcc = Instance.new("UICorner")
                mcc.CornerRadius = UDim.new(0,4)
                mcc.Parent = mc
                local mcs = Instance.new("UIStroke")
                mcs.Color = Color3.fromRGB(40,40,40)
                mcs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                mcs.Parent = mc
                local mt = Instance.new("TextLabel")
                mt.Name = "MenuTitle"
                mt.Parent = mc
                mt.BackgroundTransparency = 1
                mt.Size = UDim2.new(1,0,0,25)
                mt.Font = Enum.Font.GothamMedium
                mt.Text = t
                mt.TextColor3 = Color3.fromRGB(200,200,200)
                mt.TextSize = 14
                local so = d
                local db = Instance.new("TextButton")
                db.Name = "DropdownButton"
                db.Parent = mc
                db.BackgroundColor3 = Color3.fromRGB(0,0,0)
                db.Position = UDim2.new(0.05,0,0.45,0)
                db.Size = UDim2.new(0.9,0,0,30)
                db.Font = Enum.Font.Gotham
                db.Text = so
                db.TextColor3 = Color3.fromRGB(200,200,200)
                db.TextSize = 14
                db.TextXAlignment = Enum.TextXAlignment.Left
                db.TextTruncate = Enum.TextTruncate.AtEnd
                local dp = Instance.new("UIPadding")
                dp.Parent = db
                dp.PaddingLeft = UDim.new(0,10)
                local dbc = Instance.new("UICorner")
                dbc.CornerRadius = UDim.new(0,4)
                dbc.Parent = db
                local dl = Instance.new("Frame")
                dl.Name = "DropdownList"
                dl.Parent = mc
                dl.BackgroundColor3 = Color3.fromRGB(0,0,0)
                dl.Position = UDim2.new(0.05,0,0.9,0)
                dl.Size = UDim2.new(0.9,0,0,#o*30)
                dl.Visible = false
                dl.ZIndex = 10
                dl.ClipsDescendants = true
                local dlc = Instance.new("UICorner")
                dlc.CornerRadius = UDim.new(0,4)
                dlc.Parent = dl
                local dll = Instance.new("UIListLayout")
                dll.Parent = dl
                dll.SortOrder = Enum.SortOrder.LayoutOrder
                dll.Padding = UDim.new(0,0)
                for i,opt in ipairs(o) do
                    local ob = Instance.new("TextButton")
                    ob.Name = opt.."Option"
                    ob.Parent = dl
                    ob.Size = UDim2.new(1,0,0,30)
                    ob.Text = opt
                    ob.Font = Enum.Font.Gotham
                    ob.TextSize = 14
                    ob.TextXAlignment = Enum.TextXAlignment.Left
                    ob.LayoutOrder = i
                    ob.ZIndex = 10
                    local op = Instance.new("UIPadding")
                    op.Parent = ob
                    op.PaddingLeft = UDim.new(0,10)
                    if opt == so then
                        ob.BackgroundColor3 = Color3.fromRGB(50,50,50)
                        ob.TextColor3 = Color3.fromRGB(255,0,0)
                    else
                        ob.BackgroundColor3 = Color3.fromRGB(15,15,15)
                        ob.TextColor3 = Color3.fromRGB(180,180,180)
                    end
                    ob.MouseButton1Click:Connect(function()
                        for _,c in ipairs(dl:GetChildren()) do
                            if c:IsA("TextButton") then
                                c.BackgroundColor3 = Color3.fromRGB(15,15,15)
                                c.TextColor3 = Color3.fromRGB(180,180,180)
                            end
                        end
                        ob.BackgroundColor3 = Color3.fromRGB(50,50,50)
                        ob.TextColor3 = Color3.fromRGB(255,0,0)
                        db.Text = opt
                        md.selected = opt
                        dl.Visible = false
                        if md.callback then md.callback(opt) end
                    end)
                end
                local function cd() dl.Visible = false end
                db.MouseButton1Click:Connect(function()
                    if dl.Visible then dl.Visible = false else
                        dl.Visible = true
                        local co = game:GetService("UserInputService").InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                                local p = i.Position
                                local g = game.Players.LocalPlayer:GetGuiObjectsAtPosition(p.X,p.Y)
                                local cm = false
                                for _,o in ipairs(g) do
                                    if o == db or o:IsDescendantOf(dl) then cm = true break end
                                end
                                if not cm then cd() co:Disconnect() end
                            end
                        end)
                    end
                end)
                return mc
            end,
            setCallback = function(c) md.callback = c end
        }
        table.insert(internal.sections[s.Name].elements,md)
        if internal.currentSection == s.Name then
            local m = md.create()
            m.Parent = internal.RightContent
        end
        return {setCallback = md.setCallback}
    end
end

function AE:Input(t,s,d,p,c)
    if internal.sections[s.Name] then
        local id = {
            type = "input",
            title = t,
            value = d or "",
            create = function()
                local ic = Instance.new("Frame")
                ic.Name = t.."Input"
                ic.Size = UDim2.new(0.95,0,0,70)
                ic.Position = UDim2.new(0.025,0,0,0)
                ic.BackgroundColor3 = Color3.fromRGB(20,20,20)
                local icc = Instance.new("UICorner")
                icc.CornerRadius = UDim.new(0,4)
                icc.Parent = ic
                local ics = Instance.new("UIStroke")
                ics.Color = Color3.fromRGB(40,40,40)
                ics.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                ics.Parent = ic
                local it = Instance.new("TextLabel")
                it.Name = "InputTitle"
                it.Parent = ic
                it.BackgroundTransparency = 1
                it.Size = UDim2.new(1,0,0,25)
                it.Font = Enum.Font.GothamMedium
                it.Text = t
                it.TextColor3 = Color3.fromRGB(200,200,200)
                it.TextSize = 14
                local ib = Instance.new("TextBox")
                ib.Name = "InputBox"
                ib.Parent = ic
                ib.Position = UDim2.new(0.05,0,0.45,0)
                ib.Size = UDim2.new(0.9,0,0,30)
                ib.BackgroundColor3 = Color3.fromRGB(0,0,0)
                ib.Text = d or ""
                ib.PlaceholderText = p or "Enter text..."
                ib.Font = Enum.Font.Gotham
                ib.TextColor3 = Color3.fromRGB(200,200,200)
                ib.TextSize = 14
                ib.TextXAlignment = Enum.TextXAlignment.Left
                ib.ClipsDescendants = true
                ib.ClearTextOnFocus = false
                local ibc = Instance.new("UICorner")
                ibc.CornerRadius = UDim.new(0,4)
                ibc.Parent = ib
                local ibp = Instance.new("UIPadding")
                ibp.Parent = ib
                ibp.PaddingLeft = UDim.new(0,10)
                ib.FocusLost:Connect(function(e)
                    id.value = ib.Text
                    if c then c(ib.Text,e) end
                end)
                return ic
            end,
            setCallback = function(nc) c = nc end,
            getValue = function() return id.value end,
            setValue = function(nv)
                id.value = nv
                if internal.currentSection == s.Name then
                    local ic = internal.RightContent:FindFirstChild(t.."Input")
                    if ic then
                        local ib = ic:FindFirstChild("InputBox")
                        if ib then ib.Text = nv end
                    end
                end
            end
        }
        table.insert(internal.sections[s.Name].elements,id)
        if internal.currentSection == s.Name then
            local i = id.create()
            i.Parent = internal.RightContent
        end
        return {setCallback=id.setCallback,getValue=id.getValue,setValue=id.setValue}
    end
end

function AE:Slider(t,s,mi,ma,d,c)
    if internal.sections[s.Name] then
        mi = mi or 0
        ma = ma or 100
        d = math.clamp(d or mi,mi,ma)
        local sd = {
            type = "slider",
            title = t,
            min = mi,
            max = ma,
            value = d,
            callback = c,
            create = function()
                local sc = Instance.new("Frame")
                sc.Name = t.."Slider"
                sc.Size = UDim2.new(0.95,0,0,70)
                sc.Position = UDim2.new(0.025,0,0,0)
                sc.BackgroundColor3 = Color3.fromRGB(20,20,20)
                local scc = Instance.new("UICorner")
                scc.CornerRadius = UDim.new(0,4)
                scc.Parent = sc
                local scs = Instance.new("UIStroke")
                scs.Color = Color3.fromRGB(40,40,40)
                scs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                scs.Parent = sc
                local st = Instance.new("TextLabel")
                st.Name = "SliderTitle"
                st.Parent = sc
                st.BackgroundTransparency = 1
                st.Size = UDim2.new(0.7,0,0,25)
                st.Font = Enum.Font.GothamMedium
                st.Text = t
                st.TextColor3 = Color3.fromRGB(200,200,200)
                st.TextSize = 14
                st.TextXAlignment = Enum.TextXAlignment.Left
                st.Position = UDim2.new(0.05,0,0,0)
                local vl = Instance.new("TextLabel")
                vl.Name = "ValueLabel"
                vl.Parent = sc
                vl.BackgroundTransparency = 1
                vl.Size = UDim2.new(0.2,0,0,25)
                vl.Position = UDim2.new(0.75,0,0,0)
                vl.Font = Enum.Font.GothamMedium
                vl.Text = tostring(sd.value)
                vl.TextColor3 = Color3.fromRGB(200,200,200)
                vl.TextSize = 14
                vl.TextXAlignment = Enum.TextXAlignment.Right
                local st = Instance.new("Frame")
                st.Name = "SliderTrack"
                st.Parent = sc
                st.Position = UDim2.new(0.05,0,0.6,0)
                st.Size = UDim2.new(0.9,0,0,6)
                st.BackgroundColor3 = Color3.fromRGB(40,40,40)
                local stc = Instance.new("UICorner")
                stc.CornerRadius = UDim.new(0,3)
                stc.Parent = st
                local sf = Instance.new("Frame")
                sf.Name = "SliderFill"
                sf.Parent = st
                sf.Position = UDim2.new(0,0,0,0)
                sf.Size = UDim2.new((sd.value-mi)/(ma-mi),0,1,0)
                sf.BackgroundColor3 = Color3.fromRGB(255,0,0)
                local sfc = Instance.new("UICorner")
                sfc.CornerRadius = UDim.new(0,3)
                sfc.Parent = sf
                local sth = Instance.new("Frame")
                sth.Name = "SliderThumb"
                sth.Parent = st
                sth.AnchorPoint = Vector2.new(0.5,0.5)
                sth.Position = UDim2.new((sd.value-mi)/(ma-mi),0,0.5,0)
                sth.Size = UDim2.new(0,12,0,12)
                sth.BackgroundColor3 = Color3.fromRGB(255,0,0)
                local thc = Instance.new("UICorner")
                thc.CornerRadius = UDim.new(1,0)
                thc.Parent = sth
                local dr = false
                local function us(i)
                    local tp = st.AbsolutePosition.X
                    local tw = st.AbsoluteSize.X
                    local mp = i.Position.X
                    local rp = math.clamp((mp-tp)/tw,0,1)
                    local nv = mi+(rp*(ma-mi))
                    nv = math.floor(nv+0.5)
                    sf.Size = UDim2.new(rp,0,1,0)
                    sth.Position = UDim2.new(rp,0,0.5,0)
                    vl.Text = tostring(nv)
                    sd.value = nv
                    if sd.callback then sd.callback(nv) end
                end
                st.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        dr = true
                        us(i)
                    end
                end)
                st.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        dr = false
                    end
                end)
                st.InputChanged:Connect(function(i)
                    if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        us(i)
                    end
                end)
                return sc
            end,
            setCallback = function(nc) sd.callback = nc end,
            getValue = function() return sd.value end,
            setValue = function(nv)
                nv = math.clamp(nv,mi,ma)
                sd.value = nv
                if internal.currentSection == s.Name then
                    local sc = internal.RightContent:FindFirstChild(t.."Slider")
                    if sc then
                        local vl = sc:FindFirstChild("ValueLabel")
                        local st = sc:FindFirstChild("SliderTrack")
                        if vl then vl.Text = tostring(nv) end
                        if st then
                            local sf = st:FindFirstChild("SliderFill")
                            local sth = st:FindFirstChild("SliderThumb")
                            if sf then sf.Size = UDim2.new((nv-mi)/(ma-mi),0,1,0) end
                            if sth then sth.Position = UDim2.new((nv-mi)/(ma-mi),0,0.5,0) end
                        end
                    end
                end
                if sd.callback then sd.callback(nv) end
            end
        }
        table.insert(internal.sections[s.Name].elements,sd)
        if internal.currentSection == s.Name then
            local sl = sd.create()
            sl.Parent = internal.RightContent
        end
        return {setCallback=sd.setCallback,getValue=sd.getValue,setValue=sd.setValue}
    end
end

function AE:Toggle(t,s,d,c)
    if internal.sections[s.Name] then
        local td = {
            type = "toggle",
            title = t,
            value = d or false,
            create = function()
                local tc = Instance.new("Frame")
                tc.Name = t.."Toggle"
                tc.Size = UDim2.new(0.95,0,0,40)
                tc.Position = UDim2.new(0.025,0,0,0)
                tc.BackgroundColor3 = Color3.fromRGB(20,20,20)
                local tcc = Instance.new("UICorner")
                tcc.CornerRadius = UDim.new(0,4)
                tcc.Parent = tc
                local tcs = Instance.new("UIStroke")
                tcs.Color = Color3.fromRGB(40,40,40)
                tcs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                tcs.Parent = tc
                local tt = Instance.new("TextLabel")
                tt.Name = "ToggleTitle"
                tt.Parent = tc
                tt.BackgroundTransparency = 1
                tt.Size = UDim2.new(0.8,0,1,0)
                tt.Position = UDim2.new(0.05,0,0,0)
                tt.Font = Enum.Font.GothamMedium
                tt.Text = t
                tt.TextColor3 = Color3.fromRGB(200,200,200)
                tt.TextSize = 14
                tt.TextXAlignment = Enum.TextXAlignment.Left
                local tb = Instance.new("Frame")
                tb.Name = "ToggleButton"
                tb.Parent = tc
                tb.AnchorPoint = Vector2.new(0,0.5)
                tb.Position = UDim2.new(0.85,0,0.5,0)
                tb.Size = UDim2.new(0,36,0,20)
                tb.BackgroundColor3 = td.value and Color3.fromRGB(255,0,0) or Color3.fromRGB(40,40,40)
                local tbc = Instance.new("UICorner")
                tbc.CornerRadius = UDim.new(1,0)
                tbc.Parent = tb
                local ti = Instance.new("Frame")
                ti.Name = "ToggleIndicator"
                ti.Parent = tb
                ti.AnchorPoint = Vector2.new(0.5,0.5)
                ti.Position = td.value and UDim2.new(0.7,0,0.5,0) or UDim2.new(0.3,0,0.5,0)
                ti.Size = UDim2.new(0,16,0,16)
                ti.BackgroundColor3 = Color3.fromRGB(200,200,200)
                local tic = Instance.new("UICorner")
                tic.CornerRadius = UDim.new(1,0)
                tic.Parent = ti
                local ca = Instance.new("TextButton")
                ca.Name = "ClickArea"
                ca.Parent = tc
                ca.BackgroundTransparency = 1
                ca.Size = UDim2.new(1,0,1,0)
                ca.Text = ""
                ca.MouseButton1Click:Connect(function()
                    td.value = not td.value
                    tb.BackgroundColor3 = td.value and Color3.fromRGB(255,0,0) or Color3.fromRGB(40,40,40)
                    ti:TweenPosition(td.value and UDim2.new(0.7,0,0.5,0) or UDim2.new(0.3,0,0.5,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad,0.2,true)
                    if c then c(td.value) end
                end)
                return tc
            end,
            setCallback = function(nc) c = nc end,
            getValue = function() return td.value end,
            setValue = function(nv)
                td.value = nv
                if internal.currentSection == s.Name then
                    local tc = internal.RightContent:FindFirstChild(t.."Toggle")
                    if tc then
                        local tb = tc:FindFirstChild("ToggleButton")
                        local ti = tb and tb:FindFirstChild("ToggleIndicator")
                        if tb then tb.BackgroundColor3 = td.value and Color3.fromRGB(255,0,0) or Color3.fromRGB(40,40,40) end
                        if ti then ti:TweenPosition(td.value and UDim2.new(0.7,0,0.5,0) or UDim2.new(0.3,0,0.5,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad,0.2,true) end
                    end
                end
                if c then c(td.value) end
            end
        }
        table.insert(internal.sections[s.Name].elements,td)
        if internal.currentSection == s.Name then
            local to = td.create()
            to.Parent = internal.RightContent
        end
        return {setCallback=td.setCallback,getValue=td.getValue,setValue=td.setValue}
    end
end

function AE:Label(t,s)
    if internal.sections[s.Name] then
        local ld = {
            type = "label",
            text = t,
            create = function()
                local l = Instance.new("TextLabel")
                l.Name = "Label"
                l.Size = UDim2.new(0.95,0,0,30)
                l.Position = UDim2.new(0.025,0,0,0)
                l.BackgroundColor3 = Color3.fromRGB(20,20,20)
                l.Text = t
                l.TextColor3 = Color3.fromRGB(200,200,200)
                l.Font = Enum.Font.Gotham
                l.TextSize = 14
                local lc = Instance.new("UICorner")
                lc.CornerRadius = UDim.new(0,4)
                lc.Parent = l
                local ls = Instance.new("UIStroke")
                ls.Color = Color3.fromRGB(40,40,40)
                ls.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                ls.Parent = l
                return l
            end,
            setText = function(nt)
                ld.text = nt
                if internal.currentSection == s.Name then
                    local l = internal.RightContent:FindFirstChild("Label")
                    if l then l.Text = nt end
                end
            end
        }
        table.insert(internal.sections[s.Name].elements,ld)
        if internal.currentSection == s.Name then
            local la = ld.create()
            la.Parent = internal.RightContent
        end
        return {setText = ld.setText}
    end
end

function AE:Notify(t,d,nt,o)
    local m = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("MainFrame")
    if not m.NotificationsContainer then createContainer(m,self.config) end
    return AE_Notify(m,t,d,nt,o)
end

function AE:Separator(s)
    if internal.sections[s.Name] then
        local sd = {
            type = "separator",
            create = function()
                local se = Instance.new("Frame")
                se.Name = "Separator"
                se.Size = UDim2.new(0.95,0,0,2)
                se.Position = UDim2.new(0.025,0,0,0)
                se.BackgroundColor3 = Color3.fromRGB(40,40,40)
                local sec = Instance.new("UICorner")
                sec.CornerRadius = UDim.new(0,1)
                sec.Parent = se
                return se
            end
        }
        table.insert(internal.sections[s.Name].elements,sd)
        if internal.currentSection == s.Name then
            local sp = sd.create()
            sp.Parent = internal.RightContent
        end
    end
end

game.Players.LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(c)
    if c == internal.ScreenGui and internal.firstSection and not initialized then
        wait(0.1)
        initialized = true
        internal.selectSection(internal.firstSection)
    end
end)

return AE