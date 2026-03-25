-- [[ 1. САМА БИБЛИОТЕКА (ВСТРОЕННАЯ) ]] --
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

    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 620, 0, 440)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = BackgroundColor
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = true -- СДЕЛАНО ВИДИМЫМ ПО УМОЛЧАНИЮ
    Round(Main, 14)

    -- Декор (Линии)
    local function Line(pos, size)
        local l = Instance.new("Frame", Main)
        l.BackgroundColor3 = BorderColor
        l.BorderSizePixel = 0
        l.Position = pos
        l.Size = size
    end
    Line(UDim2.new(0, 0, 0, 60), UDim2.new(1, 0, 0, 2)) 
    Line(UDim2.new(0, 190, 0, 60), UDim2.new(0, 2, 1, -60))

    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 60)
    TopBar.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "ViloniXHub"
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.TextColor3 = ThemeColor
    Title.Font = BoldFont
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Position = UDim2.new(0, 15, 0, 75)
    Sidebar.Size = UDim2.new(0, 160, 0, 300) 
    Sidebar.BackgroundTransparency = 1
    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0, 8)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Position = UDim2.new(0, 210, 0, 80)
    PageContainer.Size = UDim2.new(1, -230, 1, -100)
    PageContainer.BackgroundTransparency = 1

    -- [[ ЭЛЕМЕНТЫ УПРАВЛЕНИЯ ]] --

    local function AddToggle(parent, text, callback)
        local Tgl = Instance.new("TextButton", parent)
        Tgl.Size = UDim2.new(1, 0, 0, 45)
        Tgl.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        Tgl.Text = "  " .. text
        Tgl.Font = MainFont
        Tgl.TextSize = 16
        Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
        Tgl.TextXAlignment = Enum.TextXAlignment.Left
        Round(Tgl, 8)

        local box = Instance.new("Frame", Tgl)
        box.Size = UDim2.new(0, 20, 0, 20)
        box.Position = UDim2.new(1, -30, 0.5, -10)
        box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Round(box, 4)

        local check = Instance.new("Frame", box)
        check.Size = UDim2.new(0, 12, 0, 12)
        check.Position = UDim2.new(0.5, -6, 0.5, -6)
        check.BackgroundColor3 = ThemeColor
        check.BackgroundTransparency = 1
        Round(check, 2)

        local active = false
        Tgl.MouseButton1Click:Connect(function()
            active = not active
            TweenService:Create(check, TweenInfo.new(0.2), {BackgroundTransparency = active and 0 or 1}):Play()
            callback(active)
        end)
    end

   al function AddDropdown(parent, text, list, callback)
        local DropFrame = Instance.new("Frame")
        local IsOpen = false
        DropFrame.Size = UDim2.new(1, 0, 0, 45)
        DropFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        DropFrame.ClipsDescendants = true
        DropFrame.Parent = parent
        Round(DropFrame, 10)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundTransparency = 1
        btn.Text = "  " .. text .. " : Select..."
        btn.Font = MainFont
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 15
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = DropFrame

        local container = Instance.new("Frame")
        container.Position = UDim2.new(0, 0, 0, 45)
        container.Size = UDim2.new(1, 0, 0, 0)
        container.BackgroundTransparency = 1
        container.Parent = DropFrame
        local layout = Instance.new("UIListLayout", container)

        btn.MouseButton1Click:Connect(function()
            IsOpen = not IsOpen
            TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = IsOpen and UDim2.new(1, 0, 0, 45 + container.UIListLayout.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 45)}):Play()
        end)

        local function refresh()
            for _, v in pairs(container:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
            for _, name in pairs(list) do
                local item = Instance.new("TextButton")
                item.Size = UDim2.new(1, 0, 0, 30)
                item.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                item.Text = name
                item.Font = MainFont
                item.TextColor3 = Color3.new(1, 1, 1)
                item.TextSize = 14
                item.Parent = container
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

    local TabSystem = {}
    local CurrentPage = nil

    function TabSystem:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = BoldFont
        TabBtn.TextSize = 14
        Round(TabBtn, 8)
        
        TabBtn.MouseButton1Click:Connect(function()
            if CurrentPage then CurrentPage.Visible = false end
            CurrentPage = Page 
            Page.Visible = true
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end
            end
            TabBtn.TextColor3 = ThemeColor
        end)

        if not CurrentPage then
            Page.Visible = true
            CurrentPage = Page
            TabBtn.TextColor3 = ThemeColor
        end

        return {
            AddToggle = function(_, text, callback) AddToggle(Page, text, callback) end,
            AddTextBox = function(_, text, callback) AddTextBox(Page, text, callback) end
        }
    end

    return TabSystem
end

-- [[ 2. ЗАПУСК ХАБА ]] --
local Hub = Library:Init()

local Visuals = Hub:CreateTab("Visuals")
local Target = Hub:CreateTab("Target")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ ЛОГИКА TARGET ]] --
local TargetName = ""
local OrbitConn

Target:AddTextBox("Player Name...", function(text)
    TargetName = text
end)

Target:AddToggle("Attach (Behind)", function(state)
    _G.Attach = state
    if state then
        OrbitConn = RunService.Heartbeat:Connect(function()
            if not _G.Attach then OrbitConn:Disconnect() return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and (p.Name:lower():find(TargetName:lower()) or p.DisplayName:lower():find(TargetName:lower())) then
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end
        end)
    else
        if OrbitConn then OrbitConn:Disconnect() end
    end
end)

-- [[ ЛОГИКА VISUALS (Кратко для примера) ]] --
Visuals:AddToggle("Lime Hats", function(state)
    _G.Hats = state
    -- Твой код Hats тут
end)

Visuals:AddToggle("Corner ESP", function(state)
    _G.Corners = state
    -- Твой код Corners тут
end)
