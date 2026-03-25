-- ============================================================
--  ViloniXLib — Roblox GUI Library (ViloniX style)
--  Usage: local ViloniX = loadstring(game:HttpGet("..."))()
--         или через require если локально
-- ============================================================

local ViloniXLib = {}
ViloniXLib.__index = ViloniXLib

-- ──────────────────────────────────────────────────────────
--  СЕРВИСЫ
-- ──────────────────────────────────────────────────────────
local Players         = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local CoreGui         = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ──────────────────────────────────────────────────────────
--  ТЕМА ПО УМОЛЧАНИЮ
-- ──────────────────────────────────────────────────────────
local Themes = {
    ViloniX = {
        Accent       = Color3.fromRGB(124, 106, 247),
        Background   = Color3.fromRGB(13,  13,  15),
        Surface      = Color3.fromRGB(20,  20,  23),
        Panel        = Color3.fromRGB(26,  26,  30),
        Border       = Color3.fromRGB(42,  42,  48),
        Text         = Color3.fromRGB(232, 232, 240),
        TextMuted    = Color3.fromRGB(107, 107, 128),
    },
    Blue = {
        Accent       = Color3.fromRGB(91,  141, 247),
        Background   = Color3.fromRGB(11,  13,  18),
        Surface      = Color3.fromRGB(17,  20,  28),
        Panel        = Color3.fromRGB(22,  26,  36),
        Border       = Color3.fromRGB(38,  44,  60),
        Text         = Color3.fromRGB(224, 230, 255),
        TextMuted    = Color3.fromRGB(90,  100, 140),
    },
    Pink = {
        Accent       = Color3.fromRGB(247, 91,  124),
        Background   = Color3.fromRGB(15,  11,  14),
        Surface      = Color3.fromRGB(24,  17,  21),
        Panel        = Color3.fromRGB(30,  22,  27),
        Border       = Color3.fromRGB(52,  36,  44),
        Text         = Color3.fromRGB(255, 224, 232),
        TextMuted    = Color3.fromRGB(140, 90,  110),
    },
    Green = {
        Accent       = Color3.fromRGB(91,  247, 160),
        Background   = Color3.fromRGB(11,  15,  12),
        Surface      = Color3.fromRGB(17,  24,  19),
        Panel        = Color3.fromRGB(22,  30,  24),
        Border       = Color3.fromRGB(38,  52,  42),
        Text         = Color3.fromRGB(224, 255, 232),
        TextMuted    = Color3.fromRGB(90,  140, 100),
    },
}

-- ──────────────────────────────────────────────────────────
--  ХЕЛПЕРЫ
-- ──────────────────────────────────────────────────────────
local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = obj
        end
    end
    return obj
end

local function Tween(obj, props, duration)
    duration = duration or 0.15
    local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos = false, nil, nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ──────────────────────────────────────────────────────────
--  УВЕДОМЛЕНИЕ (Notify)
-- ──────────────────────────────────────────────────────────
local NotifyGui

local function EnsureNotifyGui()
    if NotifyGui and NotifyGui.Parent then return end
    NotifyGui = Create("ScreenGui", {
        Name = "ViloniXNotify",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() NotifyGui.Parent = CoreGui end)
    if not NotifyGui.Parent then
        NotifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    Create("UIListLayout", {
        Parent = NotifyGui,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 6),
    })
end

function ViloniXLib:Notify(opts)
    opts = opts or {}
    local title   = opts.Title   or "ViloniXLib"
    local message = opts.Message or ""
    local duration = opts.Duration or 3

    EnsureNotifyGui()
    local theme = self.Theme

    local Frame = Create("Frame", {
        Parent = NotifyGui,
        Size = UDim2.new(0, 240, 0, 52),
        Position = UDim2.new(1, 10, 1, -10),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        BackgroundTransparency = 0,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
        Create("UIStroke", {
            Color = theme.Accent,
            Thickness = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }),
        Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -12, 0, 18),
            Position = UDim2.new(0, 12, 0, 8),
            BackgroundTransparency = 1,
            Text = title,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
        Create("TextLabel", {
            Name = "Message",
            Size = UDim2.new(1, -12, 0, 16),
            Position = UDim2.new(0, 12, 0, 28),
            BackgroundTransparency = 1,
            Text = message,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = theme.TextMuted,
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
        Create("Frame", {
            Name = "AccentBar",
            Size = UDim2.new(0, 2, 1, -8),
            Position = UDim2.new(0, 0, 0, 4),
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0,
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 2) }),
        }),
    })

    Tween(Frame, { Position = UDim2.new(1, -250, 1, -10) }, 0.2)

    task.delay(duration, function()
        Tween(Frame, { Position = UDim2.new(1, 10, 1, -10) }, 0.2)
        task.delay(0.25, function()
            Frame:Destroy()
        end)
    end)
