-- LocalScript
-- Coloque em StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MinhaGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// Botão flutuante para abrir/fechar
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(55, 55)
toggle.Position = UDim2.new(0, 20, 0.5, -27)
toggle.Text = "☰"
toggle.TextSize = 24
toggle.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggle

--// Janela principal
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(600, 380)
main.Position = UDim2.new(0.5, -300, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

--// Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.fromOffset(15, 5)
title.BackgroundTransparency = 1
title.Text = "Minha GUI"
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = main

--// Categorias
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromOffset(140, 315)
sidebar.Position = UDim2.fromOffset(10, 55)
sidebar.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
sidebar.Parent = main

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 10)
sidebarCorner.Parent = sidebar

local categories = {
	"Main",
	"Settings",
	"Scripts"
}

--// Área dos botões
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -165, 1, -65)
content.Position = UDim2.fromOffset(155, 55)
content.BackgroundTransparency = 1
content.Parent = main

local function createCategoryButton(name, order)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 45)
	button.Position = UDim2.fromOffset(5, 5 + (order - 1) * 50)
	button.Text = name
	button.TextSize = 16
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
	button.Parent = sidebar

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button

	return button
end

local function createFunctionButton(text, order)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 50)
	button.Position = UDim2.fromOffset(10, 10 + (order - 1) * 60)
	button.Text = text
	button.TextSize = 17
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
	button.Parent = content

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = button

	return button
end

--// Categorias
local categoryButtons = {}

for i, name in ipairs(categories) do
	categoryButtons[name] = createCategoryButton(name, i)
end

--// Funções de exemplo
local mainButtons = {
	"Função 1",
	"Função 2",
	"Função 3"
}

for i, name in ipairs(mainButtons) do
	local button = createFunctionButton(name, i)

	button.MouseButton1Click:Connect(function()
		print(name .. " foi clicado!")
		
		-- COLOQUE SUA FUNÇÃO AQUI
	end)
end

--// Abrir / fechar GUI
local aberto = true

toggle.MouseButton1Click:Connect(function()
	aberto = not aberto
	main.Visible = aberto
end)
