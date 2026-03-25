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

    local ThemeColor = Color3.fromRGB(0, 255, 120)
    local BackgroundColor = Color3.fromRGB(10, 10, 10)
    local BorderColor = Color3.fromRGB(55, 55, 55)
    local BoldFont = Enum.Font.GothamBold

    local function Round(obj, radius)
        local corner = Instance.new("UICorner", obj)
        corner.CornerRadius = UDim.new(0, radius)
    end

    -- Main Window
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 620, 0, 440)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = BackgroundColor
    Main.Visible = false 
    Round(Main, 14)

    -- Дизайн (Линии)
    local function Line(pos, size)
        local l = Instance.new("Frame", Main)
        l.BackgroundColor3 = BorderColor; l.BorderSizePixel = 0; l.Position = pos; l.Size = size
    end
    Line(UDim2.new(0, 0, 0, 60), UDim2.new(1, 0, 0, 2)) 
    Line(UDim2.new(0, 190, 0, 60), UDim2.new(0, 2, 1, -60))
    Line(UDim2.new(0, 0, 1, -110), UDim2.new(0, 190, 0, 2))

    local Title = Instance.new("TextLabel", Main)
    Title.Text = "ViloniXHub"; Title.Position = UDim2.new(0, 25, 0, 0); Title.Size = UDim2.new(0, 200, 0, 60)
    Title.TextColor3 = ThemeColor; Title.Font = BoldFont; Title.TextSize = 24; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Position = UDim2.new(0, 15, 0, 75); Sidebar.Size = UDim2.new(0, 160, 0, 240); Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Position = UDim2.new(0, 210, 0, 80); PageContainer.Size = UDim2.new(1, -230, 1, -100); PageContainer.BackgroundTransparency = 1

    -- Анимация
    local function ToggleUI()
        if not Main.Visible then
            Main.Size = UDim2.new(0, 0, 0, 0); Main.Visible = true; Blur.Enabled = true
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 620, 0, 440)}):Play()
            TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 20}):Play()
        else
            local t = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 0)})
            TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
            t:Play(); t.Completed:Connect(function() Main.Visible = false; Blur.Enabled = false end)
        end
    end

    local MobileBtn = Instance.new("TextButton", ScreenGui)
    MobileBtn.Size = UDim2.new(0, 45, 0, 45); MobileBtn.Position = UDim2.new(0.5, -22, 0, 15)
    MobileBtn.BackgroundColor3 = BackgroundColor; MobileBtn.Text = "V"; MobileBtn.TextColor3 = ThemeColor; MobileBtn.Font = BoldFont; MobileBtn.TextSize = 22
    Round(MobileBtn, 22); MobileBtn.MouseButton1Click:Connect(ToggleUI)

    -- API
    local TabSystem = {}
    function TabSystem:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 40); TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18); TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TabBtn.Font = BoldFont; TabBtn.TextSize = 14; Round(TabBtn, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageContainer:GetChildren()) do p.Visible = false end
            Page.Visible = true
        end)

        if not PageContainer:FindFirstChildWhichIsA("ScrollingFrame") then Page.Visible = true end

        return {
            -- ВОТ ТВОИ ОРИГИНАЛЬНЫЕ ТОГЛЫ
            AddToggle = function(_, text, callback)
                local TglBtn = Instance.new("TextButton", Page)
                TglBtn.Size = UDim2.new(1, 0, 0, 50)
                TglBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                TglBtn.Text = "  " .. text
                TglBtn.Font = Enum.Font.Ubuntu
                TglBtn.TextSize = 16
                TglBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                TglBtn.TextXAlignment = Enum.TextXAlignment.Left
                Round(TglBtn, 10)

                local box = Instance.new("Frame", TglBtn)
                box.Size = UDim2.new(0, 22, 0, 22)
                box.Position = UDim2.new(1, -35, 0.5, -11)
                box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Round(box, 6)

                local check = Instance.new("Frame", box)
                check.Size = UDim2.new(0, 12, 0, 12)
                check.Position = UDim2.new(0.5, -6, 0.5, -6)
                check.BackgroundColor3 = ThemeColor
                check.BackgroundTransparency = 1 -- По умолчанию выключен
                Round(check, 3)

                local active = false
                TglBtn.MouseButton1Click:Connect(function()
                    active = not active
                    TweenService:Create(check, TweenInfo.new(0.2), {BackgroundTransparency = active and 0 or 1}):Play()
                    callback(active)
                end)
            end
        }
    end

    UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end end)
    return TabSystem
end

return Library
