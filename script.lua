-- ==================== SERVIÇOS ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ==================== VARIÁVEIS ====================
local selectedPlayer = nil
local seguindo = false
local conexaoSeguir = nil

-- ==================== GUI ====================
local gui = Instance.new("ScreenGui")
gui.Name = "MinhaGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão flutuante
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(55, 55)
toggle.Position = UDim2.new(0, 20, 0.5, -27)
toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
toggle.Text = "≡"
toggle.TextSize = 24
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.Parent = gui

Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

-- Janela principal
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(340, 420)
main.Position = UDim2.new(0.5, -170, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.Visible = false
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.fromOffset(10, 8)
title.BackgroundTransparency = 1
title.Text = "Minha GUI"
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromOffset(110, 350)
sidebar.Position = UDim2.fromOffset(12, 55)
sidebar.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
sidebar.Parent = main

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

-- Área de conteúdo
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -140, 1, -70)
content.Position = UDim2.fromOffset(130, 55)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0, 0, 0, 500)
content.Parent = main

-- ==================== CATEGORIAS ====================
local categories = {"Main", "Configurações", "Scripts"}
local categoryButtons = {}

local function limparContent()
	for _, filho in pairs(content:GetChildren()) do
		filho:Destroy()
	end
end

local function criarBotaoCategoria(nome, ordem)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 38)
	btn.Position = UDim2.new(0, 8, 0, 10 + (ordem - 1) * 48)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
	btn.Text = nome
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 14
	btn.Font = Enum.Font.Gotham
	btn.Parent = sidebar

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

for i, nome in ipairs(categories) do
	categoryButtons[nome] = criarBotaoCategoria(nome, i)
end

-- ==================== ABA MAIN ====================
local function abrirMain()
	limparContent()

	-- Título da aba
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 30)
	label.Position = UDim2.fromOffset(5, 5)
	label.BackgroundTransparency = 1
	label.Text = "Players no Servidor"
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 16
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = content

	-- Função lista de players
	local function atualizarListaPlayers()
		for _, filho in pairs(content:GetChildren()) do
			if filho:IsA("TextButton") and filho:GetAttribute("IsPlayerButton") then
				filho:Destroy()
			end
		end

		local ordem = 0
		for _, plr in pairs(Players:GetPlayers()) do
			if plr \~= player then
				ordem += 1

				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, -20, 0, 34)
				btn.Position = UDim2.new(0, 10, 0, 40 + (ordem - 1) * 40)
				btn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
				btn.Text = plr.Name
				btn.TextColor3 = Color3.new(1, 1, 1)
				btn.TextSize = 14
				btn.Font = Enum.Font.Gotham
				btn.Parent = content
				btn:SetAttribute("IsPlayerButton", true)

				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

				btn.MouseButton1Click:Connect(function()
					selectedPlayer = plr
					print("Selecionado:", plr.Name)

					for _, b in pairs(content:GetChildren()) do
						if b:IsA("TextButton") and b:GetAttribute("IsPlayerButton") then
							b.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
						end
					end
					btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
				end)
			end
		end
	end

	atualizarListaPlayers()
	Players.PlayerAdded:Connect(atualizarListaPlayers)
	Players.PlayerRemoving:Connect(atualizarListaPlayers)

	-- Botão Seguir
	local followButton = Instance.new("TextButton")
	followButton.Size = UDim2.new(1, -20, 0, 38)
	followButton.Position = UDim2.new(0, 10, 0, 280)
	followButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
	followButton.Text = "Seguir Player"
	followButton.TextColor3 = Color3.new(1, 1, 1)
	followButton.TextSize = 15
	followButton.Font = Enum.Font.GothamBold
	followButton.Parent = content

	Instance.new("UICorner", followButton).CornerRadius = UDim.new(0, 8)

	followButton.MouseButton1Click:Connect(function()
		if not selectedPlayer then
			print("Selecione um player primeiro")
			return
		end

		seguindo = not seguindo

		if seguindo then
			followButton.Text = "Parar de Seguir"
			followButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

			conexaoSeguir = RunService.Heartbeat:Connect(function()
				local meuChar = player.Character
				local alvoChar = selectedPlayer and selectedPlayer.Character

				if meuChar and alvoChar then
					local meuHRP = meuChar:FindFirstChild("HumanoidRootPart")
					local alvoHRP = alvoChar:FindFirstChild("HumanoidRootPart")

					if meuHRP and alvoHRP then
						local distancia = 4
						local direcao = (meuHRP.Position - alvoHRP.Position).Unit
						local posicaoAlvo = alvoHRP.Position + direcao * distancia
						meuHRP.CFrame = meuHRP.CFrame:Lerp(CFrame.new(posicaoAlvo, alvoHRP.Position), 0.18)
					end
				end
			end)
		else
			followButton.Text = "Seguir Player"
			followButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)

			if conexaoSeguir then
				conexaoSeguir:Disconnect()
				conexaoSeguir = nil
			end
		end
	end)

	-- Caixa de Velocidade
	local speedBox = Instance.new("TextBox")
	speedBox.Size = UDim2.new(0.55, 0, 0, 35)
	speedBox.Position = UDim2.new(0, 10, 0, 330)
	speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	speedBox.Text = "16"
	speedBox.PlaceholderText = "Velocidade 0-100"
	speedBox.TextColor3 = Color3.new(1, 1, 1)
	speedBox.TextSize = 14
	speedBox.Font = Enum.Font.Gotham
	speedBox.ClearTextOnFocus = false
	speedBox.Parent = content

	Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

	local applySpeed = Instance.new("TextButton")
	applySpeed.Size = UDim2.new(0.35, 0, 0, 35)
	applySpeed.Position = UDim2.new(0.6, 0, 0, 330)
	applySpeed.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
	applySpeed.Text = "Aplicar"
	applySpeed.TextColor3 = Color3.new(1, 1, 1)
	applySpeed.TextSize = 14
	applySpeed.Font = Enum.Font.GothamBold
	applySpeed.Parent = content

	Instance.new("UICorner", applySpeed).CornerRadius = UDim.new(0, 8)

	applySpeed.MouseButton1Click:Connect(function()
		local valor = tonumber(speedBox.Text)
		if valor and valor >= 0 and valor <= 100 then
			local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = valor
			end
		end
	end)
end

-- ==================== ABA CONFIGURAÇÕES ====================
local function abrirConfig()
	limparContent()

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 30)
	label.Position = UDim2.fromOffset(5, 10)
	label.BackgroundTransparency = 1
	label.Text = "Configurações"
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 16
	label.Font = Enum.Font.GothamBold
	label.Parent = content
end

-- ==================== ABA SCRIPTS ====================
local function abrirScripts()
	limparContent()

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 30)
	label.Position = UDim2.fromOffset(5, 10)
	label.BackgroundTransparency = 1
	label.Text = "Scripts"
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 16
	label.Font = Enum.Font.GothamBold
	label.Parent = content
end

-- Conectar botões das categorias
categoryButtons["Main"].MouseButton1Click:Connect(abrirMain)
categoryButtons["Configurações"].MouseButton1Click:Connect(abrirConfig)
categoryButtons["Scripts"].MouseButton1Click:Connect(abrirScripts)

-- Abrir Main por padrão
abrirMain()

-- ==================== TOGGLE DA GUI ====================
local aberto = false
toggle.MouseButton1Click:Connect(function()
	aberto = not aberto
	main.Visible = aberto
end)

-- Arrastar a GUI
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
