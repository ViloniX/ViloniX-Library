--[[
    ViloniXLib — UI Library for Roblox

    local ViloniX = loadstring(game:HttpGet("..."))()

    local Window = ViloniX.CreateWindow({
        Title     = "MyHub",
        Theme     = Color3.fromRGB(0, 255, 120),
        KeySystem = true,
        Keys      = { "KEY-1234" },
        KeyNote   = "Discord: discord.gg/xyz",
        ToggleKey = Enum.KeyCode.RightShift,
    })

    local Tab = Window:AddTab("Visuals", "👁")
    Tab:AddToggle("Enable ESP", false, function(v) end)
    Tab:AddSlider("FOV", {Min=1,Max=360,Default=90}, function(v) end)
    Tab:AddButton("Click", function() end)
    Tab:AddLabel("Text")
    Tab:AddSeparator()
    Tab:AddDropdown("Method", {"Root","Head"}, function(v) end)
    Tab:AddKeybind("Panic", Enum.KeyCode.Delete, function() end)
    Tab:AddColorPicker("Color", Color3.fromRGB(0,255,120), function(c) end)

    Window:Destroy()
    Window:SetBind(Enum.KeyCode.Insert)
    Window:Toggle()
]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local Lighting         = game:GetService("Lighting")
local LocalPlayer      = Players.LocalPlayer

local function Round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
end

local function Tween(obj, t, props, style, dir)
    local tw = TweenService:Create(obj,
        TweenInfo.new(t, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function New(cls, props, parent)
    local o = Instance.new(cls)
    for k,v in pairs(props) do o[k]=v end
    if parent then o.Parent=parent end
    return o
end

local function Pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop=UDim.new(0,t or 0) u.PaddingBottom=UDim.new(0,b or 0)
    u.PaddingLeft=UDim.new(0,l or 0) u.PaddingRight=UDim.new(0,r or 0)
    u.Parent=p
end

local function MakeList(p, gap)
    local l = Instance.new("UIListLayout")
    l.Padding=UDim.new(0,gap or 8) l.SortOrder=Enum.SortOrder.LayoutOrder
    l.Parent=p return l
end

-- ─────────────────────────────────────────────
--  KEY SYSTEM
-- ─────────────────────────────────────────────

local function ShowKeySystem(cfg, onSuccess)
    local T  = cfg.Theme
    local BF = Enum.Font.GothamBold
    local MF = Enum.Font.Ubuntu

    local KeyBlur = New("BlurEffect", {Size=24, Enabled=true}, Lighting)

    local Gui = New("ScreenGui", {
        Name="VX_Key", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    New("Frame", {
        Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.5, BorderSizePixel=0, ZIndex=1,
    }, Gui)

    local Panel = New("Frame", {
        Size=UDim2.new(0,440,0,270),
        Position=UDim2.new(0.5,0,0.5,0), AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundColor3=Color3.fromRGB(10,10,10), ZIndex=2,
    }, Gui)
    Round(Panel, 16)
    New("UIStroke", {Color=Color3.fromRGB(40,40,40), Thickness=1.5}, Panel)

    -- Top accent
    New("Frame", {Size=UDim2.new(1,0,0,3), BackgroundColor3=T, BorderSizePixel=0, ZIndex=3}, Panel)

    -- Открываем панель анимацией
    Panel.Size = UDim2.new(0,0,0,0)
    Tween(Panel, 0.4, {Size=UDim2.new(0,440,0,270)})

    New("TextLabel", {
        Text=cfg.Title, Position=UDim2.new(0,0,0,16), Size=UDim2.new(1,0,0,30),
        TextColor3=T, Font=BF, TextSize=22, BackgroundTransparency=1, ZIndex=3,
    }, Panel)
    New("TextLabel", {
        Text="Key System", Position=UDim2.new(0,0,0,46), Size=UDim2.new(1,0,0,20),
        TextColor3=Color3.fromRGB(100,100,100), Font=MF, TextSize=13,
        BackgroundTransparency=1, ZIndex=3,
    }, Panel)
    New("TextLabel", {
        Text=cfg.KeyNote or "Введите ключ для доступа",
        Position=UDim2.new(0,0,0,66), Size=UDim2.new(1,0,0,18),
        TextColor3=Color3.fromRGB(70,70,70), Font=MF, TextSize=12,
        BackgroundTransparency=1, ZIndex=3,
    }, Panel)

    local IWrap = New("Frame", {
        Size=UDim2.new(1,-40,0,44), Position=UDim2.new(0,20,0,96),
        BackgroundColor3=Color3.fromRGB(18,18,18), ZIndex=3,
    }, Panel)
    Round(IWrap, 10)
    New("UIStroke", {Color=Color3.fromRGB(45,45,45), Thickness=1}, IWrap)

    local Input = New("TextBox", {
        Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1, PlaceholderText="Введите ключ...",
        PlaceholderColor3=Color3.fromRGB(65,65,65),
        Text="", TextColor3=Color3.fromRGB(220,220,220),
        Font=MF, TextSize=14, ClearTextOnFocus=false, ZIndex=4,
    }, IWrap)

    local Status = New("TextLabel", {
        Position=UDim2.new(0,0,0,150), Size=UDim2.new(1,0,0,18),
        Text="", TextColor3=Color3.fromRGB(200,70,70),
        Font=MF, TextSize=13, BackgroundTransparency=1, ZIndex=3,
    }, Panel)

    local Confirm = New("TextButton", {
        Size=UDim2.new(1,-40,0,44), Position=UDim2.new(0,20,0,178),
        BackgroundColor3=T, Text="Подтвердить",
        TextColor3=Color3.fromRGB(10,10,10),
        Font=BF, TextSize=15, AutoButtonColor=false, ZIndex=3,
    }, Panel)
    Round(Confirm, 10)
    Confirm.MouseEnter:Connect(function() Tween(Confirm,0.1,{BackgroundColor3=Color3.fromRGB(0,220,100)}) end)
    Confirm.MouseLeave:Connect(function() Tween(Confirm,0.1,{BackgroundColor3=T}) end)

    -- Проверка ключа
    local checking = false
    local function TryKey()
        if checking then return end
        checking = true

        local entered = Input.Text
        local valid   = false
        for _, k in ipairs(cfg.Keys or {}) do
            if entered == k then valid = true break end
        end

        if valid then
            Status.TextColor3 = T
            Status.Text       = "✓  Ключ принят!"

            -- Закрываем ключ-панель
            Tween(Panel, 0.3, {Size=UDim2.new(0,0,0,0)},
                Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            task.wait(0.35)

            -- Удаляем KeySystem GUI
            pcall(function() KeyBlur:Destroy() end)
            pcall(function() Gui:Destroy() end)

            -- ← Показываем основной GUI
            onSuccess()
        else
            checking = false
            Status.TextColor3 = Color3.fromRGB(255,75,75)
            Status.Text       = "✗  Неверный ключ."
            -- Shake
            for _, dx in ipairs({8,-8,6,-6,3,0}) do
                IWrap.Position = UDim2.new(0,20+dx,0,96)
                task.wait(0.04)
            end
            IWrap.Position = UDim2.new(0,20,0,96)
        end
    end

    Confirm.MouseButton1Click:Connect(function() task.spawn(TryKey) end)
    Input.FocusLost:Connect(function(enter) if enter then task.spawn(TryKey) end end)
end

-- ─────────────────────────────────────────────
--  LIBRARY
-- ─────────────────────────────────────────────

local ViloniX = {}

function ViloniX.CreateWindow(options)
    options = options or {}

    local cfg = {
        Title      = options.Title      or "ViloniXHub",
        SubTitle   = options.SubTitle   or "v1.0",
        Theme      = options.Theme      or Color3.fromRGB(0,255,120),
        Background = options.Background or Color3.fromRGB(10,10,10),
        Border     = options.Border     or Color3.fromRGB(55,55,55),
        ToggleKey  = options.ToggleKey  or Enum.KeyCode.RightShift,
        Size       = options.Size       or Vector2.new(640,450),
        KeySystem  = options.KeySystem  or false,
        Keys       = options.Keys       or {},
        KeyNote    = options.KeyNote    or "Введите ключ для доступа",
    }

    local ID = "ViloniXHub_"..cfg.Title
    if CoreGui:FindFirstChild(ID) then CoreGui:FindFirstChild(ID):Destroy() end

    local BF    = Enum.Font.GothamBold
    local MF    = Enum.Font.Ubuntu
    local T     = cfg.Theme
    local W, H  = cfg.Size.X, cfg.Size.Y

    local Window = {
        _destroyed   = false,
        _connections = {},
        _toggleFns   = {},
        _currentBind = cfg.ToggleKey,
        _tabs        = {},
        _isOpen      = false,
    }

    local ScreenGui = New("ScreenGui", {
        Name=ID, ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    local Blur = New("BlurEffect", {Size=0, Enabled=false}, Lighting)

    -- Main frame — изначально невидим с правильным размером
    local Main = New("Frame", {
        Size=UDim2.new(0,W,0,H),
        Position=UDim2.new(0.5,0,0.5,0),
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundColor3=cfg.Background,
        BorderSizePixel=0, ClipsDescendants=true,
        Visible=false,
    }, ScreenGui)
    Round(Main, 14)

    -- Shadow
    New("ImageLabel", {
        AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1,
        Position=UDim2.new(0.5,0,0.5,6), Size=UDim2.new(1,44,1,44),
        Image="rbxassetid://6014261993", ImageColor3=Color3.new(0,0,0),
        ImageTransparency=0.5, ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450), ZIndex=0,
    }, Main)

    -- Dividers
    local function DL(pos,sz) New("Frame",{BackgroundColor3=cfg.Border,BorderSizePixel=0,Position=pos,Size=sz},Main) end
    DL(UDim2.new(0,0,0,62),   UDim2.new(1,0,0,1))
    DL(UDim2.new(0,192,0,62), UDim2.new(0,1,1,-62))
    DL(UDim2.new(0,0,1,-112), UDim2.new(0,192,0,1))

    -- TopBar
    local TopBar = New("Frame", {Size=UDim2.new(1,0,0,62), BackgroundTransparency=1}, Main)

    local LogoBase = New("Frame", {
        Size=UDim2.new(0,32,0,32), Position=UDim2.new(0,18,0.5,-16),
        BackgroundColor3=Color3.fromRGB(15,15,15), Rotation=45,
    }, TopBar)
    Round(LogoBase, 6)
    New("UIStroke",{Color=T,Thickness=2},LogoBase)
    New("TextLabel",{
        Size=UDim2.new(1,0,1,0), Rotation=-45,
        Text=string.sub(cfg.Title,1,1), Font=BF, TextSize=20,
        TextColor3=T, BackgroundTransparency=1,
    },LogoBase)

    New("TextLabel",{
        Text=cfg.Title, Position=UDim2.new(0,68,0,0), Size=UDim2.new(0,200,1,0),
        TextColor3=T, Font=BF, TextSize=22,
        TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1,
    },TopBar)
    New("TextLabel",{
        Text=cfg.SubTitle, Position=UDim2.new(1,-170,0,0), Size=UDim2.new(0,110,1,0),
        TextColor3=Color3.fromRGB(70,70,70), Font=MF, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Right, BackgroundTransparency=1,
    },TopBar)

    -- TopBar buttons
    local BindBtn = New("TextButton",{
        Size=UDim2.new(0,90,0,28), Position=UDim2.new(1,-222,0.5,-14),
        BackgroundColor3=Color3.fromRGB(18,18,18),
        Text=cfg.ToggleKey.Name, TextColor3=T,
        Font=MF, TextSize=12, AutoButtonColor=false,
    },Main)
    Round(BindBtn,8)
    New("UIStroke",{Color=cfg.Border,Thickness=1},BindBtn)

    local DestroyBtn = New("TextButton",{
        Size=UDim2.new(0,34,0,34), Position=UDim2.new(1,-96,0,14),
        BackgroundColor3=Color3.fromRGB(160,35,35),
        Text="⛔", TextColor3=Color3.new(1,1,1),
        Font=BF, TextSize=14, AutoButtonColor=false,
    },Main)
    Round(DestroyBtn,8)

    local CloseBtn = New("TextButton",{
        Size=UDim2.new(0,34,0,34), Position=UDim2.new(1,-54,0,14),
        BackgroundColor3=T, Text="✕",
        TextColor3=Color3.fromRGB(10,10,10),
        Font=BF, TextSize=15, AutoButtonColor=false,
    },Main)
    Round(CloseBtn,8)

    -- Sidebar
    local SideScroll = New("ScrollingFrame",{
        Position=UDim2.new(0,12,0,74), Size=UDim2.new(0,168,1,-188),
        BackgroundTransparency=1, ScrollBarThickness=0,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
    },Main)
    MakeList(SideScroll,6)

    -- Page container
    local PageCon = New("Frame",{
        Position=UDim2.new(0,205,0,72), Size=UDim2.new(1,-220,1,-90),
        BackgroundTransparency=1,
    },Main)

    -- Profile
    local Profile = New("Frame",{
        Size=UDim2.new(0,185,0,105), Position=UDim2.new(0,4,1,-108),
        BackgroundTransparency=1,
    },Main)
    local ok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    local Av = New("ImageLabel",{
        Size=UDim2.new(0,50,0,50), Position=UDim2.new(0,10,0.5,-25),
        BackgroundColor3=Color3.fromRGB(20,20,20), Image=ok and thumb or "",
    },Profile)
    Round(Av,25)
    New("UIStroke",{Color=T,Thickness=1.5},Av)
    local function PLbl(txt,y,col,sz,f)
        New("TextLabel",{
            Text=txt, Position=UDim2.new(0,70,0,y), Size=UDim2.new(1,-75,0,18),
            TextColor3=col, Font=f, TextSize=sz,
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        },Profile)
    end
    PLbl(LocalPlayer.Name,           14,Color3.new(1,1,1),        14,BF)
    PLbl("ID: "..LocalPlayer.UserId, 34,Color3.fromRGB(90,90,90), 11,MF)
    PLbl("● Online",                 54,T,                        12,BF)

    -- Float button
    local FloatBtn = New("TextButton",{
        Size=UDim2.new(0,44,0,44), Position=UDim2.new(0.5,-22,0,70),
        BackgroundColor3=cfg.Background,
        Text=string.sub(cfg.Title,1,1), TextColor3=T,
        Font=BF, TextSize=22, AutoButtonColor=false,
    },ScreenGui)
    Round(FloatBtn,22)
    New("UIStroke",{Color=T,Thickness=1.5},FloatBtn)

    -- ─────────────────────────────────────────
    --  OPEN / CLOSE  — исправленная версия
    --  НЕ трогаем Size при открытии, используем
    --  CanvasGroupTransparency или просто Visible
    -- ─────────────────────────────────────────

    local function OpenGUI()
        if Window._destroyed then return end
        if Window._isOpen    then return end
        Window._isOpen = true

        -- Гарантируем правильный размер перед показом
        Main.Size    = UDim2.new(0, W, 0, H)
        Main.Visible = true

        -- Блюр
        Blur.Enabled = true
        Blur.Size    = 0
        Tween(Blur, 0.4, {Size=22})

        -- Простая анимация через Position (slide-in сверху)
        Main.Position = UDim2.new(0.5, 0, 0.4, 0)
        Main.BackgroundTransparency = 0.3
        Tween(Main, 0.35, {
            Position = UDim2.new(0.5,0,0.5,0),
            BackgroundTransparency = 0,
        })
    end

    local function CloseGUI()
        if Window._destroyed then return end
        if not Window._isOpen then return end
        Window._isOpen = false

        Tween(Main, 0.25, {
            Position = UDim2.new(0.5,0,0.55,0),
            BackgroundTransparency = 1,
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        Tween(Blur, 0.25, {Size=0})
        task.delay(0.28, function()
            if not Window._isOpen then
                Main.Visible = false
                Blur.Enabled = false
                Main.Position = UDim2.new(0.5,0,0.5,0)
                Main.BackgroundTransparency = 0
            end
        end)
    end

    local function ToggleUI()
        if Window._isOpen then CloseGUI() else OpenGUI() end
    end

    -- Кнопки
    CloseBtn.MouseButton1Click:Connect(CloseGUI)
    FloatBtn.MouseButton1Click:Connect(ToggleUI)

    -- Кастомный бинд
    local listenBind = false
    BindBtn.MouseButton1Click:Connect(function()
        if Window._destroyed then return end
        listenBind=true BindBtn.Text="..." BindBtn.TextColor3=Color3.fromRGB(190,190,190)
    end)

    local inputConn = UserInputService.InputBegan:Connect(function(i,g)
        if Window._destroyed then return end
        if g then return end
        if listenBind then
            if i.KeyCode ~= Enum.KeyCode.Unknown then
                listenBind=false Window._currentBind=i.KeyCode
                BindBtn.Text=i.KeyCode.Name BindBtn.TextColor3=T
            end
            return
        end
        if i.KeyCode == Window._currentBind then ToggleUI() end
    end)
    table.insert(Window._connections, inputConn)

    -- Dragging
    do
        local dragging, dragStart, startPos
        local c1=TopBar.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                dragging=true dragStart=i.Position startPos=Main.Position
                i.Changed:Connect(function()
                    if i.UserInputState==Enum.UserInputState.End then dragging=false end
                end)
            end
        end)
        local c2=UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
                local d=i.Position-dragStart
                Main.Position=UDim2.new(
                    startPos.X.Scale,startPos.X.Offset+d.X,
                    startPos.Y.Scale,startPos.Y.Offset+d.Y)
            end
        end)
        table.insert(Window._connections,c1)
        table.insert(Window._connections,c2)
    end

    -- Destroy
    local function DoDestroy()
        if Window._destroyed then return end
        Window._destroyed = true
        for _,fn in ipairs(Window._toggleFns) do pcall(fn,false) end
        for _,c  in ipairs(Window._connections) do pcall(function() c:Disconnect() end) end
        Window._toggleFns={} Window._connections={}
        Tween(Main,0.3,{BackgroundTransparency=1},Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        Tween(Blur,0.3,{Size=0})
        task.wait(0.35)
        pcall(function() Blur:Destroy() end)
        pcall(function() ScreenGui:Destroy() end)
    end

    local destroyStep=0
    DestroyBtn.MouseButton1Click:Connect(function()
        destroyStep+=1
        if destroyStep==1 then
            DestroyBtn.Text="?" Tween(DestroyBtn,0.15,{BackgroundColor3=Color3.fromRGB(220,100,30)})
            task.delay(2.5,function()
                if not Window._destroyed and destroyStep==1 then
                    destroyStep=0 DestroyBtn.Text="⛔"
                    Tween(DestroyBtn,0.15,{BackgroundColor3=Color3.fromRGB(160,35,35)})
                end
            end)
        else
            task.spawn(DoDestroy)
        end
    end)

    function Window:Destroy()    task.spawn(DoDestroy) end
    function Window:Toggle()     ToggleUI() end
    function Window:Open()       OpenGUI()  end
    function Window:Close()      CloseGUI() end
    function Window:SetBind(kc)
        self._currentBind=kc BindBtn.Text=kc.Name BindBtn.TextColor3=T
    end

    -- ─────────────────────────────────────────
    --  ELEMENT API
    -- ─────────────────────────────────────────

    local function ElementAPI(page)
        local api={}

        function api:AddToggle(label,default,callback)
            default=default or false callback=callback or function()end
            local F=New("TextButton",{
                Size=UDim2.new(1,0,0,50),BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="",AutoButtonColor=false,
            },page)
            Round(F,10) New("UIStroke",{Color=cfg.Border,Thickness=1},F)
            New("TextLabel",{
                Text="  "..label,Size=UDim2.new(1,-55,1,0),
                TextColor3=Color3.fromRGB(210,210,210),Font=MF,TextSize=15,
                BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,
            },F)
            local Track=New("Frame",{
                Size=UDim2.new(0,40,0,22),Position=UDim2.new(1,-50,0.5,-11),
                BackgroundColor3=Color3.fromRGB(35,35,35),
            },F) Round(Track,11)
            local Knob=New("Frame",{
                Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,3,0.5,-8),
                BackgroundColor3=Color3.fromRGB(90,90,90),
            },Track) Round(Knob,8)

            local active=default
            local function Refresh(fire)
                Tween(Track,0.18,{BackgroundColor3=active and T or Color3.fromRGB(35,35,35)})
                Tween(Knob,0.18,{
                    Position=active and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
                    BackgroundColor3=active and Color3.fromRGB(10,10,10) or Color3.fromRGB(90,90,90),
                })
                if fire then callback(active) end
            end
            if default then Refresh(false) end
            F.MouseButton1Click:Connect(function()
                if Window._destroyed then return end
                active=not active Refresh(true)
            end)
            table.insert(Window._toggleFns,function(v) if active~=v then active=v Refresh(true) end end)
            local ctrl={}
            function ctrl:Set(v) active=v Refresh(true) end
            function ctrl:Get() return active end
            return ctrl
        end

        function api:AddSlider(label,opts,callback)
            opts=opts or {} callback=callback or function()end
            local mn=opts.Min or 0 local mx=opts.Max or 100
            local def=opts.Default or math.floor((mn+mx)/2)
            local step=opts.Step or 1

            local F=New("Frame",{Size=UDim2.new(1,0,0,68),BackgroundColor3=Color3.fromRGB(18,18,18)},page)
            Round(F,10) New("UIStroke",{Color=cfg.Border,Thickness=1},F)
            local VL=New("TextLabel",{
                Position=UDim2.new(1,-55,0,0),Size=UDim2.new(0,50,0,30),
                Text=tostring(def),TextColor3=T,Font=BF,TextSize=13,
                BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Right,
            },F)
            New("TextLabel",{
                Text="  "..label,Size=UDim2.new(1,-60,0,30),
                TextColor3=Color3.fromRGB(210,210,210),Font=MF,TextSize=14,
                BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,
            },F)
            local Track=New("Frame",{
                Size=UDim2.new(1,-24,0,6),Position=UDim2.new(0,12,0,46),
                BackgroundColor3=Color3.fromRGB(40,40,40),
            },F) Round(Track,3)
            local Fill=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=T},Track) Round(Fill,3)
            local Knob=New("Frame",{
                Size=UDim2.new(0,14,0,14),AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(0,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),ZIndex=2,
            },Track) Round(Knob,7)

            local val=def
            local function SV(v)
                v=math.clamp(math.round((v-mn)/step)*step+mn,mn,mx) val=v
                local p=(v-mn)/(mx-mn)
                Tween(Fill,0.05,{Size=UDim2.new(p,0,1,0)})
                Tween(Knob,0.05,{Position=UDim2.new(p,0,0.5,0)})
                VL.Text=tostring(v) callback(v)
            end SV(def)

            local sliding=false
            local function FM(x)
                SV(mn+math.clamp((x-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)*(mx-mn))
            end
            local t1=Track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true FM(i.Position.X) end end)
            local t2=UserInputService.InputChanged:Connect(function(i) if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then FM(i.Position.X) end end)
            local t3=UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end end)
            table.insert(Window._connections,t1) table.insert(Window._connections,t2) table.insert(Window._connections,t3)
            local ctrl={} function ctrl:Set(v) SV(v) end function ctrl:Get() return val end return ctrl
        end

        function api:AddButton(label,callback)
            callback=callback or function()end
            local Btn=New("TextButton",{
                Size=UDim2.new(1,0,0,44),BackgroundColor3=Color3.fromRGB(22,22,22),
                Text="",AutoButtonColor=false,
            },page)
            Round(Btn,10) New("UIStroke",{Color=cfg.Border,Thickness=1},Btn)
            New("TextLabel",{Text=label,Size=UDim2.new(1,0,1,0),TextColor3=Color3.fromRGB(220,220,220),Font=BF,TextSize=14,BackgroundTransparency=1},Btn)
            local UL=New("Frame",{Size=UDim2.new(0,0,0,2),Position=UDim2.new(0.5,0,1,-2),AnchorPoint=Vector2.new(0.5,0),BackgroundColor3=T},Btn) Round(UL,1)
            Btn.MouseButton1Click:Connect(function()
                if Window._destroyed then return end
                callback()
                Tween(UL,0.15,{Size=UDim2.new(0.6,0,0,2)})
                task.delay(0.35,function() Tween(UL,0.2,{Size=UDim2.new(0,0,0,2)}) end)
            end)
            Btn.MouseEnter:Connect(function() Tween(Btn,0.1,{BackgroundColor3=Color3.fromRGB(28,28,28)}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn,0.1,{BackgroundColor3=Color3.fromRGB(22,22,22)}) end)
        end

        function api:AddLabel(text)
            local lbl=New("TextLabel",{
                Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,
                Text="  "..text,TextColor3=Color3.fromRGB(110,110,110),
                Font=MF,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,
            },page)
            local ctrl={} function ctrl:Set(t) lbl.Text="  "..t end return ctrl
        end

        function api:AddSeparator()
            New("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=cfg.Border,BorderSizePixel=0},page)
        end

        function api:AddDropdown(label,items,callback)
            callback=callback or function()end
            local sel=items[1] or ""
            local Wrap=New("Frame",{Size=UDim2.new(1,0,0,50),BackgroundColor3=Color3.fromRGB(18,18,18),ClipsDescendants=false,ZIndex=10},page)
            Round(Wrap,10) New("UIStroke",{Color=cfg.Border,Thickness=1},Wrap)
            New("TextLabel",{Text="  "..label,Size=UDim2.new(0.5,0,1,0),TextColor3=Color3.fromRGB(210,210,210),Font=MF,TextSize=15,BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10},Wrap)
            local Sbt=New("TextButton",{Size=UDim2.new(0,130,0,32),Position=UDim2.new(1,-138,0.5,-16),BackgroundColor3=Color3.fromRGB(28,28,28),Text=sel.."  ▾",TextColor3=T,Font=MF,TextSize=13,ZIndex=10},Wrap) Round(Sbt,8)
            local Drop=New("Frame",{Size=UDim2.new(0,130,0,0),Position=UDim2.new(1,-138,1,4),BackgroundColor3=Color3.fromRGB(22,22,22),ClipsDescendants=true,ZIndex=20,Visible=false},Wrap) Round(Drop,8)
            New("UIStroke",{Color=cfg.Border,Thickness=1,ZIndex=20},Drop)
            local IL=New("Frame",{Size=UDim2.new(1,0,0,#items*32),BackgroundTransparency=1,ZIndex=20},Drop) MakeList(IL,0)
            local open=false
            local function Ref() Sbt.Text=sel.."  "..(open and "▴" or "▾") end
            for _,item in ipairs(items) do
                local I=New("TextButton",{Size=UDim2.new(1,0,0,32),BackgroundColor3=Color3.fromRGB(22,22,22),Text="  "..item,TextColor3=Color3.fromRGB(200,200,200),Font=MF,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=20,AutoButtonColor=false},IL)
                I.MouseEnter:Connect(function() Tween(I,0.1,{BackgroundColor3=Color3.fromRGB(30,30,30)}) end)
                I.MouseLeave:Connect(function() Tween(I,0.1,{BackgroundColor3=Color3.fromRGB(22,22,22)}) end)
                I.MouseButton1Click:Connect(function() sel=item open=false Tween(Drop,0.15,{Size=UDim2.new(0,130,0,0)}) task.wait(0.15) Drop.Visible=false Ref() callback(item) end)
            end
            Sbt.MouseButton1Click:Connect(function()
                open=not open Ref()
                if open then Drop.Visible=true Drop.Size=UDim2.new(0,130,0,0) Tween(Drop,0.2,{Size=UDim2.new(0,130,0,#items*32)})
                else Tween(Drop,0.15,{Size=UDim2.new(0,130,0,0)}) task.wait(0.15) Drop.Visible=false end
            end)
            local ctrl={} function ctrl:Set(v) sel=v Ref() callback(v) end function ctrl:Get() return sel end return ctrl
        end

        function api:AddKeybind(label,default,callback)
            callback=callback or function()end
            local key=default or Enum.KeyCode.Unknown local listening=false
            local F=New("Frame",{Size=UDim2.new(1,0,0,50),BackgroundColor3=Color3.fromRGB(18,18,18)},page)
            Round(F,10) New("UIStroke",{Color=cfg.Border,Thickness=1},F)
            New("TextLabel",{Text="  "..label,Size=UDim2.new(0.6,0,1,0),TextColor3=Color3.fromRGB(210,210,210),Font=MF,TextSize=15,BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left},F)
            local KB=New("TextButton",{Size=UDim2.new(0,100,0,30),Position=UDim2.new(1,-108,0.5,-15),BackgroundColor3=Color3.fromRGB(28,28,28),Text=tostring(key.Name),TextColor3=T,Font=MF,TextSize=13},F) Round(KB,8)
            KB.MouseButton1Click:Connect(function() listening=true KB.Text="..." KB.TextColor3=Color3.fromRGB(190,190,190) end)
            local kc=UserInputService.InputBegan:Connect(function(i,g)
                if Window._destroyed then return end
                if listening and not g then listening=false key=i.KeyCode KB.Text=tostring(key.Name) KB.TextColor3=T
                elseif not g and i.KeyCode==key then callback() end
            end)
            table.insert(Window._connections,kc)
            local ctrl={} function ctrl:Set(k) key=k KB.Text=tostring(k.Name) end function ctrl:Get() return key end return ctrl
        end

        function api:AddColorPicker(label,default,callback)
            callback=callback or function()end default=default or Color3.fromRGB(255,0,0)
            local color=default local H,S,V=Color3.toHSV(color)
            local F=New("Frame",{Size=UDim2.new(1,0,0,50),BackgroundColor3=Color3.fromRGB(18,18,18),ClipsDescendants=false,ZIndex=5},page)
            Round(F,10) New("UIStroke",{Color=cfg.Border,Thickness=1},F)
            New("TextLabel",{Text="  "..label,Size=UDim2.new(0.6,0,1,0),TextColor3=Color3.fromRGB(210,210,210),Font=MF,TextSize=15,BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5},F)
            local Sw=New("TextButton",{Size=UDim2.new(0,32,0,32),Position=UDim2.new(1,-42,0.5,-16),BackgroundColor3=color,Text="",ZIndex=5},F) Round(Sw,8)
            New("UIStroke",{Color=cfg.Border,Thickness=1,ZIndex=5},Sw)
            local Pk=New("Frame",{Size=UDim2.new(0,200,0,160),Position=UDim2.new(1,-208,1,6),BackgroundColor3=Color3.fromRGB(18,18,18),ClipsDescendants=true,ZIndex=30,Visible=false},F)
            Round(Pk,10) New("UIStroke",{Color=cfg.Border,Thickness=1,ZIndex=30},Pk)
            local HG=New("Frame",{Size=UDim2.new(1,-20,0,14),Position=UDim2.new(0,10,0,10),ZIndex=31},Pk) Round(HG,4)
            New("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))})},HG)
            local HC=New("Frame",{Size=UDim2.new(0,4,1,4),Position=UDim2.new(H,-2,0,-2),BackgroundColor3=Color3.new(1,1,1),ZIndex=32},HG) Round(HC,2)
            local SV2=New("Frame",{Size=UDim2.new(1,-20,0,100),Position=UDim2.new(0,10,0,32),ZIndex=31,BackgroundColor3=Color3.fromHSV(H,1,1)},Pk) Round(SV2,6)
            New("UIGradient",{Color=ColorSequence.new(Color3.new(1,1,1),Color3.new(1,1,1)),Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})},SV2)
            local VO=New("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=32},SV2)
            New("UIGradient",{Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0)),Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})},VO)
            local SC=New("Frame",{Size=UDim2.new(0,10,0,10),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(S,0,1-V,0),BackgroundColor3=Color3.new(1,1,1),ZIndex=33},SV2) Round(SC,5)
            local function UC()
                color=Color3.fromHSV(H,S,V) Sw.BackgroundColor3=color SV2.BackgroundColor3=Color3.fromHSV(H,1,1)
                SC.Position=UDim2.new(S,0,1-V,0) HC.Position=UDim2.new(H,-2,0,-2) callback(color)
            end
            local hd,sd=false,false
            local p1=HG.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hd=true H=math.clamp((i.Position.X-HG.AbsolutePosition.X)/HG.AbsoluteSize.X,0,1) UC() end end)
            local p2=SV2.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sd=true S=math.clamp((i.Position.X-SV2.AbsolutePosition.X)/SV2.AbsoluteSize.X,0,1) V=1-math.clamp((i.Position.Y-SV2.AbsolutePosition.Y)/SV2.AbsoluteSize.Y,0,1) UC() end end)
            local p3=UserInputService.InputChanged:Connect(function(i) if i.UserInputType~=Enum.UserInputType.MouseMovement then return end if hd then H=math.clamp((i.Position.X-HG.AbsolutePosition.X)/HG.AbsoluteSize.X,0,1) UC() end if sd then S=math.clamp((i.Position.X-SV2.AbsolutePosition.X)/SV2.AbsoluteSize.X,0,1) V=1-math.clamp((i.Position.Y-SV2.AbsolutePosition.Y)/SV2.AbsoluteSize.Y,0,1) UC() end end)
            local p4=UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hd=false sd=false end end)
            table.insert(Window._connections,p1) table.insert(Window._connections,p2)
            table.insert(Window._connections,p3) table.insert(Window._connections,p4)
            Sw.MouseButton1Click:Connect(function() Pk.Visible=not Pk.Visible end)
            local ctrl={} function ctrl:Set(c) color=c H,S,V=Color3.toHSV(c) UC() end function ctrl:Get() return color end return ctrl
        end

        return api
    end

    -- ─────────────────────────────────────────
    --  AddTab
    -- ─────────────────────────────────────────

    function Window:AddTab(name,icon)
        local Page=New("ScrollingFrame",{
            Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
            Visible=false,ScrollBarThickness=2,ScrollBarImageColor3=T,
            CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
        },PageCon)
        MakeList(Page,10) Pad(Page,4,10,0,0)

        local TabBtn=New("TextButton",{
            Size=UDim2.new(1,0,0,42),BackgroundColor3=Color3.fromRGB(18,18,18),
            Text=(icon and icon.."  " or "  ")..name,
            TextColor3=Color3.fromRGB(140,140,140),
            Font=BF,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,
        },SideScroll)
        Round(TabBtn,10) Pad(TabBtn,0,0,10,0)

        local Bar=New("Frame",{
            Size=UDim2.new(0,3,0,22),Position=UDim2.new(0,0,0.5,-11),
            BackgroundColor3=T,BackgroundTransparency=1,
        },TabBtn) Round(Bar,2)

        TabBtn.MouseButton1Click:Connect(function()
            if self._destroyed then return end
            for _,t in ipairs(self._tabs) do
                t.page.Visible=false
                Tween(t.btn,0.15,{TextColor3=Color3.fromRGB(140,140,140),BackgroundColor3=Color3.fromRGB(18,18,18)})
                Tween(t.bar,0.15,{BackgroundTransparency=1})
            end
            Page.Visible=true self._currentPage=Page
            Tween(TabBtn,0.15,{TextColor3=T,BackgroundColor3=Color3.fromRGB(22,22,22)})
            Tween(Bar,0.15,{BackgroundTransparency=0})
        end)

        table.insert(self._tabs,{page=Page,btn=TabBtn,bar=Bar})

        if #self._tabs==1 then
            Page.Visible=true self._currentPage=Page
            TabBtn.TextColor3=T TabBtn.BackgroundColor3=Color3.fromRGB(22,22,22)
            Bar.BackgroundTransparency=0
        end

        local tab=ElementAPI(Page) tab._page=Page return tab
    end

    -- ─────────────────────────────────────────
    --  ЗАПУСК
    --  task.spawn + task.wait(0) гарантируют что
    --  все вкладки/элементы успеют создаться
    -- ─────────────────────────────────────────

    if cfg.KeySystem then
        task.spawn(function()
            task.wait()  -- ждём один кадр — пусть все AddTab выполнятся
            ShowKeySystem(cfg, function()
                task.wait()  -- ещё один кадр после удаления KeyGui
                OpenGUI()
            end)
        end)
    else
        task.spawn(function()
            task.wait()  -- один кадр
            OpenGUI()
        end)
    end

    return Window
end

return ViloniX
