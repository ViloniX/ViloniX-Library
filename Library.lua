local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- Константы оформления
local ThemeColor = Color3.fromRGB(0, 255, 120)
local BackgroundColor = Color3.fromRGB(10, 10, 10)
local BorderColor = Color3.fromRGB(55, 55, 55)
local BoldFont = Enum.Font.GothamBold
local MainFont = Enum.Font.Ubuntu

local function Round(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

function Library:CreateWindow(hubName)
    hubName = hubName or "ViloniXHub"
    
    if CoreGui:FindFirstChild(hubName) then CoreGui[hubName]:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = hubName
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Enabled = false
    Blur.Parent = Lighting

    -- Main Window
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 620, 0, 440)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = BackgroundColor
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = false 
    Main.Parent = ScreenGui
    Round(Main, 14)

    -- Разметка
    local function CreateThickLine(pos, size)
        local l = Instance.new("Frame")
        l.BackgroundColor3 = BorderColor
        l.BorderSizePixel = 0
        l.Position = pos
        l.Size = size
        l.Parent = Main
    end

    CreateThickLine(UDim2.new(0, 0, 0, 60), UDim2.new(1, 0, 0, 2)) 
    CreateThickLine(UDim2.new(0, 190, 0, 60), UDim2.new(0, 2, 1, -60))
    CreateThickLine(UDim2.new(0, 0, 1, -110), UDim2.new(0, 190, 0, 2))

    -- TopBar (Logo & Title)
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 60)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = Main

    local LogoBase = Instance.new("Frame")
    LogoBase.Size = UDim2.new(0, 32, 0, 32)
    LogoBase.Position = UDim2.new(0, 18, 0.5, -16)
    LogoBase.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LogoBase.Rotation = 45
    LogoBase.Parent = TopBar
    Round(LogoBase, 6)
    
    local LogoStroke = Instance.new("UIStroke")
    LogoStroke.Color = ThemeColor
    LogoStroke.Thickness = 2
    LogoStroke.Parent = LogoBase

    local LogoInner = Instance.new("TextLabel")
    LogoInner.Size = UDim2.new(1, 0, 1, 0)
    LogoInner.Rotation = -45
    LogoInner.Text = hubName:sub(1,1)
    LogoInner.Font = BoldFont
    LogoInner.TextSize = 20
    LogoInner.TextColor3 = ThemeColor
    LogoInner.BackgroundTransparency = 1
    LogoInner.Parent = LogoBase

    local Title = Instance.new("TextLabel")
    Title.Text = hubName
    Title.Position = UDim2.new(0, 70, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.TextColor3 = ThemeColor
    Title.Font = BoldFont
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = TopBar

    -- Sidebar & Page Container
    local Sidebar = Instance.new("Frame")
    Sidebar.Position = UDim2.new(0, 15, 0, 75)
    Sidebar.Size = UDim2.new(0, 160, 0, 240) 
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main
    
    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding = UDim.new(0, 8)
    SideLayout.Parent = Sidebar

    local PageContainer = Instance.new("Frame")
    PageContainer.Position = UDim2.new(0, 210, 0, 80)
    PageContainer.Size = UDim2.new(1, -230, 1, -100)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = Main

    -- Toggle Logic
    local function ToggleUI()
        if Main.Visible == false then
            Main.Size = UDim2.new(0, 0, 0, 0)
            Main.Visible = true
            Blur.Enabled = true
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 620, 0, 440)}):Play()
            TweenService:Create(Blur, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 20}):Play()
        else
            local t1 = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            local t2 = TweenService:Create(Blur, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = 0})
            t1:Play() t2:Play()
            t1.Completed:Connect(function() Main.Visible = false Blur.Enabled = false end)
        end
    end

    -- Profile UI
    local Profile = Instance.new("Frame")
    Profile.Size = UDim2.new(0, 180, 0, 100)
    Profile.Position = UDim2.new(0, 5, 1, -105)
    Profile.BackgroundTransparency = 1
    Profile.Parent = Main

    local Av = Instance.new("ImageLabel")
    Av.Size = UDim2.new(0, 55, 0, 55)
    Av.Position = UDim2.new(0, 12, 0.5, -27)
    Av.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    Av.Parent = Profile
    Round(Av, 28)

    local function Lbl(txt, y, col, sz, f)
        local l = Instance.new("TextLabel")
        l.Text = txt
        l.Position = UDim2.new(0, 75, 0, y)
        l.Size = UDim2.new(1, -80, 0, 20)
        l.TextColor3 = col
        l.Font = f
        l.TextSize = sz
        l.BackgroundTransparency = 1
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = Profile
    end
    Lbl(Players.LocalPlayer.Name, 18, Color3.new(1,1,1), 14, BoldFont)
    Lbl("● Online", 60, ThemeColor, 12, BoldFont)

    -- Interaction
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 36, 0, 36)
    Close.Position = UDim2.new(1, -50, 0, 12)
    Close.BackgroundColor3 = ThemeColor
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(10, 10, 10)
    Close.Font = BoldFont
    Close.TextSize = 18
    Close.Parent = Main
    Round(Close, 10)
    Close.MouseButton1Click:Connect(ToggleUI)

    UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end
    end)

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)

    local Tabs = {}
    local FirstTab = true
    local CurrentPage = nil

    function Tabs:CreateTab(tabName)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Parent = PageContainer
        
        local L = Instance.new("UIListLayout")
        L.Padding = UDim.new(0, 10)
        L.Parent = Page

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 42)
        TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = BoldFont
        TabBtn.TextSize = 15
        TabBtn.Parent = Sidebar
        Round(TabBtn, 10)

        TabBtn.MouseButton1Click:Connect(function()
            if CurrentPage then CurrentPage.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end
            end
            TabBtn.TextColor3 = ThemeColor
            CurrentPage = Page
            Page.Visible = true
        end)

        if FirstTab then
            FirstTab = false
            CurrentPage = Page
            Page.Visible = true
            TabBtn.TextColor3 = ThemeColor
        end

        local Elements = {}

        function Elements:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.Font = MainFont
            Btn.TextSize = 15
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page
            Round(Btn, 10)
            Btn.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        function Elements:AddToggle(text, callback)
            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(1, 0, 0, 50)
            TglFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            TglFrame.Text = ""
            TglFrame.Parent = Page
            Round(TglFrame, 10)

            local lbl = Instance.new("TextLabel")
            lbl.Text = "  " .. text
            lbl.Size = UDim2.new(1, -50, 1, 0)
            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.Font = MainFont
            lbl.TextSize = 16
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = TglFrame

            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 22, 0, 22)
            box.Position = UDim2.new(1, -35, 0.5, -11)
            box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            box.Parent = TglFrame
            Round(box, 6)

            local check = Instance.new("Frame")
            check.Size = UDim2.new(0, 12, 0, 12)
            check.Position = UDim2.new(0.5, -6, 0.5, -6)
            check.BackgroundColor3 = ThemeColor
            check.BackgroundTransparency = 1
            check.Parent = box
            Round(check, 3)

            local active = false
            TglFrame.MouseButton1Click:Connect(function()
                active = not active
                TweenService:Create(check, TweenInfo.new(0.2), {BackgroundTransparency = active and 0 or 1}):Play()
                callback(active)
            end)
        end

        return Elements
    end

    ToggleUI() -- Открыть при запуске
    return Tabs
end

return Library
