--// SODA SCRIPTS
--// Interface inspirada na imagem enviada

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SodaScripts"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--// Janela principal
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 760, 0, 620)
main.Position = UDim2.new(0.5, -380, 0.5, -310)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(35, 35, 35)
stroke.Thickness = 2
stroke.Parent = main

--// Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 70)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.BorderSizePixel = 0
title.Text = "Soda Scripts"
title.TextColor3 = Color3.fromRGB(255, 125, 15)
title.TextSize = 27
title.Font = Enum.Font.GothamBold
title.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = title

--// Velocidade
local speedBox = Instance.new("Frame")
speedBox.Size = UDim2.new(1, -36, 0, 82)
speedBox.Position = UDim2.new(0, 18, 0, 90)
speedBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
speedBox.BorderSizePixel = 0
speedBox.Parent = main

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 14)
speedCorner.Parent = speedBox

local speedText = Instance.new("TextLabel")
speedText.Size = UDim2.new(0.55, 0, 1, 0)
speedText.Position = UDim2.new(0, 25, 0, 0)
speedText.BackgroundTransparency = 1
speedText.Text = "Velocity Speed"
speedText.TextColor3 = Color3.fromRGB(230, 230, 230)
speedText.TextSize = 21
speedText.Font = Enum.Font.Gotham
speedText.TextXAlignment = Enum.TextXAlignment.Left
speedText.Parent = speedBox

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 215, 0, 58)
speedInput.Position = UDim2.new(1, -235, 0.5, -29)
speedInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
speedInput.BorderSizePixel = 0
speedInput.Text = "20"
speedInput.TextColor3 = Color3.fromRGB(255, 95, 10)
speedInput.TextSize = 21
speedInput.Font = Enum.Font.GothamBold
speedInput.ClearTextOnFocus = false
speedInput.Parent = speedBox

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = speedInput

--// Modo
local mode = Instance.new("TextLabel")
mode.Size = UDim2.new(1, -36, 0, 80)
mode.Position = UDim2.new(0, 18, 0, 190)
mode.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
mode.BorderSizePixel = 0
mode.Text = "Mode: Kill Players"
mode.TextColor3 = Color3.fromRGB(255, 125, 15)
mode.TextSize = 23
mode.Font = Enum.Font.GothamBold
mode.Parent = main

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 14)
modeCorner.Parent = mode

--// Função para criar opção
local function createToggle(name, x, y)

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0.47, 0, 0, 82)
    box.Position = UDim2.new(x, 0, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    box.BorderSizePixel = 0
    box.Parent = main

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 14)
    boxCorner.Parent = box

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 40, 0, 40)
    button.Position = UDim2.new(0, 18, 0.5, -20)
    button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = box

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(255, 70, 15)
    buttonStroke.Thickness = 2
    buttonStroke.Parent = button

    local check = Instance.new("TextLabel")
    check.Size = UDim2.new(1, 0, 1, 0)
    check.BackgroundTransparency = 1
    check.Text = ""
    check.TextColor3 = Color3.fromRGB(255, 255, 255)
    check.TextSize = 25
    check.Font = Enum.Font.GothamBold
    check.Parent = button

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -75, 1, 0)
    text.Position = UDim2.new(0, 68, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.TextColor3 = Color3.fromRGB(225, 225, 225)
    text.TextSize = 20
    text.Font = Enum.Font.Gotham
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = box

    local enabled = false

    button.MouseButton1Click:Connect(function()

        enabled = not enabled

        if enabled then
            button.BackgroundColor3 = Color3.fromRGB(255, 90, 15)
            check.Text = "✓"
        else
            button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            check.Text = ""
        end

        print(name, enabled)
    end)

    return function()
        return enabled
    end
end

--// Opções
local getAutoFarm = createToggle("Auto Farm", 0.025, 290)
local getNoclip = createToggle("Noclip", 0.515, 290)

local getSafeMode = createToggle("Safe Mode", 0.025, 390)
local getAntiAFK = createToggle("Anti-AFK", 0.515, 390)

--// Arrastar janela
local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--// Alterar velocidade local
speedInput.FocusLost:Connect(function()

    local value = tonumber(speedInput.Text)

    if value then
        value = math.clamp(value, 0, 200)

        speedInput.Text = tostring(value)

        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = value
        end
    else
        speedInput.Text = "20"
    end
end)
