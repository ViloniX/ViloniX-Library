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

    -- Разметка
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
    Instance.new("UIStroke", LogoBase).Color = ThemeColor

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

    -- [[ ФУНКЦИИ ЭЛЕМЕНТОВ ]] --

    local function AddToggle(parent, text, callback)
        local Tgl = Instance.new("TextButton", parent)
        Tgl.Size = UDim2.new(1, 0, 0, 45)
        Tgl.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        Tgl.Text = "  " .. text
        Tgl.Font = MainFont
        Tgl.TextSize = 15
        Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
        Tgl.TextXAlignment = Enum.TextXAlignment.Left
        Round(Tgl, 10)

        local box = Instance.new("Frame", Tgl)
        box.Size = UDim2.new(0, 20, 0, 20)
        box.Position = UDim2.new(1, -30, 0.5, -10)
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
        DropFrame.Size = UDim2.new(1, 0, 0, 45)
        DropFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        DropFrame.ClipsDescendants = true
        Round(DropFrame, 10)

        local btn = Instance.new("TextButton", DropFrame)
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundTransparency = 1
        btn.Text = "  " .. text .. " : Select..."
        btn.Font = MainFont
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 15
        btn.TextXAlignment = Enum.TextXAlignment.Left

        local container = Instance.new("Frame", DropFrame)
        container.Position = UDim2.new(0, 0, 0, 45)
        container.Size = UDim2.new(1, 0, 0, 0)
        container.BackgroundTransparency = 1
        local layout = Instance.new("UIListLayout", container)

        btn.MouseButton1Click:Connect(function()
            IsOpen = not IsOpen
            TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = IsOpen and UDim2.new(1, 0, 0, 45 + layout.AbsoluteContentSize.Y + 5) or UDim2.new(1, 0, 0, 45)}):Play()
        end)

        local function refresh()
            for _, v in pairs(container:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
            for _, name in pairs(list) do
                local item = Instance.new("TextButton", container)
                item.Size = UDim2.new(1, 0, 0, 30)
                item.BackgroundTransparency = 1
                item.Text = name
                item.Font = MainFont
                item.TextColor3 = Color3.new(0.7, 0.7, 0.7)
                item.TextSize = 14
                item.MouseButton1Click:Connect(function()
                    btn.Text = "  " .. text .. " : " .. name
                    IsOpen = false
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                    callback(name)
                end)
            end
        end
        refresh()
        return {Refresh = function(newList) list = newList; refresh() end}
    end

    -- Tab System
    local TabSystem = {}
    local FirstTab = true

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

        if FirstTab then
            Page.Visible = true
            TabBtn.TextColor3 = ThemeColor
            FirstTab = false
        end

        return {
            AddToggle = function(_, text, callback) AddToggle(Page, text, callback) end,
            AddDropdown = function(_, text, list, callback) return AddDropdown(Page, text, list, callback) end
        }
    end

    -- Toggle Logic
    local function ToggleUI()
        Main.Visible = not Main.Visible
        Blur.Enabled = Main.Visible
        Blur.Size = Main.Visible and 20 or 0
    end

    UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end
    end)

    return TabSystem
end

return Library
