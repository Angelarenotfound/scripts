local TweenService,UserInputService,SoundService=game:GetService("TweenService"),game:GetService("UserInputService"),game:GetService("SoundService")
local AE,internal,initialized,notificationQueue,maxNotificationsVisible,activeNotifications={},{sections={},currentSection=nil,firstSection=nil},false,{},5,{}
AE.config={notificationPosition="topright",cornerRadius=UDim.new(0,8),font=Enum.Font.GothamBold,notificationSound=nil,notificationVolume=0.5,theme={primary=Color3.fromRGB(50,50,50),secondary=Color3.fromRGB(30,30,30),accent=Color3.fromRGB(67,160,71),success=Color3.fromRGB(67,160,71),warning=Color3.fromRGB(251,140,0),error=Color3.fromRGB(229,57,53),highlight=Color3.fromRGB(70,70,70),text=Color3.fromRGB(255,255,255),subtext=Color3.fromRGB(180,180,180)}}

local function createTween(i,p,d,s,di)return TweenService:Create(i,TweenInfo.new(d or 0.3,s or Enum.EasingStyle.Quint,di or Enum.EasingDirection.Out),p)end
local function isMobile()return UserInputService.TouchEnabled and not UserInputService.MouseEnabled end

local function createElement(p,t)
    local e=Instance.new(t)
    for k,v in pairs(p)do e[k]=v end
    return e
end

local function createRippleEffect(b,c)
    local r=createElement({BackgroundColor3=c or Color3.fromRGB(255,255,255),BackgroundTransparency=0.8,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.new(0,0,0,0),Parent=b},"Frame")
    createElement({CornerRadius=UDim.new(1,0),Parent=r},"UICorner")
    local m=isMobile()and Vector2.new(b.AbsoluteSize.X/2,b.AbsoluteSize.Y/2)or UserInputService:GetMouseLocation()-Vector2.new(b.AbsolutePosition.X,b.AbsolutePosition.Y)
    r.Position=UDim2.new(0,m.X,0,m.Y)
    local ms=math.max(b.AbsoluteSize.X,b.AbsoluteSize.Y)*2
    local at=createTween(r,{Size=UDim2.new(0,ms,0,ms),BackgroundTransparency=1},0.5)
    at:Play()at.Completed:Connect(function()r:Destroy()end)
end

local function createContainer(m,p)
    local pos,ali=UDim2.new(1,-20,0,20),Enum.VerticalAlignment.Top
    if p.notificationPosition=="topleft"then pos,ali=UDim2.new(0,20,0,20),Enum.VerticalAlignment.Top
    elseif p.notificationPosition=="bottomright"then pos,ali=UDim2.new(1,-20,1,-20),Enum.VerticalAlignment.Bottom
    elseif p.notificationPosition=="bottomleft"then pos,ali=UDim2.new(0,20,1,-20),Enum.VerticalAlignment.Bottom end

    if m:FindFirstChild("NotificationsContainer") then
        m.NotificationsContainer:Destroy()
    end

    local notificationsContainer = createElement({
        Name="NotificationsContainer",
        Size=UDim2.new(0,isMobile()and 250 or 300,1,-40),
        Position=pos,
        BackgroundTransparency=1,
        Parent=m.Parent -- Changed from m to m.Parent to make notifications appear outside the GUI
    },"Frame")

    createElement({
        SortOrder=Enum.SortOrder.LayoutOrder,
        Padding=UDim.new(0,10),
        HorizontalAlignment=Enum.HorizontalAlignment.Right,
        VerticalAlignment=ali,
        Parent=notificationsContainer
    },"UIListLayout")

    return notificationsContainer
end

local function processQueue()
    if #notificationQueue>0 and #activeNotifications<maxNotificationsVisible then
        local n=table.remove(notificationQueue,1)table.insert(activeNotifications,n)n:Show()
    end
end

