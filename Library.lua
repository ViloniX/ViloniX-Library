local Library = {}

function Library:Init()
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")

    if CoreGui:FindFirstChild("ViloniXHub") then CoreGui.ViloniXHub:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ViloniXHub"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local Blur = Instance.new("BlurEffect", Lighting)
    Blur.Size = 0
    Blur.Enabled = false

    local function Round(obj, radius)
        local corner = Instance.new("UICorner", obj)
        corner.CornerRadius = UDim.new(0, radius)
    end

    local ThemeColor = Color3.fromRGB(0, 255, 120)
    local BackgroundColor = Color3.fromRGB(10, 10, 10)
    local BorderColor = Color3.fromRGB(55, 55, 55)
    local BoldFont = Enum.Font.GothamBold
    local MainFont = Enum.Font.Ubuntu

    -- Main Window
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 620, 0, 440)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = BackgroundColor
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = false 
    Round(Main, 14)

    -- Разметка (Твои линии)
    local function CreateThickLine(pos, size)
        local l = Instance.new("Frame", Main)
        l.BackgroundColor3 = BorderColor
        l.BorderSizePixel = 0
        l.Position = pos
        l.Size = size
    end
    CreateThickLine(UDim2.new(0, 0, 0, 60), UDim2.new(1, 0, 0, 2)) 
    CreateThickLine(UDim2.new(0, 190, 0, 60), UDim2.new(0, 2, 1, -60))
    CreateThickLine(UDim2.new(0, 0, 1, -110), UDim2.new(0, 190, 0, 2))

    -- TopBar & Logo
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 60)
    TopBar.BackgroundTransparency = 1

    local LogoBase = Instance.new("Frame", TopBar)
    LogoBase.Size = UDim2.new(0, 32, 0, 32)
    LogoBase.Position = UDim2.new(0, 18, 0.5, -16)
    LogoBase.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LogoBase.Rotation = 45
    Round(LogoBase, 6)
    local Stroke = Instance.new("UIStroke", LogoBase)
    Stroke.Color = ThemeColor
    Stroke.Thickness = 2

    local LogoInner = Instance.new("TextLabel", LogoBase)
    LogoInner.Size = UDim2.new(1, 0, 1, 0)
    LogoInner.Rotation = -45
    LogoInner.Text = "V"
    LogoInner.Font = BoldFont
    LogoInner.TextSize = 20
    LogoInner.TextColor3 = ThemeColor
    LogoInner.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "ViloniXHub"
    Title.Position = UDim2.new(0, 70, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.TextColor3 = ThemeColor
    Title.Font = BoldFont
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Position = UDim2.new(0, 15, 0, 75)
    Sidebar.Size = UDim2.new(0, 160, 0, 240) 
    Sidebar.BackgroundTransparency = 1
    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0, 8)

    -- Container for Pages
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Position = UDim2.new(0, 210, 0, 80)
    PageContainer.Size = UDim2.new(1, -230, 1, -100)
    PageContainer.BackgroundTransparency = 1

    -- Profile Card (Твой блок внизу слева)
    local Profile = Instance.new("Frame", Main)
    Profile.Size = UDim2.new(0, 180, 0, 100)
    Profile.Position = UDim2.new(0, 5, 1, -105)
    Profile.BackgroundTransparency = 1

    local Av = Instance.new("ImageLabel", Profile)
    Av.Size = UDim2.new(0, 55, 0, 55)
    Av.Position = UDim2.new(0, 12, 0.5, -27)
    Av.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    Round(Av, 28)

    local function Lbl(txt, y, col, sz, f)
        local l = Instance.new("TextLabel", Profile)
        l.Text = txt
        l.Position = UDim2.new(0, 75, 0, y)
        l.Size = UDim2.new(1, -80, 0, 20)
        l.TextColor3 = col
        l.Font = f
        l.TextSize = sz
        l.BackgroundTransparency = 1
        l.TextXAlignment = Enum.TextXAlignment.Left
    end
    Lbl(Players.LocalPlayer.Name, 18, Color3.new(1,1,1), 14, BoldFont)
    Lbl("● Online", 60, ThemeColor, 12, BoldFont)

    -- [[ ЭЛЕМЕНТЫ УПРАВЛЕНИЯ ]] --

    local function AddToggle(parent, text, callback)
        local Tgl = Instance.new("TextButton", parent)
        Tgl.Size = UDim2.new(1, 0, 0, 50)
        Tgl.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        Tgl.Text = ""
        Round(Tgl, 10)

        local lbl = Instance.new("TextLabel", Tgl)
        lbl.Text = "  " .. text
        lbl.Size = UDim2.new(1, -50, 1, 0)
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.Font = MainFont
        lbl.TextSize = 16
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local box = Instance.new("Frame", Tgl)
        box.Size = UDim2.new(0, 22, 0, 22)
        box.Position = UDim2.new(1, -35, 0.5, -11)
        box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Round(box, 6)

        local check = Instance.new("Frame", box)
        check.Size = UDim2.new(0, 12, 0, 12)
        check.Position = UDim2.new(0.5, -6, 0.5, -6)
        check.BackgroundColor3 = ThemeColor
        check.BackgroundTransparency = 1
        Round(check, 3)

        local active = false
        Tgl.MouseButton1Click:Connect(function()
            active = not active
            TweenService:Create(check, TweenInfo.new(0.2), {BackgroundTransparency = active and 0 or 1}):Play()
            if callback then callback(active) end
        end)
    end

    local function AddDropdown(parent, text, list, callback)
        local DropFrame = Instance.new("Frame", parent)
        local IsOpen = false
        DropFrame.Size = UDim2.new(1, 0, 0, 50)
        DropFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        DropFrame.ClipsDescendants = true
        Round(DropFrame, 10)

        local btn = Instance.new("TextButton", DropFrame)
        btn.Size = UDim2.new(1, 0, 0, 50)
        btn.BackgroundTransparency = 1
        btn.Text = "  " .. text .. " : Select..."
        btn.Font = MainFont
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 16
        btn.TextXAlignment = Enum.TextXAlignment.Left

        local container = Instance.new("Frame", DropFrame)
        container.Position = UDim2.new(0, 0, 0, 50)
        container.Size = UDim2.new(1, 0, 0, 0)
        container.BackgroundTransparency = 1
        local layout = Instance.new("UIListLayout", container)

        btn.MouseButton1Click:Connect(function()
            IsOpen = not IsOpen
            TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = IsOpen and UDim2.new(1, 0, 0, 50 + layout.AbsoluteContentSize.Y + 5) or UDim2.new(1, 0, 0, 50)}):Play()
        end)

        local function refresh()
            for _, v in pairs(container:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
            for _, name in pairs(list) do
                local item = Instance.new("TextButton", container)
                item.Size = UDim2.new(1, 0, 0, 30)
                item.BackgroundTransparency = 1
                item.Text = "  " .. name
                item.Font = MainFont
                item.TextColor3 = Color3.new(0.6, 0.6, 0.6)
                item.TextSize = 14
                item.TextXAlignment = Enum.TextXAlignment.Left
                item.MouseButton1Click:Connect(function()
                    btn.Text = "  " .. text .. " : " .. name
                    IsOpen = false
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                    callback(name)
                end)
            end
        end
        refresh()
        return {Refresh = function(newList) list = newList; refresh() end}
    end

    -- Tab System
    local TabSystem = {}
    local FirstPage = nil

    function TabSystem:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 42)
        TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = BoldFont
        TabBtn.TextSize = 15
        Round(TabBtn, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageContainer:GetChildren()) do p.Visible = false end
            for _, b in pairs(Sidebar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            Page.Visible = true
            TabBtn.TextColor3 = ThemeColor
        end)

        if not FirstPage then
            Page.Visible = true
            TabBtn.TextColor3 = ThemeColor
            FirstPage = Page
        end

        return {
            AddToggle = function(_, text, callback) AddToggle(Page, text, callback) end,
            AddDropdown = function(_, text, list, callback) return AddDropdown(Page, text, list, callback) end
        }
    end

    -- Toggle Logic (RightShift)
    local function ToggleUI()
        Main.Visible = not Main.Visible
        Blur.Enabled = Main.Visible
        Blur.Size = Main.Visible and 20 or 0
    end

    UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end
    end)

    -- Кнопка закрытия
    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -45, 0, 15)
    Close.BackgroundColor3 = ThemeColor
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(10, 10, 10)
    Close.Font = BoldFont
    Close.TextSize = 16
    Round(Close, 8)
    Close.MouseButton1Click:Connect(ToggleUI)

    -- Драггинг (Плавный)
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    return TabSystem
end

return Library
