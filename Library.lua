local Library = {}

function Library:Init()
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")

    if CoreGui:FindFirstChild("ViloniXHub") then CoreGui.ViloniXHub:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "ViloniXHub"
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
    Main.ClipsDescendants = true
    Main.Visible = false 
    Round(Main, 14)

    -- Декор (Линии)
    local function Line(pos, size)
        local l = Instance.new("Frame", Main)
        l.BackgroundColor3 = BorderColor
        l.Position = pos
        l.Size = size
        l.BorderSizePixel = 0
    end
    Line(UDim2.new(0, 0, 0, 60), UDim2.new(1, 0, 0, 2)) 
    Line(UDim2.new(0, 190, 0, 60), UDim2.new(0, 2, 1, -60))
    Line(UDim2.new(0, 0, 1, -110), UDim2.new(0, 190, 0, 2))

    -- TopBar
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 60)
    TopBar.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "ViloniXHub"
    Title.Position = UDim2.new(0, 25, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.TextColor3 = ThemeColor
    Title.Font = BoldFont
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Sidebar & Container
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Position = UDim2.new(0, 15, 0, 75)
    Sidebar.Size = UDim2.new(0, 160, 0, 240) 
    Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Position = UDim2.new(0, 210, 0, 80)
    PageContainer.Size = UDim2.new(1, -230, 1, -100)
    PageContainer.BackgroundTransparency = 1

    -- Анимация ToggleUI
    local function ToggleUI()
        if Main.Visible == false then
            Main.Size = UDim2.new(0, 0, 0, 0)
            Main.Visible = true
            Blur.Enabled = true
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 620, 0, 440)}):Play()
            TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 20}):Play()
        else
            local t = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
            t:Play()
            t.Completed:Connect(function() Main.Visible = false; Blur.Enabled = false end)
        end
    end

    -- Кнопки управления
    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.new(0, 35, 0, 35)
    Close.Position = UDim2.new(1, -45, 0, 12)
    Close.BackgroundColor3 = ThemeColor
    Close.Text = "X"; Close.Font = BoldFont; Close.TextSize = 18
    Round(Close, 8)
    Close.MouseButton1Click:Connect(ToggleUI)

    local ScreenBtn = Instance.new("TextButton", ScreenGui)
    ScreenBtn.Size = UDim2.new(0, 45, 0, 45)
    ScreenBtn.Position = UDim2.new(0, 20, 0.5, -22)
    ScreenBtn.BackgroundColor3 = BackgroundColor
    ScreenBtn.Text = "V"; ScreenBtn.TextColor3 = ThemeColor; ScreenBtn.Font = BoldFont; ScreenBtn.TextSize = 24
    Round(ScreenBtn, 22)
    ScreenBtn.MouseButton1Click:Connect(ToggleUI)

    -- Элемент Toggle
    local function AddToggle(parent, text, callback)
        local Tgl = Instance.new("TextButton", parent)
        Tgl.Size = UDim2.new(1, 0, 0, 50)
        Tgl.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        Tgl.Text = "  " .. text
        Tgl.Font = MainFont; Tgl.TextSize = 16; Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
        Tgl.TextXAlignment = Enum.TextXAlignment.Left
        Round(Tgl, 10)

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
            callback(active)
        end)
    end

    -- Tab System
    local TabSystem = {}
    function TabSystem:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 42); TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        TabBtn.Text = name; TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TabBtn.Font = BoldFont; TabBtn.TextSize = 15
        Round(TabBtn, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageContainer:GetChildren()) do p.Visible = false end
            for _, b in pairs(Sidebar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            Page.Visible = true; TabBtn.TextColor3 = ThemeColor
        end)
        
        if not PageContainer:FindFirstChildWhichIsA("ScrollingFrame") then Page.Visible = true; TabBtn.TextColor3 = ThemeColor end
        return { AddToggle = function(_, text, callback) AddToggle(Page, text, callback) end }
    end

    -- Dragging
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    return TabSystem
end

return Library
