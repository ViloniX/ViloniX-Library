--[[
    ViloniXLib — UI Library for Roblox
    
    Использование:
    
    local ViloniX = loadstring(game:HttpGet("..."))()
    
    local Window = ViloniX.CreateWindow({
        Title = "MyHub",
        Theme = Color3.fromRGB(0, 255, 120),
    })
    
    local Tab = Window:AddTab("AimBot")
    
    Tab:AddToggle("Enable AimBot", false, function(val) print(val) end)
    Tab:AddSlider("FOV", {Min=1, Max=360, Default=90}, function(val) print(val) end)
    Tab:AddButton("Click Me", function() print("clicked") end)
    Tab:AddLabel("Some info text")
    Tab:AddDropdown("Method", {"Humanoid", "Root", "Head"}, function(val) print(val) end)
    Tab:AddKeybind("Toggle Key", Enum.KeyCode.E, function() print("triggered") end)
    Tab:AddColorPicker("Color", Color3.fromRGB(255,0,0), function(col) print(col) end)
]]

local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
local Players           = game:GetService("Players")
local Lighting          = game:GetService("Lighting")
local RunService        = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ─────────────────────────────────────────────
--  UTILS
-- ─────────────────────────────────────────────

local function Round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
    return c
end

local function Tween(obj, t, props, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    local tw = TweenService:Create(obj, TweenInfo.new(t, style, dir), props)
    tw:Play()
    return tw
end

local function MakePadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    p.Parent = parent
    return p
end

local function MakeListLayout(parent, padding, fillDir)
    local l = Instance.new("UIListLayout")
    l.Padding          = UDim.new(0, padding or 8)
    l.FillDirection    = fillDir or Enum.FillDirection.Vertical
    l.SortOrder        = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

-- ─────────────────────────────────────────────
--  LIBRARY TABLE
-- ─────────────────────────────────────────────

local ViloniX = {}
ViloniX.__index = ViloniX

-- ─────────────────────────────────────────────
--  WINDOW
-- ─────────────────────────────────────────────

function ViloniX.CreateWindow(options)
    options = options or {}

    local cfg = {
        Title       = options.Title       or "ViloniXHub",
        SubTitle    = options.SubTitle    or "v1.0",
        Theme       = options.Theme       or Color3.fromRGB(0, 255, 120),
        Background  = options.Background  or Color3.fromRGB(10, 10, 10),
        Border      = options.Border      or Color3.fromRGB(55, 55, 55),
        ToggleKey   = options.ToggleKey   or Enum.KeyCode.RightShift,
        Size        = options.Size        or Vector2.new(640, 450),
    }

    -- Clean old instance
    if CoreGui:FindFirstChild("ViloniXHub_" .. cfg.Title) then
        CoreGui:FindFirstChild("ViloniXHub_" .. cfg.Title):Destroy()
    end

    local BoldFont = Enum.Font.GothamBold
    local MainFont = Enum.Font.Ubuntu

    -- ScreenGui
    local ScreenGui = New("ScreenGui", {
        Name          = "ViloniXHub_" .. cfg.Title,
        ResetOnSpawn  = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    -- Blur
    local Blur = New("BlurEffect", { Size = 0, Enabled = false }, Lighting)

    -- Main Frame
    local W, H = cfg.Size.X, cfg.Size.Y
    local Main = New("Frame", {
        Name              = "Main",
        Size              = UDim2.new(0, W, 0, H),
        Position          = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint       = Vector2.new(0.5, 0.5),
        BackgroundColor3  = cfg.Background,
        BorderSizePixel   = 0,
        ClipsDescendants  = true,
        Visible           = false,
    }, ScreenGui)
    Round(Main, 14)

    -- Shadow
    local Shadow = New("ImageLabel", {
        AnchorPoint          = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position             = UDim2.new(0.5, 0, 0.5, 6),
        Size                 = UDim2.new(1, 40, 1, 40),
        Image                = "rbxassetid://6014261993",
        ImageColor3          = Color3.new(0,0,0),
        ImageTransparency    = 0.5,
        ScaleType            = Enum.ScaleType.Slice,
        SliceCenter          = Rect.new(49,49,450,450),
        ZIndex               = 0,
    }, Main)

    -- ── Divider lines ──────────────────────────
    local function Line(pos, size)
        return New("Frame", {
            BackgroundColor3 = cfg.Border,
            BorderSizePixel  = 0,
            Position         = pos,
            Size             = size,
        }, Main)
    end

    Line(UDim2.new(0, 0, 0, 62),   UDim2.new(1, 0, 0, 1))
    Line(UDim2.new(0, 192, 0, 62), UDim2.new(0, 1, 1, -62))
    Line(UDim2.new(0, 0, 1, -112), UDim2.new(0, 192, 0, 1))

    -- ── Top Bar ───────────────────────────────
    local TopBar = New("Frame", {
        Size                 = UDim2.new(1, 0, 0, 62),
        BackgroundTransparency = 1,
    }, Main)

    -- Logo diamond
    local LogoBase = New("Frame", {
        Size             = UDim2.new(0, 32, 0, 32),
        Position         = UDim2.new(0, 18, 0.5, -16),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        Rotation         = 45,
    }, TopBar)
    Round(LogoBase, 6)
    New("UIStroke", { Color = cfg.Theme, Thickness = 2 }, LogoBase)
    New("TextLabel", {
        Size                 = UDim2.new(1, 0, 1, 0),
        Rotation             = -45,
        Text                 = string.sub(cfg.Title, 1, 1),
        Font                 = BoldFont,
        TextSize             = 20,
        TextColor3           = cfg.Theme,
        BackgroundTransparency = 1,
    }, LogoBase)

    New("TextLabel", {
        Text                 = cfg.Title,
        Position             = UDim2.new(0, 68, 0, 0),
        Size                 = UDim2.new(0, 220, 1, 0),
        TextColor3           = cfg.Theme,
        Font                 = BoldFont,
        TextSize             = 22,
        TextXAlignment       = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
    }, TopBar)

    New("TextLabel", {
        Text                 = cfg.SubTitle,
        Position             = UDim2.new(1, -120, 0, 0),
        Size                 = UDim2.new(0, 100, 1, 0),
        TextColor3           = Color3.fromRGB(80, 80, 80),
        Font                 = MainFont,
        TextSize             = 13,
        TextXAlignment       = Enum.TextXAlignment.Right,
        BackgroundTransparency = 1,
    }, TopBar)

    -- Close button
    local CloseBtn = New("TextButton", {
        Size             = UDim2.new(0, 34, 0, 34),
        Position         = UDim2.new(1, -48, 0, 14),
        BackgroundColor3 = cfg.Theme,
        Text             = "✕",
        TextColor3       = Color3.fromRGB(10, 10, 10),
        Font             = BoldFont,
        TextSize         = 16,
    }, Main)
    Round(CloseBtn, 8)

    -- ── Sidebar ───────────────────────────────
    local SidebarScroll = New("ScrollingFrame", {
        Position             = UDim2.new(0, 12, 0, 74),
        Size                 = UDim2.new(0, 168, 1, -186),
        BackgroundTransparency = 1,
        ScrollBarThickness   = 0,
        CanvasSize           = UDim2.new(0,0,0,0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        ClipsDescendants     = true,
    }, Main)
    MakeListLayout(SidebarScroll, 6)

    -- ── Page Container ────────────────────────
    local PageContainer = New("Frame", {
        Position             = UDim2.new(0, 205, 0, 72),
        Size                 = UDim2.new(1, -220, 1, -90),
        BackgroundTransparency = 1,
    }, Main)

    -- ── Profile ───────────────────────────────
    local Profile = New("Frame", {
        Size                 = UDim2.new(0, 185, 0, 105),
        Position             = UDim2.new(0, 4, 1, -108),
        BackgroundTransparency = 1,
    }, Main)

    local ok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)

    local Av = New("ImageLabel", {
        Size             = UDim2.new(0, 50, 0, 50),
        Position         = UDim2.new(0, 10, 0.5, -25),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Image            = ok and thumb or "",
    }, Profile)
    Round(Av, 25)
    New("UIStroke", { Color = cfg.Theme, Thickness = 1.5 }, Av)

    local function ProfileLbl(txt, y, col, sz, f)
        return New("TextLabel", {
            Text                 = txt,
            Position             = UDim2.new(0, 70, 0, y),
            Size                 = UDim2.new(1, -75, 0, 18),
            TextColor3           = col,
            Font                 = f,
            TextSize             = sz,
            BackgroundTransparency = 1,
            TextXAlignment       = Enum.TextXAlignment.Left,
        }, Profile)
    end

    ProfileLbl(LocalPlayer.Name,                        14, Color3.new(1,1,1),           14, BoldFont)
    ProfileLbl("ID: " .. LocalPlayer.UserId,            34, Color3.fromRGB(100,100,100), 11, MainFont)
    ProfileLbl("● Online",                              54, cfg.Theme,                   12, BoldFont)

    -- ── Floating open button ──────────────────
    local FloatBtn = New("TextButton", {
        Size             = UDim2.new(0, 44, 0, 44),
        Position         = UDim2.new(0.5, -22, 0, 70),
        BackgroundColor3 = cfg.Background,
        Text             = string.sub(cfg.Title, 1, 1),
        TextColor3       = cfg.Theme,
        Font             = BoldFont,
        TextSize         = 22,
    }, ScreenGui)
    Round(FloatBtn, 22)
    New("UIStroke", { Color = cfg.Theme, Thickness = 1.5 }, FloatBtn)

    -- ─────────────────────────────────────────
    --  TOGGLE / ANIMATION
    -- ─────────────────────────────────────────

    local function ToggleUI()
        if not Main.Visible then
            Main.Size    = UDim2.new(0, 0, 0, 0)
            Main.Visible = true
            Blur.Enabled = true
            Tween(Main, 0.4, { Size = UDim2.new(0, W, 0, H) })
            Tween(Blur, 0.4, { Size = 22 })
        else
            local t1 = Tween(Main, 0.3, { Size = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            Tween(Blur, 0.3, { Size = 0 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            t1.Completed:Once(function()
                Main.Visible = false
                Blur.Enabled = false
            end)
        end
    end

    CloseBtn.MouseButton1Click:Connect(ToggleUI)
    FloatBtn.MouseButton1Click:Connect(ToggleUI)
    UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == cfg.ToggleKey then ToggleUI() end
    end)

    -- ─────────────────────────────────────────
    --  DRAGGING
    -- ─────────────────────────────────────────

    do
        local dragging, dragStart, startPos
        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging  = true
                dragStart = input.Position
                startPos  = Main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (
                input.UserInputType == Enum.UserInputType.MouseMovement or
                input.UserInputType == Enum.UserInputType.Touch
            ) then
                local d = input.Position - dragStart
                Tween(Main, 0.07, {
                    Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + d.X,
                        startPos.Y.Scale, startPos.Y.Offset + d.Y
                    )
                }, Enum.EasingStyle.Linear)
            end
        end)
    end

    -- ─────────────────────────────────────────
    --  WINDOW OBJECT
    -- ─────────────────────────────────────────

    local Window   = { _cfg = cfg, _tabs = {}, _currentPage = nil }
    local BF, MF   = BoldFont, MainFont
    local THEME    = cfg.Theme
    local BG       = cfg.Background
    local BORDER   = cfg.Border

    -- ── ELEMENT BUILDERS ─────────────────────

    -- returns element helpers bound to a given ScrollingFrame (page)
    local function ElementAPI(page)
        local api = {}

        -- ── Toggle ───────────────────────────
        function api:AddToggle(label, default, callback)
            default  = default  or false
            callback = callback or function() end

            local Frame = New("TextButton", {
                Size             = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Text             = "",
                AutoButtonColor  = false,
            }, page)
            Round(Frame, 10)
            New("UIStroke", { Color = BORDER, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Frame)

            New("TextLabel", {
                Text                 = "  " .. label,
                Size                 = UDim2.new(1, -55, 1, 0),
                TextColor3           = Color3.fromRGB(210, 210, 210),
                Font                 = MF,
                TextSize             = 15,
                BackgroundTransparency = 1,
                TextXAlignment       = Enum.TextXAlignment.Left,
            }, Frame)

            -- pill track
            local Track = New("Frame", {
                Size             = UDim2.new(0, 40, 0, 22),
                Position         = UDim2.new(1, -50, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            }, Frame)
            Round(Track, 11)

            local Knob = New("Frame", {
                Size             = UDim2.new(0, 16, 0, 16),
                Position         = UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(90, 90, 90),
            }, Track)
            Round(Knob, 8)

            local active = default
            local function Refresh()
                Tween(Track, 0.2, { BackgroundColor3 = active and THEME or Color3.fromRGB(35,35,35) })
                Tween(Knob,  0.2, {
                    Position         = active and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
                    BackgroundColor3 = active and Color3.fromRGB(10,10,10) or Color3.fromRGB(90,90,90),
                })
                callback(active)
            end
            if default then Refresh() end

            Frame.MouseButton1Click:Connect(function()
                active = not active
                Refresh()
            end)

            local ctrl = {}
            function ctrl:Set(val)
                active = val
                Refresh()
            end
            function ctrl:Get() return active end
            return ctrl
        end

        -- ── Slider ───────────────────────────
        function api:AddSlider(label, opts, callback)
            opts     = opts     or {}
            callback = callback or function() end
            local min  = opts.Min     or 0
            local max  = opts.Max     or 100
            local def  = opts.Default or math.floor((min + max) / 2)
            local step = opts.Step    or 1

            local Frame = New("Frame", {
                Size             = UDim2.new(1, 0, 0, 68),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
            }, page)
            Round(Frame, 10)
            New("UIStroke", { Color = BORDER, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Frame)

            local ValLbl = New("TextLabel", {
                Position             = UDim2.new(1, -55, 0, 0),
                Size                 = UDim2.new(0, 50, 0, 30),
                Text                 = tostring(def),
                TextColor3           = THEME,
                Font                 = BF,
                TextSize             = 13,
                BackgroundTransparency = 1,
                TextXAlignment       = Enum.TextXAlignment.Right,
            }, Frame)

            New("TextLabel", {
                Text                 = "  " .. label,
                Size                 = UDim2.new(1, -60, 0, 30),
                TextColor3           = Color3.fromRGB(210, 210, 210),
                Font                 = MF,
                TextSize             = 14,
                BackgroundTransparency = 1,
                TextXAlignment       = Enum.TextXAlignment.Left,
            }, Frame)

            local Track = New("Frame", {
                Size             = UDim2.new(1, -24, 0, 6),
                Position         = UDim2.new(0, 12, 0, 46),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            }, Frame)
            Round(Track, 3)

            local Fill = New("Frame", {
                Size             = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = THEME,
            }, Track)
            Round(Fill, 3)

            local Knob = New("Frame", {
                Size             = UDim2.new(0, 14, 0, 14),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3 = Color3.new(1,1,1),
                ZIndex           = 2,
            }, Track)
            Round(Knob, 7)

            local value = def

            local function SetValue(v)
                v = math.clamp(math.round((v - min) / step) * step + min, min, max)
                value = v
                local pct = (v - min) / (max - min)
                Tween(Fill, 0.05, { Size = UDim2.new(pct, 0, 1, 0) })
                Tween(Knob, 0.05, { Position = UDim2.new(pct, 0, 0.5, 0) })
                ValLbl.Text = tostring(v)
                callback(v)
            end
            SetValue(def)

            local sliding = false
            local function UpdateFromMouse(x)
                local abs = Track.AbsolutePosition.X
                local w   = Track.AbsoluteSize.X
                local pct = math.clamp((x - abs) / w, 0, 1)
                SetValue(min + pct * (max - min))
            end

            Track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    UpdateFromMouse(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateFromMouse(i.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)

            local ctrl = {}
            function ctrl:Set(v) SetValue(v) end
            function ctrl:Get() return value end
            return ctrl
        end

        -- ── Button ───────────────────────────
        function api:AddButton(label, callback)
            callback = callback or function() end

            local Btn = New("TextButton", {
                Size             = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                Text             = "",
                AutoButtonColor  = false,
            }, page)
            Round(Btn, 10)
            New("UIStroke", { Color = BORDER, Thickness = 1 }, Btn)

            New("TextLabel", {
                Text                 = label,
                Size                 = UDim2.new(1, 0, 1, 0),
                TextColor3           = Color3.fromRGB(220, 220, 220),
                Font                 = BF,
                TextSize             = 14,
                BackgroundTransparency = 1,
            }, Btn)

            local Line = New("Frame", {
                Size             = UDim2.new(0, 0, 0, 2),
                Position         = UDim2.new(0.5, 0, 1, -2),
                AnchorPoint      = Vector2.new(0.5, 0),
                BackgroundColor3 = THEME,
            }, Btn)
            Round(Line, 1)

            Btn.MouseButton1Click:Connect(function()
                callback()
                Tween(Line, 0.15, { Size = UDim2.new(0.6, 0, 0, 2) })
                task.delay(0.3, function()
                    Tween(Line, 0.2, { Size = UDim2.new(0, 0, 0, 2) })
                end)
            end)

            Btn.MouseEnter:Connect(function()
                Tween(Btn, 0.15, { BackgroundColor3 = Color3.fromRGB(28, 28, 28) })
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, 0.15, { BackgroundColor3 = Color3.fromRGB(22, 22, 22) })
            end)
        end

        -- ── Label ────────────────────────────
        function api:AddLabel(text)
            local lbl = New("TextLabel", {
                Size                 = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Text                 = "  " .. text,
                TextColor3           = Color3.fromRGB(120, 120, 120),
                Font                 = MF,
                TextSize             = 13,
                TextXAlignment       = Enum.TextXAlignment.Left,
            }, page)
            local ctrl = {}
            function ctrl:Set(t) lbl.Text = "  " .. t end
            return ctrl
        end

        -- ── Separator ────────────────────────
        function api:AddSeparator()
            New("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = BORDER,
                BorderSizePixel  = 0,
            }, page)
        end

        -- ── Dropdown ─────────────────────────
        function api:AddDropdown(label, items, callback)
            callback = callback or function() end
            local selected = items[1] or ""

            local Wrap = New("Frame", {
                Size             = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                ClipsDescendants = false,
                ZIndex           = 10,
            }, page)
            Round(Wrap, 10)
            New("UIStroke", { Color = BORDER, Thickness = 1 }, Wrap)

            New("TextLabel", {
                Text                 = "  " .. label,
                Size                 = UDim2.new(0.5, 0, 1, 0),
                TextColor3           = Color3.fromRGB(210, 210, 210),
                Font                 = MF,
                TextSize             = 15,
                BackgroundTransparency = 1,
                TextXAlignment       = Enum.TextXAlignment.Left,
                ZIndex               = 10,
            }, Wrap)

            local SelBtn = New("TextButton", {
                Size             = UDim2.new(0, 130, 0, 32),
                Position         = UDim2.new(1, -138, 0.5, -16),
                BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                Text             = selected .. "  ▾",
                TextColor3       = THEME,
                Font             = MF,
                TextSize         = 13,
                ZIndex           = 10,
            }, Wrap)
            Round(SelBtn, 8)

            local DropFrame = New("Frame", {
                Size             = UDim2.new(0, 130, 0, 0),
                Position         = UDim2.new(1, -138, 1, 4),
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                ClipsDescendants = true,
                ZIndex           = 20,
                Visible          = false,
            }, Wrap)
            Round(DropFrame, 8)
            New("UIStroke", { Color = BORDER, Thickness = 1, ZIndex = 20 }, DropFrame)

            local ItemList = New("Frame", {
                Size                 = UDim2.new(1, 0, 0, #items * 32),
                BackgroundTransparency = 1,
                ZIndex               = 20,
            }, DropFrame)
            MakeListLayout(ItemList, 0)

            local open = false
            local function Refresh()
                SelBtn.Text = selected .. "  " .. (open and "▴" or "▾")
            end

            for _, item in ipairs(items) do
                local Itm = New("TextButton", {
                    Size             = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                    Text             = "  " .. item,
                    TextColor3       = Color3.fromRGB(200, 200, 200),
                    Font             = MF,
                    TextSize         = 13,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 20,
                    AutoButtonColor  = false,
                }, ItemList)

                Itm.MouseEnter:Connect(function()
                    Tween(Itm, 0.1, { BackgroundColor3 = Color3.fromRGB(30, 30, 30) })
                end)
                Itm.MouseLeave:Connect(function()
                    Tween(Itm, 0.1, { BackgroundColor3 = Color3.fromRGB(22, 22, 22) })
                end)
                Itm.MouseButton1Click:Connect(function()
                    selected = item
                    open = false
                    Tween(DropFrame, 0.15, { Size = UDim2.new(0, 130, 0, 0) })
                    task.wait(0.15)
                    DropFrame.Visible = false
                    Refresh()
                    callback(item)
                end)
            end

            SelBtn.MouseButton1Click:Connect(function()
                open = not open
                Refresh()
                if open then
                    DropFrame.Visible = true
                    DropFrame.Size    = UDim2.new(0, 130, 0, 0)
                    Tween(DropFrame, 0.2, { Size = UDim2.new(0, 130, 0, #items * 32) })
                else
                    Tween(DropFrame, 0.15, { Size = UDim2.new(0, 130, 0, 0) })
                    task.wait(0.15)
                    DropFrame.Visible = false
                end
            end)

            local ctrl = {}
            function ctrl:Set(v) selected = v Refresh() callback(v) end
            function ctrl:Get() return selected end
            return ctrl
        end

        -- ── Keybind ──────────────────────────
        function api:AddKeybind(label, default, callback)
            callback = callback or function() end
            local key = default or Enum.KeyCode.Unknown
            local listening = false

            local Frame = New("Frame", {
                Size             = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
            }, page)
            Round(Frame, 10)
            New("UIStroke", { Color = BORDER, Thickness = 1 }, Frame)

            New("TextLabel", {
                Text                 = "  " .. label,
                Size                 = UDim2.new(0.6, 0, 1, 0),
                TextColor3           = Color3.fromRGB(210, 210, 210),
                Font                 = MF,
                TextSize             = 15,
                BackgroundTransparency = 1,
                TextXAlignment       = Enum.TextXAlignment.Left,
            }, Frame)

            local KeyBtn = New("TextButton", {
                Size             = UDim2.new(0, 100, 0, 30),
                Position         = UDim2.new(1, -108, 0.5, -15),
                BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                Text             = tostring(key.Name or key),
                TextColor3       = THEME,
                Font             = MF,
                TextSize         = 13,
            }, Frame)
            Round(KeyBtn, 8)

            KeyBtn.MouseButton1Click:Connect(function()
                listening        = true
                KeyBtn.Text      = "..."
                KeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end)

            UserInputService.InputBegan:Connect(function(i, g)
                if listening and not g then
                    listening        = false
                    key              = i.KeyCode
                    KeyBtn.Text      = tostring(key.Name)
                    KeyBtn.TextColor3 = THEME
                elseif not g and i.KeyCode == key then
                    callback()
                end
            end)

            local ctrl = {}
            function ctrl:Set(k) key = k KeyBtn.Text = tostring(k.Name) end
            function ctrl:Get() return key end
            return ctrl
        end

        -- ── ColorPicker ──────────────────────
        function api:AddColorPicker(label, default, callback)
            callback = callback or function() end
            default  = default  or Color3.fromRGB(255, 0, 0)
            local color = default

            local Frame = New("Frame", {
                Size             = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                ClipsDescendants = false,
                ZIndex           = 5,
            }, page)
            Round(Frame, 10)
            New("UIStroke", { Color = BORDER, Thickness = 1 }, Frame)

            New("TextLabel", {
                Text                 = "  " .. label,
                Size                 = UDim2.new(0.6, 0, 1, 0),
                TextColor3           = Color3.fromRGB(210, 210, 210),
                Font                 = MF,
                TextSize             = 15,
                BackgroundTransparency = 1,
                TextXAlignment       = Enum.TextXAlignment.Left,
                ZIndex               = 5,
            }, Frame)

            local Swatch = New("TextButton", {
                Size             = UDim2.new(0, 32, 0, 32),
                Position         = UDim2.new(1, -42, 0.5, -16),
                BackgroundColor3 = color,
                Text             = "",
                ZIndex           = 5,
            }, Frame)
            Round(Swatch, 8)
            New("UIStroke", { Color = BORDER, Thickness = 1, ZIndex = 5 }, Swatch)

            -- Minimal HSV picker popup
            local Picker = New("Frame", {
                Size             = UDim2.new(0, 200, 0, 160),
                Position         = UDim2.new(1, -208, 1, 6),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                ClipsDescendants = true,
                ZIndex           = 30,
                Visible          = false,
            }, Frame)
            Round(Picker, 10)
            New("UIStroke", { Color = BORDER, Thickness = 1, ZIndex = 30 }, Picker)

            -- Hue bar
            local HueGrad = New("Frame", {
                Size    = UDim2.new(1, -20, 0, 14),
                Position = UDim2.new(0, 10, 0, 10),
                ZIndex  = 31,
            }, Picker)
            Round(HueGrad, 4)
            local HG = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                    ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,0)),
                }),
            }, HueGrad)

            local H, S, V = Color3.toHSV(color)

            local HueCursor = New("Frame", {
                Size             = UDim2.new(0, 4, 1, 4),
                Position         = UDim2.new(H, -2, 0, -2),
                BackgroundColor3 = Color3.new(1,1,1),
                ZIndex           = 32,
            }, HueGrad)
            Round(HueCursor, 2)

            -- SV square
            local SVFrame = New("Frame", {
                Size     = UDim2.new(1, -20, 0, 100),
                Position = UDim2.new(0, 10, 0, 32),
                ZIndex   = 31,
                BackgroundColor3 = Color3.fromHSV(H, 1, 1),
            }, Picker)
            Round(SVFrame, 6)

            New("UIGradient", {
                Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
            }, SVFrame)

            local VOver = New("Frame", {
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                ZIndex = 32,
            }, SVFrame)
            New("UIGradient", {
                Color    = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0)),
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0),
                }),
            }, VOver)

            local SVCursor = New("Frame", {
                Size             = UDim2.new(0, 10, 0, 10),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(S, 0, 1-V, 0),
                BackgroundColor3 = Color3.new(1,1,1),
                ZIndex           = 33,
            }, SVFrame)
            Round(SVCursor, 5)

            local function UpdateColor()
                color = Color3.fromHSV(H, S, V)
                Swatch.BackgroundColor3 = color
                SVFrame.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                SVCursor.Position = UDim2.new(S, 0, 1-V, 0)
                HueCursor.Position = UDim2.new(H, -2, 0, -2)
                callback(color)
            end

            -- Hue drag
            local hDrag = false
            HueGrad.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    hDrag = true
                    local pct = math.clamp((i.Position.X - HueGrad.AbsolutePosition.X) / HueGrad.AbsoluteSize.X, 0, 1)
                    H = pct UpdateColor()
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if hDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((i.Position.X - HueGrad.AbsolutePosition.X) / HueGrad.AbsoluteSize.X, 0, 1)
                    H = pct UpdateColor()
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    hDrag = false
                end
            end)

            -- SV drag
            local svDrag = false
            SVFrame.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDrag = true
                    local ax, ay = SVFrame.AbsolutePosition.X, SVFrame.AbsolutePosition.Y
                    local aw, ah = SVFrame.AbsoluteSize.X, SVFrame.AbsoluteSize.Y
                    S = math.clamp((i.Position.X - ax) / aw, 0, 1)
                    V = 1 - math.clamp((i.Position.Y - ay) / ah, 0, 1)
                    UpdateColor()
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if svDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local ax, ay = SVFrame.AbsolutePosition.X, SVFrame.AbsolutePosition.Y
                    local aw, ah = SVFrame.AbsoluteSize.X, SVFrame.AbsoluteSize.Y
                    S = math.clamp((i.Position.X - ax) / aw, 0, 1)
                    V = 1 - math.clamp((i.Position.Y - ay) / ah, 0, 1)
                    UpdateColor()
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDrag = false
                end
            end)

            local pickerOpen = false
            Swatch.MouseButton1Click:Connect(function()
                pickerOpen = not pickerOpen
                Picker.Visible = pickerOpen
            end)

            local ctrl = {}
            function ctrl:Set(c) color = c H,S,V = Color3.toHSV(c) UpdateColor() end
            function ctrl:Get() return color end
            return ctrl
        end

        return api
    end

    -- ── AddTab ───────────────────────────────
    function Window:AddTab(name, icon)
        local Page = New("ScrollingFrame", {
            Size                 = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible              = false,
            ScrollBarThickness   = 2,
            ScrollBarImageColor3 = THEME,
            CanvasSize           = UDim2.new(0,0,0,0),
            AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        }, PageContainer)
        MakeListLayout(Page, 10)
        MakePadding(Page, 4, 10, 0, 0)

        local TabBtn = New("TextButton", {
            Size             = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = Color3.fromRGB(18, 18, 18),
            Text             = (icon and icon .. "  " or "  ") .. name,
            TextColor3       = Color3.fromRGB(140, 140, 140),
            Font             = BF,
            TextSize         = 14,
            TextXAlignment   = Enum.TextXAlignment.Left,
            AutoButtonColor  = false,
        }, SidebarScroll)
        Round(TabBtn, 10)
        MakePadding(TabBtn, 0, 0, 10, 0)

        -- Active indicator bar
        local Bar = New("Frame", {
            Size             = UDim2.new(0, 3, 0, 22),
            Position         = UDim2.new(0, 0, 0.5, -11),
            BackgroundColor3 = THEME,
            BackgroundTransparency = 1,
        }, TabBtn)
        Round(Bar, 2)

        TabBtn.MouseButton1Click:Connect(function()
            -- deactivate all
            for _, t in pairs(self._tabs) do
                t.page.Visible = false
                Tween(t.btn,       0.15, { TextColor3 = Color3.fromRGB(140, 140, 140), BackgroundColor3 = Color3.fromRGB(18, 18, 18) })
                Tween(t.bar,       0.15, { BackgroundTransparency = 1 })
            end
            Page.Visible = true
            self._currentPage = Page
            Tween(TabBtn,  0.15, { TextColor3 = THEME, BackgroundColor3 = Color3.fromRGB(22, 22, 22) })
            Tween(Bar,     0.15, { BackgroundTransparency = 0 })
        end)

        local tabEntry = { page = Page, btn = TabBtn, bar = Bar }
        table.insert(self._tabs, tabEntry)

        -- activate first tab automatically
        if #self._tabs == 1 then
            Page.Visible           = true
            self._currentPage      = Page
            TabBtn.TextColor3      = THEME
            TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Bar.BackgroundTransparency = 0
        end

        -- return tab object with element api
        local tab = ElementAPI(Page)
        tab._page = Page
        return tab
    end

    -- Auto-show on creation
    ToggleUI()

    return Window
end

return ViloniX
