-- Karpa Blox Fruits PvP (Silent Aim + Skills no Alvo)
-- Executor: Delta, Xeno, Solara, Synapse

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Config = {
    ESP = true,
    AimLock = true,
    SkillAim = true, -- Força skills a irem no alvo
    AimPart = "Head",
    Speed = true,
    SpeedValue = 50,
    Jump = true,
    JumpValue = 100,
    AutoAttack = false,
    AutoAttackDelay = 0.1,
}

-- Limpar UI antiga
if CoreGui:FindFirstChild("KarpaPvP") then
    CoreGui:FindFirstChild("KarpaPvP"):Destroy()
end

-- UI Básica
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KarpaPvP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 200, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -100, 0, 20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 20
ToggleBtn.Text = "Karpa PvP: Menu"
ToggleBtn.BorderSizePixel = 0

local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 250, 0, 400)
MenuFrame.Position = UDim2.new(0.5, -125, 0, 80)
MenuFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MenuFrame.Visible = true
MenuFrame.BorderSizePixel = 0

Instance.new("UICorner", MenuFrame).CornerRadius = UDim.new(0, 8)
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MenuFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MenuFrame
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Text = text
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ESP System
local ESP_List = {}
local function createESP(player)
    if player == LocalPlayer or ESP_List[player] then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "KarpaESP_" .. player.Name
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    ESP_List[player] = highlight
end

local function removeESP(player)
    if ESP_List[player] then
        ESP_List[player]:Destroy()
        ESP_List[player] = nil
    end
end

local function onCharacterAdded(player, character)
    if Config.ESP then createESP(player) end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then onCharacterAdded(player, player.Character) end
    player.CharacterAdded:Connect(function(char) onCharacterAdded(player, char) end)
end
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char) onCharacterAdded(player, char) end)
end)
Players.PlayerRemoving:Connect(removeESP)

-- Alvo Atual (AimLock)
local CurrentTarget = nil

local function getClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    local center = Camera.ViewportSize / 2
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild(Config.AimPart) or player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- Camera e Silent Aim Loop
RunService.RenderStepped:Connect(function()
    if Config.AimLock then
        CurrentTarget = getClosestPlayer()
        if CurrentTarget and CurrentTarget.Character then
            local part = CurrentTarget.Character:FindFirstChild(Config.AimPart) or CurrentTarget.Character.HumanoidRootPart
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
        end
    else
        CurrentTarget = nil
    end

    -- Força o mouse a ficar no alvo para as skills irem nele
    if Config.SkillAim and CurrentTarget and CurrentTarget.Character then
        local part = CurrentTarget.Character:FindFirstChild(Config.AimPart) or CurrentTarget.Character.HumanoidRootPart
        -- O truque está aqui: move o mouse (Hit) para a posição 3D do inimigo
        Mouse.TargetFilter = CurrentTarget.Character
        mousemoverel(0, 0) -- Força atualização do mouse
        -- Se o seu executor suportar, isso engana o jogo
        local pos = Camera:WorldToViewportPoint(part.Position)
        VirtualInputManager:SendMouseMoveEvent(pos.X, pos.Y, game)
    end
end)

-- Auto Attack
local autoAttackConnection
local function toggleAutoAttack()
    Config.AutoAttack = not Config.AutoAttack
    if Config.AutoAttack then
        autoAttackConnection = RunService.Heartbeat:Connect(function()
            if Config.AutoAttack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
                VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
                task.wait(Config.AutoAttackDelay)
                VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
            end
        end)
    else
        if autoAttackConnection then autoAttackConnection:Disconnect() end
    end
end

-- Movimento
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if Config.Speed then hum.WalkSpeed = Config.SpeedValue end
        if Config.Jump then hum.JumpPower = Config.JumpValue end
    end
end)

-- UI Callbacks
createButton("Toggle ESP", function()
    Config.ESP = not Config.ESP
    for _, p in ipairs(Players:GetPlayers()) do
        if Config.ESP then if p.Character then createESP(p) end else removeESP(p) end
    end
end)

createButton("Toggle AimLock", function() Config.AimLock = not Config.AimLock end)
createButton("Toggle Skill Aim (Mira)", function() Config.SkillAim = not Config.SkillAim end)
createButton("Toggle Speed (50)", function() Config.Speed = not Config.Speed end)
createButton("Toggle Jump (100)", function() Config.Jump = not Config.Jump end)
createButton("Toggle Auto Attack", function() toggleAutoAttack() end)

createButton("TP to Closest Player", function()
    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function() MenuFrame.Visible = not MenuFrame.Visible end)