end

-- ──────────────────────────────────────────────────────────
--  СОЗДАНИЕ ОКНА (Window)
-- ──────────────────────────────────────────────────────────
function ViloniXLib:CreateWindow(opts)
    opts = opts or {}
    local title    = opts.Title    or "ViloniX"
    local size     = opts.Size     or UDim2.new(0, 420, 0, 500)
    local position = opts.Position or UDim2.new(0.5, -210, 0.5, -250)
    local themeName = opts.Theme   or "ViloniX"

    self.Theme = Themes[themeName] or Themes.ViloniX

    -- Удаляем старый gui
    pcall(function()
        if CoreGui:FindFirstChild("ViloniXLib") then
            CoreGui:FindFirstChild("ViloniXLib"):Destroy()
        end
    end)

    local theme = self.Theme

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "ViloniXLib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Main Window Frame
    local Window = Create("Frame", {
        Name = "Window",
        Parent = ScreenGui,
        Size = size,
        Position = position,
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 7) }),
        Create("UIStroke", {
            Color = theme.Border,
            Thickness = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }),
    })

    -- Titlebar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = Window,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 7) }),
        -- Accent dot
        Create("Frame", {
            Name = "Dot",
            Size = UDim2.new(0, 8, 0, 8),
            Position = UDim2.new(0, 12, 0.5, -4),
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0,
        }, {
            Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        }),
        -- Title
        Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -80, 1, 0),
            Position = UDim2.new(0, 28, 0, 0),
            BackgroundTransparency = 1,
            Text = string.upper(title),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            LetterSpacing = 2,
        }),
        -- Close button
        Create("TextButton", {
            Name = "CloseBtn",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -28, 0.5, -10),
            BackgroundColor3 = Color3.fromRGB(42, 22, 22),
            BorderSizePixel = 0,
            Text = "×",
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(180, 70, 70),
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
        }),
    })

    -- Cover round bottom of titlebar
    Create("Frame", {
        Name = "TitleCover",
        Parent = TitleBar,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
    })

    -- Tab bar
    local TabBar = Create("Frame", {
        Name = "TabBar",
        Parent = Window,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
    }, {
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
        Create("Frame", {
            Name = "BottomLine",
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 1, -1),
            BackgroundColor3 = theme.Border,
            BorderSizePixel = 0,
        }),
    })

    -- Content area
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Parent = Window,
        Size = UDim2.new(1, 0, 1, -66),
        Position = UDim2.new(0, 0, 0, 66),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })

    -- Draggable
    MakeDraggable(Window, TitleBar)

    -- Close
    TitleBar.CloseBtn.MouseButton1Click:Connect(function()
        Tween(Window, { Size = UDim2.new(0, size.X.Offset, 0, 0) }, 0.15)
        task.delay(0.15, function() ScreenGui:Destroy() end)
    end)

    -- Hover close
    TitleBar.CloseBtn.MouseEnter:Connect(function()
        Tween(TitleBar.CloseBtn, { BackgroundColor3 = Color3.fromRGB(60, 20, 20) })
    end)
    TitleBar.CloseBtn.MouseLeave:Connect(function()
        Tween(TitleBar.CloseBtn, { BackgroundColor3 = Color3.fromRGB(42, 22, 22) })
    end)

    -- Вход анимация
    Window.Size = UDim2.new(0, size.X.Offset, 0, 0)
    Tween(Window, { Size = size }, 0.2)

    -- ──────────────────────────────────────────────────────
    --  Объект окна
    -- ──────────────────────────────────────────────────────
    local Win = { Tabs = {}, ActiveTab = nil, _theme = theme, _tabBar = TabBar, _content = ContentArea }

    -- SetTheme
    function Win:SetTheme(name)
        local t = Themes[name]
        if not t then return end
        self._theme = t
        theme = t
        Window.BackgroundColor3 = t.Background
        TitleBar.BackgroundColor3 = t.Surface
        TitleBar.Title.TextColor3 = t.Text
        TitleBar.Dot.BackgroundColor3 = t.Accent
        TabBar.BackgroundColor3 = t.Surface
        TabBar.BottomLine.BackgroundColor3 = t.Border
        for _, tab in ipairs(self.Tabs) do
            tab._btn.TextColor3 = (tab == self.ActiveTab) and t.Accent or t.TextMuted
            if tab._indicator then
                tab._indicator.BackgroundColor3 = (tab == self.ActiveTab) and t.Accent or Color3.fromRGB(0,0,0)
                tab._indicator.BackgroundTransparency = (tab == self.ActiveTab) and 0 or 1
            end
            tab._frame.BackgroundColor3 = t.Background
        end
    end

    -- AddTab
    function Win:AddTab(name)
        local t    = self._theme
        local idx  = #self.Tabs + 1
        local tabW = math.floor(self._tabBar.AbsoluteSize.X / math.max(1, idx))

        -- Resize existing tabs
        for _, existing in ipairs(self.Tabs) do
            Tween(existing._btn, { Size = UDim2.new(0, tabW, 1, 0) })
        end

        -- Tab button
        local Btn = Create("TextButton", {
            Parent = self._tabBar,
            Size = UDim2.new(0, tabW, 1, 0),
            BackgroundTransparency = 1,
            Text = string.upper(name),
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextColor3 = t.TextMuted,
            LayoutOrder = idx,
        }, {
            Create("Frame", {
                Name = "Indicator",
                Size = UDim2.new(1, 0, 0, 2),
                Position = UDim2.new(0, 0, 1, -2),
                BackgroundColor3 = t.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
            }),
        })

        -- Scroll frame for content
        local TabFrame = Create("ScrollingFrame", {
            Parent = self._content,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = t.Background,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = t.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
        }, {
            Create("UIPadding", {
                PaddingLeft   = UDim.new(0, 10),
                PaddingRight  = UDim.new(0, 10),
                PaddingTop    = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
            }),
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
            }),
        })

        local Tab = { _btn = Btn, _indicator = Btn.Indicator, _frame = TabFrame, _theme = t, _order = 0 }

        Btn.MouseButton1Click:Connect(function()
            self:SelectTab(Tab)
        end)

        Btn.MouseEnter:Connect(function()
            if self.ActiveTab ~= Tab then
                Tween(Btn, { TextColor3 = t.Text })
            end
        end)
        Btn.MouseLeave:Connect(function()
            if self.ActiveTab ~= Tab then
                Tween(Btn, { TextColor3 = t.TextMuted })
            end
        end)

        table.insert(self.Tabs, Tab)
        if not self.ActiveTab then
            self:SelectTab(Tab)
        end

        -- ────────────────────────────────────────────────
        --  СЕКЦИЯ
        -- ────────────────────────────────────────────────
        function Tab:AddSection(sectionName)
            local frame = self._frame
            local th    = self._theme
            self._order = self._order + 1

            local Label = Create("TextLabel", {
                Parent = frame,
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = string.upper(sectionName),
                Font = Enum.Font.Gotham,
                TextSize = 9,
                TextColor3 = th.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = self._order,
            })

            Create("Frame", {
                Parent = Label,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = th.Border,
                BorderSizePixel = 0,
            })

            return Label
        end

        -- ────────────────────────────────────────────────
        --  TOGGLE
        -- ────────────────────────────────────────────────
        function Tab:AddToggle(opts2)
            opts2 = opts2 or {}
            local label   = opts2.Label    or "Toggle"
            local default = opts2.Default  or false
            local callback = opts2.Callback or function() end
            local th = self._theme
            self._order = self._order + 1
            local state = default

            local Row = Create("Frame", {
                Parent = self._frame,
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = th.Panel,
                BorderSizePixel = 0,
                LayoutOrder = self._order,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, -55, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = label,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = th.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }),
            })

            local Track = Create("Frame", {
                Parent = Row,
                Size = UDim2.new(0, 36, 0, 20),
                Position = UDim2.new(1, -46, 0.5, -10),
                BackgroundColor3 = state and th.Accent or Color3.fromRGB(34, 34, 40),
                BorderSizePixel = 0,
            }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local Thumb = Create("Frame", {
                Parent = Track,
                Size = UDim2.new(0, 14, 0, 14),
                Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or th.TextMuted,
                BorderSizePixel = 0,
            }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local function UpdateToggle()
                Tween(Track, { BackgroundColor3 = state and th.Accent or Color3.fromRGB(34, 34, 40) })
                Tween(Thumb, {
                    Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = state and Color3.fromRGB(255,255,255) or th.TextMuted,
                })
                callback(state)
            end

            Row.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    UpdateToggle()
                end
            end)
            Row.MouseEnter:Connect(function()
                Tween(Row, { BackgroundColor3 = Color3.fromRGB(th.Panel.R*255+6, th.Panel.G*255+6, th.Panel.B*255+10) })
            end)
            Row.MouseLeave:Connect(function()
                Tween(Row, { BackgroundColor3 = th.Panel })
            end)

            local ToggleObj = {}
            function ToggleObj:Set(val)
                state = val
                UpdateToggle()
            end
            function ToggleObj:Get() return state end
            return ToggleObj
        end

        -- ────────────────────────────────────────────────
        --  BUTTON
        -- ────────────────────────────────────────────────
        function Tab:AddButton(opts2)
            opts2 = opts2 or {}
            local label    = opts2.Label    or "Button"
            local callback = opts2.Callback or function() end
            local style    = opts2.Style    or "Default" -- "Default" | "Accent" | "Danger"
            local th = self._theme
            self._order = self._order + 1

            local borderColor = th.Border
            local textColor   = th.Text
            if style == "Accent" then borderColor = th.Accent; textColor = th.Accent
            elseif style == "Danger" then borderColor = Color3.fromRGB(120, 34, 34); textColor = Color3.fromRGB(200, 80, 80)
            end

            local Btn = Create("TextButton", {
                Parent = self._frame,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = th.Panel,
                BorderSizePixel = 0,
                Text = label,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextColor3 = textColor,
                LayoutOrder = self._order,
                AutoButtonColor = false,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = borderColor, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            Btn.MouseButton1Click:Connect(function()
                Tween(Btn, { Size = UDim2.new(0.99, 0, 0, 30) }, 0.07)
                task.delay(0.07, function() Tween(Btn, { Size = UDim2.new(1, 0, 0, 32) }, 0.07) end)
                callback()
            end)
            Btn.MouseEnter:Connect(function()
                Tween(Btn, { BackgroundColor3 = Color3.fromRGB(
                    math.clamp(th.Panel.R*255+8,0,255),
                    math.clamp(th.Panel.G*255+8,0,255),
                    math.clamp(th.Panel.B*255+12,0,255)
                )})
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, { BackgroundColor3 = th.Panel })
            end)
            return Btn
        end

        -- ────────────────────────────────────────────────
        --  SLIDER
        -- ────────────────────────────────────────────────
        function Tab:AddSlider(opts2)
            opts2 = opts2 or {}
            local label    = opts2.Label    or "Slider"
            local min      = opts2.Min      or 0
            local max      = opts2.Max      or 100
            local default  = opts2.Default  or min
            local suffix   = opts2.Suffix   or ""
            local callback = opts2.Callback or function() end
            local th = self._theme
            self._order = self._order + 1

            local value = math.clamp(default, min, max)

            local Row = Create("Frame", {
                Parent = self._frame,
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = th.Panel,
                BorderSizePixel = 0,
                LayoutOrder = self._order,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            local LabelEl = Create("TextLabel", {
                Parent = Row,
                Size = UDim2.new(0.6, 0, 0, 18),
                Position = UDim2.new(0, 10, 0, 6),
                BackgroundTransparency = 1,
                Text = label,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = th.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local ValLabel = Create("TextLabel", {
                Parent = Row,
                Size = UDim2.new(0.4, -10, 0, 18),
                Position = UDim2.new(0.6, 0, 0, 6),
                BackgroundTransparency = 1,
                Text = tostring(value) .. suffix,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = th.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
            })

            local TrackBg = Create("Frame", {
                Parent = Row,
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(34, 34, 42),
                BorderSizePixel = 0,
            }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local pct = (value - min) / (max - min)
            local Fill = Create("Frame", {
                Parent = TrackBg,
                Size = UDim2.new(pct, 0, 1, 0),
                BackgroundColor3 = th.Accent,
                BorderSizePixel = 0,
            }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local Thumb = Create("Frame", {
                Parent = TrackBg,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(pct, -7, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 2,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                Create("UIStroke", { Color = th.Accent, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            local dragging = false

            local function UpdateSlider(x)
                local abs = TrackBg.AbsolutePosition.X
                local w   = TrackBg.AbsoluteSize.X
                local p   = math.clamp((x - abs) / w, 0, 1)
                value = math.round(min + (max - min) * p)
                Fill.Size  = UDim2.new(p, 0, 1, 0)
                Thumb.Position = UDim2.new(p, -7, 0.5, -7)
                ValLabel.Text = tostring(value) .. suffix
                callback(value)
            end

            TrackBg.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(inp.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(inp.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            local SliderObj = {}
            function SliderObj:Set(val)
                value = math.clamp(val, min, max)
                local p = (value - min) / (max - min)
                Fill.Size = UDim2.new(p, 0, 1, 0)
                Thumb.Position = UDim2.new(p, -7, 0.5, -7)
                ValLabel.Text = tostring(value) .. suffix
                callback(value)
            end
            function SliderObj:Get() return value end
            return SliderObj
        end

        -- ────────────────────────────────────────────────
        --  DROPDOWN
        -- ────────────────────────────────────────────────
        function Tab:AddDropdown(opts2)
            opts2 = opts2 or {}
            local label    = opts2.Label    or "Dropdown"
            local items    = opts2.Items    or {}
            local default  = opts2.Default  or (items[1] or "")
            local callback = opts2.Callback or function() end
            local th = self._theme
            self._order = self._order + 1

            local selected = default
            local open     = false

            local Wrap = Create("Frame", {
                Parent = self._frame,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = th.Panel,
                BorderSizePixel = 0,
                LayoutOrder = self._order,
                ClipsDescendants = false,
                ZIndex = 5,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            local Header = Create("TextButton", {
                Parent = Wrap,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 6,
            })

            Create("TextLabel", {
                Parent = Header,
                Name = "SelLabel",
                Size = UDim2.new(1, -34, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = selected,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = th.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
            })

            local Arrow = Create("TextLabel", {
                Parent = Header,
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -26, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextColor3 = th.TextMuted,
                ZIndex = 6,
            })

            local Menu = Create("Frame", {
                Parent = Wrap,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 2),
                BackgroundColor3 = th.Panel,
                BorderSizePixel = 0,
                Visible = false,
                ClipsDescendants = true,
                ZIndex = 10,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
            })

            local itemHeight = 28

            for i, item in ipairs(items) do
                local isSel = item == selected
                local Item = Create("TextButton", {
                    Parent = Menu,
                    Size = UDim2.new(1, 0, 0, itemHeight),
                    BackgroundColor3 = isSel and Color3.fromRGB(
                        math.clamp(th.Panel.R*255+10,0,255),
                        math.clamp(th.Panel.G*255+10,0,255),
                        math.clamp(th.Panel.B*255+14,0,255)
                    ) or th.Panel,
                    BorderSizePixel = 0,
                    Text = item,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = isSel and th.Accent or th.Text,
                    AutoButtonColor = false,
                    ZIndex = 11,
                    LayoutOrder = i,
                })

                Item.MouseButton1Click:Connect(function()
                    selected = item
                    Header.SelLabel.Text = item
                    for _, c in ipairs(Menu:GetChildren()) do
                        if c:IsA("TextButton") then
                            c.TextColor3 = c.Text == item and th.Accent or th.Text
                        end
                    end
                    open = false
                    Tween(Menu, { Size = UDim2.new(1, 0, 0, 0) }, 0.12)
                    Tween(Arrow, { Rotation = 0 })
                    task.delay(0.12, function() Menu.Visible = false end)
                    callback(item)
                end)
                Item.MouseEnter:Connect(function()
                    if Item.Text ~= selected then
                        Tween(Item, { BackgroundColor3 = Color3.fromRGB(
                            math.clamp(th.Panel.R*255+8,0,255),
                            math.clamp(th.Panel.G*255+8,0,255),
                            math.clamp(th.Panel.B*255+12,0,255)
                        )})
                    end
                end)
                Item.MouseLeave:Connect(function()
                    if Item.Text ~= selected then
                        Tween(Item, { BackgroundColor3 = th.Panel })
                    end
                end)
            end

            local totalH = #items * itemHeight

            Header.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    Menu.Visible = true
                    Menu.Size = UDim2.new(1, 0, 0, 0)
                    Tween(Menu, { Size = UDim2.new(1, 0, 0, totalH) }, 0.12)
                    Tween(Arrow, { Rotation = 180 })
                else
                    Tween(Menu, { Size = UDim2.new(1, 0, 0, 0) }, 0.12)
                    Tween(Arrow, { Rotation = 0 })
                    task.delay(0.12, function() Menu.Visible = false end)
                end
            end)

            local DDObj = {}
            function DDObj:Set(val)
                selected = val
                Header.SelLabel.Text = val
                callback(val)
            end
            function DDObj:Get() return selected end
            return DDObj
        end

        -- ────────────────────────────────────────────────
        --  COLOR PICKER
        -- ────────────────────────────────────────────────
        function Tab:AddColorPicker(opts2)
            opts2 = opts2 or {}
            local label    = opts2.Label    or "Color"
            local default  = opts2.Default  or Color3.fromRGB(124, 106, 247)
            local callback = opts2.Callback or function() end
            local th = self._theme
            self._order = self._order + 1

            local currentColor = default
            local open         = false
            local hue, sat, val2 = 0, 1, 1

            local Row = Create("Frame", {
                Parent = self._frame,
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = th.Panel,
                BorderSizePixel = 0,
                LayoutOrder = self._order,
                ClipsDescendants = false,
                ZIndex = 4,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                Create("TextLabel", {
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = label,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = th.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }),
            })

            local r, g, b = default.R * 255, default.G * 255, default.B * 255
            local Preview = Create("TextButton", {
                Parent = Row,
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(1, -34, 0.5, -12),
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                Text = "",
                ZIndex = 5,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            -- Panel
            local Panel = Create("Frame", {
                Parent = Row,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = th.Surface,
                BorderSizePixel = 0,
                Visible = false,
                ClipsDescendants = true,
                ZIndex = 8,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
                    PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
                }),
            })

            -- SV gradient (simulated with frames)
            local SVArea = Create("Frame", {
                Parent = Panel,
                Size = UDim2.new(1, 0, 0, 100),
                BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 9,
                Position = UDim2.new(0, 0, 0, 0),
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Create("Frame", { -- White gradient overlay
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 0.01,
                    ZIndex = 9,
                }),
            })

            local SVCursor = Create("Frame", {
                Parent = SVArea,
                Size = UDim2.new(0, 10, 0, 10),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(sat, 0, 1 - val2, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 11,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                Create("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 1.5 }),
            })

            -- Hue bar
            local HueBar = Create("Frame", {
                Parent = Panel,
                Size = UDim2.new(1, 0, 0, 12),
                Position = UDim2.new(0, 0, 0, 108),
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 9,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
            })

            -- Build hue gradient manually with segments
            local hueColors = {
                {0, Color3.fromRGB(255,0,0)},
                {1/6, Color3.fromRGB(255,255,0)},
                {2/6, Color3.fromRGB(0,255,0)},
                {3/6, Color3.fromRGB(0,255,255)},
                {4/6, Color3.fromRGB(0,0,255)},
                {5/6, Color3.fromRGB(255,0,255)},
                {1, Color3.fromRGB(255,0,0)},
            }
            for i = 1, #hueColors - 1 do
                local seg = Create("Frame", {
                    Parent = HueBar,
                    Size = UDim2.new(hueColors[i+1][1] - hueColors[i][1], 0, 1, 0),
                    Position = UDim2.new(hueColors[i][1], 0, 0, 0),
                    BackgroundColor3 = hueColors[i][2],
                    BorderSizePixel = 0,
                    ZIndex = 9,
                })
                if i == 1 then Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = seg }) end
            end

            local HueCursor = Create("Frame", {
                Parent = HueBar,
                Size = UDim2.new(0, 14, 0, 18),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 11,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 3) }),
                Create("UIStroke", { Color = Color3.fromRGB(120, 120, 120), Thickness = 1 }),
            })

            -- Hex input
            local function colorToHex(c)
                return string.format("%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
            end

            local HexRow = Create("Frame", {
                Parent = Panel,
                Size = UDim2.new(1, 0, 0, 26),
                Position = UDim2.new(0, 0, 0, 128),
                BackgroundTransparency = 1,
                ZIndex = 9,
            })
            Create("TextLabel", {
                Parent = HexRow,
                Size = UDim2.new(0, 16, 1, 0),
                BackgroundTransparency = 1,
                Text = "#",
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = th.TextMuted,
                ZIndex = 9,
            })
            local HexInput = Create("TextBox", {
                Parent = HexRow,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 18, 0, 0),
                BackgroundColor3 = th.Background,
                BorderSizePixel = 0,
                Text = colorToHex(default),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = th.Text,
                PlaceholderText = "RRGGBB",
                ZIndex = 9,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1 }),
                Create("UIPadding", { PaddingLeft = UDim.new(0, 6) }),
            })

            local function refreshColor()
                currentColor = Color3.fromHSV(hue, sat, val2)
                Preview.BackgroundColor3 = currentColor
                SVArea.BackgroundColor3  = Color3.fromHSV(hue, 1, 1)
                HexInput.Text = colorToHex(currentColor)
                callback(currentColor)
            end

            -- SV drag
            local svDrag = false
            SVArea.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDrag = true
                    local p = inp.Position
                    local abs = SVArea.AbsolutePosition
                    local sz  = SVArea.AbsoluteSize
                    sat  = math.clamp((p.X - abs.X) / sz.X, 0, 1)
                    val2 = 1 - math.clamp((p.Y - abs.Y) / sz.Y, 0, 1)
                    SVCursor.Position = UDim2.new(sat, 0, 1 - val2, 0)
                    refreshColor()
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if svDrag and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local p = inp.Position
                    local abs = SVArea.AbsolutePosition
                    local sz  = SVArea.AbsoluteSize
                    sat  = math.clamp((p.X - abs.X) / sz.X, 0, 1)
                    val2 = 1 - math.clamp((p.Y - abs.Y) / sz.Y, 0, 1)
                    SVCursor.Position = UDim2.new(sat, 0, 1 - val2, 0)
                    refreshColor()
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = false end
            end)

            -- Hue drag
            local hueDrag = false
            HueBar.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDrag = true
                    local p   = inp.Position.X
                    local abs = HueBar.AbsolutePosition.X
                    local sz  = HueBar.AbsoluteSize.X
                    hue = math.clamp((p - abs) / sz, 0, 1)
                    HueCursor.Position = UDim2.new(hue, 0, 0.5, 0)
                    refreshColor()
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if hueDrag and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local p   = inp.Position.X
                    local abs = HueBar.AbsolutePosition.X
                    local sz  = HueBar.AbsoluteSize.X
                    hue = math.clamp((p - abs) / sz, 0, 1)
                    HueCursor.Position = UDim2.new(hue, 0, 0.5, 0)
                    refreshColor()
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = false end
            end)

            -- Hex input
            HexInput.FocusLost:Connect(function()
                local hex = HexInput.Text:gsub("#", "")
                if #hex == 6 then
                    local ri = tonumber(hex:sub(1,2), 16)
                    local gi = tonumber(hex:sub(3,4), 16)
                    local bi = tonumber(hex:sub(5,6), 16)
                    if ri and gi and bi then
                        currentColor = Color3.fromRGB(ri, gi, bi)
                        hue, sat, val2 = Color3.toHSV(currentColor)
                        SVCursor.Position = UDim2.new(sat, 0, 1 - val2, 0)
                        HueCursor.Position = UDim2.new(hue, 0, 0.5, 0)
                        SVArea.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                        Preview.BackgroundColor3 = currentColor
                        callback(currentColor)
                    end
                end
            end)

            Preview.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    Panel.Visible = true
                    Panel.Size = UDim2.new(1, 0, 0, 0)
                    Tween(Panel, { Size = UDim2.new(1, 0, 0, 162) }, 0.15)
                else
                    Tween(Panel, { Size = UDim2.new(1, 0, 0, 0) }, 0.12)
                    task.delay(0.12, function() Panel.Visible = false end)
                end
            end)

            local CPObj = {}
            function CPObj:Set(c)
                currentColor = c
                hue, sat, val2 = Color3.toHSV(c)
                SVArea.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                SVCursor.Position = UDim2.new(sat, 0, 1 - val2, 0)
                HueCursor.Position = UDim2.new(hue, 0, 0.5, 0)
                Preview.BackgroundColor3 = c
                HexInput.Text = colorToHex(c)
                callback(c)
            end
            function CPObj:Get() return currentColor end
            return CPObj
        end

        -- ────────────────────────────────────────────────
        --  INPUT (TextBox)
        -- ────────────────────────────────────────────────
        function Tab:AddInput(opts2)
            opts2 = opts2 or {}
            local label    = opts2.Label       or "Input"
            local placeholder = opts2.Placeholder or "Enter text..."
            local default  = opts2.Default     or ""
            local callback = opts2.Callback    or function() end
            local th = self._theme
            self._order = self._order + 1

            local Row = Create("Frame", {
                Parent = self._frame,
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = th.Panel,
                BorderSizePixel = 0,
                LayoutOrder = self._order,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                Create("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 16),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    Text = string.upper(label),
                    Font = Enum.Font.Gotham,
                    TextSize = 9,
                    TextColor3 = th.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LetterSpacing = 1,
                }),
            })

            local InputEl = Create("TextBox", {
                Parent = Row,
                Size = UDim2.new(1, -20, 0, 24),
                Position = UDim2.new(0, 10, 0, 22),
                BackgroundColor3 = th.Background,
                BorderSizePixel = 0,
                Text = default,
                PlaceholderText = placeholder,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = th.Text,
                PlaceholderColor3 = th.TextMuted,
                ClearTextOnFocus = false,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Create("UIStroke", { Name = "Stroke", Color = th.Border, Thickness = 1 }),
                Create("UIPadding", { PaddingLeft = UDim.new(0, 8) }),
            })

            InputEl.Focused:Connect(function()
                Tween(InputEl.Stroke, { Color = th.Accent })
            end)
            InputEl.FocusLost:Connect(function(enter)
                Tween(InputEl.Stroke, { Color = th.Border })
                if enter then callback(InputEl.Text) end
            end)

            local InputObj = {}
            function InputObj:Set(txt)
                InputEl.Text = txt
                callback(txt)
            end
            function InputObj:Get() return InputEl.Text end
            return InputObj
        end

        -- ────────────────────────────────────────────────
        --  KEYBIND
        -- ────────────────────────────────────────────────
        function Tab:AddKeybind(opts2)
            opts2 = opts2 or {}
            local label    = opts2.Label    or "Keybind"
            local default  = opts2.Default  or Enum.KeyCode.Insert
            local callback = opts2.Callback or function() end
            local th = self._theme
            self._order = self._order + 1

            local currentKey = default
            local listening  = false

            local Row = Create("Frame", {
                Parent = self._frame,
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = th.Panel,
                BorderSizePixel = 0,
                LayoutOrder = self._order,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                Create("TextLabel", {
                    Size = UDim2.new(1, -90, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = label,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = th.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }),
            })

            local KeyBtn = Create("TextButton", {
                Parent = Row,
                Size = UDim2.new(0, 70, 0, 22),
                Position = UDim2.new(1, -78, 0.5, -11),
                BackgroundColor3 = th.Background,
                BorderSizePixel = 0,
                Text = tostring(currentKey.Name),
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextColor3 = th.Accent,
                AutoButtonColor = false,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1 }),
            })

            KeyBtn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                KeyBtn.Text = "..."
                Tween(KeyBtn, { TextColor3 = th.TextMuted })
            end)

            UserInputService.InputBegan:Connect(function(inp, gp)
                if not listening then return end
                if inp.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = inp.KeyCode
                    listening = false
                    KeyBtn.Text = tostring(currentKey.Name)
                    Tween(KeyBtn, { TextColor3 = th.Accent })
                    callback(currentKey)
                end
            end)

            local KBObj = {}
            function KBObj:Get() return currentKey end
            return KBObj
        end

        -- ────────────────────────────────────────────────
        --  LABEL
        -- ────────────────────────────────────────────────
        function Tab:AddLabel(opts2)
            opts2 = opts2 or {}
            local text = opts2.Text or "Label"
            local th = self._theme
            self._order = self._order + 1

            local Label = Create("TextLabel", {
                Parent = self._frame,
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = th.Panel,
                BorderSizePixel = 0,
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextColor3 = th.TextMuted,
                LayoutOrder = self._order,
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                Create("UIPadding", { PaddingLeft = UDim.new(0, 10) }),
            })

            local LabelObj = {}
            function LabelObj:Set(txt)
                Label.Text = txt
            end
            function LabelObj:Get() return Label.Text end
            return LabelObj
        end

        return Tab
    end

    -- SelectTab
    function Win:SelectTab(tab)
        if self.ActiveTab then
            Tween(self.ActiveTab._btn, { TextColor3 = self._theme.TextMuted })
            Tween(self.ActiveTab._indicator, { BackgroundTransparency = 1 })
            self.ActiveTab._frame.Visible = false
        end
        self.ActiveTab = tab
        Tween(tab._btn, { TextColor3 = self._theme.Accent })
        Tween(tab._indicator, { BackgroundTransparency = 0 })
        tab._frame.Visible = true
    end

    return Win
end

-- ──────────────────────────────────────────────────────────
--  WATERMARK
-- ──────────────────────────────────────────────────────────
function ViloniXLib:CreateWatermark(opts)
    opts = opts or {}
    local text = opts.Text or "ViloniX"
    local th   = self.Theme or Themes.ViloniX

    local WGui = Create("ScreenGui", {
        Name = "ViloniXWatermark",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() WGui.Parent = game:GetService("CoreGui") end)
    if not WGui.Parent then WGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local Frame = Create("Frame", {
        Parent = WGui,
        Size = UDim2.new(0, 0, 0, 24),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = th.Surface,
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
        Create("UIStroke", { Color = th.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
        Create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
        Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6) }),
        Create("Frame", {
            Size = UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = th.Accent,
            BorderSizePixel = 0,
        }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) }),
        Create("TextLabel", {
            Name = "WaterText",
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = th.Text,
        }),
    })

    local fps = 0
    local FPS_Label
    if opts.ShowFPS then
        FPS_Label = Create("TextLabel", {
            Parent = Frame,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "| 60 FPS",
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextColor3 = th.TextMuted,
        })
        local last = tick()
        RunService.RenderStepped:Connect(function()
            local now = tick()
            fps = math.round(1 / (now - last))
            last = now
            FPS_Label.Text = "| " .. fps .. " FPS"
        end)
    end

    local WObj = {}
    function WObj:SetText(t) Frame.WaterText.Text = t end
    function WObj:Remove() WGui:Destroy() end
    return WObj
end

-- ──────────────────────────────────────────────────────────
return ViloniXLib
