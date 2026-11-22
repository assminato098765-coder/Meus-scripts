-- Purple Hub | Blox Fruits PvP
-- Executor: Delta, Xeno, Solara, Synapse

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Config = {
    ESP = true,
    AimLock = true,
    SkillAim = true,
    AimPart = "Head",
    Speed = true,
    SpeedValue = 50,
    Jump = true,
    JumpValue = 100,
    AutoAttack = false,
    AutoAttackDelay = 0.1,
}

if CoreGui:FindFirstChild("PurpleHub") then
    CoreGui:FindFirstChild("PurpleHub"):Destroy()
end

-- Cores do Tema
local Theme = {
    Background = Color3.fromRGB(15, 10, 20),     -- Preto arroxeado
    TopBar = Color3.fromRGB(25, 15, 35),         -- Roxo escuro
    Element = Color3.fromRGB(30, 20, 45),        -- Fundo de botões
    ElementHover = Color3.fromRGB(50, 30, 75),   -- Hover
    Accent = Color3.fromRGB(150, 70, 255),       -- Roxo Vívido (Destaque)
    Text = Color3.fromRGB(240, 240, 240),        -- Branco
    TextDim = Color3.fromRGB(160, 160, 180)      -- Cinza claro
}

-- ==========================================
-- UI CONSTRUCTION
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PurpleHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 140, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -70, 0, 20)
ToggleBtn.BackgroundColor3 = Theme.TopBar
ToggleBtn.TextColor3 = Theme.Text
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Text = "PURPLE HUB"
ToggleBtn.BorderSizePixel = 0
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = Theme.Accent
ToggleStroke.Thickness = 1.5

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.Visible = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Theme.TopBar
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Purple Hub | Blox Fruits"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Dragging Logic
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- TAB SYSTEM
-- ==========================================
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 120, 1, -45)
Sidebar.Position = UDim2.new(0, 10, 0, 40)
Sidebar.BackgroundTransparency = 1

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -140, 1, -45)
ContentArea.Position = UDim2.new(0, 130, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = Sidebar
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)

local ActiveTab = nil
local Tabs = {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = Sidebar
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Theme.Element
    TabBtn.TextColor3 = Theme.TextDim
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 13
    TabBtn.Text = name
    TabBtn.BorderSizePixel = 0
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Parent = ContentArea
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 2
    TabContent.ScrollBarImageColor3 = Theme.Accent
    TabContent.Visible = false
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabContent
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)

    local function SelectTab()
        for _, btn in pairs(Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Theme.Element
                btn.TextColor3 = Theme.TextDim
            end
        end
        for _, content in pairs(ContentArea:GetChildren()) do
            if content:IsA("ScrollingFrame") then
                content.Visible = false
            end
        end
        
        TabBtn.BackgroundColor3 = Theme.Accent
        TabBtn.TextColor3 = Theme.Text
        TabContent.Visible = true
    end

    TabBtn.MouseButton1Click:Connect(SelectTab)
    Tabs[name] = {Button = TabBtn, Content = TabContent, Select = SelectTab}
    
    if not ActiveTab then
        ActiveTab = name
        SelectTab()
    end
end

-- ==========================================
-- ELEMENT BUILDERS
-- ==========================================
local function CreateToggle(parentTab, text, initialStatus, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Tabs[parentTab].Content
    btn.Size = UDim2.new(1, -5, 0, 35)
    btn.BackgroundColor3 = Theme.Element
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = "   " .. text
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local dot = Instance.new("Frame")
    dot.Parent = btn
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(1, -20, 0.5, -5)
    dot.BackgroundColor3 = initialStatus and Theme.Accent or Color3.fromRGB(255, 50, 50)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element}):Play() end)
    
    local active = initialStatus
    btn.MouseButton1Click:Connect(function()
        active = not active
        dot.BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(255, 50, 50)
        callback(active)
    end)
end

local function CreateButton(parentTab, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Tabs[parentTab].Content
    btn.Size = UDim2.new(1, -5, 0, 35)
    btn.BackgroundColor3 = Theme.Element
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Text = text
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element}):Play() end)
    btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- CRIANDO AS ABAS E FUNÇÕES
-- ==========================================
CreateTab("Combat")
CreateTab("Visuals")
CreateTab("Player")

-- Combat Tab
CreateToggle("Combat", "AimLock (Câmera)", Config.AimLock, function(state) Config.AimLock = state end)
CreateToggle("Combat", "Skill Aim (Mira nas Skills)", Config.SkillAim, function(state) Config.SkillAim = state end)
CreateToggle("Combat", "Auto Attack (Clique)", Config.AutoAttack, function(state)
    Config.AutoAttack = state
    if state then
        task.spawn(function()
            while Config.AutoAttack do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
                    VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
                    task.wait(Config.AutoAttackDelay)
                    VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
                else
                    task.wait(0.5)
                end
            end
        end)
    end
end)

-- Visuals Tab
CreateToggle("Visuals", "ESP (Ver Jogadores)", Config.ESP, function(state)
    Config.ESP = state
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if state and not p.Character:FindFirstChild("PurpleESP") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "PurpleESP"
                hl.FillColor = Theme.Accent
                hl.FillTransparency = 0.5
                hl.Adornee = p.Character
            elseif not state and p.Character:FindFirstChild("PurpleESP") then
                p.Character.PurpleESP:Destroy()
            end
        end
    end
end)

-- Player Tab
CreateToggle("Player", "Speed Hack (50)", Config.Speed, function(state) Config.Speed = state end)
CreateToggle("Player", "Jump Power (100)", Config.Jump, function(state) Config.Jump = state end)
CreateButton("Player", "Teleport para o Mais Próximo", function()
    local closest, shortestDist = nil, math.huge
    local center = Camera.ViewportSize / 2
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist < shortestDist then shortestDist, closest = dist, p end
            end
        end
    end
    if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

-- ==========================================
-- BACKGROUND LOOPS
-- ==========================================
local CurrentTarget = nil
RunService.RenderStepped:Connect(function()
    if Config.AimLock then
        CurrentTarget = nil
        local shortestDist, center = math.huge, Camera.ViewportSize / 2
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid").Health > 0 then
                local part = p.Character:FindFirstChild(Config.AimPart) or p.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortestDist then shortestDist, CurrentTarget = dist, p end
                end
            end
        end
        if CurrentTarget and CurrentTarget.Character then
            local part = CurrentTarget.Character:FindFirstChild(Config.AimPart) or CurrentTarget.Character.HumanoidRootPart
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
        end
    end

    if Config.SkillAim and CurrentTarget and CurrentTarget.Character then
        local part = CurrentTarget.Character:FindFirstChild(Config.AimPart) or CurrentTarget.Character.HumanoidRootPart
        Mouse.TargetFilter = CurrentTarget.Character
        mousemoverel(0, 0)
        local pos = Camera:WorldToViewportPoint(part.Position)
        VirtualInputManager:SendMouseMoveEvent(pos.X, pos.Y, game)
    end
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if Config.Speed then hum.WalkSpeed = Config.SpeedValue end
        if Config.Jump then hum.JumpPower = Config.JumpValue end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        if Config.ESP and not char:FindFirstChild("PurpleESP") then
            local hl = Instance.new("Highlight", char)
            hl.Name = "PurpleESP"
            hl.FillColor = Theme.Accent
            hl.FillTransparency = 0.5
            hl.Adornee = char
        end
    end)
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
