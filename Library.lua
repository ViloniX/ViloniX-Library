local Library = {}

function Library:Init()
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

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
    local MainFont = Enum.Font.Ubuntu

    local function Round(obj, radius)
        local corner = Instance.new("UICorner", obj)
        corner.CornerRadius = UDim.new(0, radius)
    end

    -- [[ ГЛАВНОЕ ОКНО ]] --
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 620, 0, 440)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = BackgroundColor
    Main.Visible = false 
    Round(Main, 14)

    -- Оригинальные линии дизайна
    local function Line(pos, size)
        local l = Instance.new("Frame", Main)
        l.BackgroundColor3 = BorderColor; l.BorderSizePixel = 0; l.Position = pos; l.Size = size
    end
    Line(UDim2.new(0, 0, 0, 60), UDim2.new(1, 0, 0, 2)) 
    Line(UDim2.new(0, 190, 0, 60), UDim2.new(0, 2, 1, -60))
    Line(UDim2.new(0, 0, 1, -110), UDim2.new(0, 190, 0, 2))

    -- Верхняя панель и Логотип
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 60); TopBar.BackgroundTransparency = 1
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "ViloniXHub"; Title.Position = UDim2.new(0, 25, 0, 0); Title.Size = UDim2.new(0, 200, 1, 0)
    Title.TextColor3 = ThemeColor; Title.Font = BoldFont; Title.TextSize = 24; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

    -- Контейнеры
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Position = UDim2.new(0, 15, 0, 75); Sidebar.Size = UDim2.new(0, 160, 0, 240); Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Position = UDim2.new(0, 210, 0, 80); PageContainer.Size = UDim2.new(1, -230, 1, -100); PageContainer.BackgroundTransparency = 1

    -- Профиль игрока
    local Profile = Instance.new("Frame", Main)
    Profile.Size = UDim2.new(0, 180, 0, 100); Profile.Position = UDim2.new(0, 5, 1, -105); Profile.BackgroundTransparency = 1
    local Av = Instance.new("ImageLabel", Profile)
    Av.Size = UDim2.new(0, 55, 0, 55); Av.Position = UDim2.new(0, 12, 0.5, -27)
    Av.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    Round(Av, 28)

    -- [[ АНИМАЦИЯ И КНОПКИ ]] --
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
    MobileBtn.Size = UDim2.new(0, 45, 0, 45); MobileBtn.Position = UDim2.new(0.5, -22, 0, 70)
    MobileBtn.BackgroundColor3 = BackgroundColor; MobileBtn.Text = "V"; MobileBtn.TextColor3 = ThemeColor; MobileBtn.Font = BoldFont; MobileBtn.TextSize = 24
    Round(MobileBtn, 22); MobileBtn.MouseButton1Click:Connect(ToggleUI)

    -- [[ ФУНКЦИИ VISUALS ]] --
    local function CreateESP(p, type)
        if p == LocalPlayer then return end
        local box = Drawing.new("Square"); box.Visible = false; box.Color = ThemeColor; box.Thickness = 1
        local line = Drawing.new("Line"); line.Visible = false; line.Color = ThemeColor; line.Thickness = 1

        RunService.RenderStepped:Connect(function()
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local root = p.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                
                if onScreen then
                    if type == "Tracer" and _G.TracersEnabled then
                        line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(pos.X, pos.Y); line.Visible = true
                    else line.Visible = false end

                    if type == "Corner" and _G.CornersEnabled then
                        local size = 2500/pos.Z
                        box.Size = Vector2.new(size, size); box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2); box.Visible = true
                    else box.Visible = false end
                else line.Visible = false; box.Visible = false end
            else line.Visible = false; box.Visible = false end
            if not _G.TracersEnabled and type == "Tracer" then line.Visible = false end
            if not _G.CornersEnabled and type == "Corner" then box.Visible = false end
        end)
    end

    -- API
    local TabSystem = {}
    function TabSystem:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 42); TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18); TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TabBtn.Font = BoldFont; TabBtn.TextSize = 15
        Round(TabBtn, 10)
        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageContainer:GetChildren()) do p.Visible = false end
            Page.Visible = true
        end)

        return {
            AddToggle = function(_, text, callback)
                local Tgl = Instance.new("TextButton", Page)
                Tgl.Size = UDim2.new(1, 0, 0, 50); Tgl.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Tgl.Text = "  " .. text
                Tgl.Font = MainFont; Tgl.TextSize = 16; Tgl.TextColor3 = Color3.fromRGB(200, 200, 200); Tgl.TextXAlignment = Enum.TextXAlignment.Left
                Round(Tgl, 10)
                Tgl.MouseButton1Click:Connect(function()
                    Tgl.TextColor3 = (Tgl.TextColor3 == ThemeColor) and Color3.new(1,1,1) or ThemeColor
                    callback(Tgl.TextColor3 == ThemeColor)
                end)
            end
        }
    end

    for _, p in pairs(Players:GetPlayers()) do CreateESP(p, "Tracer"); CreateESP(p, "Corner") end
    Players.PlayerAdded:Connect(function(p) CreateESP(p, "Tracer"); CreateESP(p, "Corner") end)

    return TabSystem
end

-- Использование
local Hub = Library:Init()
local Visuals = Hub:CreateTab("Visuals")

Visuals:AddToggle("Lime Hats ESP", function(s) _G.HatsEnabled = s end)
Visuals:AddToggle("Lime Trail ESP", function(s) _G.TrailEnabled = s end)
Visuals:AddToggle("Lime Tracers ESP", function(s) _G.TracersEnabled = s end)
Visuals:AddToggle("Corner ESP", function(s) _G.CornersEnabled = s end)

return Library