local function AE_Notify(m,t,d,nt,o)
    o=o or{}local n={mainGui=m,title=t,description=d,notificationType=nt,options=o,config=AE.config,frame=nil,isVisible=false,isDestroyed=false}
    function n:Show()
        if self.isDestroyed then return end
        local c=self.notificationType=="success"and self.config.theme.success or self.notificationType=="warning"and self.config.theme.warning or self.notificationType=="error"and self.config.theme.error or self.config.theme.accent
        local h=self.options.height or(self.options.buttons and 120 or 80)
        if isMobile()then h=h*1.2 end
        self.frame=createElement({Size=UDim2.new(1,0,0,h),BackgroundColor3=self.config.theme.secondary,BorderSizePixel=0,Position=UDim2.new(1,300,0,0),AnchorPoint=Vector2.new(0,0),Parent=self.mainGui.NotificationsContainer},"Frame")
        local s=createElement({Size=UDim2.new(1,40,1,40),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Image="rbxassetid://6014261993",ImageColor3=Color3.new(0,0,0),ImageTransparency=0.5,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),ZIndex=self.frame.ZIndex-1,Parent=self.frame},"ImageLabel")
        createElement({CornerRadius=self.config.cornerRadius,Parent=self.frame},"UICorner")
        local tb=createElement({Size=UDim2.new(1,0,0,6),BackgroundColor3=c,BorderSizePixel=0,Parent=self.frame},"Frame")
        createElement({CornerRadius=UDim.new(0,4),Parent=tb},"UICorner")
        local ts,ds=isMobile()and 18 or 16,isMobile()and 16 or 14
        if self.options.icon then
            local is=isMobile()and 28 or 24
            local ic=createElement({Size=UDim2.new(0,is,0,is),Position=UDim2.new(0,10,0,15),BackgroundTransparency=1,Image=self.options.icon,ImageColor3=c,Parent=self.frame},"ImageLabel")
            createElement({Size=UDim2.new(1,-80,0,24),Position=UDim2.new(0,is+20,0,15),BackgroundTransparency=1,Font=self.config.font,TextSize=ts,TextColor3=self.config.theme.text,TextXAlignment=Enum.TextXAlignment.Left,Text=self.title,Parent=self.frame},"TextLabel")
            createElement({Size=UDim2.new(1,-60,0,40),Position=UDim2.new(0,is+20,0,39),BackgroundTransparency=1,Font=self.config.font,TextSize=ds,TextColor3=self.config.theme.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Text=self.description,Parent=self.frame},"TextLabel")
        else
            createElement({Size=UDim2.new(1,-60,0,24),Position=UDim2.new(0,15,0,15),BackgroundTransparency=1,Font=self.config.font,TextSize=ts,TextColor3=self.config.theme.text,TextXAlignment=Enum.TextXAlignment.Left,Text=self.title,Parent=self.frame},"TextLabel")
            createElement({Size=UDim2.new(1,-30,0,40),Position=UDim2.new(0,15,0,39),BackgroundTransparency=1,Font=self.config.font,TextSize=ds,TextColor3=self.config.theme.subtext,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Text=self.description,Parent=self.frame},"TextLabel")
        end
        if self.options.buttons then
            local bs,bf=isMobile()and 36 or 30,isMobile()and 16 or 14
            local bc=createElement({Size=UDim2.new(1,-30,0,bs),Position=UDim2.new(0,15,1,-(bs+10)),BackgroundTransparency=1,Parent=self.frame},"Frame")
            local bl=createElement({FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,10),Parent=bc},"UIListLayout")
            for i,bi in ipairs(self.options.buttons)do
                local bw=isMobile()and 90 or 80
                local b=createElement({Size=UDim2.new(0,bw,1,0),BackgroundColor3=i==1 and c or self.config.theme.primary,BorderSizePixel=0,Font=self.config.font,TextSize=bf,TextColor3=self.config.theme.text,Text=bi.text,LayoutOrder=i,ClipsDescendants=true,AutoButtonColor=false,Parent=bc},"TextButton")
                createElement({CornerRadius=UDim.new(0,4),Parent=b},"UICorner")
                local bs=createElement({Size=UDim2.new(1,6,1,6),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Image="rbxassetid://6014261993",ImageColor3=Color3.new(0,0,0),ImageTransparency=0.8,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),ZIndex=b.ZIndex-1,Parent=b},"ImageLabel")
                b.MouseEnter:Connect(function()createTween(b,{BackgroundColor3=i==1 and Color3.new(math.min(c.R+0.1,1),math.min(c.G+0.1,1),math.min(c.B+0.1,1))or self.config.theme.highlight}):Play()end)
                b.MouseLeave:Connect(function()createTween(b,{BackgroundColor3=i==1 and c or self.config.theme.primary}):Play()end)
                b.MouseButton1Click:Connect(function()createRippleEffect(b,Color3.fromRGB(255,255,255))if bi.callback then bi.callback()end self:Destroy()end)
            end
        end
        local cbs=isMobile()and 28 or 24
        local cb=createElement({Size=UDim2.new(0,cbs,0,cbs),Position=UDim2.new(1,-30,0,15),BackgroundTransparency=1,Font=self.config.font,TextSize=isMobile()and 18 or 16,TextColor3=self.config.theme.text,Text="✕",Parent=self.frame},"TextButton")
        cb.MouseEnter:Connect(function()createTween(cb,{TextColor3=self.config.theme.error}):Play()end)
        cb.MouseLeave:Connect(function()createTween(cb,{TextColor3=self.config.theme.text}):Play()end)
        cb.MouseButton1Click:Connect(function()createRippleEffect(cb,self.config.theme.error)self:Destroy()end)
        if self.options.sound or self.config.notificationSound then
            local s=createElement({SoundId=self.options.sound or self.config.notificationSound,Volume=self.options.volume or self.config.notificationVolume or 0.5,Parent=self.frame},"Sound")s:Play()
        end
        self.isVisible=true
        createTween(self.frame,{Position=UDim2.new(0,0,0,0)},0.3,Enum.EasingStyle.Back):Play()
        local du=self.options.duration or 5
        if du>0 then task.delay(du,function()if self.isVisible and not self.isDestroyed then self:Destroy()end end)end
    end
    function n:Destroy()
        if self.isDestroyed then return end
        self.isDestroyed=true
        if self.frame then
            createTween(self.frame,{Position=UDim2.new(1,300,0,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In):Play()
            for i,v in ipairs(activeNotifications)do if v==self then table.remove(activeNotifications,i)break end end
            task.delay(0.1,processQueue)task.delay(0.3,function()if self.frame and self.frame.Parent then self.frame:Destroy()self.frame=nil end end)
        end
    end
    if #activeNotifications<maxNotificationsVisible then table.insert(activeNotifications,n)n:Show()else table.insert(notificationQueue,n)end
    return n
end

function internal.selectSection(s)
    if not internal.sections[s] then return end
    for n,se in pairs(internal.sections) do
        se.frame.BackgroundColor3=Color3.fromRGB(45,45,45)
        se.frame:FindFirstChild("SectionTitle").TextColor3=Color3.fromRGB(180,180,180)
        se.indicator.Visible=false
    end
    internal.sections[s].frame.BackgroundColor3=Color3.fromRGB(20,20,20)
    internal.sections[s].frame:FindFirstChild("SectionTitle").TextColor3=Color3.fromRGB(220,220,220)
    internal.sections[s].indicator.Visible=true
    for _,c in ipairs(internal.RightContent:GetChildren()) do if c:IsA("GuiObject") and not c:IsA("UIListLayout") then c:Destroy() end end
    for _,e in ipairs(internal.sections[s].elements) do 
        if e and type(e.create) == "function" then
            local element = e.create()
            if element then
                element.Parent = internal.RightContent
            end
        end
    end
    internal.currentSection=s
end

function AE:Start(t,s,d,b)
    s,d=s or 1,d or false
    local sg=createElement({Parent=game.Players.LocalPlayer:WaitForChild("PlayerGui"),ZIndexBehavior=Enum.ZIndexBehavior.Sibling,ResetOnSpawn=false},"ScreenGui")
    local mf=createElement({Name="MainFrame",Parent=sg,BackgroundColor3=Color3.fromRGB(40,40,40),BorderColor3=Color3.fromRGB(30,30,30),Position=UDim2.new(0.15,0,0.1,0),Size=UDim2.new(0.7*s,0,0.85*s,0),ClipsDescendants=true},"Frame")
    if b then createElement({Name="Background",Parent=mf,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Image=b,ScaleType=Enum.ScaleType.Stretch,ZIndex=0},"ImageLabel")end
    createElement({CornerRadius=UDim.new(0.08,0),Parent=mf},"UICorner")
    local tb=createElement({Name="TopBar",Parent=mf,BackgroundColor3=Color3.fromRGB(25,25,25),BorderSizePixel=0,Size=UDim2.new(1,0,0,30),ZIndex=2},"Frame")
    createElement({CornerRadius=UDim.new(0.08,0),Parent=tb},"UICorner")
    createElement({Name="Title",Parent=tb,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Font=Enum.Font.GothamBold,Text=t or "ADONIS EXCEPT",TextColor3=Color3.fromRGB(200,200,200),TextSize=18,ZIndex=3},"TextLabel")
    local lp=createElement({Name="LeftPanel",Parent=mf,BackgroundColor3=Color3.fromRGB(35,35,35),BorderSizePixel=0,Position=UDim2.new(0,0,0,tb.Size.Y.Offset),Size=UDim2.new(0.25,-2,1,-tb.Size.Y.Offset)},"Frame")
    local lc=createElement({Name="LeftContent",Parent=lp,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)},"Frame")
    local ls=createElement({Name="LeftScroll",Parent=lc,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=4,ScrollingDirection=Enum.ScrollingDirection.Y,AutomaticCanvasSize=Enum.AutomaticSize.Y,BorderSizePixel=0},"ScrollingFrame")
    createElement({HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),Parent=ls},"UIListLayout")
    local di=createElement({Name="Divider",Parent=mf,BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0,Position=UDim2.new(0.25,0,0,tb.Size.Y.Offset),Size=UDim2.new(0,3,1,-tb.Size.Y.Offset)},"Frame")
    local rp=createElement({Name="RightPanel",Parent=mf,BackgroundColor3=Color3.fromRGB(35,35,35),BorderSizePixel=0,Position=UDim2.new(0.25,3,0,tb.Size.Y.Offset),Size=UDim2.new(0.75,-3,1,-tb.Size.Y.Offset)},"Frame")
    local rc=createElement({Name="RightContent",Parent=rp,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)},"Frame")
    local rs=createElement({Name="RightScroll",Parent=rc,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=4,ScrollingDirection=Enum.ScrollingDirection.Y,AutomaticCanvasSize=Enum.AutomaticSize.Y,BorderSizePixel=0},"ScrollingFrame")
    createElement({SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),Parent=rs},"UIListLayout")
    createElement({CornerRadius=UDim.new(0,8),Parent=lp},"UICorner")
    createElement({CornerRadius=UDim.new(0,8),Parent=rp},"UICorner")
    createElement({Name="Shadow",Parent=mf,BackgroundTransparency=1,Size=UDim2.new(1,10,1,10),Position=UDim2.new(0,-5,0,-5),Image="rbxassetid://1316045217",ImageColor3=Color3.fromRGB(0,0,0),ImageTransparency=0.85,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(10,10,118,118),ZIndex=-1},"ImageLabel")
    if d then
        local uis=game:GetService("UserInputService")local dr,di,ds,sp
        local function up(i)local de=i.Position-ds mf.Position=UDim2.new(sp.X.Scale,sp.X.Offset+de.X,sp.Y.Scale,sp.Y.Offset+de.Y)end
        tb.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr,ds,sp=true,i.Position,mf.Position i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then dr=false end end)end end)
        tb.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
        uis.InputChanged:Connect(function(i)if i==di and dr then up(i)end end)
    end
    internal.LeftContent,internal.RightContent,internal.MainFrame,internal.ScreenGui=ls,rs,mf,sg
    task.delay(0.1,function()if internal.firstSection then internal.selectSection(internal.firstSection)initialized=true end end)
    return self
