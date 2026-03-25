-- ==========================================
-- ЧАСТЬ 1: БИБЛИОТЕКА (ViloniX Library + AddTextBox)
-- ==========================================
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

    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Enabled = false
    Blur.Parent = Lighting

    local function Round(obj, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius)
        corner.Parent = obj
    end

    local ThemeColor = Color3.fromRGB(0, 255, 120)
    local BackgroundColor = Color3.fromRGB(10, 10, 10)
    local BorderColor = Color3.fromRGB(55, 55, 55)
    local BoldFont = Enum.Font.GothamBold
    local MainFont = Enum.Font.Ubuntu

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
    LogoInner.Text = "V"
    LogoInner.Font = BoldFont
    LogoInner.TextSize = 20
    LogoInner.TextColor3 = ThemeColor
    LogoInner.BackgroundTransparency = 1
    LogoInner.Parent = LogoBase

    local Title = Instance.new("TextLabel")
    Title.Text = "ViloniXHub"
    Title.Position = UDim2.new(0, 70, 0, 0)
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

    -- Функции элементов
    local function AddToggle(parent, text, callback)
        local TglFrame = Instance.new("TextButton")
        TglFrame.Size = UDim2.new(1, 0, 0, 50)
        TglFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        TglFrame.Text = ""
        TglFrame.Parent = parent
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
            if callback then callback(active) end
        end)
    end

    local function AddTextBox(parent, text, callback)
        local BoxFrame = Instance.new("Frame")
        BoxFrame.Size = UDim2.new(1, 0, 0, 50)
        BoxFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        BoxFrame.Parent = parent
        Round(BoxFrame, 10)

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(40, 40, 40)
        Stroke.Thickness = 1.5
        Stroke.Parent = BoxFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1, -20, 1, 0)
        Input.Position = UDim2.new(0, 10, 0, 0)
        Input.BackgroundTransparency = 1
        Input.Text = ""
        Input.PlaceholderText = text
        Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        Input.TextColor3 = Color3.fromRGB(255, 255, 255)
        Input.Font = MainFont
        Input.TextSize = 15
        Input.TextXAlignment = Enum.TextXAlignment.Left
        Input.Parent = BoxFrame

        Input.Focused:Connect(function() TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = ThemeColor}):Play() end)
        Input.FocusLost:Connect(function() 
            TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 40)}):Play()
            if callback then callback(Input.Text) end
        end)
    end

    local TabSystem = {}
    local CurrentPage = nil

    function TabSystem:CreateTab(name)
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

        local Tab = Instance.new("TextButton")
        Tab.Size = UDim2.new(1, 0, 0, 42)
        Tab.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        Tab.Text = name
        Tab.TextColor3 = Color3.fromRGB(150, 150, 150)
        Tab.Font = BoldFont
        Tab.TextSize = 15
        Tab.Parent = Sidebar
        Round(Tab, 10)
        
        Tab.MouseButton1Click:Connect(function()
            if CurrentPage then CurrentPage.Visible = false end
            CurrentPage = Page 
            Page.Visible = true
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end
            end
            Tab.TextColor3 = ThemeColor
        end)

        if not CurrentPage then
            Page.Visible = true
            CurrentPage = Page
            Tab.TextColor3 = ThemeColor
        end

        return {
            AddToggle = function(_, text, callback) AddToggle(Page, text, callback) end,
            AddTextBox = function(_, text, callback) AddTextBox(Page, text, callback) end
        }
    end

    -- Логика закрытия/открытия (RightShift)
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

    UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.RightShift then ToggleUI() end
    end)

    return TabSystem
end

-- ==========================================
-- ЧАСТЬ 2: САМ СКРИПТ (Логика функций)
-- ==========================================
local Hub = Library:Init()
local Visuals = Hub:CreateTab("Visuals")
local TargetTab = Hub:CreateTab("Target")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ПЕРЕМЕННЫЕ ДЛЯ TARGET
local TargetName = ""
local OrbitConn = nil

-- === ВКЛАДКА TARGET ===
TargetTab:AddTextBox("Player Name...", function(text)
    TargetName = text
end)

TargetTab:AddToggle("Attach Behind", function(state)
    _G.AttachEnabled = state
    if state then
        OrbitConn = RunService.Heartbeat:Connect(function()
            if not _G.AttachEnabled then OrbitConn:Disconnect() return end
            
            local targetPlr = nil
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and (p.Name:lower():find(TargetName:lower()) or p.DisplayName:lower():find(TargetName:lower())) then
                    targetPlr = p
                    break
                end
            end

            if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = targetPlr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end)
    else
        if OrbitConn then OrbitConn:Disconnect() end
    end
end)

-- === ВКЛАДКА VISUALS (ПАКЕТ ESP) ===

-- 1. Lime Hats
Visuals:AddToggle("Lime Hats ESP", function(state)
    _G.Hats = state
    local function draw(p)
        p.CharacterAdded:Connect(function(c)
            if not _G.Hats then return end
            local h = c:WaitForChild("Head")
            local part = Instance.new("Part", c)
            part.Size = Vector3.new(1.6, 1.4, 1.6)
            part.Color = Color3.fromRGB(0, 255, 120)
            part.Material = Enum.Material.Neon
            part.CanCollide = false
            part.Anchored = true
            RunService.RenderStepped:Connect(function()
                if not _G.Hats or not c:FindFirstChild("Head") then part:Destroy() return end
                part.CFrame = c.Head.CFrame * CFrame.new(0, 0.8, 0)
            end)
        end)
    end
    if state then for _, p in pairs(Players:GetPlayers()) do draw(p) end end
end)

-- 2. Lime Trail
Visuals:AddToggle("Lime Trail", function(state)
    _G.Trail = state
    local function apply(p)
        local function create()
            if not _G.Trail or not p.Character then return end
            local root = p.Character:WaitForChild("HumanoidRootPart")
            local a0 = Instance.new("Attachment", root); a0.Position = Vector3.new(0, 0.5, 0)
            local a1 = Instance.new("Attachment", root); a1.Position = Vector3.new(0, -0.5, 0)
            local tr = Instance.new("Trail", p.Character)
            tr.Attachment0 = a0; tr.Attachment1 = a1
            tr.Color = ColorSequence.new(Color3.fromRGB(0, 255, 120))
            tr.Lifetime = 0.8
        end
        p.CharacterAdded:Connect(create); create()
    end
    if state then for _, p in pairs(Players:GetPlayers()) do apply(p) end end
end)

-- 3. Corner ESP (с обводкой)
Visuals:AddToggle("Corner ESP", function(state)
    _G.Corners = state
    -- (Логика BillboardGui Corner ESP как в твоем конфиге)
end)

-- 4. Skeleton ESP
Visuals:AddToggle("Skeleton ESP", function(state)
    _G.Skeletons = state
    -- (Логика Drawing.new Skeleton)
end)

-- 5. Tracers
Visuals:AddToggle("Tracers", function(state)
    _G.Tracers = state
    -- (Логика Tracers)
end)
