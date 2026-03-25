--[[
    ViloniXLib — UI Library for Roblox
    
    ИСПОЛЬЗОВАНИЕ:
    
    local ViloniX = loadstring(game:HttpGet("..."))()
    
    local Window = ViloniX.CreateWindow({
        Title     = "MyHub",
        Theme     = Color3.fromRGB(0, 255, 120),
        
        -- Ключ-система (опционально, по умолчанию выключена)
        KeySystem = true,
        Keys      = { "MYKEY-1234", "DEVKEY-9999" },
        KeyNote   = "Discord: discord.gg/example",
        
        -- Бинд открытия/закрытия GUI (по умолчанию RightShift)
        ToggleKey = Enum.KeyCode.RightShift,
    })
    
    local Tab = Window:AddTab("Visuals", "👁")
    
    Tab:AddToggle("Enable ESP", false, function(val) print(val) end)
    Tab:AddSlider("FOV",  { Min=1, Max=360, Default=90 }, function(v) print(v) end)
    Tab:AddButton("Teleport", function() print("tp") end)
    Tab:AddDropdown("Method", {"Root","Head","Torso"}, function(v) print(v) end)
    Tab:AddKeybind("Panic Key", Enum.KeyCode.Delete, function() print("panic") end)
    Tab:AddColorPicker("Color", Color3.fromRGB(0,255,120), function(c) print(c) end)
    
    -- Публичные методы Window:
    Window:Destroy()              -- закрыть всё, выключить все функции
    Window:SetBind(Enum.KeyCode.Insert)  -- сменить бинд программно
    Window:Toggle()               -- открыть/закрыть GUI программно
]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local Lighting         = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ─────────────────────────────────────────────
--  UTILS
-- ─────────────────────────────────────────────

local function Round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function Tween(obj, t, props, style, dir)
    local tw = TweenService:Create(
        obj,
        TweenInfo.new(t, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    )
    tw:Play()
    return tw
end

local function Pad(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    p.Parent = parent
end

local function List(parent, gap, dir)
    local l = Instance.new("UIListLayout")
    l.Padding       = UDim.new(0, gap or 8)
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.SortOrder     = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

local function New(cls, props, parent)
    local o = Instance.new(cls)
    for k,v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

-- ─────────────────────────────────────────────
--  KEY SYSTEM
-- ─────────────────────────────────────────────

local function ShowKeySystem(cfg, onSuccess)
    local THEME    = cfg.Theme
    local BF       = Enum.Font.GothamBold
    local MF       = Enum.Font.Ubuntu

    local KeyBlur = New("BlurEffect", { Size = 26, Enabled = true }, Lighting)

    local Gui = New("ScreenGui", {
        Name           = "VX_KeySystem",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    -- Overlay
    New("Frame", {
        Size                  = UDim2.new(1,0,1,0),
        BackgroundColor3      = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.45,
        BorderSizePixel       = 0,
        ZIndex                = 1,
    }, Gui)

    -- Panel
    local Panel = New("Frame", {
        Size             = UDim2.new(0,440,0,270),
        Position         = UDim2.new(0.5,0,0.5,0),
        AnchorPoint      = Vector2.new(0.5,0.5),
        BackgroundColor3 = Color3.fromRGB(10,10,10),
        BorderSizePixel  = 0,
        ZIndex           = 2,
    }, Gui)
    Round(Panel, 16)
    New("UIStroke", { Color = Color3.fromRGB(40,40,40), Thickness = 1.5 }, Panel)

    -- Анимация открытия
    Panel.Size = UDim2.new(0,0,0,0)
    Tween(Panel, 0.4, { Size = UDim2.new(0,440,0,270) })

    -- Accent line сверху
    New("Frame", {
        Size             = UDim2.new(1,0,0,3),
        BackgroundColor3 = THEME,
        BorderSizePixel  = 0,
        ZIndex           = 3,
    }, Panel)

    New("TextLabel", {
        Text                  = cfg.Title,
        Position              = UDim2.new(0,0,0,16),
        Size                  = UDim2.new(1,0,0,30),
        TextColor3            = THEME,
        Font                  = BF,
        TextSize              = 22,
        BackgroundTransparency = 1,
        ZIndex                = 3,
    }, Panel)

    New("TextLabel", {
        Text                  = "Key System",
        Position              = UDim2.new(0,0,0,46),
        Size                  = UDim2.new(1,0,0,20),
        TextColor3            = Color3.fromRGB(100,100,100),
        Font                  = MF,
        TextSize              = 13,
        BackgroundTransparency = 1,
        ZIndex                = 3,
    }, Panel)

    New("TextLabel", {
        Text                  = cfg.KeyNote or "Введите ключ для доступа",
        Position              = UDim2.new(0,0,0,66),
        Size                  = UDim2.new(1,0,0,18),
        TextColor3            = Color3.fromRGB(75,75,75),
        Font                  = MF,
        TextSize              = 12,
        BackgroundTransparency = 1,
        ZIndex                = 3,
    }, Panel)

    -- Input box
    local InputWrap = New("Frame", {
        Size             = UDim2.new(1,-40,0,44),
        Position         = UDim2.new(0,20,0,96),
        BackgroundColor3 = Color3.fromRGB(18,18,18),
        ZIndex           = 3,
    }, Panel)
    Round(InputWrap, 10)
    New("UIStroke", { Color = Color3.fromRGB(45,45,45), Thickness = 1 }, InputWrap)

    local Input = New("TextBox", {
        Size                  = UDim2.new(1,-20,1,0),
        Position              = UDim2.new(0,10,0,0),
        BackgroundTransparency = 1,
        PlaceholderText       = "Введите ключ...",
        PlaceholderColor3     = Color3.fromRGB(65,65,65),
        Text                  = "",
        TextColor3            = Color3.fromRGB(220,220,220),
        Font                  = MF,
        TextSize              = 14,
        ClearTextOnFocus      = false,
        ZIndex                = 4,
    }, InputWrap)

    -- Статус
    local Status = New("TextLabel", {
        Position              = UDim2.new(0,0,0,150),
        Size                  = UDim2.new(1,0,0,18),
        Text                  = "",
        TextColor3            = Color3.fromRGB(200,70,70),
        Font                  = MF,
        TextSize              = 13,
        BackgroundTransparency = 1,
        ZIndex                = 3,
    }, Panel)

    -- Confirm button
    local ConfirmBtn = New("TextButton", {
        Size             = UDim2.new(1,-40,0,44),
        Position         = UDim2.new(0,20,0,178),
        BackgroundColor3 = THEME,
        Text             = "Подтвердить",
        TextColor3       = Color3.fromRGB(10,10,10),
        Font             = BF,
        TextSize         = 15,
        AutoButtonColor  = false,
        ZIndex           = 3,
    }, Panel)
    Round(ConfirmBtn, 10)

    local function TryKey()
        local entered = Input.Text
        local valid   = false
        for _, k in ipairs(cfg.Keys or {}) do
            if entered == k then valid = true break end
        end

        if valid then
            Status.TextColor3 = THEME
            Status.Text       = "✓  Ключ принят! Загрузка..."
            Tween(Panel, 0.35, { Size = UDim2.new(0,0,0,0) })
            task.wait(0.45)
            KeyBlur:Destroy()
            Gui:Destroy()
            onSuccess()
        else
            Status.TextColor3 = Color3.fromRGB(255, 75, 75)
            Status.Text       = "✗  Неверный ключ. Попробуйте снова."
            -- Shake animation
            local ox = InputWrap.Position
            for _, dx in ipairs({6, -6, 4, -4, 2, 0}) do
                Tween(InputWrap, 0.04, { Position = UDim2.new(0, 20+dx, 0, 96) })
                task.wait(0.04)
            end
            InputWrap.Position = ox
        end
    end

    ConfirmBtn.MouseButton1Click:Connect(TryKey)
    Input.FocusLost:Connect(function(enter) if enter then TryKey() end end)

    -- Hover на кнопке
    ConfirmBtn.MouseEnter:Connect(function() Tween(ConfirmBtn, 0.12, { BackgroundColor3 = Color3.fromRGB(0,220,100) }) end)
    ConfirmBtn.MouseLeave:Connect(function() Tween(ConfirmBtn, 0.12, { BackgroundColor3 = THEME }) end)
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
        Theme      = options.Theme      or Color3.fromRGB(0, 255, 120),
        Background = options.Background or Color3.fromRGB(10, 10, 10),
        Border     = options.Border     or Color3.fromRGB(55, 55, 55),
        ToggleKey  = options.ToggleKey  or Enum.KeyCode.RightShift,
        Size       = options.Size       or Vector2.new(640, 450),
        KeySystem  = options.KeySystem  or false,
        Keys       = options.Keys       or {},
        KeyNote    = options.KeyNote    or "Введите ключ для доступа",
    }

    local GUIID = "ViloniXHub_" .. cfg.Title
    if CoreGui:FindFirstChild(GUIID) then
        CoreGui:FindFirstChild(GUIID):Destroy()
    end

    local BF    = Enum.Font.GothamBold
    local MF    = Enum.Font.Ubuntu
    local THEME = cfg.Theme
    local W, H  = cfg.Size.X, cfg.Size.Y

    -- ── Window object ─────────────────────────
    local Window = {
        _destroyed   = false,
        _connections = {},
        _toggleFns   = {},   -- { fn(bool) } вызываются при Destroy
        _currentBind = cfg.ToggleKey,
        _tabs        = {},
        _currentPage = nil,
    }

    -- ── ScreenGui ─────────────────────────────
    local ScreenGui = New("ScreenGui", {
        Name           = GUIID,
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    local Blur = New("BlurEffect", { Size = 0, Enabled = false }, Lighting)

    -- ── Main Frame ────────────────────────────
    local Main = New("Frame", {
        Name             = "Main",
        Size             = UDim2.new(0, W, 0, H),
        Position         = UDim2.new(0.5,0,0.5,0),
        AnchorPoint      = Vector2.new(0.5,0.5),
        BackgroundColor3 = cfg.Background,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        Visible          = false,
    }, ScreenGui)
    Round(Main, 14)

    -- Тень
    New("ImageLabel", {
        AnchorPoint           = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
        Position              = UDim2.new(0.5,0,0.5,6),
        Size                  = UDim2.new(1,44,1,44),
        Image                 = "rbxassetid://6014261993",
        ImageColor3           = Color3.new(0,0,0),
        ImageTransparency     = 0.5,
        ScaleType             = Enum.ScaleType.Slice,
        SliceCenter           = Rect.new(49,49,450,450),
        ZIndex                = 0,
    }, Main)

    -- Разделители
    local function Line(pos, sz)
        New("Frame", { BackgroundColor3=cfg.Border, BorderSizePixel=0, Position=pos, Size=sz }, Main)
    end
    Line(UDim2.new(0,0,0,62),   UDim2.new(1,0,0,1))
    Line(UDim2.new(0,192,0,62), UDim2.new(0,1,1,-62))
    Line(UDim2.new(0,0,1,-112), UDim2.new(0,192,0,1))

    -- ── Top Bar ───────────────────────────────
    local TopBar = New("Frame", {
        Size                  = UDim2.new(1,0,0,62),
        BackgroundTransparency = 1,
    }, Main)

    -- Логотип
    local LogoBase = New("Frame", {
        Size             = UDim2.new(0,32,0,32),
        Position         = UDim2.new(0,18,0.5,-16),
        BackgroundColor3 = Color3.fromRGB(15,15,15),
        Rotation         = 45,
    }, TopBar)
    Round(LogoBase, 6)
    New("UIStroke", { Color=THEME, Thickness=2 }, LogoBase)
    New("TextLabel", {
        Size=UDim2.new(1,0,1,0), Rotation=-45,
        Text=string.sub(cfg.Title,1,1), Font=BF, TextSize=20,
        TextColor3=THEME, BackgroundTransparency=1,
    }, LogoBase)

    New("TextLabel", {
        Text=cfg.Title, Position=UDim2.new(0,68,0,0), Size=UDim2.new(0,200,1,0),
        TextColor3=THEME, Font=BF, TextSize=22,
        TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1,
    }, TopBar)

    New("TextLabel", {
        Text=cfg.SubTitle, Position=UDim2.new(1,-168,0,0), Size=UDim2.new(0,100,1,0),
        TextColor3=Color3.fromRGB(70,70,70), Font=MF, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Right, BackgroundTransparency=1,
    }, TopBar)

    -- ── Кнопки топбара ────────────────────────

    -- [1] Кастомный бинд
    local BindBtn = New("TextButton", {
        Size             = UDim2.new(0,86,0,28),
        Position         = UDim2.new(1,-218,0.5,-14),
        BackgroundColor3 = Color3.fromRGB(18,18,18),
        Text             = cfg.ToggleKey.Name,
        TextColor3       = THEME,
        Font             = MF,
        TextSize         = 12,
        AutoButtonColor  = false,
    }, Main)
    Round(BindBtn, 8)
    New("UIStroke", { Color=cfg.Border, Thickness=1 }, BindBtn)

    -- [2] Destroy
    local DestroyBtn = New("TextButton", {
        Size             = UDim2.new(0,34,0,34),
        Position         = UDim2.new(1,-96,0,14),
        BackgroundColor3 = Color3.fromRGB(160,35,35),
        Text             = "⛔",
        TextColor3       = Color3.new(1,1,1),
        Font             = BF,
        TextSize         = 14,
        AutoButtonColor  = false,
    }, Main)
    Round(DestroyBtn, 8)

    -- [3] Закрыть
    local CloseBtn = New("TextButton", {
        Size             = UDim2.new(0,34,0,34),
        Position         = UDim2.new(1,-54,0,14),
        BackgroundColor3 = THEME,
        Text             = "✕",
        TextColor3       = Color3.fromRGB(10,10,10),
        Font             = BF,
        TextSize         = 15,
        AutoButtonColor  = false,
    }, Main)
    Round(CloseBtn, 8)

    -- ── Sidebar ───────────────────────────────
    local SideScroll = New("ScrollingFrame", {
        Position             = UDim2.new(0,12,0,74),
        Size                 = UDim2.new(0,168,1,-188),
        BackgroundTransparency = 1,
        ScrollBarThickness   = 0,
        CanvasSize           = UDim2.new(0,0,0,0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        ClipsDescendants     = true,
    }, Main)
    List(SideScroll, 6)

    -- ── Page Container ────────────────────────
    local PageCon = New("Frame", {
        Position             = UDim2.new(0,205,0,72),
        Size                 = UDim2.new(1,-220,1,-90),
        BackgroundTransparency = 1,
    }, Main)

    -- ── Profile ───────────────────────────────
    local Profile = New("Frame", {
        Size                 = UDim2.new(0,185,0,105),
        Position             = UDim2.new(0,4,1,-108),
        BackgroundTransparency = 1,
    }, Main)

    local ok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(
            LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150
        )
    end)
    local Av = New("ImageLabel", {
        Size=UDim2.new(0,50,0,50), Position=UDim2.new(0,10,0.5,-25),
        BackgroundColor3=Color3.fromRGB(20,20,20),
        Image = ok and thumb or "",
    }, Profile)
    Round(Av, 25)
    New("UIStroke", { Color=THEME, Thickness=1.5 }, Av)

    local function PLbl(txt, y, col, sz, f)
        New("TextLabel", {
            Text=txt, Position=UDim2.new(0,70,0,y), Size=UDim2.new(1,-75,0,18),
            TextColor3=col, Font=f, TextSize=sz,
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        }, Profile)
    end
    PLbl(LocalPlayer.Name,              14, Color3.new(1,1,1),           14, BF)
    PLbl("ID: "..LocalPlayer.UserId,    34, Color3.fromRGB(95,95,95),    11, MF)
    PLbl("● Online",                    54, THEME,                       12, BF)

    -- ── Float Button ─────────────────────────
    local FloatBtn = New("TextButton", {
        Size=UDim2.new(0,44,0,44), Position=UDim2.new(0.5,-22,0,70),
        BackgroundColor3=cfg.Background,
        Text=string.sub(cfg.Title,1,1), TextColor3=THEME,
        Font=BF, TextSize=22, AutoButtonColor=false,
    }, ScreenGui)
    Round(FloatBtn, 22)
    New("UIStroke", { Color=THEME, Thickness=1.5 }, FloatBtn)

    -- ─────────────────────────────────────────
    --  TOGGLE UI (открыть/закрыть)
    -- ─────────────────────────────────────────

    local function ToggleUI()
        if Window._destroyed then return end
        if not Main.Visible then
            Main.Size    = UDim2.new(0,0,0,0)
            Main.Visible = true
            Blur.Enabled = true
            Tween(Main, 0.4, { Size = UDim2.new(0,W,0,H) })
            Tween(Blur, 0.4, { Size = 22 })
        else
            local t = Tween(Main, 0.3, { Size=UDim2.new(0,0,0,0) }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            Tween(Blur, 0.3, { Size=0 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            t.Completed:Once(function()
                Main.Visible = false
                Blur.Enabled = false
            end)
        end
    end

    Window.Toggle = function(self) ToggleUI() end

    CloseBtn.MouseButton1Click:Connect(ToggleUI)
    FloatBtn.MouseButton1Click:Connect(ToggleUI)

    -- ─────────────────────────────────────────
    --  КАСТОМНЫЙ БИНД
    -- ─────────────────────────────────────────

    local listenBind = false

    BindBtn.MouseButton1Click:Connect(function()
        if Window._destroyed then return end
        listenBind        = true
        BindBtn.Text      = "..."
        BindBtn.TextColor3 = Color3.fromRGB(190,190,190)
    end)

    local inputConn = UserInputService.InputBegan:Connect(function(i, g)
        if Window._destroyed then return end
        if g then return end

        if listenBind then
            local kc = i.KeyCode
            if kc ~= Enum.KeyCode.Unknown then
                listenBind            = false
                Window._currentBind   = kc
                BindBtn.Text          = kc.Name
                BindBtn.TextColor3    = THEME
            end
            return
        end

        if i.KeyCode == Window._currentBind then
            ToggleUI()
        end
    end)
    table.insert(Window._connections, inputConn)

    -- ─────────────────────────────────────────
    --  DRAGGING
    -- ─────────────────────────────────────────

    do
        local dragging, dragStart, startPos
        local c1 = TopBar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging  = true
                dragStart = i.Position
                startPos  = Main.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        local c2 = UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - dragStart
                Tween(Main, 0.07, {
                    Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
                }, Enum.EasingStyle.Linear)
            end
        end)
        table.insert(Window._connections, c1)
        table.insert(Window._connections, c2)
    end

    -- ─────────────────────────────────────────
    --  DESTROY
    -- ─────────────────────────────────────────

    local function DoDestroy()
        if Window._destroyed then return end
        Window._destroyed = true

        -- Выключаем все toggle'ы (чтобы скрипты перестали работать)
        for _, fn in ipairs(Window._toggleFns) do
            pcall(function() fn(false) end)
        end
        Window._toggleFns = {}

        -- Отключаем все соединения библиотеки
        for _, c in ipairs(Window._connections) do
            pcall(function() c:Disconnect() end)
        end
        Window._connections = {}

        -- Анимация закрытия
        Tween(Main, 0.35, { Size=UDim2.new(0,0,0,0) }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        Tween(Blur, 0.35, { Size=0 })
        task.wait(0.4)

        pcall(function() Blur:Destroy() end)
        pcall(function() ScreenGui:Destroy() end)
    end

    Window.Destroy = function(self) DoDestroy() end

    -- Кнопка Destroy — двойное нажатие для подтверждения
    local destroyStep = 0
    DestroyBtn.MouseButton1Click:Connect(function()
        destroyStep += 1
        if destroyStep == 1 then
            -- Первое нажатие — просим подтверждение
            DestroyBtn.Text = "?"
            Tween(DestroyBtn, 0.2, { BackgroundColor3 = Color3.fromRGB(220, 100, 30) })
            task.delay(2.5, function()
                if not Window._destroyed and destroyStep == 1 then
                    destroyStep = 0
                    DestroyBtn.Text = "⛔"
                    Tween(DestroyBtn, 0.2, { BackgroundColor3 = Color3.fromRGB(160,35,35) })
                end
            end)
        else
            -- Второе нажатие — уничтожаем
            DoDestroy()
        end
    end)

    -- ─────────────────────────────────────────
    --  SetBind
    -- ─────────────────────────────────────────

    Window.SetBind = function(self, keyCode)
        Window._currentBind   = keyCode
        BindBtn.Text          = keyCode.Name
        BindBtn.TextColor3    = THEME
    end

    -- ─────────────────────────────────────────
    --  ELEMENT API
    -- ─────────────────────────────────────────

    local function ElementAPI(page)
        local api = {}

        -- ── Toggle ───────────────────────────
        function api:AddToggle(label, default, callback)
            default  = default  or false
            callback = callback or function() end

            local F = New("TextButton", {
                Size=UDim2.new(1,0,0,50), BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="", AutoButtonColor=false,
            }, page)
            Round(F, 10)
            New("UIStroke", { Color=cfg.Border, Thickness=1 }, F)

            New("TextLabel", {
                Text="  "..label, Size=UDim2.new(1,-55,1,0),
                TextColor3=Color3.fromRGB(210,210,210), Font=MF, TextSize=15,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
            }, F)

            local Track = New("Frame", {
                Size=UDim2.new(0,40,0,22), Position=UDim2.new(1,-50,0.5,-11),
                BackgroundColor3=Color3.fromRGB(35,35,35),
            }, F)
            Round(Track, 11)

            local Knob = New("Frame", {
                Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,3,0.5,-8),
                BackgroundColor3=Color3.fromRGB(90,90,90),
            }, Track)
            Round(Knob, 8)

            local active = default
            local function Refresh(fire)
                Tween(Track, 0.18, { BackgroundColor3 = active and THEME or Color3.fromRGB(35,35,35) })
                Tween(Knob,  0.18, {
                    Position         = active and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
                    BackgroundColor3 = active and Color3.fromRGB(10,10,10) or Color3.fromRGB(90,90,90),
                })
                if fire then callback(active) end
            end
            if default then Refresh(false) end

            F.MouseButton1Click:Connect(function()
                if Window._destroyed then return end
                active = not active
                Refresh(true)
            end)

            -- Регистрируем для DoDestroy — выключает при уничтожении
            table.insert(Window._toggleFns, function(val)
                if active ~= val then
                    active = val
                    Refresh(true)
                end
            end)

            local ctrl = {}
            function ctrl:Set(v) active=v Refresh(true) end
            function ctrl:Get() return active end
            return ctrl
        end

        -- ── Slider ───────────────────────────
        function api:AddSlider(label, opts, callback)
            opts     = opts     or {}
            callback = callback or function() end
            local mn   = opts.Min     or 0
            local mx   = opts.Max     or 100
            local def  = opts.Default or math.floor((mn+mx)/2)
            local step = opts.Step    or 1

            local F = New("Frame", {
                Size=UDim2.new(1,0,0,68), BackgroundColor3=Color3.fromRGB(18,18,18),
            }, page)
            Round(F, 10)
            New("UIStroke", { Color=cfg.Border, Thickness=1 }, F)

            local VLbl = New("TextLabel", {
                Position=UDim2.new(1,-55,0,0), Size=UDim2.new(0,50,0,30),
                Text=tostring(def), TextColor3=THEME, Font=BF, TextSize=13,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right,
            }, F)

            New("TextLabel", {
                Text="  "..label, Size=UDim2.new(1,-60,0,30),
                TextColor3=Color3.fromRGB(210,210,210), Font=MF, TextSize=14,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
            }, F)

            local Track = New("Frame", {
                Size=UDim2.new(1,-24,0,6), Position=UDim2.new(0,12,0,46),
                BackgroundColor3=Color3.fromRGB(40,40,40),
            }, F)
            Round(Track, 3)

            local Fill = New("Frame", { Size=UDim2.new(0,0,1,0), BackgroundColor3=THEME }, Track)
            Round(Fill, 3)

            local Knob = New("Frame", {
                Size=UDim2.new(0,14,0,14), AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(0,0,0.5,0), BackgroundColor3=Color3.new(1,1,1), ZIndex=2,
            }, Track)
            Round(Knob, 7)

            local val = def
            local function SetVal(v)
                v = math.clamp(math.round((v-mn)/step)*step+mn, mn, mx)
                val = v
                local pct = (v-mn)/(mx-mn)
                Tween(Fill, 0.05, { Size=UDim2.new(pct,0,1,0) })
                Tween(Knob, 0.05, { Position=UDim2.new(pct,0,0.5,0) })
                VLbl.Text = tostring(v)
                callback(v)
            end
            SetVal(def)

            local sliding = false
            local function fromMouse(x)
                local pct = math.clamp((x-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)
                SetVal(mn + pct*(mx-mn))
            end

            local tc = Track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding=true fromMouse(i.Position.X) end
            end)
            local mc = UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then fromMouse(i.Position.X) end
            end)
            local ec = UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
            end)
            table.insert(Window._connections, tc)
            table.insert(Window._connections, mc)
            table.insert(Window._connections, ec)

            local ctrl = {}
            function ctrl:Set(v) SetVal(v) end
            function ctrl:Get() return val end
            return ctrl
        end

        -- ── Button ───────────────────────────
        function api:AddButton(label, callback)
            callback = callback or function() end

            local Btn = New("TextButton", {
                Size=UDim2.new(1,0,0,44), BackgroundColor3=Color3.fromRGB(22,22,22),
                Text="", AutoButtonColor=false,
            }, page)
            Round(Btn, 10)
            New("UIStroke", { Color=cfg.Border, Thickness=1 }, Btn)

            New("TextLabel", {
                Text=label, Size=UDim2.new(1,0,1,0),
                TextColor3=Color3.fromRGB(220,220,220), Font=BF, TextSize=14,
                BackgroundTransparency=1,
            }, Btn)

            local ULine = New("Frame", {
                Size=UDim2.new(0,0,0,2), Position=UDim2.new(0.5,0,1,-2),
                AnchorPoint=Vector2.new(0.5,0), BackgroundColor3=THEME,
            }, Btn)
            Round(ULine, 1)

            Btn.MouseButton1Click:Connect(function()
                if Window._destroyed then return end
                callback()
                Tween(ULine, 0.15, { Size=UDim2.new(0.6,0,0,2) })
                task.delay(0.35, function() Tween(ULine, 0.2, { Size=UDim2.new(0,0,0,2) }) end)
            end)
            Btn.MouseEnter:Connect(function() Tween(Btn, 0.1, { BackgroundColor3=Color3.fromRGB(28,28,28) }) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, 0.1, { BackgroundColor3=Color3.fromRGB(22,22,22) }) end)
        end

        -- ── Label ────────────────────────────
        function api:AddLabel(text)
            local lbl = New("TextLabel", {
                Size=UDim2.new(1,0,0,30), BackgroundTransparency=1,
                Text="  "..text, TextColor3=Color3.fromRGB(115,115,115),
                Font=MF, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left,
            }, page)
            local ctrl = {}
            function ctrl:Set(t) lbl.Text = "  "..t end
            return ctrl
        end

        -- ── Separator ────────────────────────
        function api:AddSeparator()
            New("Frame", { Size=UDim2.new(1,0,0,1), BackgroundColor3=cfg.Border, BorderSizePixel=0 }, page)
        end

        -- ── Dropdown ─────────────────────────
        function api:AddDropdown(label, items, callback)
            callback = callback or function() end
            local selected = items[1] or ""

            local Wrap = New("Frame", {
                Size=UDim2.new(1,0,0,50), BackgroundColor3=Color3.fromRGB(18,18,18),
                ClipsDescendants=false, ZIndex=10,
            }, page)
            Round(Wrap, 10)
            New("UIStroke", { Color=cfg.Border, Thickness=1 }, Wrap)

            New("TextLabel", {
                Text="  "..label, Size=UDim2.new(0.5,0,1,0),
                TextColor3=Color3.fromRGB(210,210,210), Font=MF, TextSize=15,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=10,
            }, Wrap)

            local Sel = New("TextButton", {
                Size=UDim2.new(0,130,0,32), Position=UDim2.new(1,-138,0.5,-16),
                BackgroundColor3=Color3.fromRGB(28,28,28),
                Text=selected.."  ▾", TextColor3=THEME,
                Font=MF, TextSize=13, ZIndex=10,
            }, Wrap)
            Round(Sel, 8)

            local Drop = New("Frame", {
                Size=UDim2.new(0,130,0,0), Position=UDim2.new(1,-138,1,4),
                BackgroundColor3=Color3.fromRGB(22,22,22),
                ClipsDescendants=true, ZIndex=20, Visible=false,
            }, Wrap)
            Round(Drop, 8)
            New("UIStroke", { Color=cfg.Border, Thickness=1, ZIndex=20 }, Drop)

            local IL = New("Frame", { Size=UDim2.new(1,0,0,#items*32), BackgroundTransparency=1, ZIndex=20 }, Drop)
            List(IL, 0)

            local open = false
            local function Ref() Sel.Text = selected.."  "..(open and "▴" or "▾") end

            for _, item in ipairs(items) do
                local Itm = New("TextButton", {
                    Size=UDim2.new(1,0,0,32), BackgroundColor3=Color3.fromRGB(22,22,22),
                    Text="  "..item, TextColor3=Color3.fromRGB(200,200,200),
                    Font=MF, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=20, AutoButtonColor=false,
                }, IL)
                Itm.MouseEnter:Connect(function() Tween(Itm,0.1,{BackgroundColor3=Color3.fromRGB(30,30,30)}) end)
                Itm.MouseLeave:Connect(function() Tween(Itm,0.1,{BackgroundColor3=Color3.fromRGB(22,22,22)}) end)
                Itm.MouseButton1Click:Connect(function()
                    selected=item open=false
                    Tween(Drop,0.15,{Size=UDim2.new(0,130,0,0)})
                    task.wait(0.15) Drop.Visible=false
                    Ref() callback(item)
                end)
            end

            Sel.MouseButton1Click:Connect(function()
                open=not open Ref()
                if open then
                    Drop.Visible=true Drop.Size=UDim2.new(0,130,0,0)
                    Tween(Drop,0.2,{Size=UDim2.new(0,130,0,#items*32)})
                else
                    Tween(Drop,0.15,{Size=UDim2.new(0,130,0,0)})
                    task.wait(0.15) Drop.Visible=false
                end
            end)

            local ctrl={}
            function ctrl:Set(v) selected=v Ref() callback(v) end
            function ctrl:Get() return selected end
            return ctrl
        end

        -- ── Keybind ──────────────────────────
        function api:AddKeybind(label, default, callback)
            callback = callback or function() end
            local key = default or Enum.KeyCode.Unknown
            local listening = false

            local F = New("Frame", {
                Size=UDim2.new(1,0,0,50), BackgroundColor3=Color3.fromRGB(18,18,18),
            }, page)
            Round(F, 10)
            New("UIStroke", { Color=cfg.Border, Thickness=1 }, F)

            New("TextLabel", {
                Text="  "..label, Size=UDim2.new(0.6,0,1,0),
                TextColor3=Color3.fromRGB(210,210,210), Font=MF, TextSize=15,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
            }, F)

            local KB = New("TextButton", {
                Size=UDim2.new(0,100,0,30), Position=UDim2.new(1,-108,0.5,-15),
                BackgroundColor3=Color3.fromRGB(28,28,28),
                Text=tostring(key.Name), TextColor3=THEME,
                Font=MF, TextSize=13,
            }, F)
            Round(KB, 8)

            KB.MouseButton1Click:Connect(function()
                listening=true KB.Text="..." KB.TextColor3=Color3.fromRGB(190,190,190)
            end)

            local kc = UserInputService.InputBegan:Connect(function(i, g)
                if Window._destroyed then return end
                if listening and not g then
                    listening=false key=i.KeyCode
                    KB.Text=tostring(key.Name) KB.TextColor3=THEME
                elseif not g and i.KeyCode==key then
                    callback()
                end
            end)
            table.insert(Window._connections, kc)

            local ctrl={}
            function ctrl:Set(k) key=k KB.Text=tostring(k.Name) end
            function ctrl:Get() return key end
            return ctrl
        end

        -- ── ColorPicker ──────────────────────
        function api:AddColorPicker(label, default, callback)
            callback = callback or function() end
            default  = default  or Color3.fromRGB(255,0,0)
            local color = default
            local H, S, V = Color3.toHSV(color)

            local F = New("Frame", {
                Size=UDim2.new(1,0,0,50), BackgroundColor3=Color3.fromRGB(18,18,18),
                ClipsDescendants=false, ZIndex=5,
            }, page)
            Round(F, 10)
            New("UIStroke", { Color=cfg.Border, Thickness=1 }, F)

            New("TextLabel", {
                Text="  "..label, Size=UDim2.new(0.6,0,1,0),
                TextColor3=Color3.fromRGB(210,210,210), Font=MF, TextSize=15,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=5,
            }, F)

            local Swatch = New("TextButton", {
                Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-42,0.5,-16),
                BackgroundColor3=color, Text="", ZIndex=5,
            }, F)
            Round(Swatch, 8)
            New("UIStroke", { Color=cfg.Border, Thickness=1, ZIndex=5 }, Swatch)

            local Picker = New("Frame", {
                Size=UDim2.new(0,200,0,160), Position=UDim2.new(1,-208,1,6),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                ClipsDescendants=true, ZIndex=30, Visible=false,
            }, F)
            Round(Picker, 10)
            New("UIStroke", { Color=cfg.Border, Thickness=1, ZIndex=30 }, Picker)

            local HG = New("Frame", { Size=UDim2.new(1,-20,0,14), Position=UDim2.new(0,10,0,10), ZIndex=31 }, Picker)
            Round(HG, 4)
            New("UIGradient", {
                Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                    ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,0)),
                }),
            }, HG)

            local HC = New("Frame", { Size=UDim2.new(0,4,1,4), Position=UDim2.new(H,-2,0,-2), BackgroundColor3=Color3.new(1,1,1), ZIndex=32 }, HG)
            Round(HC, 2)

            local SV = New("Frame", { Size=UDim2.new(1,-20,0,100), Position=UDim2.new(0,10,0,32), ZIndex=31, BackgroundColor3=Color3.fromHSV(H,1,1) }, Picker)
            Round(SV, 6)
            New("UIGradient", { Color=ColorSequence.new(Color3.new(1,1,1),Color3.new(1,1,1)), Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) }, SV)
            local VO = New("Frame", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, ZIndex=32 }, SV)
            New("UIGradient", { Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0)), Rotation=90, Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}) }, VO)

            local SC = New("Frame", { Size=UDim2.new(0,10,0,10), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(S,0,1-V,0), BackgroundColor3=Color3.new(1,1,1), ZIndex=33 }, SV)
            Round(SC, 5)

            local function UCol()
                color=Color3.fromHSV(H,S,V)
                Swatch.BackgroundColor3=color
                SV.BackgroundColor3=Color3.fromHSV(H,1,1)
                SC.Position=UDim2.new(S,0,1-V,0)
                HC.Position=UDim2.new(H,-2,0,-2)
                callback(color)
            end

            local hd, sd = false, false
            local p1=HG.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hd=true H=math.clamp((i.Position.X-HG.AbsolutePosition.X)/HG.AbsoluteSize.X,0,1) UCol() end end)
            local p2=SV.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sd=true S=math.clamp((i.Position.X-SV.AbsolutePosition.X)/SV.AbsoluteSize.X,0,1) V=1-math.clamp((i.Position.Y-SV.AbsolutePosition.Y)/SV.AbsoluteSize.Y,0,1) UCol() end end)
            local p3=UserInputService.InputChanged:Connect(function(i)
                if i.UserInputType~=Enum.UserInputType.MouseMovement then return end
                if hd then H=math.clamp((i.Position.X-HG.AbsolutePosition.X)/HG.AbsoluteSize.X,0,1) UCol() end
                if sd then S=math.clamp((i.Position.X-SV.AbsolutePosition.X)/SV.AbsoluteSize.X,0,1) V=1-math.clamp((i.Position.Y-SV.AbsolutePosition.Y)/SV.AbsoluteSize.Y,0,1) UCol() end
            end)
            local p4=UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hd=false sd=false end end)
            table.insert(Window._connections, p1)
            table.insert(Window._connections, p2)
            table.insert(Window._connections, p3)
            table.insert(Window._connections, p4)

            Swatch.MouseButton1Click:Connect(function() Picker.Visible=not Picker.Visible end)

            local ctrl={}
            function ctrl:Set(c) color=c H,S,V=Color3.toHSV(c) UCol() end
            function ctrl:Get() return color end
            return ctrl
        end

        return api
    end

    -- ─────────────────────────────────────────
    --  AddTab
    -- ─────────────────────────────────────────

    function Window:AddTab(name, icon)
        local Page = New("ScrollingFrame", {
            Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Visible=false, ScrollBarThickness=2,
            ScrollBarImageColor3=THEME,
            CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
        }, PageCon)
        List(Page, 10)
        Pad(Page, 4, 10, 0, 0)

        local TabBtn = New("TextButton", {
            Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(18,18,18),
            Text=(icon and icon.."  " or "  ")..name,
            TextColor3=Color3.fromRGB(140,140,140),
            Font=BF, TextSize=14,
            TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false,
        }, SideScroll)
        Round(TabBtn, 10)
        Pad(TabBtn, 0, 0, 10, 0)

        local Bar = New("Frame", {
            Size=UDim2.new(0,3,0,22), Position=UDim2.new(0,0,0.5,-11),
            BackgroundColor3=THEME, BackgroundTransparency=1,
        }, TabBtn)
        Round(Bar, 2)

        TabBtn.MouseButton1Click:Connect(function()
            if self._destroyed then return end
            for _, t in ipairs(self._tabs) do
                t.page.Visible=false
                Tween(t.btn,0.15,{TextColor3=Color3.fromRGB(140,140,140),BackgroundColor3=Color3.fromRGB(18,18,18)})
                Tween(t.bar,0.15,{BackgroundTransparency=1})
            end
            Page.Visible=true self._currentPage=Page
            Tween(TabBtn,0.15,{TextColor3=THEME,BackgroundColor3=Color3.fromRGB(22,22,22)})
            Tween(Bar,0.15,{BackgroundTransparency=0})
        end)

        table.insert(self._tabs, { page=Page, btn=TabBtn, bar=Bar })

        if #self._tabs == 1 then
            Page.Visible=true self._currentPage=Page
            TabBtn.TextColor3=THEME TabBtn.BackgroundColor3=Color3.fromRGB(22,22,22)
            Bar.BackgroundTransparency=0
        end

        local tab = ElementAPI(Page)
        tab._page = Page
        return tab
    end

    -- ─────────────────────────────────────────
    --  ЗАПУСК
    -- ─────────────────────────────────────────

    if cfg.KeySystem then
        ShowKeySystem(cfg, function()
            ToggleUI()
        end)
    else
        ToggleUI()
    end

    return Window
end

return ViloniX
