local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

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

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 620, 0, 440)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = BackgroundColor
    Main.ClipsDescendants = true
    Main.Visible = false 
    Main.Parent = ScreenGui
    Round(Main, 14)

    -- Линии разметки
    local function CreateLine(pos, size)
        local l = Instance.new("Frame")
        l.BackgroundColor3 = BorderColor
        l.BorderSizePixel = 0
        l.Position = pos
        l.Size = size
        l.Parent = Main
    end
    CreateLine(UDim2.new(0, 0, 0, 60), UDim2.new(1, 0, 0, 2)) 
    CreateLine(UDim2.new(0, 190, 0, 60), UDim2.new(0, 2, 1, -60))
    CreateLine(UDim2.new(0, 0, 1, -110), UDim2.new(0, 190, 0, 2))

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 60)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Text = hubName
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.TextColor3 = ThemeColor
    Title.Font = BoldFont
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = TopBar

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

    -- Функции управления
    local function ToggleUI()
        local targetSize = Main.Visible and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 620, 0, 440)
        local targetBlur = Main.Visible and 0 or 20
        
        if not Main.Visible then 
            Main.Visible = true 
            Blur.Enabled = true
        end

        local t1 = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize})
        local t2 = TweenService:Create(Blur, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetBlur})
        
        t1:Play() t2:Play()
        if targetBlur == 0 then
            t1.Completed:Connect(function() Main.Visible = false Blur.Enabled = false end)
        end
    end

    UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end
    end)

    -- Вкладки
    local Tabs = { ActivePage = nil, ActiveBtn = nil }
    
    function Tabs:CreateTab(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = ThemeColor
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Parent = PageContainer
        local L = Instance.new("UIListLayout")
        L.Padding = UDim.new(0, 10)
        L.Parent = Page

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = BoldFont
        TabBtn.TextSize = 14
        TabBtn.Parent = Sidebar
        Round(TabBtn, 8)

        TabBtn.MouseButton1Click:Connect(function()
            if Tabs.ActivePage then Tabs.ActivePage.Visible = false end
            if Tabs.ActiveBtn then Tabs.ActiveBtn.TextColor3 = Color3.fromRGB(150, 150, 150) end
            
            TabBtn.TextColor3 = ThemeColor
            Page.Visible = true
            Tabs.ActivePage = Page
            Tabs.ActiveBtn = TabBtn
        end)

        if not Tabs.ActivePage then
            TabBtn.TextColor3 = ThemeColor
            Page.Visible = true
            Tabs.ActivePage = Page
            Tabs.ActiveBtn = TabBtn
        end

        local Elements = {}

        -- Кнопка
        function Elements:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.Font = MainFont
            Btn.TextSize = 15
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page
            Round(Btn, 8)
            Btn.MouseButton1Click:Connect(callback)
        end

        -- Переключатель
        function Elements:AddToggle(text, callback)
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, -10, 0, 45)
            Tgl.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            Tgl.Text = "  " .. text
            Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
            Tgl.Font = MainFont
            Tgl.TextSize = 15
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.Parent = Page
            Round(Tgl, 8)

            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 20, 0, 20)
            box.Position = UDim2.new(1, -30, 0.5, -10)
            box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            box.Parent = Tgl
            Round(box, 4)

            local check = Instance.new("Frame")
            check.Size = UDim2.new(0, 12, 0, 12)
            check.Position = UDim2.new(0.5, -6, 0.5, -6)
            check.BackgroundColor3 = ThemeColor
            check.BackgroundTransparency = 1
            check.Parent = box
            Round(check, 2)

            local active = false
            Tgl.MouseButton1Click:Connect(function()
                active = not active
                TweenService:Create(check, TweenInfo.new(0.2), {BackgroundTransparency = active and 0 or 1}):Play()
                callback(active)
            end)
        end

        -- Слайдер
        function Elements:AddSlider(text, min, max, default, callback)
            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, -10, 0, 60)
            SldFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            SldFrame.Parent = Page
            Round(SldFrame, 8)

            local lbl = Instance.new("TextLabel")
            lbl.Text = "  " .. text
            lbl.Size = UDim2.new(1, 0, 0, 30)
            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.Font = MainFont
            lbl.TextSize = 14
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = SldFrame

            local valLbl = Instance.new("TextLabel")
            valLbl.Text = tostring(default) .. " "
            valLbl.Size = UDim2.new(1, -10, 0, 30)
            valLbl.BackgroundTransparency = 1
            valLbl.TextColor3 = ThemeColor
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent = SldFrame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -30, 0, 6)
            bar.Position = UDim2.new(0, 15, 0, 42)
            bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            bar.Parent = SldFrame
            Round(bar, 3)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = ThemeColor
            fill.Parent = bar
            Round(fill, 3)

            local dragging = false
            local function update()
                local pos = math.clamp((UserInputService:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                valLbl.Text = tostring(val) .. " "
                callback(val)
            end

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end
            end)
        end

        return Elements
    end

    ToggleUI()
    return Tabs
end

return Library