end

function AE:Section(s)
    local sf=createElement({Name=s.."Section",BackgroundColor3=Color3.fromRGB(45,45,45),Size=UDim2.new(0.9,0,0,35),AutoButtonColor=false,LayoutOrder=#internal.LeftContent:GetChildren(),Text="",Parent=internal.LeftContent},"TextButton")
    createElement({CornerRadius=UDim.new(0,6),Parent=sf},"UICorner")
    createElement({Color=Color3.fromRGB(60,60,60),ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=sf},"UIStroke")
    createElement({Name="SectionTitle",Parent=sf,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Font=Enum.Font.GothamMedium,Text="    "..string.upper(s),TextColor3=Color3.fromRGB(180,180,180),TextSize=14,TextXAlignment=Enum.TextXAlignment.Left},"TextLabel")
    local ai=createElement({Name="ActiveIndicator",Parent=sf,BackgroundColor3=Color3.fromRGB(255,0,0),Size=UDim2.new(0.05,0,0.7,0),Position=UDim2.new(0.025,0,0.15,0),Visible=false},"Frame")
    createElement({CornerRadius=UDim.new(0,4),Parent=ai},"UICorner")
    internal.sections[s]={frame=sf,elements={},indicator=ai}
    sf.MouseButton1Click:Connect(function()internal.selectSection(s)end)
    if not internal.firstSection then internal.firstSection=s end
    return{Name=s,Frame=sf}
end

function AE:Button(b,s,c)
    if not internal.sections[s.Name]then return end
    local bd={type="button",text=b,callback=c or function()end,create=function()
        local bt=createElement({Name=b.."Button",Text=b,Size=UDim2.new(0.95,0,0,35),Position=UDim2.new(0.025,0,0,0),BackgroundColor3=Color3.fromRGB(20,20,20),TextColor3=Color3.fromRGB(200,200,200),Font=Enum.Font.Gotham,TextSize=14,AutoButtonColor=true,Parent=internal.RightContent},"TextButton")
        createElement({CornerRadius=UDim.new(0,4),Parent=bt},"UICorner")
        createElement({Color=Color3.fromRGB(40,40,40),ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=bt},"UIStroke")
        bt.MouseButton1Click:Connect(c or function()end)
        return bt
    end}
    table.insert(internal.sections[s.Name].elements,bd)
    if internal.currentSection==s.Name then bd.create()end
end

function AE:Menu(t, s, o, d)
    if not internal.sections[s.Name] then return {setCallback = function() end, getValue = function() return "" end, setValue = function() end} end

    o = o or {}
    d = d or (o[1] or "")

    local md = {
        type = "menu",
        title = t,
        options = o,
        selected = d,
        callback = nil,
        create = function()
            local mc = createElement({
                Name = t.."Menu",
                Size = UDim2.new(0.95, 0, 0, 70),
                Position = UDim2.new(0.025, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Parent = internal.RightContent
            }, "Frame")

            createElement({CornerRadius = UDim.new(0, 4), Parent = mc}, "UICorner")
            createElement({Color = Color3.fromRGB(40, 40, 40), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = mc}, "UIStroke")

            createElement({
                Name = "MenuTitle",
                Parent = mc,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.GothamMedium,
                Text = t,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 14
            }, "TextLabel")

            local db = createElement({
                Name = "DropdownButton",
                Parent = mc,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Position = UDim2.new(0.05, 0, 0.45, 0),
                Size = UDim2.new(0.9, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = md.selected,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd
            }, "TextButton")

            createElement({PaddingLeft = UDim.new(0, 10), Parent = db}, "UIPadding")
            createElement({CornerRadius = UDim.new(0, 4), Parent = db}, "UICorner")

            local dl = createElement({
                Name = "DropdownList",
                Parent = mc,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Position = UDim2.new(0.05, 0, 0.9, 0),
                Size = UDim2.new(0.9, 0, 0, #o * 30),
                Visible = false,
                ZIndex = 10,
                ClipsDescendants = true
            }, "Frame")

            createElement({CornerRadius = UDim.new(0, 4), Parent = dl}, "UICorner")
            createElement({SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0), Parent = dl}, "UIListLayout")

            for i, opt in ipairs(o) do
                local ob = createElement({
                    Name = opt.."Option",
                    Parent = dl,
                    Size = UDim2.new(1, 0, 0, 30),
                    Text = opt,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = i,
                    ZIndex = 10
                }, "TextButton")

                createElement({PaddingLeft = UDim.new(0, 10), Parent = ob}, "UIPadding")
                ob.BackgroundColor3 = opt == md.selected and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(15, 15, 15)
                ob.TextColor3 = opt == md.selected and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(180, 180, 180)

                ob.MouseButton1Click:Connect(function()
                    for _, c in ipairs(dl:GetChildren()) do
                        if c:IsA("TextButton") then
                            c.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                            c.TextColor3 = Color3.fromRGB(180, 180, 180)
                        end
                    end

                    ob.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    ob.TextColor3 = Color3.fromRGB(255, 0, 0)
                    db.Text = opt
                    md.selected = opt
                    dl.Visible = false

                    if md.callback then
                        md.callback(opt)
                    end
                end)
            end

            db.MouseButton1Click:Connect(function()
                dl.Visible = not dl.Visible
                if dl.Visible then
                    local co = game:GetService("UserInputService").InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            local p = i.Position
                            local g = game.Players.LocalPlayer:GetGuiObjectsAtPosition(p.X, p.Y)
                            local cm = false

                            for _, o in ipairs(g) do
                                if o == db or o:IsDescendantOf(dl) then
                                    cm = true
                                    break
                                end
                            end

                            if not cm then
                                dl.Visible = false
                                co:Disconnect()
                            end
                        end
                    end)
                end
            end)

            return mc
        end,
        setCallback = function(c)
            if type(c) == "function" then
                md.callback = c
            else
                warn("El callback proporcionado no es una función")
            end
        end,
        getValue = function()
            return md.selected or d or ""
        end,
        setValue = function(nv)
            if table.find(o, nv) then
                md.selected = nv
                local mc = internal.RightContent:FindFirstChild(t.."Menu")
                if mc then
                    local db = mc:FindFirstChild("DropdownButton")
                    if db then db.Text = nv end

                    local dl = mc:FindFirstChild("DropdownList")
                    if dl then
                        for _, child in ipairs(dl:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.BackgroundColor3 = child.Text == nv and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(15, 15, 15)
                                child.TextColor3 = child.Text == nv and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(180, 180, 180)
                            end
                        end
                    end
                end

                if md.callback then
                    md.callback(nv)
                end
            else
                warn("Valor no válido para el menú: "..tostring(nv))
            end
        end
    }

    table.insert(internal.sections[s.Name].elements, md)
    if internal.currentSection == s.Name then md.create() end

    return {
        setCallback = md.setCallback,
        getValue = md.getValue,
        setValue = md.setValue
    }
end

function AE:Input(t, s, d, p, c)
    if not internal.sections[s.Name] then return {setCallback = function() end, getValue = function() return "" end, setValue = function() end} end

    local id = {
        type = "input",
        title = t,
        value = d or "",
        callback = nil,
        create = function()
            local ic = createElement({
                Name = t.."Input",
                Size = UDim2.new(0.95, 0, 0, 70),
                Position = UDim2.new(0.025, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Parent = internal.RightContent
            }, "Frame")

            createElement({CornerRadius = UDim.new(0, 4), Parent = ic}, "UICorner")
            createElement({Color = Color3.fromRGB(40, 40, 40), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = ic}, "UIStroke")

            createElement({
                Name = "InputTitle",
                Parent = ic,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.GothamMedium,
                Text = t,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 14
            }, "TextLabel")

            local ib = createElement({
                Name = "InputBox",
                Parent = ic,
                Position = UDim2.new(0.05, 0, 0.45, 0),
                Size = UDim2.new(0.9, 0, 0, 30),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Text = id.value,
                PlaceholderText = p or "Enter text...",
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClipsDescendants = true,
                ClearTextOnFocus = false
            }, "TextBox")

            createElement({CornerRadius = UDim.new(0, 4), Parent = ib}, "UICorner")
            createElement({PaddingLeft = UDim.new(0, 10), Parent = ib}, "UIPadding")

            ib.FocusLost:Connect(function(enterPressed)
                id.value = ib.Text or ""
                if id.callback then
                    id.callback(id.value, enterPressed)
                end
            end)

            return ic
        end,
        setCallback = function(nc)
            if type(nc) == "function" then
                id.callback = nc
            else
                warn("El callback proporcionado no es una función")
            end
        end,
        getValue = function()
            return id.value or ""
        end,
        setValue = function(nv)
            id.value = nv or id.value or ""
            local ic = internal.RightContent:FindFirstChild(t.."Input")
            if ic then
                local ib = ic:FindFirstChild("InputBox")
                if ib then
                    ib.Text = id.value
                end
            end
        end
    }

    -- Configurar el callback inicial si se proporcionó
    if c and type(c) == "function" then
        id.callback = c
    end

    table.insert(internal.sections[s.Name].elements, id)
    if internal.currentSection == s.Name then id.create() end

    return {
        setCallback = id.setCallback,
        getValue = id.getValue,
        setValue = id.setValue
    }
end


function AE:Slider(t,s,mi,ma,d,c)
    if not internal.sections[s.Name]then return {setCallback = function() end, getValue = function() return 0 end, setValue = function() end} end
    mi,ma,d=mi or 0,ma or 100,math.clamp(d or mi,mi,ma)
    local sd={
        type="slider",
        title=t,
        min=mi,
        max=ma,
        value=d,
        callback=c,
        create=function()
            local sc=createElement({Name=t.."Slider",Size=UDim2.new(0.95,0,0,70),Position=UDim2.new(0.025,0,0,0),BackgroundColor3=Color3.fromRGB(20,20,20),Parent=internal.RightContent},"Frame")
            createElement({CornerRadius=UDim.new(0,4),Parent=sc},"UICorner")
            createElement({Color=Color3.fromRGB(40,40,40),ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=sc},"UIStroke")
            createElement({Name="SliderTitle",Parent=sc,BackgroundTransparency=1,Size=UDim2.new(0.7,0,0,25),Font=Enum.Font.GothamMedium,Text=t,TextColor3=Color3.fromRGB(200,200,200),TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.new(0.05,0,0,0)},"TextLabel")
            local vl=createElement({Name="ValueLabel",Parent=sc,BackgroundTransparency=1,Size=UDim2.new(0.2,0,0,25),Position=UDim2.new(0.75,0,0,0),Font=Enum.Font.GothamMedium,Text=tostring(sd.value),TextColor3=Color3.fromRGB(200,200,200),TextSize=14,TextXAlignment=Enum.TextXAlignment.Right},"TextLabel")
            local st=createElement({Name="SliderTrack",Parent=sc,Position=UDim2.new(0.05,0,0.6,0),Size=UDim2.new(0.9,0,0,6),BackgroundColor3=Color3.fromRGB(40,40,40)},"Frame")
            createElement({CornerRadius=UDim.new(0,3),Parent=st},"UICorner")
            local sf=createElement({Name="SliderFill",Parent=st,Size=UDim2.new((sd.value-mi)/(ma-mi),0,1,0),BackgroundColor3=Color3.fromRGB(255,0,0)},"Frame")
            createElement({CornerRadius=UDim.new(0,3),Parent=sf},"UICorner")
            local sth=createElement({Name="SliderThumb",Parent=st,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new((sd.value-mi)/(ma-mi),0,0.5,0),Size=UDim2.new(0,12,0,12),BackgroundColor3=Color3.fromRGB(255,0,0)},"Frame")
            createElement({CornerRadius=UDim.new(1,0),Parent=sth},"UICorner")
            local dr=false
            local function us(i)
                local tp,tw,mp=st.AbsolutePosition.X,st.AbsoluteSize.X,i.Position.X
                local rp=math.clamp((mp-tp)/tw,0,1)
                local nv=math.floor(mi+(rp*(ma-mi))+0.5)
                sf.Size,sth.Position,vl.Text,sd.value=UDim2.new(rp,0,1,0),UDim2.new(rp,0,0.5,0),tostring(nv),nv
                if sd.callback then sd.callback(nv)end
            end
            st.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true us(i)end end)
            st.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=false end end)
            st.InputChanged:Connect(function(i)if dr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then us(i)end end)
            return sc
        end,
        setCallback=function(nc)
            if type(nc) == "function" then
                sd.callback = nc
            else
                warn("El callback proporcionado no es una función")
            end
        end,
        getValue=function()
            return sd.value
        end,
        setValue=function(nv)
            nv=math.clamp(nv,mi,ma)
            sd.value=nv
            local sc=internal.RightContent:FindFirstChild(t.."Slider")
            if sc then
                local vl,st=sc:FindFirstChild("ValueLabel"),sc:FindFirstChild("SliderTrack")
                if vl then vl.Text=tostring(nv)end
                if st then
                    local sf,sth=st:FindFirstChild("SliderFill"),st:FindFirstChild("SliderThumb")
                    if sf then sf.Size=UDim2.new((nv-mi)/(ma-mi),0,1,0)end
                    if sth then sth.Position=UDim2.new((nv-mi)/(ma-mi),0,0.5,0)end
                end
            end
            if sd.callback then sd.callback(nv)end
        end
    }
    table.insert(internal.sections[s.Name].elements,sd)
    if internal.currentSection==s.Name then sd.create()end
    return{setCallback=sd.setCallback,getValue=sd.getValue,setValue=sd.setValue}
end

function AE:Toggle(t,s,d,c)
    if not internal.sections[s.Name]then return {setCallback = function() end, getValue = function() return false end, setValue = function() end} end
    local td={
        type="toggle",
        title=t,
        value=d or false,
        callback=c,
        create=function()
            local tc=createElement({Name=t.."Toggle",Size=UDim2.new(0.95,0,0,40),Position=UDim2.new(0.025,0,0,0),BackgroundColor3=Color3.fromRGB(20,20,20),Parent=internal.RightContent},"Frame")
            createElement({CornerRadius=UDim.new(0,4),Parent=tc},"UICorner")
            createElement({Color=Color3.fromRGB(40,40,40),ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=tc},"UIStroke")
            createElement({Name="ToggleTitle",Parent=tc,BackgroundTransparency=1,Size=UDim2.new(0.8,0,1,0),Position=UDim2.new(0.05,0,0,0),Font=Enum.Font.GothamMedium,Text=t,TextColor3=Color3.fromRGB(200,200,200),TextSize=14,TextXAlignment=Enum.TextXAlignment.Left},"TextLabel")
            local tb=createElement({Name="ToggleButton",Parent=tc,AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0.85,0,0.5,0),Size=UDim2.new(0,36,0,20),BackgroundColor3=td.value and Color3.fromRGB(255,0,0)or Color3.fromRGB(40,40,40)},"Frame")
            createElement({CornerRadius=UDim.new(1,0),Parent=tb},"UICorner")
            local ti=createElement({Name="ToggleIndicator",Parent=tb,AnchorPoint=Vector2.new(0.5,0.5),Position=td.value and UDim2.new(0.7,0,0.5,0)or UDim2.new(0.3,0,0.5,0),Size=UDim2.new(0,16,0,16),BackgroundColor3=Color3.fromRGB(200,200,200)},"Frame")
            createElement({CornerRadius=UDim.new(1,0),Parent=ti},"UICorner")
            createElement({Name="ClickArea",Parent=tc,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text=""},"TextButton").MouseButton1Click:Connect(function()
                td.value=not td.value
                tb.BackgroundColor3=td.value and Color3.fromRGB(255,0,0)or Color3.fromRGB(40,40,40)
                ti:TweenPosition(td.value and UDim2.new(0.7,0,0.5,0)or UDim2.new(0.3,0,0.5,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad,0.2,true)
                if td.callback then td.callback(td.value) end
            end)
            return tc
        end,
        setCallback=function(nc)
            if type(nc) == "function" then
                td.callback = nc
            else
                warn("El callback proporcionado no es una función")
            end
        end,
        getValue=function()
            return td.value
        end,
        setValue=function(nv)
            td.value=nv
            local tc=internal.RightContent:FindFirstChild(t.."Toggle")
            if tc then
                local tb=tc:FindFirstChild("ToggleButton")
                if tb then 
                    tb.BackgroundColor3=td.value and Color3.fromRGB(255,0,0)or Color3.fromRGB(40,40,40)
                    local ti=tb:FindFirstChild("ToggleIndicator")
                    if ti then ti:TweenPosition(td.value and UDim2.new(0.7,0,0.5,0)or UDim2.new(0.3,0,0.5,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad,0.2,true) end
                end
            end
            if td.callback then td.callback(td.value) end
        end
    }
    table.insert(internal.sections[s.Name].elements,td)
    if internal.currentSection==s.Name then td.create()end
    return{setCallback=td.setCallback,getValue=td.getValue,setValue=td.setValue}
end

function AE:Label(t,s)
    if not internal.sections[s.Name]then return end
    local ld={type="label",text=t,create=function()
        local l=createElement({Name="Label",Size=UDim2.new(0.95,0,0,30),Position=UDim2.new(0.025,0,0,0),BackgroundColor3=Color3.fromRGB(20,20,20),Text=t,TextColor3=Color3.fromRGB(200,200,200),Font=Enum.Font.Gotham,TextSize=14,Parent=internal.RightContent},"TextLabel")
        createElement({CornerRadius=UDim.new(0,4),Parent=l},"UICorner")
        createElement({Color=Color3.fromRGB(40,40,40),ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=l},"UIStroke")
        return l
    end,setText=function(nt)
        ld.text=nt
        local l=internal.RightContent:FindFirstChild("Label")
        if l then l.Text=nt end
    end}
    table.insert(internal.sections[s.Name].elements,ld)
    if internal.currentSection==s.Name then ld.create()end
    return{setText=ld.setText}
end

function AE:Notify(t,d,nt,o)
    local m=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ScreenGui")

    if not m then
        return
    end

    local mainFrame = m:FindFirstChild("MainFrame")

    if not mainFrame then
        return
    end

    if not mainFrame:FindFirstChild("NotificationsContainer") then
        createContainer(mainFrame, AE.config)
    end

    return AE_Notify(mainFrame, t, d, nt, o)
end

function AE:Separator(s)
    if not internal.sections[s.Name]then return end
    local sd={type="separator",create=function()
        local se=createElement({Name="Separator",Size=UDim2.new(0.95,0,0,2),Position=UDim2.new(0.025,0,0,0),BackgroundColor3=Color3.fromRGB(40,40,40),Parent=internal.RightContent},"Frame")
        createElement({CornerRadius=UDim.new(0,1),Parent=se},"UICorner")
        return se
    end}
    table.insert(internal.sections[s.Name].elements,sd)
    if internal.currentSection==s.Name then sd.create()end
end

game.Players.LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(c)if c==internal.ScreenGui and internal.firstSection and not initialized then wait(0.1)initialized=true internal.selectSection(internal.firstSection)end end)
return AE